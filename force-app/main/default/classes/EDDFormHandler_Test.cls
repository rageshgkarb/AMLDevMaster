@isTest
public class EDDFormHandler_Test {
    
    @testSetup
    public static void setup(){
        
        Case cs = new Case();
        cs.Contact_address__c = 'United Kingdom';
        insert cs;
        
        EDD_Form__c eddForm = new EDD_Form__c();
        eddForm.Closing_Comments__c = 'Test EDD Form';
        eddForm.EDD_Review_SF_Case_Number__c = cs.Id;
        insert eddForm;
        
        Account ac= new Account(FirstName = 'Joe', LastName = 'Bloggs', Title_Other__c = 'Mr', BillingStreet = 'A\nB', ShippingStreet = 'A\nB', PersonMailingStreet = 'A\nB', Layers_of_Ownership__c  ='1 layer of ownership or less', 
                                Length_of_Establishment__c  = 'Over 3 years', Balance_Sheet_000s__c = 'Under £2.5m', Sanctioned_Individual_Check__c = 'No true match identified', 
                                Previously_Exited_or_Declined__c = 'No true match identified',  Source_of_Funds__c = 'Account funded from a bank account in the UK', 
                                Nature_of_Business_NPAA__c = 'Club, Association or Community', Face_to_face_Contact__c  = 'No UBO or Significant Controller met face to face', 
                                Politically_Exposed_Company__c = 'No True Match', Negative_News_Screening__c = 'No true match identified', Organisation_type__c = 'Limited Company', 
                                Organisation_Domicile__c =   '', High_risk_prohibited_sanctioned_countr__c = 'United Kingdom', HR_Prohibited_sanctioned_COR_for_UBOs_I__c = 'United Kingdom', 
                                Customer_Type__c = 'Limited Company');
        insert ac;
        
        Account_with_IBB__c accIbb = new Account_with_IBB__c();
        accIbb.Primary_SFDC_Account__c = ac.Id;
        accIbb.Account_Blocked__c = 'Accou';
        accIbb.Account_Closed__c = 'Y';
        insert accIbb;
        
    }
    
    @isTest
    public static void testMethod1(){
        
         Account ac= new Account(FirstName = 'Joe', LastName = 'Bloggs', Title_Other__c = 'Mr', BillingStreet = 'A\nB', ShippingStreet = 'A\nB', PersonMailingStreet = 'A\nB', Layers_of_Ownership__c  ='1 layer of ownership or less', 
                                Length_of_Establishment__c  = 'Over 3 years', Balance_Sheet_000s__c = 'Under £2.5m', Sanctioned_Individual_Check__c = 'No true match identified', 
                                Previously_Exited_or_Declined__c = 'No true match identified',  Source_of_Funds__c = 'Account funded from a bank account in the UK', 
                                Nature_of_Business_NPAA__c = 'Club, Association or Community', Face_to_face_Contact__c  = 'No UBO or Significant Controller met face to face', 
                                Politically_Exposed_Company__c = 'No True Match', Negative_News_Screening__c = 'No true match identified', Organisation_type__c = 'Limited Company', 
                                Organisation_Domicile__c =   '', High_risk_prohibited_sanctioned_countr__c = 'United Kingdom', HR_Prohibited_sanctioned_COR_for_UBOs_I__c = 'United Kingdom', 
                                Customer_Type__c = 'Limited Company');
         insert ac;
        
        Case cs = new Case();
        cs.Contact_address__c = 'United Kingdom';
        insert cs;
        
        EDD_Form__c eddForm = new EDD_Form__c();
        eddForm.Closing_Comments__c = 'Test EDD Form';
        eddForm.EDD_Review_SF_Case_Number__c = cs.Id;
        insert eddForm;
        
        Account_with_IBB__c accIbb = new Account_with_IBB__c();
        accIbb.Primary_SFDC_Account__c = ac.Id;
        accIbb.Account_Blocked__c = 'Accou';
        accIbb.Account_Closed__c = 'Y';
        insert accIbb;
        
       
        
       // EDD_Form__c eddformId = [Select Name, Id from EDD_Form__c Where Closing_Comments__c = 'Test EDD Form'];
        
        string saveObj = '{"eddId":"'+eddForm.Id+'","itemCount":0,"accountId":"001D000001FBF1AIAX","caseId":"5003z00002XGSMhAAP","reviewType":"EDR","jsonReferenceName":"[]","relationshipManager":"005200000016PV1AAM","reviewPreparedBy":"0053z00000ClGhuAAF","onboardingcaseno":"5002500000KwBHSAA3","expAnnualTurnover":5000,"linkaccounts":[{"caccebsid":"476725","caccId":"001D000002FvUp8IAF","caccName":"ADEBAYO Force26","caccNameebs":"ADEBAYO Force26 - 476725","id":"a7n25000001CXvJAAW"},{"caccebsid":"013883","caccId":"001D000002IBS6ZIAX","caccName":"123 Technology Limited","caccNameebs":"123 Technology Limited - 013883","id":"a7n25000001CXvEAAW"},{"caccebsid":"012979","caccId":"001D000001mUS7mIAG","caccName":"154 Bayswater Road Limited","caccNameebs":"154 Bayswater Road Limited - 012979","id":"a7n25000001CXvFAAW"},{"caccebsid":"014148","caccId":"0013z00002mBh7dAAC","caccName":"1MPR ESTATES LTD","caccNameebs":"1MPR ESTATES LTD - 014148","id":"a7n25000001CXvGAAW"}],"abtCustomer":"About the customer","corporatestructure":"No","rrcorporatestructure":"No","spvtrust":"N/A","reasonEntityType":"Yes","structurecomplex":"Yes","kycselectedDate":"2023-03-02","KYCRecommendation":"Retain","ScreenedParties":"input saving","KycAnalystComments":"KYC ANALUST RECOMM","PEPScreeningPositiveMatch":"True Match","IDVPartiesComments":"sdfsdfsdfsdfsdfsdfsdf","totalAssets":0,"totalLibs":500,"netWorth":10,"customeraccounts":[],"IssuedDate":"2023-03-07","NextRenewalDate":"2023-03-22","isSubmittedEDD":false}';
            
            system.debug('saveObj::'+saveObj);
        
        EDDFormHandler.save(saveObj,'submitEDD');
        
    }
    
}