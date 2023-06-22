public class UpdateSourceOfWealth {
    public static final String RES_STATUS = 'status';
    public static final String RES_STATUS_MSG = 'statusMsg';
    public static final String SUCCESS = 'SUCCESS';
    public static final String ERROR = 'ERROR';
    public static final String WARNING = 'WARNING';
    public static final String ERR_SHORT = 'An Error occurred ';


    @AuraEnabled
    public static Map<String, Object> getAsset(String eddId, String type, String referenceId) {
        System.debug('eddId : '+eddId);
        Map<String, Object> resMap = new Map<String, Object>{RES_STATUS => SUCCESS};
        try{
            if(eddId == null){
                if(type == 'Assets'){
                    List<AssetWrapper> assets = (List<AssetWrapper>) JSON.deserialize(
                    '[{"name":"Business Property","value":"","change":"","comments":"","pickListOptions":[{"label":"Yes","value":"Yes"},{"label":"No","value":"No"}]},{"name":"Own Home","value":"","change":"","comments":"","pickListOptions":[{"label":"Yes","value":"Yes"},{"label":"No","value":"No"}]},{"name":"Other Property","value":"","change":"","comments":"","pickListOptions":[{"label":"Yes","value":"Yes"},{"label":"No","value":"No"}]},{"name":"Cash / Savings","value":"","change":"","comments":"","pickListOptions":[{"label":"Yes","value":"Yes"},{"label":"No","value":"No"}]},{"name":"Stocks & Shares","value":"","change":"","comments":"","pickListOptions":[{"label":"Yes","value":"Yes"},{"label":"No","value":"No"}]},{"name":"Life Policy Values (surrender value only)","value":"","change":"","comments":"","pickListOptions":[{"label":"Yes","value":"Yes"},{"label":"No","value":"No"}]},{"name":"Personal Effects","value":"","change":"","comments":"","pickListOptions":[{"label":"Yes","value":"Yes"},{"label":"No","value":"No"}]},{"name":"Cars","value":"","change":"","comments":"","pickListOptions":[{"label":"Yes","value":"Yes"},{"label":"No","value":"No"}]},{"name":"Other","value":"","change":"","comments":"","pickListOptions":[{"label":"Yes","value":"Yes"},{"label":"No","value":"No"}]}]',
                        List<AssetWrapper>.class);
                    resMap.put('assetSOWF',assets);
                }
                if(type == 'Liabilities'){
                     List<AssetWrapper> liabs = (List<AssetWrapper>) JSON.deserialize(
                    '[{"name":"Business Finance","value":"","change":"","comments":"","pickListOptions":[{"label":"yes","value":"yes"},{"label":"no","value":"no"}],"source":"Source Of Wealth","typeOfSource":"Liabilities"},{"name":"Mortgage","value":"","change":"","comments":"","pickListOptions":[{"label":"yes","value":"yes"},{"label":"no","value":"no"}],"source":"Source Of Wealth","typeOfSource":"Liabilities"},{"name":"Other Mortgage","value":"","change":"","comments":"","pickListOptions":[{"label":"yes","value":"yes"},{"label":"no","value":"no"}],"source":"Source Of Wealth","typeOfSource":"Liabilities"},{"name":"Bank Finance","value":"","change":"","comments":"","pickListOptions":[{"label":"yes","value":"yes"},{"label":"no","value":"no"}],"source":"Source Of Wealth","typeOfSource":"Liabilities"},{"name":"Other Finance","value":"","change":"","comments":"","pickListOptions":[{"label":"yes","value":"yes"},{"label":"no","value":"no"}],"source":"Source Of Wealth","typeOfSource":"Liabilities"},{"name":"Overdraft","value":"","change":"","comments":"","pickListOptions":[{"label":"yes","value":"yes"},{"label":"no","value":"no"}],"source":"Source Of Wealth","typeOfSource":"Liabilities"},{"name":"Hire Purchase","value":"","change":"","comments":"","pickListOptions":[{"label":"yes","value":"yes"},{"label":"no","value":"no"}],"source":"Source Of Wealth","typeOfSource":"Liabilities"},{"name":"Credit Cards","value":"","change":"","comments":"","pickListOptions":[{"label":"yes","value":"yes"},{"label":"no","value":"no"}],"source":"Source Of Wealth","typeOfSource":"Liabilities"},{"name":"Guarantees","value":"","change":"","comments":"","pickListOptions":[{"label":"yes","value":"yes"},{"label":"no","value":"no"}],"source":"Source Of Wealth","typeOfSource":"Liabilities"},{"name":"Others","value":"","change":"","comments":"","pickListOptions":[{"label":"yes","value":"yes"},{"label":"no","value":"no"}],"source":"Source Of Wealth","typeOfSource":"Liabilities"}]',
                    List<AssetWrapper>.class);
                    resMap.put('assetSOWF',liabs);
                }
            }else{
                list<Source_of_Wealth_Funds__c> lstSOWF = [ Select id,Case__c, EDD__c, Amount__c, Change_since_last_review__c, 
                                                Comments__c, Type_Of_Source__c,Name,Source__c,Reference__c
                                                from Source_of_Wealth_Funds__c 
                                                where EDD__c=: eddId and Reference__c=:referenceId and Type_Of_Source__c =: type];
                if(!lstSOWF.isEmpty()){
                    list<AssetWrapper> lstAssts = new list<AssetWrapper>();
                    for(Source_of_Wealth_Funds__c each: lstSOWF){
                        
                        lstAssts.add(new AssetWrapper(each));
                        
                    }
                    resMap.put('assetSOWF',lstAssts);
                }else{
                    if(type == 'Assets'){
                        List<AssetWrapper> assets = (List<AssetWrapper>) JSON.deserialize(
                        '[{"name":"Business Property","value":"","change":"","comments":"","pickListOptions":[{"label":"Yes","value":"Yes"},{"label":"No","value":"No"}]},{"name":"Own Home","value":"","change":"","comments":"","pickListOptions":[{"label":"Yes","value":"Yes"},{"label":"No","value":"No"}]},{"name":"Other Property","value":"","change":"","comments":"","pickListOptions":[{"label":"Yes","value":"Yes"},{"label":"No","value":"No"}]},{"name":"Cash / Savings","value":"","change":"","comments":"","pickListOptions":[{"label":"Yes","value":"Yes"},{"label":"No","value":"No"}]},{"name":"Stocks & Shares","value":"","change":"","comments":"","pickListOptions":[{"label":"Yes","value":"Yes"},{"label":"No","value":"No"}]},{"name":"Life Policy Values (surrender value only)","value":"","change":"","comments":"","pickListOptions":[{"label":"Yes","value":"Yes"},{"label":"No","value":"No"}]},{"name":"Personal Effects","value":"","change":"","comments":"","pickListOptions":[{"label":"Yes","value":"Yes"},{"label":"No","value":"No"}]},{"name":"Cars","value":"","change":"","comments":"","pickListOptions":[{"label":"Yes","value":"Yes"},{"label":"No","value":"No"}]},{"name":"Other","value":"","change":"","comments":"","pickListOptions":[{"label":"Yes","value":"Yes"},{"label":"No","value":"No"}]}]',
                            List<AssetWrapper>.class);
                        resMap.put('assetSOWF',assets);
                    }
                    if(type == 'Liabilities'){
                        List<AssetWrapper> liabs = (List<AssetWrapper>) JSON.deserialize(
                        '[{"name":"Business Finance","value":"","change":"","comments":"","pickListOptions":[{"label":"yes","value":"yes"},{"label":"no","value":"no"}],"source":"Source Of Wealth","typeOfSource":"Liabilities"},{"name":"Mortgage","value":"","change":"","comments":"","pickListOptions":[{"label":"yes","value":"yes"},{"label":"no","value":"no"}],"source":"Source Of Wealth","typeOfSource":"Liabilities"},{"name":"Other Mortgage","value":"","change":"","comments":"","pickListOptions":[{"label":"yes","value":"yes"},{"label":"no","value":"no"}],"source":"Source Of Wealth","typeOfSource":"Liabilities"},{"name":"Bank Finance","value":"","change":"","comments":"","pickListOptions":[{"label":"yes","value":"yes"},{"label":"no","value":"no"}],"source":"Source Of Wealth","typeOfSource":"Liabilities"},{"name":"Other Finance","value":"","change":"","comments":"","pickListOptions":[{"label":"yes","value":"yes"},{"label":"no","value":"no"}],"source":"Source Of Wealth","typeOfSource":"Liabilities"},{"name":"Overdraft","value":"","change":"","comments":"","pickListOptions":[{"label":"yes","value":"yes"},{"label":"no","value":"no"}],"source":"Source Of Wealth","typeOfSource":"Liabilities"},{"name":"Hire Purchase","value":"","change":"","comments":"","pickListOptions":[{"label":"yes","value":"yes"},{"label":"no","value":"no"}],"source":"Source Of Wealth","typeOfSource":"Liabilities"},{"name":"Credit Cards","value":"","change":"","comments":"","pickListOptions":[{"label":"yes","value":"yes"},{"label":"no","value":"no"}],"source":"Source Of Wealth","typeOfSource":"Liabilities"},{"name":"Guarantees","value":"","change":"","comments":"","pickListOptions":[{"label":"yes","value":"yes"},{"label":"no","value":"no"}],"source":"Source Of Wealth","typeOfSource":"Liabilities"},{"name":"Others","value":"","change":"","comments":"","pickListOptions":[{"label":"yes","value":"yes"},{"label":"no","value":"no"}],"source":"Source Of Wealth","typeOfSource":"Liabilities"}]',
                        List<AssetWrapper>.class);
                        resMap.put('assetSOWF',liabs);
                    }
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
            
            if(each.value == '' || each.value == null){
                each.value = '0';
            }
            objSOWF.Amount__c = Decimal.valueOf(each.value);
             if(each.change == '' || each.change == null){
                each.change = 'No';
            }
            objSOWF.Change_since_last_review__c = each.change;
            objSOWF.Comments__c = each.comments;
            objSOWF.Name =  each.name;
            objSOWF.Type_Of_Source__c = each.typeOfSource;
            objSOWF.Source__c = each.source;
            objSOWF.EDD__c = each.eddId;
            objSOWF.Reference__c = each.referenceId;
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

    @AuraEnabled
    public static void deleteAsset(String referenceId,String eddId){
        System.debug('referenceId '+referenceId);
        System.debug('eddId '+eddId);


            List<Source_of_Wealth_Funds__c> objSOWF = [SELECT Id, Name from Source_of_Wealth_Funds__c
            where Reference__c=:referenceId and EDD__c=:eddId];

        system.debug('DelSOWFs : '+objSOWF);
        delete objSOWF;
    }


    public class AssetWrapper {
        @AuraEnabled public String id;
        @AuraEnabled public String name;
        @AuraEnabled public String value;
        @AuraEnabled public String change;
        @AuraEnabled public String comments;
        @AuraEnabled public String eddId;
        @AuraEnabled public String referenceId;
        @AuraEnabled public String caseId;
        @AuraEnabled public String source;
        @AuraEnabled public String typeOfSource;
        @AuraEnabled public List<PickListOption> pickListOptions = new List<PickListOption>() ;

        public AssetWrapper(Source_of_Wealth_Funds__c sowf) {
            this.id = sowf.id;
            this.name = sowf.name;
            this.value = String.valueOf(sowf.Amount__c);
            this.change = sowf.Change_since_last_review__c;
            this.comments = sowf.Comments__c;
            this.eddId = sowf.EDD__c;
            this.referenceId = sowf.Reference__c;
            this.source = sowf.Source__c;
            this.typeOfSource = sowf.Type_Of_Source__c;
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