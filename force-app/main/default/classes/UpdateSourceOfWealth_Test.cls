@isTest
public class UpdateSourceOfWealth_Test {

    @testSetup
    public static void setup(){
        
        Case cs = new Case();
            cs.Contact_address__c = 'United Kingdom';
            insert cs;
        
        
        EDD_Form__c eddForm = new EDD_Form__c();
            eddForm.Closing_Comments__c = 'Test EDD Form';
            eddForm.EDD_Review_SF_Case_Number__c = cs.Id;
       		insert eddForm;
        
        List<Source_of_Wealth_Funds__c> sowfList = new List<Source_of_Wealth_Funds__c>();
        
            Source_of_Wealth_Funds__c sowf = new Source_of_Wealth_Funds__c();
            sowf.Name = 'Bank Finance';
            sowf.Amount__c = 1000;
            sowf.Comments__c = 'Source of Wealth Comments';
            sowf.Change_since_last_review__c = 'Yes';
            sowf.EDD__c = eddForm.Id;
            sowf.Case__c = cs.Id;
            sowf.Source__c = 'Source Of Wealth';
        	sowf.Reference__c = 'Reference 1';
        	sowf.Type_Of_Source__c = 'Assets';
            sowfList.add(sowf);
            
            Source_of_Wealth_Funds__c sowf1 = new Source_of_Wealth_Funds__c();
            sowf1.Name = 'Business Finance';
            sowf1.Amount__c = 2000;
            sowf1.Comments__c = 'Source of Wealth Comments';
            sowf1.Change_since_last_review__c = 'Yes';
            sowf1.EDD__c = eddForm.Id;
            sowf1.Case__c = cs.Id;
            sowf1.Source__c = 'Source Of Wealth';
        	sowf1.Reference__c = 'Reference 2';
        	sowf1.Type_Of_Source__c = 'Liabilities';
            sowfList.add(sowf1);
        
        	 Source_of_Wealth_Funds__c sowf2 = new Source_of_Wealth_Funds__c();
            sowf2.Name = 'Bank Finance';
            sowf2.Amount__c = 1000;
            sowf2.Comments__c = 'Source of Wealth Comments';
            sowf2.Change_since_last_review__c = 'Yes';
            sowf2.Case__c = cs.Id;
            sowf2.Source__c = 'Source Of Wealth';
        	sowf2.Reference__c = 'Reference 3';
        	sowf2.Type_Of_Source__c = 'Assets';
            sowfList.add(sowf2);
        
        	Source_of_Wealth_Funds__c sowf3 = new Source_of_Wealth_Funds__c();
            sowf3.Name = 'Bank Finance';
            sowf3.Amount__c = 1000;
            sowf3.Comments__c = 'Source of Wealth Comments';
            sowf3.Change_since_last_review__c = 'Yes';
            sowf3.Case__c = cs.Id;
            sowf3.Source__c = 'Source Of Wealth';
        	sowf3.Reference__c = 'Reference 4';
        	sowf3.Type_Of_Source__c = 'Liabilities';
            sowfList.add(sowf3);
            
        insert sowfList;
    }
    
    @isTest
    public static void testGetAsset(){
        
        EDD_Form__c edd = [Select Id, Name, Closing_Comments__c,EDD_Review_SF_Case_Number__c From EDD_Form__c
                              where Closing_Comments__c = 'Test EDD Form'];
        
        
        Source_of_Wealth_Funds__c sowfList = [Select id,Case__c, EDD__c, Amount__c, Change_since_last_review__c, 
                                                Comments__c, Type_Of_Source__c,Name,Source__c,Reference__c
                                                from Source_of_Wealth_Funds__c 
                                                where EDD__c=: edd.Id and Type_Of_Source__c = 'Assets'];
        
        Source_of_Wealth_Funds__c sowfList1 = [Select id,Case__c, EDD__c, Amount__c, Change_since_last_review__c, 
                                                Comments__c, Type_Of_Source__c,Name,Source__c,Reference__c
                                                from Source_of_Wealth_Funds__c 
                                                where EDD__c= null and Type_Of_Source__c = 'Liabilities'];
        
        system.debug('sowfList1::' +sowfList1);
        
        UpdateSourceOfWealth.getAsset(edd.Id, sowfList.Type_Of_Source__c,sowfList.Reference__c);
        
        UpdateSourceOfWealth.getAsset(sowfList1.EDD__c, sowfList1.Type_Of_Source__c,sowfList1.Reference__c);
        

    }
    
    @isTest
     public static void testGetAsset1(){
         
         EDD_Form__c edd = [Select Id, Name, Closing_Comments__c,EDD_Review_SF_Case_Number__c From EDD_Form__c
                              where Closing_Comments__c = 'Test EDD Form'];
         
         /* Source_of_Wealth_Funds__c sowfList1 = [Select id,Case__c, EDD__c, Amount__c, Change_since_last_review__c, 
                                                Comments__c, Type_Of_Source__c,Name,Source__c,Reference__c
                                                from Source_of_Wealth_Funds__c 
                                                where EDD__c= null and Type_Of_Source__c = 'Liabilities' and Reference__c = 'REFER']; */
        
        
         
         UpdateSourceOfWealth.getAsset('abc', 'Assets','REFER');
         UpdateSourceOfWealth.getAsset('abc', 'Liabilities','REFER');

     }
    
    @isTest
    public static void testSaveAsset(){
     
        String lstSowf = '[{"name":"Business Finance","value":"","change":"","comments":"","pickListOptions":[{"label":"yes","value":"yes"},{"label":"no","value":"no"}],"source":"Source Of Wealth","typeOfSource":"Liabilities"},{"name":"Mortgage","value":"","change":"","comments":"","pickListOptions":[{"label":"yes","value":"yes"},{"label":"no","value":"no"}],"source":"Source Of Wealth","typeOfSource":"Liabilities"},{"name":"Other Mortgage","value":"","change":"","comments":"","pickListOptions":[{"label":"yes","value":"yes"},{"label":"no","value":"no"}],"source":"Source Of Wealth","typeOfSource":"Liabilities"},{"name":"Bank Finance","value":"","change":"","comments":"","pickListOptions":[{"label":"yes","value":"yes"},{"label":"no","value":"no"}],"source":"Source Of Wealth","typeOfSource":"Liabilities"},{"name":"Other Finance","value":"","change":"","comments":"","pickListOptions":[{"label":"yes","value":"yes"},{"label":"no","value":"no"}],"source":"Source Of Wealth","typeOfSource":"Liabilities"},{"name":"Overdraft","value":"","change":"","comments":"","pickListOptions":[{"label":"yes","value":"yes"},{"label":"no","value":"no"}],"source":"Source Of Wealth","typeOfSource":"Liabilities"},{"name":"Hire Purchase","value":"","change":"","comments":"","pickListOptions":[{"label":"yes","value":"yes"},{"label":"no","value":"no"}],"source":"Source Of Wealth","typeOfSource":"Liabilities"},{"name":"Credit Cards","value":"","change":"","comments":"","pickListOptions":[{"label":"yes","value":"yes"},{"label":"no","value":"no"}],"source":"Source Of Wealth","typeOfSource":"Liabilities"},{"name":"Guarantees","value":"","change":"","comments":"","pickListOptions":[{"label":"yes","value":"yes"},{"label":"no","value":"no"}],"source":"Source Of Wealth","typeOfSource":"Liabilities"},{"name":"Others","value":"","change":"","comments":"","pickListOptions":[{"label":"yes","value":"yes"},{"label":"no","value":"no"}],"source":"Source Of Wealth","typeOfSource":"Liabilities"}]';
        UpdateSourceOfWealth.saveAsset(lstSowf);
    }
    @isTest
    public static void deleteAsset(){
        
        EDD_Form__c edd = [Select Id, Name, Closing_Comments__c,EDD_Review_SF_Case_Number__c From EDD_Form__c
                              where Closing_Comments__c = 'Test EDD Form'];
        
        Source_of_Wealth_Funds__c sowfList = [Select id,Case__c, EDD__c, Amount__c, Change_since_last_review__c, 
                                                Comments__c, Type_Of_Source__c,Name,Source__c,Reference__c
                                                from Source_of_Wealth_Funds__c 
                                                where EDD__c=: edd.Id and Type_Of_Source__c = 'Assets'];
        
        
       UpdateSourceOfWealth.deleteAsset('Reference 3', sowfList.EDD__c);
    }
}