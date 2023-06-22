import { LightningElement,api,wire,track } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { getObjectInfo } from 'lightning/uiObjectInfoApi';

export default class Eddformbase extends NavigationMixin(LightningElement) {
    @api recordId;
    @api customerDetail;
    showspinner = false;

    eddId;
    error;
    reviewType;
    customerName;
    caseNumberTitle;
    caseNumber;
    caseId;
    ebsId; 
    accountId;
    riskRating;
    relationshipManager;
    relationshipManagerWrap = {};
    relationshipManagerApprovalWrap = {};
    dateOfSubmission;
    department;
    reviewPreparedBy;
    reviewPreparedByWrap = {};
    entityType;
    tradingAddress;
    registeredAddress;
    registrationNumber;
    countryOfIncorporation;
    contactMethod;
    contactLastMade;
    methodMostRecentContact;
    customerConvertedDate;
    sourceOfFunds;
    sourceOfFundsCountry;
    internationalFundTransferFrequency;
    intFundTransferSource;
    estMonthlyVolumeInward;
    estMonthlyVolumeOutward;
    estCashWithdrawalFrequency;
    estCashDeprequency;
    overallCompCreditTurnover;
    expAnnualTurnover;
    rrcorporatestructure;
    corporatestructure;
    AMLOCRecommendation;
    MLRORecommendation;
    RMRecommendation;
    KYCRecommendation;
    adversemediamatch;
    sanctionsscreeningmatch;
    pepScreeningmatch;
    IDVvalidationcheck;
    IDVsatisfied;
    structurecomplex;
    reasonEntityType;
    spvtrust;
    rrcorporatestructure;
    MLROCRAOverride;
    RationaleforMLROCRAOverride;
    datecheckscompletedApproval;
    datecheckscompleted;
    kycselectedDate;
    RMdateofApproval;
    MLROdateofApproval;
    AMLOCdateofApproval;
    politicallyExposedCompany;
    hrProhibitedsanctionedCORforSignif;
    hrProhibitedsanctionedCORforUBOsI;
    EDDsupportinginformation;
    onboardingcaseno;
    onboardingCasenoWrap = {};
    kycAnalystlookupWrapper = {};
    mlrolookupWrapper = {};
    kycAnalyst; 
    mlroName;
    orgType;
    layersOfOwner;
    lengthOfEst;
    balanceSheet;
    sancIndCheck;
    negNewsScreen;
    preDecExited;
    natureOfBusiNPAA;
    abtCustomer;
    rationalePepStatus;
    RMRecomComments;
    RMName;
    KycAnalystComments;
    MLROName;
    MLRORecomComments;
    AMLOCRecomComments;
    totalAssets;
    totalLibs;
    netWorth;
    PepComments;
    IDVValidationComments;
    SanctionsScreeningComments;
    AdversMediaMatchComments;
    SourceofComments;
    sofChangesince;
    ScreenedParties;
    PEPScreeningPositiveMatch;
    ScreenedRelationship;
    PEPScreeningPositiveMatch;
    AdverseMediaScreeningPositiveMatchplusmatchtype;
    ScreenedPartiesComments;
    IDVPurpose;
    IDVLocation;
    IDVPartiesComments;
    totalAssets;
    IssuedDate;
    NextRenewalDate;
    SourceofWealthComments;
    itemCount;
    AppendixIDVLocation;
    
    linkedcustomercolumns = [{label: 'Customer', fieldName: 'caccName',type: 'text', sortable:true},
                             {label: 'EBS ID', fieldName: 'caccebsid',type: 'text', sortable:true}   ];

    customerAccountcolumns = [{label: 'Customer', fieldName: 'caccName',type: 'text', sortable:true},
                             {label: 'Product', fieldName: 'caccProduct',type: 'text', sortable:true},
                             {label: 'Nature & Purpose', fieldName: 'caccNPAccount',type: 'text', sortable:true},
                             {label: 'Is Blocked', fieldName: 'caccIsBlocked',type: 'text', sortable:true}  ];

    sowcolumns = [{label: 'Name', fieldName: 'name',type: 'text', sortable:true},
                {label: '£', fieldName: 'amount',type: 'text', sortable:true},
                {label: 'Change Since Last Review', fieldName: 'changelastreview',type: 'text', sortable:true},
                {label: 'Comments', fieldName: 'comment',type: 'text', sortable:true}];

    sofcolumns = [  {label: 'Source of Funds', fieldName: 'sourceOfFunds',type: 'text', sortable:true},
                    {label: 'Change Since last Review', fieldName: 'changelastreview',type: 'text', sortable:true},
                    {label: 'Comments', fieldName: 'comment',type: 'text', sortable:true}];


    idvColumns ={column1:'Document name',column2:'Purpose',column3:'Location',column4:'Issued Date',column5:'Next renewal date',column6:'Comments'};
    idvitems=[{id:1},{id:2,countryOptions:''}];


    // screenedPartiesColumns ={column1:'Document name',column2:'Purpose',column3:'Location',column4:'Issued Date',column5:'Next renewal date',column6:'Comments'};

    screenedPartiesColumns = [{label: 'Screened name', fieldName: 'ScreenedName',type: 'text', sortable:true},
                    {label: 'Relationship', fieldName: 'Relationship',type: 'text', sortable:true},
                    {
                      label: 'PEP Screening Positive Match plus match type',
                      fieldName: 'pepScreening',
                      type: 'picklistColumn',
                      editable: !this.isDisabledListener,
                      typeAttributes: {
                          placeholder: 'Select an Option',
                          options: {fieldName: 'pickListOptions'}
                        }
                    },
                {
                label: 'Sanction Screening Positive Match plus match type',
                fieldName: 'sanctionScreening',
                type: 'picklistColumn',
                editable: !this.isDisabledListener,
                typeAttributes: {
                    placeholder: 'Select an Option',
                    options: {fieldName: 'pickListOptions'}
                    }
                },
                {
                  label: 'Adverse Media Screening Positive Match plus match type',
                  fieldName: 'adverseMedia',
                  type: 'picklistColumn',
                  editable: !this.isDisabledListener,
                  typeAttributes: {
                      placeholder: 'Select an Option',
                      options: {fieldName: 'pickListOptions'}
                    }
                    
                },
                {label: 'Comments', fieldName: 'Comments',type: 'text', sortable:true}]

    screenPartiesData =[{"ScreenedName":"Business Property","Relationship":"","pepScreening":"","sanctionScreening":"","adverseMedia":"","Comments":"","pickListOptions":[{"label":"N/A","value":"N/A"},{"label":"True Match","value":"True Match"},{"label":"No True Match","value":"No True Match"}]}];
    
    get reviewTypeOptions(){
        return[
            { label: 'Onboarding' ,value: 'Onboarding' },
            { label: 'EDR' ,value: 'EDR' },
            { label: 'PR' ,value: 'PR' }
            ];
    }

    get departmentOptions(){
        return[
            { label: 'Commercial' ,value: 'Commercial' },
            { label: 'Premier' ,value: 'Premier' },
            { label: 'Retail' ,value: 'Retail' }
            ];
    }

    get methodMostRecentContactOptions(){
        return[
            { label: 'Phone' ,value: 'Phone' },
            { label: 'Face to face' ,value: 'Face to face' },
            { label: 'Email' ,value: 'Email' },
            { label: 'Post' ,value: 'Post' },
            { label: 'Secure message' ,value: 'Secure message' }
            ];
    }

    get corporateStructureOptions(){
        return[
            { label: 'Yes' ,value: 'Yes' },
            { label: 'No' ,value: 'No' },
            { label: 'N/A' ,value: 'N/A' }
        ];
    }


    get yesnoOptions(){
        return[
            { label: 'Yes' ,value: 'Yes' },
            { label: 'No' ,value: 'No' }
        ];
    }

    get matchOptions(){
        return[
            { label: 'N/A' ,value: 'N/A' },
            { label: 'True Match' ,value: 'True Match' },
            { label: 'No True Match' ,value: 'No True Match' }
        ];
    }

     get optionsIDV(){
        return[
            { label: 'ID' ,value: 'ID' },
            { label: 'POA' ,value: 'POA' },
            { label: 'SOW' ,value: 'SOW' },
            { label: 'SOF' ,value: 'SOF' },
            { label: 'Other' ,value: 'Other' },
            //{ label: 'etc' ,value: 'etc' }
        ];
    }
   
   get passfailOptions(){
        return[
            { label: 'Pass' ,value: 'Pass' },
            { label: 'Fail' ,value: 'Fail' }
        ];
    }

    get KYCRMRecommendationOptions(){
        return[
            { label: 'Onboard' ,value: 'Onboard' },
            { label: 'Retain' ,value: 'Retain' },
            { label: 'Exit' ,value: 'Exit' }
        ];
    }

    get purposeOptions(){
      return[
       { label: 'ID' ,value: 'ID' },
            { label: 'POA' ,value: 'POA' },
            { label: 'SOW' ,value: 'SOW' },
            { label: 'SOF' ,value: 'SOF' },
            { label: 'other' ,value: 'other' },
            { label: 'etc' ,value: 'etc' }
        ];
    }

    get countryOptions(){
        return [
  {
    label: 'United Kingdom (GB)',
    value: 'United Kingdom (GB)',
    name: 'United Kingdom (GB)'
  },
  {
    label: 'Afghanistan (AF)',
    value: 'Afghanistan (AF)',
    name: 'Afghanistan (AF)'
  },
  {
    label: 'Albania (AL)',
    value: 'Albania (AL)',
    name: 'Albania (AL)'
  },
  {
    label: 'Algeria (DZ)',
    value: 'Algeria (DZ)',
    name: 'Algeria (DZ)'
  },
  {
    label: 'American Samoa (AS)',
    value: 'American Samoa (AS)',
    name: 'American Samoa (AS)'
  },
  {
    label: 'Andorra (AD)',
    value: 'Andorra (AD)',
    name: 'Andorra (AD)'
  },
  { label: 'Angola (AO)', value: 'Angola (AO)', name: 'Angola (AO)' },
  {
    label: 'Anguilla (AI)',
    value: 'Anguilla (AI)',
    name: 'Anguilla (AI)'
  },
  {
    label: 'Neth Antilles (AN)',
    value: 'Neth Antilles (AN)',
    name: 'Neth Antilles (AN)'
  },
  {
    label: 'Antartica (AQ)',
    value: 'Antartica (AQ)',
    name: 'Antartica (AQ)'
  },
  {
    label: 'Antigua and Barbuda (AG)',
    value: 'Antigua and Barbuda (AG)',
    name: 'Antigua and Barbuda (AG)'
  },
  {
    label: 'Argentina (AR)',
    value: 'Argentina (AR)',
    name: 'Argentina (AR)'
  },
  {
    label: 'Armenia (AM)',
    value: 'Armenia (AM)',
    name: 'Armenia (AM)'
  },
  {
    label: 'Australia (AU)',
    value: 'Australia (AU)',
    name: 'Australia (AU)'
  },
  {
    label: 'Austria (AT)',
    value: 'Austria (AT)',
    name: 'Austria (AT)'
  },
  {
    label: 'Azerbaijan (AZ)',
    value: 'Azerbaijan (AZ)',
    name: 'Azerbaijan (AZ)'
  },
  {
    label: 'Bahamas (BS)',
    value: 'Bahamas (BS)',
    name: 'Bahamas (BS)'
  },
  {
    label: 'Bahrain (BH)',
    value: 'Bahrain (BH)',
    name: 'Bahrain (BH)'
  },
  {
    label: 'Bangladesh (BD)',
    value: 'Bangladesh (BD)',
    name: 'Bangladesh (BD)'
  },
  {
    label: 'Barbados (BB)',
    value: 'Barbados (BB)',
    name: 'Barbados (BB)'
  },
  {
    label: 'Belgium (BE)',
    value: 'Belgium (BE)',
    name: 'Belgium (BE)'
  },
  { label: 'Belize (BZ)', value: 'Belize (BZ)', name: 'Belize (BZ)' },
  { label: 'Benin (BJ)', value: 'Benin (BJ)', name: 'Benin (BJ)' },
  {
    label: 'Bermuda (BM)',
    value: 'Bermuda (BM)',
    name: 'Bermuda (BM)'
  },
  { label: 'Bhutan (BT)', value: 'Bhutan (BT)', name: 'Bhutan (BT)' },
  {
    label: 'Bolivia (BO)',
    value: 'Bolivia (BO)',
    name: 'Bolivia (BO)'
  },
  {
    label: 'Bosnia-Herzegovina (BA)',
    value: 'Bosnia-Herzegovina (BA)',
    name: 'Bosnia-Herzegovina (BA)'
  },
  {
    label: 'Botswana (BW)',
    value: 'Botswana (BW)',
    name: 'Botswana (BW)'
  },
  {
    label: 'Bouvet Island (BV)',
    value: 'Bouvet Island (BV)',
    name: 'Bouvet Island (BV)'
  },
  {
    label: 'Burkina Fasso (BF)',
    value: 'Burkina Fasso (BF)',
    name: 'Burkina Fasso (BF)'
  },
  { label: 'Brazil (BR)', value: 'Brazil (BR)', name: 'Brazil (BR)' },
  {
    label: 'Virgin Islands, Brit (VG)',
    value: 'Virgin Islands, Brit (VG)',
    name: 'Virgin Islands, Brit (VG)'
  },
  {
    label: 'British Indian Oc Te (IO)',
    value: 'British Indian Oc Te (IO)',
    name: 'British Indian Oc Te (IO)'
  },
  {
    label: 'Brunei Darussalam (BN)',
    value: 'Brunei Darussalam (BN)',
    name: 'Brunei Darussalam (BN)'
  },
  {
    label: 'Bulgaria (BG)',
    value: 'Bulgaria (BG)',
    name: 'Bulgaria (BG)'
  },
  {
    label: 'Burundi (BI)',
    value: 'Burundi (BI)',
    name: 'Burundi (BI)'
  },
  {
    label: 'Belarus (BY)',
    value: 'Belarus (BY)',
    name: 'Belarus (BY)'
  },
  {
    label: 'Cambodia (KH)',
    value: 'Cambodia (KH)',
    name: 'Cambodia (KH)'
  },
  {
    label: 'Cameroon (CM)',
    value: 'Cameroon (CM)',
    name: 'Cameroon (CM)'
  },
  { label: 'Canada (CA)', value: 'Canada (CA)', name: 'Canada (CA)' },
  {
    label: 'Cape Verde (CV)',
    value: 'Cape Verde (CV)',
    name: 'Cape Verde (CV)'
  },
  {
    label: 'Cayman Islands (KY)',
    value: 'Cayman Islands (KY)',
    name: 'Cayman Islands (KY)'
  },
  {
    label: 'Central African Rep (CF)',
    value: 'Central African Rep (CF)',
    name: 'Central African Rep (CF)'
  },
  { label: 'Chad (TD)', value: 'Chad (TD)', name: 'Chad (TD)' },
  { label: 'Chile (CL)', value: 'Chile (CL)', name: 'Chile (CL)' },
  { label: 'China (CN)', value: 'China (CN)', name: 'China (CN)' },
  {
    label: 'Christmas Island (CX)',
    value: 'Christmas Island (CX)',
    name: 'Christmas Island (CX)'
  },
  {
    label: 'Cocos (Keeling) Is (CC)',
    value: 'Cocos (Keeling) Is (CC)',
    name: 'Cocos (Keeling) Is (CC)'
  },
  {
    label: 'Columbia (CO)',
    value: 'Columbia (CO)',
    name: 'Columbia (CO)'
  },
  {
    label: 'Comoros (KM)',
    value: 'Comoros (KM)',
    name: 'Comoros (KM)'
  },
  { label: 'Congo (CG)', value: 'Congo (CG)', name: 'Congo (CG)' },
  {
    label: 'Cook Islands (CK)',
    value: 'Cook Islands (CK)',
    name: 'Cook Islands (CK)'
  },
  {
    label: 'Costa Rica (CR)',
    value: 'Costa Rica (CR)',
    name: 'Costa Rica (CR)'
  },
  {
    label: 'Croatia (HR)',
    value: 'Croatia (HR)',
    name: 'Croatia (HR)'
  },
  { label: 'Cuba (CU)', value: 'Cuba (CU)', name: 'Cuba (CU)' },
  { label: 'Cyprus (CY)', value: 'Cyprus (CY)', name: 'Cyprus (CY)' },
  {
    label: 'Czech Republic (CZ)',
    value: 'Czech Republic (CZ)',
    name: 'Czech Republic (CZ)'
  },
  {
    label: 'Denmark (DK)',
    value: 'Denmark (DK)',
    name: 'Denmark (DK)'
  },
  {
    label: 'Djibouti (DJ)',
    value: 'Djibouti (DJ)',
    name: 'Djibouti (DJ)'
  },
  {
    label: 'Dominica (DM)',
    value: 'Dominica (DM)',
    name: 'Dominica (DM)'
  },
  {
    label: 'Dominican Republic (DO)',
    value: 'Dominican Republic (DO)',
    name: 'Dominican Republic (DO)'
  },
  {
    label: 'Ecuador (EC)',
    value: 'Ecuador (EC)',
    name: 'Ecuador (EC)'
  },
  { label: 'Egypt (EG)', value: 'Egypt (EG)', name: 'Egypt (EG)' },
  {
    label: 'El Salvador (SV)',
    value: 'El Salvador (SV)',
    name: 'El Salvador (SV)'
  },
  {
    label: 'Equatorial Guinea (GQ)',
    value: 'Equatorial Guinea (GQ)',
    name: 'Equatorial Guinea (GQ)'
  },
  {
    label: 'Estonia (EE)',
    value: 'Estonia (EE)',
    name: 'Estonia (EE)'
  },
  {
    label: 'Ethiopia (ET)',
    value: 'Ethiopia (ET)',
    name: 'Ethiopia (ET)'
  },
  {
    label: 'Faeroe Islands (FO)',
    value: 'Faeroe Islands (FO)',
    name: 'Faeroe Islands (FO)'
  },
  {
    label: 'Falkland Islands (FK)',
    value: 'Falkland Islands (FK)',
    name: 'Falkland Islands (FK)'
  },
  { label: 'Fiji (FJ)', value: 'Fiji (FJ)', name: 'Fiji (FJ)' },
  {
    label: 'Finland (FI)',
    value: 'Finland (FI)',
    name: 'Finland (FI)'
  },
  { label: 'France (FR)', value: 'France (FR)', name: 'France (FR)' },
  {
    label: 'French Guiana (GF)',
    value: 'French Guiana (GF)',
    name: 'French Guiana (GF)'
  },
  {
    label: 'French Polynesia (PF)',
    value: 'French Polynesia (PF)',
    name: 'French Polynesia (PF)'
  },
  { label: 'Gabon (GA)', value: 'Gabon (GA)', name: 'Gabon (GA)' },
  { label: 'Gambia (GM)', value: 'Gambia (GM)', name: 'Gambia (GM)' },
  {
    label: 'Germany (DE)',
    value: 'Germany (DE)',
    name: 'Germany (DE)'
  },
  { label: 'Ghana (GH)', value: 'Ghana (GH)', name: 'Ghana (GH)' },
  {
    label: 'Gibraltar (GI)',
    value: 'Gibraltar (GI)',
    name: 'Gibraltar (GI)'
  },
  { label: 'Greece (GR)', value: 'Greece (GR)', name: 'Greece (GR)' },
  {
    label: 'Greenland (GL)',
    value: 'Greenland (GL)',
    name: 'Greenland (GL)'
  },
  {
    label: 'Grenada (GD)',
    value: 'Grenada (GD)',
    name: 'Grenada (GD)'
  },
  {
    label: 'Georgia (GE)',
    value: 'Georgia (GE)',
    name: 'Georgia (GE)'
  },
  {
    label: 'Guadeloupe (GP)',
    value: 'Guadeloupe (GP)',
    name: 'Guadeloupe (GP)'
  },
  { label: 'Guam (GU)', value: 'Guam (GU)', name: 'Guam (GU)' },
  {
    label: 'Guatemala (GT)',
    value: 'Guatemala (GT)',
    name: 'Guatemala (GT)'
  },
  {
    label: 'Guernsey C.I. (GG)',
    value: 'Guernsey C.I. (GG)',
    name: 'Guernsey C.I. (GG)'
  },
  { label: 'Guinea (GN)', value: 'Guinea (GN)', name: 'Guinea (GN)' },
  {
    label: 'Guinea-Bissau (GW)',
    value: 'Guinea-Bissau (GW)',
    name: 'Guinea-Bissau (GW)'
  },
  { label: 'Guyana (GY)', value: 'Guyana (GY)', name: 'Guyana (GY)' },
  { label: 'Haiti (HT)', value: 'Haiti (HT)', name: 'Haiti (HT)' },
  {
    label: 'Heard & McDonald Is (HM)',
    value: 'Heard & McDonald Is (HM)',
    name: 'Heard & McDonald Is (HM)'
  },
  {
    label: 'Honduras (HN)',
    value: 'Honduras (HN)',
    name: 'Honduras (HN)'
  },
  {
    label: 'Hong Kong (HK)',
    value: 'Hong Kong (HK)',
    name: 'Hong Kong (HK)'
  },
  {
    label: 'Hungary (HU)',
    value: 'Hungary (HU)',
    name: 'Hungary (HU)'
  },
  {
    label: 'Iceland (IS)',
    value: 'Iceland (IS)',
    name: 'Iceland (IS)'
  },
  { label: 'India (IN)', value: 'India (IN)', name: 'India (IN)' },
  {
    label: 'Indonesia (ID)',
    value: 'Indonesia (ID)',
    name: 'Indonesia (ID)'
  },
  { label: 'Iran (IR)', value: 'Iran (IR)', name: 'Iran (IR)' },
  { label: 'Iraq (IQ)', value: 'Iraq (IQ)', name: 'Iraq (IQ)' },
  {
    label: 'Ireland (IE)',
    value: 'Ireland (IE)',
    name: 'Ireland (IE)'
  },
  {
    label: 'Isle of Man (IM)',
    value: 'Isle of Man (IM)',
    name: 'Isle of Man (IM)'
  },
  { label: 'Israel (IL)', value: 'Israel (IL)', name: 'Israel (IL)' },
  { label: 'Italy (IT)', value: 'Italy (IT)', name: 'Italy (IT)' },
  {
    label: 'Cote dIvoire (IC)',
    value: 'Cote dIvoire (IC)',
    name: 'Cote dIvoire (IC)'
  },
  {
    label: 'Jamaica (JM)',
    value: 'Jamaica (JM)',
    name: 'Jamaica (JM)'
  },
  { label: 'Japan (JP)', value: 'Japan (JP)', name: 'Japan (JP)' },
  {
    label: 'Jersey C.I. (JE)',
    value: 'Jersey C.I. (JE)',
    name: 'Jersey C.I. (JE)'
  },
  { label: 'Jordan (JO)', value: 'Jordan (JO)', name: 'Jordan (JO)' },
  {
    label: 'Kazakhstan (KZ)',
    value: 'Kazakhstan (KZ)',
    name: 'Kazakhstan (KZ)'
  },
  { label: 'Kenya (KE)', value: 'Kenya (KE)', name: 'Kenya (KE)' },
  {
    label: 'Kiribati (KI)',
    value: 'Kiribati (KI)',
    name: 'Kiribati (KI)'
  },
  {
    label: 'Korea, Dem Ppl Rep (KP)',
    value: 'Korea, Dem Ppl Rep (KP)',
    name: 'Korea, Dem Ppl Rep (KP)'
  },
  { label: 'Korea (KR)', value: 'Korea (KR)', name: 'Korea (KR)' },
  { label: 'Kuwait (KW)', value: 'Kuwait (KW)', name: 'Kuwait (KW)' },
  {
    label: 'Kyrgyzstan (KG)',
    value: 'Kyrgyzstan (KG)',
    name: 'Kyrgyzstan (KG)'
  },
  {
    label: 'Lao Peoples Dem Rep (LA)',
    value: 'Lao Peoples Dem Rep (LA)',
    name: 'Lao Peoples Dem Rep (LA)'
  },
  { label: 'Latvia (LV)', value: 'Latvia (LV)', name: 'Latvia (LV)' },
  {
    label: 'Lebanon (LB)',
    value: 'Lebanon (LB)',
    name: 'Lebanon (LB)'
  },
  {
    label: 'Lesotho (LS)',
    value: 'Lesotho (LS)',
    name: 'Lesotho (LS)'
  },
  {
    label: 'Liberia (LR)',
    value: 'Liberia (LR)',
    name: 'Liberia (LR)'
  },
  {
    label: 'Libyan Arab Jamah (LY)',
    value: 'Libyan Arab Jamah (LY)',
    name: 'Libyan Arab Jamah (LY)'
  },
  {
    label: 'Liechtenstein (LI)',
    value: 'Liechtenstein (LI)',
    name: 'Liechtenstein (LI)'
  },
  {
    label: 'Lithuania (LT)',
    value: 'Lithuania (LT)',
    name: 'Lithuania (LT)'
  },
  {
    label: 'Luxembourg (LU)',
    value: 'Luxembourg (LU)',
    name: 'Luxembourg (LU)'
  },
  { label: 'Macau (MO)', value: 'Macau (MO)', name: 'Macau (MO)' },
  {
    label: 'Madagascar (MG)',
    value: 'Madagascar (MG)',
    name: 'Madagascar (MG)'
  },
  { label: 'Malawi (MW)', value: 'Malawi (MW)', name: 'Malawi (MW)' },
  {
    label: 'Malaysia (MY)',
    value: 'Malaysia (MY)',
    name: 'Malaysia (MY)'
  },
  {
    label: 'Maldives (MV)',
    value: 'Maldives (MV)',
    name: 'Maldives (MV)'
  },
  { label: 'Mali (ML)', value: 'Mali (ML)', name: 'Mali (ML)' },
  { label: 'Malta (MT)', value: 'Malta (MT)', name: 'Malta (MT)' },
  {
    label: 'Marshall Islands (MH)',
    value: 'Marshall Islands (MH)',
    name: 'Marshall Islands (MH)'
  },
  {
    label: 'Martinique (MQ)',
    value: 'Martinique (MQ)',
    name: 'Martinique (MQ)'
  },
  {
    label: 'Mauritania (MR)',
    value: 'Mauritania (MR)',
    name: 'Mauritania (MR)'
  },
  {
    label: 'Mauritius (MU)',
    value: 'Mauritius (MU)',
    name: 'Mauritius (MU)'
  },
  {
    label: 'Micronesia (FM)',
    value: 'Micronesia (FM)',
    name: 'Micronesia (FM)'
  },
  { label: 'Mexico (MX)', value: 'Mexico (MX)', name: 'Mexico (MX)' },
  {
    label: 'Moldova, Republic of (MD)',
    value: 'Moldova, Republic of (MD)',
    name: 'Moldova, Republic of (MD)'
  },
  { label: 'Monaco (MC)', value: 'Monaco (MC)', name: 'Monaco (MC)' },
  {
    label: 'Mongolia (MN)',
    value: 'Mongolia (MN)',
    name: 'Mongolia (MN)'
  },
  {
    label: 'Monserrat (MS)',
    value: 'Monserrat (MS)',
    name: 'Monserrat (MS)'
  },
  {
    label: 'Morocco (MA)',
    value: 'Morocco (MA)',
    name: 'Morocco (MA)'
  },
  {
    label: 'Mozambique (MZ)',
    value: 'Mozambique (MZ)',
    name: 'Mozambique (MZ)'
  },
  {
    label: 'Myanmar (MM)',
    value: 'Myanmar (MM)',
    name: 'Myanmar (MM)'
  },
  {
    label: 'Namibia (NA)',
    value: 'Namibia (NA)',
    name: 'Namibia (NA)'
  },
  { label: 'Nauru (NR)', value: 'Nauru (NR)', name: 'Nauru (NR)' },
  { label: 'Nepal (NP)', value: 'Nepal (NP)', name: 'Nepal (NP)' },
  {
    label: 'Netherlands (NL)',
    value: 'Netherlands (NL)',
    name: 'Netherlands (NL)'
  },
  {
    label: 'Neutral Zone (NT)',
    value: 'Neutral Zone (NT)',
    name: 'Neutral Zone (NT)'
  },
  { label: 'Aruba (AW)', value: 'Aruba (AW)', name: 'Aruba (AW)' },
  {
    label: 'New Caledonia (NC)',
    value: 'New Caledonia (NC)',
    name: 'New Caledonia (NC)'
  },
  {
    label: 'New Zealand (NZ)',
    value: 'New Zealand (NZ)',
    name: 'New Zealand (NZ)'
  },
  {
    label: 'Nicaragua (NI)',
    value: 'Nicaragua (NI)',
    name: 'Nicaragua (NI)'
  },
  { label: 'Niger (NE)', value: 'Niger (NE)', name: 'Niger (NE)' },
  {
    label: 'Nigeria (NG)',
    value: 'Nigeria (NG)',
    name: 'Nigeria (NG)'
  },
  { label: 'Niue (NU)', value: 'Niue (NU)', name: 'Niue (NU)' },
  {
    label: 'Norfolk Island (NF)',
    value: 'Norfolk Island (NF)',
    name: 'Norfolk Island (NF)'
  },
  {
    label: 'Northern Mariana Is (MP)',
    value: 'Northern Mariana Is (MP)',
    name: 'Northern Mariana Is (MP)'
  },
  { label: 'Norway (NO)', value: 'Norway (NO)', name: 'Norway (NO)' },
  { label: 'Oman (OM)', value: 'Oman (OM)', name: 'Oman (OM)' },
  {
    label: 'Pakistan (PK)',
    value: 'Pakistan (PK)',
    name: 'Pakistan (PK)'
  },
  { label: 'Palau (PW)', value: 'Palau (PW)', name: 'Palau (PW)' },
  { label: 'Panama (PA)', value: 'Panama (PA)', name: 'Panama (PA)' },
  {
    label: 'Panama Canal Zone (PZ)',
    value: 'Panama Canal Zone (PZ)',
    name: 'Panama Canal Zone (PZ)'
  },
  {
    label: 'Papua New Guinea (PG)',
    value: 'Papua New Guinea (PG)',
    name: 'Papua New Guinea (PG)'
  },
  {
    label: 'Paraguay (PY)',
    value: 'Paraguay (PY)',
    name: 'Paraguay (PY)'
  },
  { label: 'Peru (PE)', value: 'Peru (PE)', name: 'Peru (PE)' },
  {
    label: 'Philippines (PH)',
    value: 'Philippines (PH)',
    name: 'Philippines (PH)'
  },
  {
    label: 'Pitcairn (PN)',
    value: 'Pitcairn (PN)',
    name: 'Pitcairn (PN)'
  },
  { label: 'Poland (PL)', value: 'Poland (PL)', name: 'Poland (PL)' },
  {
    label: 'Portugal (PT)',
    value: 'Portugal (PT)',
    name: 'Portugal (PT)'
  },
  {
    label: 'East Timor (TP)',
    value: 'East Timor (TP)',
    name: 'East Timor (TP)'
  },
  {
    label: 'Puerto Rico (PR)',
    value: 'Puerto Rico (PR)',
    name: 'Puerto Rico (PR)'
  },
  { label: 'Qatar (QA)', value: 'Qatar (QA)', name: 'Qatar (QA)' },
  {
    label: 'Reunion (RE)',
    value: 'Reunion (RE)',
    name: 'Reunion (RE)'
  },
  {
    label: 'Romania (RO)',
    value: 'Romania (RO)',
    name: 'Romania (RO)'
  },
  {
    label: 'Russian Federation (RU)',
    value: 'Russian Federation (RU)',
    name: 'Russian Federation (RU)'
  },
  { label: 'Rwanda (RW)', value: 'Rwanda (RW)', name: 'Rwanda (RW)' },
  {
    label: 'St Helena (SH)',
    value: 'St Helena (SH)',
    name: 'St Helena (SH)'
  },
  {
    label: 'St Kitts and Nevis (KN)',
    value: 'St Kitts and Nevis (KN)',
    name: 'St Kitts and Nevis (KN)'
  },
  {
    label: 'Saint Lucia (LC)',
    value: 'Saint Lucia (LC)',
    name: 'Saint Lucia (LC)'
  },
  {
    label: 'St Pierre & Miquelon (PM)',
    value: 'St Pierre & Miquelon (PM)',
    name: 'St Pierre & Miquelon (PM)'
  },
  {
    label: 'St Vincent & the Gre (VC)',
    value: 'St Vincent & the Gre (VC)',
    name: 'St Vincent & the Gre (VC)'
  },
  { label: 'Samoa (WS)', value: 'Samoa (WS)', name: 'Samoa (WS)' },
  {
    label: 'San Marino (SM)',
    value: 'San Marino (SM)',
    name: 'San Marino (SM)'
  },
  {
    label: 'Sao Tome & Principe (ST)',
    value: 'Sao Tome & Principe (ST)',
    name: 'Sao Tome & Principe (ST)'
  },
  {
    label: 'Saudi Arabia (SA)',
    value: 'Saudi Arabia (SA)',
    name: 'Saudi Arabia (SA)'
  },
  {
    label: 'Senegal (SN)',
    value: 'Senegal (SN)',
    name: 'Senegal (SN)'
  },
  {
    label: 'Seychelles (SC)',
    value: 'Seychelles (SC)',
    name: 'Seychelles (SC)'
  },
  {
    label: 'Sierra Leone (SL)',
    value: 'Sierra Leone (SL)',
    name: 'Sierra Leone (SL)'
  },
  {
    label: 'Singapore (SG)',
    value: 'Singapore (SG)',
    name: 'Singapore (SG)'
  },
  {
    label: 'Slovakia (SK)',
    value: 'Slovakia (SK)',
    name: 'Slovakia (SK)'
  },
  {
    label: 'Slovenia (SI)',
    value: 'Slovenia (SI)',
    name: 'Slovenia (SI)'
  },
  {
    label: 'Solomon Islands (SB)',
    value: 'Solomon Islands (SB)',
    name: 'Solomon Islands (SB)'
  },
  {
    label: 'Somalia (SO)',
    value: 'Somalia (SO)',
    name: 'Somalia (SO)'
  },
  {
    label: 'South Africa (ZA)',
    value: 'South Africa (ZA)',
    name: 'South Africa (ZA)'
  },
  { label: 'Spain (ES)', value: 'Spain (ES)', name: 'Spain (ES)' },
  {
    label: 'Western Sahara (EH)',
    value: 'Western Sahara (EH)',
    name: 'Western Sahara (EH)'
  },
  {
    label: 'Sri Lanka (LK)',
    value: 'Sri Lanka (LK)',
    name: 'Sri Lanka (LK)'
  },
  { label: 'Sudan (SD)', value: 'Sudan (SD)', name: 'Sudan (SD)' },
  {
    label: 'Suriname (SR)',
    value: 'Suriname (SR)',
    name: 'Suriname (SR)'
  },
  {
    label: 'Svalbard & Jan Mayan (SJ)',
    value: 'Svalbard & Jan Mayan (SJ)',
    name: 'Svalbard & Jan Mayan (SJ)'
  },
  {
    label: 'Swaziland (SZ)',
    value: 'Swaziland (SZ)',
    name: 'Swaziland (SZ)'
  },
  { label: 'Sweden (SE)', value: 'Sweden (SE)', name: 'Sweden (SE)' },
  {
    label: 'Switzerland (CH)',
    value: 'Switzerland (CH)',
    name: 'Switzerland (CH)'
  },
  {
    label: 'Syrian Arab Republic (SY)',
    value: 'Syrian Arab Republic (SY)',
    name: 'Syrian Arab Republic (SY)'
  },
  { label: 'Taiwan (TW)', value: 'Taiwan (TW)', name: 'Taiwan (TW)' },
  {
    label: 'Tajikistan (TJ)',
    value: 'Tajikistan (TJ)',
    name: 'Tajikistan (TJ)'
  },
  {
    label: 'Tanzania (TZ)',
    value: 'Tanzania (TZ)',
    name: 'Tanzania (TZ)'
  },
  {
    label: 'French Sthn Terr. (TF)',
    value: 'French Sthn Terr. (TF)',
    name: 'French Sthn Terr. (TF)'
  },
  {
    label: 'Thailand (TH)',
    value: 'Thailand (TH)',
    name: 'Thailand (TH)'
  },
  { label: 'Togo (TG)', value: 'Togo (TG)', name: 'Togo (TG)' },
  {
    label: 'Tokelau (TK)',
    value: 'Tokelau (TK)',
    name: 'Tokelau (TK)'
  },
  { label: 'Tonga (TO)', value: 'Tonga (TO)', name: 'Tonga (TO)' },
  {
    label: 'Trinidad & Tobago (TT)',
    value: 'Trinidad & Tobago (TT)',
    name: 'Trinidad & Tobago (TT)'
  },
  {
    label: 'Tunisia (TN)',
    value: 'Tunisia (TN)',
    name: 'Tunisia (TN)'
  },
  { label: 'Turkey (TR)', value: 'Turkey (TR)', name: 'Turkey (TR)' },
  {
    label: 'Turkmenistan (TM)',
    value: 'Turkmenistan (TM)',
    name: 'Turkmenistan (TM)'
  },
  {
    label: 'Turka & Caicos Is (TC)',
    value: 'Turka & Caicos Is (TC)',
    name: 'Turka & Caicos Is (TC)'
  },
  { label: 'Tuvalu (TV)', value: 'Tuvalu (TV)', name: 'Tuvalu (TV)' },
  { label: 'Uganda (UG)', value: 'Uganda (UG)', name: 'Uganda (UG)' },
  {
    label: 'Ukraine (UA)',
    value: 'Ukraine (UA)',
    name: 'Ukraine (UA)'
  },
  {
    label: 'United Arab Emirates (AE)',
    value: 'United Arab Emirates (AE)',
    name: 'United Arab Emirates (AE)'
  },
  {
    label: 'United States (US)',
    value: 'United States (US)',
    name: 'United States (US)'
  },
  {
    label: 'US Minor Outlaying I (UM)',
    value: 'US Minor Outlaying I (UM)',
    name: 'US Minor Outlaying I (UM)'
  },
  {
    label: 'Uruguay (UY)',
    value: 'Uruguay (UY)',
    name: 'Uruguay (UY)'
  },
  {
    label: 'Virgin Islands, U.S. (VI)',
    value: 'Virgin Islands, U.S. (VI)',
    name: 'Virgin Islands, U.S. (VI)'
  },
  {
    label: 'Uzbekistan (UZ)',
    value: 'Uzbekistan (UZ)',
    name: 'Uzbekistan (UZ)'
  },
  {
    label: 'Vanuatu (VU)',
    value: 'Vanuatu (VU)',
    name: 'Vanuatu (VU)'
  },
  {
    label: 'Vatican City State (VA)',
    value: 'Vatican City State (VA)',
    name: 'Vatican City State (VA)'
  },
  {
    label: 'Venezuela (VE)',
    value: 'Venezuela (VE)',
    name: 'Venezuela (VE)'
  },
  {
    label: 'Vietnam (VN)',
    value: 'Vietnam (VN)',
    name: 'Vietnam (VN)'
  },
  {
    label: 'Wallis & Futuna Is (WF)',
    value: 'Wallis & Futuna Is (WF)',
    name: 'Wallis & Futuna Is (WF)'
  },
  { label: 'Yemen', value: 'Yemen', name: 'Yemen' },
  {
    label: 'Yugoslavia (YU)',
    value: 'Yugoslavia (YU)',
    name: 'Yugoslavia (YU)'
  },
  { label: 'Zaire (ZR)', value: 'Zaire (ZR)', name: 'Zaire (ZR)' },
  { label: 'Zambia (ZM)', value: 'Zambia (ZM)', name: 'Zambia (ZM)' },
  {
    label: 'Zimbabwe (ZW)',
    value: 'Zimbabwe (ZW)',
    name: 'Zimbabwe (ZW)'
  },
  {
    label: 'Palestinian Territory (PS)',
    value: 'Palestinian Territory (PS)',
    name: 'Palestinian Territory (PS)'
  },
  {
    label: 'Eritrea (ER)',
    value: 'Eritrea (ER)',
    name: 'Eritrea (ER)'
  },
  { label: 'Palestine.', value: 'Palestine.', name: 'Palestine.' },
  { label: 'Kosovo (KO)', value: 'Kosovo (KO)', name: 'Kosovo (KO)' },
  {
    label: 'Serbia And Montenegro (SP)',
    value: 'Serbia And Montenegro (SP)',
    name: 'Serbia And Montenegro (SP)'
  },
  {
    label: 'British Virgin Islands (VGB)',
    value: 'British Virgin Islands (VGB)',
    name: 'British Virgin Islands (VGB)'
  },
  {
    label: 'Aland Islands (ALA)',
    value: 'Aland Islands (ALA)',
    name: 'Aland Islands (ALA)'
  },
  {
    label: 'Antarctica (ATA)',
    value: 'Antarctica (ATA)',
    name: 'Antarctica (ATA)'
  },
  {
    label: 'Bonaire (BES)',
    value: 'Bonaire (BES)',
    name: 'Bonaire (BES)'
  },
  {
    label: 'British Indian Ocean Territory (IOT)',
    value: 'British Indian Ocean Territory (IOT)',
    name: 'British Indian Ocean Territory (IOT)'
  },
  {
    label: 'Burkina Faso (BFA)',
    value: 'Burkina Faso (BFA)',
    name: 'Burkina Faso (BFA)'
  },
  {
    label: 'Central African Republic (CAF)',
    value: 'Central African Republic (CAF)',
    name: 'Central African Republic (CAF)'
  },
  {
    label: 'Christmas Islands (CXR)',
    value: 'Christmas Islands (CXR)',
    name: 'Christmas Islands (CXR)'
  },
  {
    label: 'Cocos (Keeling) Islands (CCK)',
    value: 'Cocos (Keeling) Islands (CCK)',
    name: 'Cocos (Keeling) Islands (CCK)'
  },
  {
    label: 'Colombia (COL)',
    value: 'Colombia (COL)',
    name: 'Colombia (COL)'
  },
  {
    label: 'Congo – Brazzaville (COG)',
    value: 'Congo – Brazzaville (COG)',
    name: 'Congo – Brazzaville (COG)'
  },
  {
    label: 'Curacao (CUW)',
    value: 'Curacao (CUW)',
    name: 'Curacao (CUW)'
  },
  {
    label: 'Democratic Republic of Congo (COD)',
    value: 'Democratic Republic of Congo (COD)',
    name: 'Democratic Republic of Congo (COD)'
  },
  {
    label: 'Faroe Islands (FRO)',
    value: 'Faroe Islands (FRO)',
    name: 'Faroe Islands (FRO)'
  },
  {
    label: 'French Southern Territories (ATF)',
    value: 'French Southern Territories (ATF)',
    name: 'French Southern Territories (ATF)'
  },
  {
    label: 'Guernsey (GGY)',
    value: 'Guernsey (GGY)',
    name: 'Guernsey (GGY)'
  },
  {
    label: 'Heard Island and McDonald Islands (HMD)',
    value: 'Heard Island and McDonald Islands (HMD)',
    name: 'Heard Island and McDonald Islands (HMD)'
  },
  {
    label: 'Holy See (Vatican City State) (VAT)',
    value: 'Holy See (Vatican City State) (VAT)',
    name: 'Holy See (Vatican City State) (VAT)'
  },
  {
    label: 'Iran (Islamic Republic of) (IRN)',
    value: 'Iran (Islamic Republic of) (IRN)',
    name: 'Iran (Islamic Republic of) (IRN)'
  },
  {
    label: 'Lao Peoples Democratic Republic (LAO)',
    value: 'Lao Peoples Democratic Republic (LAO)',
    name: 'Lao Peoples Democratic Republic (LAO)'
  },
  {
    label: 'Macedonia (MKD)',
    value: 'Macedonia (MKD)',
    name: 'Macedonia (MKD)'
  },
  {
    label: 'Mayotte (MYT)',
    value: 'Mayotte (MYT)',
    name: 'Mayotte (MYT)'
  },
  {
    label: 'Montenegro (MNE)',
    value: 'Montenegro (MNE)',
    name: 'Montenegro (MNE)'
  },
  {
    label: 'Montserrat (MSR)',
    value: 'Montserrat (MSR)',
    name: 'Montserrat (MSR)'
  },
  {
    label: 'Norfolk Islands (NFK)',
    value: 'Norfolk Islands (NFK)',
    name: 'Norfolk Islands (NFK)'
  },
  {
    label: 'North Korea (PRK)',
    value: 'North Korea (PRK)',
    name: 'North Korea (PRK)'
  },
  {
    label: 'Northern Mariana Islands (MNP)',
    value: 'Northern Mariana Islands (MNP)',
    name: 'Northern Mariana Islands (MNP)'
  },
  {
    label: 'Palestinian Territory Occupied (PSE)',
    value: 'Palestinian Territory Occupied (PSE)',
    name: 'Palestinian Territory Occupied (PSE)'
  },
  { label: 'Saba (BES)', value: 'Saba (BES)', name: 'Saba (BES)' },
  {
    label: 'Sao Tome and Principe (STP)',
    value: 'Sao Tome and Principe (STP)',
    name: 'Sao Tome and Principe (STP)'
  },
  {
    label: 'Serbia (SRB)',
    value: 'Serbia (SRB)',
    name: 'Serbia (SRB)'
  },
  {
    label: 'Sint Eustatius (BES)',
    value: 'Sint Eustatius (BES)',
    name: 'Sint Eustatius (BES)'
  },
  {
    label: 'South Georgia and the South Sandwich Islands (SGS)',
    value: 'South Georgia and the South Sandwich Islands (SGS)',
    name: 'South Georgia and the South Sandwich Islands (SGS)'
  },
  {
    label: 'South Korea  (KOR)',
    value: 'South Korea  (KOR)',
    name: 'South Korea  (KOR)'
  },
  {
    label: 'South Sudan (SSD)',
    value: 'South Sudan (SSD)',
    name: 'South Sudan (SSD)'
  },
  {
    label: 'St Lucia (LCA)',
    value: 'St Lucia (LCA)',
    name: 'St Lucia (LCA)'
  },
  {
    label: 'St Maarten - Dutch (SXM)',
    value: 'St Maarten - Dutch (SXM)',
    name: 'St Maarten - Dutch (SXM)'
  },
  {
    label: 'St Martin - French (MAF)',
    value: 'St Martin - French (MAF)',
    name: 'St Martin - French (MAF)'
  },
  {
    label: 'St Vincent and the Grenadines (VCT)',
    value: 'St Vincent and the Grenadines (VCT)',
    name: 'St Vincent and the Grenadines (VCT)'
  },
  {
    label: 'St. Barthelemy (BLM)',
    value: 'St. Barthelemy (BLM)',
    name: 'St. Barthelemy (BLM)'
  },
  {
    label: 'St. Helena, Ascension and Tristan Da Cunha (SHN)',
    value: 'St. Helena, Ascension and Tristan Da Cunha (SHN)',
    name: 'St. Helena, Ascension and Tristan Da Cunha (SHN)'
  },
  {
    label: 'Svalbard and Jan Mayen (SJM)',
    value: 'Svalbard and Jan Mayen (SJM)',
    name: 'Svalbard and Jan Mayen (SJM)'
  },
  {
    label: 'Turks and Caicos Islands (TCA)',
    value: 'Turks and Caicos Islands (TCA)',
    name: 'Turks and Caicos Islands (TCA)'
  },
  {
    label: 'United States Minor Outlying Islands (UMI)',
    value: 'United States Minor Outlying Islands (UMI)',
    name: 'United States Minor Outlying Islands (UMI)'
  },
  {
    label: 'Wallis And Futuna (WLF)',
    value: 'Wallis And Futuna (WLF)',
    name: 'Wallis And Futuna (WLF)'
  }
  ];
    }

 

   
}