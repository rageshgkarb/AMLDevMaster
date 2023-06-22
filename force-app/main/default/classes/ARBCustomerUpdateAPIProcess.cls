/*******************************************************************
* @Class Name      : ARBCustomerUpdateAPIProcess
* @Author          : RAGESH G
* @Created Date    : 11 April 2023
* @description      : This Queueable class is used to send the customer update request to TN from Account Trigger
* @JIRA            : 

  LOG   DATE        Author  UserStory         COMMENT      
* 001   11/04/2023  RG                       First Commit
********************************************************************/
public class ARBCustomerUpdateAPIProcess implements Queueable, Database.AllowsCallouts{
  
    public Set<Id> accountIdSet;
  public Map < String, String > oppAccountMap;
  
    public ARBCustomerUpdateAPIProcess( Set<Id> accountIdSet , Map < String, String >  oppAccountMap){
    
    this.accountIdSet = accountIdSet;
        this.oppAccountMap = oppAccountMap;
    }
    public void execute(QueueableContext qCntxt){
    IBBEvents.CompleteEventArgs args = new IBBEvents.CompleteEventArgs(); 
    system.debug ('oppAccountMap' + oppAccountMap);
    args = ARBCustomerAMLAPIUtils.invokeCustomerUpdateAMLAPI (accountIdSet, oppAccountMap );
    System.debug ('Response from API ' + args);  
    
  }
    
}