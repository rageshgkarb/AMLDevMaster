/*******************************************************************
* @Class Name      : ARBConstantValues
* @Author          : RAGESH G
* @Created Date    : 20 January 2021
* @description 	   : This class is used to write all the constant values accross the application
* @JIRA            : SFD-271

  LOG   DATE        Author  UserStory       	COMMENT      
* 001   10/01/2021  RG                       First Commit
********************************************************************/
public with sharing class ARBConstantValues {
    
    public static String CASE_PRIORITY = System.Label.ARB_Case_Priority;
    public static String CASE_STATUS = System.Label.ARB_Case_Status;
    public static String CASE_ORIGIN = System.Label.ARB_Case_Origin;

    public static String CASE_RECORD_TYPE = System.Label.ARB_Case_Record_Type;
    
    //Constants for ARBCustomerAMLRequestHelper //ADDED Mateen Ahmed - 02/05/23
    public static String CUSTOMER_TYPE_INDIVIDUALS = System.Label.ARB_Customer_Type_Individuals; //Individuals
    public static String CUSTOMER_TYPE_COMPANY = System.Label.ARB_Customer_Type_Company;//COMPANY   
    public static String CUSTOMER_RELATIONSHIP_APPLICANT = System.Label.ARB_Customer_Relationship_Applicant;//'APPLICANT';
    public static String REQUEST_TYPE_587 = System.Label.ARB_REQUEST_TYPE; // '587';
    public static String BUSINESS_ACCOUNT_RECORD_TYPE = System.Label.ARB_Business_Account_Record_Type;//'012D0000000QQfrIAG';
    public static String KYC_NONPERSONAL = System.Label.ARB_Customer_KYC_NP;//'KYCNonPersonal';
    public static String KYC_PERSONAL = System.Label.ARB_Customer_KYC_Personal;//'KYCPersonal';
    public static String APPLICATION_ACCOUNT_TYPE_SAVINGS = System.Label.ARB_Savings_Account;//'Savings';
    public static String MESSAGETYPE_UPDATE = System.Label.ARB_Message_Type_Update;//'SFDCAMLUpdate';
    public static String MESSAGETYPE_REQUEST = System.Label.ARB_Message_Type_Request; //'SFDCAMLRequest';
    public static String MESSAGETYPE_PERIODICREVIEW = System.Label.ARB_Message_Type_PeriodicReview;//MESSAGETYPE_PERIODICREVIEW
    public static String PRIMARY_APPLICANT_TRUE = System.Label.ARB_True_Value;//'true';
    public static Integer ZERO_COUNT = integer.valueof(System.Label.ARB_Count_Zero);//0;
    public Static String CUSTOMER_RELATIONSHIP_DIRECTOR = System.Label.ARB_Customer_Relationship_Director;//DIRECTOR
    
    //Constants for ARBCustomerAMLAPIUtils //ADDED Mateen Ahmed - 22/05/2023
    public static String  AML_HUB_ACCOUNT_REQUEST= System.Label.ARB_AML_Hub_AccountRequest;//AMLHubAccountRequest
    public static String  OBJECT_OPPORTUNITY= System.Label.ARB_Opportunity_ObjectType;
    public Static String DECLINE = 'DECLINE';
    public Static String CLOSE = 'CLOSE';
    public Static String REFERRED = 'REFERRED';
    public Static String AWAITING_RESPONSE = 'AWAITING_RESPONSE';
    public Static String PENDING_EXTERNAL_APPROVAL = 'PENDING_EXTERNAL_APPROVAL';
    public Static String ACCEPT = 'ACCEPT';
    public Static String COMPLETE = 'COMPLETE';
    public Static String SUCCESS = 'SUCCESS';
    public Static String ERROR = 'ERROR';
    public Static String ACCOUNT_REFERRED = 'ACCOUNT REFERRED';
    //public static String CASE_RECORD_ID= System.Label.ARB_Case_Record_ID;//0123z0000007WwUAAU Risk Scheduled Review

    
    
    
    


    
    
}