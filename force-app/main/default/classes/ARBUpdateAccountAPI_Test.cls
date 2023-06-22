@isTest
private class ARBUpdateAccountAPI_Test {

    @testSetup
    static void dataSetup(){
        Account ac= new Account(FirstName = 'John', LastName = 'Blogs', Title_Other__c = 'Mr', BillingStreet = 'A\nB', ShippingStreet = 'A\nB', PersonMailingStreet = 'A\nB', Layers_of_Ownership__c  ='1 layer of ownership or less', 
                            Length_of_Establishment__c  = 'Over 3 years', Balance_Sheet_000s__c = 'Under £2.5m', Sanctioned_Individual_Check__c = 'No true match identified', 
                            Previously_Exited_or_Declined__c = 'No true match identified',  Source_of_Funds__c = 'Account funded from a bank account in the UK', 
                            Nature_of_Business_NPAA__c = 'Club, Association or Community', Face_to_face_Contact__c  = 'No UBO or Significant Controller met face to face', 
                            Politically_Exposed_Company__c = 'No True Match', Negative_News_Screening__c = 'No true match identified', Organisation_type__c = 'Limited Company', 
                            Organisation_Domicile__c =   '', High_risk_prohibited_sanctioned_countr__c = 'United Kingdom', HR_Prohibited_sanctioned_COR_for_UBOs_I__c = 'United Kingdom', 
                            Customer_Type__c = 'Limited Company', TN_accountId__c= '947169', TN_Manual_Screening_Required__c= '');
        insert ac;
        system.debug('Account ID is: '+ ac.Id);
        system.debug('Organisation type is:'+ ac.Organisation_type__c);
        system.debug('SFDC ID is: '+ ac.SFDC_ID__c);
        
        Opportunity opp = new Opportunity(closedate = date.today(), AccountId = ac.id, Name = 'Test Opp', Interested_in__c = 'Test', Purchase_price_market_value__c = 300000, Finance_Required__c = 100000, 
                                          Term_of_Finance__c=25, number_of_people_applying__c = 1, Source_of_Funds__c = 'Account funded from a bank account in the UK', StageName = 'Awaiting final documents');
        insert opp;
        
        Case csrec= new Case(FCUSatisfied__c = 'Yes', Referral_Decision__c = 'Accept', Subject = 'TestSubject', Description = 'TestDescription', Status = 'Awaiting Allocation', AccountId = ac.id, Opportunity__c = opp.id,RecordTypeId='012D0000000KJujIAG');           
        insert csrec;
        
        /*Account ac2= new Account(FirstName = 'Joe', LastName = 'Bloggs', Title_Other__c = 'Mr', BillingStreet = 'A\nB', ShippingStreet = 'A\nB', PersonMailingStreet = 'A\nB', Layers_of_Ownership__c  ='1 layer of ownership or less', 
                            Length_of_Establishment__c  = 'Over 3 years', Balance_Sheet_000s__c = 'Under £2.5m', Sanctioned_Individual_Check__c = 'No true match identified', 
                            Previously_Exited_or_Declined__c = 'No true match identified',  Source_of_Funds__c = 'Account funded from a bank account in the UK', 
                            Nature_of_Business_NPAA__c = 'Club, Association or Community', Face_to_face_Contact__c  = 'No UBO or Significant Controller met face to face', 
                            Politically_Exposed_Company__c = 'No True Match', Negative_News_Screening__c = 'No true match identified', Organisation_type__c = 'Limited Company', 
                            Organisation_Domicile__c =   '', High_risk_prohibited_sanctioned_countr__c = 'United Kingdom', HR_Prohibited_sanctioned_COR_for_UBOs_I__c = 'United Kingdom', 
                            Customer_Type__c = 'Limited Company', TN_accountId__c= '947189', TN_Manual_Screening_Required__c= 'Y');
        insert ac2;
        
         

        Opportunity opp2 = new Opportunity(closedate = date.today(), AccountId = ac2.id, Name = 'Test Opp', Interested_in__c = 'Test', Purchase_price_market_value__c = 300000, Finance_Required__c = 100000, 
                                          Term_of_Finance__c=25, number_of_people_applying__c = 1, Source_of_Funds__c = 'Account funded from a bank account in the UK', StageName = 'Completed');
        insert opp2;


        Case csrec2= new Case(FCUSatisfied__c = 'No', Referral_Decision__c = 'Reject', Subject = 'TestSubject', Description = 'TestDescription', Status = 'Awaiting Allocation', AccountId =ac2.id , Opportunity__c = opp2.id);           
        insert csrec2;*/
        
        /*Profile profileId = [SELECT Id FROM Profile WHERE Name = 'Commercial Staff (POST PROFILE REVIEW)' LIMIT 1];
    
        User usr = new User(LastName = 'TEST',FirstName='Fail',Alias = 'ftest',Email = 'f.test@asdf.com',Username = 'f.test@asdf.com',ProfileId = profileId.id,TimeZoneSidKey = 'GMT',
                            LanguageLocaleKey = 'en_US',EmailEncodingKey = 'UTF-8',LocaleSidKey = 'en_US');
        insert usr;  */
    }
    
    
    
    @isTest
    static void invokeAccountUpdateTest(){
    try{
    system.RestRequest mockReq= new system.RestRequest();
    system.RestResponse mockRes = new system.RestResponse();
    mockReq.requestURI = '/services/apexrest/updateAccountAPI/';
    mockReq.httpMethod='POST';
    ARBAccountReferralRequestModel requestData= new ARBAccountReferralRequestModel();
    string requestBody = '{"CaseReferralRequest": {"SFDCID":"","OpportunityId": "'+Account.SFDC_ID__c+'","UpdateType": "D","nextAction": "","tnMessage": {"name": "STORYWELCOMELETTER Force26","referralReference": "R2310215","uid": "7f5578b9-ffaf-45d4-92ff-abd31b684f4b","status": "DECLINE","updateDateTime": "2023-03-30T00:15:03Z","riskLevel": "Equifax - IDV No Match","clientApplicationReference": "SFDC-UAT001061627","nextAction":{"id":1,"label":"Non Personal - No True Match Identified-008"}}}}';      
    Account acc = [SELECT Id, SFDC_ID__c,TN_accountId__c From Account where TN_accountId__c=:'947169'];
    requestBody=requestBody.replaceAll('"SFDCID":""','"SFDCID":"'+acc.SFDC_ID__c+'"');
    mockreq.requestBody=Blob.valueOf(requestBody);
      
     Test.startTest();
     system.RestContext.request=mockReq;
     system.RestContext.response=mockRes; 
     
     ARBCaseUpdateResponseModel responseInstance = ARBUpdateAccountAPI.invokeAccountUpdate();
     Test.stopTest();
     }Catch(Exception ex){
         system.debug('Exception message is' + ex.getMessage());
         }
     
    }
    
    @isTest
    static void invokeAccountUpdateTest2(){
    try{
    system.RestRequest mockReq= new system.RestRequest();
    system.RestResponse mockRes = new system.RestResponse();
    mockReq.requestURI = '/services/apexrest/updateAccountAPI/';
    mockReq.httpMethod='POST';
    ARBAccountReferralRequestModel requestData= new ARBAccountReferralRequestModel();
        string requestBody = '{"CaseReferralRequest": {"SFDCID":"","OpportunityId": "'+Account.SFDC_ID__c+'","UpdateType": "A","nextAction": "","tnMessage": {"name": "STORYWELCOMELETTER Force26","referralReference": "R2310215","uid": "7f5578b9-ffaf-45d4-92ff-abd31b684f4b","status": "DECLINE","updateDateTime": "2023-03-30T00:15:03Z","riskLevel": "Equifax - IDV No Match","clientApplicationReference": "SFDC-UAT001061627","nextAction":{"id":1,"label":"Personal - Some Level of Match-027"}}}}';      
    Account acc = [SELECT Id, SFDC_ID__c,TN_accountId__c From Account where TN_accountId__c=:'947169'];
    requestBody=requestBody.replaceAll('"SFDCID":""','"SFDCID":"'+acc.SFDC_ID__c+'"');
    mockreq.requestBody=Blob.valueOf(requestBody);
     // Case cs = [Select ID, RecordTypeId,AccountId,isClosed,Opportunity__c,Opportunity__r.StageName,Referral_Decision__c,FCUSatisfied__c from Case];
      //Opportunity opty =[Select Id From Opportunity];
      
     Opportunity opty = new Opportunity(closedate = date.today(), AccountId = acc.id, Name = 'Test Opp', Interested_in__c = 'Test', Purchase_price_market_value__c = 300000, Finance_Required__c = 100000, 
                                          Term_of_Finance__c=25, number_of_people_applying__c = 1, Source_of_Funds__c = 'Account funded from a bank account in the UK', StageName = 'Awaiting final documents');
        insert opty;
        
       Case csrec= new Case(FCUSatisfied__c = 'Yes', Referral_Decision__c = 'Accept', Subject = 'Test Subject', Description = 'TestDescription', Status = 'Awaiting Allocation', AccountId = acc.id, Opportunity__c = opty.id,RecordTypeId='012D0000000KJujIAG');           
        insert csrec;
     Test.startTest();
     system.RestContext.request=mockReq;
     system.RestContext.response=mockRes; 
     
     ARBCaseUpdateResponseModel responseInstance = ARBUpdateAccountAPI.invokeAccountUpdate();
     Test.stopTest();
     }Catch(Exception ex){
         system.debug('Exception message is' + ex.getMessage());
      }
    
  }
    @isTest
    static void invokeAccountUpdateExceptionTest(){
    system.RestRequest mockReq= new system.RestRequest();
    system.RestResponse mockRes = new system.RestResponse();
    mockReq.requestURI = '/services/apexrest/updateAccountAPI/';
    mockReq.httpMethod='POST';
    ARBAccountReferralRequestModel requestData= new ARBAccountReferralRequestModel();
        string requestBody = '{"CaseReferralRequest": {"SFDCID":"","OpportunityId": "","UpdateType": "A","nextAction": "","tnMessage": {"name": "STORYWELCOMELETTER Force26","referralReference": "R2310215","uid": "7f5578b9-ffaf-45d4-92ff-abd31b684f4b","status": "DECLINE","updateDateTime": "2023-03-30T00:15:03Z","riskLevel": "Equifax - IDV No Match","clientApplicationReference": "SFDC-UAT001061627","nextAction":{"id":1,"label":"Personal - Some Level of Match-027"}}}}';      
    Account acc = [SELECT Id, SFDC_ID__c,TN_accountId__c From Account where TN_accountId__c=:'947169'];
    requestBody=requestBody.replaceAll('"SFDCID":""','"SFDCID":"'+acc.SFDC_ID__c+'"');
    mockreq.requestBody=Blob.valueOf(requestBody);
     // Case cs = [Select ID, RecordTypeId,AccountId,isClosed,Opportunity__c,Referral_Decision__c,FCUSatisfied__c from Case];
      Opportunity opty =[Select Id From Opportunity];
        
       // system.debug('cs:::'+cs);
     Test.startTest();
     system.RestContext.request=mockReq;
     system.RestContext.response=mockRes; 
     ARBCaseUpdateResponseModel responseInstance = ARBUpdateAccountAPI.invokeAccountUpdate();
     Test.stopTest();
    
  }
    
  @isTest
    static void invokeAccountUpdateTest3	(){
    try{
    system.RestRequest mockReq= new system.RestRequest();
    system.RestResponse mockRes = new system.RestResponse();
    mockReq.requestURI = '/services/apexrest/updateAccountAPI/';
    mockReq.httpMethod='POST';
    ARBAccountReferralRequestModel requestData= new ARBAccountReferralRequestModel();
    string requestBody = '{"CaseReferralRequest": {"SFDCID":"","OpportunityId": "'+Account.SFDC_ID__c+'","UpdateType": "B","nextAction": "","tnMessage": {"name": "STORYWELCOMELETTER Force26","referralReference": "R2310215","uid": "7f5578b9-ffaf-45d4-92ff-abd31b684f4b","status": "DECLINE","updateDateTime": "2023-03-30T00:15:03Z","riskLevel": "Equifax - IDV No Match","clientApplicationReference": "SFDC-UAT001061627","nextAction":{"id":1,"label":"CRA screening fields updated in Salesforce - Yes?-029"}}}}';      
    Account acc = [SELECT Id, SFDC_ID__c,TN_accountId__c From Account where TN_accountId__c=:'947169'];
    requestBody=requestBody.replaceAll('"SFDCID":""','"SFDCID":"'+acc.SFDC_ID__c+'"');
    mockreq.requestBody=Blob.valueOf(requestBody);
      
     Test.startTest();
     system.RestContext.request=mockReq;
     system.RestContext.response=mockRes; 
     
     ARBCaseUpdateResponseModel responseInstance = ARBUpdateAccountAPI.invokeAccountUpdate();
     Test.stopTest();
     }Catch(Exception ex){
         system.debug('Exception message is' + ex.getMessage());
         }
     
    }
    
    @isTest
    static void invokeAccountUpdateTest4(){
    try{
    system.RestRequest mockReq= new system.RestRequest();
    system.RestResponse mockRes = new system.RestResponse();
    mockReq.requestURI = '/services/apexrest/updateAccountAPI/';
    mockReq.httpMethod='POST';
    ARBAccountReferralRequestModel requestData= new ARBAccountReferralRequestModel();
    string requestBody = '{"CaseReferralRequest": {"SFDCID":"","UpdateType": "B","nextAction": "","tnMessage": {"name": "STORYWELCOMELETTER Force26","referralReference": "R2310215","uid": "7f5578b9-ffaf-45d4-92ff-abd31b684f4b","status": "DECLINE","updateDateTime": "2023-03-30T00:15:03Z","riskLevel": "Equifax - IDV No Match","clientApplicationReference": "SFDC-UAT001061627","nextAction":{"id":1,"label":"CRA screening fields updated in Salesforce - N/A?-030"}}}}';      
    Account acc = [SELECT Id, SFDC_ID__c,TN_accountId__c From Account where TN_accountId__c=:'947169'];
    requestBody=requestBody.replaceAll('"SFDCID":""','"SFDCID":"'+acc.SFDC_ID__c+'"');
    mockreq.requestBody=Blob.valueOf(requestBody);
      
     Test.startTest();
     system.RestContext.request=mockReq;
     system.RestContext.response=mockRes; 
     
     ARBCaseUpdateResponseModel responseInstance = ARBUpdateAccountAPI.invokeAccountUpdate();
     Test.stopTest();
     }Catch(Exception ex){
         system.debug('Exception message is' + ex.getMessage());
         }
     
    }
    

    
   
}