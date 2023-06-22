/*******************************************************************
* @Class Name      : ARBCustomerERTrigger 
* @Author          : RAGESH G
* @Created Date    : 12 June 2023
* @description     : This trigger is used to send the Customer Related Entity information to Risk Narrative System
* @JIRA            : ASE-37

  LOG   DATE        Author  UserStory           COMMENT      
* 001   12/06/2023  RG                       Changes
********************************************************************/
trigger ARBCustomerERTrigger on Related_Customer_Entity_Relationship__c (after insert, after update, after undelete) {

    if (TN_Trigger_Settings__mdt.getInstance('CER_Trigger')?.Run_Trigger__c == true) {
        ARBCustomerERTriggerHandler handler = new ARBCustomerERTriggerHandler(Trigger.isExecuting, Trigger.size);
        switch on Trigger.operationType {
            
            when AFTER_INSERT {
                 handler.afterInsert(Trigger.new);
            }
            when AFTER_UPDATE {
                 handler.afterUpdate( Trigger.new );
            }
            when AFTER_UNDELETE {
                 handler.afterUndelete( Trigger.new );
            }
        }
    }
}