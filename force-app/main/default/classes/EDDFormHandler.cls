public without sharing class EDDFormHandler {
    public static final String RES_STATUS = 'status';
    public static final String RES_STATUS_MSG = 'statusMsg';
    public static final String SUCCESS = 'SUCCESS';
    public static final String ERROR = 'ERROR';
    public static final String WARNING = 'WARNING';
    public static final String ERR_SHORT = 'An Error occurred ';
    public static Case oCase;




 @AuraEnabled
    public static Map<String, Object> save(String saveObjdata, string savemode) {
        Map<String, Object> resMap = new Map<String, Object>{RES_STATUS => SUCCESS};
        try{
            System.debug('saveObjdata : '+saveObjdata);
            Customer objCus = (Customer) System.JSON.deserialize(saveObjdata, Customer.class);
            System.debug('objCus : '+objCus);
            resMap.put('customerDetails',saveEDD(objCus,savemode));
            list<Account_with_IBB__c> lstcustAccs = [Select id,Primary_SFDC_Account__c,Primary_SFDC_Account__r.Name,Account_Blocked__c, IBB_Product_Name__c,EBS_ID__c
                                                            from Account_with_IBB__c 
                                                            where Account_Closed__c != 'Y' and Primary_SFDC_Account__c =: objCus.AccountId];
            
            list<CustomerAccounts> allCustomerAccounts = new list<CustomerAccounts>();
            for(Account_with_IBB__c each : lstcustAccs){
                CustomerAccounts objLinkedCustomer = new CustomerAccounts(each);
                allCustomerAccounts.add(objLinkedCustomer);
            }
            
            resMap.put('customeraccounts', allCustomerAccounts );
        }catch(Exception e){
            String errMsg = ERR_SHORT + 'saveAsDraftEDD . '+e;
            resMap.put(RES_STATUS, ERROR);
            resMap.put(RES_STATUS_MSG, errMsg);
            system.debug('Exception e'+e);
        }
        return resMap;
    }


    public static Customer saveEDD(Customer objCus, string mode){
        EDD_Form__c objEDD = new EDD_Form__c();
        System.debug('objCus.eddId : '+objCus.eddId);
        if(objCus.eddId != null){
            objEDD.Id = objCus.eddId;
            if(mode == 'submitEDD'){
                EDD_Form__c objtemp = getEDDRec(objEDD.Id,'');
                objEDD.Entity_Type__c=objtemp.Customer_Name__r.Entity_Type__c;
                //objEDD.Location__c=objtemp.Customer_Name__r.Location__c;
                objEDD.Source_of_Funds__c=objtemp.Customer_Name__r.Source_of_Funds__c;
                objEDD.International_Fund_Transfer_Frequency__c=objtemp.Customer_Name__r.International_Fund_Transfer_Frequency__c;
                objEDD.Estimated_Monthly_Volume_Inward__c=objtemp.Customer_Name__r.Estimated_Monthly_Volume_Inward__c;
                objEDD.Estimated_Cash_Withdrawal_Frequency__c=objtemp.Customer_Name__r.Estimated_Cash_Withdrawal_Frequency__c;
                objEDD.Overall_Company_Credit_Turnover__c=objtemp.Customer_Name__r.Company_anticipated_turnover__c;
                objEDD.Contact_method_at_Onboarding__c=objtemp.Customer_Name__r.Face_to_face_Contact__c; 
                //objEDD.Method_of_most_recent_contact__c=objtemp.Customer_Name__r.Method_of_most_recent_contact__c; 
                objEDD.Source_of_Funds_Country__c=objtemp.Customer_Name__r.Source_of_Funds_Country__c;
                objEDD.International_Fund_Transfer_Source__c=objtemp.Customer_Name__r.International_Fund_Transfer_Source__c;
                objEDD.Estimated_Monthly_Volume_Outward__c=objtemp.Customer_Name__r.Estimated_Monthly_Volume_Outward__c;
                objEDD.Estimated_Cash_Deposit_frequency__c=objtemp.Customer_Name__r.Estimated_Cash_Deposit_frequency__c;
                objEDD.EBS_ID__c=objtemp.Customer_Name__r.EBS_ID__c;
                //objEDD.Risk_Rating__c=objtemp.Customer_Name__r.Risk_Rating__c;
                objEDD.Organisation_type__c=objtemp.Customer_Name__r.Organisation_type__c;
                objEDD.Previously_Exited_or_Declined__c = objtemp.Customer_Name__r.Previously_Exited_or_Declined__c;
                objEDD.Layers_of_Ownership__c=objtemp.Customer_Name__r.Layers_of_Ownership__c;
                objEDD.Balance_Sheet_000s__c=objtemp.Customer_Name__r.Balance_Sheet_000s__c;
                objEDD.Sanctioned_Individual_Check__c=objtemp.Customer_Name__r.Sanctioned_Individual_Check__c;
                objEDD.Organisation_Domicile__c=objtemp.Customer_Name__r.Organisation_Domicile__c;
                objEDD.Length_of_Establishment__c=objtemp.Customer_Name__r.Length_of_Establishment__c;
                objEDD.Politically_Exposed_Company__c=objtemp.Customer_Name__r.Politically_Exposed_Company__c;
                objEDD.Negative_News_Screening__c=objtemp.Customer_Name__r.Negative_News_Screening__c;
                objEDD.Nature_of_Business_NPAA__c=objtemp.Customer_Name__r.Nature_of_Business_NPAA__c;
                objEDD.PEP_status__c=objtemp.Customer_Name__r.Politically_Exposed_Company__c;
                objEDD.HR_Prohibited_sanctioned_COR_for_UBOs__c=objtemp.Customer_Name__r.HR_Prohibited_sanctioned_COR_for_UBOs_I__c;
                objEDD.HR_Prohibited_sanctioned_COR_for_Signif__c = objtemp.Customer_Name__r.High_risk_prohibited_sanctioned_countr__c;
                objEDD.Date_Converted_to_Customer__c = objtemp.Customer_Name__r.Date_Converted_to_Customer__c;
                
           

            }
        }
        objEDD.Customer_Name__c = objCus.AccountId;
        objEDD.EDD_Review_SF_Case_Number__c = objCus.caseId;
        System.debug(objCus.reviewType);
		objEDD.Review_Type__c = objCus.reviewType;
		objEDD.Relationship_Manager__c = objCus.relationshipManager;
		objEDD.Review_prepared_by__c = objCus.reviewPreparedBy;
        objEDD.Onboarding_Case_Number__c = objCus.onboardingcaseno;
        objEDD.KYC_Analyst__c = objCus.kycAnalyst;
        objEDD.MLRO_Name__c = objCus.mlroName;
		objEDD.Expected_Annual_Turnover__c = objCus.expAnnualTurnover;
        objEDD.Summary_of_the_Customer__c = 	objCus.abtCustomer;	
        objEDD.Confirmation_that_a_corporate_structure__c =objCus.corporatestructure ;
        objEDD.Is_there_reasonable_rationale_structure__c =objCus.rrcorporatestructure;
        objEDD.Does_it_involve_SPVs_trusts_etc__c =	objCus.spvtrust ;	
        objEDD.If_yes_please_state_entity_type_reason__c =	objCus.reasonEntityType 	;
        objEDD.Is_the_structure_complex_opaque__c =	objCus.structurecomplex;	
        objEDD.ID_V_satisfied__c =	objCus.IDVsatisfied 				;						
        objEDD.Supporting_information__c =	objCus.EDDsupportinginformation;				
        objEDD.Rationale_for_PEP_Status__c =	objCus.rationalePepStatus;			
       // objEDD.Date_checks_completed__c =	objCus.datecheckscompleted;	
        objEDD.Date_of_Approval__c = objCus.datecheckscompletedApproval;
        objEDD.ID_V_validation_check__c =	objCus.IDVvalidationcheck;
        objEDD.Date_checks_completed__c = objCus.kycselectedDate;

        objEDD.Adverse_Media_match_Comments__c = objCus.AdversMediaMatchComments;	
        objEDD.PEP_Screening_match__c =	objCus.pepScreeningmatch;				
        objEDD.Sanctions_Screening_match__c =objCus.sanctionsscreeningmatch;
        objEDD.Adverse_Media_Screening_Positive_Match__c = objCus.AdverseMediaScreeningPositiveMatchplusmatchtype;
        objEDD.Adverse_Media_match__c =		objCus.adversemediamatch;			
        objEDD.KYC_Analyst_Recommendation__c =	objCus.KYCRecommendation;			
        objEDD.RM_Recommendation__c =	objCus.RMRecommendation;					
        objEDD.MLRO_CRA_Override__c = objCus.MLROCRAOverride;
        objEDD.Rationale_for_MLRO_CRA_Override__c = objCus.RationaleforMLROCRAOverride;						
        objEDD.MLRO_Recommendation__c =	objCus.MLRORecommendation;
        objEDD.MLRO_Recommendation_Comments__c =	objCus.MLRORecomComments;	
        objEDD.AMLOC_Recommendation_Comments__c =	objCus.AMLOCRecomComments;		
        objEDD.AMLOC_Recommendation__c	 =	objCus.AMLOCRecommendation;			
        objEDD.AMLOC_Date_of_Approval__c =	objCus.AMLOCdateofApproval;	
        objEDD.Issued_date__c = objCus.IssuedDate;	
        objEDD.Next_renewal_date__c = objCus.NextRenewalDate;		
        objEDD.MLRO_Date_of_Approval__c =	objCus.MLROdateofApproval;				
        objEDD.RM_Recommendation_Comments__c =objCus.RMRecomComments;
       // objEDD.Relationship_Manager__c =	objCus.RMName ;
       // objEDD.MLRO_Name__c =	objCus.MLROName	;							
        objEDD.RM_Date_of_Approval__c =	objCus.RMdateofApproval;				
        objEDD.KYC_Analyst_Recommendation_Comments__c =objCus.KycAnalystComments;
		objEDD.ID_V_validation_check_Comments__c =objCus.IDVValidationComments;
        objEDD.PEP_Screening_match_Comments__c = objCus.PepComments;
        objEDD.Sanctions_Screening_match_Comments__c = objCus.SanctionsScreeningComments;
        objEDD.Source_of_Funds_Comments__c = objCus.SourceofComments;
        objEDD.Change_since_last_review__c = objCus.sofChangesince;
        objEDD.Screened_Parties__c = objCus.ScreenedParties;
        objEDD.PEP_Screening_Positive_Match_plus_match__c = objCus.PEPScreeningPositiveMatch;
        objEDD.Relationship__c = objCus.ScreenedRelationship;
        objEDD.Sanction_Screening_Positive_Match_plus__c = objCus.SanctionScreeningPositiveMatch;
        objEDD.Comments__c = objCus.ScreenedPartiesComments;
        objEDD.Purpose__c = objCus.IDVPurpose;
        objEDD.Location__c = objCus.IDVLocation;
        objEDD.IDV_Comments__c = objCus.IDVPartiesComments;
        objEDD.Total_Assets__c = objCus.totalAssets;
        objEDD.Total_Liabilities__c = objCus.totalLibs;
        objEDD.Net_Worth__c = objCus.netWorth;
        objEDD.Source_of_Wealth_Comments__c = objCus.SourceofWealthComments;
        objEDD.Item_Count__c = objCus.itemCount;
        objEDD.Reference_Name__c = objCus.jsonReferenceName;
        objEDD.Is_Submitted_EDD__c = objCus.isSubmittedEDD; 
        objEDD.Appendix_IDV_Location__c = objCus.AppendixIDVLocation;

        upsert objEDD;

        if(objCus.linkaccounts != null){
            list<Linked_Customers__c> linkedCuss = new list<Linked_Customers__c>();
            for(LinkedCustomers each : objCus.linkaccounts ){
                Linked_Customers__c objLC = new Linked_Customers__c();
                if(each.Id != null){
                    objLC.Id = each.Id;
                }
                objLC.Customer__c = each.caccId;
                objLC.EBS_ID__c = each.caccebsid;
                objLC.EDD__c = objEDD.Id;
                linkedCuss.add(objLC);
                
            }
            upsert linkedCuss;
        }

        if(objCus.customeraccounts != null){
            
            list<Nature_and_Purpose__c> NPCuss = new list<Nature_and_Purpose__c>();
            for(Customeraccounts each: objCus.customeraccounts){
                Nature_and_Purpose__c objNP = new Nature_and_Purpose__c();
                if(each.Id != null){
                    objNP.Id = each.Id;
                }
                objNP.Blocked__c    = each.caccIsBlocked;
                objNP.Customer_Account__c   = each.caccId;
                objNP.EDD__c        = objEDD.id;
                objNP.Product__c    = each.caccProduct;
                //string allNPs = string.join(each.caccNPAccount,',');
                //objNP.Nature_Purpose__c    = allNPs;
                NPCuss.add(objNP);
            }

            upsert NPCuss;
        }

        return new Customer(getEDDRec(objEDD.Id,''),new Customer());
    }

    public static Customer updateEDD(Customer objCus, Boolean FinalSave){

        return new Customer();
    }

    public static EDD_Form__c getEDDRec(String EDDId, String caseId){
        EDD_Form__c objEDD;

        if(!String.isBlank(EDDId)){
            objEDD = [Select Id,EDD_Review_SF_Case_Number__r.caseNumber, EDD_Review_SF_Case_Number__c, Expected_Annual_Turnover__c,
                         Summary_of_the_Customer__c,Confirmation_that_a_corporate_structure__c,Is_there_reasonable_rationale_structure__c,				
                         Does_it_involve_SPVs_trusts_etc__c,If_yes_please_state_entity_type_reason__c,Is_the_structure_complex_opaque__c,ID_V_satisfied__c,		
                         Supporting_information__c,Rationale_for_PEP_Status__c,Date_checks_completed__c,ID_V_validation_check__c,PEP_Screening_match__c,	
                         Sanctions_Screening_match__c,Adverse_Media_match__c,KYC_Analyst_Recommendation__c,RM_Recommendation__c,	
                         MLRO_CRA_Override__c,Rationale_for_MLRO_CRA_Override__c,MLRO_Recommendation__c,	MLRO_Recommendation_Comments__c,AMLOC_Recommendation_Comments__c,
                         AMLOC_Recommendation__c,AMLOC_Date_of_Approval__c,MLRO_Date_of_Approval__c,RM_Recommendation_Comments__c,
                         MLRO_Name__c,RM_Date_of_Approval__c,KYC_Analyst_Recommendation_Comments__c,Customer_Name__c,
                            Customer_Name__r.Name, Customer_Name__r.EBS_ID__c, Customer_Name__r.Risk_Rating__c, Review_Type__c,
                            Customer_Name__r.Date_Converted_to_Customer__c, Customer_Name__r.Entity_Type__c, Customer_Name__r.Registered_number__c, 
                            Customer_Name__r.RegisteredAddressCity__c, Customer_Name__r.RegisteredAddressCountry__c, Customer_Name__r.RegisteredAddressPostCode__c, 
                            Customer_Name__r.RegisteredAddressStreet__c, Customer_Name__r.TradingAddressCity__c, Customer_Name__r.TradingAddressCountry__c, 
                            Customer_Name__r.TradingAddressStreet__c, Customer_Name__r.TradingPostCode__c, Customer_Name__r.Organisation_Domicile__c, 
                            Customer_Name__r.Face_to_face_Contact__c, Customer_Name__r.Source_of_Funds__c, Customer_Name__r.Source_of_Funds_Country__c, 
                            Customer_Name__r.International_Fund_Transfer_Frequency__c, Customer_Name__r.Estimated_Monthly_Volume_Inward__c,Customer_Name__r.Estimated_Monthly_Volume_Outward__c,Customer_Name__r.International_Fund_Transfer_Source__c, 
                            Customer_Name__r.Est_Monthly_Num_of_Transactions_Inward__c, Customer_Name__r.Politically_Exposed_Company__c, 
                            Customer_Name__r.High_risk_prohibited_sanctioned_countr__c, Customer_Name__r.HR_Prohibited_sanctioned_COR_for_UBOs_I__c,
                            Customer_Name__r.Estimated_Cash_Withdrawal_Frequency__c, Customer_Name__r.Est_Monthly_Num_of_Transactions_Outward__c, 
                            Customer_Name__r.Estimated_Cash_Deposit_frequency__c, Customer_Name__r.Company_anticipated_turnover__c,
                            Customer_Name__r.Nature_of_Employers_Your_Business__c, Customer_Name__r.Employment_Type__c, Customer_Name__r.Country_of_nationality__c, 
                            Customer_Name__r.Country_of_Residence__c,Customer_Name__r.What_is_your_total_net_worth__c, Customer_Name__r.Source_of_Wealth__c, 
                            Customer_Name__r.Pep__c, Relationship_Manager__c,Review_prepared_by__c,Customer_Name__r.Organisation_type__c, 
                            Customer_Name__r.Layers_of_Ownership__c, Customer_Name__r.Length_of_Establishment__c,Review_prepared_by__r.name,Relationship_Manager__r.name,
                            Customer_Name__r.Balance_Sheet_000s__c, Customer_Name__r.Sanctioned_Individual_Check__c, Customer_Name__r.Negative_News_Screening__c,
                            Customer_Name__r.Previously_Exited_or_Declined__c, Customer_Name__r.Nature_of_Business_NPAA__c,Sanctions_Screening_match_Comments__c,
                            Customer_Name__r.Country_of_PEP_Exposure__c, Customer_Name__r.PEP_Associate__c,ID_V_validation_check_Comments__c,PEP_Screening_match_Comments__c,
                            Adverse_Media_match_Comments__c,	Source_of_Funds_Comments__c,Change_since_last_review__c,Screened_Parties__c,PEP_Screening_Positive_Match_plus_match__c,
                            Relationship__c,Sanction_Screening_Positive_Match_plus__c,Adverse_Media_Screening_Positive_Match__c,Comments__c,Purpose__c,Location__c,IDV_Comments__c,
                            Onboarding_Case_Number__c,Date_of_Approval__c,Onboarding_Case_Number__r.CaseNumber,KYC_Analyst__c,KYC_Analyst__r.Name,KYC_Analyst__r.Id,MLRO_Name__r.Name,
                            Total_Assets__c,Total_Liabilities__c,Net_Worth__c,Overall_Company_Credit_Turnover__c,Contact_method_at_Onboarding__c,Method_of_most_recent_contact__c,
                            Risk_Rating__c,PEP_status__c,HR_Prohibited_sanctioned_COR_for_UBOs__c,Previously_Exited_or_Declined__c,HR_Prohibited_sanctioned_COR_for_Signif__c,Issued_date__c,Next_renewal_date__c,
                            Source_of_Wealth_Comments__c,Item_Count__c,Reference_Name__c,Is_Submitted_EDD__c,Entity_Type__c,Appendix_IDV_Location__c,
                               (Select Id,name,Customer__c,Customer__r.name, EBS_ID__c,EDD__c from Linked_Customers__r),
                               (Select Id,name from Account_Holders__r),(Select Id,name from Related_Customer_Entity_Relationships__r),                               
                                (Select Id,name,Customer__c,Customer__r.name, Customer__r.EBS_ID__c,EDD__c,Blocked__c,Nature_Purpose__c,Product__c,Customer_Account__c,Customer_Account__r.Primary_SFDC_Account__r.Name from Nature_and_Purpose__r)    
                            from EDD_Form__c where Id =: EDDId];
        }else{
            list<EDD_Form__c>  lstEDDs = [Select Id,EDD_Review_SF_Case_Number__r.caseNumber, EDD_Review_SF_Case_Number__c, Expected_Annual_Turnover__c,
                        Summary_of_the_Customer__c,Confirmation_that_a_corporate_structure__c,Is_there_reasonable_rationale_structure__c,				
                         Does_it_involve_SPVs_trusts_etc__c,If_yes_please_state_entity_type_reason__c,Is_the_structure_complex_opaque__c,ID_V_satisfied__c,		
                         Supporting_information__c,Rationale_for_PEP_Status__c,Date_checks_completed__c,ID_V_validation_check__c,PEP_Screening_match__c,	
                         Sanctions_Screening_match__c,Adverse_Media_match__c,KYC_Analyst_Recommendation__c,RM_Recommendation__c,	
                         MLRO_CRA_Override__c,Rationale_for_MLRO_CRA_Override__c,MLRO_Recommendation__c,	MLRO_Recommendation_Comments__c,AMLOC_Recommendation_Comments__c,
                         AMLOC_Recommendation__c,AMLOC_Date_of_Approval__c,MLRO_Date_of_Approval__c,RM_Recommendation_Comments__c,
                         MLRO_Name__c,RM_Date_of_Approval__c,KYC_Analyst_Recommendation_Comments__c,Customer_Name__c,
                            Customer_Name__r.Name, Customer_Name__r.EBS_ID__c, Customer_Name__r.Risk_Rating__c, Review_Type__c,
                            Customer_Name__r.Date_Converted_to_Customer__c, Customer_Name__r.Entity_Type__c, Customer_Name__r.Registered_number__c, 
                            Customer_Name__r.RegisteredAddressCity__c, Customer_Name__r.RegisteredAddressCountry__c, Customer_Name__r.RegisteredAddressPostCode__c, 
                            Customer_Name__r.RegisteredAddressStreet__c, Customer_Name__r.TradingAddressCity__c, Customer_Name__r.TradingAddressCountry__c, 
                            Customer_Name__r.TradingAddressStreet__c, Customer_Name__r.TradingPostCode__c, Customer_Name__r.Organisation_Domicile__c, 
                            Customer_Name__r.Face_to_face_Contact__c, Customer_Name__r.Source_of_Funds__c, Customer_Name__r.Source_of_Funds_Country__c, 
                            Customer_Name__r.International_Fund_Transfer_Frequency__c, Customer_Name__r.Estimated_Monthly_Volume_Inward__c,Customer_Name__r.Estimated_Monthly_Volume_Outward__c,Customer_Name__r.International_Fund_Transfer_Source__c, 
                            Customer_Name__r.Est_Monthly_Num_of_Transactions_Inward__c, Customer_Name__r.Politically_Exposed_Company__c, 
                            Customer_Name__r.High_risk_prohibited_sanctioned_countr__c, Customer_Name__r.HR_Prohibited_sanctioned_COR_for_UBOs_I__c,
                            Customer_Name__r.Estimated_Cash_Withdrawal_Frequency__c, Customer_Name__r.Est_Monthly_Num_of_Transactions_Outward__c, 
                            Customer_Name__r.Estimated_Cash_Deposit_frequency__c, Customer_Name__r.Company_anticipated_turnover__c,
                            Customer_Name__r.Nature_of_Employers_Your_Business__c, Customer_Name__r.Employment_Type__c, Customer_Name__r.Country_of_nationality__c, 
                            Customer_Name__r.Country_of_Residence__c,Customer_Name__r.What_is_your_total_net_worth__c, Customer_Name__r.Source_of_Wealth__c, 
                            Customer_Name__r.Pep__c, Relationship_Manager__c,Review_prepared_by__c,Customer_Name__r.Organisation_type__c, 
                            Customer_Name__r.Layers_of_Ownership__c, Customer_Name__r.Length_of_Establishment__c,Review_prepared_by__r.name, Relationship_Manager__r.name,
                            Customer_Name__r.Balance_Sheet_000s__c, Customer_Name__r.Sanctioned_Individual_Check__c, Customer_Name__r.Negative_News_Screening__c, 
                            Customer_Name__r.Previously_Exited_or_Declined__c, Customer_Name__r.Nature_of_Business_NPAA__c,Sanctions_Screening_match_Comments__c,
                            Customer_Name__r.Country_of_PEP_Exposure__c, Customer_Name__r.PEP_Associate__c,ID_V_validation_check_Comments__c,PEP_Screening_match_Comments__c,
                            Adverse_Media_match_Comments__c,Source_of_Funds_Comments__c,Change_since_last_review__c,Screened_Parties__c,PEP_Screening_Positive_Match_plus_match__c,
                            Relationship__c,Sanction_Screening_Positive_Match_plus__c,Adverse_Media_Screening_Positive_Match__c,Comments__c,Purpose__c,Location__c,IDV_Comments__c,
                            Onboarding_Case_Number__c,Date_of_Approval__c,Onboarding_Case_Number__r.CaseNumber,KYC_Analyst__c,KYC_Analyst__r.Name,KYC_Analyst__r.Id,MLRO_Name__r.Name,
                            Total_Assets__c,Total_Liabilities__c,Net_Worth__c,Overall_Company_Credit_Turnover__c,Contact_method_at_Onboarding__c,Method_of_most_recent_contact__c,
                            Risk_Rating__c,PEP_status__c,HR_Prohibited_sanctioned_COR_for_UBOs__c,Previously_Exited_or_Declined__c,HR_Prohibited_sanctioned_COR_for_Signif__c,Issued_date__c,Next_renewal_date__c,
                            Source_of_Wealth_Comments__c,Item_Count__c,Reference_Name__c,Is_Submitted_EDD__c,Entity_Type__c,Appendix_IDV_Location__c,
                                (Select Id,name,Customer__c,Customer__r.name, EBS_ID__c,EDD__c from Linked_Customers__r),
                                (Select Id,name from Account_Holders__r),(Select Id,name from Related_Customer_Entity_Relationships__r),
                                (Select Id,name,Customer__c,Customer__r.name, Customer__r.EBS_ID__c,EDD__c,Blocked__c,Nature_Purpose__c,Product__c,Customer_Account__c,Customer_Account__r.Primary_SFDC_Account__r.Name from Nature_and_Purpose__r)
                            from EDD_Form__c where EDD_Review_SF_Case_Number__c =: caseId LIMIT 1];
            if(!lstEDDs.isEmpty()){
                objEDD = lstEDDs[0];
            }else{
                objEDD = null;
            }
        }
        
        return objEDD;
    }

    @AuraEnabled
    public static Map<String, Object> getCustomerDetails(String caseRecordId) {
        Map<String, Object> resMap = new Map<String, Object>{RES_STATUS => SUCCESS};
        try{
            EDD_Form__c objEDD = getEDDRec('', caseRecordId);
            System.debug('objEDD : '+objEDD);
            String accountId;
            Customer customer;
            if(objEDD == null){
                oCase =    [Select Id, caseNumber, AccountId, Account.Name, Account.EBS_ID__c, Account.Risk_Rating__c, 
                            Account.Date_Converted_to_Customer__c, Account.Entity_Type__c, Account.Registered_number__c, 
                            Account.RegisteredAddressCity__c, Account.RegisteredAddressCountry__c, Account.RegisteredAddressPostCode__c, 
                            Account.RegisteredAddressStreet__c, Account.TradingAddressCity__c, Account.TradingAddressCountry__c, 
                            Account.TradingAddressStreet__c, Account.TradingPostCode__c, Account.Organisation_Domicile__c, 
                            Account.Face_to_face_Contact__c, Account.Source_of_Funds__c, Account.Source_of_Funds_Country__c, 
                            Account.International_Fund_Transfer_Frequency__c,Account.Estimated_Monthly_Volume_Inward__c, Account.International_Fund_Transfer_Source__c, 
                            Account.Est_Monthly_Num_of_Transactions_Inward__c, Account.Politically_Exposed_Company__c, Account.Estimated_Monthly_Volume_Outward__c,
                            Account.High_risk_prohibited_sanctioned_countr__c, Account.HR_Prohibited_sanctioned_COR_for_UBOs_I__c,
                            Account.Estimated_Cash_Withdrawal_Frequency__c, Account.Est_Monthly_Num_of_Transactions_Outward__c, 
                            Account.Estimated_Cash_Deposit_frequency__c, Account.Company_anticipated_turnover__c,
                            Account.Nature_of_Employers_Your_Business__c, Account.Employment_Type__c, Account.Country_of_nationality__c, 
                            Account.Country_of_Residence__c,Account.What_is_your_total_net_worth__c, Account.Source_of_Wealth__c, 
                            Account.Pep__c, Account.Organisation_type__c, Account.Layers_of_Ownership__c, Account.Length_of_Establishment__c, 
                            Account.Balance_Sheet_000s__c, Account.Sanctioned_Individual_Check__c, Account.Negative_News_Screening__c, 
                            Account.Previously_Exited_or_Declined__c, Account.Nature_of_Business_NPAA__c,
                            Account.Country_of_PEP_Exposure__c, Account.PEP_Associate__c 
                            from Case 
                            where Id =: caseRecordId];
                accountId = oCase.AccountId;
                customer =new Customer(oCase);
                resMap.put('customerDetails',customer );

                /*list<LinkedCustomers> allLinkedCustomers = new list<LinkedCustomers>();
                list<Account> lstAccs = [Select Id,name,EBS_ID__c from Account where EBS_ID__c != null Order by EBS_ID__c desc Limit 3];
                for(Account each : lstAccs){
                    LinkedCustomers objLinkedCustomer =new LinkedCustomers(each);
                    allLinkedCustomers.add(objLinkedCustomer);
                }
                    
                resMap.put('linkaccounts',allLinkedCustomers );*/
                
            }else{
                
                accountId = objEDD.Customer_Name__c;
                customer = new customer(objEDD, new customer());
                resMap.put('customerDetails',customer );
            }
            

            

            list<Account_with_IBB__c> lstcustAccs = [Select id,Primary_SFDC_Account__c,Primary_SFDC_Account__r.Name,Account_Blocked__c, IBB_Product_Name__c,EBS_ID__c
                                                            from Account_with_IBB__c 
                                                            where Account_Closed__c != 'Y' and Primary_SFDC_Account__c =: accountId];
            
            list<CustomerAccounts> allCustomerAccounts = new list<CustomerAccounts>();
            for(Account_with_IBB__c each : lstcustAccs){
                CustomerAccounts objLinkedCustomer = new CustomerAccounts(each);
                allCustomerAccounts.add(objLinkedCustomer);
            }
            
            resMap.put('customeraccounts', allCustomerAccounts );

            list<SOW> lstSOWs = new list<SOW>();
            set<String> allAssets = new set<String>{'Business Property', 'Own Home', 'Other Property', 'Cash / Savings', 'Stocks & Shares', 'Life policy values(surrender value only)', 'Personal Effects', 'Cars', 'Other'};
            set<String> allLiabilites = new set<String>{'Business Finance', 'Mortgage', 'Other Mortgage', 'Bank Finance', 'Other Finance', 'Overdraft', 'Hire Purchase', 'Credit Cards', 'Guarantees', 'Other'};
            for(String each : allAssets){
                SOW objSOW = new SOW();
                objSOW.type = 'Asset';
                objSOW.name = each;
                lstSOWs.add(objSOW);
            }
            for(String each : allLiabilites){
                SOW objSOW = new SOW();
                objSOW.type = 'Liability';
                objSOW.name = each;
                lstSOWs.add(objSOW);
            }

            resMap.put('sow', lstSOWs );
        }catch(Exception e){
            String errMsg = ERR_SHORT + 'getCustomerDetails . '+e;
            resMap.put(RES_STATUS, ERROR);
            resMap.put(RES_STATUS_MSG, errMsg);
            system.debug('errMsg : '+e);
        }
        return resMap;
    }


    public class Customer{
        @AuraEnabled public list<LinkedCustomers> linkaccounts = new list<LinkedCustomers>();
        @AuraEnabled public list<AccountHolders> accountHolders = new list<AccountHolders>();
        @AuraEnabled public list<RelatedCustomerEntity> relatedCustomerEntities = new list<RelatedCustomerEntity>();
        @AuraEnabled public list<CustomerAccounts> customeraccounts = new list<CustomerAccounts>();
        //General Information attributes
        @AuraEnabled public String eddId{get;set;}
        @AuraEnabled public Boolean saveasdraft{get;set;}
        @AuraEnabled public String customerName{get;set;}
        @AuraEnabled public String accountId{get;set;}
        @AuraEnabled public String caseId{get;set;}
        @AuraEnabled public String reviewType{get;set;}
        @AuraEnabled public String ebsId{get;set;}
        @AuraEnabled public String riskRating{get;set;}
        @AuraEnabled public String relationshipManager{get;set;}
        @AuraEnabled public lookupwrapper relationshipManagerWrap = new lookupwrapper();
        @AuraEnabled public casenolookupWrapper onboardingCasenoWrap = new casenolookupWrapper();
        @AuraEnabled public kycAnalystlookupWrapper kycAnalystWrap = new kycAnalystlookupWrapper();
        @AuraEnabled public mlrolookupWrapper mlroWrap = new mlrolookupWrapper();
        
        
        @AuraEnabled public String onboardingcaseno {get;set;}
        @AuraEnabled public String kycAnalyst {get;set;}
        @AuraEnabled public String mlroName {get;set;}
        
        @AuraEnabled public String reviewPreparedBy{get;set;}
        @AuraEnabled public lookupwrapper reviewPreparedByWrap = new lookupwrapper();
        @AuraEnabled public String department{get;set;}
        @AuraEnabled public Date customerConvertedDate{get;set;}
        @AuraEnabled public String dateOfSubmission{get;set;}
        @AuraEnabled public String eddReviewCaseNo{get;set;}

        //Part1 : CUSTOMER AND ACCOUNT INFORMATION attributes
        @AuraEnabled public String entityType{get;set;}
        @AuraEnabled public String registeredAddress{get;set;}
        @AuraEnabled public String tradingAddress{get;set;}
        @AuraEnabled public String registrationNumber{get;set;}
        @AuraEnabled public String countryOfIncorporation {get;set;}
        @AuraEnabled public String contactMethod{get;set;}
        @AuraEnabled public String contactLastMade{get;set;}
        @AuraEnabled public String methodMostRecentContact {get;set;}
        @AuraEnabled public String naturePurposeOfTheAccount{get;set;}
        @AuraEnabled public String sourceOfFunds{get;set;}
        @AuraEnabled public String sourceOfFundsCountry{get;set;}
        @AuraEnabled public String internationalFundTransferFrequency{get;set;}
        @AuraEnabled public String intFundTransferSource{get;set;}
        @AuraEnabled public String estMonthlyVolumeInward{get;set;}
        @AuraEnabled public String estMonthlyVolumeOutward{get;set;}
        @AuraEnabled public String estCashWithdrawalFrequency{get;set;}
        @AuraEnabled public String estMnthNumofTranInward{get;set;}
        @AuraEnabled public String estMnthNumofTranOutward{get;set;}
        @AuraEnabled public String estCashDeprequency{get;set;}
        @AuraEnabled public Decimal overallCompCreditTurnover{get;set;}
        @AuraEnabled public Decimal expAnnualTurnover{get;set;}

        //Part4 : 
        @AuraEnabled public String politicallyExposedCompany {get;set;}
        @AuraEnabled public String hrProhibitedsanctionedCORforSignif{get;set;}
        @AuraEnabled public String hrProhibitedsanctionedCORforUBOsI{get;set;}
        @AuraEnabled public String empType{get;set;}
        @AuraEnabled public String countryOfNationality{get;set;}
        @AuraEnabled public String countryOfResidence{get;set;}
        @AuraEnabled public String totelNetWorth{get;set;}
        @AuraEnabled public String sourceOfWealth{get;set;}
        @AuraEnabled public Boolean pep{get;set;}
        @AuraEnabled public String countryOfPEP{get;set;}
        @AuraEnabled public String pepAssociate{get;set;}
        @AuraEnabled public String noe{get;set;}
        @AuraEnabled public String orgType{get;set;}
        @AuraEnabled public String layersOfOwner{get;set;}
        @AuraEnabled public String lengthOfEst{get;set;}
        @AuraEnabled public String balanceSheet{get;set;}
        @AuraEnabled public String sancIndCheck{get;set;}
        @AuraEnabled public String negNewsScreen{get;set;}
        @AuraEnabled public String preDecExited{get;set;}
        @AuraEnabled public String natureOfBusiNPAA{get;set;}

        @AuraEnabled public String abtCustomer 	    {get;set;}		
        @AuraEnabled public String corporatestructure 	{get;set;}	
        @AuraEnabled public String rrcorporatestructure {get;set;}	
        @AuraEnabled public String spvtrust 			{get;set;}	
        @AuraEnabled public String reasonEntityType 	{get;set;}	
        @AuraEnabled public String structurecomplex 		{get;set;}
        @AuraEnabled public String IDVsatisfied 		{get;set;}	
        @AuraEnabled public String EDDsupportinginformation{get;set;}
        @AuraEnabled public String rationalePepStatus 		{get;set;}
        //@AuraEnabled public Date datecheckscompleted 	{get;set;}
        @AuraEnabled public Date datecheckscompletedApproval 	{get;set;}

        @AuraEnabled public String IDVvalidationcheck 		{get;set;}
        @AuraEnabled public Date kycselectedDate 		{get;set;}
        
        @AuraEnabled public String AdversMediaMatchComments {get;set;}
        @AuraEnabled public String adversemediamatch  {get;set;}
        @AuraEnabled public String IDVValidationComments 		{get;set;}
        @AuraEnabled public String SourceofComments 		{get;set;}
        @AuraEnabled public String sofChangesince 		{get;set;}
        @AuraEnabled public String pepScreeningmatch 		{get;set;}        
        @AuraEnabled public String sanctionsscreeningmatch {get;set;}
        @AuraEnabled public String AdverseMediaScreeningPositiveMatchplusmatchtype {get;set;}
        @AuraEnabled public String SourceofWealthComments {get;set;}
        @AuraEnabled public Decimal itemCount {get;set;}
        @AuraEnabled public String jsonReferenceName {get;set;}
        @AuraEnabled public Boolean isSubmittedEDD {get;set;}

        
        

       // @AuraEnabled public String adversemediamatch 		{get;set;}
        @AuraEnabled public String KYCRecommendation 		{get;set;}
        @AuraEnabled public String RMRecommendation 		{get;set;}
        @AuraEnabled public String MLROCRAOverride 		{get;set;}
        @AuraEnabled public String RationaleforMLROCRAOverride {get;set;}
        
        @AuraEnabled public String MLRORecommendation 		{get;set;}
        @AuraEnabled public String AMLOCRecommendation 	{get;set;}
        @AuraEnabled public Date AMLOCdateofApproval 	{get;set;}
        @AuraEnabled public Date IssuedDate 	{get;set;}
        @AuraEnabled public Date NextRenewalDate 	{get;set;}        
        @AuraEnabled public Date MLROdateofApproval 		{get;set;}
        @AuraEnabled public String RMRecomComments 		{get;set;}
        @AuraEnabled public String RMName 				{get;set;}	
        @AuraEnabled public Date RMdateofApproval 	{get;set;}	
        @AuraEnabled public String KycAnalystComments 	{get;set;}	
        @AuraEnabled public String MLRORecomComments    {get;set;}
        @AuraEnabled public String AMLOCRecomComments   {get;set;}
       // @AuraEnabled public String MLROName             {get;set;}
        @AuraEnabled public String PepComments         {get;set;}
        @AuraEnabled public String SanctionsScreeningComments {get;set;}
        @AuraEnabled public String ScreenedParties {get;set;}
        @AuraEnabled public String PEPScreeningPositiveMatch {get;set;}
        @AuraEnabled public String ScreenedRelationship {get;set;}
        @AuraEnabled public String SanctionScreeningPositiveMatch {get;set;}
        @AuraEnabled public String ScreenedPartiesComments {get;set;}
        @AuraEnabled public String IDVPurpose {get;set;}
        @AuraEnabled public String IDVLocation {get;set;}
        @AuraEnabled public String IDVPartiesComments {get;set;}
        @AuraEnabled public Decimal totalAssets {get;set;}
        @AuraEnabled public Decimal totalLibs {get;set;}
        @AuraEnabled public Decimal netWorth {get;set;}
        @AuraEnabled public String AppendixIDVLocation {get;set;}
        
        
        
        
        
        
        
        
        
        
        
        
    
        public Customer(){}

        // accepts case and returns Customer Details
        public Customer(Case recCase){
            this.saveasdraft = true;
            this.caseId = recCase.Id;
            this.customerName = recCase.Account.Name;
            this.accountId = recCase.AccountId;
            this.reviewType = '';
            this.ebsId = recCase.Account.EBS_ID__c;
            this.riskRating = recCase.Account.Risk_Rating__c;
            this.relationshipManager = '';
            this.reviewPreparedBy = '';
            this.onboardingcaseno = '';
            this.kycAnalyst = '';
            this.mlroName = '';
            this.department = '';
            this.customerConvertedDate = recCase.Account.Date_Converted_to_Customer__c;
            this.dateOfSubmission = '';
            this.eddReviewCaseNo = recCase.caseNumber;
            this.entityType = recCase.Account.Entity_Type__c;
            this.registrationNumber = recCase.Account.Registered_number__c;
            this.registeredAddress = recCase.Account.RegisteredAddressStreet__c +', '+recCase.Account.RegisteredAddressCity__c+', '+recCase.Account.RegisteredAddressCountry__c+', '+recCase.Account.RegisteredAddressPostCode__c;
            this.tradingAddress = recCase.Account.TradingAddressStreet__c+', '+recCase.Account.TradingAddressCity__c+', '+recCase.Account.TradingAddressCountry__c+', '+recCase.Account.TradingPostCode__c;
            this.countryOfIncorporation = recCase.Account.Organisation_Domicile__c;
            this.contactMethod = recCase.Account.Face_to_face_Contact__c;
            this.contactLastMade = '';
            this.methodMostRecentContact  = '';
            this.naturePurposeOfTheAccount = '';
            this.sourceOfFunds = recCase.Account.Source_of_Funds__c;
            this.sourceOfFundsCountry = recCase.Account.Source_of_Funds_Country__c;
            this.internationalFundTransferFrequency = recCase.Account.International_Fund_Transfer_Frequency__c;
            this.intFundTransferSource = recCase.Account.International_Fund_Transfer_Source__c;
            this.estMonthlyVolumeInward = recCase.Account.Est_Monthly_Num_of_Transactions_Inward__c;
            this.estMonthlyVolumeOutward = recCase.Account.Est_Monthly_Num_of_Transactions_Outward__c;
            this.estCashWithdrawalFrequency = recCase.Account.Estimated_Cash_Withdrawal_Frequency__c;
            this.estCashDeprequency = recCase.Account.Estimated_Cash_Deposit_frequency__c;
            this.overallCompCreditTurnover = recCase.Account.Company_anticipated_turnover__c;
            this.expAnnualTurnover = 0;
            this.politicallyExposedCompany = recCase.Account.Politically_Exposed_Company__c;
            this.hrProhibitedsanctionedCORforSignif = recCase.Account.High_risk_prohibited_sanctioned_countr__c;
            this.hrProhibitedsanctionedCORforUBOsI = recCase.Account.HR_Prohibited_sanctioned_COR_for_UBOs_I__c;
            this.noe = recCase.Account.Nature_of_Employers_Your_Business__c;
            this.empType = recCase.Account.Employment_Type__c;
            this.countryOfNationality = recCase.Account.Country_of_nationality__c;
            this.countryOfResidence = recCase.Account.Country_of_Residence__c;
            this.totelNetWorth = recCase.Account.What_is_your_total_net_worth__c;
            this.sourceOfWealth = recCase.Account.Source_of_Wealth__c;
            this.pep = recCase.Account.Pep__c;
            this.countryOfPEP = recCase.Account.Country_of_PEP_Exposure__c;
            this.pepAssociate = recCase.Account.PEP_Associate__c;
            this.orgType = recCase.Account.Organisation_type__c;
            this.layersOfOwner = recCase.Account.Layers_of_Ownership__c;
            this.lengthOfEst = recCase.Account.Length_of_Establishment__c;
            this.balanceSheet = recCase.Account.Balance_Sheet_000s__c;
            this.sancIndCheck = recCase.Account.Sanctioned_Individual_Check__c;
            this.negNewsScreen = recCase.Account.Negative_News_Screening__c;
            this.preDecExited = recCase.Account.Previously_Exited_or_Declined__c;
            this.natureOfBusiNPAA = recCase.Account.Nature_of_Business_NPAA__c;
            

        }

        public Customer(EDD_Form__c recEDD, Customer cusObj){
			this.eddId = recEDD.Id;
            this.caseId = recEDD.EDD_Review_SF_Case_Number__c;
            this.customerName = recEDD.Customer_Name__r.Name;
            this.accountId = recEDD.Customer_Name__c;
            this.reviewType = recEDD.Review_Type__c;
            this.ebsId = recEDD.Customer_Name__r.EBS_ID__c;
            this.riskRating = recEDD.Customer_Name__r.Risk_Rating__c;
            this.relationshipManager = recEDD.Relationship_Manager__c;
            if(recEDD.Relationship_Manager__c != null){
                this.relationshipManagerWrap.Id = recEDD.Relationship_Manager__c;
                this.relationshipManagerWrap.Name = recEDD.Relationship_Manager__r.name;
            }
            if(recEDD.Review_prepared_by__c != null){
                //lookupWrapper obj= new lookupWrapper(Id= recEDD.Review_prepared_by__c, Name = recEDD.Review_prepared_by__r.Name);
                this.reviewPreparedByWrap = new lookupWrapper(recEDD);
            }

            if(recEDD.Onboarding_Case_Number__c != null){
                //lookupWrapper obj= new lookupWrapper(Id= recEDD.Review_prepared_by__c, Name = recEDD.Review_prepared_by__r.Name);
                this.onboardingCasenoWrap = new casenolookupWrapper(recEDD);
            }
             if(recEDD.KYC_Analyst__c != null){
                //lookupWrapper obj= new lookupWrapper(Id= recEDD.Review_prepared_by__c, Name = recEDD.Review_prepared_by__r.Name);
                this.kycAnalystWrap = new kycAnalystlookupWrapper(recEDD);
            }
            if(recEDD.MLRO_Name__c != null){
                //lookupWrapper obj= new lookupWrapper(Id= recEDD.Review_prepared_by__c, Name = recEDD.Review_prepared_by__r.Name);
                this.mlroWrap = new mlrolookupWrapper(recEDD);
            }

                
            this.reviewPreparedBy = recEDD.Review_prepared_by__c;
            this.onboardingcaseno = recEDD.Onboarding_Case_Number__c;
            this.kycAnalyst = recEDD.KYC_Analyst__c;
            this.mlroName = recEDD.MLRO_Name__c;
            this.department = '';
            this.customerConvertedDate = recEDD.Customer_Name__r.Date_Converted_to_Customer__c;
            this.dateOfSubmission = '';
            this.eddReviewCaseNo = recEDD.EDD_Review_SF_Case_Number__r.caseNumber;
            this.entityType = recEDD.Customer_Name__r.Entity_Type__c;
            this.registrationNumber = recEDD.Customer_Name__r.Registered_number__c;
            this.registeredAddress = recEDD.Customer_Name__r.RegisteredAddressStreet__c +', '+recEDD.Customer_Name__r.RegisteredAddressCity__c+', '+recEDD.Customer_Name__r.RegisteredAddressCountry__c+', '+recEDD.Customer_Name__r.RegisteredAddressPostCode__c;
            this.tradingAddress = recEDD.Customer_Name__r.TradingAddressStreet__c+', '+recEDD.Customer_Name__r.TradingAddressCity__c+', '+recEDD.Customer_Name__r.TradingAddressCountry__c+', '+recEDD.Customer_Name__r.TradingPostCode__c;
            this.countryOfIncorporation = recEDD.Customer_Name__r.Organisation_Domicile__c;
            this.contactMethod = recEDD.Customer_Name__r.Face_to_face_Contact__c;
            this.contactLastMade = '';
            this.methodMostRecentContact  = '';
            this.naturePurposeOfTheAccount = '';
            this.sourceOfFunds = recEDD.Customer_Name__r.Source_of_Funds__c;
            this.sourceOfFundsCountry = recEDD.Customer_Name__r.Source_of_Funds_Country__c;
            this.internationalFundTransferFrequency = recEDD.Customer_Name__r.International_Fund_Transfer_Frequency__c;
            this.intFundTransferSource = recEDD.Customer_Name__r.International_Fund_Transfer_Source__c;
            this.estMonthlyVolumeInward = recEDD.Customer_Name__r.Est_Monthly_Num_of_Transactions_Inward__c;
            this.estMonthlyVolumeOutward = recEDD.Customer_Name__r.Est_Monthly_Num_of_Transactions_Outward__c;
            this.estCashWithdrawalFrequency = recEDD.Customer_Name__r.Estimated_Cash_Withdrawal_Frequency__c;
            this.estCashDeprequency = recEDD.Customer_Name__r.Estimated_Cash_Deposit_frequency__c;
            this.overallCompCreditTurnover = recEDD.Customer_Name__r.Company_anticipated_turnover__c;
            this.expAnnualTurnover = recEDD.Expected_Annual_Turnover__c;
            this.politicallyExposedCompany = recEDD.Customer_Name__r.Politically_Exposed_Company__c;
            this.hrProhibitedsanctionedCORforSignif = recEDD.Customer_Name__r.High_risk_prohibited_sanctioned_countr__c;
            this.hrProhibitedsanctionedCORforUBOsI = recEDD.Customer_Name__r.HR_Prohibited_sanctioned_COR_for_UBOs_I__c;
            this.noe = recEDD.Customer_Name__r.Nature_of_Employers_Your_Business__c;
            this.empType = recEDD.Customer_Name__r.Employment_Type__c;
            this.countryOfNationality = recEDD.Customer_Name__r.Country_of_nationality__c;
            this.countryOfResidence = recEDD.Customer_Name__r.Country_of_Residence__c;
            this.totelNetWorth = recEDD.Customer_Name__r.What_is_your_total_net_worth__c;
            this.sourceOfWealth = recEDD.Customer_Name__r.Source_of_Wealth__c;
            this.pep = recEDD.Customer_Name__r.Pep__c;
            this.countryOfPEP = recEDD.Customer_Name__r.Country_of_PEP_Exposure__c;
            this.pepAssociate = recEDD.Customer_Name__r.PEP_Associate__c;
            this.orgType = recEDD.Customer_Name__r.Organisation_type__c;
            this.layersOfOwner = recEDD.Customer_Name__r.Layers_of_Ownership__c;
            this.lengthOfEst = recEDD.Customer_Name__r.Length_of_Establishment__c;
            this.balanceSheet = recEDD.Customer_Name__r.Balance_Sheet_000s__c;
            this.sancIndCheck = recEDD.Customer_Name__r.Sanctioned_Individual_Check__c;
            this.negNewsScreen = recEDD.Customer_Name__r.Negative_News_Screening__c;
            this.preDecExited = recEDD.Customer_Name__r.Previously_Exited_or_Declined__c;
            this.natureOfBusiNPAA = recEDD.Customer_Name__r.Nature_of_Business_NPAA__c;
            this.abtCustomer 			= recEDD.Summary_of_the_Customer__c;						
            this.corporatestructure 	= recEDD.Confirmation_that_a_corporate_structure__c;		
            this.rrcorporatestructure 	= recEDD.Is_there_reasonable_rationale_structure__c;		
            this.spvtrust 				= recEDD.Does_it_involve_SPVs_trusts_etc__c;				
            this.reasonEntityType 		= recEDD.If_yes_please_state_entity_type_reason__c;			
            this.structurecomplex 		= recEDD.Is_the_structure_complex_opaque__c;				
            this.IDVsatisfied 			= recEDD.ID_V_satisfied__c;									
            this.EDDsupportinginformation 	= recEDD.Supporting_information__c;						
            this.rationalePepStatus 	= recEDD.Rationale_for_PEP_Status__c;						
            //this.datecheckscompleted 	= recEDD.Date_checks_completed__c;	
            this.datecheckscompletedApproval = recEDD.Date_of_Approval__c;						
            this.IDVvalidationcheck 	= recEDD.ID_V_validation_check__c;
            this.kycselectedDate = recEDD.Date_checks_completed__c;
            this.AdversMediaMatchComments = recEDD.Adverse_Media_match_Comments__c;
            
            this.adversemediamatch = recEDD.Adverse_Media_match__c;
            this.IDVValidationComments  = recEDD.ID_V_validation_check_Comments__c;
            this.SourceofComments = recEDD.Source_of_Funds_Comments__c;
            this.sofChangesince = recEDD.Change_since_last_review__c;
            this.PepComments            = recEDD.PEP_Screening_match_Comments__c;		
            this.SanctionsScreeningComments = recEDD.Sanctions_Screening_match_Comments__c;				
            this.pepScreeningmatch 			= recEDD.PEP_Screening_match__c;						
            this.sanctionsscreeningmatch 	= recEDD.Sanctions_Screening_match__c;
            this.AdverseMediaScreeningPositiveMatchplusmatchtype = recEDD.Adverse_Media_Screening_Positive_Match__c;
           // this.adversemediamatch 		= recEDD.Adverse_Media_match__c;							
            this.KYCRecommendation 		= recEDD.KYC_Analyst_Recommendation__c;						
            this.RMRecommendation 		= recEDD.RM_Recommendation__c;								
            this.MLROCRAOverride 		= recEDD.MLRO_CRA_Override__c;		
            this.RationaleforMLROCRAOverride = recEDD.Rationale_for_MLRO_CRA_Override__c;					
            this.MLRORecommendation 	= recEDD.MLRO_Recommendation__c;	
            this.MLRORecomComments		= recEDD.MLRO_Recommendation_Comments__c;		
            this.AMLOCRecomComments		= recEDD.AMLOC_Recommendation_Comments__c;					
            this.AMLOCRecommendation 	= recEDD.AMLOC_Recommendation__c	;						
            this.AMLOCdateofApproval 	= recEDD.AMLOC_Date_of_Approval__c;							
            this.MLROdateofApproval 	= recEDD.MLRO_Date_of_Approval__c;		
            this.IssuedDate             = recEDD.Issued_date__c;		
            this.NextRenewalDate        = recEDD.Next_renewal_date__c;			
            this.RMRecomComments 		= recEDD.RM_Recommendation_Comments__c;
            //this.RMName 				= recEDD.Relationship_Manager__c;	
           // this.MLROName				= recEDD.MLRO_Name__c;										
            this.RMdateofApproval 		= recEDD.RM_Date_of_Approval__c;							
            this.KycAnalystComments 	= recEDD.KYC_Analyst_Recommendation_Comments__c;
            this.ScreenedParties        = recEDD.Screened_Parties__c;	
            this.PEPScreeningPositiveMatch = recEDD.PEP_Screening_Positive_Match_plus_match__c;
            this.ScreenedRelationship = recEDD.Relationship__c;
            this.SanctionScreeningPositiveMatch =recEDD.Sanction_Screening_Positive_Match_plus__c;
            this.ScreenedPartiesComments = recEDD.Comments__c;
            this.IDVPurpose = recEDD.Purpose__c;
            this.IDVLocation = recEDD.Location__c;
            this.IDVPartiesComments = recEDD.IDV_Comments__c;
            this.totalAssets = recEDD.Total_Assets__c;
            this.totalLibs = recEDD.Total_Liabilities__c;
            this.netWorth = recEDD.Net_Worth__c;
            this.SourceofWealthComments = recEDD.Source_of_Wealth_Comments__c;
            this.itemCount = recEDD.Item_Count__c;
            this.jsonReferenceName = recEDD.Reference_Name__c;
            this.isSubmittedEDD = recEDD.Is_Submitted_EDD__c;
            this.AppendixIDVLocation = recEDD.Appendix_IDV_Location__c;

            list<LinkedCustomers> allLinkedCustomers = new list<LinkedCustomers>();
            for(Linked_Customers__c each : recEDD.Linked_Customers__r){
                LinkedCustomers objLinkedCustomer =new LinkedCustomers(each);
                allLinkedCustomers.add(objLinkedCustomer);
            }
            this.linkaccounts.AddAll(allLinkedCustomers);	

            list<CustomerAccounts> allCustomerAccounts = new list<CustomerAccounts>();
            for(Nature_and_Purpose__c each : recEDD.Nature_and_Purpose__r){
                CustomerAccounts objCustomerAccount =new CustomerAccounts(each);
                allCustomerAccounts.add(objCustomerAccount);
            }
            this.customeraccounts.AddAll(allCustomerAccounts);

            list<AccountHolders> allAccountHolders = new list<AccountHolders>();
            for(Asset_Relationship__c each : recEDD.Account_Holders__r){
                AccountHolders objAccountHolder =new AccountHolders(each);
                allAccountHolders.add(objAccountHolder);
            }
            this.accountHolders.AddAll(allAccountHolders);	
            
            list<RelatedCustomerEntity> allRelatedCustomerEntity = new list<RelatedCustomerEntity>();
            for(Related_Customer_Entity_Relationship__c each : recEDD.Related_Customer_Entity_Relationships__r){
                RelatedCustomerEntity objallRelatedCustomerEntity =new RelatedCustomerEntity(each);
                allRelatedCustomerEntity.add(objallRelatedCustomerEntity);
            }
            this.relatedCustomerEntities.AddAll(allRelatedCustomerEntity);
        }
    }
      
    public class AccountHolders{
        @AuraEnabled public String accountHolderName {get;set;}
        public AccountHolders(Asset_Relationship__c acc){
            this.accountHolderName = acc.name;
        }

    }

    public class RelatedCustomerEntity{
        @AuraEnabled public String relatedCustomerEntities {get;set;}
        
        public RelatedCustomerEntity(Related_Customer_Entity_Relationship__c acc){
            this.relatedCustomerEntities = acc.name;
        }

    }

    public class LinkedCustomers{
        @AuraEnabled public String caccName {get;set;}
        @AuraEnabled public String caccebsid {get;set;}
        @AuraEnabled public String caccNameebs {get;set;}
        @AuraEnabled public String caccId {get;set;}
        @AuraEnabled public String id {get;set;}

        public LinkedCustomers(account acc){
            this.caccName     =   acc.name;
            this.caccNameebs  =   acc.name +' - '+acc.EBS_ID__c;
            this.caccId       =   acc.id;
            this.caccebsid    =   acc.EBS_ID__c;
        }
        public LinkedCustomers(Linked_Customers__c acc){
            this.caccName     =   acc.Customer__r.name;
            this.caccNameebs  =   this.caccName +' - '+acc.EBS_ID__c;
            this.caccId       =   acc.Customer__c;
            this.caccebsid    =   acc.EBS_ID__c;
            this.id           =   acc.Id;
        }
    }

    public class CustomerAccounts{
        @AuraEnabled public String caccName {get;set;}
        @AuraEnabled public String caccNameebs {get;set;}
        @AuraEnabled public String caccebsid {get;set;}
        @AuraEnabled public String caccId {get;set;}
        @AuraEnabled public String id {get;set;}
        @AuraEnabled public String caccIsBlocked {get;set;}
        @AuraEnabled public String caccProduct {get;set;}
        //@AuraEnabled public list<String> caccNPAccount =new list<String>();
        
        public CustomerAccounts(Account_with_IBB__c acc){
            this.caccName     =   acc.Primary_SFDC_Account__r.name;
            this.caccId       =   acc.id;
            this.caccebsid    =   acc.EBS_ID__c;
            if(acc.Account_Blocked__c == 'Y'){
                this.caccIsBlocked= 'YES';
            }else{
                this.caccIsBlocked= 'NO';
            }
            this.caccProduct  =   acc.IBB_Product_Name__c;
        }
        public CustomerAccounts(Nature_and_Purpose__c acc){
            this.caccName     =   acc.Customer_Account__r.Primary_SFDC_Account__r.Name;
            this.caccId       =   acc.Customer_Account__c;
            this.id           =   acc.id;
            this.caccebsid    =   acc.Customer__r.EBS_ID__c;
            if(acc.Blocked__c == 'Yes'){
                this.caccIsBlocked= 'YES';
            }else{
                this.caccIsBlocked= 'NO';
            }
            this.caccProduct  =   acc.Product__c;
        }
    }

    public class SOW{
        @AuraEnabled public String type {get;set;}
        @AuraEnabled public String name {get;set;}
        @AuraEnabled public String changelastreview {get;set;}
        @AuraEnabled public String comment {get;set;}
        @AuraEnabled public decimal amount {get;set;}
    }

    public class SOF{
        @AuraEnabled public String sourceOfFunds {get;set;}
        @AuraEnabled public String changelastreview {get;set;}
        @AuraEnabled public String comment {get;set;}
    }

    public class lookupWrapper{
        @AuraEnabled public String Id {get;set;}
        @AuraEnabled public String Name {get;set;}

        public lookupWrapper(){}
        public lookupWrapper(EDD_Form__c recEDD){
            this.Id = recEDD.Review_prepared_by__c;
            this.Name = recEDD.Review_prepared_by__r.name;
        }
    }

    public class casenolookupWrapper{
        @AuraEnabled public String Id {get;set;}
        @AuraEnabled public String Name {get;set;}

        public casenolookupWrapper(){}
        public casenolookupWrapper(EDD_Form__c recEDD){
            this.Id = recEDD.Onboarding_Case_Number__c;
            this.Name = recEDD.Onboarding_Case_Number__r.CaseNumber;
        }
    }

     public class kycAnalystlookupWrapper{
        @AuraEnabled public String Id {get;set;}
        @AuraEnabled public String Name {get;set;}

        public kycAnalystlookupWrapper(){}
        public kycAnalystlookupWrapper(EDD_Form__c recEDD){
            this.Id = recEDD.KYC_Analyst__c;
            this.Name = recEDD.KYC_Analyst__r.Name;
        }
    }

     public class mlrolookupWrapper{
        @AuraEnabled public String Id {get;set;}
        @AuraEnabled public String Name {get;set;}

        public mlrolookupWrapper(){}
        public mlrolookupWrapper(EDD_Form__c recEDD){
            this.Id = recEDD.MLRO_Name__c;
            this.Name = recEDD.MLRO_Name__r.Name;
        }
    }
    

    
}