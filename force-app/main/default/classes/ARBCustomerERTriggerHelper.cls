/*******************************************************************
* @Class Name      : ARBCustomerERTriggerHelper
* @Author          : RAGESH G
* @Created Date    : 09 June 2023
* @description 	   : This class is used to write all the helper methods required for 
* @JIRA            : ASE-37

  LOG   DATE        Author  UserStory       	COMMENT      
* 001   09/06/2023  RG                       First Commit
********************************************************************/
public without sharing class ARBCustomerERTriggerHelper {
    public ARBCustomerERTriggerHelper() {
        System.debug('Inside ARBCustomerERTriggerHelper Constructor');
    }
    public void processRelatedEntityRecords( Map < String, Map < Id, Related_Customer_Entity__c > > relatedBusinessCustomerMap ) {
        System.debug('processRelatedEntityRecords');
        Map < Id, Related_Customer_Entity__c > relatedAccountMap = new Map < Id, Related_Customer_Entity__c > ();

        if ( relatedBusinessCustomerMap != null ) {
            String businessAccountId = 
            System.enqueueJob(new ARBRelatedEntityUpdateAPIProcess( relatedBusinessCustomerMap ));
        }
    }
}