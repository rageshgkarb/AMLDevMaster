@RestResource(urlMapping='/updateAccountAPI/*')
global class ARBUpdateAccountAPI {

  /* @Purpose - Method to invoke the update Account API from middleware ( from TruNarrative )
   * @Params  - ARBCaseUpdateRequestModel- model record for quote update request
          
   * @return ARBAccountUpdateResponseModel with updated order details.
  */
  @HTTPPost
  global static ARBCaseUpdateResponseModel invokeAccountUpdate( ) {
      
      
      System.RestRequest     request    = System.RestContext.request;
      System.RestResponse    response   = System.RestContext.response;         
      ARBAccountReferralRequestModel wrpData = new ARBAccountReferralRequestModel(); 
      List < Account > accountRecordList = new List < Account > ();
      List < Opportunity > oppRecordList = new List < Opportunity > ();
      Account accountRecord ;
      Set < Id > oppRecordIDSet = new Set < Id > ();
      
      String formattedRequest = request.requestBody.toString().unescapeEcmaScript();
      System.debug ('formattedRequest' + formattedRequest);
      wrpData = (ARBAccountReferralRequestModel)System.JSON.deserialize( formattedRequest, ARBAccountReferralRequestModel.class);
        
      ARBCaseUpdateResponseModel responseInstance = new ARBCaseUpdateResponseModel ();
      List < Case > caseRecordList = new List < Case > ();
      if ( wrpData.CaseReferralRequest.SFDCID != null ) {
          accountRecord = [ SELECT Id, SFDC_ID__c, TN_Manual_Screening_Required__c FROM Account WHERE SFDC_ID__c=:wrpData.CaseReferralRequest.SFDCID ];
          
          
          if ( accountRecord != null ) {
              List<string> recordTypeList = new List<String>{'012D0000000KJujIAG','0123z0000007WwUAAU'};
              for ( Case caseRecord : [ SELECT Id, CaseNumber, Status, FCUSatisfied__c, Referral_Decision__c, Opportunity__c, Comments__c
                                        FROM Case WHERE AccountId =: accountRecord.Id AND RecordTypeId IN:recordTypeList AND isClosed = false]) {
                if ( wrpData.CaseReferralRequest.UpdateType == 'A' ) {
                    caseRecord.FCUSatisfied__c = 'Yes';
                    caseRecord.Referral_Decision__c = 'Accept';
                } else if ( wrpData.CaseReferralRequest.UpdateType == 'D' ) {
                    caseRecord.FCUSatisfied__c = 'No';
                    caseRecord.Referral_Decision__c = 'Decline';
                    if ( wrpData.CaseReferralRequest.tnMessage.riskLevel != null ) {
                      caseRecord.Comments__c = 'This case is rejected due to ' + wrpData.CaseReferralRequest.tnMessage.riskLevel;
                    }
                    

                }
                
                caseRecord.Status = 'Closed';
                caseRecordList.add ( caseRecord );
                oppRecordIDSet.add ( caseRecord.Opportunity__c);
              }
          }

          if ( caseRecordList.size () > 0 ) {
            ARBCaseUpdateResponseModel.CaseUpdateResponse updateCaseResponseObj =new ARBCaseUpdateResponseModel.CaseUpdateResponse();

              try {
                update caseRecordList;
                updateCaseResponseObj.caseId=''+caseRecordList[0].Id;
                updateCaseResponseObj.OpportunityId=''+ wrpData.CaseReferralRequest.OpportunityId;
                updateCaseResponseObj.Status='Closed';
                updateCaseResponseObj.Success = 'true';
                updateCaseResponseObj.Message = 'Case Closed Successfully Updated';
                responseInstance.caseUpdateResponse = updateCaseResponseObj;

              } catch ( Exception Exe ) {
                updateCaseResponseObj.caseId='';
                updateCaseResponseObj.OpportunityId=''+ wrpData.CaseReferralRequest.OpportunityId;
                updateCaseResponseObj.Status='Open';
                updateCaseResponseObj.Success = 'false';
                updateCaseResponseObj.Message = 'Cannot close the case due to== ' + Exe.getMessage ();
                responseInstance.caseUpdateResponse = updateCaseResponseObj;

              }
              
              Boolean isSuccess = false;  
              for(Case c: [SELECT Id, CaseNumber, Status, FCUSatisfied__c, Referral_Decision__c, Opportunity__c, Comments__c, isClosed
                                                      FROM Case WHERE Opportunity__c IN : oppRecordIDSet 
                                                      AND RecordTypeId='012D0000000KJujIAG' AND isClosed = false]){
                if(c.Referral_Decision__c =='Accept' && c.FCUSatisfied__c=='Yes'){
                  isSuccess =  true;
                } else {
              isSuccess =  false;
              }
                if(!c.isClosed){
                  isSuccess = false;
                  }
              }
              
              System.debug ('is Success ' + isSuccess);                            
              
              if ( oppRecordIDSet.size ()> 0 && isSuccess) {
                  for ( Opportunity oppRecord : [ SELECT Id, Name, CAA_Decision__c FROM Opportunity WHERE Id IN : oppRecordIDSet]) {
                      oppRecord.CAA_Decision__c = 'SUCCESS';
                      oppRecordList.add ( oppRecord);
                  }

                  
              }

              if ( oppRecordIDSet.size ()> 0 && !isSuccess) {
                for ( Opportunity oppRecord : [ SELECT Id, Name, CAA_Decision__c FROM Opportunity WHERE Id IN : oppRecordIDSet]) {
                    oppRecord.CAA_Decision__c = 'FAILED';
                    oppRecord.stagename = 'Application declined';
                    oppRecordList.add ( oppRecord);
                }
                
            }

            try {
              update oppRecordList;    
            } catch ( Exception Exe ) {
              System.debug ('Unable to update Opportunity ' + + Exe.getMessage ());
              
            }
          }
      }
      System.debug ('wrpData.CaseReferralRequest.tnMessage.nextAction' + wrpData.CaseReferralRequest.tnMessage.nextAction);
      if ( wrpData.CaseReferralRequest.tnMessage.nextAction != null ) {
        if ( wrpData.CaseReferralRequest.tnMessage.nextAction.label == ARBAPIConstantValues.PERSONAL_SOME_LEVEL_MATCH || 
        wrpData.CaseReferralRequest.tnMessage.nextAction.label == ARBAPIConstantValues.NON_PERSONAL_SOME_LEVEL_MATCH) {
             accountRecord.TN_Manual_Screening_Required__c = 'Y';
             accountRecordList.add ( accountRecord);
        } else if ( wrpData.CaseReferralRequest.tnMessage.nextAction.label == ARBAPIConstantValues.PERSONAL_NO_MATCH || 
        wrpData.CaseReferralRequest.tnMessage.nextAction.label == ARBAPIConstantValues.NON_PERSONAL_NO_MATCH ) {
          accountRecord.TN_Manual_Screening_Required__c = 'N';
          accountRecordList.add ( accountRecord);
        }
  
  
        try { 
          update accountRecordList;
  
        } catch ( Exception Exe ) {
            System.debug (' Exception while updating account from inbound API' + Exe.getMessage ()  );
        }

      }
      

      return responseInstance;
  
  }



}