/*******************************************************************
* @Class Name      : ARBProcessCustomerUpdateHelper
* @Author          : RAGESH G
* @Created Date    : 11 April 2023
* @description      : This class is used to send the customer update request to TN from Account Trigger
* @JIRA            : 

  LOG   DATE        Author  UserStory         COMMENT      
* 001   11/04/2023  RG                       changes to the new list of fields for monitoring
********************************************************************/
public with sharing class ARBProcessCustomerUpdateHelper {

    
    
    public static void processCustomerUpdate(List<Account> oldList, Map<Id, Account> oldMap, List<Account> newList, Map<Id, Account> newMap) {
        
        Set < Id > accountIdSet = new Set < Id > ();
        List < Account > accountRecordList = new List < Account > ();
        for(Account acc: newList){
            if ( acc.TN_accountId__c != null && acc.Status__c != ARBAPIConstantValues.CLOSED_CUSTOMER_STATUS ) {
                if ( acc.RecordTypeId != ARBAPIConstantValues.NON_PERSON_ACCOUNT_RECORD_TYPE ) {
                    if(newMap.get(acc.Id).FirstName != oldMap.get(acc.Id).FirstName || 
                    newMap.get(acc.Id).Middle_Name__pc != oldMap.get(acc.Id).Middle_Name__pc ||
                        newMap.get(acc.Id).LastName != oldMap.get(acc.Id).LastName ||
                            newMap.get(acc.Id).BillingStreet != oldMap.get(acc.Id).BillingStreet|| 
                                newMap.get(acc.Id).Customer_Address_District__c != oldMap.get(acc.Id).Customer_Address_District__c ||
                                    newMap.get(acc.Id).BillingCity != oldMap.get(acc.Id).BillingCity ||
                                        newMap.get(acc.Id).BillingState != oldMap.get(acc.Id).BillingState ||
                                            newMap.get(acc.Id).BillingCountry != oldMap.get(acc.Id).BillingCountry ||
                                                newMap.get(acc.Id).BillingPostalCode != oldMap.get(acc.Id).BillingPostalCode  ){

                                                    accountIdSet.add ( acc.Id );
                    }
                } else {
                    if(newMap.get(acc.Id).Name != oldMap.get(acc.Id).Name || 
                            newMap.get(acc.Id).RegisteredAddressCity__c != oldMap.get(acc.Id).RegisteredAddressCity__c ||
                                newMap.get(acc.Id).RegisteredAddressCountry__c != oldMap.get(acc.Id).RegisteredAddressCountry__c || 
                                    newMap.get(acc.Id).RegisteredAddressPostCode__c != oldMap.get(acc.Id).RegisteredAddressPostCode__c ||
                                        newMap.get(acc.Id).RegisteredAddressStreet__c != oldMap.get(acc.Id).RegisteredAddressStreet__c){
                                            accountIdSet.add ( acc.Id );
                    }
                } 

                }
                
        }

    Map < String, String > oppAccountMap = new Map < String, String > ();
    System.debug ('accountIDSet ' + accountIdSet);
    if ( accountIDSet.size () > 0 ) {

        for ( Applicant__c applicant : [ SELECT Id,Opportunity__c, Prospect_Customer__c, Opportunity__r.Reason__c, Opportunity__r.Name,
		                                    Opportunity__r.AccountId, Opportunity__r.IBB_Product__r.Category_Of_Product__c, Opportunity__r.RecordTypeId
                                        FROM Applicant__c
                                        WHERE Applicant__c.Prospect_Customer__c IN : accountIDSet] ) {
        
        oppAccountMap.put ( ''+applicant.Opportunity__c, ''+applicant.Prospect_Customer__c);
        }    

    System.debug ('Passing accountIdset n map ' + accountIdSet +'#####' + oppAccountMap);
    if ( oppAccountMap != null ) {
        System.enqueueJob(new ARBCustomerUpdateAPIProcess( accountIdSet , oppAccountMap ));
    }

    }
    

    
    }

}