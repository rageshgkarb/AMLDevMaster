/*******************************************************************
* @Class Name      : ARBRelatedEntityUpdateAPIProcess
* @Author          : RAGESH G
* @Created Date    : 09 June 2023
* @description     : This Queueable class is used to send the related customer entity request to TN from Related_Customer_Entity__c 
                        Trigger
* @JIRA            : ASE-32

  LOG   DATE        Author  UserStory         COMMENT      
* 001   09/06/2023  RG                       First Commit
********************************************************************/
public class ARBRelatedEntityUpdateAPIProcess implements Queueable, Database.AllowsCallouts{
  
	Map < String, Map < Id, Related_Customer_Entity__c > > relatedBusinessCustomerMap;
    String businessAccountId;
  
    public ARBRelatedEntityUpdateAPIProcess( Map < String, Map < Id, Related_Customer_Entity__c > > relatedBusinessCustomerMap ){
    
        this.relatedBusinessCustomerMap = relatedBusinessCustomerMap;
    }
    public void execute(QueueableContext qCntxt){

        
		if ( relatedBusinessCustomerMap.values ().size() > 0 ) {
            Opportunity oppRecord = [SELECT id, Accountid  FROM opportunity WHERE Accountid=:relatedBusinessCustomerMap.keySet() LIMIT 1];
            Map < Id, Related_Customer_Entity__c > relatedAccountMap;
            if ( oppRecord != null && relatedBusinessCustomerMap.containsKey ( oppRecord.Accountid ) ) {
                relatedAccountMap = relatedBusinessCustomerMap.get ( oppRecord.Accountid );
                System.debug ('relatedAccountMap ' + relatedAccountMap.keySet ());
			    ARBCustomerAMLAPIUtils.invokeRelatedEntityAMLAPI ( relatedAccountMap, ''+oppRecord.Id );
            }
			
        }
  }
    
}