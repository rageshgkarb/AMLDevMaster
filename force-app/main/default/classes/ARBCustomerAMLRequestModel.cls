/*******************************************************************
* @Class Name      : ARBCustomerAMLRequestModel
* @Author          : RAGESH G
* @Created Date    : 17 August 2022
* @description      : This is model class used to create the request to TruNarrative with Customer details via Middleware
* @JIRA            : 

  LOG   DATE        Author  UserStory         COMMENT      
* 001   17/08/2022  RG                       First Commit
********************************************************************/
public class ARBCustomerAMLRequestModel {

    public String MessageId;
    public String DateRequested;
    public String MessageType;
    public String RequestType;
    public String TNaccountId;
    public String OpportunityId;
    public String ApplicationAccountType;
    public String CustomerType;
    public String CustomerRelationship;
    public String PrimaryApplicant;
    public String ExistingCustomer;
    public String UKCitizen;
    public String SFDCID;
    public String CustomerNumber;
    public String AccountName;
    public String CustomerSurName;
    public String CustDateOfBirth;
    public String CustomerGender;
    public String MaritalStatus;
    public String CountryOfResidence;
    public String CustomerIDEvidence;
    public String EvidenceOfAddress;
    public String CustomerDocSerialNo;
    public String DocumentIssueDate;
    public String TotalIncomeBeforeTax;
    public String DateMovedToCurrentAddress;
    public String DateMovedToPrevAddress;
    public String DateEmploymentCommenced;
    public String CustomerFirstName;
    public String CustomerMiddleName;
    public String CustomerPreviousName;
    public String CountryOfBirth;
    public String TownOfBirth;
    public String PrevAddrHouseNo;
    public String PrevAddrLine1;
    public String PrevAddrLine2;
    public String PrevAddrLine3;
    public String PrevAddrLine4;
    public String PrevAddrCountry;
    public String PrevPCode;
    public String PrevPrevAddrHouseNo;
    public String PrevPrevAddrLine1;
    public String PrevPrevAddrLine2;
    public String PrevPrevAddrLine3;
    public String PrevPrevAddrLine4;
    public String PrevPrevAddrCountry;
    public String PrevPrevPCode;
    public String EmployerName;
    public String EmployerAddrLine1;
    public String EmployerAddrLine2;
    public String EmployerAddrLine3;
    public String EmployerAddrLine4;
    public String EmployerAddrLine5;
    public String EmployerPostCode;
    public String EmployerNatureOfBuiness;
    public String MobNo;
    public String WorkTelNo;
    public String PrivateEmail;
    public String HomeDetails;
    public String EmploymentType;
    public String EmploymentStatus;
    public String Occupation;
    public String NoOfChildren;
    public String CurrentBankSortCode;
    public String CurrentBankDetailsName;
    public String CustSalutation;
    public String AddrLine1;
    public String AddrLine2;
    public String AddrLine3;
    public String AddrLine4;
    public String AddrLine5;
    public String PostCode;
    public String TelNo;
    public String DateMovedToPrevPrevAddress;
    public String NationalityCountry;
    public String OrganisationName;
    public String OrganisationType;
    public String OrgRegisteredAddrStreet;
    public String OrgRegisteredAddrCity;
    public String OrgRegisteredAddrPCode;
    public String OrgRegisteredAddrCountry;
    public String OrgRegisteredAddrMovingInDate;
    public String OrgRegNo;
    public String OrgRegDate;
    public String OrgVATNo;
    public String OrgTradingAddrStreet;
    public String OrgTradingAddrCity;
    public String OrgTradingAddrPCode;
    public String OrgTradingAddrCountry;
    public String OrgCorrespondenceAddrStreet;
    public String OrgCorrespondenceAddrCity;
    public String OrgCorrespondenceAddrPCode;
    public String OrgCorrespondenceAddrCountry;
    public String OrgStartDate;
    public Integer OrgNoDirectors;
    public Integer OrgNoEmpl;
    public String OrgIndustry;
    public String OrgSIC;
    public String OrgMainCountryOfBusiness;
    public Integer OrgTurnover;
    public String OrgBankName;
    public String OrgBankSortCode;
    public String OrgBankAccNo;
    public String OpportunityName;

    public List<ClientApplicationPurposes> ClientApplicationPurposes;

    public class ClientApplicationPurposes {
    public String code;
  }

  public static ARBCustomerAMLRequestModel parse(String json) {
	return (ARBCustomerAMLRequestModel) System.JSON.deserialize(json, ARBCustomerAMLRequestModel.class);
}
  }