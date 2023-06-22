global class DeleteAllAudits_BatchJob implements Database.Batchable<sObject> {
    global Database.QueryLocator start(Database.BatchableContext bc) {
         String query = 'SELECT Id FROM ContentDocument';
        return Database.getQueryLocator(query);
    }
    global void execute(Database.BatchableContext BC, List<ContentDocument> AuditList) {
        
        try {
            // delete the Audit__c Records
            delete AuditList;
         
        } catch(Exception e) {
            System.debug(e);
        }
         
    }      
    global void finish(Database.BatchableContext bc){
        // execute any post-processing operations
    }    
}