public class TestingRelatedEntity{
/*
public static String buildRelatedEntityRequest (Related_Customer_Entity__c relatedCustomerEntities, Opportunity oppRecord){

        System.debug ('relatedCustomerEntities' + relatedCustomerEntities );
		
        ARBCustomerAMLRequestModel customerRequest = new ARBCustomerAMLRequestModel ();
        customerRequest.RequestType = '587';
        ARBCustomerAMLRequestModel.ClientApplicationPurposes codeData = new ARBCustomerAMLRequestModel.ClientApplicationPurposes ();
        List<ARBCustomerAMLRequestModel.ClientApplicationPurposes> clientCodeList = new List<ARBCustomerAMLRequestModel.ClientApplicationPurposes> ();
        Map < String, String > organisationMap = new Map < String, String > ();
        for ( TruNarrative_Mappings__mdt orgTypeMapping : TruNarrative_Mappings__mdt.getAll().values()) {
        	organisationMap.put ( orgTypeMapping.SF_Value__c, orgTypeMapping.TN_Value__c);
        }
         Map < String, String > customerTypeMap = new Map < String, String > ();
        for ( TruNarrative_Customer_Type_Mapping__mdt customerType: TruNarrative_Customer_Type_Mapping__mdt.getAll().values()) {
        	customerTypeMap.put ( customerType.SF_Value__c, customerType.TN_Value__c);
        }
		System.debug ( customerTypeMap );
        System.debug ( 'relatedCustomerEntities.Account__r.RecordTypeId' + relatedCustomerEntities.Account__r.RecordTypeId);
        
        if ( relatedCustomerEntities.Account__r.RecordTypeId =='012D0000000QQfrIAG') {
			
            codeData.code = 'KYCNonPersonal';
            clientCodeList.add (codeData);
            customerRequest.ClientApplicationPurposes = clientCodeList;
           // if ( organisationMap.containsKey ( accountRecord.Organisation_type__c) ) {
             //   customerRequest.OrganisationType =  organisationMap.get ( accountRecord.Organisation_type__c);
           // }
            if ( customerTypeMap.containsKey ( relatedCustomerEntities.Account__r.Customer_Type__c) ) {
                customerRequest.CustomerType =  customerTypeMap.get ( relatedCustomerEntities.Account__r.Customer_Type__c);
            } else {
                customerRequest.CustomerType =  'COMPANY';
            }

        } else {
           // customerRequest.CustomerRelationship    = 'APPLICANT';
            codeData.code = 'KYCPersonal';
            clientCodeList.add (codeData);
            customerRequest.ClientApplicationPurposes = clientCodeList;
            customerRequest.CustomerType            = 'Individuals';//''+accountRecord.Type;
           // customerRequest.OrganisationType        = ''+accountRecord.Organisation_type__c;
        }

     
       
        
        
        customerRequest.PrimaryApplicant        = 'true';
        customerRequest.SFDCID                  = ''+oppRecord.Application_Reference_Number__c;
        customerRequest.CustomerSurName         = ''+ relatedCustomerEntities.Last_name__c;
        if ( relatedCustomerEntities.Account__r.RecordTypeId !='012D0000000QQfrIAG') {
            customerRequest.CustDateOfBirth         = ''+ARBAPIUtils.formatDate( relatedCustomerEntities.Date_of_Birth__c);
                    
        } else {
            customerRequest.CustDateOfBirth = '';

        }

        customerRequest.CustomerFirstName       = ''+relatedCustomerEntities.First_Name__c;
        customerRequest.CustomerMiddleName      = ''+relatedCustomerEntities.Middle_Name__c;
      
        customerRequest.AddrLine1               = ''+relatedCustomerEntities.Address_Street__c;
        //customerRequest.AddrLine2               = ''+accountRecord.Customer_Address_District__c;
        customerRequest.AddrLine3               = ''+relatedCustomerEntities.Address_City__c;
        customerRequest.AddrLine4               = ''+relatedCustomerEntities.Address_State__c;
        customerRequest.AddrLine5               = ''+relatedCustomerEntities.Address_Country__c;
        customerRequest.PostCode                = ''+relatedCustomerEntities.Post_Code__c;
    
        
        customerRequest.NationalityCountry      = ''+relatedCustomerEntities.Nationality__c;
        customerRequest.OrganisationName        = ''+relatedCustomerEntities.Business_Name__c;
        
        customerRequest.OrgRegisteredAddrStreet = ''+relatedCustomerEntities.Address_Street__c;
        customerRequest.OrgRegisteredAddrCity   = ''+relatedCustomerEntities.Address_City__c;
        customerRequest.OrgRegisteredAddrPCode  = ''+relatedCustomerEntities.Post_Code__c;
        customerRequest.OrgRegisteredAddrCountry    =''+relatedCustomerEntities.Address_Country__c;
    

        if ( relatedCustomerEntities.Account__r.Registration_date__c !=null ) {
            customerRequest.OrgRegDate  = ''+ARBAPIUtils.formatDate(relatedCustomerEntities.Date_of_incorporation__c);
        } else {
            customerRequest.OrgRegDate  = '';
        }

        customerRequest.OrgVATNo                = ''+relatedCustomerEntities.Company_Registration_Number__c;
        customerRequest.OrgMainCountryOfBusiness= ''+relatedCustomerEntities.Country_Of_Incorporation__c;
       

        System.debug(customerRequest.OrgMainCountryOfBusiness);
    	System.debug('Address_City__c'+customerRequest.OrgRegisteredAddrCity);
	    System.debug(customerRequest.CustomerType);
    
    

        return JSON.serialize ( customerRequest ).replace('null','');

    }
    */
}