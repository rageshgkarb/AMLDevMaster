@isTest
public class BAA_Application_Signed_Controller_Test {

    
    
    @isTest static void method1(){
    		
        Event__c evt = new Event__c(Name = 'Test Event');
		insert evt;
 
         Account ac= new Account(FirstName = 'Joe', LastName = 'Bloggs', Title_Other__c = 'Mr', BillingStreet = 'A\nB', ShippingStreet = 'A\nB', PersonMailingStreet = 'A\nB', Layers_of_Ownership__c  ='1 layer of ownership or less', 
                                Length_of_Establishment__c  = 'Over 3 years', Balance_Sheet_000s__c = 'Under £2.5m', Sanctioned_Individual_Check__c = 'No true match identified', 
                                Previously_Exited_or_Declined__c = 'No true match identified',  Source_of_Funds__c = 'Account funded from a bank account in the UK', 
                                Nature_of_Business_NPAA__c = 'Club, Association or Community', Face_to_face_Contact__c  = 'No UBO or Significant Controller met face to face', 
                                Politically_Exposed_Company__c = 'No True Match', Negative_News_Screening__c = 'No true match identified', Organisation_type__c = 'Limited Company', 
                                Organisation_Domicile__c =   '', High_risk_prohibited_sanctioned_countr__c = 'United Kingdom', HR_Prohibited_sanctioned_COR_for_UBOs_I__c = 'United Kingdom', 
                                Customer_Type__c = 'Limited Company',Gender__c ='Male',Marital_Status__c= 'Married',Date_of_Birth__c= Date.today()-7300,
                                UK_Citizen__c = 'No',ID_Evidence__c = 'Contact Center',ID_Serial_No__c = '123AA0',Proof_of_Address__c='Not Provided');
        
        insert ac;
        
        Opportunity opp = new Opportunity(closedate = date.today(), AccountId = ac.id, Name = 'Test Opp', Interested_in__c = 'TestA', Purchase_price_market_value__c = 300000, Finance_Required__c = 100000, 
                                          Term_of_Finance__c=25, number_of_people_applying__c = 1, Source_of_Funds__c = 'Account funded from a bank account in the UK', StageName = 'Personal Details');
        
        insert opp;
        
        EventLog__c eventLog = new EventLog__c();
        eventLog.Name = 'Event Log';
        eventLog.Event__c = evt.Id;
        eventLog.Opportunity__c = opp.Id;
        insert eventLog;
        
       
        
        String response1 = '{"MessageId": "123","TNId": 123,"InitialDecision": "Pass","Decision": "Pass","ErrorCode": null,"ErrorMessage": null,"RuleOutcomes": [{"RuleName": "Test Rule","Outcome": true,"Score": 100}],"TNResponse": {"accountId":1234,"status": {"code": "AWAITING_RESPONSE","label": "AWAITING_RESPONSE"},"decision": {"code": "AWAITING_RESPONSE","label": "AWAITING_RESPONSE"},"Applications": [{"uid": "123","auditReference": "123","runId": 123,"journeyId": {"id": 123,"name": "Test Journey"},"organisationId": {"id": 123},"country": "USA","user": {"id": 123,"name": "Test User"},"nameReference": "Test Name","riskLevel": "High","journeyType": {"id": 123,"label": "Test Journey"},"startDateTime": "2023-03-15T10:05:44.475Z","endDateTime": "2023-03-15T10:05:44.475Z","progressStatus": {"code": "Pass","label": "Pass"},"decision": {"code": "Pass","label": "Pass"},"rulesetOutcomes": [{"reference": "Test Reference","score": 100,"ruleOutcomes": [{"RuleName": "Test Rule","Outcome": true,"Score": 100}],"riskLevel": "High"}],"links": [{"code": "Test Code","url": "http://test.com"}]}]}}';

        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new ARBCustomerAMLAPIMock(response1));        
        BAA_Application_Signed_Controller_Ltng.SubmitToDe(eventLog.Id);
        Test.stopTest();
    }
    
    
  /* @isTest
    static void testSubmitToDe() {
    
        
         Account ac= new Account(FirstName = 'Joe', LastName = 'Bloggs', Title_Other__c = 'Mr', BillingStreet = 'A\nB', ShippingStreet = 'A\nB', PersonMailingStreet = 'A\nB', Layers_of_Ownership__c  ='1 layer of ownership or less', 
                                Length_of_Establishment__c  = 'Over 3 years', Balance_Sheet_000s__c = 'Under £2.5m', Sanctioned_Individual_Check__c = 'No true match identified', 
                                Previously_Exited_or_Declined__c = 'No true match identified',  Source_of_Funds__c = 'Account funded from a bank account in the UK', 
                                Nature_of_Business_NPAA__c = 'Club, Association or Community', Face_to_face_Contact__c  = 'No UBO or Significant Controller met face to face', 
                                Politically_Exposed_Company__c = 'No True Match', Negative_News_Screening__c = 'No true match identified', Organisation_type__c = 'Limited Company', 
                                Organisation_Domicile__c =   '', High_risk_prohibited_sanctioned_countr__c = 'United Kingdom', HR_Prohibited_sanctioned_COR_for_UBOs_I__c = 'United Kingdom', 
                                Customer_Type__c = 'Limited Company',Gender__c ='Male',Marital_Status__c= 'Married',Date_of_Birth__c= Date.today()-7300,
                                UK_Citizen__c = 'No',ID_Evidence__c = 'Contact Center',ID_Serial_No__c = '123AA0',Proof_of_Address__c='Not Provided');
        
        insert ac;
        
        Opportunity opp = new Opportunity(closedate = date.today(), AccountId = ac.id, Name = 'Test Opp', Interested_in__c = 'TestA', Purchase_price_market_value__c = 300000, Finance_Required__c = 100000, 
                                          Term_of_Finance__c=25, number_of_people_applying__c = 1, Source_of_Funds__c = 'Account funded from a bank account in the UK', StageName = 'Closed Won');
        
        insert opp;
        
        HPP_extended_opportunity__c hppOpp = new HPP_extended_opportunity__c();
        hppOpp.Opportunity__c = opp.Id;
        insert hppOpp; 
        
        Applicant__c applicant1 = new Applicant__c(Opportunity__c = opp.Id,Prospect_Customer__c= ac.Id);
		insert applicant1;
        
        BAA_Application_Signed_Controller controller = new BAA_Application_Signed_Controller();
        controller.OppId = opp.Id;

        // Call Setup method
        Test.startTest();
        PageReference setupResult = controller.SubmitToDe();
        Test.stopTest();
        
    }  */
    
    static testMethod void testMethod1() {
        
        Event__c evt = new Event__c(Name = 'Test Event');
		insert evt;
 
         Account ac= new Account(FirstName = 'Joe', LastName = 'Bloggs', Title_Other__c = 'Mr', BillingStreet = 'A\nB', ShippingStreet = 'A\nB', PersonMailingStreet = 'A\nB', Layers_of_Ownership__c  ='1 layer of ownership or less', 
                                Length_of_Establishment__c  = 'Over 3 years', Balance_Sheet_000s__c = 'Under £2.5m', Sanctioned_Individual_Check__c = 'No true match identified', 
                                Previously_Exited_or_Declined__c = 'No true match identified',  Source_of_Funds__c = 'Account funded from a bank account in the UK', 
                                Nature_of_Business_NPAA__c = 'Club, Association or Community', Face_to_face_Contact__c  = 'No UBO or Significant Controller met face to face', 
                                Politically_Exposed_Company__c = 'No True Match', Negative_News_Screening__c = 'No true match identified', Organisation_type__c = 'Limited Company', 
                                Organisation_Domicile__c =   '', High_risk_prohibited_sanctioned_countr__c = 'United Kingdom', HR_Prohibited_sanctioned_COR_for_UBOs_I__c = 'United Kingdom', 
                                Customer_Type__c = 'Limited Company',Gender__c ='Male',Marital_Status__c= 'Married',Date_of_Birth__c= Date.today()-7300,
                                UK_Citizen__c = 'No',ID_Evidence__c = 'Contact Center',ID_Serial_No__c = '123AA0',Proof_of_Address__c='Not Provided');
        
        insert ac;
        
        Opportunity opp = new Opportunity(closedate = date.today(), AccountId = ac.id, Name = 'Test Opp', Interested_in__c = 'TestA', Purchase_price_market_value__c = 300000, Finance_Required__c = 100000, 
                                          Term_of_Finance__c=25, number_of_people_applying__c = 1, Source_of_Funds__c = 'Account funded from a bank account in the UK', StageName = 'Personal Details');
        
        insert opp;
        
        /*set<Id> oppId = new set<Id>();
        oppId.add(opp.Id);  */
        
        EventLog__c eventLog = new EventLog__c();
        eventLog.Name = 'Event Log';
        eventLog.Event__c = evt.Id;
        eventLog.Opportunity__c = opp.Id;
        eventLog.CreatedDate__c = datetime.now();
        eventLog.ActualCompletedDate__c = datetime.now().addDays(2);
        eventLog.CompletedBy__c = 'Event Completed';
        eventLog.EventStatus__c = 'Closed';
        insert eventLog;
        
        
        HPP_extended_opportunity__c hppOpp = new HPP_extended_opportunity__c(Application_form_signed__c= True, 
                            Documents_Received__c= True, 
                            All_customer_documents_recieved__c= Date.today(),
                 	        Opportunity__c = opp.id);
        insert hppOpp; 
        
        Applicant__c applicant1 = new Applicant__c(Opportunity__c = opp.Id,Prospect_Customer__c= ac.Id);
		insert applicant1;
        
        PageReference pageRef = Page.BAA_Application_Signed;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('id',String.valueOf(opp.Id));
        ApexPages.StandardController sc = new ApexPages.StandardController(opp);     

        BAA_Application_Signed_Controller controller = new BAA_Application_Signed_Controller();
        controller.OppId = opp.Id;
        controller.opportunityId = opp.Id;

        controller.Setup();
        controller.Complete();
      	String response1 = '{"MessageId": "123","TNId": 123,"InitialDecision": "Pass","Decision": "Pass","ErrorCode": null,"ErrorMessage": null,"RuleOutcomes": [{"RuleName": "Test Rule","Outcome": true,"Score": 100}],"TNResponse": {"accountId":1234,"status": {"code": "AWAITING_RESPONSE","label": "AWAITING_RESPONSE"},"decision": {"code": "AWAITING_RESPONSE","label": "AWAITING_RESPONSE"},"Applications": [{"uid": "123","auditReference": "123","runId": 123,"journeyId": {"id": 123,"name": "Test Journey"},"organisationId": {"id": 123},"country": "USA","user": {"id": 123,"name": "Test User"},"nameReference": "Test Name","riskLevel": "High","journeyType": {"id": 123,"label": "Test Journey"},"startDateTime": "2023-03-15T10:05:44.475Z","endDateTime": "2023-03-15T10:05:44.475Z","progressStatus": {"code": "Pass","label": "Pass"},"decision": {"code": "Pass","label": "Pass"},"rulesetOutcomes": [{"reference": "Test Reference","score": 100,"ruleOutcomes": [{"RuleName": "Test Rule","Outcome": true,"Score": 100}],"riskLevel": "High"}],"links": [{"code": "Test Code","url": "http://test.com"}]}]}}';


        Test.startTest();
        
        Test.setMock(HttpCalloutMock.class, new ARBCustomerAMLAPIMock(response1));
		controller.SubmitToDe();
        Test.stopTest();
        
        System.debug('hppOpp:' +hppOpp);
        System.debug('Controller:' +controller); 
        
       
        
        
    }
    
    @isTest
    static void acctOppTwoApplicant() {

         PageReference pageRef = Page.BAA_Application_Signed;
         Test.setCurrentPage(pageRef);
        
        Event__c evt = new Event__c(Name = 'Test Event');
		insert evt;
 
         Account ac= new Account(FirstName = 'Joe', LastName = 'Bloggs', Title_Other__c = 'Mr', BillingStreet = 'A\nB', ShippingStreet = 'A\nB', PersonMailingStreet = 'A\nB', Layers_of_Ownership__c  ='1 layer of ownership or less', 
                                Length_of_Establishment__c  = 'Over 3 years', Balance_Sheet_000s__c = 'Under £2.5m', Sanctioned_Individual_Check__c = 'No true match identified', 
                                Previously_Exited_or_Declined__c = 'No true match identified',  Source_of_Funds__c = 'Account funded from a bank account in the UK', 
                                Nature_of_Business_NPAA__c = 'Club, Association or Community', Face_to_face_Contact__c  = 'No UBO or Significant Controller met face to face', 
                                Politically_Exposed_Company__c = 'No True Match', Negative_News_Screening__c = 'No true match identified', Organisation_type__c = 'Limited Company', 
                                Organisation_Domicile__c =   '', High_risk_prohibited_sanctioned_countr__c = 'United Kingdom', HR_Prohibited_sanctioned_COR_for_UBOs_I__c = 'United Kingdom', 
                                Customer_Type__c = 'Limited Company',Gender__c ='Male',Marital_Status__c= 'Married',Date_of_Birth__c= Date.today()-7300,
                                UK_Citizen__c = 'No',ID_Evidence__c = 'Contact Center',ID_Serial_No__c = '123AA0',Proof_of_Address__c='Not Provided');
        
        insert ac;
        
        Opportunity opp = new Opportunity(closedate = date.today(), AccountId = ac.id, Name = 'Test Opp', Interested_in__c = 'TestA', Purchase_price_market_value__c = 300000, Finance_Required__c = 100000, 
                                          Term_of_Finance__c=25, number_of_people_applying__c = 1, Source_of_Funds__c = 'Account funded from a bank account in the UK', StageName = 'Personal Details');
        
        insert opp;
        
        /*set<Id> oppId = new set<Id>();
        oppId.add(opp.Id);  */
        
        EventLog__c eventLog = new EventLog__c();
        eventLog.Name = 'Event Log';
        eventLog.Event__c = evt.Id;
        eventLog.Opportunity__c = opp.Id;
        eventLog.CreatedDate__c = datetime.now();
        eventLog.ActualCompletedDate__c = datetime.now().addDays(2);
        eventLog.CompletedBy__c = 'Event Completed';
        eventLog.EventStatus__c = 'Closed';
        insert eventLog;
        
        
        HPP_extended_opportunity__c hppOpp = new HPP_extended_opportunity__c(Application_form_signed__c= True, 
                            Documents_Received__c= True, 
                            All_customer_documents_recieved__c= Date.today(),
                 	        Opportunity__c = opp.id);
        insert hppOpp; 
        
        
        List<Applicant__c> appList = new List<Applicant__c>();
        Applicant__c applicant1 = new Applicant__c(Opportunity__c = opp.Id,Prospect_Customer__c= ac.Id);
		appList.add(applicant1);
        Applicant__c applicant2 = new Applicant__c(Opportunity__c = opp.Id,Prospect_Customer__c= ac.Id);
		appList.add(applicant2);
        insert appList;
        
        String response1 = '{"MessageId": "123","TNId": 123,"InitialDecision": "Pass","Decision": "Pass","ErrorCode": null,"ErrorMessage": null,"RuleOutcomes": [{"RuleName": "Test Rule","Outcome": true,"Score": 100}],"TNResponse": {"accountId":1234,"status": {"code": "AWAITING_RESPONSE","label": "AWAITING_RESPONSE"},"decision": {"code": "AWAITING_RESPONSE","label": "AWAITING_RESPONSE"},"Applications": [{"uid": "123","auditReference": "123","runId": 123,"journeyId": {"id": 123,"name": "Test Journey"},"organisationId": {"id": 123},"country": "USA","user": {"id": 123,"name": "Test User"},"nameReference": "Test Name","riskLevel": "High","journeyType": {"id": 123,"label": "Test Journey"},"startDateTime": "2023-03-15T10:05:44.475Z","endDateTime": "2023-03-15T10:05:44.475Z","progressStatus": {"code": "Pass","label": "Pass"},"decision": {"code": "Pass","label": "Pass"},"rulesetOutcomes": [{"reference": "Test Reference","score": 100,"ruleOutcomes": [{"RuleName": "Test Rule","Outcome": true,"Score": 100}],"riskLevel": "High"}],"links": [{"code": "Test Code","url": "http://test.com"}]}]}}';

        pageRef.getParameters().put('id',String.valueOf(opp.Id));
        ApexPages.StandardController sc = new ApexPages.StandardController(opp);     
        BAA_Application_Signed_Controller controller = new BAA_Application_Signed_Controller();
        controller.opportunityId = opp.Id;
        controller.setup();

        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new ARBCustomerAMLAPIMock(response1));
        controller.SubmitToDe();
        Test.stopTest();

        controller.complete();

        
        
        
        System.debug('hppOpp:' +hppOpp);
        System.debug('Controller:' +controller); 
        
       
        
        
    }
    
    @isTest static void noevtMethod(){
    		
        Event__c evt = new Event__c(Name = 'Test Event');
		insert evt;
 
         Account ac= new Account(FirstName = 'Joe', LastName = 'Bloggs', Title_Other__c = 'Mr', BillingStreet = 'A\nB', ShippingStreet = 'A\nB', PersonMailingStreet = 'A\nB', Layers_of_Ownership__c  ='1 layer of ownership or less', 
                                Length_of_Establishment__c  = 'Over 3 years', Balance_Sheet_000s__c = 'Under £2.5m', Sanctioned_Individual_Check__c = 'No true match identified', 
                                Previously_Exited_or_Declined__c = 'No true match identified',  Source_of_Funds__c = 'Account funded from a bank account in the UK', 
                                Nature_of_Business_NPAA__c = 'Club, Association or Community', Face_to_face_Contact__c  = 'No UBO or Significant Controller met face to face', 
                                Politically_Exposed_Company__c = 'No True Match', Negative_News_Screening__c = 'No true match identified', Organisation_type__c = 'Limited Company', 
                                Organisation_Domicile__c =   '', High_risk_prohibited_sanctioned_countr__c = 'United Kingdom', HR_Prohibited_sanctioned_COR_for_UBOs_I__c = 'United Kingdom', 
                                Customer_Type__c = 'Limited Company',Gender__c ='Male',Marital_Status__c= 'Married',Date_of_Birth__c= Date.today()-7300,
                                UK_Citizen__c = 'No',ID_Evidence__c = 'Contact Center',ID_Serial_No__c = '123AA0',Proof_of_Address__c='Not Provided');
        
        insert ac;
        
        Opportunity opp = new Opportunity(closedate = date.today(), AccountId = ac.id, Name = 'Test Opp', Interested_in__c = 'TestA', Purchase_price_market_value__c = 300000, Finance_Required__c = 100000, 
                                          Term_of_Finance__c=25, number_of_people_applying__c = 1, Source_of_Funds__c = 'Account funded from a bank account in the UK', StageName = 'Personal Details');
        
        insert opp;
        
        
        String response1 = '{"MessageId": "123","TNId": 123,"InitialDecision": "Pass","Decision": "Pass","ErrorCode": null,"ErrorMessage": null,"RuleOutcomes": [{"RuleName": "Test Rule","Outcome": true,"Score": 100}],"TNResponse": {"accountId":1234,"status": {"code": "AWAITING_RESPONSE","label": "AWAITING_RESPONSE"},"decision": {"code": "AWAITING_RESPONSE","label": "AWAITING_RESPONSE"},"Applications": [{"uid": "123","auditReference": "123","runId": 123,"journeyId": {"id": 123,"name": "Test Journey"},"organisationId": {"id": 123},"country": "USA","user": {"id": 123,"name": "Test User"},"nameReference": "Test Name","riskLevel": "High","journeyType": {"id": 123,"label": "Test Journey"},"startDateTime": "2023-03-15T10:05:44.475Z","endDateTime": "2023-03-15T10:05:44.475Z","progressStatus": {"code": "Pass","label": "Pass"},"decision": {"code": "Pass","label": "Pass"},"rulesetOutcomes": [{"reference": "Test Reference","score": 100,"ruleOutcomes": [{"RuleName": "Test Rule","Outcome": true,"Score": 100}],"riskLevel": "High"}],"links": [{"code": "Test Code","url": "http://test.com"}]}]}}';

        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new ARBCustomerAMLAPIMock(response1));        
        //BAA_Application_Signed_Controller_Ltng.SubmitToDe(evt.Id);
        Test.stopTest();
    }
   
   @isTest
   static void testMethodtwoapplicants() {
        
        Event__c evt = new Event__c(Name = 'Test Event');
		insert evt;
 
         Account ac= new Account(FirstName = 'Joe', LastName = 'Bloggs', Title_Other__c = 'Mr', BillingStreet = 'A\nB', ShippingStreet = 'A\nB', PersonMailingStreet = 'A\nB', Layers_of_Ownership__c  ='1 layer of ownership or less', 
                                Length_of_Establishment__c  = 'Over 3 years', Balance_Sheet_000s__c = 'Under £2.5m', Sanctioned_Individual_Check__c = 'No true match identified', 
                                Previously_Exited_or_Declined__c = 'No true match identified',  Source_of_Funds__c = 'Account funded from a bank account in the UK', 
                                Nature_of_Business_NPAA__c = 'Club, Association or Community', Face_to_face_Contact__c  = 'No UBO or Significant Controller met face to face', 
                                Politically_Exposed_Company__c = 'No True Match', Negative_News_Screening__c = 'No true match identified', Organisation_type__c = 'Limited Company', 
                                Organisation_Domicile__c =   '', High_risk_prohibited_sanctioned_countr__c = 'United Kingdom', HR_Prohibited_sanctioned_COR_for_UBOs_I__c = 'United Kingdom', 
                                Customer_Type__c = 'Limited Company',Gender__c ='Male',Marital_Status__c= 'Married',Date_of_Birth__c= Date.today()-7300,
                                UK_Citizen__c = 'No',ID_Evidence__c = 'Contact Center',ID_Serial_No__c = '123AA0',Proof_of_Address__c='Not Provided');
        
        insert ac;
        
        Opportunity opp = new Opportunity(closedate = date.today(), AccountId = ac.id, Name = 'Test Opp', Interested_in__c = 'TestA', Purchase_price_market_value__c = 300000, Finance_Required__c = 100000, 
                                          Term_of_Finance__c=25, number_of_people_applying__c = 1, Source_of_Funds__c = 'Account funded from a bank account in the UK', StageName = 'Personal Details');
        
        insert opp;
        
        EventLog__c eventLog = new EventLog__c();
        eventLog.Name = 'Event Log';
        eventLog.Event__c = evt.Id;
        eventLog.Opportunity__c = opp.Id;
        insert eventLog;
		
		 Applicant__c applicant1 = new Applicant__c(Opportunity__c = opp.Id,Prospect_Customer__c= ac.Id);
        Applicant__c applicant2 = new Applicant__c(Opportunity__c = opp.Id,Prospect_Customer__c= ac.Id);
		List<Applicant__c> applicantList = new List<Applicant__c>();
       	applicantList.add(applicant1);
       	applicantList.add(applicant2);
		insert applicantList;
        
        String response1 = '{"MessageId": "123","TNId": 123,"InitialDecision": "Pass","Decision": "Pass","ErrorCode": null,"ErrorMessage": null,"RuleOutcomes": [{"RuleName": "Test Rule","Outcome": true,"Score": 100}],"TNResponse": {"accountId":1234,"status": {"code": "AWAITING_RESPONSE","label": "AWAITING_RESPONSE"},"decision": {"code": "AWAITING_RESPONSE","label": "AWAITING_RESPONSE"},"Applications": [{"uid": "123","auditReference": "123","runId": 123,"journeyId": {"id": 123,"name": "Test Journey"},"organisationId": {"id": 123},"country": "USA","user": {"id": 123,"name": "Test User"},"nameReference": "Test Name","riskLevel": "High","journeyType": {"id": 123,"label": "Test Journey"},"startDateTime": "2023-03-15T10:05:44.475Z","endDateTime": "2023-03-15T10:05:44.475Z","progressStatus": {"code": "Pass","label": "Pass"},"decision": {"code": "Pass","label": "Pass"},"rulesetOutcomes": [{"reference": "Test Reference","score": 100,"ruleOutcomes": [{"RuleName": "Test Rule","Outcome": true,"Score": 100}],"riskLevel": "High"}],"links": [{"code": "Test Code","url": "http://test.com"}]}]}}';
		NPAABaseEventController.Wrapper npaaWrap = new NPAABaseEventController.Wrapper();
        npaaWrap.CreatedEvent = eventLog;
        npaaWrap.NextEventUrl = 'www.test.com';
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new ARBCustomerAMLAPIMock(response1));        
        BAA_Application_Signed_Controller_Ltng.SubmitToDe(eventLog.Id);
        BAA_Application_Signed_Controller_Ltng.complete(npaaWrap);
        Test.stopTest();
    } 
}