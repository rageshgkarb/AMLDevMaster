public class DeleteWebServiceLogs {

    // Set the number of days for which web service logs should be deleted
    private static final Integer DAYS_TO_KEEP = 730;
    
    public static void deleteLogs() {
        
        // Get the current date
        Date currentDate = Date.today();
        
        // Calculate the date before which logs should be deleted
        Date cutoffDate = currentDate.addDays(-DAYS_TO_KEEP);
        
        // Delete the web service logs
        List<Web_Service_Log__c> logsToDelete = [SELECT Id FROM Web_Service_Log__c WHERE MessageId__c != null AND 
                                      SystemModstamp < :cutoffDate];
        
        if (logsToDelete.size() > 0) {
            for (Web_Service_Log__c log : logsToDelete) {
                System.debug(log);
            }
        }
        
    }
}