public class invokeRelatedEntityAMLAPIQueueable implements Queueable, Database.AllowsCallouts{
    
    
	public Map<String,String> requestBodyMap;
    public String apiName;
    
    public invokeRelatedEntityAMLAPIQueueable( Map<String,String> requestBodyMap,String apiName){
        System.debug('inside queuable');
        this.requestBodyMap = requestBodyMap;
        this.apiName=apiName;
        System.debug('inside queuable 13');

    }
    
    public void execute(QueueableContext context){
        System.debug('inside execute');
        IBBEvents.CompleteEventArgs args = new IBBEvents.CompleteEventArgs();
        List<Web_Integration_Log__c> webLogList = new List<Web_Integration_Log__c>();
        for(String reqBodyKey: requestBodyMap.keySet()){
			String apiResponse = ARBAPIUtils.fetchAPIResponse ( requestBodyMap.get(reqBodyKey),apiName);
			Web_Integration_Log__c webLog = new Web_Integration_Log__c();
            webLog.Message_Id__c= reqBodyKey;
            webLog.Request_Body__c=requestBodyMap.get(reqBodyKey);
            webLog.Response_Body__c=apiResponse;
            webLogList.add(webLog);      
        }
        insert webLogList;
  	}
    
    

    /*public Map < Id, Related_Customer_Entity__c > relatedAccountMap;
    public String opportunityId;
    public String webLogId;
    
    public invokeRelatedEntityAMLAPIQueueable(Map < Id, Related_Customer_Entity__c > relatedAccountMap, String opportunityId,String webLogId){
        System.debug('inside queuable');
        this.relatedAccountMap = relatedAccountMap;
        this.opportunityId=opportunityId;
        this.webLogId= webLogId;
        System.debug('inside queuable 13');

    }
    
    public void execute(QueueableContext context){
        System.debug('inside execute');
        IBBEvents.CompleteEventArgs args = new IBBEvents.CompleteEventArgs();
        args = ARBCustomerAMLAPIUtils.invokeRelatedEntityAMLAPI ( relatedAccountMap, opportunityId);
		Web_Integration_Log__c webLog = [Select Id,Response_Body__c from Web_Integration_Log__c where Id =:webLogId ];
        webLog.Response_Body__c = JSON.serialize(args);
        System.debug('weblogId::'+webLog);

        update webLog;
  }*/
    
    
}