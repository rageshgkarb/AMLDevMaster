public class invokeRelatedEntityAMLAPIFuture {
    
    @future(callout=true)
    public static void executeFuture(String relatedAccountString, String opportunityId,String webLogId){
        System.debug('inside execute');
        
        Map < Id, Related_Customer_Entity__c > relatedAccountMap = (Map< Id, Related_Customer_Entity__c >)JSON.deserialize(relatedAccountString,Map< Id, Related_Customer_Entity__c >.class);
        
        IBBEvents.CompleteEventArgs args = new IBBEvents.CompleteEventArgs();
        args = ARBCustomerAMLAPIUtils.invokeRelatedEntityAMLAPI ( relatedAccountMap, opportunityId);
		Web_Integration_Log__c webLog = [Select Id,Response_Body__c from Web_Integration_Log__c where Id =:webLogId ];
        webLog.Response_Body__c = JSON.serialize(args);
        System.debug('weblogId::'+webLog);

        update webLog;
  }

}