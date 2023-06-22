@isTest
public class ARBCustomerAMLRequestHelper_Test {

    @testSetup
    static void dataSetup(){
        
        Account ac= new Account(FirstName = 'Joe', LastName = 'Bloggs', Title_Other__c = 'Mr', BillingStreet = 'A\nB', ShippingStreet = 'A\nB', PersonMailingStreet = 'A\nB', Layers_of_Ownership__c  ='1 layer of ownership or less', 
                                Length_of_Establishment__c  = 'Over 3 years', Balance_Sheet_000s__c = 'Under £2.5m', Sanctioned_Individual_Check__c = 'No true match identified', 
                                Previously_Exited_or_Declined__c = 'No true match identified',  Source_of_Funds__c = 'Account funded from a bank account in the UK', 
                                Nature_of_Business_NPAA__c = 'Club, Association or Community', Face_to_face_Contact__c  = 'No UBO or Significant Controller met face to face', 
                                Politically_Exposed_Company__c = 'No True Match', Negative_News_Screening__c = 'No true match identified', Organisation_type__c = 'Limited Company', 
                                Organisation_Domicile__c =   '', High_risk_prohibited_sanctioned_countr__c = 'United Kingdom', HR_Prohibited_sanctioned_COR_for_UBOs_I__c = 'United Kingdom',                            
                                Customer_Type__c = 'Limited Company', TN_accountId__c= '947169', TN_Manual_Screening_Required__c= '',Gender__c ='Male',Marital_Status__c= 'Married',Date_of_Birth__c= Date.today()-7300,
                               UK_Citizen__c = 'No',ID_Evidence__c = 'Contact Center',ID_Serial_No__c = '123AA0',Proof_of_Address__c='Not Provided');
        insert ac;
        //RecordTypeId='012D0000000QQkOIAW';
        system.debug('Account ID is: '+ ac.Id);
        system.debug('Organisation type is:'+ ac.Organisation_type__c);
        system.debug('SFDC ID is: '+ ac.SFDC_ID__c);
        
        IBB_Product_Set__c productSet = new IBB_Product_Set__c();
        productSet.Name = 'Test'; 
        productSet.Max_No_of_Applicants__c = 4;
        productSet.ProductSetType__c = 'btl';
        insert productSet;
        
        IBB_Product__c product = new IBB_Product__c();
        product.Name = 'Test';
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
        
        //List<Opportunity> optyList = new List<Opportunity>();
        Opportunity opp = new Opportunity(closedate = date.today(), AccountId = ac.id, Name = 'Test Oppy', Interested_in__c = 'Test', Purchase_price_market_value__c = 300000, Finance_Required__c = 100000, 
                                          Term_of_Finance__c=25, number_of_people_applying__c = 1, Source_of_Funds__c = 'Account funded from a bank account in the UK',StageName = 'Completed',IBB_Product__c = product.Id);
        insert opp;
        
        // Opportunity opp1 = new Opportunity(AccountId = ac.id, Name = 'Test aml', StageName = 'Completed',closedate = date.today()+2);
        //optyList.add(opp);
        //optyList.add(opp1);
        //insert optyList;
        
        Case csrec= new Case(FCUSatisfied__c = 'Yes', Referral_Decision__c = 'Accept', Subject = 'TestSubject', Description = 'TestDescription', Status = 'Awaiting Allocation', AccountId = ac.id, Opportunity__c = opp.id);           
        insert csrec;    
    }
    
    @isTest
    public static void requestHelperMethod(){
        
        Account ac= new Account(FirstName = 'Joe', LastName = 'Bloggs', Title_Other__c = 'Mr', BillingStreet = 'A\nB', ShippingStreet = 'A\nB', PersonMailingStreet = 'A\nB', Layers_of_Ownership__c  ='1 layer of ownership or less', 
                                Length_of_Establishment__c  = 'Over 3 years', Balance_Sheet_000s__c = 'Under £2.5m', Sanctioned_Individual_Check__c = 'No true match identified', 
                                Previously_Exited_or_Declined__c = 'No true match identified',  Source_of_Funds__c = 'Account funded from a bank account in the UK', 
                                Nature_of_Business_NPAA__c = 'Club, Association or Community', Face_to_face_Contact__c  = 'No UBO or Significant Controller met face to face', 
                                Politically_Exposed_Company__c = 'No True Match', Negative_News_Screening__c = 'No true match identified', Organisation_type__c = 'Limited Company', 
                                Organisation_Domicile__c =   '', High_risk_prohibited_sanctioned_countr__c = 'United Kingdom', HR_Prohibited_sanctioned_COR_for_UBOs_I__c = 'United Kingdom',                            
                                Customer_Type__c = 'Limited Company', TN_accountId__c= '947169', TN_Manual_Screening_Required__c= '',Gender__c ='Male',Marital_Status__c= 'Married',Date_of_Birth__c= Date.today()-7300,
                               UK_Citizen__c = 'No',ID_Evidence__c = 'Contact Center',ID_Serial_No__c = '123AA0',Proof_of_Address__c='Not Provided');
        insert ac;
        //RecordTypeId='012D0000000QQkOIAW';
        system.debug('Account ID is: '+ ac.Id);
        system.debug('Organisation type is:'+ ac.Organisation_type__c);
        system.debug('SFDC ID is: '+ ac.SFDC_ID__c);
        
        IBB_Product_Set__c productSet = new IBB_Product_Set__c();
        productSet.Name = 'Test'; 
        productSet.Max_No_of_Applicants__c = 4;
        productSet.ProductSetType__c = 'btl';
        insert productSet;
        
        IBB_Product__c product = new IBB_Product__c();
        product.Name = 'Test';
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
        
        //List<Opportunity> optyList = new List<Opportunity>();
        Opportunity opp = new Opportunity(closedate = date.today(), AccountId = ac.id, Name = 'Test Oppy', Interested_in__c = 'Test', Purchase_price_market_value__c = 300000, Finance_Required__c = 100000, 
                                          Term_of_Finance__c=25, number_of_people_applying__c = 1, Source_of_Funds__c = 'Account funded from a bank account in the UK',StageName = 'Completed',IBB_Product__c = product.Id);
        insert opp;
        
        // Opportunity opp1 = new Opportunity(AccountId = ac.id, Name = 'Test aml', StageName = 'Completed',closedate = date.today()+2);
        //optyList.add(opp);
        //optyList.add(opp1);
        //insert optyList;
        
        Case csrec= new Case(FCUSatisfied__c = 'Yes', Referral_Decision__c = 'Accept', Subject = 'TestSubject', Description = 'TestDescription', Status = 'Awaiting Allocation', AccountId = ac.id, Opportunity__c = opp.id);           
        insert csrec; 
        
        Related_Customer_Entity__c relCusEntity = new Related_Customer_Entity__c();
        relCusEntity.Business_Name__c = 'Test Business Account';
        relCusEntity.Account__c = ac.Id;
        relCusEntity.Date_of_Birth__c = Date.today()-7300;
        insert relCusEntity;
        
        List<Account> acctList = [Select Id, LastName,FirstName from Account];
        system.debug('acctList::'+acctList);
        
        List<Opportunity> oppty = [Select Id,Name,closedate,AccountId,Application_Reference_Number__c from Opportunity];
        system.debug('oppty::'+oppty);
        
        Map < String, Asset_Relationship__c > accountToAssetMap = new Map < String, Asset_Relationship__c > ();
        for ( Asset_Relationship__c assetRecord : [ SELECT Id, Relationship_To_Primary_Applicant1__c, Prospect_Customer__c 
                                                   FROM Asset_Relationship__c
                                                   WHERE Prospect_Customer__c =:ac.Id]) {
                                                       accountToAssetMap.put ( assetRecord.Prospect_Customer__c, assetRecord);
                                                    }        
        
        
        
        ARBCustomerAMLRequestHelper.buildCustomerRequest(oppty[0].Id);
        
        ARBCustomerAMLRequestHelper.buildCustomerRequest(ac,opp,accountToAssetMap,true);
        
        ARBCustomerAMLRequestHelper.buildRelatedEntityRequest(relCusEntity, oppty[0]);
 
        
        
    }
}