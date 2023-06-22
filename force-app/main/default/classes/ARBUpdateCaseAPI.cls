@RestResource(urlMapping='/updatecaseAPI/*')
global with sharing class ARBUpdateCaseAPI {

  /* @Purpose - Method to invoke the update Case API from middleware ( from TruNarrative )
   * @Params  - ARBCaseUpdateRequestModel- model record for quote update request
          
   * @return ARBCaseUpdateResponseModel with updated order details.
  */
  @HTTPPost
  global static ARBCaseUpdateResponseModel invokeCaseUpdate( ARBCaseUpdateRequestModel CaseUpdateRequest ) {
      
      system.debug('Post : CaseUpdateRequest  :'+CaseUpdateRequest );
      ARBCaseUpdateResponseModel responseInstance = new ARBCaseUpdateResponseModel ();
      Account accountRecord ;
      List < Case > caseRecordList = new List < Case > ();
      if ( CaseUpdateRequest.TNAccountId != null ) {
          accountRecord = [ SELECT Id, Name FROM Account WHERE Id=:CaseUpdateRequest.TNAccountId ];
          
          if ( accountRecord != null ) {
              for ( Case caseRecord : [ SELECT Id, CaseNumber, Status, FCUSatisfied__c, Referral_Decision__c
                                        FROM Case WHERE AccountId =: accountRecord.Id]) {
                caseRecord.FCUSatisfied__c = 'Yes';
                caseRecord.Referral_Decision__c = 'Accept';
                caseRecord.Status = 'Closed';
                caseRecordList.add ( caseRecord );
              }
          }

          if ( caseRecordList.size () > 0 ) {
            ARBCaseUpdateResponseModel.CaseUpdateResponse updateCaseResponseObj =new ARBCaseUpdateResponseModel.CaseUpdateResponse();

              try {
                //update caseRecordList;
                updateCaseResponseObj.caseId=''+caseRecordList[0].Id;
                updateCaseResponseObj.OpportunityId=''+ CaseUpdateRequest.OpportunityId;
                updateCaseResponseObj.Status='Closed';
                updateCaseResponseObj.Success = 'true';
                updateCaseResponseObj.Message = 'Case Closed Successfully Updated';
                responseInstance.caseUpdateResponse = updateCaseResponseObj;

              } catch ( Exception Exe ) {
                updateCaseResponseObj.caseId='';
                updateCaseResponseObj.OpportunityId=''+ CaseUpdateRequest.OpportunityId;
                updateCaseResponseObj.Status='Open';
                updateCaseResponseObj.Success = 'false';
                updateCaseResponseObj.Message = 'Case Update Failed ' + Exe.getMessage ();
                responseInstance.caseUpdateResponse = updateCaseResponseObj;

              }
          }
      }

      
      return responseInstance;
  
  }



}