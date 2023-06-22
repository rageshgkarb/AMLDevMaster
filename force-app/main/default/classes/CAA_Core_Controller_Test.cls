@IsTest
global class CAA_Core_Controller_Test {

    @testSetup
    public static void dataSetup(){
        
        Event__c evt = new Event__c(Name = 'Test Event',CustomPageLocation__c='/apex/CAA_PersonalDetails');
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
                                         Credit_Or_Debit__c='1000', Term_of_Finance__c=25, number_of_people_applying__c = 1, Source_of_Funds__c = 'Account funded from a bank account in the UK', StageName = 'Personal Details');
        
        insert opp;
        
       Web_Integration_Log__c wlog = new Web_Integration_Log__c();
       wlog.request_output__c = '<?xml version="1.0" encoding="utf-8"?><soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema"><soap:Body><OperationResponse xmlns="http://IBB.SalesForce.OCA.Additional"><AdditionalInformationResponse><MessageType>EBSAdditionalInfoUpdate</MessageType><MessageID>a0oL00000009A7nIAE</MessageID><Status>S</Status><ErrorMessage /><WarningMessage /></AdditionalInformationResponse></OperationResponse></soap:Body></soap:Envelope>';
       wlog.Request_Action__c = 'AddJournalEntry';
       wlog.OpportunityId__c = opp.id;
       insert wlog;
        
        HPP_extended_opportunity__c hpp = new HPP_extended_opportunity__c();
        hpp.Opportunity__c=opp.id;
        insert hpp;
        
        EventLog__c eventLog = new EventLog__c();
        eventLog.Name = 'Event Log';
        eventLog.Event__c = evt.Id;
        eventLog.Opportunity__c = opp.Id;
        eventLog.EventStatus__c = 'Open';
        insert eventLog;
        
        IBB_Product_Set__c	ps = new IBB_Product_Set__c();
        ps.Name ='test';
        insert ps;
        System.debug('8= '+ps);
        
 		CongaSettings__c docu= new CongaSettings__c();
        docu.Name ='test';
        docu.Document_name__c = 'test';
        /*docu.Queries__c = '{"Queries":[{"QueryId":"a5aD0000000GmfWIAS","Order":1,"Name":"Applicant2","Alias":""}]}';
        docu.Templates__c = '{"Templates":[{"TemplateId":"a5bD0000000GmisIAC","SystemModstamp":null,"Order":0,"Name":"AIP Letter","MinApplicants":0,"AttachmentId":null}]}';
        */
        insert docu;
        
        List<CAA_Settings__c> caaSeeting = new List<CAA_Settings__c>();
        CAA_Settings__c caa = new CAA_Settings__c();
        caa.Name ='UseFITAccount';
        caa.Value__c ='YES';
        caaSeeting.add(Caa);
        CAA_Settings__c caa1 = new CAA_Settings__c();
        caa1.Name ='UseISAFITAccount';
        caa1.Value__c ='YES';
        caaSeeting.add(Caa1);
        insert caaSeeting;
        
        IBB_Product__c prod = new IBB_Product__c();

        prod.congaISATransfer__c = docu.Id;
        prod.Staff_Only_Product__c = 'yes';
        prod.Term__c= '6 Months';
        prod.Max_finance_to_value_FTV__c= 22.1;
        prod.Rental_Rate_Type__c = 'F';
        prod.Benchmark_rate__c= 22.22;
        prod.Rent_or_occupancy__c= 'rent';
        prod.Offer_Letter_Version__c='Pre-September 2014';
        prod.Fixed_or_Discounted__c='Fixed';
        prod.Type_of_product_for_solicitor_letter__c ='HPP';
        prod.Product_live_date__c= system.today();
        prod.Short_Product_Name__c= 'testproduct';
        prod.Account_Type__c='Bid Bonds';
        prod.Product_code__c= 'The IBB product code';

        prod.Category_of_Product__c= 'Current Account';	
        prod.Type_of_Product__c= 'Current Account';
        prod.Product_Description__c= 'testproduct';
        prod.Profit_calculated__c='monthly';
        prod.Profit_Rate__c= 3.3574;
        prod.Profit_accrued__c= 'monthly';
        prod.Profit_paid_to__c='External account';
        prod.Statement_frequency__c='Monthly';
        prod.Name='Testing Product';
        prod.DocuGen_Liability_App_1_CAA_Face2Face__c = docu.Id;
        prod.DocuGen_Liability_App_2_CAA_Face2Face__c = docu.Id;
        prod.DocuGen_Liability_App_3_CAA_Face2Face__c = docu.Id;
        prod.Conga_Liability_App_1_caa__c = docu.Id;
        prod.Conga_Liability_App_2_caa__c = docu.Id;
        prod.Conga_Liability_App_3_caa__c = docu.Id;
        prod.Conga_Failed_EKYC_Letter__c = docu.Id;
        prod.IBB_Product_Set__c = ps.Id;
        insert prod;     
        
        XML_Message__c xml = new XML_Message__c();
        xml.Name = 'AddJournalEntry1000';
        xml.Type__c='Request';
        xml.Element_Name__c = 'RepaymentScheduleResponse';
        //xml.Start_Tag__c = '<RepaymentScheduleResponse>';
        //xml.End_Tag__c = 'EndTagResponse';
		xml.Active__c = True;
        xml.Service_Namespace__c = 'RepaymentScheduleResponse';
        xml.Element_Name__c = 'http://www.islamic-bank.com/';
        xml.Description__c = 'XMLResponseDescription';
        xml.Service_Name_Element__c = 'RepaymentScheduleRequestResponse';
        xml.Buffered__c = True;
		insert xml;
    }

    @IsTest
    static void CAA_ControllerTestOne(){
        z_DirectorHelper dHelp = new z_DirectorHelper();
        dHelp.AIPEvent();
        dHelp.ApplicationEvent();
        ProductEventDirector__c director = dHelp.Build();  
        
        IBB_Product__c pd = [Select Id, Name,ProductEventDirector__c from IBB_Product__c where Name = 'Testing Product'];
        pd.ProductEventDirector__c = director.Id;
        update pd;
        
        Opportunity o = [Select Id,Name, IBB_Product__c,Credit_Or_Debit__c,ProductEventDirector__c from Opportunity limit 1];
        o.IBB_Product__c = pd.Id;
        o.CAA_Decision__c = 'Decline';
        o.ProductEventDirector__c = director.Id;
        update o;
        
        Account acc = [Select FirstName, Id from Account Where FirstName = 'Joe'];
        Account act = new Account();
        act.Name = 'Bravo';
        insert act;
        
        Contact ct = new Contact();
        ct.Salutation = 'Mr';
        ct.LastName = 'Contact';
        ct.AccountId = act.Id;
        insert ct;
        
        Card__c card = new Card__c();
        card.Name = 'Card1230';
        card.Contact__c = ct.Id;
        insert card;
        
        
        Transaction__c txn  = new Transaction__c();
        txn.Name = 'txn';
        txn.Card__c = card.Id;
        insert txn;
        
       IBBOpportunityPayment__c oppPayment = new IBBOpportunityPayment__c ();
        oppPayment.PaymentTransaction__c = txn.Id;
        insert oppPayment;

        
        EventLog__c evtLog = [select Id,event__c,opportunity__c, Opportunity__r.name, Opportunity__r.No_of_Applicants__c, Opportunity__r.IBB_product__c, 
                              Opportunity__r.IBB_product__r.name, Opportunity__r.Application_Reference_Number__c,
                              Opportunity__r.US_Person_Signed_App_Form_Received__c from eventlog__c];
        
        System.debug('evtLog::'+evtLog);
                    
        Web_Integration_Log__c webLog = [Select request_output__c,OpportunityId__c,Request_Action__c From Web_Integration_Log__c];
        
        XML_Message__c xmlMessage = [Select Id,Name,Buffered__c,Type__c,Active__c,Service_Namespace__c,Element_Name__c,Description__c,Service_Name_Element__c
                                    From XML_Message__c];
        
        //system.debug(acc);
        Eventlog__c log = [Select Id,opportunity__c,event__c from Eventlog__c limit 1];
        External_Session__c es = new External_Session__c();
        es.Active_Date__c= date.today();
        es.Account__c=acc.id;
        es.Opportunity__c= o.id;
        insert es;
        
        Applicant__c apl =  new Applicant__c();
        apl.Prospect_Customer__c=acc.id;
        apl.Opportunity__c=log.opportunity__c;
        insert apl;
        
        Case cs = new Case();
        cs.Opportunity__c = o.Id;
        cs.Referral_Decision__c = '';
        insert cs;
        
        
         WebLogClass wl = new WebLogClass();
         wl.upsertWebLogs();
         wl.insertCases();
         wl.upsertBuffers();
       
       
        CAA_Settings__c caaSettings = [Select Id, Name from CAA_Settings__c Where Name = 'UseISAFITAccount'];
        CAA_Settings__c caaSettings1 = [Select Id, Name from CAA_Settings__c Where Name = 'UseFITAccount'];
		caaSettings1.Value__c = 'NO';
        update caaSettings1;
        
        List<External_Session__c> sessions = [select id,is_active__c, Active_Date__c, Expires__c, Account__c, Opportunity__c from External_Session__c Limit 1];
        String cookieSession = CAA_Helper.EncryptData(sessions[0].Id);
        
        PageReference myVfPage = Page.CAA_Core;
        Test.setCurrentPage(myVfPage);
        Cookie cookie = new Cookie('applicationId', cookieSession, null, -1, false);
        ApexPages.currentPage().setCookies(new Cookie[]{cookie});
        //ApexPages.currentPage().getCookies().set('applicationId',String.Valueof(cookieSession));
        CAA_Core_Controller core = New CAA_Core_Controller();
        String m_SessionId = core.m_SessionId;
        String ExistingCustomerValue = core.ExistingCustomerValue;
        //Boolean IsABranch = core.IsABranch;
        String isYPSAAccount = core.isYPSAAccount;
        String SessionId = core.SessionId;
        Opportunity Opp = core.opp;
        core.m_EventLogId = log.Id;
        core.m_AccountId = acc.Id;
        string AccountId = core.AccountId;
        List<Campaign> Campaigns = core.Campaigns;
        IBB_Product__c Product = core.Product; 
        Boolean IsYPSA = core.IsYPSA;
        Boolean IsFTD = core.IsFTD;
        Boolean IsFTDISA = core.IsFTDISA;
        Boolean UseFITForISA = core.UseFITForISA;
        boolean UseFIT = core.UseFIT;
        string titleText = core.titleText;
        Boolean IsCurrentAccount = core.IsCurrentAccount;
        Boolean IsANC = core.IsANC;
        List<CAA_Data.KeyValue> InterestedIn = core.InterestedIn;
        List<CAA_Data.KeyValue> Titles = core.Titles;
        //List<CAA_Data.ProductSuitabilityData> GetProductSuitability = core.GetProductSuitability();
        
        core.Setup();
        Boolean IsFTDSetup = core.IsFTDSetup;
        Boolean IsFITSetup = core.IsFITSetup;
        core.FTD_Setup();
        

        core.EligibilitySetup();
        core.ISA_Transfer_Init();
        core.Product_Screen_Init();
        String EncOppId = core.EncOppId;
        core.SendToHost();
        core.Declaration_Summary();
        core.Declaration_Init();
        Boolean ShowImage = core.ShowImage;
        Boolean PageUsesKendo = core.PageUsesKendo;
        boolean showDirectSavingsAccountTC = core.showDirectSavingsAccountTC;
        boolean show60DayNoticeAccountTC = core.show60DayNoticeAccountTC;
        boolean show120DayNoticeAccountTC = core.show120DayNoticeAccountTC;
        boolean showOnDemandSavingsAccountTC = core.showOnDemandSavingsAccountTC;
        boolean showYPSATC = core.showYPSATC;
        boolean showISA = core.showISA;
        boolean showInstantISA = core.showInstantISA;
        boolean showFTDISA = core.showFTDISA;
        boolean showYPNATC = core.showYPNATC;
        boolean showFixedTermAccountTC = core.showFixedTermAccountTC;
        boolean showSmallFixedTermAccountTC = core.showSmallFixedTermAccountTC;
        boolean showCurrentText = core.showCurrentText;
        boolean showSavingText = core.showSavingText;
        boolean showCurrentAccountTC = core.showCurrentAccountTC;
        CAA_Data.AddNewApplicantData appdata = new CAA_Data.AddNewApplicantData();
        appdata.FirstName = 'Applicant Account DM1';
        appdata.LastName = 'Force26';
        appdata.Title = 'xyz'; 
        CAA_Data.ProductSelectedData data = new CAA_Data.ProductSelectedData();
        data.ProductId = Product.Id;
        data.PurposeOfAccount = 'Loan';
        data.NumberOfApplicants = 20;  
        data.Deposit =123.01;
        data.AccountId =acc.Id;
        CAA_Core_Controller ob = new CAA_Core_Controller();
        data.OpportunityId= o.Id;
        data.Receive_Salary_Benefits = true;
        data.Pay_Bills_Expenses= true;
        data.Domestic_Transfers_In_Out= true;
        data.International_Transfer_In_Out= true;
        data.Cash_Deposit_In_Out= true;
        data.Saving_Goals= true;
        data.Over16= 'test';
        data.Regular_payment_amount_c = 123.23;
        data.Payment_Frequency_c='test';
        data.Direct_debit_date_day_c='test';
        data.Name_of_current_Bank_Building_Society_c='test';
        data.Sort_Code_c = '123';
        data.HasRegularPayment= 'test';
        
        String logId = CAA_Helper.EncryptData(log.id);
                
        User u = [select id,isactive,name from user where usertype='Guest' AND name like '%External CAA%'];
        
        External_Session__c exse = new External_Session__c();
        exse.Active_Date__c = Date.today();
        //exse.Expires__c =Date.today().adddays(1);
        exse.Opportunity__c=o.id;
        exse.Account__c =acc.id;
        insert exse;
        
        Campaign cam=new Campaign();
        cam.name='test';
        cam.IsActive=true;
        cam.StartDate=Date.today();
        cam.Type='TV';
        insert cam;
        
        CAA_Data.PersonalDetailsCompleteData personaldata= new CAA_Data.PersonalDetailsCompleteData();
        personaldata.PaperStatements = 'test';
        personaldata.Campaign = cam.Id;
        personaldata.EventLogId =logId;
        personaldata.ApprovalUser =userinfo.getUserId();
        personaldata.isEDD = true;
        
        CAA_Data.PersonalDetailsCompleteData personaldata2= new CAA_Data.PersonalDetailsCompleteData();
        personaldata2.PaperStatements = 'test';
        personaldata2.Campaign = cam.Id;
        personaldata2.EventLogId =logId;
        personaldata2.ApprovalUser =userinfo.getUserId();
        personaldata2.isEDD = true;
        
        CAA_Data.PersonalDetailsCompleteData personaldata3= new CAA_Data.PersonalDetailsCompleteData();
        personaldata3.PaperStatements = 'test';
        personaldata3.Campaign = cam.Id;
        personaldata3.EventLogId =logId;
        personaldata3.ApprovalUser =userinfo.getUserId();
        personaldata3.isEDD = true;
        
        CAA_Data.PersonalDetailsCompleteData personaldata4= new CAA_Data.PersonalDetailsCompleteData();
        personaldata4.PaperStatements = 'test';
        personaldata4.Campaign = cam.Id;
        personaldata4.EventLogId =logId;
        personaldata4.ApprovalUser =userinfo.getUserId();
        personaldata4.isEDD = true;
        
        data.accountid = CAA_Helper.EncryptData(acc.id);
        CAA_Data.PrimaryApplicantData app = new CAA_Data.PrimaryApplicantData();
        app.Id = data.accountid;
        app.HasEmail  = false;
        app.HasMail = false;
        app.HasPhone = false;
        app.HasSMS = false;
        app.LastName = 'test';
	    CAA_Data.MyDate md = new CAA_Data.MyDate(system.today());
        app.Date_Employment_Commenced_c = md;
        app.Date_of_birth_c =  new CAA_Data.MyDate(Date.newInstance(1994, 01, 01));
        app.Document_issue_date_c = md;
        app.Visa_expiry_date_c = new CAA_Data.MyDate(system.today()+30);
        app.Date_moved_to_address_c = new CAA_Data.MyDate(system.today()-20);
        app.Date_moved_to_previous_address_c = new CAA_Data.MyDate(system.today()-200);
        app.Self_Cert_Acknowledged_c  = false;
        
        CAA_Data.PrimaryApplicantData app2 = new CAA_Data.PrimaryApplicantData();
        app2.Id = data.accountid;
        app2.HasEmail  = false;
        app2.HasMail = false;
        app2.HasPhone = false;
        app2.HasSMS = false;
        app2.LastName = 'test';
	    CAA_Data.MyDate md2 = new CAA_Data.MyDate(system.today());
        app2.Date_Employment_Commenced_c = md2;
        app2.Date_of_birth_c =  new CAA_Data.MyDate(Date.newInstance(1994, 01, 01));
        app2.Document_issue_date_c = md;
        app2.Visa_expiry_date_c = new CAA_Data.MyDate(system.today()+30);
        app2.Date_moved_to_address_c = new CAA_Data.MyDate(system.today()-20);
        app2.Date_moved_to_previous_address_c = new CAA_Data.MyDate(system.today()-200);
        app2.Self_Cert_Acknowledged_c  = false;

        CAA_Data.PrimaryApplicantData app3 = new CAA_Data.PrimaryApplicantData();
        app3.Id = data.accountid;
        app3.HasEmail  = false;
        app3.HasMail = false;
        app3.HasPhone = false;
        app3.HasSMS = false;
        app3.LastName = 'test';
	    CAA_Data.MyDate md3 = new CAA_Data.MyDate(system.today());
        app3.Date_Employment_Commenced_c = md3;
        app3.Date_of_birth_c =  new CAA_Data.MyDate(Date.newInstance(1994, 01, 01));
        app3.Document_issue_date_c = md;
        app3.Visa_expiry_date_c = new CAA_Data.MyDate(system.today()+30);
        app3.Date_moved_to_address_c = new CAA_Data.MyDate(system.today()-20);
        app3.Date_moved_to_previous_address_c = new CAA_Data.MyDate(system.today()-200);
        app3.Self_Cert_Acknowledged_c  = false;

        CAA_Data.PrimaryApplicantData app4 = new CAA_Data.PrimaryApplicantData();
        app4.Id = data.accountid;
        app4.HasEmail  = false;
        app4.HasMail = false;
        app4.HasPhone = false;
        app4.HasSMS = false;
        app4.LastName = 'test';
	    CAA_Data.MyDate md4 = new CAA_Data.MyDate(system.today());
        app4.Date_Employment_Commenced_c = md4;
        app4.Date_of_birth_c =  new CAA_Data.MyDate(Date.newInstance(1994, 01, 01));
        app4.Document_issue_date_c = md;
        app4.Visa_expiry_date_c = new CAA_Data.MyDate(system.today()+30);
        app4.Date_moved_to_address_c = new CAA_Data.MyDate(system.today()-20);
        app4.Date_moved_to_previous_address_c = new CAA_Data.MyDate(system.today()-200);
        app4.Self_Cert_Acknowledged_c  = false;

        personaldata.Applicants = New List<CAA_Data.PrimaryApplicantData>{app};
        personaldata2.Applicants = New List<CAA_Data.PrimaryApplicantData>{app2};
        personaldata3.Applicants = New List<CAA_Data.PrimaryApplicantData>{app3};
        personaldata4.Applicants = New List<CAA_Data.PrimaryApplicantData>{app4};
           
        CAA_Core_Controller.CallAJE(logId,sessionId);
        //CAA_Core_Controller.SavePersonalDetails(personaldata,SessionId);

        CAA_Core_Controller.ApplicantDeclaration appli = new CAA_Core_Controller.ApplicantDeclaration();
        appli.capacity ='test';
        
        String response1 = '{"MessageId": "123","TNId": 123,"InitialDecision": "Pass","Decision": "Pass","ErrorCode": null,"ErrorMessage": null,"RuleOutcomes": [{"RuleName": "Test Rule","Outcome": true,"Score": 100}],"TNResponse": {"accountId":1234,"status": {"code": "AWAITING_RESPONSE","label": "AWAITING_RESPONSE"},"decision": {"code": "AWAITING_RESPONSE","label": "AWAITING_RESPONSE"},"Applications": [{"uid": "123","auditReference": "123","runId": 123,"journeyId": {"id": 123,"name": "Test Journey"},"organisationId": {"id": 123},"country": "USA","user": {"id": 123,"name": "Test User"},"nameReference": "Test Name","riskLevel": "High","journeyType": {"id": 123,"label": "Test Journey"},"startDateTime": "2023-03-15T10:05:44.475Z","endDateTime": "2023-03-15T10:05:44.475Z","progressStatus": {"code": "Pass","label": "Pass"},"decision": {"code": "Pass","label": "Pass"},"rulesetOutcomes": [{"reference": "Test Reference","score": 100,"ruleOutcomes": [{"RuleName": "Test Rule","Outcome": true,"Score": 100}],"riskLevel": "High"}],"links": [{"code": "Test Code","url": "http://test.com"}]}]}}';
        Test.setMock(HttpCalloutMock.class, new ARBCustomerAMLAPIMock(response1));        

        test.startTest();

        
        system.runAs(u){
            core.GoToLogin();
            data.opportunityid = CAA_Helper.EncryptData(o.id);
            sessionId = CAA_Helper.EncryptData(exse.id);
            CAA_Core_Controller.GetHostData(logId);
            CAA_Core_Controller.CompleteSummary(logId);
            CAA_Core_Controller.AddApplicant(acc.id,log.Id);
            CAA_Core_Controller.CreateANC('test',acc.id);
            CAA_Core_Controller.GetApplicantData(logId,SessionId);
            CAA_Core_Controller.FindCustomer('test');
            CAA_Core_Controller.GetRMApplicantData(log.id,SessionId);
            CAA_Core_Controller.RemoveApplicant(data.accountid,logId);
        
        
            CAA_Core_Controller.CallDe(logId,SessionId,new List<CAA_Core_Controller.ApplicantDeclaration>{appli});
            CAA_Core_Controller.CallRM(logId,SessionId,false,false);
            CAA_Core_Controller.CallEBSDE(logId,SessionId);
            
        
            CAA_Core_Controller.CallEBS(logId,sessionId,null);
            CAA_Core_Controller.CallAJE(logId,sessionId);
            CAA_Core_Controller.SetupFTD(log.id);   
            CAA_Core_Controller.FTDSetup(log.id);
            CAA_Core_Controller.CompleteExternal(logId,SessionId);
            CAA_Core_Controller.FTDSetupInit(log.id);
            CAA_Data.SetupFTDInitData setdata = new CAA_Data.SetupFTDInitData();
            setdata.PaymentAmount =1234.01;
            setdata.AJECompleted =true;
            setdata.FTDCompleted= true;
            setdata.ShowAJE= true;
            
        CAA_Core_Controller.FTDSetupSave(log.id,setdata);
        CAA_Core_Controller.SaveISATransfer(logId,SessionId,null,false);
        CAA_Core_Controller.Eligibility(null);
        CAA_Core_Controller.GetCampaigns('Test');
        CAA_Core_Controller.SavePersonalDetails(personaldata,SessionId);
        CAA_Core_Controller.CompleteRM(personaldata2,SessionId);
        CAA_Core_Controller.CompletePersonalDetails(personaldata3,SessionId);
        CAA_Core_Controller.CompletePersonalDetailsOverride(personaldata4,SessionId);
        //CAA_Core_Controller.checkIsFTD(log.Id);
        String transactionId=CAA_Helper.EncryptData(o.Id);
        //CAA_Core_Controller.MakePayment(null,transactionId,logId,SessionId);

        //CAA_Core_Controller.ResumeCallRecording(transactionId,logId,SessionId);
        }
        CAA_Core_Controller.IsExistingAccount(appdata,log.id,true);
        //CAA_Core_Controller.CallDe(log.Id,SessionId,new List<CAA_Core_Controller.ApplicantDeclaration>{appli});
        CAA_Core_Controller.SetupFTD(log.Id);   
        CAA_Core_Controller.FTDSetup(log.id);
        CAA_Core_Controller.CreateDocument(logId,SessionId,CAA_Helper.EncryptData('settingId'));


        test.stopTest();
    }
    
     @IsTest
    static void CAA_ControllerTestTwo(){
        test.startTest();
        z_DirectorHelper dHelp = new z_DirectorHelper();
        dHelp.AIPEvent();
        dHelp.ApplicationEvent();
        ProductEventDirector__c director = dHelp.Build();  
        
        IBB_Product__c pd = [Select Id, Name,ProductEventDirector__c from IBB_Product__c where Name = 'Testing Product'];
        pd.ProductEventDirector__c = director.Id;
        update pd;
        
        Opportunity o = [Select Id,Name, IBB_Product__c,Credit_Or_Debit__c,ProductEventDirector__c from Opportunity limit 1];
        o.IBB_Product__c = pd.Id;
        o.CAA_Decision__c = 'Decline';
        o.ProductEventDirector__c = director.Id;
        update o;
        
        Web_Integration_Log__c webLog = [Select request_output__c,OpportunityId__c,Request_Action__c From Web_Integration_Log__c];
        
        XML_Message__c xmlMessage = [Select Id,Name,Buffered__c,Type__c,Active__c,Service_Namespace__c,Element_Name__c,Description__c,Service_Name_Element__c
                                    From XML_Message__c];
        
        Account acc = [Select Id from Account Limit 1];
        //system.debug(acc);
        Eventlog__c log = [Select Id,opportunity__c,event__c from Eventlog__c limit 1];
        External_Session__c es = new External_Session__c();
        es.Active_Date__c= date.today();
        es.Account__c=acc.id;
        es.Opportunity__c= o.id;
        insert es;
        
        Applicant__c apl =  new Applicant__c();
        apl.Prospect_Customer__c=acc.id;
        apl.Opportunity__c=log.opportunity__c;
        insert apl;
        
        Case cs = new Case();
        cs.Opportunity__c = o.Id;
        cs.Referral_Decision__c = '';
        cs.RecordTypeId = '012D0000000KJujIAG'; 
        insert cs;
        system.debug('cs::'+Cs.RecordTypeId);
        
         WebLogClass wl = new WebLogClass();
         wl.upsertWebLogs();
         wl.insertCases();
         wl.upsertBuffers();
       

       
        CAA_Settings__c caaSettings = [Select Id, Name from CAA_Settings__c Where Name = 'UseFITAccount'];
        CAA_Settings__c caaSettings1 = [Select Id, Name from CAA_Settings__c Where Name = 'UseISAFITAccount'];
		caaSettings1.Value__c = 'NO';
        update caaSettings1;
        
        List<External_Session__c> sessions = [select id,is_active__c, Active_Date__c, Expires__c, Account__c, Opportunity__c from External_Session__c Limit 1];
        String cookieSession = CAA_Helper.EncryptData(sessions[0].Id);
        
        PageReference myVfPage = Page.CAA_Core;
        Test.setCurrentPage(myVfPage);
        Cookie cookie = new Cookie('applicationId', cookieSession, null, -1, false);
        ApexPages.currentPage().setCookies(new Cookie[]{cookie});
        //ApexPages.currentPage().getCookies().set('applicationId',String.Valueof(cookieSession));
        CAA_Core_Controller core = New CAA_Core_Controller();
        String ExistingCustomerValue = core.ExistingCustomerValue;
        
        String isYPSAAccount = core.isYPSAAccount;
        String SessionId = core.SessionId;
        Opportunity Opp = core.opp;
        core.m_EventLogId = log.Id;
        core.m_AccountId = acc.Id;
        string AccountId = core.AccountId;
        //List<Campaign> Campaigns = core.Campaigns;
        IBB_Product__c Product = core.Product; 
        Boolean IsYPSA = core.IsYPSA;
        Boolean IsFTD = core.IsFTD;
        Boolean IsFTDISA = core.IsFTDISA;
        Boolean UseFITForISA = core.UseFITForISA;
        boolean UseFIT = core.UseFIT;
        string titleText = core.titleText;
        Boolean IsCurrentAccount = core.IsCurrentAccount;
        Boolean IsANC = core.IsANC;
        //List<CAA_Data.KeyValue> InterestedIn = core.InterestedIn;
        //List<CAA_Data.KeyValue> Titles = core.Titles;
        core.Setup();
        Boolean IsFTDSetup = core.IsFTDSetup;
        Boolean IsFITSetup = core.IsFITSetup;
        core.FTD_Setup();

        //core.EligibilitySetup();
        core.ISA_Transfer_Init();
        String EncOppId = core.EncOppId;
        core.SendToHost();
        core.Declaration_Summary();
        core.Declaration_Init();
        Boolean ShowImage = core.ShowImage;
        Boolean PageUsesKendo = core.PageUsesKendo;
        boolean showDirectSavingsAccountTC = core.showDirectSavingsAccountTC;
        boolean show60DayNoticeAccountTC = core.show60DayNoticeAccountTC;
        boolean show120DayNoticeAccountTC = core.show120DayNoticeAccountTC;
        boolean showOnDemandSavingsAccountTC = core.showOnDemandSavingsAccountTC;
        boolean showYPSATC = core.showYPSATC;
        boolean showISA = core.showISA;
        boolean showInstantISA = core.showInstantISA;
        boolean showFTDISA = core.showFTDISA;
        boolean showYPNATC = core.showYPNATC;
        boolean showFixedTermAccountTC = core.showFixedTermAccountTC;
        boolean showSmallFixedTermAccountTC = core.showSmallFixedTermAccountTC;
        boolean showCurrentText = core.showCurrentText;
        boolean showSavingText = core.showSavingText;
        boolean showCurrentAccountTC = core.showCurrentAccountTC;
        String AncEbsId = core.AncEbsId;
        String AncFirstName = core.AncFirstName;
        String AncLastName = core.AncLastName;
        String EligibilityAccDate = core.EligibilityAccDate;
        boolean showProduct = core.showProduct;
        CAA_Data.AddNewApplicantData appdata = new CAA_Data.AddNewApplicantData();
        appdata.FirstName = 'Applicant Account DM1';
        appdata.LastName = 'Force26';
        appdata.Title = 'xyz';
        appdata.dob = new CAA_Data.MyDate(Date.today());
        CAA_Data.ProductSelectedData data = new CAA_Data.ProductSelectedData();
        data.ProductId = Product.Id;
        data.PurposeOfAccount = 'Loan';
        data.NumberOfApplicants = 20;  
        data.Deposit =123.01;
        CAA_Core_Controller ob = new CAA_Core_Controller();
        data.OpportunityId= o.Id;
        data.Receive_Salary_Benefits = true;
        data.Pay_Bills_Expenses= true;
        data.Domestic_Transfers_In_Out= true;
        data.International_Transfer_In_Out= true;
        data.Cash_Deposit_In_Out= true;
        data.Saving_Goals= true;
        data.Over16= 'test';
        data.Regular_payment_amount_c = 123.23;
        data.Payment_Frequency_c='test';
        data.Direct_debit_date_day_c='test';
        data.Name_of_current_Bank_Building_Society_c='test';
        data.Sort_Code_c = '123';
        data.HasRegularPayment= 'test';
        
        String logId = CAA_Helper.EncryptData(log.id);
        
        CAA_Core_Controller.ProductSelected(data,SessionId,false,false,false,false,false,false);
        
       // User u = [select id,isactive,name from user where usertype='AutomatedProcess' Limit 1];
          User u = [select id,isactive,name from user where usertype='Guest' AND name like '%External CAA%'];

        /*User us = new User();
        us.Username= 'trghygjhaf@gmail.com';
        us.LastName='User';
        us.Email= 'abctest@gmail.com';
        us.Alias='ates';
        us.TimeZoneSidKey= 'Europe/London';
        us.LocaleSidKey='en_GB';
        us.EmailEncodingKey='ISO-8859-1';
        us.profileId = '00e3z000001tTBm';
        us.LanguageLocaleKey='en_US';
        us.Branch__c='DEWSBURY';
        us.EBSUserId__c='12234';
        us.IsActive =true;
        insert us;
        system.debug('User us::'+us.UserType); */
        
        External_Session__c exse = new External_Session__c();
        exse.Active_Date__c = Date.today();
        //exse.Expires__c =Date.today().adddays(1);
        exse.Opportunity__c=o.id;
        exse.Account__c =acc.id;
        insert exse;
        
        Campaign cam=new Campaign();
        cam.name='test';
        cam.IsActive=true;
        cam.StartDate=Date.today();
        cam.Type='TV';
        insert cam;
        
        CAA_Data.PersonalDetailsCompleteData personaldata= new CAA_Data.PersonalDetailsCompleteData();
        personaldata.PaperStatements = 'test';
        personaldata.Campaign = cam.Id;
        personaldata.EventLogId =log.Id;
        personaldata.ApprovalUser =userinfo.getUserId();
        personaldata.isEDD = true;
        
        CAA_Data.PrimaryApplicantData app = new CAA_Data.PrimaryApplicantData();
        app.Id = data.accountid;
        app.HasEmail  = false;
        app.HasMail = false;
        app.HasPhone = false;
        app.HasSMS = false;
        app.LastName = 'test';
	    CAA_Data.MyDate md = new CAA_Data.MyDate(system.today());
        app.Date_Employment_Commenced_c = md;
        app.Date_of_birth_c =  new CAA_Data.MyDate(Date.newInstance(1994, 01, 01));
        app.Document_issue_date_c = md;
        app.Visa_expiry_date_c = new CAA_Data.MyDate(system.today()+30);
        app.Date_moved_to_address_c = new CAA_Data.MyDate(system.today()-20);
        app.Date_moved_to_previous_address_c = new CAA_Data.MyDate(system.today()-200);
        app.Self_Cert_Acknowledged_c  = false;
        
        personaldata.Applicants = New List<CAA_Data.PrimaryApplicantData>{app};

        
        sessionid = CAA_Helper.EncryptData(exse.id);

        CAA_Core_Controller.GetHostData(logId);
		CAA_Core_Controller.CompleteSummary(logId);
        CAA_Core_Controller.AddApplicant(acc.id,log.Id);
        CAA_Core_Controller.CreateANC('test',acc.id);
        CAA_Core_Controller.RemoveApplicant(data.accountid,logId);
        CAA_Core_Controller.FindExistingAccounts('Test',log.id);
        CAA_Core_Controller.IsExistingAccount(appdata,log.id,false);
        CAA_Core_Controller.CompleteExternal(logId,SessionId);
        CAA_Core_Controller.CompleteSummaryExternal(logId,SessionId);
        CAA_Core_Controller.FTDSetupInit(log.id);

        CAA_Data.SetupFTDInitData setdata = new CAA_Data.SetupFTDInitData();
            setdata.PaymentAmount =1234.01;
            setdata.AJECompleted =true;
            setdata.FTDCompleted= true;
            setdata.ShowAJE= true;
            
        CAA_Core_Controller.FTDSetupSave(log.id,setdata);
        CAA_Core_Controller.SaveISATransfer(logId,SessionId,null,false);
        CAA_Core_Controller.Eligibility(null);


        
        system.runAs(u){
            core.Product_Screen_Init();
            data.accountid = CAA_Helper.EncryptData(acc.id);
            data.opportunityid = CAA_Helper.EncryptData(o.id);
            Boolean IsABranch = core.IsABranch;
            CAA_Core_Controller.ProductSelected(data,sessionid,false,false,false,false,false,false);
            CAA_Core_Controller.FindExistingAccounts('Test',log.id);
        	CAA_Core_Controller.IsExistingAccount(appdata,log.id,false);
        	CAA_Core_Controller.GetDocumentData(logId,sessionid,'Open');
        	CAA_Core_Controller.CreateDocument(logId,SessionId,CAA_Helper.EncryptData('settingId'));
            CAA_Core_Controller.CompleteSummaryExternal(logId,SessionId);
            
            
        }
        //CAA_Core_Controller.CallRM(log.Id,SessionId,false,false);
        
        
        
        test.stopTest();
    }
    
    @isTest
    Public static Void testMethod3(){
        
        CAA_Core_Controller.HasEmailOption = true;
		System.assertEquals(CAA_Core_Controller.HasEmailOption, true);
        CAA_Core_Controller.HasMailOption = true;
		System.assertEquals(CAA_Core_Controller.HasMailOption, true);
        CAA_Core_Controller.HasPhoneOption = true;
		System.assertEquals(CAA_Core_Controller.HasPhoneOption, true);
        CAA_Core_Controller.HasSMSOption = true;
		System.assertEquals(CAA_Core_Controller.HasSMSOption, true);
        
        
        CAA_Core_Controller_Lightning ccc = New CAA_Core_Controller_Lightning();
        /*ccc.AncEbsId = 'xyz';
		System.assertEquals(ccc.AncEbsId, 'xyz');
        ccc.AncFirstName = 'xyz';
		System.assertEquals(ccc.AncFirstName, 'xyz');
        ccc.AncLastName = 'xyz';
		System.assertEquals(ccc.AncLastName, 'xyz');
        ccc.EligibilityAccDate = 'xyz';
		System.assertEquals(ccc.EligibilityAccDate, 'xyz');
        */
        
        //Opportunity op2 = new Opportunity();
        //CAA_Core_Controller_Lightning.m_Opp = op2;
        //
        
       CAA_Core_Controller_Lightning.init_wrap ini = new CAA_Core_Controller_Lightning.init_wrap();
        ini.DeResponse='';
        ini.ibbProductName='';
        ini.OppLibRef='';
        ini.AllowComplete=false;
        ini.EventLogId='';
        ini.isISA=false;
        ini.IsYPSA=false;
        ini.loginURL='';
        ini.showYPSATC=false;
        ini.showYPNATC=false;
        ini.showSavingText=false;
        ini.showCurrentAccountTC=false;
        List<String> li = new List<String>();
        ini.applicantNames = li;
        
        ini.FirstName='';
        ini.LastName='';
        ini.Salutation='';
        ini.Email='';
        ini.PreferedContact='';
        ini.Postcode='';
        ini.WebFormDataId='';
        ini.EligibilityAccDate='';
        ini.AncEbsId='';
        ini.AncFirstName ='';
        ini.AncLastName='';
		Account acc = new Account();
        acc.FirstName ='test';
        acc.LastName = 'acc';
        acc.Salutation = 'Mr';
        acc.PersonEmail ='test@salesforce.com';
        acc.Home_Telephone_No__c = '012341234';
        acc.Date_Of_Birth__c = Date.today()-7200;
		insert acc;
        ApexPages.currentPage().getParameters().put('accountid',acc.Id);
        
        //insert ini;
        CAA_Core_Controller caaAnc = new CAA_Core_Controller();
        caaAnc.ANCSetup();
        CAA_Core_Controller.GetProductSuitability();
        caaAnc.EligibilitySetup();
        
      /* @AuraEnabled public transient String DeResponse { get; set; }
       @AuraEnabled public String ibbProductName { get; set; }
       @AuraEnabled public transient String OppLibRef { get; set; }
       @AuraEnabled public Boolean AllowComplete { get; set; }
       @AuraEnabled public List<Case> Cases { get;set; }
       @AuraEnabled public List<Opportunity> opps { get;set; }
       @AuraEnabled public string EventLogId{ get;set; }
       @AuraEnabled public Boolean isISA{get;set;}
       @AuraEnabled public Boolean IsYPSA{get;set;} 
       //@AuraEnabled public List<String> applicantNames{get;set;}
       @AuraEnabled public String loginURL {get;set;}
       @AuraEnabled public Boolean showYPSATC {get;set;}
       @AuraEnabled public Boolean showYPNATC {get;set;}
       @AuraEnabled public Boolean showSavingText {get;set;}
       @AuraEnabled public Boolean showCurrentAccountTC {get;set;}
*/
    }
    
    static Id createproduct(){
        IBB_Product__c prod = new IBB_Product__c();
        
        createDocuGenSetting();
        CongaSettings__c docu = [select id from CongaSettings__c limit 1];
        
        prod.congaISATransfer__c = docu.Id;
        createProductSet();
        IBB_Product_Set__c	ps = [select id from IBB_Product_Set__c limit 1];
        prod.IBB_Product_Set__c = ps.id;
        
        prod.Staff_Only_Product__c = 'yes';
        prod.Term__c= '6 Months';
        prod.Max_finance_to_value_FTV__c= 22.1;
        prod.Rental_Rate_Type__c = 'F';
        prod.Benchmark_rate__c= 22.22;
        prod.Rent_or_occupancy__c= 'rent';
        prod.Offer_Letter_Version__c='Pre-September 2014';
        prod.Fixed_or_Discounted__c='Fixed';
        prod.Type_of_product_for_solicitor_letter__c ='HPP';
        prod.Product_live_date__c= system.today();
        prod.Short_Product_Name__c= 'testproduct';
        prod.Account_Type__c='Bid Bonds';
        prod.Product_code__c= 'The IBB product code';
        
        prod.Category_of_Product__c= 'Current Account';	
        prod.Type_of_Product__c= 'Current Account';
        prod.Product_Description__c= 'testproduct';
        prod.Profit_calculated__c='monthly';
        prod.Profit_Rate__c= 3.3574;
        prod.Profit_accrued__c= 'monthly';
        prod.Profit_paid_to__c='External account';
        prod.Statement_frequency__c='Monthly';
        prod.Name='test';
        prod.DocuGen_Liability_App_1_CAA_Face2Face__c = docu.Id;
        prod.DocuGen_Liability_App_2_CAA_Face2Face__c = docu.Id;
        prod.DocuGen_Liability_App_3_CAA_Face2Face__c = docu.Id;
        prod.Conga_Liability_App_1_caa__c = docu.Id;
        prod.Conga_Liability_App_2_caa__c = docu.Id;
        prod.Conga_Liability_App_3_caa__c = docu.Id;
        prod.Conga_Failed_EKYC_Letter__c = docu.Id;
        insert prod;
        return prod.id;
    }
    
    static void createDocuGenSetting() {
        CongaSettings__c docu= new CongaSettings__c();
        docu.Name ='test';
        docu.Document_name__c = 'test';
        /*docu.Queries__c = '{"Queries":[{"QueryId":"a5aD0000000GmfWIAS","Order":1,"Name":"Applicant2","Alias":""}]}';
        docu.Templates__c = '{"Templates":[{"TemplateId":"a5bD0000000GmisIAC","SystemModstamp":null,"Order":0,"Name":"AIP Letter","MinApplicants":0,"AttachmentId":null}]}';
        */
        insert docu;
        System.debug('8= '+docu);
        
    }
    static void createProductSet(){
        IBB_Product_Set__c	ps = new IBB_Product_Set__c();
        ps.Name ='test';
        insert ps;
        System.debug('8= '+ps);
    }
    
     @isTest
    Public static Void isYPSAAccountTest(){
        Account acc =new Account();
        //acc.Salutation = 'Mr';
        acc.Name='Test';
        acc.Date_of_Birth__c = Date.newInstance(2022, 01, 01);
        acc.Customer_Type__c = 'Minors (EB)';
        insert acc;
        CAA_Core_Controller ccc = New CAA_Core_Controller();
        ccc.m_AccountId = acc.Id;
        String xyz = ccc.isYPSAAccount;
        
    }
    
      @isTest
    Public static Void isYPSAAccountTestDob(){
        Account acc =new Account();
        //acc.Salutation = 'Mr';
        acc.Name='Test';
        //acc.Date_of_Birth__c = Date.newInstance(2022, 01, 01);
        acc.Customer_Type__c = 'Limited Company';
        insert acc;
        CAA_Core_Controller ccc = New CAA_Core_Controller();
        ccc.m_AccountId = acc.Id;
        String xyz = ccc.isYPSAAccount;
        
    }
   
    @isTest
    Public static Void GetDocumentDataTest(){
        z_DirectorHelper dHelp = new z_DirectorHelper();
        dHelp.AIPEvent();
        dHelp.ApplicationEvent();
        ProductEventDirector__c director = dHelp.Build();
        
        z_OpportunityHelper oHelp = new z_OpportunityHelper('Test','Test');
        oHelp.Director(director.id);
        id prod = createproduct();
        opportunity o= oHelp.build();
        
        o.name = 'test';
        o.stagename = 'Open';
        o.closedate = date.today();
        o.ProductEventDirector__c = director.id;
        o.IBB_Product__c = prod;
        o.caa_decision__c = 'REFER';
        o.From_Upload__c = true;
        update o;
        
        Event__c e = dHelp.Event;
        e.name = 'Awaiting Valuation';
        e.CustomPageLocation__c = '/apex/CAA_PersonalDetails';
        update e;
        
        Eventlog__c log = new Eventlog__c();
        log.event__c = e.id;
        log.eventstatus__c = 'Open';
        log.isexpired__c = false;
        log.opportunity__c = o.id;
        insert log;
         
        CAA_Core_Controller.GetDocumentData(log.id,'xyz','DOCS');
    }
    
    @isTest
    static void getLoadSourceofFundPickLists_Test(){
        CAA_Picklist__c picklist = new CAA_Picklist__c();
        picklist.name = 'picklist 1';
        picklist.value__c = 'picklist1';
        picklist.Field__c = 'SOURCEOFFUNDS';
        picklist.Internal__c = True;
        insert(picklist);
        CAA_Core_Controller.getLoadSourceofFundPickLists();
    } 
    
    @isTest
    Public static Void checkIsFTDTest(){
       
        Opportunity opp = new Opportunity(closedate = date.today(), Name = 'Test Opp', Interested_in__c = 'TestA', Purchase_price_market_value__c = 300000, Finance_Required__c = 100000, 
                                          Credit_Or_Debit__c='1000', Term_of_Finance__c=25, number_of_people_applying__c = 1, Source_of_Funds__c = 'Account funded from a bank account in the UK', StageName = 'Personal Details');
        
        insert opp;
        
        Event__c evt = new Event__c(Name = 'Testing Event');
        insert evt;
        
        
        EventLog__c eventLog = new EventLog__c();
        eventLog.Name = 'Event Log';
        eventLog.Event__c = evt.Id;
        eventLog.Opportunity__c = opp.Id;
        eventLog.EventStatus__c = 'Open';
        insert eventLog;
        
        
        CAA_Core_Controller.checkIsFTD(eventLog.Id);
        
    }
    
    /*
    @isTest
    Public static Void MakePaymentTest(){
        z_DirectorHelper dHelp = new z_DirectorHelper();
        dHelp.AIPEvent();
        dHelp.ApplicationEvent();
        ProductEventDirector__c director = dHelp.Build();
        
        
        z_OpportunityHelper oHelp = new z_OpportunityHelper('Test','Test');
        oHelp.Director(director.id);
        id prod = createproduct();
        opportunity o= oHelp.build();
        o.name = 'test';
        o.stagename = 'Open';
        o.closedate = date.today();
        o.ProductEventDirector__c = director.id;
        o.IBB_Product__c = prod;
        o.caa_decision__c = 'Test';
        o.From_Upload__c = true;
        update o;
        
        Event__c e = dHelp.Event;
        e.name = 'Awaiting Valuation';
        e.CustomPageLocation__c = '/apex/CAA_PersonalDetails';
        update e;
        
        Eventlog__c log = new Eventlog__c();
        log.event__c = e.id;
        log.eventstatus__c = 'Open';
        log.isexpired__c = false;
        log.opportunity__c = o.id;
        insert log;
        
        IBBOpportunityPayment__c oppPayment = new IBBOpportunityPayment__c ();
        
        CAA_Core_Controller.MakePayment(null,null,log.id,'xyz');
    }
    
    @isTest
    Public static Void CallDetest(){
        
        Opportunity o = [Select Id from Opportunity limit 1];
        Account acc = [Select Id from Account Limit 1];
        
        
        //system.debug(acc);
        Eventlog__c log = [Select Id,opportunity__c from Eventlog__c limit 1];
        External_Session__c es = new External_Session__c();
        es.Active_Date__c= date.today();
        es.Account__c=acc.id;
        es.Opportunity__c= o.id;
        insert es;
        //Applicant__c apl =  new Applicant__c();
        //apl.Prospect_Customer__c=acc.id;
        //apl.Opportunity__c=log.opportunity__c;
        //insert apl;
        
        HPP_Extended_Opportunity__c hpp = new HPP_Extended_Opportunity__c();
        hpp.Opportunity__c = o.Id;
        insert hpp;
        
        List<External_Session__c> sessions = [select id,is_active__c, Active_Date__c, Expires__c, Account__c, Opportunity__c from External_Session__c Limit 1];
        String cookieSession = CAA_Helper.EncryptData(sessions[0].Id);
        
        PageReference myVfPage = Page.CAA_Core;
        Test.setCurrentPage(myVfPage);
        Cookie cookie = new Cookie('applicationId', cookieSession, null, -1, false);
        ApexPages.currentPage().setCookies(new Cookie[]{cookie});
        //ApexPages.currentPage().getCookies().set('applicationId',String.Valueof(cookieSession));
        
        CAA_Core_Controller core = New CAA_Core_Controller();
        String m_SessionId = core.m_SessionId;
        String ExistingCustomerValue = core.ExistingCustomerValue;
       // Boolean IsABranch = core.IsABranch;
        String isYPSAAccount = core.isYPSAAccount;
        String SessionId = core.SessionId;
        Opportunity Opp = core.opp;
        core.m_EventLogId = log.Id;
        core.m_AccountId = acc.Id;
        string AccountId = core.AccountId;
        //List<Campaign> Campaigns = core.Campaigns;
        IBB_Product__c Product = core.Product; 
        Boolean IsYPSA = core.IsYPSA;
        Boolean IsFTD = core.IsFTD;
        //Boolean IsFTDISA = core.IsFTDISA;
        Boolean UseFITForISA = core.UseFITForISA;
        boolean UseFIT = core.UseFIT;
        string titleText = core.titleText;
        Boolean IsCurrentAccount = core.IsCurrentAccount;
        Boolean IsANC = core.IsANC;
        //List<CAA_Data.KeyValue> InterestedIn = core.InterestedIn;
        //List<CAA_Data.KeyValue> Titles = core.Titles;
        core.GoToLogin();
        core.Setup();
        Boolean IsFTDSetup = core.IsFTDSetup;
        Boolean IsFITSetup = core.IsFITSetup;
        core.FTD_Setup();
        
        //core.EligibilitySetup();
        core.ISA_Transfer_Init();
        core.Product_Screen_Init();
        String EncOppId = core.EncOppId;
        core.SendToHost();
        core.Declaration_Summary();
        core.Declaration_Init();
        Boolean ShowImage = core.ShowImage;
        Boolean PageUsesKendo = core.PageUsesKendo;
        boolean showDirectSavingsAccountTC = core.showDirectSavingsAccountTC;
        boolean show60DayNoticeAccountTC = core.show60DayNoticeAccountTC;
        boolean show120DayNoticeAccountTC = core.show120DayNoticeAccountTC;
        boolean showOnDemandSavingsAccountTC = core.showOnDemandSavingsAccountTC;
        boolean showYPSATC = core.showYPSATC;
        boolean showISA = core.showISA;
        boolean showInstantISA = core.showInstantISA;
        boolean showFTDISA = core.showFTDISA;
        boolean showYPNATC = core.showYPNATC;
        boolean showFixedTermAccountTC = core.showFixedTermAccountTC;
        boolean showSmallFixedTermAccountTC = core.showSmallFixedTermAccountTC;
        boolean showCurrentText = core.showCurrentText;
        boolean showSavingText = core.showSavingText;
        boolean showCurrentAccountTC = core.showCurrentAccountTC;
        
        List<CAA_Core_Controller.ApplicantDeclaration> appli = new List<CAA_Core_Controller.ApplicantDeclaration>();
        for(Integer i = 0; i<=1; i++){
            CAA_Core_Controller.ApplicantDeclaration appli1 = new CAA_Core_Controller.ApplicantDeclaration();
            	appli1.capacity='Self';
            	appli.add(appli1);     
        }
		//Test.setMock(HttpCalloutMock.class, new RestMock());
        String logId = log.id;
        z_XmlMessage.CreateXmlMessageDE(); 
        System.test.startTest();         
        z_WebServiceMock mock = new z_WebServiceMock();
        mock.xml = '<?xml version="1.0" encoding="utf-8"?><soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema"><soap:Body><OperationResponse xmlns="http://www.islamic-bank.com/HPPDecisionEngine"><HPPDecisionEngineResponse><MessageID>a0oD0000007OHwZIAW</MessageID><MessageType>HPPDecisionEngineResponse</MessageType><DecisionId>86BF2236-E7F8-4244-B16B-D1C0E75A59DE</DecisionId><Decision>DECLINE-BDM14;REFER-BDM35;REFER-BDM36;</Decision><DecisionReason>DECLINE-BDM14 (DFF5AC28-6EC6-46A8-AF5F-F73ECD82B0D6 - Property not equal to \'absolute ownership\' in Scotland;) REFER-BDM35 (05B7D6AA-4D0D-472E-B982-652828AA8F3F - No of credit searches within the last 3 months at current address;) REFER-BDM36 (F0FE17BC-621E-40CD-A071-CDD50A252E5A - No of credit searches within the last 3 months at previous address;) </DecisionReason><DecisionExcludingWarnings>REFER-NOMATCH</DecisionExcludingWarnings><AcceptedFacilities /><RejectedFacilities /><SupplierScore>800</SupplierScore></HPPDecisionEngineResponse></OperationResponse></soap:Body></soap:Envelope>';
                     
        System.Test.setMock(WebServiceMock.class,mock);
        CAA_Core_Controller.CallDe(log.id,SessionId,appli);
        system.test.stopTest();
    }
    
    @isTest
    Public static Void CallRMtest(){
        
        Opportunity o = [Select Id from Opportunity limit 1];
        Account acc = [Select Id from Account Limit 1];
        //system.debug(acc);
        Eventlog__c log = [Select Id,opportunity__c from Eventlog__c limit 1];
        External_Session__c es = new External_Session__c();
        es.Active_Date__c= date.today();
        es.Account__c=acc.id;
        es.Opportunity__c= o.id;
        insert es;
        //Applicant__c apl =  new Applicant__c();
        //apl.Prospect_Customer__c=acc.id;
        //apl.Opportunity__c=log.opportunity__c;
        //insert apl;
        
        HPP_Extended_Opportunity__c hpp = new HPP_Extended_Opportunity__c();
        hpp.Opportunity__c = o.Id;
        insert hpp;
        List<External_Session__c> sessions = [select id,is_active__c, Active_Date__c, Expires__c, Account__c, Opportunity__c from External_Session__c Limit 1];
        String cookieSession = CAA_Helper.EncryptData(sessions[0].Id);
        
        PageReference myVfPage = Page.CAA_Core;
        Test.setCurrentPage(myVfPage);
        Cookie cookie = new Cookie('applicationId', cookieSession, null, -1, false);
        ApexPages.currentPage().setCookies(new Cookie[]{cookie});
        //ApexPages.currentPage().getCookies().set('applicationId',String.Valueof(cookieSession));
        CAA_Core_Controller core = New CAA_Core_Controller();
        String m_SessionId = core.m_SessionId;
        String ExistingCustomerValue = core.ExistingCustomerValue;
        //Boolean IsABranch = core.IsABranch;
        String isYPSAAccount = core.isYPSAAccount;
        String SessionId = core.SessionId;
        Opportunity Opp = core.opp;
        core.m_EventLogId = log.Id;
        core.m_AccountId = acc.Id;
        string AccountId = core.AccountId;
        String logId = log.id;
        
        CAA_Core_Controller.CallRM(logId,SessionId,False,False);
    }
    
    @isTest
    Public static Void CallEBStest(){
        
        Opportunity o = [Select Id from Opportunity limit 1];
        Account acc = [Select Id from Account Limit 1];
        acc.Salutation = 'MR';
        acc.PersonEmail = 'Test@gmail.com';
        acc.Home_Telephone_No__c = '34567890';
        acc.Date_Of_Birth__c = Date.newInstance(1992, 12, 9);
        update acc;
        //system.debug(acc);
        Eventlog__c log = [Select Id,opportunity__c from Eventlog__c limit 1];
        External_Session__c es = new External_Session__c();
        es.Active_Date__c= date.today();
        es.Account__c=acc.id;
        es.Opportunity__c= o.id;
        insert es;
        Applicant__c apl =  new Applicant__c();
        apl.Prospect_Customer__c=acc.id;
        apl.Opportunity__c=log.opportunity__c;
        insert apl;
      	
        HPP_Extended_Opportunity__c hpp = new HPP_Extended_Opportunity__c();
        hpp.Opportunity__c = o.Id;
        insert hpp;
        
        Account_with_IBB__c a = new Account_with_IBB__c ();
        a.Opportunity__c = o.id;
        a.Primary_SFDC_Account__c = acc.id;
        insert a;
        
        
        Asset_Relationship__c ass = new Asset_Relationship__c();
        ass.Account_with_IBB__c = a.id;
        ass.Prospect_Customer__c = acc.id;
        ass.Primary_Account_Holder__c = true;
        insert ass;
        
        Account_Reference_Information__c aInfor = new Account_Reference_Information__c();
        aInfor.Payment_Type__c = 'Test';
        aInfor.Request_Type__c = 'OCA';
        insert aInfor;
        
        Debug__c d = new Debug__c();
        d.opportunity__c = o.id;
        insert d;
        
        Web_Integration_Log__c wlog = new Web_Integration_Log__c();
        wlog.Accountid__c = acc.id;
        wlog.OpportunityId__c = o.Id;
        wlog.Request_Action__c = 'AddNewCustomer';
        insert wlog;
        
        List<External_Session__c> sessions = [select id,is_active__c, Active_Date__c, Expires__c, Account__c, Opportunity__c from External_Session__c Limit 1];
        String cookieSession = CAA_Helper.EncryptData(sessions[0].Id);
        
        PageReference myVfPage = Page.CAA_Core;
        Test.setCurrentPage(myVfPage);
        Cookie cookie = new Cookie('applicationId', cookieSession, null, -1, false);
        ApexPages.currentPage().setCookies(new Cookie[]{cookie});
        //ApexPages.currentPage().getCookies().set('applicationId',String.Valueof(cookieSession));
       
        CAA_Core_Controller core = New CAA_Core_Controller();
        String m_SessionId = core.m_SessionId;
        String ExistingCustomerValue = core.ExistingCustomerValue;
        //Boolean IsABranch = core.IsABranch;
        String isYPSAAccount = core.isYPSAAccount;
        String SessionId = core.SessionId;
        Opportunity Opp = core.opp;
        core.m_EventLogId = log.Id;
        core.m_AccountId = acc.Id;
        string AccountId = core.AccountId;
        //List<Campaign> Campaigns = core.Campaigns;
        IBB_Product__c Product = core.Product; 
        Boolean IsYPSA = core.IsYPSA;
        Boolean IsFTD = core.IsFTD;
        Boolean IsFTDISA = core.IsFTDISA;
        Boolean UseFITForISA = core.UseFITForISA;
        boolean UseFIT = core.UseFIT;
        string titleText = core.titleText;
        Boolean IsCurrentAccount = core.IsCurrentAccount;
        Boolean IsANC = core.IsANC;
        //List<CAA_Data.KeyValue> InterestedIn = core.InterestedIn;
        //List<CAA_Data.KeyValue> Titles = core.Titles;
        core.GoToLogin();
        core.Setup();
        Boolean IsFTDSetup = core.IsFTDSetup;
        Boolean IsFITSetup = core.IsFITSetup;
        core.FTD_Setup();
        
        ApexPages.currentPage().getParameters().put('accountid',acc.Id);
        ApexPages.currentPage().getParameters().put('webFormDataId','test');
        //core.ANCSetup();
        //core.EligibilitySetup();
        core.ISA_Transfer_Init();
        core.Product_Screen_Init();
        String EncOppId = core.EncOppId;
        core.SendToHost();
        core.Declaration_Summary();
        core.Declaration_Init();
        Boolean ShowImage = core.ShowImage;
        Boolean PageUsesKendo = core.PageUsesKendo;
        boolean showDirectSavingsAccountTC = core.showDirectSavingsAccountTC;
        boolean show60DayNoticeAccountTC = core.show60DayNoticeAccountTC;
        boolean show120DayNoticeAccountTC = core.show120DayNoticeAccountTC;
        boolean showOnDemandSavingsAccountTC = core.showOnDemandSavingsAccountTC;
        boolean showYPSATC = core.showYPSATC;
        boolean showISA = core.showISA;
        boolean showInstantISA = core.showInstantISA;
        boolean showFTDISA = core.showFTDISA;
        boolean showYPNATC = core.showYPNATC;
        boolean showFixedTermAccountTC = core.showFixedTermAccountTC;
        boolean showSmallFixedTermAccountTC = core.showSmallFixedTermAccountTC;
        boolean showCurrentText = core.showCurrentText;
        boolean showSavingText = core.showSavingText;
        boolean showCurrentAccountTC = core.showCurrentAccountTC;
        
        z_XmlMessage.CreateAddNewCustomerMessage();
        z_XmlMessage.CreateAJREssage();
        z_XmlMessage.CreateANCAllMessage();
        Z_TheXmlMessages.CreateOCAMessage();
        //IBBDependentObjectFactory.CreateANCRLAJARStubs (o);
        System.test.startTest(); 
        z_WebServiceMock mock = new z_WebServiceMock();
        mock.xml = '<?xml version="1.0" encoding="utf-8"?><soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema"><soap:Body><OperationResponse xmlns="http://www.islamic-bank.com/HPPDecisionEngine"><HPPDecisionEngineResponse><MessageID>a0oD0000007OHwZIAW</MessageID><MessageType>HPPDecisionEngineResponse</MessageType><DecisionId>86BF2236-E7F8-4244-B16B-D1C0E75A59DE</DecisionId><Decision>DECLINE-BDM14;REFER-BDM35;REFER-BDM36;</Decision><DecisionReason>DECLINE-BDM14 (DFF5AC28-6EC6-46A8-AF5F-F73ECD82B0D6 - Property not equal to \'absolute ownership\' in Scotland;) REFER-BDM35 (05B7D6AA-4D0D-472E-B982-652828AA8F3F - No of credit searches within the last 3 months at current address;) REFER-BDM36 (F0FE17BC-621E-40CD-A071-CDD50A252E5A - No of credit searches within the last 3 months at previous address;) </DecisionReason><DecisionExcludingWarnings>REFER-NOMATCH</DecisionExcludingWarnings><AcceptedFacilities /><RejectedFacilities /><SupplierScore>800</SupplierScore></HPPDecisionEngineResponse></OperationResponse></soap:Body></soap:Envelope>';             
        System.Test.setMock(WebServiceMock.class,mock);
        
        String logId = log.id;     
        CAA_Core_Controller.CallEBS(logId,SessionId,null);
         system.test.stopTest();
    }
    
    
    @isTest
    Public static Void CallEBSDEtest(){
        
        Opportunity o = [Select Id from Opportunity limit 1];
        Account acc = [Select Id from Account Limit 1];
        //system.debug(acc);
        Eventlog__c log = [Select Id,opportunity__c from Eventlog__c limit 1];
        External_Session__c es = new External_Session__c();
        es.Active_Date__c= date.today();
        es.Account__c=acc.id;
        es.Opportunity__c= o.id;
        insert es;
        Applicant__c apl =  new Applicant__c();
        apl.Prospect_Customer__c=acc.id;
        apl.Opportunity__c=log.opportunity__c;
        insert apl;
        HPP_Extended_Opportunity__c hpp = new HPP_Extended_Opportunity__c();
        hpp.Opportunity__c = o.Id;
        insert hpp;
        
        Account_with_IBB__c a = new Account_with_IBB__c ();
        a.Opportunity__c = o.id;
        a.Primary_SFDC_Account__c = acc.id;
        insert a;
        
        
        Asset_Relationship__c ass = new Asset_Relationship__c();
        ass.Account_with_IBB__c = a.id;
        ass.Prospect_Customer__c = acc.id;
        ass.Primary_Account_Holder__c = true;
        insert ass;
        
        Account_Reference_Information__c aInfor = new Account_Reference_Information__c();
        aInfor.Payment_Type__c = 'Test';
        aInfor.Request_Type__c = 'OCA';
        insert aInfor;
        
        Debug__c d = new Debug__c();
        d.opportunity__c = o.id;
        insert d;
        
        Web_Integration_Log__c wlog = new Web_Integration_Log__c();
        wlog.Accountid__c = acc.id;
        wlog.OpportunityId__c = o.Id;
        wlog.Request_Action__c = 'AddNewCustomer';
        insert wlog;
        
        List<External_Session__c> sessions = [select id,is_active__c, Active_Date__c, Expires__c, Account__c, Opportunity__c from External_Session__c Limit 1];
        String cookieSession = CAA_Helper.EncryptData(sessions[0].Id);
        
        PageReference myVfPage = Page.CAA_Core;
        Test.setCurrentPage(myVfPage);
        Cookie cookie = new Cookie('applicationId', cookieSession, null, -1, false);
        ApexPages.currentPage().setCookies(new Cookie[]{cookie});
        //ApexPages.currentPage().getCookies().set('applicationId',String.Valueof(cookieSession));
        CAA_Core_Controller core = New CAA_Core_Controller();
        String m_SessionId = core.m_SessionId;
        String ExistingCustomerValue = core.ExistingCustomerValue;
        //Boolean IsABranch = core.IsABranch;
        String isYPSAAccount = core.isYPSAAccount;
        String SessionId = core.SessionId;
        Opportunity Opp = core.opp;
        core.m_EventLogId = log.Id;
        core.m_AccountId = acc.Id;
        string AccountId = core.AccountId;
        
        String logId = log.id;
        z_XmlMessage.CreateAddNewCustomerMessage();
        z_XmlMessage.CreateAJREssage();
        z_XmlMessage.CreateANCAllMessage();
        Z_TheXmlMessages.CreateOCAMessage();
        //IBBDependentObjectFactory.CreateANCRLAJARStubs (o);
        System.test.startTest(); 
        z_WebServiceMock mock = new z_WebServiceMock();
        mock.xml = '<?xml version="1.0" encoding="utf-8"?><soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema"><soap:Body><OperationResponse xmlns="http://www.islamic-bank.com/HPPDecisionEngine"><HPPDecisionEngineResponse><MessageID>a0oD0000007OHwZIAW</MessageID><MessageType>HPPDecisionEngineResponse</MessageType><DecisionId>86BF2236-E7F8-4244-B16B-D1C0E75A59DE</DecisionId><Decision>DECLINE-BDM14;REFER-BDM35;REFER-BDM36;</Decision><DecisionReason>DECLINE-BDM14 (DFF5AC28-6EC6-46A8-AF5F-F73ECD82B0D6 - Property not equal to \'absolute ownership\' in Scotland;) REFER-BDM35 (05B7D6AA-4D0D-472E-B982-652828AA8F3F - No of credit searches within the last 3 months at current address;) REFER-BDM36 (F0FE17BC-621E-40CD-A071-CDD50A252E5A - No of credit searches within the last 3 months at previous address;) </DecisionReason><DecisionExcludingWarnings>REFER-NOMATCH</DecisionExcludingWarnings><AcceptedFacilities /><RejectedFacilities /><SupplierScore>800</SupplierScore></HPPDecisionEngineResponse></OperationResponse></soap:Body></soap:Envelope>';             
        System.Test.setMock(WebServiceMock.class,mock);
        CAA_Core_Controller.CallEBSDE(logId,SessionId);
        system.test.stopTest();
    } */
    
    /*@isTest
    Public static Void CreateDocumenttest(){
        
        Opportunity o = [Select Id from Opportunity limit 1];
        Account acc = [Select Id from Account Limit 1];
        //system.debug(acc);
        Eventlog__c log = [Select Id,opportunity__c from Eventlog__c limit 1];
        External_Session__c es = new External_Session__c();
        es.Active_Date__c= date.today();
        es.Account__c=acc.id;
        es.Opportunity__c= o.id;
        insert es;
        Applicant__c apl =  new Applicant__c();
        apl.Prospect_Customer__c=acc.id;
        apl.Opportunity__c=log.opportunity__c;
        insert apl;
        List<External_Session__c> sessions = [select id,is_active__c, Active_Date__c, Expires__c, Account__c, Opportunity__c from External_Session__c Limit 1];
        String cookieSession = CAA_Helper.EncryptData(sessions[0].Id);
        
        PageReference myVfPage = Page.CAA_Core;
        Test.setCurrentPage(myVfPage);
        Cookie cookie = new Cookie('applicationId', cookieSession, null, -1, false);
        ApexPages.currentPage().setCookies(new Cookie[]{cookie});
        //ApexPages.currentPage().getCookies().set('applicationId',String.Valueof(cookieSession));
        CAA_Core_Controller core = New CAA_Core_Controller();
        String m_SessionId = core.m_SessionId;
        String ExistingCustomerValue = core.ExistingCustomerValue;
        Boolean IsABranch = core.IsABranch;
        String isYPSAAccount = core.isYPSAAccount;
        String SessionId = core.SessionId;
        Opportunity Opp = core.opp;
        core.m_EventLogId = log.Id;
        core.m_AccountId = acc.Id;
        string AccountId = core.AccountId;
        List<Campaign> Campaigns = core.Campaigns;
        IBB_Product__c Product = core.Product; 
        Boolean IsYPSA = core.IsYPSA;
        Boolean IsFTD = core.IsFTD;
        Boolean IsFTDISA = core.IsFTDISA;
        Boolean UseFITForISA = core.UseFITForISA;
        boolean UseFIT = core.UseFIT;
        string titleText = core.titleText;
        Boolean IsCurrentAccount = core.IsCurrentAccount;
        Boolean IsANC = core.IsANC;
        List<CAA_Data.KeyValue> InterestedIn = core.InterestedIn;
        List<CAA_Data.KeyValue> Titles = core.Titles;
        core.GoToLogin();
        core.Setup();
        Boolean IsFTDSetup = core.IsFTDSetup;
        Boolean IsFITSetup = core.IsFITSetup;
        core.FTD_Setup();
    
        core.EligibilitySetup();
        core.ISA_Transfer_Init();
        core.Product_Screen_Init();
        String EncOppId = core.EncOppId;
        core.SendToHost();
        core.Declaration_Summary();
        core.Declaration_Init();
        Boolean ShowImage = core.ShowImage;
        Boolean PageUsesKendo = core.PageUsesKendo;
        boolean showDirectSavingsAccountTC = core.showDirectSavingsAccountTC;
        boolean show60DayNoticeAccountTC = core.show60DayNoticeAccountTC;
        boolean show120DayNoticeAccountTC = core.show120DayNoticeAccountTC;
        boolean showOnDemandSavingsAccountTC = core.showOnDemandSavingsAccountTC;
        boolean showYPSATC = core.showYPSATC;
        boolean showISA = core.showISA;
        boolean showInstantISA = core.showInstantISA;
        boolean showFTDISA = core.showFTDISA;
        boolean showYPNATC = core.showYPNATC;
        boolean showFixedTermAccountTC = core.showFixedTermAccountTC;
        boolean showSmallFixedTermAccountTC = core.showSmallFixedTermAccountTC;
        boolean showCurrentText = core.showCurrentText;
        boolean showSavingText = core.showSavingText;
        boolean showCurrentAccountTC = core.showCurrentAccountTC;
        
        
        String logId = log.id;
        
        CongaSettings__c docu= new CongaSettings__c();
        docu.Name ='test';
        docu.Document_name__c = 'test';
        insert docu;
		CongaSettings__c docu1 = [select id from CongaSettings__c limit 1];
        CAA_Core_Controller.CreateDocument(logId,SessionId,docu1.Id);
    }
    
    @isTest
    Public static Void CompletePersonalDetailstest(){
        
        Opportunity o = [Select Id from Opportunity limit 1];
        Account acc = [Select Id from Account Limit 1];
        //system.debug(acc);
        Eventlog__c log = [Select Id,opportunity__c from Eventlog__c limit 1];
        External_Session__c es = new External_Session__c();
        es.Active_Date__c= date.today();
        es.Account__c=acc.id;
        es.Opportunity__c= o.id;
        insert es;
        /*Applicant__c apl =  new Applicant__c();
        apl.Prospect_Customer__c=acc.id;
        apl.Opportunity__c=log.opportunity__c;
        insert apl;
        HPP_Extended_Opportunity__c hpp = new HPP_Extended_Opportunity__c();
        hpp.Opportunity__c = o.Id;
        insert hpp;
        
        List<External_Session__c> sessions = [select id,is_active__c, Active_Date__c, Expires__c, Account__c, Opportunity__c from External_Session__c Limit 1];
        String cookieSession = CAA_Helper.EncryptData(sessions[0].Id);
        
        PageReference myVfPage = Page.CAA_Core;
        Test.setCurrentPage(myVfPage);
        Cookie cookie = new Cookie('applicationId', cookieSession, null, -1, false);
        ApexPages.currentPage().setCookies(new Cookie[]{cookie});
        //ApexPages.currentPage().getCookies().set('applicationId',String.Valueof(cookieSession));
        CAA_Core_Controller core = New CAA_Core_Controller();
        String m_SessionId = core.m_SessionId;
        String ExistingCustomerValue = core.ExistingCustomerValue;
        //Boolean IsABranch = core.IsABranch;
        String isYPSAAccount = core.isYPSAAccount;
        String SessionId = core.SessionId;
        Opportunity Opp = core.opp;
        core.m_EventLogId = log.Id;
        core.m_AccountId = acc.Id;
        string AccountId = core.AccountId;
        //List<Campaign> Campaigns = core.Campaigns;
        IBB_Product__c Product = core.Product; 
        String logId = log.id;
        
        CAA_Data.PersonalDetailsCompleteData personaldata= new CAA_Data.PersonalDetailsCompleteData();
        personaldata.PaperStatements = 'test';
        //personaldata.Campaign = c.Id;
        personaldata.EventLogId =log.Id;
        personaldata.ApprovalUser =userinfo.getUserId();
        personaldata.isEDD = true;
        CAA_Data.PrimaryApplicantData app = new CAA_Data.PrimaryApplicantData();
        app.Id = acc.id;
        app.HasEmail  = false;
        app.HasMail = false;
        app.HasPhone = false;
        app.HasSMS = false;
        app.LastName = 'test';
	    CAA_Data.MyDate md = new CAA_Data.MyDate(system.today());
        app.Date_Employment_Commenced_c = md;
        app.Date_of_birth_c =  new CAA_Data.MyDate(Date.newInstance(1994, 01, 01));
        app.Document_issue_date_c = md;
        app.Visa_expiry_date_c = new CAA_Data.MyDate(system.today()+30);
        app.Date_moved_to_address_c = new CAA_Data.MyDate(system.today()-20);
        app.Date_moved_to_previous_address_c = new CAA_Data.MyDate(system.today()-200);
        app.Self_Cert_Acknowledged_c  = false;
        personaldata.Applicants = New List<CAA_Data.PrimaryApplicantData>{app};
            
        CAA_Core_Controller.CompletePersonalDetails(personaldata,SessionId);
    }
    
    @isTest
    Public static Void CompletePersonalDetailsOverridetest(){
        
        Opportunity o = [Select Id from Opportunity limit 1];
        Account acc = [Select Id from Account Limit 1];
        //system.debug(acc);
        Eventlog__c log = [Select Id,opportunity__c from Eventlog__c limit 1];
        External_Session__c es = new External_Session__c();
        es.Active_Date__c= date.today();
        es.Account__c=acc.id;
        es.Opportunity__c= o.id;
        insert es;
        
        /*Applicant__c apl =  new Applicant__c();
        apl.Prospect_Customer__c=acc.id;
        apl.Opportunity__c=log.opportunity__c;
        insert apl; 
        HPP_Extended_Opportunity__c hpp = new HPP_Extended_Opportunity__c();
        hpp.Opportunity__c = o.Id;
        insert hpp;
        
        List<External_Session__c> sessions = [select id,is_active__c, Active_Date__c, Expires__c, Account__c, Opportunity__c from External_Session__c Limit 1];
        String cookieSession = CAA_Helper.EncryptData(sessions[0].Id);
        
        PageReference myVfPage = Page.CAA_Core;
        Test.setCurrentPage(myVfPage);
        Cookie cookie = new Cookie('applicationId', cookieSession, null, -1, false);
        ApexPages.currentPage().setCookies(new Cookie[]{cookie});
        //ApexPages.currentPage().getCookies().set('applicationId',String.Valueof(cookieSession));
        CAA_Core_Controller core = New CAA_Core_Controller();
        String m_SessionId = core.m_SessionId;
        String ExistingCustomerValue = core.ExistingCustomerValue;
        //Boolean IsABranch = core.IsABranch;
        String isYPSAAccount = core.isYPSAAccount;
        String SessionId = core.SessionId;
        Opportunity Opp = core.opp;
        core.m_EventLogId = log.Id;
        core.m_AccountId = acc.Id;
        string AccountId = core.AccountId;
        String logId = log.id;
        
        CAA_Data.PersonalDetailsCompleteData personaldata= new CAA_Data.PersonalDetailsCompleteData();
        personaldata.PaperStatements = 'test';
        //personaldata.Campaign = c.Id;
        personaldata.EventLogId =log.Id;
        personaldata.ApprovalUser =userinfo.getUserId();
        personaldata.isEDD = true;
        CAA_Data.PrimaryApplicantData app = new CAA_Data.PrimaryApplicantData();
        app.Id = acc.id;
        app.HasEmail  = false;
        app.HasMail = false;
        app.HasPhone = false;
        app.HasSMS = false;
        app.LastName = 'test';
	    CAA_Data.MyDate md = new CAA_Data.MyDate(system.today());
        app.Date_Employment_Commenced_c = md;
        app.Date_of_birth_c =  new CAA_Data.MyDate(Date.newInstance(1994, 01, 01));
        app.Document_issue_date_c = md;
        app.Visa_expiry_date_c = new CAA_Data.MyDate(system.today()+30);
        app.Date_moved_to_address_c = new CAA_Data.MyDate(system.today()-20);
        app.Date_moved_to_previous_address_c = new CAA_Data.MyDate(system.today()-200);
        app.Self_Cert_Acknowledged_c  = false;
        personaldata.Applicants = New List<CAA_Data.PrimaryApplicantData>{app};
            
        CAA_Core_Controller.CompletePersonalDetailsOverride(personaldata,SessionId);
    }
     
    @isTest
    Public static Void CompleteRMtest(){
        
        Opportunity o = [Select Id from Opportunity limit 1];
        Account acc = [Select Id from Account Limit 1];
        //system.debug(acc);
        Eventlog__c log = [Select Id,opportunity__c from Eventlog__c limit 1];
        //system.debug(log.id);
        External_Session__c es = new External_Session__c();
        es.Active_Date__c= date.today();
        es.Account__c=acc.id;
        es.Opportunity__c= o.id;
        insert es;
        
       Applicant__c apl =  new Applicant__c();
        apl.Prospect_Customer__c=acc.id;
        apl.Opportunity__c=log.opportunity__c;
        insert apl;
        
        HPP_Extended_Opportunity__c hpp = new HPP_Extended_Opportunity__c();
        hpp.Opportunity__c = o.Id;
        insert hpp;
        
        List<External_Session__c> sessions = [select id,is_active__c, Active_Date__c, Expires__c, Account__c, Opportunity__c from External_Session__c Limit 1];
        String cookieSession = CAA_Helper.EncryptData(sessions[0].Id);
        
        PageReference myVfPage = Page.CAA_Core;
        Test.setCurrentPage(myVfPage);
        Cookie cookie = new Cookie('applicationId', cookieSession, null, -1, false);
        ApexPages.currentPage().setCookies(new Cookie[]{cookie});
        //ApexPages.currentPage().getCookies().set('applicationId',String.Valueof(cookieSession));
        CAA_Core_Controller core = New CAA_Core_Controller();
        String m_SessionId = core.m_SessionId;
        String ExistingCustomerValue = core.ExistingCustomerValue;
        //Boolean IsABranch = core.IsABranch;
        String isYPSAAccount = core.isYPSAAccount;
        String SessionId = core.SessionId;
        Opportunity Opp = core.opp;
        core.m_EventLogId = log.Id;
        core.m_AccountId = acc.Id;
        string AccountId = core.AccountId;
        String logId = log.id;
        
        CAA_Data.PersonalDetailsCompleteData personaldata= new CAA_Data.PersonalDetailsCompleteData();
        personaldata.PaperStatements = 'test';
        //personaldata.Campaign = c.Id;
        personaldata.EventLogId =log.Id;
        personaldata.ApprovalUser =userinfo.getUserId();
        personaldata.isEDD = true;
        CAA_Data.PrimaryApplicantData app = new CAA_Data.PrimaryApplicantData();
        app.Id = acc.id;
        app.HasEmail  = false;
        app.HasMail = false;
        app.HasPhone = false;
        app.HasSMS = false;
        app.LastName = 'test';
	    CAA_Data.MyDate md = new CAA_Data.MyDate(system.today());
        app.Date_Employment_Commenced_c = md;
        app.Date_of_birth_c =  new CAA_Data.MyDate(Date.newInstance(1994, 01, 01));
        app.Document_issue_date_c = md;
        app.Visa_expiry_date_c = new CAA_Data.MyDate(system.today()+30);
        app.Date_moved_to_address_c = new CAA_Data.MyDate(system.today()-20);
        app.Date_moved_to_previous_address_c = new CAA_Data.MyDate(system.today()-200);
        app.Self_Cert_Acknowledged_c  = false;
        personaldata.Applicants = New List<CAA_Data.PrimaryApplicantData>{app};
            
        CAA_Core_Controller.CompleteRM(personaldata,SessionId);
    }
    
    /*@isTest
    Public static Void ResumeCallRecordingtest(){
        
        Opportunity o = [Select Id from Opportunity limit 1];
        Account acc = [Select Id from Account Limit 1];
        //system.debug(acc);
        Eventlog__c log = [Select Id,opportunity__c from Eventlog__c limit 1];
        External_Session__c es = new External_Session__c();
        es.Active_Date__c= date.today();
        es.Account__c=acc.id;
        es.Opportunity__c= o.id;
        insert es;
        Applicant__c apl =  new Applicant__c();
        apl.Prospect_Customer__c=acc.id;
        apl.Opportunity__c=log.opportunity__c;
        insert apl;
        List<External_Session__c> sessions = [select id,is_active__c, Active_Date__c, Expires__c, Account__c, Opportunity__c from External_Session__c Limit 1];
        String cookieSession = CAA_Helper.EncryptData(sessions[0].Id);
        
        PageReference myVfPage = Page.CAA_Core;
        Test.setCurrentPage(myVfPage);
        Cookie cookie = new Cookie('applicationId', cookieSession, null, -1, false);
        ApexPages.currentPage().setCookies(new Cookie[]{cookie});
        //ApexPages.currentPage().getCookies().set('applicationId',String.Valueof(cookieSession));
        CAA_Core_Controller core = New CAA_Core_Controller();
        String m_SessionId = core.m_SessionId;
        String ExistingCustomerValue = core.ExistingCustomerValue;
        Boolean IsABranch = core.IsABranch;
        String isYPSAAccount = core.isYPSAAccount;
        String SessionId = core.SessionId;
        Opportunity Opp = core.opp;
        core.m_EventLogId = log.Id;
        core.m_AccountId = acc.Id;
        string AccountId = core.AccountId;
        List<Campaign> Campaigns = core.Campaigns;
        IBB_Product__c Product = core.Product; 
        Boolean IsYPSA = core.IsYPSA;
        Boolean IsFTD = core.IsFTD;
        Boolean IsFTDISA = core.IsFTDISA;
        Boolean UseFITForISA = core.UseFITForISA;
        boolean UseFIT = core.UseFIT;
        string titleText = core.titleText;
        Boolean IsCurrentAccount = core.IsCurrentAccount;
        Boolean IsANC = core.IsANC;
        List<CAA_Data.KeyValue> InterestedIn = core.InterestedIn;
        List<CAA_Data.KeyValue> Titles = core.Titles;
        core.GoToLogin();
        core.Setup();
        Boolean IsFTDSetup = core.IsFTDSetup;
        Boolean IsFITSetup = core.IsFITSetup;
        core.FTD_Setup();

        core.EligibilitySetup();
        core.ISA_Transfer_Init();
        core.Product_Screen_Init();
        String EncOppId = core.EncOppId;
        core.SendToHost();
        core.Declaration_Summary();
        core.Declaration_Init();
        Boolean ShowImage = core.ShowImage;
        Boolean PageUsesKendo = core.PageUsesKendo;
        boolean showDirectSavingsAccountTC = core.showDirectSavingsAccountTC;
        boolean show60DayNoticeAccountTC = core.show60DayNoticeAccountTC;
        boolean show120DayNoticeAccountTC = core.show120DayNoticeAccountTC;
        boolean showOnDemandSavingsAccountTC = core.showOnDemandSavingsAccountTC;
        boolean showYPSATC = core.showYPSATC;
        boolean showISA = core.showISA;
        boolean showInstantISA = core.showInstantISA;
        boolean showFTDISA = core.showFTDISA;
        boolean showYPNATC = core.showYPNATC;
        boolean showFixedTermAccountTC = core.showFixedTermAccountTC;
        boolean showSmallFixedTermAccountTC = core.showSmallFixedTermAccountTC;
        boolean showCurrentText = core.showCurrentText;
        boolean showSavingText = core.showSavingText;
        boolean showCurrentAccountTC = core.showCurrentAccountTC;
        
        String logId = log.id;
        
        CAA_Core_Controller.ResumeCallRecording('5255',logId,SessionId);
    }*/
    
  /*  @isTest
    Public static Void get_Declaration_Summarytest(){
        
        Opportunity o = [Select Id from Opportunity limit 1];
        Account acc = [Select Id from Account Limit 1];
        //system.debug(acc);
        Eventlog__c log = [Select Id,opportunity__c from Eventlog__c limit 1];
        External_Session__c es = new External_Session__c();
        es.Active_Date__c= date.today();
        es.Account__c=acc.id;
        es.Opportunity__c= o.id;
        insert es;
        Applicant__c apl =  new Applicant__c();
        apl.Prospect_Customer__c=acc.id;
        apl.Opportunity__c=log.opportunity__c;
        insert apl;
        List<External_Session__c> sessions = [select id,is_active__c, Active_Date__c, Expires__c, Account__c, Opportunity__c from External_Session__c Limit 1];
        String cookieSession = CAA_Helper.EncryptData(sessions[0].Id);
        
        PageReference myVfPage = Page.CAA_Core;
        Test.setCurrentPage(myVfPage);
        Cookie cookie = new Cookie('applicationId', cookieSession, null, -1, false);
        ApexPages.currentPage().setCookies(new Cookie[]{cookie});
        //ApexPages.currentPage().getCookies().set('applicationId',String.Valueof(cookieSession));
        CAA_Core_Controller core = New CAA_Core_Controller();
        String m_SessionId = core.m_SessionId;
        String ExistingCustomerValue = core.ExistingCustomerValue;
        //Boolean IsABranch = core.IsABranch;
        String isYPSAAccount = core.isYPSAAccount;
        String SessionId = core.SessionId;
        Opportunity Opp = core.opp;
        core.m_EventLogId = log.Id;
        core.m_AccountId = acc.Id;
        string AccountId = core.AccountId;
        //List<Campaign> Campaigns = core.Campaigns;
        IBB_Product__c Product = core.Product; 
        Boolean IsYPSA = core.IsYPSA;
        Boolean IsFTD = core.IsFTD;
        Boolean IsFTDISA = core.IsFTDISA;
        Boolean UseFITForISA = core.UseFITForISA;
        boolean UseFIT = core.UseFIT;
        string titleText = core.titleText;
        Boolean IsCurrentAccount = core.IsCurrentAccount;
        Boolean IsANC = core.IsANC;
        //List<CAA_Data.KeyValue> InterestedIn = core.InterestedIn;
        //List<CAA_Data.KeyValue> Titles = core.Titles;
        core.GoToLogin();
        core.Setup();
        Boolean IsFTDSetup = core.IsFTDSetup;
        Boolean IsFITSetup = core.IsFITSetup;
        core.FTD_Setup();

        //core.EligibilitySetup();
        core.ISA_Transfer_Init();
        core.Product_Screen_Init();
        String EncOppId = core.EncOppId;
        core.SendToHost();
        core.Declaration_Summary();
        core.Declaration_Init();
        Boolean ShowImage = core.ShowImage;
        Boolean PageUsesKendo = core.PageUsesKendo;
        boolean showDirectSavingsAccountTC = core.showDirectSavingsAccountTC;
        boolean show60DayNoticeAccountTC = core.show60DayNoticeAccountTC;
        boolean show120DayNoticeAccountTC = core.show120DayNoticeAccountTC;
        boolean showOnDemandSavingsAccountTC = core.showOnDemandSavingsAccountTC;
        boolean showYPSATC = core.showYPSATC;
        boolean showISA = core.showISA;
        boolean showInstantISA = core.showInstantISA;
        boolean showFTDISA = core.showFTDISA;
        boolean showYPNATC = core.showYPNATC;
        boolean showFixedTermAccountTC = core.showFixedTermAccountTC;
        boolean showSmallFixedTermAccountTC = core.showSmallFixedTermAccountTC;
        boolean showCurrentText = core.showCurrentText;
        boolean showSavingText = core.showSavingText;
        boolean showCurrentAccountTC = core.showCurrentAccountTC;
        
        String logId = log.id;
        
        //CAA_Core_Controller.get_Declaration_Summary(logId,SessionId);
        
        User u = [select id,isactive,name from user where usertype='Guest' AND name like '%External CAA%'];
        
        External_Session__c exse = new External_Session__c();
        exse.Active_Date__c = Date.today();
        //exse.Expires__c =Date.today().adddays(1);
        exse.Opportunity__c=o.id;
        exse.Account__c =acc.id;
        insert exse;
        
        system.runAs(u){
            sessionid = CAA_Helper.EncryptData(exse.id);
           // CAA_Core_Controller.get_Declaration_Summary(logId,SessionId);
        }
        
    }
    
    
	@isTest
    Public static Void ProductSelectedtest(){
        test.startTest();
        Opportunity o = [Select Id from Opportunity limit 1];
        Account acc = [Select Id from Account Limit 1];
        //system.debug(acc);
        Eventlog__c log = [Select Id,opportunity__c,event__c from Eventlog__c limit 1];
        External_Session__c es = new External_Session__c();
        es.Active_Date__c= date.today();
        es.Account__c=acc.id;
        es.Opportunity__c= o.id;
        insert es;
        Applicant__c apl =  new Applicant__c();
        apl.Prospect_Customer__c=acc.id;
        apl.Opportunity__c=log.opportunity__c;
        insert apl;
        List<External_Session__c> sessions = [select id,is_active__c, Active_Date__c, Expires__c, Account__c, Opportunity__c from External_Session__c Limit 1];
        String cookieSession = CAA_Helper.EncryptData(sessions[0].Id);
        
        PageReference myVfPage = Page.CAA_Core;
        Test.setCurrentPage(myVfPage);
        Cookie cookie = new Cookie('applicationId', cookieSession, null, -1, false);
        ApexPages.currentPage().setCookies(new Cookie[]{cookie});
        //ApexPages.currentPage().getCookies().set('applicationId',String.Valueof(cookieSession));
        CAA_Core_Controller core = New CAA_Core_Controller();
        String m_SessionId = core.m_SessionId;
        String ExistingCustomerValue = core.ExistingCustomerValue;
       // Boolean IsABranch = core.IsABranch;
        String isYPSAAccount = core.isYPSAAccount;
        String SessionId = core.SessionId;
        Opportunity Opp = core.opp;
        core.m_EventLogId = log.Id;
        core.m_AccountId = acc.Id;
        string AccountId = core.AccountId;
        //List<Campaign> Campaigns = core.Campaigns;
        IBB_Product__c Product = core.Product; 
        Boolean IsYPSA = core.IsYPSA;
        Boolean IsFTD = core.IsFTD;
        Boolean IsFTDISA = core.IsFTDISA;
        Boolean UseFITForISA = core.UseFITForISA;
        boolean UseFIT = core.UseFIT;
        string titleText = core.titleText;
        Boolean IsCurrentAccount = core.IsCurrentAccount;
        Boolean IsANC = core.IsANC;
        //List<CAA_Data.KeyValue> InterestedIn = core.InterestedIn;
        //List<CAA_Data.KeyValue> Titles = core.Titles;
        core.GoToLogin();
        core.Setup();
        Boolean IsFTDSetup = core.IsFTDSetup;
        Boolean IsFITSetup = core.IsFITSetup;
        core.FTD_Setup();

        //core.EligibilitySetup();
        core.ISA_Transfer_Init();
        core.Product_Screen_Init();
        String EncOppId = core.EncOppId;
        core.SendToHost();
        core.Declaration_Summary();
        core.Declaration_Init();
        Boolean ShowImage = core.ShowImage;
        Boolean PageUsesKendo = core.PageUsesKendo;
        boolean showDirectSavingsAccountTC = core.showDirectSavingsAccountTC;
        boolean show60DayNoticeAccountTC = core.show60DayNoticeAccountTC;
        boolean show120DayNoticeAccountTC = core.show120DayNoticeAccountTC;
        boolean showOnDemandSavingsAccountTC = core.showOnDemandSavingsAccountTC;
        boolean showYPSATC = core.showYPSATC;
        boolean showISA = core.showISA;
        boolean showInstantISA = core.showInstantISA;
        boolean showFTDISA = core.showFTDISA;
        boolean showYPNATC = core.showYPNATC;
        boolean showFixedTermAccountTC = core.showFixedTermAccountTC;
        boolean showSmallFixedTermAccountTC = core.showSmallFixedTermAccountTC;
        boolean showCurrentText = core.showCurrentText;
        boolean showSavingText = core.showSavingText;
        boolean showCurrentAccountTC = core.showCurrentAccountTC;
        CAA_Data.AddNewApplicantData appdata = new CAA_Data.AddNewApplicantData();
        appdata.FirstName = 'Applicant Account DM1';
        appdata.LastName = 'Force26';
        appdata.Title = 'xyz'; 
        CAA_Core_Controller.IsExistingAccount(appdata,log.id,true);
        CAA_Data.ProductSelectedData data = new CAA_Data.ProductSelectedData();
        data.ProductId = Product.Id;
        data.PurposeOfAccount = 'Loan';
        data.NumberOfApplicants = 20;  
        data.Deposit =123.01;
        data.AccountId =acc.Id;
        CAA_Core_Controller ob = new CAA_Core_Controller();
        data.OpportunityId= o.Id;
        data.Receive_Salary_Benefits = true;
        data.Pay_Bills_Expenses= true;
        data.Domestic_Transfers_In_Out= true;
        data.International_Transfer_In_Out= true;
        data.Cash_Deposit_In_Out= true;
        data.Saving_Goals= true;
        data.Over16= 'test';
        data.Regular_payment_amount_c = 123.23;
        data.Payment_Frequency_c='test';
        data.Direct_debit_date_day_c='test';
        data.Name_of_current_Bank_Building_Society_c='test';
        data.Sort_Code_c = '123';
        data.HasRegularPayment= 'test';
        
        String logId = log.id;
        
        CAA_Core_Controller.ProductSelected(data,SessionId,false,false,false,false,false,false);
        
        User u = [select id,isactive,name from user where usertype='Guest' AND name like '%External CAA%'];
        
        External_Session__c exse = new External_Session__c();
        exse.Active_Date__c = Date.today();
        //exse.Expires__c =Date.today().adddays(1);
        exse.Opportunity__c=o.id;
        exse.Account__c =acc.id;
        insert exse;
        
        system.runAs(u){
             
            data.accountid = CAA_Helper.EncryptData(acc.id);
            data.opportunityid = CAA_Helper.EncryptData(o.id);
            sessionid = CAA_Helper.EncryptData(exse.id);
           // CAA_Core_Controller.ProductSelected(data,sessionid,false,false,false,false,false,false,false,false,false,false,false,false);
            CAA_Core_Controller.ProductSelected(data,SessionId,false,false,false,false,false,false);

        }
        test.stopTest();
        
    }
    
    @isTest
    Public static void ResumeCallRecordingTest(){
        
        User u = [select id,isactive,name from user where usertype='Guest' AND name like '%External CAA%'];
        system.runAs(u){
            CAA_Core_Controller.ResumeCallRecording(CAA_Helper.EncryptData('transactionId'),CAA_Helper.EncryptData('eventLogId'),CAA_Helper.EncryptData('sessionId'));
    	
        }
    }
    
    @isTest
    Public static void MakePaymentTest(){
        
        User u = [select id,isactive,name from user where usertype='Guest' AND name like '%External CAA%'];
        system.runAs(u){
            CAA_Core_Controller.MakePayment(new CAA_Data.TakePaymentData(),CAA_Helper.EncryptData('transactionId'),CAA_Helper.EncryptData('eventLogId'),CAA_Helper.EncryptData('sessionId'));
    	
        }
    }
    
    @isTest
    Public static void CreateDocumentTest(){
        
        User u = [select id,isactive,name from user where usertype='Guest' AND name like '%External CAA%'];
        system.runAs(u){
            CAA_Core_Controller.CreateDocument(CAA_Helper.EncryptData('eventLogId'),CAA_Helper.EncryptData('sessionId'),CAA_Helper.EncryptData('settingId'));
    	
        }
    }
   /* 
    @isTest
    Public static Void ANCSetuptest(){
        Account acc = [Select Id from Account Limit 1];
        //system.debug(acc);
        String accid = acc.id;
        CAA_Core_Controller.ANCSetup();
    }

	@isTest
    Public static Void EligibilitySetuptest(){
        
        Account acc1 = new Account();
        acc1.Firstname='Test1';
        acc1.Lastname='Test12';
        acc1.Salutation='Mr';
        acc1.Home_Telephone_No__c='9876543210';
        acc1.PersonEmail='test@test.com';
        acc1.BillingPostalCode='522510';
        acc1.Date_of_Birth__c=date.today();
        insert acc1;
       // Account acc = [Select Id,Salutation,Lastname from Account Limit 1];
        system.debug('salu str'+acc1);
        String accid = acc1.id;
        CAA_Core_Controller.EligibilitySetup(accid,'test');
    } */
    
    @isTest
    static list<Campaign> CampaignsTest(){
        Campaign c1 = new Campaign();
        c1.name = 'test';
        c1.isActive = true;
        Campaign c2 = new Campaign();
        c2.name = 'test';
        c2.isActive = true;
        insert new List<Campaign>{c1,c2};
        CAA_Core_Controller.GetCampaigns(c1.name);
        return null;
    } 
    
 
    
}