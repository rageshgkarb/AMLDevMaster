/*******************************************************************
* @Class Name      : ARBTriggerHandler
* @Author          : RAGESH G
* @Created Date    : 09 June 2023
* @description 	   : This interface is used to write respective events for the trigger of an object
* @JIRA            : ASE-37

  LOG   DATE        Author  UserStory       	COMMENT      
* 001   09/06/2023  RG                       First Commit
********************************************************************/

public interface ARBTriggerHandler {
    
    void afterInsert(List<SObject> newRecords);
    void afterUpdate(List<SObject> newRecords);
    void afterUndelete(List<SObject> newRecords);
}