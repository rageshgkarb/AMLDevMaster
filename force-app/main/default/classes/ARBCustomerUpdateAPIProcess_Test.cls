@isTest
public class ARBCustomerUpdateAPIProcess_Test {
    @TestSetup
    static void setup(){
        Account ac= new Account(FirstName = 'Joe', LastName = 'Bloggs', Title_Other__c = 'Mr', BillingStreet = 'A\nB', ShippingStreet = 'A\nB', PersonMailingStreet = 'A\nB', Layers_of_Ownership__c  ='1 layer of ownership or less', 
                                Length_of_Establishment__c  = 'Over 3 years', Balance_Sheet_000s__c = 'Under £2.5m', Sanctioned_Individual_Check__c = 'No true match identified', 
                                Previously_Exited_or_Declined__c = 'No true match identified',  Source_of_Funds__c = 'Account funded from a bank account in the UK', 
                                Nature_of_Business_NPAA__c = 'Club, Association or Community', Face_to_face_Contact__c  = 'No UBO or Significant Controller met face to face', 
                                Politically_Exposed_Company__c = 'No True Match', Negative_News_Screening__c = 'No true match identified', Organisation_type__c = 'Limited Company', 
                                Organisation_Domicile__c =   '', High_risk_prohibited_sanctioned_countr__c = 'United Kingdom', HR_Prohibited_sanctioned_COR_for_UBOs_I__c = 'United Kingdom', 
                                Customer_Type__c = 'Limited Company',Gender__c ='Male',Marital_Status__c= 'Married',Date_of_Birth__c= Date.today()-7300,
                                UK_Citizen__c = 'No',ID_Evidence__c = 'Contact Center',ID_Serial_No__c = '123AA0',Proof_of_Address__c='Not Provided');
        
        insert ac;
        
        //RecordTypeId ='012D0000000QQfrIAG'
        
        Opportunity opp = new Opportunity(closedate = date.today(), AccountId = ac.id, Name = 'Test Opp', Interested_in__c = 'TestA', Purchase_price_market_value__c = 300000, Finance_Required__c = 100000, 
                                          Term_of_Finance__c=25, number_of_people_applying__c = 1, Source_of_Funds__c = 'Account funded from a bank account in the UK', StageName = 'Personal Details');
        
        insert opp;
    }

    @isTest static void CustomerUpdateAPIProcessTest(){
        
         Set<Id> actIds = new Set<Id>();
         Map<String,String> oppAcc = new Map<String,String>();
         Account act = [Select Id,Name from Account];
         actIds.add(act.Id);
         
        Opportunity oppt = [Select ID,Name,Interested_in__c from Opportunity where Interested_in__c = 'TestA'];
 		
        oppAcc.put(oppt.Id,act.Id);
        String response1 = '{"MessageId": "123","TNId": 123,"InitialDecision": "Pass","Decision": "Pass","ErrorCode": null,"ErrorMessage": null,"RuleOutcomes": [{"RuleName": "Test Rule","Outcome": true,"Score": 100}],"TNResponse": {"accountId":1234,"status": {"code": "CLOSE","label": "CLOSE"},"decision": {"code": "CLOSE","label": "CLOSE"},"Applications": [{"uid": "123","auditReference": "123","runId": 123,"journeyId": {"id": 123,"name": "Test Journey"},"organisationId": {"id": 123},"country": "USA","user": {"id": 123,"name": "Test User"},"nameReference": "Test Name","riskLevel": "High","journeyType": {"id": 123,"label": "Test Journey"},"startDateTime": "2023-03-15T10:05:44.475Z","endDateTime": "2023-03-15T10:05:44.475Z","progressStatus": {"code": "Pass","label": "Pass"},"decision": {"code": "Pass","label": "Pass"},"rulesetOutcomes": [{"reference": "Test Reference","score": 100,"ruleOutcomes": [{"RuleName": "Test Rule","Outcome": true,"Score": 100}],"riskLevel": "High"}],"links": [{"code": "Test Code","url": "http://test.com"}]}]}}';
         
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new ARBCustomerAMLAPIMock(response1));
        ARBCustomerUpdateAPIProcess updateProcess = new ARBCustomerUpdateAPIProcess(actIds,oppAcc);
        Test.stopTest();        
    }
    
    
}