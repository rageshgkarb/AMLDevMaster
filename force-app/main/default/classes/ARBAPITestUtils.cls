public with sharing class ARBAPITestUtils {
    public static String buildStaticCustomerRequest ( ) {
        ARBCustomerAMLRequestModel customerRequest = new ARBCustomerAMLRequestModel ();

        customerRequest.MessageId               = '9249DD9F-A479-432C-98D9-96F5DFF08C50'; 
        customerRequest.DateRequested           = ''+DateTime.now ();
        customerRequest.MessageType             = 'SFDCAMLRequest';
        //customerRequest.RequestType             = '545';
        customerRequest.TNaccountId             = '1212121';
        customerRequest.OpportunityId           = 'SFDC-0001230';
        customerRequest.ApplicationAccountType  = 'Savings';
        customerRequest.CustomerType            = 'Individuals';
        customerRequest.CustomerRelationship    = 'APPLICANT';
        customerRequest.PrimaryApplicant        = 'true';
        customerRequest.ExistingCustomer        = '';
        customerRequest.UKCitizen               = '';
        customerRequest.SFDCID                  = 'SFDC-0001230';
        customerRequest.CustomerNumber          = '';
        customerRequest.AccountName             = 'Betty Morgan';
        customerRequest.CustomerSurName         = 'Morgan';
        customerRequest.CustDateOfBirth         = '1978-10-14';
        customerRequest.CustomerGender          = 'F';
        customerRequest.MaritalStatus           = 'Single';
        customerRequest.CountryOfResidence      = 'United Kingdom';
        //customerRequest.ParentCountry           = 'United Kingdom';
        customerRequest.CustomerIDEvidence      = 'Passport';
        customerRequest.EvidenceOfAddress       = '';
        customerRequest.CustomerDocSerialNo     = '';
        customerRequest.DocumentIssueDate       = '';
        customerRequest.TotalIncomeBeforeTax    = '50000';
        customerRequest.DateMovedToCurrentAddress= '2000-01-01';
        customerRequest.DateMovedToPrevAddress  = '';
        customerRequest.DateEmploymentCommenced = '2001-03-03';
        customerRequest.CustomerFirstName       = 'Betty';
        customerRequest.CustomerMiddleName      = '';
        customerRequest.CustomerPreviousName    = '';
        customerRequest.CountryOfBirth          = 'United Kingdom';
        customerRequest.TownOfBirth             = 'Hull';
        customerRequest.PrevAddrHouseNo         = '';
        customerRequest.PrevAddrLine1           = '';
        customerRequest.PrevAddrLine2           = '';
        customerRequest.PrevAddrLine3           = '';
        customerRequest.PrevAddrLine4           = '';
        customerRequest.PrevAddrCountry         = '';
        customerRequest.PrevPCode               = '';
        customerRequest.PrevPrevAddrHouseNo     = '';
        customerRequest.PrevPrevAddrLine1       = '';
        customerRequest.PrevPrevAddrLine2       = '';
        customerRequest.PrevPrevAddrLine3       = '';
        customerRequest.PrevPrevAddrLine4       = '';
        customerRequest.PrevPrevAddrCountry     = '';
        customerRequest.PrevPrevPCode           = '';
        customerRequest.EmployerName            = 'Acme Inc';
        customerRequest.EmployerAddrLine1       = 'HQ';
        customerRequest.EmployerAddrLine2       = '22 Acacia Ave';
        customerRequest.EmployerAddrLine3       = 'Northfield';
        customerRequest.EmployerAddrLine4       = 'Birmingham';
        customerRequest.EmployerAddrLine5       = '';
        customerRequest.EmployerPostCode        = 'B28 9ZZ';
        customerRequest.EmployerNatureOfBuiness = 'Cars';
        customerRequest.MobNo                   = '11111111111';
        customerRequest.WorkTelNo               = '2222222222';
        customerRequest.PrivateEmail            = 'foo@blah.com';
        customerRequest.HomeDetails             = 'Employed';
        customerRequest.EmploymentType          = '';
        customerRequest.EmploymentStatus        = '';
        customerRequest.Occupation              = 'Boss';
        customerRequest.NoOfChildren            = '0';
        customerRequest.CurrentBankSortCode     = '111111';
        customerRequest.CurrentBankDetailsName  = 'Fargo Bank';
        customerRequest.CustSalutation          = 'Ms';
        customerRequest.AddrLine1               = '4013 West Fen Road';
        customerRequest.AddrLine2               = '';
        customerRequest.AddrLine3               = 'Ely';
        customerRequest.AddrLine4               = '';
        customerRequest.AddrLine5               = 'United Kingdom';
        customerRequest.PostCode                = 'CB6 1AN';
        customerRequest.TelNo                   = '33333333333';
        customerRequest.DateMovedToPrevPrevAddress  = 'United Kingdom';
        customerRequest.NationalityCountry      = '';
        customerRequest.OrganisationName        = '';
        customerRequest.OrganisationType        = '';
        customerRequest.OrgRegisteredAddrStreet = '';
        customerRequest.OrgRegisteredAddrCity   = '';
        customerRequest.OrgRegisteredAddrPCode  = '';
        customerRequest.OrgRegisteredAddrCountry    = '';
        customerRequest.OrgRegisteredAddrMovingInDate  = '';
        customerRequest.OrgRegNo                = '';
        customerRequest.OrgRegDate              = '';
        customerRequest.OrgVATNo                = '';
        customerRequest.OrgTradingAddrStreet    = '';
        customerRequest.OrgTradingAddrCity      = '';
        customerRequest.OrgTradingAddrPCode     = '';
        customerRequest.OrgTradingAddrCountry   = '';
        customerRequest.OrgCorrespondenceAddrStreet = '';
        customerRequest.OrgCorrespondenceAddrCity   = '';
        customerRequest.OrgCorrespondenceAddrPCode  = '';
        customerRequest.OrgCorrespondenceAddrCountry= '';
        customerRequest.OrgStartDate            = '';
        customerRequest.OrgNoDirectors          = 0;
        customerRequest.OrgNoEmpl               = 0;
        customerRequest.OrgIndustry             = '';
        customerRequest.OrgSIC                  = '';
        customerRequest.OrgMainCountryOfBusiness= '';
        customerRequest.OrgTurnover             = 0;
        customerRequest.OrgBankName             = '';
        customerRequest.OrgBankSortCode         = '';
        customerRequest.OrgBankAccNo            = '';
        

        return JSON.serialize ( customerRequest );
    }
    
    public static ARBCustomerAMLResponseModel invokeMockAPI () {
        StaticResource sr = [SELECT Id, Body FROM StaticResource WHERE Name = 'JSON_AWAIT' LIMIT 1];
        String apiResponse = sr.Body.toString();
        
        ARBCustomerAMLResponseModel responseObj = ARBCustomerAMLResponseModel.parse( apiResponse );
        
        System.debug ('responseObj' + responseObj);
        return responseObj;
    }
}