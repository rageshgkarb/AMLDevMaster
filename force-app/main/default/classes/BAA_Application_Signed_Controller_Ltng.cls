/* ------------------------------------------------------------------------------------------------- */
/* C00233    Submit to Decision Engine Lightning cmp                                                              */    
/* ------------------------------------------------------------------------------------------------- */
/* C0359    Web logs                                                                                 */
/* ------------------------------------------------------------------------------------------------- */

public class BAA_Application_Signed_Controller_Ltng
{

    @AuraEnabled
    public static isWrapper SubmitToDe(string eventId)
    {       
         isWrapper w = new isWrapper();
        Boolean isError = false;
        string message = 'Unknown Error';
        Boolean DeResponce;
          EventLog__c EventLog;
        string opportunityId;
        
            List<EventLog__c> listEvent = DataHelper.GetEventLog(eventId);
            if (listEvent.size() == 0)
              //  return null;
               isError = true;
            
            EventLog = listEvent[0];
            if(EventLog == null)
              //  return null;
              isError = true;
            opportunityId= EventLog.Opportunity__c;
        
        
        if(opportunityId != null){
        opportunity Opp = [select id, Accountid, General_comments_box__c from opportunity where id=:opportunityId];
        

        // fetch business accountIdSet 
        Set <Id > businessAccountIdSet = new Set < Id > ();
        if ( Opp.Accountid != null ) {
          businessAccountIdSet.add( Opp.Accountid );
        }

        
        //Call decision engine  
            
        Actions.ActionBAADecisionEngine DecisionEngineAction = new Actions.ActionBAADecisionEngine ();
        system.debug ('This is the opp id ' + opp.id);
        IBBEvents.CompleteEventArgs args  ;
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
                    accountIdSet.add (Opp.Accountid);
                args = ARBCustomerAMLAPIUtils.invokeCustomerAMLAPI ( accountIdSet, ''+opp.Id );
                } else  if (applicantList.size () <= 1){
                    args = ARBCustomerAMLAPIUtils.invokeCustomerAMLAPI ( ''+opp.Id );
                }
               /* Map < Id, Related_Customer_Entity__c > relatedAccountMap = new Map < Id, Related_Customer_Entity__c > ();
                for ( Related_Customer_Entity_Relationship__c relatedEntityRel : [ SELECT Percent_Ownership__c, Position_Held__c, Relationship_Type__c, Related_Customer_Entity__r.First_Name__c,
                                                                                    Related_Customer_Entity__r.Address_Country__c,Related_Customer_Entity__r.Business_Name__c, Related_Customer_Entity__r.Account__r.Name_of_entity__c,Related_Customer_Entity__r.Post_Code__c,Related_Customer_Entity__r.Middle_Name__c,
                                                                                    Related_Customer_Entity__r.Address_Street__c, Related_Customer_Entity__r.Address_State__c,Related_Customer_Entity__r.Last_name__c,
                                                                                    Related_Customer_Entity__r.Address_City__c,Related_Customer_Entity__r.Date_of_Birth__c,Related_Customer_Entity__r.EBS_Id__c,
                                                                                    Related_Customer_Entity__r.RecordType.DeveloperName,Related_Customer_Entity__r.Name__c,
                                                                                    Related_Customer_Entity__r.Company_Registration_Number__c,Related_Customer_Entity__r.Date_of_incorporation__c,Related_Customer_Entity__r.Country_of_Residence__c,
                                                                                    Related_Customer_Entity__r.Nationality__c,Related_Customer_Entity__r.Country_Of_Incorporation__c,Related_Customer_Entity__r.Account__c, Related_Customer_Entity__r.Account__r.RecordTypeId
                                                                                    FROM Related_Customer_Entity_Relationship__c
                                                                                    WHERE Account__c IN : businessAccountIdSet ]) {
            
                    relatedAccountMap.put ( relatedEntityRel.Related_Customer_Entity__r.Account__c,  relatedEntityRel.Related_Customer_Entity__r);
                }
        
                System.debug ('relatedAccountMap ' + relatedAccountMap.keySet ());

        if ( relatedAccountMap.values ().size() > 0 ) {
          
          args = ARBCustomerAMLAPIUtils.invokeRelatedEntityAMLAPI ( relatedAccountMap, ''+opp.Id );

        }*/

        system.debug('DEResponse : ' +args.DEResponse.Decision);
        
        
        
        if(args.DEResponse.Decision.equalsIgnoreCase('Failed IN EBS') ||
            args.DEResponse.Decision.equalsIgnoreCase('SYSTEMERROR')) 
            
        {
          // ApexPages.addMessage( new ApexPages.Message(ApexPages.Severity.Fatal,'Unfortunately your request to decision engine has been unsuccessful, please contact I.T. Helpdesk and quote the opportunity number as stated above'));
          // return null;
          isError = true;
          message = 'Unfortunately your request to decision engine has been unsuccessful, please contact I.T. Helpdesk and quote the opportunity number as stated above';
        }
        else if(args.DEResponse.Decision.equalsIgnoreCase('ADDRESSMISMATCH') )
        {
          // ApexPages.addMessage( new ApexPages.Message(ApexPages.Severity.Fatal,'The address you have entered for the customer could not be found during the credit check. Please check the address on Royal Mail Postcode search. If this error continues to occur, please contact IT on 0121-452-7333'));
          // return null;
          isError = true;
         message ='The address you have entered for the customer could not be found during the credit check. Please check the address on Royal Mail Postcode search. If this error continues to occur, please contact IT on 0121-452-7333';
        }
        else if (!args.DEResponse.Decision.equalsIgnoreCase('REFERRED') && 
            !args.DEResponse.Decision.equalsIgnoreCase('DECLINE') &&
            !args.DEResponse.Decision.equalsIgnoreCase('SUCCESS') && 
                !args.DEResponse.Decision.equalsIgnoreCase('ACCEPT') &&
                !args.DEResponse.Decision.equalsIgnoreCase('COMPLETE'))
        {
         //  ApexPages.addMessage( new ApexPages.Message(ApexPages.Severity.Fatal,'Unfortunately your request to decision engine has been unsuccessful, please contact I.T. Helpdesk and quote the opportunity number as stated above'));
          // return null;
          isError = true;
           message = 'Unfortunately your request to decision engine has been unsuccessful, please contact I.T. Helpdesk and quote the opportunity number as stated above';
        }
        
            
        DeResponce  = true;
       isError = false;
       // ApexPages.addMessage( new ApexPages.Message(ApexPages.Severity.Info,'Your request to decision engine has been successful, please complete the event'));
       // return null;
        message = 'Your request to decision engine has been successful, please submit the Related Entities';
        }
        w.isError = isError;
        w.message = message;
        
        return w;
    }
    
    @AuraEnabled
    public static isWrapper submitRelatedEntity(string eventId){
        
        isWrapper w = new isWrapper();
        Boolean isError = false;
        string message = 'Unknown Error';
        Boolean DeResponce;
        EventLog__c EventLog;
        string opportunityId;
        
            List<EventLog__c> listEvent = DataHelper.GetEventLog(eventId);
            if (listEvent.size() == 0)
              //  return null;
               isError = true;
            
            EventLog = listEvent[0];
            if(EventLog == null)
              //  return null;
              isError = true;
            opportunityId= EventLog.Opportunity__c;
        
        
        if(opportunityId != null){
        opportunity Opp = [select id, Accountid, General_comments_box__c from opportunity where id=:opportunityId];
        

        // fetch business accountIdSet 
        Set <Id > businessAccountIdSet = new Set < Id > ();
        if ( Opp.Accountid != null ) {
          businessAccountIdSet.add( Opp.Accountid );
        }

        
        //Call decision engine  
            
        Actions.ActionBAADecisionEngine DecisionEngineAction = new Actions.ActionBAADecisionEngine ();
        system.debug ('This is the opp id ' + opp.id);
        IBBEvents.CompleteEventArgs args;
                
               Map < Id, Related_Customer_Entity__c > relatedAccountMap = new Map < Id, Related_Customer_Entity__c > ();
                for ( Related_Customer_Entity_Relationship__c relatedEntityRel : [ SELECT Percent_Ownership__c, Position_Held__c, Relationship_Type__c, Related_Customer_Entity__r.First_Name__c,
                                                                                    Related_Customer_Entity__r.Address_Country__c,Related_Customer_Entity__r.Business_Name__c, Related_Customer_Entity__r.Account__r.Name_of_entity__c,Related_Customer_Entity__r.Post_Code__c,Related_Customer_Entity__r.Middle_Name__c,
                                                                                    Related_Customer_Entity__r.Address_Street__c, Related_Customer_Entity__r.Address_State__c,Related_Customer_Entity__r.Last_name__c,
                                                                                    Related_Customer_Entity__r.Address_City__c,Related_Customer_Entity__r.Date_of_Birth__c,Related_Customer_Entity__r.EBS_Id__c,
                                                                                    Related_Customer_Entity__r.RecordType.DeveloperName,Related_Customer_Entity__r.Name__c,
                                                                                    Related_Customer_Entity__r.Company_Registration_Number__c,Related_Customer_Entity__r.Date_of_incorporation__c,Related_Customer_Entity__r.Country_of_Residence__c,
                                                                                    Related_Customer_Entity__r.Nationality__c,Related_Customer_Entity__r.Country_Of_Incorporation__c,Related_Customer_Entity__r.Account__c, Related_Customer_Entity__r.Account__r.RecordTypeId
                                                                                    FROM Related_Customer_Entity_Relationship__c
                                                                                    WHERE Account__c IN : businessAccountIdSet ]) {
            
                    relatedAccountMap.put ( relatedEntityRel.Related_Customer_Entity__r.Account__c,  relatedEntityRel.Related_Customer_Entity__r);
                }
        
                

        if ( relatedAccountMap.values ().size() > 0 ) {
          System.debug ('relatedAccountMap ' + relatedAccountMap.keySet ());
          
          args = ARBCustomerAMLAPIUtils.invokeRelatedEntityAMLAPI ( relatedAccountMap, ''+opp.Id );

        }

        system.debug('DEResponse : ' +args.DEResponse.Decision);
        
        
        
        if(args.DEResponse.Decision.equalsIgnoreCase('Failed IN EBS') ||
            args.DEResponse.Decision.equalsIgnoreCase('SYSTEMERROR')) 
            
        {
          // ApexPages.addMessage( new ApexPages.Message(ApexPages.Severity.Fatal,'Unfortunately your request to decision engine has been unsuccessful, please contact I.T. Helpdesk and quote the opportunity number as stated above'));
          // return null;
          isError = true;
          message = 'Unfortunately your request to decision engine has been unsuccessful, please contact I.T. Helpdesk and quote the opportunity number as stated above';
        }
        else if(args.DEResponse.Decision.equalsIgnoreCase('ADDRESSMISMATCH') )
        {
          // ApexPages.addMessage( new ApexPages.Message(ApexPages.Severity.Fatal,'The address you have entered for the customer could not be found during the credit check. Please check the address on Royal Mail Postcode search. If this error continues to occur, please contact IT on 0121-452-7333'));
          // return null;
          isError = true;
         message ='The address you have entered for the customer could not be found during the credit check. Please check the address on Royal Mail Postcode search. If this error continues to occur, please contact IT on 0121-452-7333';
        }
        else if (!args.DEResponse.Decision.equalsIgnoreCase('REFERRED') && 
            !args.DEResponse.Decision.equalsIgnoreCase('DECLINE') &&
            !args.DEResponse.Decision.equalsIgnoreCase('SUCCESS') && 
                !args.DEResponse.Decision.equalsIgnoreCase('ACCEPT') &&
                !args.DEResponse.Decision.equalsIgnoreCase('COMPLETE'))
        {
         //  ApexPages.addMessage( new ApexPages.Message(ApexPages.Severity.Fatal,'Unfortunately your request to decision engine has been unsuccessful, please contact I.T. Helpdesk and quote the opportunity number as stated above'));
          // return null;
          isError = true;
           message = 'Unfortunately your request to decision engine has been unsuccessful, please contact I.T. Helpdesk and quote the opportunity number as stated above';
        }
        
            
        DeResponce  = true;
       isError = false;
       // ApexPages.addMessage( new ApexPages.Message(ApexPages.Severity.Info,'Your request to decision engine has been successful, please complete the event'));
       // return null;
        message = 'Your request to submit Related Entities has been successful, please complete the event';
        }
        w.isError = isError;
        w.message = message;
        
        return w;
        
    }
    
    
   	 @AuraEnabled
    public static String complete( NPAABaseEventController.Wrapper wrap)
    {
     
        try
        {        
            wrap.CompleteEvent();            
        }
        catch(Exception ex)
        {
          //  Log.Fatal('Exception',ex);            
        }  
        
        //if(wrap.GoToNextEvent() != null)
        	return wrap.GoToNextEvent().getUrl();
       // else
         //   return null;
    }
	
    
 
   
    public class isWrapper{
        @AuraEnabled public boolean isError{ get; set;}
        @AuraEnabled public string message{get; set;}
        
          public isWrapper()
        {
            this.message = '';
            this.isError = false;
        }
    }
   
   
}