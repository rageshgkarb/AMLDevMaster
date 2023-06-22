@IsTest
public class CAA_DE_Test {
    
    @Testsetup
    static void dataSetup() {
        z_DirectorHelper dHelp = new z_DirectorHelper();
        dHelp.AIPEvent();
        dHelp.ApplicationEvent();
        ProductEventDirector__c director = dHelp.Build();
        
        Account ac= new Account(FirstName = 'Joe', LastName = 'Bloggs', Title_Other__c = 'Mr', BillingStreet = 'A\nB', ShippingStreet = 'A\nB', PersonMailingStreet = 'A\nB', Layers_of_Ownership__c  ='1 layer of ownership or less', 
                                Length_of_Establishment__c  = 'Over 3 years', Balance_Sheet_000s__c = 'Under £2.5m', Sanctioned_Individual_Check__c = 'No true match identified', 
                                Previously_Exited_or_Declined__c = 'No true match identified',  Source_of_Funds__c = 'Account funded from a bank account in the UK', 
                                Nature_of_Business_NPAA__c = 'Club, Association or Community', Face_to_face_Contact__c  = 'No UBO or Significant Controller met face to face', 
                                Politically_Exposed_Company__c = 'No True Match', Negative_News_Screening__c = 'No true match identified', Organisation_type__c = 'Limited Company', 
                                Organisation_Domicile__c =   '', High_risk_prohibited_sanctioned_countr__c = 'United Kingdom', HR_Prohibited_sanctioned_COR_for_UBOs_I__c = 'United Kingdom',                            
                                Customer_Type__c = 'Limited Company', TN_accountId__c= '947169', TN_Manual_Screening_Required__c= '',Gender__c ='Male',Marital_Status__c= 'Married',Date_of_Birth__c= Date.today()-7300,
                                UK_Citizen__c = 'No',ID_Evidence__c = 'Contact Center',ID_Serial_No__c = '123AA0',Proof_of_Address__c='Not Provided');
        insert ac;
        
        IBB_Product_Set__c productSet = new IBB_Product_Set__c();
        productSet.Name = 'Test'; 
        productSet.Max_No_of_Applicants__c = 4;
        productSet.ProductSetType__c = 'btl';
        insert productSet;
        
        IBB_Product__c product = new IBB_Product__c();
        product.Name = 'ANC-';
        product.IBb_product_set__c =productSet.id;
        product.Max_finance_to_value_FTV__c = 80;
        product.ShowOnAIP__c = true;
        product.Benchmark_rate__c = 4;
        product.Type_of_Product__c = 'Current Account';
        product.Category_of_Product__c = 'Current Account';
        insert product;
        
        Asset_Relationship__c ar = new Asset_Relationship__c();
        // ar.Account_with_IBB__c = accountWithIBBId;
        ar.Prospect_Customer__c = ac.Id;
        ar.Relationship_To_Primary_Applicant1__c = 'Relation to Customer';
        //ar.Primary_Account_Holder__c = primaryAccount;
        ar.Is_Active__c = true;
        
        Event__c evt = new Event__c(Name = 'Test Event');
        insert evt;       
        
        
        ProductEventDirector__c productDirector = new ProductEventDirector__c(Name = 'ProductD',Flow_Events__c ='[{"Status":"","Stage":"Product Selection","Sequence":0,"EventName":"BAA Business Details","EventLogName":"","EventId":"'+evt.Id+'","Description":"Business Details","Context":null},{"Status":"","Stage":"Business Details","Sequence":100,"EventName":"BAA Personal Details","EventLogName":"","EventId":"'+evt.Id+'","Description":"Personal Details","Context":null}]');
        insert productDirector;
        
        Opportunity opp = new Opportunity(closedate = date.today(), AccountId = ac.id, Name = 'Test Opp', Interested_in__c = 'TestA', Purchase_price_market_value__c = 300000, Finance_Required__c = 100000, 
                                          Term_of_Finance__c=25, number_of_people_applying__c = 1, Source_of_Funds__c = 'Account funded from a bank account in the UK', StageName = 'Personal Details', ProductEventDirector__c=productDirector.Id);
        
        insert opp;
        
      /*opportunity o= new opportunity();
        o.name = 'test';
        o.AccountId=acc.id;
        o.IBB_Product__c=product.Id;
        o.stagename = 'Decision Response';
        o.closedate = date.today();
        o.ProductEventDirector__c = director.id;
        o.caa_decision__c = 'Referred';
        o.From_Upload__c = true;
        o.Status_HPP_CAA__c='Declaration Completed';
        o.US_Person_Signed_App_Form_Received__c=true;
        o.RecordTypeId='012D0000000QWmKIAW';
        insert o;
        
        Eventlog__c log = new Eventlog__c();
        log.Name='CAA RM';
        log.event__c = 'a2AD000000A00CAMAZ';
        log.eventstatus__c = 'Open';
        log.isexpired__c = false;
        log.opportunity__c = o.id;
        insert log;   */ 
        
        
        
        EventLog__c eventLog = new EventLog__c();
        eventLog.Name = 'Event Log';
        eventLog.Event__c = evt.Id;
        eventLog.Opportunity__c = opp.Id;
        eventLog.EventStatus__c = 'Open';
        eventLog.isExpired__c = True;
        insert eventLog;
        List<Applicant__c> applist = new List<Applicant__c>();
        Applicant__c applicant1 = new Applicant__c(Opportunity__c = opp.Id,Prospect_Customer__c= ac.Id);
        applist.add(applicant1);
        /*Applicant__c applicant2 = new Applicant__c(Opportunity__c = opp.Id,Prospect_Customer__c= ac.Id);
		applist.add(applicant2); */
        insert applist;
    }
    
    @IsTest
    static void callDETestMethod(){
        Opportunity opp = [select CAA_Decision__c, Status_HPP_CAA__c,US_Person_Signed_App_Form_Received__c,RecordTypeId, Name from Opportunity];
        string response = '{"Test":"Response"}';
        Eventlog__c evlog = [select id,Name,Event__c,Opportunity__c,EventStatus__c,isExpired__c from Eventlog__c];
        evlog.isExpired__c = false;
        evlog.EventStatus__c = 'Open';
        system.debug('evlog in Test method::'+evlog);
        
        //  String response1 = '{"MessageId": "123","TNId": 123,"InitialDecision": "Pass","Decision": "Pass","ErrorCode": null,"ErrorMessage": null,"RuleOutcomes": [{"RuleName": "Test Rule","Outcome": true,"Score": 100}],"TNResponse": {"accountId":1234,"status": {"code": "DE_SUCCESS","label": "DE_SUCCESS"},"decision": {"code": "DE_SUCCESS","label": "DE_SUCCESS"},"Applications": [{"uid": "123","auditReference": "123","runId": 123,"journeyId": {"id": 123,"name": "Test Journey"},"organisationId": {"id": 123},"country": "USA","user": {"id": 123,"name": "Test User"},"nameReference": "Test Name","riskLevel": "High","journeyType": {"id": 123,"label": "Test Journey"},"startDateTime": "2023-03-15T10:05:44.475Z","endDateTime": "2023-03-15T10:05:44.475Z","progressStatus": {"code": "Pass","label": "Pass"},"decision": {"code": "Pass","label": "Pass"},"rulesetOutcomes": [{"reference": "Test Reference","score": 100,"ruleOutcomes": [{"RuleName": "Test Rule","Outcome": true,"Score": 100}],"riskLevel": "High"}],"links": [{"code": "Test Code","url": "http://test.com"}]}]}}';
        String response1 = '{"MessageId": "123","TNId": 123,"InitialDecision": "Pass","Decision": "Pass","ErrorCode": null,"ErrorMessage": null,"RuleOutcomes": [{"RuleName": "Test Rule","Outcome": true,"Score": 100}],"TNResponse": {"accountId":1234,"status": {"code": "AWAITING_RESPONSE","label": "AWAITING_RESPONSE"},"decision": {"code": "AWAITING_RESPONSE","label": "AWAITING_RESPONSE"},"Applications": [{"uid": "123","auditReference": "123","runId": 123,"journeyId": {"id": 123,"name": "Test Journey"},"organisationId": {"id": 123},"country": "USA","user": {"id": 123,"name": "Test User"},"nameReference": "Test Name","riskLevel": "High","journeyType": {"id": 123,"label": "Test Journey"},"startDateTime": "2023-03-15T10:05:44.475Z","endDateTime": "2023-03-15T10:05:44.475Z","progressStatus": {"code": "Pass","label": "Pass"},"decision": {"code": "Pass","label": "Pass"},"rulesetOutcomes": [{"reference": "Test Reference","score": 100,"ruleOutcomes": [{"RuleName": "Test Rule","Outcome": true,"Score": 100}],"riskLevel": "High"}],"links": [{"code": "Test Code","url": "http://test.com"}]}]}}';
        
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new ARBCustomerAMLAPIMock(response1));        
        CAA_DE.CallDE(evlog.id);
        CAA_DE.CloseOpenSystemErrorCases(opp.id);
        Test.stopTest();
        
        /* Test.startTest();
        Test.setMock(HttpCalloutMock.class, new DEResponseMock(response));
        CAA_DE.CallDE(evlog.id);  */
        } 
    
    @IsTest
    static void callDETestMethodApplicantError(){
        Opportunity opp = [select CAA_Decision__c, Status_HPP_CAA__c,US_Person_Signed_App_Form_Received__c,RecordTypeId, Name from Opportunity];
        System.debug('0opp'+opp);
        Account acc = [select Id, name from Account];
        Eventlog__c evlog = [select id,Name,Event__c,Opportunity__c,EventStatus__c,isExpired__c from Eventlog__c];
        evlog.isExpired__c = false;
        evlog.EventStatus__c = 'Open';
        system.debug('evlog in Test method::'+evlog);
        
        String response = '{"MessageId": "123","TNId": 123,"InitialDecision": "ERROR","Decision": "ERROR","ErrorCode": null,"ErrorMessage": null,"RuleOutcomes": [{"RuleName": "Test Rule","Outcome": true,"Score": 100}],"TNResponse": {"accountId":1234,"status": {"code": "ERROR","label": "ERROR"},"decision": {"code": "ERROR","label": "ERROR"},"Applications": [{"uid": "123","auditReference": "123","runId": 123,"journeyId": {"id": 123,"name": "Test Journey"},"organisationId": {"id": 123},"country": "USA","user": {"id": 123,"name": "Test User"},"nameReference": "Test Name","riskLevel": "High","journeyType": {"id": 123,"label": "Test Journey"},"startDateTime": "2023-03-15T10:05:44.475Z","endDateTime": "2023-03-15T10:05:44.475Z","progressStatus": {"code": "Pass","label": "Pass"},"decision": {"code": "Pass","label": "Pass"},"rulesetOutcomes": [{"reference": "Test Reference","score": 100,"ruleOutcomes": [{"RuleName": "Test Rule","Outcome": true,"Score": 100}],"riskLevel": "High"}],"links": [{"code": "Test Code","url": "http://test.com"}]}]}}';
        
        List<Applicant__c> applist = new List<Applicant__c>();
        Applicant__c applicant1 = new Applicant__c(Opportunity__c = opp.Id,Prospect_Customer__c= acc.Id);
        //applist.add(applicant1);
       // Applicant__c applicant2 = new Applicant__c(Opportunity__c = opp.Id,Prospect_Customer__c= acc.Id);
        //applist.add(applicant2); 
        //insert applist;
        insert applicant1;
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new ARBCustomerAMLAPIMock(response));        
        CAA_DE.CallDE(evlog.id);
        Test.stopTest();
    }
    
    
    
    @IsTest
    static void callDETestSuccessApplicant(){
        Opportunity opp = [select CAA_Decision__c, Status_HPP_CAA__c,US_Person_Signed_App_Form_Received__c,RecordTypeId, Name from Opportunity];
        Account acc = [select Id, name from Account];
        Eventlog__c evlog = [select id,Name,Event__c,Opportunity__c,EventStatus__c,isExpired__c from Eventlog__c];
        evlog.isExpired__c = false;
        evlog.EventStatus__c = 'Open';
        system.debug('evlog in Test method::'+evlog);
        
        String response = '{"MessageId": "123","TNId": 123,"InitialDecision": "Pass","Decision": "ACCEPT","ErrorCode": null,"ErrorMessage": null,"RuleOutcomes": [{"RuleName": "Test Rule","Outcome": true,"Score": 100}],"TNResponse": {"accountId":1234,"status": {"code": "ACCEPT","label": "ACCEPT"},"decision": {"code": "ACCEPT","label": "ACCEPT"},"Applications": [{"uid": "123","auditReference": "123","runId": 123,"journeyId": {"id": 123,"name": "Test Journey"},"organisationId": {"id": 123},"country": "USA","user": {"id": 123,"name": "Test User"},"nameReference": "Test Name","riskLevel": "High","journeyType": {"id": 123,"label": "Test Journey"},"startDateTime": "2023-03-15T10:05:44.475Z","endDateTime": "2023-03-15T10:05:44.475Z","progressStatus": {"code": "Pass","label": "Pass"},"decision": {"code": "Pass","label": "Pass"},"rulesetOutcomes": [{"reference": "Test Reference","score": 100,"ruleOutcomes": [{"RuleName": "Test Rule","Outcome": true,"Score": 100}],"riskLevel": "High"}],"links": [{"code": "Test Code","url": "http://test.com"}]}]}}';
        
        List<Applicant__c> applist = new List<Applicant__c>();
        Applicant__c applicant1 = new Applicant__c(Opportunity__c = opp.Id,Prospect_Customer__c= acc.Id);
        applist.add(applicant1);
        Applicant__c applicant2 = new Applicant__c(Opportunity__c = opp.Id,Prospect_Customer__c= acc.Id);
        applist.add(applicant2); 
        insert applist;
        
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new ARBCustomerAMLAPIMock(response));        
        CAA_DE.CallDE(evlog.id);
        Test.stopTest();
    }  
    
    
    @IsTest
    static void callDETestReferredApplicant(){
        Opportunity opp = [select CAA_Decision__c, Status_HPP_CAA__c,US_Person_Signed_App_Form_Received__c,RecordTypeId, Name from Opportunity];
        Account acc = [select Id, name from Account];
        Eventlog__c evlog = [select id,Name,Event__c,Opportunity__c,EventStatus__c,isExpired__c from Eventlog__c];
        evlog.isExpired__c = false;
        evlog.EventStatus__c = 'Open';
        system.debug('evlog in Test method::'+evlog);
        
        String response = '{"MessageId": "123","TNId": 123,"InitialDecision": "Pass","Decision": "ERROR","ErrorCode": null,"ErrorMessage": null,"RuleOutcomes": [{"RuleName": "Test Rule","Outcome": true,"Score": 100}],"TNResponse": {"accountId":1234,"status": {"code": "REFERRED","label": "REFERRED"},"decision": {"code": "REFERRED","label": "REFERRED"},"Applications": [{"uid": "123","auditReference": "123","runId": 123,"journeyId": {"id": 123,"name": "Test Journey"},"organisationId": {"id": 123},"country": "USA","user": {"id": 123,"name": "Test User"},"nameReference": "Test Name","riskLevel": "High","journeyType": {"id": 123,"label": "Test Journey"},"startDateTime": "2023-03-15T10:05:44.475Z","endDateTime": "2023-03-15T10:05:44.475Z","progressStatus": {"code": "Pass","label": "Pass"},"decision": {"code": "Pass","label": "Pass"},"rulesetOutcomes": [{"reference": "Test Reference","score": 100,"ruleOutcomes": [{"RuleName": "Test Rule","Outcome": true,"Score": 100}],"riskLevel": "High"}],"links": [{"code": "Test Code","url": "http://test.com"}]}]}}';
        
        List<Applicant__c> applist = new List<Applicant__c>();
        Applicant__c applicant1 = new Applicant__c(Opportunity__c = opp.Id,Prospect_Customer__c= acc.Id);
        applist.add(applicant1);
        Applicant__c applicant2 = new Applicant__c(Opportunity__c = opp.Id,Prospect_Customer__c= acc.Id);
        applist.add(applicant2); 
        insert applist;
        
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new ARBCustomerAMLAPIMock(response));        
        CAA_DE.CallDE(evlog.id);
        CAA_DE.CompleteSummary(evlog.Id,opp);
        Test.stopTest();
    }
    
    /*
    @IsTest
    static void callDETestMethodApplicantDecisionBlank(){
        
        Account acc = [select Id, name from Account];
        IBB_Product__c pd = [Select Id,Name from IBB_Product__c Where Name='ANC-'];

        ProductEventDirector__c prd = [Select Id,Name from ProductEventDirector__c Where Name='ProductD'];
        Opportunity opty = new Opportunity(closedate = date.today(), AccountId = acc.id, Name = 'ANC-Current', Interested_in__c = 'TestA', Purchase_price_market_value__c = 300000, Finance_Required__c = 100000, CAA_Decision__c = '',IBB_Product__c = pd.Id,
                                           Term_of_Finance__c=25, number_of_people_applying__c = 1, Source_of_Funds__c = 'Account funded from a bank account in the UK', StageName = 'Personal Details', ProductEventDirector__c=prd.Id);
        
        insert opty;
        
        
        Opportunity opp2 = [select CAA_Decision__c, Status_HPP_CAA__c,US_Person_Signed_App_Form_Received__c,RecordTypeId, Name from Opportunity where id=: opty.Id];
        System.debug('0opp'+opp2);
        
        Event__c evt = new Event__c(Name = 'Test Event');
        insert evt; 
        
      
        EventLog__c eventLog = new EventLog__c();
        eventLog.Name = 'Event Log';
        eventLog.Event__c = evt.Id;
        eventLog.Opportunity__c = opty.Id;
        eventLog.EventStatus__c = 'Open';
        eventLog.isExpired__c = false;
        insert eventLog;
        system.debug('evlog in Test method::'+eventLog);

        
        XML_Message__c xml = new XML_Message__c();
        xml.Name = 'DecisionEngineRequest';
        xml.Type__c='Request';
        xml.Element_Name__c = 'RepaymentScheduleResponse';
        //xml.Start_Tag__c = '<RepaymentScheduleResponse>';
        //xml.End_Tag__c = 'EndTagResponse';
		xml.Active__c = True;
        xml.Service_Namespace__c = 'RepaymentScheduleResponse';
        xml.Element_Name__c = 'http://www.islamic-bank.com/';
        xml.Description__c = 'XMLResponseDescription';
        xml.Service_Name_Element__c = 'RepaymentScheduleRequestResponse';
		insert xml;
     
        
        String response = '{"MessageId": "123","TNId": 123,"InitialDecision": "","Decision": "REFER","ErrorCode": null,"ErrorMessage": null,"RuleOutcomes": [{"RuleName": "Test Rule","Outcome": true,"Score": 100}],"TNResponse": {"accountId":1234,"status": {"code": "REFER","label": "REFER"},"decision": {"code": "REFER","label": "REFER"},"Applications": [{"uid": "123","auditReference": "123","runId": 123,"journeyId": {"id": 123,"name": "Test Journey"},"organisationId": {"id": 123},"country": "USA","user": {"id": 123,"name": "Test User"},"nameReference": "Test Name","riskLevel": "High","journeyType": {"id": 123,"label": "Test Journey"},"startDateTime": "2023-03-15T10:05:44.475Z","endDateTime": "2023-03-15T10:05:44.475Z","progressStatus": {"code": "Pass","label": "Pass"},"decision": {"code": "Pass","label": "Pass"},"rulesetOutcomes": [{"reference": "Test Reference","score": 100,"ruleOutcomes": [{"RuleName": "Test Rule","Outcome": true,"Score": 100}],"riskLevel": "High"}],"links": [{"code": "Test Code","url": "http://test.com"}]}]}}';
        
        List<Applicant__c> applist = new List<Applicant__c>();
        Applicant__c applicant1 = new Applicant__c(Opportunity__c = opty.Id,Prospect_Customer__c= acc.Id);
        applist.add(applicant1);
        Applicant__c applicant2 = new Applicant__c(Opportunity__c = opty.Id,Prospect_Customer__c= acc.Id);
        applist.add(applicant2); 
        insert applist;
        
        HPP_Extended_Opportunity__c hppOpp = new HPP_Extended_Opportunity__c();
        hppOpp.Opportunity__c = opty.Id;
        
        
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new ARBCustomerAMLAPIMock(response));        
        CAA_DE.CallDE(eventLog.id);
        Test.stopTest();
    }   */
    
}