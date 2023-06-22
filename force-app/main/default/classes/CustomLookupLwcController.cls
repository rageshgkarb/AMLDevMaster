public class CustomLookupLwcController {
   // Method to fetch lookup search result   


    @AuraEnabled
    public static Map<String, Object> fetchLookupRecs(string searchKey , string sObjectApiName) {
        Map<String, Object> resMap = new Map<String, Object>{'status' => 'SUCCESS'};
        try{
           List < lookupWrapper > returnList = new List < lookupWrapper > ();

            string sWildCardText = '%' + searchKey + '%';
            string sQuery = 'Select Id,Name From ' + sObjectApiName + ' Where Name Like : sWildCardText order by Name LIMIT 5';
            if(sObjectApiName == 'Case'){
                sQuery = 'Select Id,CaseNumber From ' + sObjectApiName + ' Where CaseNumber Like : sWildCardText order by CaseNumber DESC LIMIT 5';
            }
            if(sObjectApiName == 'Account'){
                sQuery = 'Select Id,Name,EBS_ID__c From ' + sObjectApiName + ' Where Name Like : sWildCardText AND EBS_ID__c != null order by Name LIMIT 5';
            }
            for (sObject obj: database.query(sQuery)) {
                if(sObjectApiName == 'Case'){
                    lookupWrapper objlookupWrapper = new lookupWrapper(String.valueOf(obj.get('CaseNumber')),String.valueOf(obj.get('Id')));
                    returnList.add(objlookupWrapper);
                }else if(sObjectApiName == 'Account'){
                    lookupWrapper objlookupWrapper = new lookupWrapper(String.valueOf(obj.get('Name')),String.valueOf(obj.get('Id')),String.valueOf(obj.get('EBS_ID__c')));
                    returnList.add(objlookupWrapper);
                }else{
                    lookupWrapper objlookupWrapper = new lookupWrapper(String.valueOf(obj.get('Name')),String.valueOf(obj.get('Id')));
                    returnList.add(objlookupWrapper);
                }
            }

            resMap.put('data',returnList);
        }catch(Exception e){
            
        }
        return resMap;
        
    }

    public class lookupWrapper{
        @AuraEnabled public String Name {get;set;}
        @AuraEnabled public String Id {get;set;}
        
        @AuraEnabled public String EBSId {get;set;}

        public lookupWrapper(String Name,String Id){
            this.Name = Name;
            this.Id = Id;
        }

        public lookupWrapper(String Name,String Id, String EBSId){
            this.Name = Name;
            this.Id = Id;
            this.EBSId = EBSId;
        }
    }
    
    
}