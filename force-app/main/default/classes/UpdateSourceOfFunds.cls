public class UpdateSourceOfFunds {

public static final String RES_STATUS = 'status';
    public static final String RES_STATUS_MSG = 'statusMsg';
    public static final String SUCCESS = 'SUCCESS';
    public static final String ERROR = 'ERROR';
    public static final String WARNING = 'WARNING';
    public static final String ERR_SHORT = 'An Error occurred ';


    @AuraEnabled
    public static Map<String, Object> getAsset(String eddId) {
        System.debug('eddId : '+eddId);
        Map<String, Object> resMap = new Map<String, Object>{RES_STATUS => SUCCESS};
        try{
            if(eddId == null){
                List<AssetWrapper> assets = (List<AssetWrapper>) JSON.deserialize(
                '[{"id":"1","name":"Account funded from a bank account held outside the UK or EU","change":"","comments":"","pickListOptions":[{"label":"yes","value":"yes"},{"label":"no","value":"no"}]},{"id":"2","name":"Account funded from a bank account held with Masraf Al Rayan","change":"","comments":"","pickListOptions":[{"label":"yes","value":"yes"},{"label":"no","value":"no"}]},{"id":"3","name":"Account funded from a bank account in the UK","change":"","comments":"","pickListOptions":[{"label":"yes","value":"yes"},{"label":"no","value":"no"}]},{"id":"4","name":"Account funded from a bank account in the UK or EU","change":"","comments":"","pickListOptions":[{"label":"yes","value":"yes"},{"label":"no","value":"no"}]},{"id":"5","name":"Account funded from a High-Risk Country","change":"","comments":"","pickListOptions":[{"label":"yes","value":"yes"},{"label":"no","value":"no"}]},{"id":"6","name":"Account funded from a Low or Medium-Risk Country outside the UK","change":"","comments":"","pickListOptions":[{"label":"yes","value":"yes"},{"label":"no","value":"no"}]},{"id":"7","name":"Account funded from an Extreme Risk Country","change":"","comments":"","pickListOptions":[{"label":"yes","value":"yes"},{"label":"no","value":"no"}]},{"id":"8","name":"Account funded from a Payment Service Provider (PSP) account in the UK or EU","change":"","comments":"","pickListOptions":[{"label":"yes","value":"yes"},{"label":"no","value":"no"}]},{"id":"9","name":"Account funded from a Payment Service Provider (PSP) account outside the UK or EU","change":"","comments":"","pickListOptions":[{"label":"yes","value":"yes"},{"label":"no","value":"no"}]},{"id":"10","name":"Bonus","change":"","comments":"","pickListOptions":[{"label":"yes","value":"yes"},{"label":"no","value":"no"}]},{"id":"11","name":"Cash Deposit","change":"","comments":"","pickListOptions":[{"label":"yes","value":"yes"},{"label":"no","value":"no"}]},{"id":"12","name":"Cash Deposits","change":"","comments":"","pickListOptions":[{"label":"yes","value":"yes"},{"label":"no","value":"no"}]},{"id":"13","name":"Donations","change":"","comments":"","pickListOptions":[{"label":"yes","value":"yes"},{"label":"no","value":"no"}]},{"id":"14","name":"Gift","change":"","comments":"","pickListOptions":[{"label":"yes","value":"yes"},{"label":"no","value":"no"}]},{"id":"15","name":"Inheritance","change":"","comments":"","pickListOptions":[{"label":"yes","value":"yes"},{"label":"no","value":"no"}]},{"id":"16","name":"Investment","change":"","comments":"","pickListOptions":[{"label":"yes","value":"yes"},{"label":"no","value":"no"}]},{"id":"17","name":"Nil","change":"","comments":"","pickListOptions":[{"label":"yes","value":"yes"},{"label":"no","value":"no"}]},{"id":"18","name":"Proceeds of Sale","change":"","comments":"","pickListOptions":[{"label":"yes","value":"yes"},{"label":"no","value":"no"}]},{"id":"19","name":"Salary","change":"","comments":"","pickListOptions":[{"label":"yes","value":"yes"},{"label":"no","value":"no"}]},{"id":"20","name":"Sale of assets","change":"","comments":"","pickListOptions":[{"label":"yes","value":"yes"},{"label":"no","value":"no"}]},{"id":"21","name":"Savings","change":"","comments":"","pickListOptions":[{"label":"yes","value":"yes"},{"label":"no","value":"no"}]},{"id":"22","name":"Source of Funds connected to Sanctions in anyway","change":"","comments":"","pickListOptions":[{"label":"yes","value":"yes"},{"label":"no","value":"no"}]},{"id":"23","name":"Source of funds linked to dominant risk country","change":"","comments":"","pickListOptions":[{"label":"yes","value":"yes"},{"label":"no","value":"no"}]},{"id":"24","name":"Source of inward payment linked to sanction concerns of an individual, entity or vessel with CRO review","change":"","comments":"","pickListOptions":[{"label":"yes","value":"yes"},{"label":"no","value":"no"}]},{"id":"25","name":"Stocks and Shares","change":"","comments":"","pickListOptions":[{"label":"yes","value":"yes"},{"label":"no","value":"no"}]},{"id":"26","name":"TREASURY ONLY – Financial Institution Funding","change":"","comments":"","pickListOptions":[{"label":"yes","value":"yes"},{"label":"no","value":"no"}]}]',
                List<AssetWrapper>.class);
                resMap.put('assetSOWF',assets);
                
            }else{
                list<Source_of_Wealth_Funds__c> lstSOWF = [ Select id,Case__c, EDD__c, Amount__c, Change_since_last_review__c, 
                                                Comments__c, Name,Source__c from Source_of_Wealth_Funds__c 
                                                where EDD__c=: eddId ];
                if(!lstSOWF.isEmpty()){
                    list<AssetWrapper> lstAssts = new list<AssetWrapper>();
                    for(Source_of_Wealth_Funds__c each: lstSOWF){
                        
                        lstAssts.add(new AssetWrapper(each));
                        
                    }
                    resMap.put('assetSOWF',lstAssts);
                }else{
                    List<AssetWrapper> assets = (List<AssetWrapper>) JSON.deserialize(
                '[{"id":"1","name":"Account funded from a bank account held outside the UK or EU","change":"","comments":"","pickListOptions":[{"label":"yes","value":"yes"},{"label":"no","value":"no"}]},{"id":"2","name":"Account funded from a bank account held with Masraf Al Rayan","change":"","comments":"","pickListOptions":[{"label":"yes","value":"yes"},{"label":"no","value":"no"}]},{"id":"3","name":"Account funded from a bank account in the UK","change":"","comments":"","pickListOptions":[{"label":"yes","value":"yes"},{"label":"no","value":"no"}]},{"id":"4","name":"Account funded from a bank account in the UK or EU","change":"","comments":"","pickListOptions":[{"label":"yes","value":"yes"},{"label":"no","value":"no"}]},{"id":"5","name":"Account funded from a High-Risk Country","change":"","comments":"","pickListOptions":[{"label":"yes","value":"yes"},{"label":"no","value":"no"}]},{"id":"6","name":"Account funded from a Low or Medium-Risk Country outside the UK","change":"","comments":"","pickListOptions":[{"label":"yes","value":"yes"},{"label":"no","value":"no"}]},{"id":"7","name":"Account funded from an Extreme Risk Country","change":"","comments":"","pickListOptions":[{"label":"yes","value":"yes"},{"label":"no","value":"no"}]},{"id":"8","name":"Account funded from a Payment Service Provider (PSP) account in the UK or EU","change":"","comments":"","pickListOptions":[{"label":"yes","value":"yes"},{"label":"no","value":"no"}]},{"id":"9","name":"Account funded from a Payment Service Provider (PSP) account outside the UK or EU","change":"","comments":"","pickListOptions":[{"label":"yes","value":"yes"},{"label":"no","value":"no"}]},{"id":"10","name":"Bonus","change":"","comments":"","pickListOptions":[{"label":"yes","value":"yes"},{"label":"no","value":"no"}]},{"id":"11","name":"Cash Deposit","change":"","comments":"","pickListOptions":[{"label":"yes","value":"yes"},{"label":"no","value":"no"}]},{"id":"12","name":"Cash Deposits","change":"","comments":"","pickListOptions":[{"label":"yes","value":"yes"},{"label":"no","value":"no"}]},{"id":"13","name":"Donations","change":"","comments":"","pickListOptions":[{"label":"yes","value":"yes"},{"label":"no","value":"no"}]},{"id":"14","name":"Gift","change":"","comments":"","pickListOptions":[{"label":"yes","value":"yes"},{"label":"no","value":"no"}]},{"id":"15","name":"Inheritance","change":"","comments":"","pickListOptions":[{"label":"yes","value":"yes"},{"label":"no","value":"no"}]},{"id":"16","name":"Investment","change":"","comments":"","pickListOptions":[{"label":"yes","value":"yes"},{"label":"no","value":"no"}]},{"id":"17","name":"Nil","change":"","comments":"","pickListOptions":[{"label":"yes","value":"yes"},{"label":"no","value":"no"}]},{"id":"18","name":"Proceeds of Sale","change":"","comments":"","pickListOptions":[{"label":"yes","value":"yes"},{"label":"no","value":"no"}]},{"id":"19","name":"Salary","change":"","comments":"","pickListOptions":[{"label":"yes","value":"yes"},{"label":"no","value":"no"}]},{"id":"20","name":"Sale of assets","change":"","comments":"","pickListOptions":[{"label":"yes","value":"yes"},{"label":"no","value":"no"}]},{"id":"21","name":"Savings","change":"","comments":"","pickListOptions":[{"label":"yes","value":"yes"},{"label":"no","value":"no"}]},{"id":"22","name":"Source of Funds connected to Sanctions in anyway","change":"","comments":"","pickListOptions":[{"label":"yes","value":"yes"},{"label":"no","value":"no"}]},{"id":"23","name":"Source of funds linked to dominant risk country","change":"","comments":"","pickListOptions":[{"label":"yes","value":"yes"},{"label":"no","value":"no"}]},{"id":"24","name":"Source of inward payment linked to sanction concerns of an individual, entity or vessel with CRO review","change":"","comments":"","pickListOptions":[{"label":"yes","value":"yes"},{"label":"no","value":"no"}]},{"id":"25","name":"Stocks and Shares","change":"","comments":"","pickListOptions":[{"label":"yes","value":"yes"},{"label":"no","value":"no"}]},{"id":"26","name":"TREASURY ONLY – Financial Institution Funding","change":"","comments":"","pickListOptions":[{"label":"yes","value":"yes"},{"label":"no","value":"no"}]}]',
                List<AssetWrapper>.class);
                resMap.put('assetSOWF',assets);
                } 
            }
            
        }catch(Exception e){
            String errMsg = ERR_SHORT + 'getAsset . '+e;
            resMap.put(RES_STATUS, ERROR);
            resMap.put(RES_STATUS_MSG, errMsg);
        }
        return resMap;
    }
     @AuraEnabled
    public static Map<String, Object> saveAsset(String assetData) {
        Map<String, Object> resMap = new Map<String, Object>{RES_STATUS => SUCCESS};
            System.debug('assetData : '+assetData);
            list<AssetWrapper> lstAsset = (list<AssetWrapper>) System.JSON.deserialize(assetData, list<AssetWrapper>.class);
            System.debug('lstAsset : '+lstAsset);
             resMap.put('assetSOWF',saveAsset(lstAsset));
        try{
           


        }catch(Exception e){
            String errMsg = ERR_SHORT + 'saveAsset . '+e;
            resMap.put(RES_STATUS, ERROR);
            resMap.put(RES_STATUS_MSG, errMsg);
        }
        return resMap;
    }

    public static list<AssetWrapper> saveAsset(list<AssetWrapper> lstAsset){
        list<Source_of_Wealth_Funds__c> lstSOWFs= new list<Source_of_Wealth_Funds__c>();
        for(AssetWrapper each: lstAsset ){
            Source_of_Wealth_Funds__c objSOWF = new Source_of_Wealth_Funds__c();
            if(each.id != '' && each.id != null){
                 objSOWF.id = each.id;
            }
            
             if(each.change == '' || each.change == null){
                each.change = 'No';
            }
            objSOWF.Change_since_last_review__c = each.change;
            objSOWF.Comments__c = each.comments;
            objSOWF.Name =  each.name;
            // objSOWF.Type_Of_Source__c = each.typeOfSource;
            objSOWF.Source__c = each.source;
            objSOWF.EDD__c = each.eddId;
            lstSOWFs.add(objSOWF);
        }
        system.debug('lstSOWFs : '+lstSOWFs);
        upsert lstSOWFs;
        list<AssetWrapper> lstAssts = new list<AssetWrapper>();
        for(Source_of_Wealth_Funds__c each: lstSOWFs){
            lstAssts.add(new AssetWrapper(each));
        }

        return lstAssts;
    }


    public class AssetWrapper {
        @AuraEnabled public String id;
        @AuraEnabled public String name;
        @AuraEnabled public String change;
        @AuraEnabled public String comments;
        @AuraEnabled public String eddId;
        @AuraEnabled public String caseId;
        @AuraEnabled public String source;
        @AuraEnabled public List<PickListOption> pickListOptions = new List<PickListOption>() ;

        public AssetWrapper(Source_of_Wealth_Funds__c sowf) {
            this.id = sowf.id;
            this.name = sowf.name;
            this.change = sowf.Change_since_last_review__c;
            this.comments = sowf.Comments__c;
            this.eddId = sowf.EDD__c;
            this.source = sowf.Source__c;
            //this.caseId = sowf.Case__c;
             
            this.pickListOptions.add(new PickListOption('Yes','Yes'));
            this.pickListOptions.add(new PickListOption('No','No'));
        }
        
    }

    public class PickListOption {
        @AuraEnabled public String label;
        @AuraEnabled public String value;
        
        public PickListOption(String label, String value) {
            this.label = label;
            this.value = value;
        }
    }

}