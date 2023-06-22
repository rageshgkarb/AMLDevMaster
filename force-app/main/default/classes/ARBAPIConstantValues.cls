/*******************************************************************
* @Class Name      : ARBAPIConstantValues
* @Author          : RAGESH G
* @Created Date    : 26/09/2022
* @description 	   : This class is used to write all the constant values accross the application for TN API development
* @JIRA            : SFD-331

  LOG   DATE        Author  UserStory       	COMMENT      
* 001   26/09/2021  RG                       First Commit
********************************************************************/
public class ARBAPIConstantValues {
    public static String CAA_RECORD_TYPE = System.Label.ARB_TN_CAA_Record_Type;
    public static String CAA_ANC_STRING = System.Label.ARB_TN_CAA_ANC;
    public static String CAA_ELIGIBILITY = System.Label.ARB_TN_CAA_ELIGIBILITY;
    public static String PERSONAL_SOME_LEVEL_MATCH = 'CRA screening fields updated in Salesforce - Yes?-029';
    public static String PERSONAL_NO_MATCH = 'CRA screening fields updated in Salesforce - N/A?-030';
    public static String NON_PERSONAL_NO_MATCH = 'CRA screening fields updated in Salesforce - N/A?-030';
    public static String NON_PERSONAL_SOME_LEVEL_MATCH = 'CRA screening fields updated in Salesforce - Yes?-029';
    public static String CLOSED_CUSTOMER_STATUS = System.Label.ARB_Closed_Customer_Status;
    public static String NON_PERSON_ACCOUNT_RECORD_TYPE = System.Label.ARB_TN_Non_Person_Account_Record_Type;

    // Referral statuses 

    public static String ARB_Referral_Pending_External = System.Label.ARB_Referral_Pending_External;
    public static String ARB_Referral_Accept = System.Label.ARB_Referral_Accept;
    public static String ARB_Referral_Complete = System.Label.ARB_Referral_Complete;
    public static String ARB_Referral_Referred = System.Label.ARB_Referral_Referred;
    public static String ARB_Referral_Awaiting_response = System.Label.ARB_Referral_Awaiting_response;


    // case creation constant strings
    public static String Risk_Scheduled_Review = 'Risk_Scheduled_Review';




}