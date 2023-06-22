@IsTest
public class RiskUtilsTest {
    
    @TestSetup
    Public static void TestSetup(){
        Account acc = new Account();
        acc.Name = 'Testing';
        acc.Next_Risk_Review_Date__c = system.today();
        insert acc;
        
        Opportunity opp = new Opportunity();
        opp.Name='Testing';
        opp.AccountId = acc.Id;
        opp.StageName='open';
        opp.CloseDate = system.today();
        insert opp; 
        
        Case cs = new case();
        cs.Status='Open';
        cs.Subject='ACreated by OvernightZ';
        insert cs;
        
        Golden_Source__c gs = new Golden_Source__c();
         gs.Customer__c = acc.Id;
         gs.Risk_Status__c = 'High Risk';
         gs.Account_External__c = acc.Id;
         insert gs;
        
        Webservice_Setting__c ws = new Webservice_Setting__c();
        ws.Value__c = 'https://google.com';
        ws.Name = 'HTTP Soap NS';
        insert ws;
    }
  
    @IsTest
    static void getBusinessCustomerRMStatusTest(){
        Opportunity opp = [SELECT Id,RM_Decision__c,accountId,Name FROM Opportunity limit 1];
        ContentVersion cv = new ContentVersion();
         cv.Description  = 'test description';
         cv.PathOnClient =opp.Name+'.txt';
         cv.Title = 'test file '+DateTime.now();
         cv.versiondata=Blob.valueOf('test file body');
         insert cv;

        ContentDocumentLink cdl = new ContentDocumentLink();
         cdl.ContentDocumentId = [SELECT Id, ContentDocumentId FROM ContentVersion WHERE Id =: cv.Id].ContentDocumentId;
         cdl.LinkedEntityId =opp.accountId;
         insert cdl;
        
        RiskUtils.getBusinessCustomerRMStatus(opp);
    }
     @IsTest
    static void getBusinessCustomerRMStatusTest2(){
        Opportunity opp = [SELECT Id,RM_Decision__c,accountId,Name FROM Opportunity limit 1];
       // RiskUtils.getBusinessCustomerRMStatus(opp);
         Case c = new Case();
        c.Referral_Decision__c = 'Accept';
        c.Status = 'Closed';
        c.Subject = 'Risk Score';
        c.Opportunity__c=opp.Id;
        insert c;
        
        RiskScoreThreshold__c rs = new RiskScoreThreshold__c();
        rs.Threshold_Value__c = 2.4;
        rs.Name = 'High';
        insert rs;
        
        Attachment att = new Attachment();
        att.Name=opp.Name+'.txt';
        att.Body= blob.valueOf('Testing');
        att.ParentId=opp.AccountId;
        insert att;
        RiskUtils.getBusinessCustomerRMStatus(opp);
    }
    @IsTest
    static void getBusinessCustomerRMStatusTest3(){
        Opportunity opp = [SELECT Id,RM_Decision__c,accountId,Name FROM Opportunity limit 1];
       // RiskUtils.getBusinessCustomerRMStatus(opp);
        
        Attachment att = new Attachment();
        att.Name=opp.Name+'.txt';
        att.Body= blob.valueOf('Testing');
        att.ParentId=opp.AccountId;
        insert att;
        RiskUtils.getBusinessCustomerRMStatus(opp);
    }
    
    @IsTest
    static void raiseCaseforRiskEscalationTest(){
        Opportunity opp = [SELECT Id,RM_Decision__c,accountId FROM Opportunity limit 1];
        Profile p = [SELECT Id FROM Profile WHERE Name='Standard User']; 
        User umgr = new User(Alias = 'mstandt', Email='manafer@testorg.com', EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = p.Id, TimeZoneSidKey='America/Los_Angeles', UserName='testingarb@arbtestin.com');
        insert umgr ;
        User u = new User(Alias = 'standt', Email='standarduser@testorg.com', 
        EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
        LocaleSidKey='en_US', ProfileId = p.Id, 
        TimeZoneSidKey='America/Los_Angeles', UserName='testingarbuser@arbtestin.com', managerid=umgr.id );
                             
        system.runAs(u){
            try{
                RiskUtils.raiseCaseforRiskEscalation(opp.AccountId,opp);
            }catch(Exception e){
                
            }
            
        }
        
    }
    @IsTest
    static void raiseCaseforReviewRiskTest(){
        List<Account> AccountList=[Select Id,Next_Risk_Review_Date__c From Account limit 1];
        Profile p = [SELECT Id FROM Profile WHERE Name='Standard User']; 


        User umgr = new User(Alias = 'mstandt', Email='manafer@testorg.com', EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = p.Id, TimeZoneSidKey='America/Los_Angeles', UserName='testingarb@arbtestin.com');
        insert umgr ;
        User u = new User(Alias = 'standt', Email='standarduser@testorg.com', 
        EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
        LocaleSidKey='en_US', ProfileId = p.Id, 
        TimeZoneSidKey='America/Los_Angeles', UserName='testingarbuser@arbtestin.com', managerid=umgr.id );
                             
        system.runAs(u){
            try{
                RiskUtils.raiseCaseforReviewRisk(AccountList);
            }catch(Exception e){
                
            }
            
        }
        
    }
    @IsTest
    static void raiseCaseforNonPersonalReviewTest(){
        
        Opportunity opp = [SELECT Id,RM_Decision__c,accountId FROM Opportunity limit 1];
        RiskUtils.raiseCaseforNonPersonalReview(opp);
    }
    
    @IsTest
    static void raiseCaseforOvernightCreateCaseTest(){
        Account acc= [Select id, Name, Next_Risk_Review_Date__c from Account];
        acc.Overnight_Panoptic_Score__c='';
        acc.Panoptic_Score__c='';
        update acc;
        
        Map<Id, Account> oldMapAccount = new Map<Id, Account>();
        oldMapAccount.put(acc.id,acc);
              
        RiskScoreThreshold__c rs = new RiskScoreThreshold__c();
        rs.Threshold_Value__c = 2.4;
        rs.Name = 'High';
        insert rs;
            
        List<Account> newAccList= new List<Account>();
        newAccList.add(acc);
        newAccList[0].Overnight_Panoptic_Score__c='15';
        newAccList[0].Panoptic_Score__c='10';
                   
        update newAccList;
        
        Case c=[Select id,status, subject from case];
               
        
        RiskUtils.raiseCaseforOvernight(oldMapAccount,newAccList);
    }
    
    @IsTest
    static void raiseCaseforOvernightTest2(){
        Account acc= [Select id, Name, Next_Risk_Review_Date__c from Account];
        acc.Overnight_Panoptic_Score__c='1';
        acc.Panoptic_Score__c='2';
        update acc;

		Map<Id, Account> oldMapAccount = new Map<Id, Account>();
        oldMapAccount.put(acc.id,acc);
        
                
        /*Account newAcc = new Account();
        newAcc.Name = 'Testing2';
        newAcc.Next_Risk_Review_Date__c = system.today();
        newAcc.Overnight_Panoptic_Score__c='15';
        newAcc.Panoptic_Score__c='15';
        insert newAcc;
                
        List<Account> newAccList= new List<Account>();
        newAccList.add(newAcc);
        update newAccList;*/
        
        List<Account> newAccList= new List<Account>();
        newAccList.add(acc);
        newAccList[0].Overnight_Panoptic_Score__c='5';
        newAccList[0].Panoptic_Score__c='10';
                   
        update newAccList;
        
        RiskScoreThreshold__c rs = new RiskScoreThreshold__c();
        rs.Threshold_Value__c = 2.4;
        rs.Name = 'High';
        insert rs;
             
        Case c=[Select id,status, subject from case];
        c.AccountId=newAccList[0].id;
        update c;
        
        Golden_Source__c gs= [Select Customer__c, Risk_Status__c from Golden_Source__c];
        gs.Account_External__c = newAccList[0].Id;
        update gs;
        
        RiskUtils.raiseCaseforOvernight(oldMapAccount,newAccList);
    }
    
        @IsTest
    static void raiseCaseforOvernightTest3(){
        Account acc= [Select id, Name, Next_Risk_Review_Date__c from Account];
        acc.Overnight_Panoptic_Score__c='2';
        acc.Panoptic_Score__c='1';
        update acc;
        
        Map<Id, Account> oldMapAccount = new Map<Id, Account>();
        oldMapAccount.put(acc.Id,acc);
        
        List<Account> newAccList= new List<Account>();
        newAccList.add(acc);
            
        newAccList[0].Overnight_Panoptic_Score__c='10';
        newAccList[0].Panoptic_Score__c='10';
       	update newAccList;
        system.debug('oldMapAccount.get(acc.Id).Panoptic_Score__c:' + oldMapAccount.get(newAccList[0].Id).Panoptic_Score__c );
        system.debug('newAccList[0].Panoptic_Score__c:'+ newAccList[0].Panoptic_Score__c);
        
        RiskScoreThreshold__c rs = new RiskScoreThreshold__c();
        rs.Threshold_Value__c = 2.4;
        rs.Name = 'High';
        insert rs;
        
        Case c=[Select id,status, subject from case];
                
        RiskUtils.raiseCaseforOvernight(oldMapAccount,newAccList);
    }
    
    @IsTest
    static void raiseCaseforRiskEscalationNPTest(){
        Account acc= [Select id, Name, Next_Risk_Review_Date__c from Account];
        Opportunity opp = [SELECT Id,RM_Decision__c,accountId FROM Opportunity limit 1];
        RiskUtils.raiseCaseforRiskEscalationNP(acc.Id, opp);
    }
    
    @IsTest
    static void raiseCaseforRiskEscalationFutureNPTest(){
        Account acc= [Select id, Name, Next_Risk_Review_Date__c from Account];
        Opportunity opp = [SELECT Id,RM_Decision__c,accountId FROM Opportunity limit 1];
        RiskUtils.raiseCaseforRiskEscalationFutureNP(acc.Id, opp.id);
    }
    
    
}