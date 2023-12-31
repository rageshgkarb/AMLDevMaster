public class CAA_DE
{
    public static final String DE_SUCCESS = 'SUCCESS';
    public static final String DE_ERROR= 'SYSTEMERROR';
    public static final String DE_DECLINE= 'DECLINE';
    public static final String TN_REFERRED ='REFERRED';
    public static final String TN_AWAITING_RESPONSE = 'AWAITING_RESPONSE';

    public static CAA_Data.DEResponse CallDE(ID eventLogId){
        Actions.ActionCAADecisionEngine de = new Actions.ActionCAADecisionEngine();
        //opp id
        String oppId = CAA_Helper.GetOppId(string.valueof(eventLogId));
        //update opp with correct stage
        Opportunity opp = [select CAA_Decision__c, Status_HPP_CAA__c,US_Person_Signed_App_Form_Received__c,RecordTypeId, Name  from opportunity where id=:CAA_Helper.GetOppId(eventLogId)];
        
        CAA_Data.DEResponse response = new CAA_Data.DEResponse();
        IBBEvents.CompleteEventArgs result;
        System.debug ('opp.RecordTypeId' + opp.RecordTypeId);
        //if(string.IsBlank(opp.CAA_Decision__c ) || opp.CAA_Decision__c.equalsIgnoreCase(DE_ERROR)){
            if ( opp.RecordTypeId == ARBAPIConstantValues.CAA_RECORD_TYPE ) {
                /*&& !opp.Name.startswith ( ARBAPIConstantValues.CAA_ANC_STRING) 
                    && !opp.Name.startswith (ARBAPIConstantValues.CAA_ELIGIBILITY)*/ 
                
                Set < Id > accountIdSet = new Set < Id > ();
                List < Applicant__c > applicantList = [Select Id,
                            Opportunity__c, 
                            Prospect_Customer__c, 
                            Applicant_Number__c ,
                            Prospect_Customer__r.PersonContactId
                      from Applicant__c
                      where Applicant__c.Opportunity__c = :opp.Id];
                if (applicantList.size () > 1){
                    for (Applicant__c applicant : applicantList){
                        accountIdSet.Add(applicant.Prospect_customer__c);
                    }
                    result = ARBCustomerAMLAPIUtils.invokeCustomerAMLAPI ( accountIdSet, ''+opp.Id );
                } else  if (applicantList.size () <= 1){
                    result = ARBCustomerAMLAPIUtils.invokeCustomerAMLAPI ( oppId );
                }
                
                String url = CAA_Helper.CompleteEvent(eventlogId);
                if ( result.DEResponse.Decision.equalsIgnoreCase(DE_SUCCESS)) {
                    response.url = url;
                    response.Success = true;
                    update opp;
                }         
                if(result.DEResponse.Decision.equalsIgnoreCase(DE_ERROR)){
                    system.debug(result);
                    response.success = false;
                    response.error = 'some system error, this is a test description';
                    
                    if(!CAA_Helper.IsGuestUser()){
                        List<DecisionEngineResponse.Reason> Reasons = result.DEResponse.DecisionReasons;            
                        response.Reasons = Reasons;
                    }
                    update opp;
                }    
                else if(result.DEResponse.Decision.equalsIgnoreCase(DE_DECLINE)){
                    //LB - new code
                    url = CAA_Helper.CompleteEvent(eventlogId);       
                    response.Success = true;   
                    response.url = url;
                    
                    Opp.Status_HPP_CAA__c= 'Account Declined';  
                    update opp;      
                }
                else if ( result.DEResponse.Decision.equalsIgnoreCase( TN_REFERRED ) ||
                            result.DEResponse.Decision.equalsIgnoreCase( TN_AWAITING_RESPONSE )) {
                    response.Decision = 'SUCCESS';
                    url = CAA_Helper.CompleteEvent(eventlogId);       
                    response.Success = true;   
                    response.url = url;
                }
                return response;
            }
            else {
                if(string.IsBlank(opp.CAA_Decision__c ) || opp.CAA_Decision__c.equalsIgnoreCase(DE_ERROR))
                {
                    result = de.RunAction(oppId);            
                    
                    try
                    {
                        //If refer, then if only 1 reason and it's a refer nomatch, treat as success
                        if(result.DEResponse.Decision.equalsIgnoreCase('REFER'))
                        {
                            if(result.DEResponse.DecisionReasons != null)
                            {
                                
                            
                                if(result.DEResponse.DecisionReasons.size() > 0)
                                {
                                    boolean reasonOtherThanNoMatch = false;                    
                                    
                                    
                                    for(DecisionEngineResponse.Reason r : result.DEResponse.DecisionReasons)
                                    {
                                        if(!r.ReasonCode.equalsIgnoreCase('REFER-NOMATCH'))
                                        {
                                            reasonOtherThanNoMatch = true;
                                            break;
                                        }
                                    }
                                
                                    if(!reasonOtherThanNoMatch)
                                        result.DEResponse.Decision = 'SUCCESS';                        
                                }
                            }
                        }
        
                // C0695 Spoof DE response if product requires a signature from a US Person.
                // Remove this spoof if test moves to DE
                if(CAA_Helper.isUSPersonSignatureRequired(opp))
                {
                  if(result.DEResponse.Decision.equalsIgnoreCase('SUCCESS'))
                  {
                    result.DEResponse.Decision='REFER-USPERSON';
                  }
                  result.DEResponse.DecisionReasons.add(new DecisionEngineResponse.Reason(0,new Applicant__c(),'REFER','REFER-USPERSON','Signed application form required before continuing'));
                }
                    }
                    catch(Exception ex)
                    {
                        system.debug('EXCEPTION:' + ex.getMessage());
                    }
                    
                   
                    //if(IsNoMAtch(result)) result.DEResponse.Decision = DE_ERROR;
           
                    response.Decision = result.DEResponse.Decision;
                } 
                else
                {
                    response.Decision = opp.CAA_Decision__c;
                }        
                
                if(response.Decision.equalsIgnoreCase(DE_SUCCESS))
                    CloseOpenSystemErrorCases(opp.id);
                opp.CAA_Decision__c = response.Decision;
                        
                if(response.Decision.equalsIgnoreCase(DE_ERROR))
                {
                    system.debug(result);
                    response.success = false;
                    response.error = 'some system error, this is a test description';
                    
                    if(!CAA_Helper.IsGuestUser())
                    {
                        List<DecisionEngineResponse.Reason> Reasons = result.DEResponse.DecisionReasons;            
                        response.Reasons = Reasons;
                    }
                    update opp;
                }    
                else if(response.Decision.equalsIgnoreCase(DE_DECLINE))
                {
                    //LB - new code
                    String url = CAA_Helper.CompleteEvent(eventlogId);       
                    response.Success = true;   
                    response.url = url;
                    
                    Opp.Status_HPP_CAA__c= 'Account Declined';  
                    update opp;      
                }        
                else
                { 
                    //complete the event
                    String url = CAA_Helper.CompleteEvent(eventlogId);       
                    response.Success = true;   
                    
                    //allow external users to see next event
                    //if(!CAA_Helper.IsGuestUser())
                        response.url = url;
                    
                    system.debug('RES:' + response.Decision);
                    if(!response.Decision.equalsIgnoreCase(DE_SUCCESS))
                    {
                        system.debug('Setting status for refer');
                        Opp.Status_HPP_CAA__c= 'Account Referred'; 
                        update opp;
                    }
                    else
                    {
                        update opp;
                // C0592 Next stage must now be CAA RM for both internal and external users so
                // we now need to make the next stage CAA RM and send back CallEBS=true
                if(CAA_Helper.IsGuestUser())
                        {
                            response.url = null;
                  response.CallEBS = true;
                        }
                    }         
                }
            }
        
        
            
            
            
        return response ;        
    }
    
    
    
    public static void CloseOpenSystemErrorCases(ID oppId)
    {
        //todo get open cases and close them
        return;
    }
    
    public static CAA_Data.GenericResponse CompleteSummary(ID eventLogId, Opportunity opp)
    {
        CAA_Data.GenericResponse response = new CAA_Data.GenericResponse();
        response.Success = false;
    
        //TODO- Check that all the cases have been closed
        Boolean AllCasesClosed = true;  
          
          
        if(AllCasesClosed)
        {
            
            if(CAA_Helper.isUSPersonSignatureRequired(opp))
            {
                response.Success=false;
            }
            else
            {
                response.url = CAA_Helper.CompleteEvent(eventlogId);  
                response.Success = true;                 
            }
        }
        else
        {
            response.Error = 'Cases are not closed'; 
        }
       
        return response ;        
    }
}