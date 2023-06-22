/*******************************************************************
* @Class Name      : ARBCustomerAMLRequestHelper
* @Author          : RAGESH G
* @Created Date    : 17 August 2022
* @description      : This helper class is used to create the request to TruNarrative with Customer details via Middleware
* @JIRA            : 

  LOG   DATE        Author  UserStory         COMMENT      
* 001   17/08/2022  RG                       First Commit
********************************************************************/
public  without sharing class ARBCustomerAMLRequestHelper {
    
    public static String buildCustomerRequest ( String opptyId ) {
		
        system.debug('OppID id: ' + opptyId);
        
        Opportunity oppRecord = [ SELECT Name, AccountId, IBB_Product__r.Category_Of_Product__c 
                                  FROM Opportunity 
                                  WHERE Id =: opptyId];
        
        String accountId = oppRecord.AccountId;
        String accountQuery = ARBAPIUtils.buildAllFieldsQuery ('Account');
        accountQuery += ' WHERE Id=:accountId';
        System.debug ('accountQuery' + accountQuery );
        Account accountRecord = Database.query ( accountQuery );
        ARBCustomerAMLRequestModel customerRequest = new ARBCustomerAMLRequestModel ();
        Map < String, Asset_Relationship__c > accountToAssetMap = new Map < String, Asset_Relationship__c > ();
        for ( Asset_Relationship__c assetRecord : [ SELECT Id, Relationship_To_Primary_Applicant1__c, Prospect_Customer__c 
                FROM Asset_Relationship__c
                WHERE Prospect_Customer__c =:accountRecord.Id]) {
                    accountToAssetMap.put ( assetRecord.Prospect_Customer__c, assetRecord);
        }
        Map < String, String > organisationMap = new Map < String, String > ();
        for ( TruNarrative_Mappings__mdt orgTypeMapping : TruNarrative_Mappings__mdt.getAll().values()) {
        	organisationMap.put ( orgTypeMapping.SF_Value__c, orgTypeMapping.TN_Value__c);
        }
         Map < String, String > customerTypeMap = new Map < String, String > ();
        for ( TruNarrative_Customer_Type_Mapping__mdt customerType: TruNarrative_Customer_Type_Mapping__mdt.getAll().values()) {
        	customerTypeMap.put ( customerType.SF_Value__c, customerType.TN_Value__c);
        }
		System.debug ( customerTypeMap );
        
        
        customerRequest.CustomerType            = 'Individuals';//''+accountRecord.Type;
        customerRequest.CustomerRelationship    = 'APPLICANT';
        List<ARBCustomerAMLRequestModel.ClientApplicationPurposes> clientCodeList = new List<ARBCustomerAMLRequestModel.ClientApplicationPurposes> ();
        customerRequest.OrganisationType        = ''+accountRecord.Organisation_type__c;
        customerRequest.RequestType = '587';
        ARBCustomerAMLRequestModel.ClientApplicationPurposes codeData = new ARBCustomerAMLRequestModel.ClientApplicationPurposes ();
       
        

        if ( accountRecord.RecordTypeId =='012D0000000QQfrIAG') {
            system.debug ('accountToAssetMap' + accountToAssetMap);
            if ( accountToAssetMap.containsKey ( ''+accountRecord.Id ) ) {
                Asset_Relationship__c assetRec = accountToAssetMap.get ( ''+accountRecord.Id );
                if ( assetRec.Relationship_To_Primary_Applicant1__c !=null ) {
                    customerRequest.CustomerRelationship    = ''+assetRec.Relationship_To_Primary_Applicant1__c;
                }
            
            } else {
                customerRequest.CustomerRelationship    = 'APPLICANT';
            }
            codeData.code = 'KYCNonPersonal';
            clientCodeList.add (codeData);
            if ( organisationMap.containsKey ( accountRecord.Organisation_type__c) ) {
                customerRequest.OrganisationType =  organisationMap.get ( accountRecord.Organisation_type__c);
            }
            if ( customerTypeMap.containsKey ( accountRecord.Customer_Type__c) ) {
                customerRequest.CustomerType =  customerTypeMap.get ( accountRecord.Customer_Type__c);
            } else {
                customerRequest.CustomerType =  'COMPANY';
            }
            customerRequest.OrganisationName        = ''+accountRecord.Name;

        } else {
            customerRequest.CustomerRelationship    = 'APPLICANT';
            codeData.code = 'KYCPersonal';
            clientCodeList.add (codeData);
            customerRequest.OrganisationName        = ''+accountRecord.Name;
        }
        customerRequest.ClientApplicationPurposes = clientCodeList;

        customerRequest.MessageId               = ARBAPIUtils.fetchUniqueMessageId (); 
        customerRequest.DateRequested           = ''+DateTime.now ();
        if ( oppRecord.IBB_Product__r.Category_Of_Product__c !=null  ) {
            customerRequest.ApplicationAccountType  = oppRecord.IBB_Product__r.Category_Of_Product__c;
        } else {
            customerRequest.ApplicationAccountType  = 'Savings';
        }
        
        if ( accountRecord.TN_accountId__c !=null ) {
            customerRequest.MessageType             = 'SFDCAMLUpdate';
        } else {
            customerRequest.MessageType             = 'SFDCAMLRequest';
        }
        
        if ( accountRecord.TN_accountId__c != null ) {
            customerRequest.TNaccountId             = ''+accountRecord.TN_accountId__c;
        } else {
            customerRequest.TNaccountId             = '';
        }
        
        customerRequest.OpportunityId           =''+accountRecord.SFDC_ID__c;
        
        
        
        
        customerRequest.PrimaryApplicant        = 'true';
        customerRequest.ExistingCustomer        = ''+accountRecord.Existing_Customer__c;
        customerRequest.UKCitizen               = ''+accountRecord.UK_Citizen__c;
        customerRequest.SFDCID                  = ''+accountRecord.SFDC_ID__c;
        customerRequest.CustomerNumber          = ''+accountRecord.EBS_ID__c;
        customerRequest.AccountName             = accountRecord.FirstName +' ' + accountRecord.LastName;
        customerRequest.CustomerSurName         = ''+ accountRecord.LastName;
        if ( accountRecord.Date_of_Birth__c != null ) {
            customerRequest.CustDateOfBirth         = ''+ARBAPIUtils.formatDate( accountRecord.Date_of_Birth__c);
        } else {
            customerRequest.CustDateOfBirth         = '';
        }
        
        customerRequest.CustomerGender          = ''+accountRecord.Gender__c;
        customerRequest.MaritalStatus           = ''+accountRecord.Marital_Status__c;
        customerRequest.CountryOfResidence      = ''+accountRecord.BillingCountry;
        customerRequest.CustomerIDEvidence      = ''+ accountRecord.ID_Evidence__c;
        customerRequest.EvidenceOfAddress       = ''+accountRecord.Proof_of_Address__c;
        customerRequest.CustomerDocSerialNo     = ''+accountRecord.ID_Serial_No__c;
        if ( accountRecord.Document_Issue_Date__c != null ) {
            customerRequest.DocumentIssueDate       = ''+ ARBAPIUtils.formatDate (accountRecord.Document_Issue_Date__c);
        } else {
            customerRequest.DocumentIssueDate       = '';
        }
        
        customerRequest.TotalIncomeBeforeTax    = ''+accountRecord.Total_Income_Before_Tax__c;
        if ( accountRecord.Date_moved_to_address__c != null ) {
            customerRequest.DateMovedToCurrentAddress       = ''+ ARBAPIUtils.formatDate(accountRecord.Date_moved_to_address__c);
        } else {
            customerRequest.DateMovedToCurrentAddress       = '';
        }

        if ( accountRecord.Date_moved_to_previous_address__c != null ) {
            customerRequest.DateMovedToPrevAddress       = ''+ ARBAPIUtils.formatDate(accountRecord.Date_moved_to_previous_address__c);
        } else {
            customerRequest.DateMovedToPrevAddress       = '';
        }

        if ( accountRecord.Date_Employment_Commenced__c != null ) {
            customerRequest.DateEmploymentCommenced       = ''+ ARBAPIUtils.formatDate(accountRecord.Date_Employment_Commenced__c);
        } else {
            customerRequest.DateEmploymentCommenced       = '';
        }


        customerRequest.CustomerFirstName       = ''+accountRecord.FirstName;
        customerRequest.CustomerMiddleName      = ''+accountRecord.Middle_Name__pc;
        customerRequest.CustomerPreviousName    = ''+accountRecord.Previous_Name__pc;
        customerRequest.CountryOfBirth          = ''+accountRecord.Country_of_Birth__c;
        customerRequest.TownOfBirth             = ''+accountRecord.Town_of_Birth__c;
        customerRequest.PrevAddrHouseNo         = ''+accountRecord.Previous_Customer_Address_House_No__c;
        customerRequest.PrevAddrLine1           = ''+accountRecord.ShippingStreet;
        customerRequest.PrevAddrLine2           = ''+accountRecord.Customer_Previous_Address_District__c;
        customerRequest.PrevAddrLine3           = ''+accountRecord.ShippingCity;
        customerRequest.PrevAddrLine4           = ''+accountRecord.ShippingState;
        customerRequest.PrevAddrCountry         = ''+accountRecord.ShippingCountry;
        customerRequest.PrevPCode               = ''+accountRecord.ShippingPostalCode;
        customerRequest.PrevPrevAddrHouseNo     = ''+accountRecord.Prev_Previous_Address_House_No__c;
        customerRequest.PrevPrevAddrLine1       = ''+accountRecord.PersonMailingStreet;
        customerRequest.PrevPrevAddrLine2       = ''+accountRecord.Customer_Prev_Previous_Address_District__c;
        customerRequest.PrevPrevAddrLine3       = ''+accountRecord.PersonMailingCity;
        customerRequest.PrevPrevAddrLine4       = ''+accountRecord.PersonMailingState;
        customerRequest.PrevPrevAddrCountry     = ''+accountRecord.PersonMailingCountry;
        customerRequest.PrevPrevPCode           = ''+accountRecord.PersonMailingPostalCode;
        customerRequest.EmployerName            = ''+accountRecord.Employer_Name__c;
        customerRequest.EmployerAddrLine1       = ''+accountRecord.Employer_Address_Line_1__c;
        customerRequest.EmployerAddrLine2       = ''+accountRecord.Employer_Address_Line_2__c;
        customerRequest.EmployerAddrLine3       = ''+accountRecord.Employer_Address_Line_3__c;
        customerRequest.EmployerAddrLine4       = ''+accountRecord.Employer_Address_Line_4__c;
        customerRequest.EmployerAddrLine5       = ''+accountRecord.Employer_Address_Line_5__c;
        customerRequest.EmployerPostCode        = ''+accountRecord.Employer_Post_Code__c;
        customerRequest.EmployerNatureOfBuiness = ''+accountRecord.Nature_of_Employers_Your_Business__c;
        customerRequest.MobNo                   = ''+accountRecord.PersonMobilePhone;
        customerRequest.WorkTelNo               = '';
        customerRequest.PrivateEmail            = ''+accountRecord.PersonEmail;
        customerRequest.HomeDetails             = ''+accountRecord.Home_Details__c;
        customerRequest.EmploymentType          = ''+accountRecord.Employment_Type__c;
        customerRequest.EmploymentStatus        = ''+accountRecord.Employment_Status__c;
        customerRequest.Occupation              = ''+accountRecord.Occupation__c;
        customerRequest.NoOfChildren            = ''+accountRecord.No_of_children__c;
        customerRequest.CurrentBankSortCode     = ''+accountRecord.Current_Bank_Sort_Code__c;
        customerRequest.CurrentBankDetailsName  = ''+accountRecord.Current_Bank_name__c;
        customerRequest.CustSalutation          = ''+accountRecord.Salutation;
        customerRequest.AddrLine1               = ''+accountRecord.BillingStreet;
        customerRequest.AddrLine2               = ''+accountRecord.Customer_Address_District__c;
        customerRequest.AddrLine3               = ''+accountRecord.BillingCity;
        customerRequest.AddrLine4               = ''+accountRecord.BillingState;
        customerRequest.AddrLine5               = ''+accountRecord.BillingCountry;
        customerRequest.PostCode                = ''+accountRecord.BillingPostalCode;
        customerRequest.TelNo                   = ''+accountRecord.Home_Telephone_No__c;
        if ( accountRecord.Date_moved_to_prev_previous_address__c !=null ) {
            customerRequest.DateMovedToPrevPrevAddress  = ''+ARBAPIUtils.formatDate(accountRecord.Date_moved_to_prev_previous_address__c);
        } else {
            customerRequest.DateMovedToPrevPrevAddress  = '';
        }
        
        customerRequest.NationalityCountry      = ''+accountRecord.Country_of_nationality__c;
        
        
        customerRequest.OrgRegisteredAddrStreet = ''+accountRecord.RegisteredAddressStreet__c;
        customerRequest.OrgRegisteredAddrCity   = ''+accountRecord.RegisteredAddressCity__c;
        customerRequest.OrgRegisteredAddrPCode  = ''+accountRecord.RegisteredAddressPostCode__c;
        customerRequest.OrgRegisteredAddrCountry    =''+accountRecord.RegisteredAddressCountry__c;
        if ( accountRecord.Date_moved_to_registered_address__c !=null ) {
            customerRequest.OrgRegisteredAddrMovingInDate  = ''+ARBAPIUtils.formatDate(accountRecord.Date_moved_to_registered_address__c);
        } else {
            customerRequest.OrgRegisteredAddrMovingInDate  = '';
        }

        customerRequest.OrgRegNo                = ''+accountRecord.Registered_number__c;

        if ( accountRecord.Registration_date__c !=null ) {
            customerRequest.OrgRegDate  = ''+ARBAPIUtils.formatDate(accountRecord.Registration_date__c);
        } else {
            customerRequest.OrgRegDate  = '';
        }

        customerRequest.OrgVATNo                = ''+accountRecord.VAT_number__c;
        customerRequest.OrgTradingAddrStreet    = ''+accountRecord.TradingAddressStreet__c;
        customerRequest.OrgTradingAddrCity      = ''+accountRecord.TradingAddressCity__c;
        customerRequest.OrgTradingAddrPCode     = ''+accountRecord.TradingPostCode__c;
        customerRequest.OrgTradingAddrCountry   = ''+accountRecord.TradingAddressCountry__c;
        customerRequest.OrgCorrespondenceAddrStreet = ''+accountRecord.CorrespondenceAddressStreet__c;
        customerRequest.OrgCorrespondenceAddrCity   = ''+accountRecord.CorrespondenceAddressCity__c;
        customerRequest.OrgCorrespondenceAddrPCode  = ''+accountRecord.CorrespondenceAddressPostCode__c;
        customerRequest.OrgCorrespondenceAddrCountry= ''+accountRecord.CorrespondenceAddressCountry__c;
        if ( accountRecord.Date_business_began_operating__c !=null ) {
            customerRequest.OrgStartDate  = ''+ARBAPIUtils.formatDate(accountRecord.Date_business_began_operating__c);
        } else {
            customerRequest.OrgStartDate  = '';
        }

        customerRequest.OrgNoDirectors          = 0;
        if ( accountRecord.Org_No_Directors__c !=null ) {
            customerRequest.OrgNoEmpl               = Integer.valueOf(''+accountRecord.Org_No_Directors__c ) ;
        } else {
            customerRequest.OrgNoEmpl               = 0;
        }
        
        customerRequest.OrgIndustry             = ''+accountRecord.Nature_of_Business_NPAA__c;
        customerRequest.OrgSIC                  = ''+accountRecord.Main_company_activities__c;
        customerRequest.OrgMainCountryOfBusiness= ''+accountRecord.Organisation_domicile__c;
        if ( accountRecord.Company_anticipated_turnover__c !=null ) {
            customerRequest.OrgTurnover               = Integer.valueOf(''+accountRecord.Company_anticipated_turnover__c ) ;
        } else {
            customerRequest.OrgTurnover               = 0;
        }

        customerRequest.OrgBankName             = ''+accountRecord.Existing_Business_Bank_Name__c;
        customerRequest.OrgBankSortCode         = ''+accountRecord.Existing_Business_Bank_Sort_Code__c;
        customerRequest.OrgBankAccNo            = ''+accountRecord.Existing_Business_Bank_Account_Number__c;
        customerRequest.OpportunityName         = ''+oppRecord.Name;

        

        return JSON.serialize ( customerRequest ).replace('null','');

    }

    public static String buildCustomerRequest ( Account accountRecord, Opportunity oppRecord , Map < String, Asset_Relationship__c >  accountToAssetMap, Boolean isUpdateRequest ) {

        System.debug ('accountRecord' + accountRecord.Id );
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
        System.debug ( 'accountRecord.RecordTypeId' + accountRecord.RecordTypeId );
        
        if ( accountRecord.RecordTypeId =='012D0000000QQfrIAG') {
            if ( accountToAssetMap.containsKey ( ''+accountRecord.Id ) ) {
                Asset_Relationship__c assetRec = accountToAssetMap.get ( ''+accountRecord.Id );
                if ( assetRec.Relationship_To_Primary_Applicant1__c !=null ) {
                    customerRequest.CustomerRelationship    = assetRec.Relationship_To_Primary_Applicant1__c;
                }
            
            } else {
                customerRequest.CustomerRelationship = '';
            }
            
            if ( organisationMap.containsKey ( accountRecord.Organisation_type__c) ) {
                customerRequest.OrganisationType =  organisationMap.get ( accountRecord.Organisation_type__c);
            }
            if ( customerTypeMap.containsKey ( accountRecord.Customer_Type__c) ) {
                customerRequest.CustomerType =  customerTypeMap.get ( accountRecord.Customer_Type__c);
            } else {
                customerRequest.CustomerType =  'COMPANY';
            }

            if ( isUpdateRequest ) {
                codeData.code = 'Change in Details';
                clientCodeList.add (codeData);
                customerRequest.ClientApplicationPurposes = clientCodeList;
            } else {
                codeData.code = 'KYCNonPersonal';
                clientCodeList.add (codeData);
                customerRequest.ClientApplicationPurposes = clientCodeList;
            }

            customerRequest.OrganisationName        = ''+accountRecord.Name;
        } else {
            if ( isUpdateRequest ) {
                codeData.code = 'Change in Details';
                clientCodeList.add (codeData);
                customerRequest.ClientApplicationPurposes = clientCodeList;
            } else {
                codeData.code = 'KYCPersonal';
                clientCodeList.add (codeData);
                customerRequest.ClientApplicationPurposes = clientCodeList;
            }
            customerRequest.CustomerRelationship    = 'APPLICANT';
            
            customerRequest.CustomerType            = 'Individuals';//''+accountRecord.Type;
            customerRequest.OrganisationType        = ''+accountRecord.Organisation_type__c;
            customerRequest.OrganisationName        = ''+accountRecord.Name;
        }

        customerRequest.MessageId               = ARBAPIUtils.fetchUniqueMessageId ();
        customerRequest.DateRequested           = ''+DateTime.now ();
        if ( oppRecord.IBB_Product__r.Category_Of_Product__c !=null  ) {
            customerRequest.ApplicationAccountType  = oppRecord.IBB_Product__r.Category_Of_Product__c;
        } else {
            customerRequest.ApplicationAccountType  = 'Savings';
        }
        
       if ( accountRecord.TN_accountId__c !=null ) {
            customerRequest.MessageType             = 'SFDCAMLUpdate';
        } else {
            customerRequest.MessageType             = 'SFDCAMLRequest';
        }
        
        
        if ( accountRecord.TN_accountId__c != null ) {
            customerRequest.TNaccountId             = ''+accountRecord.TN_accountId__c;
        } else {
            customerRequest.TNaccountId             = '';
        }
        
        customerRequest.OpportunityId           =''+accountRecord.SFDC_ID__c;
        
       
        
        
        customerRequest.PrimaryApplicant        = 'true';
        customerRequest.ExistingCustomer        = ''+accountRecord.Existing_Customer__c;
        customerRequest.UKCitizen               = ''+accountRecord.UK_Citizen__c;
        customerRequest.SFDCID                  = ''+accountRecord.SFDC_ID__c;
        customerRequest.CustomerNumber          = ''+accountRecord.EBS_ID__c;
        customerRequest.AccountName             = accountRecord.FirstName +' ' + accountRecord.LastName;
        customerRequest.CustomerSurName         = ''+ accountRecord.LastName;
        if ( accountRecord.RecordTypeId !='012D0000000QQfrIAG') {
            if ( accountRecord.Date_of_Birth__c != null ) {
                customerRequest.CustDateOfBirth         = ''+ARBAPIUtils.formatDate( accountRecord.Date_of_Birth__c);
            }
            
            customerRequest.CustomerGender          = ''+accountRecord.Gender__c;
            if ( accountRecord.Marital_Status__c != null ) {
                customerRequest.MaritalStatus           = ''+accountRecord.Marital_Status__c;
            }
           
        } else {
            customerRequest.CustDateOfBirth = '';
            customerRequest.CustomerGender = '';
            customerRequest.MaritalStatus = '';

        }
       
        customerRequest.CountryOfResidence      = ''+accountRecord.BillingCountry;
        customerRequest.CustomerIDEvidence      = ''+ accountRecord.ID_Evidence__c;
        customerRequest.EvidenceOfAddress       = ''+accountRecord.Proof_of_Address__c;
        customerRequest.CustomerDocSerialNo     = ''+accountRecord.ID_Serial_No__c;
        if ( accountRecord.Document_Issue_Date__c != null ) {
            customerRequest.DocumentIssueDate       = ''+ ARBAPIUtils.formatDate (accountRecord.Document_Issue_Date__c);
        } else {
            customerRequest.DocumentIssueDate       = '';
        }
        
        customerRequest.TotalIncomeBeforeTax    = ''+accountRecord.Total_Income_Before_Tax__c;
        if ( accountRecord.Date_moved_to_address__c != null ) {
            customerRequest.DateMovedToCurrentAddress       = ''+ ARBAPIUtils.formatDate(accountRecord.Date_moved_to_address__c);
        } else {
            customerRequest.DateMovedToCurrentAddress       = '';
        }

        if ( accountRecord.Date_moved_to_previous_address__c != null ) {
            customerRequest.DateMovedToPrevAddress       = ''+ ARBAPIUtils.formatDate(accountRecord.Date_moved_to_previous_address__c);
        } else {
            customerRequest.DateMovedToPrevAddress       = '';
        }

        if ( accountRecord.Date_Employment_Commenced__c != null ) {
            customerRequest.DateEmploymentCommenced       = ''+ ARBAPIUtils.formatDate(accountRecord.Date_Employment_Commenced__c);
        } else {
            customerRequest.DateEmploymentCommenced       = '';
        }


        customerRequest.CustomerFirstName       = ''+accountRecord.FirstName;
        customerRequest.CustomerMiddleName      = ''+accountRecord.Middle_Name__pc;
        customerRequest.CustomerPreviousName    = ''+accountRecord.Previous_Name__pc;
        customerRequest.CountryOfBirth          = ''+accountRecord.Country_of_Birth__c;
        customerRequest.TownOfBirth             = ''+accountRecord.Town_of_Birth__c;
        customerRequest.PrevAddrHouseNo         = ''+accountRecord.Previous_Customer_Address_House_No__c;
        customerRequest.PrevAddrLine1           = ''+accountRecord.ShippingStreet;
        customerRequest.PrevAddrLine2           = ''+accountRecord.Customer_Previous_Address_District__c;
        customerRequest.PrevAddrLine3           = ''+accountRecord.ShippingCity;
        customerRequest.PrevAddrLine4           = ''+accountRecord.ShippingState;
        customerRequest.PrevAddrCountry         = ''+accountRecord.ShippingCountry;
        customerRequest.PrevPCode               = ''+accountRecord.ShippingPostalCode;
        customerRequest.PrevPrevAddrHouseNo     = ''+accountRecord.Prev_Previous_Address_House_No__c;
        customerRequest.PrevPrevAddrLine1       = ''+accountRecord.PersonMailingStreet;
        customerRequest.PrevPrevAddrLine2       = ''+accountRecord.Customer_Prev_Previous_Address_District__c;
        customerRequest.PrevPrevAddrLine3       = ''+accountRecord.PersonMailingCity;
        customerRequest.PrevPrevAddrLine4       = ''+accountRecord.PersonMailingState;
        customerRequest.PrevPrevAddrCountry     = ''+accountRecord.PersonMailingCountry;
        customerRequest.PrevPrevPCode           = ''+accountRecord.PersonMailingPostalCode;
        customerRequest.EmployerName            = ''+accountRecord.Employer_Name__c;
        customerRequest.EmployerAddrLine1       = ''+accountRecord.Employer_Address_Line_1__c;
        customerRequest.EmployerAddrLine2       = ''+accountRecord.Employer_Address_Line_2__c;
        customerRequest.EmployerAddrLine3       = ''+accountRecord.Employer_Address_Line_3__c;
        customerRequest.EmployerAddrLine4       = ''+accountRecord.Employer_Address_Line_4__c;
        customerRequest.EmployerAddrLine5       = ''+accountRecord.Employer_Address_Line_5__c;
        customerRequest.EmployerPostCode        = ''+accountRecord.Employer_Post_Code__c;
        customerRequest.EmployerNatureOfBuiness = ''+accountRecord.Nature_of_Employers_Your_Business__c;
        customerRequest.MobNo                   = ''+accountRecord.PersonMobilePhone;
        customerRequest.WorkTelNo               = '';
        customerRequest.PrivateEmail            = ''+accountRecord.PersonEmail;
        customerRequest.HomeDetails             = ''+accountRecord.Home_Details__c;
        customerRequest.EmploymentType          = ''+accountRecord.Employment_Type__c;
        customerRequest.EmploymentStatus        = ''+accountRecord.Employment_Status__c;
        customerRequest.Occupation              = ''+accountRecord.Occupation__c;
        customerRequest.NoOfChildren            = ''+accountRecord.No_of_children__c;
        customerRequest.CurrentBankSortCode     = ''+accountRecord.Current_Bank_Sort_Code__c;
        customerRequest.CurrentBankDetailsName  = ''+accountRecord.Current_Bank_name__c;
        customerRequest.CustSalutation          = ''+accountRecord.Salutation;
        customerRequest.AddrLine1               = ''+accountRecord.BillingStreet;
        customerRequest.AddrLine2               = ''+accountRecord.Customer_Address_District__c;
        customerRequest.AddrLine3               = ''+accountRecord.BillingCity;
        customerRequest.AddrLine4               = ''+accountRecord.BillingState;
        customerRequest.AddrLine5               = ''+accountRecord.BillingCountry;
        customerRequest.PostCode                = ''+accountRecord.BillingPostalCode;
        customerRequest.TelNo                   = ''+accountRecord.Home_Telephone_No__c;
        if ( accountRecord.Date_moved_to_prev_previous_address__c !=null ) {
            customerRequest.DateMovedToPrevPrevAddress  = ''+ARBAPIUtils.formatDate(accountRecord.Date_moved_to_prev_previous_address__c);
        } else {
            customerRequest.DateMovedToPrevPrevAddress  = '';
        }
        
        customerRequest.NationalityCountry      = ''+accountRecord.Country_of_nationality__c;
        
        
        customerRequest.OrgRegisteredAddrStreet = ''+accountRecord.RegisteredAddressStreet__c;
        customerRequest.OrgRegisteredAddrCity   = ''+accountRecord.RegisteredAddressCity__c;
        customerRequest.OrgRegisteredAddrPCode  = ''+accountRecord.RegisteredAddressPostCode__c;
        customerRequest.OrgRegisteredAddrCountry    =''+accountRecord.RegisteredAddressCountry__c;
        if ( accountRecord.Date_moved_to_registered_address__c !=null ) {
            customerRequest.OrgRegisteredAddrMovingInDate  = ''+ARBAPIUtils.formatDate(accountRecord.Date_moved_to_registered_address__c);
        } else {
            customerRequest.OrgRegisteredAddrMovingInDate  = '';
        }

        customerRequest.OrgRegNo                = ''+accountRecord.Registered_number__c;

        if ( accountRecord.Registration_date__c !=null ) {
            customerRequest.OrgRegDate  = ''+ARBAPIUtils.formatDate(accountRecord.Registration_date__c);
        } else {
            customerRequest.OrgRegDate  = '';
        }

        customerRequest.OrgVATNo                = ''+accountRecord.VAT_number__c;
        customerRequest.OrgTradingAddrStreet    = ''+accountRecord.TradingAddressStreet__c;
        customerRequest.OrgTradingAddrCity      = ''+accountRecord.TradingAddressCity__c;
        customerRequest.OrgTradingAddrPCode     = ''+accountRecord.TradingPostCode__c;
        customerRequest.OrgTradingAddrCountry   = ''+accountRecord.TradingAddressCountry__c;
        customerRequest.OrgCorrespondenceAddrStreet = ''+accountRecord.CorrespondenceAddressStreet__c;
        customerRequest.OrgCorrespondenceAddrCity   = ''+accountRecord.CorrespondenceAddressCity__c;
        customerRequest.OrgCorrespondenceAddrPCode  = ''+accountRecord.CorrespondenceAddressPostCode__c;
        customerRequest.OrgCorrespondenceAddrCountry= ''+accountRecord.CorrespondenceAddressCountry__c;
        if ( accountRecord.Date_business_began_operating__c !=null ) {
            customerRequest.OrgStartDate  = ''+ARBAPIUtils.formatDate(accountRecord.Date_business_began_operating__c);
        } else {
            customerRequest.OrgStartDate  = '';
        }

        customerRequest.OrgNoDirectors          = 0;
        if ( accountRecord.Org_No_Directors__c !=null ) {
            customerRequest.OrgNoEmpl               = Integer.valueOf(''+accountRecord.Org_No_Directors__c ) ;
        } else {
            customerRequest.OrgNoEmpl               = 0;
        }
        
        customerRequest.OrgIndustry             = ''+accountRecord.Nature_of_Business_NPAA__c;
        customerRequest.OrgSIC                  = ''+accountRecord.Main_company_activities__c;
        customerRequest.OrgMainCountryOfBusiness= ''+accountRecord.Organisation_domicile__c;
        if ( accountRecord.Company_anticipated_turnover__c !=null ) {
            customerRequest.OrgTurnover               = Integer.valueOf(''+accountRecord.Company_anticipated_turnover__c ) ;
        } else {
            customerRequest.OrgTurnover               = 0;
        }

        customerRequest.OrgBankName             = ''+accountRecord.Existing_Business_Bank_Name__c;
        customerRequest.OrgBankSortCode         = ''+accountRecord.Existing_Business_Bank_Sort_Code__c;
        customerRequest.OrgBankAccNo            = ''+accountRecord.Existing_Business_Bank_Account_Number__c;
        customerRequest.OpportunityName         = ''+oppRecord.Name;

        

        return JSON.serialize ( customerRequest ).replace('null','');

    }


    public static String buildRelatedEntityRequest (Related_Customer_Entity__c relatedEntityRecord, Opportunity oppRecord){

        System.debug ('relatedEntityRecord' + relatedEntityRecord );
		
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
        System.debug ( 'relatedEntityRecord.Account__r.RecordTypeId' + relatedEntityRecord.Account__r.RecordTypeId);
        
        if ( relatedEntityRecord.Account__r.RecordTypeId =='012D0000000QQfrIAG') {
			
            codeData.code = 'KYCNonPersonal';
            clientCodeList.add (codeData);
            customerRequest.ClientApplicationPurposes = clientCodeList;
           /* if ( organisationMap.containsKey ( accountRecord.Organisation_type__c) ) {
                customerRequest.OrganisationType =  organisationMap.get ( accountRecord.Organisation_type__c);
            }*/
            if ( customerTypeMap.containsKey ( relatedEntityRecord.Account__r.Customer_Type__c) ) {
                customerRequest.CustomerType =  customerTypeMap.get ( relatedEntityRecord.Account__r.Customer_Type__c);
            } else {
                customerRequest.CustomerType =  'COMPANY';
            }
            customerRequest.OrganisationType        = 'LTD';

        } else {
           // customerRequest.CustomerRelationship    = 'APPLICANT';
            codeData.code = 'KYCPersonal';
            clientCodeList.add (codeData);
            customerRequest.ClientApplicationPurposes = clientCodeList;
            customerRequest.CustomerType            = 'Individuals';//''+accountRecord.Type;
            customerRequest.OrganisationType        = '';
        }

     
       
        
        customerRequest.CustomerRelationship    = 'DIRECTOR';
        customerRequest.PrimaryApplicant        = 'true';
        customerRequest.SFDCID                  = ''+oppRecord.Application_Reference_Number__c;
        customerRequest.CustomerSurName         = ''+ relatedEntityRecord.Last_name__c;
        if ( relatedEntityRecord.Account__r.RecordTypeId !='012D0000000QQfrIAG') {
            customerRequest.CustDateOfBirth         = ''+ARBAPIUtils.formatDate( relatedEntityRecord.Date_of_Birth__c);
                    
        } else {
            customerRequest.CustDateOfBirth = '';

        }

        customerRequest.CustomerFirstName       = ''+relatedEntityRecord.First_Name__c;
        customerRequest.CustomerMiddleName      = ''+relatedEntityRecord.Middle_Name__c;
      
        customerRequest.AddrLine1               = ''+relatedEntityRecord.Address_Street__c;
        //customerRequest.AddrLine2               = ''+accountRecord.Customer_Address_District__c;
        customerRequest.AddrLine3               = ''+relatedEntityRecord.Address_City__c;
        customerRequest.AddrLine4               = ''+relatedEntityRecord.Address_State__c;
        customerRequest.AddrLine5               = ''+relatedEntityRecord.Address_Country__c;
        customerRequest.PostCode                = ''+relatedEntityRecord.Post_Code__c;
    
        
        customerRequest.NationalityCountry      = ''+relatedEntityRecord.Nationality__c;
        customerRequest.OrganisationName        = ''+relatedEntityRecord.Account__r.Name;
        
        customerRequest.OrgRegisteredAddrStreet = ''+relatedEntityRecord.Address_Street__c;
        customerRequest.OrgRegisteredAddrCity   = ''+relatedEntityRecord.Address_City__c;
        customerRequest.OrgRegisteredAddrPCode  = ''+relatedEntityRecord.Post_Code__c;
        customerRequest.OrgRegisteredAddrCountry    =''+relatedEntityRecord.Address_Country__c;
    

        if ( relatedEntityRecord.Date_of_incorporation__c !=null ) {
            customerRequest.OrgRegDate  = ''+ARBAPIUtils.formatDate(relatedEntityRecord.Date_of_incorporation__c);
        } else {
            customerRequest.OrgRegDate  = '';
        }

        customerRequest.OrgVATNo                = ''+relatedEntityRecord.Company_Registration_Number__c;
        customerRequest.OrgMainCountryOfBusiness= ''+relatedEntityRecord.Country_Of_Incorporation__c;
        customerRequest.MessageId               = ARBAPIUtils.fetchUniqueMessageId (); 

        System.debug(customerRequest.OrgMainCountryOfBusiness);
    	System.debug('Address_City__c'+customerRequest.OrgRegisteredAddrCity);
	    System.debug(customerRequest.CustomerType);
    
    
        return JSON.serialize( customerRequest ).replace('null','\'\'');
		//return JSON.serialize( customerRequest );
    }
    
    
    

}