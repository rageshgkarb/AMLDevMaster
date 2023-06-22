/*******************************************************************
* @Class Name      : ARBCustomerAMLRequestHelper
* @Author          : RAGESH G
* @Created Date    : 17 August 2022
* @description     : This API utils class is used to invoke the API to TruNarrative with Customer details via Middleware
* @JIRA            : 

  LOG   DATE        Author  UserStory           COMMENT      
* 001   17/08/2022  RG                       First Commit
********************************************************************/

public with sharing class ARBCustomerAMLAPIUtils {
   
  public static IBBEvents.CompleteEventArgs invokeCustomerAMLAPI ( String oppId ) {
    IBBEvents.CompleteEventArgs args = new IBBEvents.CompleteEventArgs();

      String accountId = '';
      String requestBody = ARBCustomerAMLRequestHelper.buildCustomerRequest ( oppId );
      System.debug ('requestBody' + requestBody); 
      
      String apiResponse = ARBAPIUtils.fetchAPIResponse ( requestBody, 'AMLHubAccountRequest' );
      System.debug ('apiResponse' + apiResponse); 
      ARBCustomerAMLResponseModel responseObj = ARBCustomerAMLResponseModel.parse( apiResponse );
      ARBCustomerAMLRequestModel customerRequest = ARBCustomerAMLRequestModel.parse ( requestBody );
      Web_Integration_Log__c webLog = new Web_Integration_Log__c();
      weblog.Request_Body__c =''+requestBody;
      weblog.Response_Body__c = ''+apiResponse;
      weblog.Request_Object_Type__c = 'Opportunity';

      args = processAMLResponse ( responseObj, customerRequest, webLog );
      return args;
  }

  // This method is used to send the request to TN for related Entities 
  public static IBBEvents.CompleteEventArgs invokeRelatedEntityAMLAPI ( Map < Id, Related_Customer_Entity__c > relatedAccountMap, String opportunityId ) {
    IBBEvents.CompleteEventArgs args = new IBBEvents.CompleteEventArgs();
    
    List < ARBCustomerAPIWrapper > customerAPIWrapperList = new List < ARBCustomerAPIWrapper > ();
    Set< Id > accountIdSet = relatedAccountMap.keySet ();
    String accountQuery = ARBAPIUtils.buildAllFieldsQuery ('Account');
    String closedStatus = ARBAPIConstantValues.CLOSED_CUSTOMER_STATUS;

      accountQuery += ' WHERE Id IN:accountIdSet AND Status__c !=:closedStatus';
      System.debug (' accountQuery' + accountQuery);
  
    Opportunity oppRecord = [ SELECT Id, Application_Reference_Number__c, Account.SFDC_ID__c,RecordTypeId
              FROM Opportunity WHERE Id=:opportunityId];
    Map < Id, Account > accountRecordMap = new Map < Id, Account > ();
                  system.debug('relMap'+relatedAccountMap);

    if ( relatedAccountMap.KeySet().size () > 0 ) {
        for ( Account accountRecord : Database.query (accountQuery)) {
          accountRecordMap.put ( accountRecord.Id, accountRecord);
        }
    }
    
          
    
    for ( Related_Customer_Entity__c relatedCustomer : relatedAccountMap.values() ) {
  
        String requestBody = ARBCustomerAMLRequestHelper.buildRelatedEntityRequest ( relatedCustomer, oppRecord);
        System.debug (' requestBody' + requestBody);
        String apiResponse = ARBAPIUtils.fetchAPIResponse ( requestBody, 'AMLHubAccountRequest' );
        System.debug (' apiResponse' + apiResponse);
        Account accountRecord ;
        if ( accountRecordMap.containsKey ( relatedCustomer.Account__c)) {
            accountRecord = accountRecordMap.get ( relatedCustomer.Account__c);
            ARBCustomerAPIWrapper customerWrapperObj = new ARBCustomerAPIWrapper ( requestBody, apiResponse, accountRecord, oppRecord);
            customerAPIWrapperList.add ( customerWrapperObj );
        }       
        
    }
      
     /* //new changes start-->
      Map<String,String> requestBodyMap = new Map<String,String>();
      Map<String,Related_Customer_Entity__c> relatedCustomerMessageIdMap = new Map<String,Related_Customer_Entity__c>();
      for ( Related_Customer_Entity__c relatedCustomer : relatedAccountMap.values() ) {
          
          String requestBody = ARBCustomerAMLRequestHelper.buildRelatedEntityRequest ( relatedCustomer, oppRecord);
                    System.debug (' requestBody' + requestBody);            

          ARBCustomerAMLRequestModel reqBody = (ARBCustomerAMLRequestModel)JSON.deserialize(requestBody, ARBCustomerAMLRequestModel.class);
          requestBodyMap.put(reqBody.MessageId,requestBody);
          relatedCustomerMessageIdMap.put(reqBody.MessageId,relatedCustomer);
      }
      
      System.enqueueJob(new invokeRelatedEntityAMLAPIQueueable(requestBodyMap,'AMLHubAccountRequest'));
      List<Web_Integration_Log__c> webLogList = [Select Id,Message_Id__c,Request_Body__c,Response_Body__c from Web_Integration_Log__c where Message_Id__c in:requestBodyMap.keySet() ];
      
      for ( Web_Integration_Log__c webLog : webLogList){                 
          Account accountRecord ;
          
          if ( accountRecordMap.containsKey ( relatedCustomerMessageIdMap.get(webLog.Message_Id__c).Account__c)) {
              accountRecord = accountRecordMap.get (relatedCustomerMessageIdMap.get(webLog.Message_Id__c).Account__c);
              ARBCustomerAPIWrapper customerWrapperObj = new ARBCustomerAPIWrapper ( webLog.Request_Body__c, webLog.Response_Body__c, accountRecord, oppRecord);
              customerAPIWrapperList.add ( customerWrapperObj );
          }
          
      } //<--new changes end.  */

    System.debug ( 'customerAPIWrapperList' + customerAPIWrapperList);
    args = processRelatedEntityAMLResponse ( customerAPIWrapperList );
    return args;
}


  public static IBBEvents.CompleteEventArgs processAMLResponse ( ARBCustomerAMLResponseModel responseObj, ARBCustomerAMLRequestModel requestObj,
                                                              Web_Integration_Log__c webLog) {

    IBBEvents.CompleteEventArgs args = new IBBEvents.CompleteEventArgs();
    System.debug (' inside processing ' + responseObj.TNResponse);

    Account accountRecord = [ SELECT Id,Name, TN_accountId__c, RecordTypeId FROM Account WHERE SFDC_ID__c =:requestObj.SFDCID ];
    Opportunity oppRecord = [ SELECT Id, Reason__c,  Reason_for_decline__c, Name, RecordTypeId, CAA_Decision__c
                              FROM Opportunity 
                              WHERE Name =:requestObj.OpportunityName ];
    
    webLog.OpportunityId__c = oppRecord.Id;
    webLog.AccountId__c = accountRecord.Id;
                              
    weblog.Request_Log_Date_Time__c = DateTime.now();
                                  
   
    weblog.Request_Log_Date_Time__c = DateTime.Now();
    
    try {
      insert webLog;   
    } catch ( Exception Ex ) {
      System.debug ('Error ' + Ex.getMessage () );
    }
                             
    if ( responseObj.TNResponse != null ) {
      if ( responseObj.TNResponse.accountId != null ) {
          accountRecord.TN_accountId__c = ''+responseObj.TNResponse.accountId ;
      }

      if ( accountRecord.TN_accountId__c != null ) {
        try {
          update accountRecord;
        } catch ( Exception Exe ) {
            System.debug ('Error while updating account ' + Exe.getMessage ());
        }
        
      }
      if ( responseObj.TNResponse.status != null && 
      responseObj.TNResponse.status.code !=null ) {
        System.debug ('responseObj.TNResponse.status.code' + responseObj.TNResponse.status.code);
        System.debug ('responseObj.TNResponse.decision.code' + responseObj.TNResponse.decision.code);
        if ( responseObj.TNResponse.status.code == 'DECLINE' || responseObj.TNResponse.status.code == 'CLOSE') {
            
            updateOpportunityRecord ( responseObj, requestObj );
        }else if ( responseObj.TNResponse.status.code !=null && ( responseObj.TNResponse.status.code == 'REFERRED' ||
                responseObj.TNResponse.status.code == 'AWAITING_RESPONSE' ||
                  responseObj.TNResponse.status.code == 'PENDING_EXTERNAL_APPROVAL')) {
          System.debug(' inside Referral ');          
          oppRecord.CAA_Decision__c   = 'REFERRED';
          update oppRecord;
          args.ReturnValue = responseObj.TNResponse.status.code;
          System.enqueueJob(new ARBCaseUpdateProcess( responseObj , accountRecord,  oppRecord));
      }
        else if ( responseObj.TNResponse.decision != null && 
        responseObj.TNResponse.decision.code !=null ) {
      if ( responseObj.TNResponse.decision.code == 'ACCEPT' || responseObj.TNResponse.decision.code == 'COMPLETE') {
          args.ReturnValue = 'SUCCESS';
          System.debug ('inside success ### ' +args.ReturnValue);
      }
      }
  }
  args.DEResponse.Decision = args.ReturnValue ;
  if ( responseObj.InitialDecision =='ERROR') {
      args.DEResponse.Decision = ''+ responseObj.InitialDecision ;
      args.ErrorMessage = ''+responseObj.ErrorMessage;
  }
    
  }

  System.debug ('Returning ### ' +args);
  return args;

}

public static Opportunity updateOpportunityRecord ( ARBCustomerAMLResponseModel reponseObj, ARBCustomerAMLRequestModel requestObj  ) {
    Opportunity oppRecord = [ SELECT Id, Reason__c,  Reason_for_decline__c, Name,RecordTypeId
                              FROM Opportunity 
                              WHERE Name =:requestObj.OpportunityName ];
    if ( reponseObj.TNResponse.decision.code !=null ) {
        if ( reponseObj.TNResponse.decision.code == 'DECLINE') {
          oppRecord.CAA_Decision__c   = ''+reponseObj.TNResponse.decision.code;
        } else if ( reponseObj.TNResponse.decision.code == 'CLOSE') {
          oppRecord.CAA_Decision__c   = ''+reponseObj.TNResponse.decision.code;
        }
    
    update oppRecord;
    }
    
    return oppRecord;
}




public static IBBEvents.CompleteEventArgs invokeCustomerAMLAPI ( Set < Id > accountIdSet, String oppId ) {
  IBBEvents.CompleteEventArgs args = new IBBEvents.CompleteEventArgs();

  String accountQuery = ARBAPIUtils.buildAllFieldsQuery ('Account');

      accountQuery += ' WHERE Id IN:accountIdSet';
      System.debug (' accountQuery' + accountQuery);
  Opportunity oppRecord = [ SELECT Id, Reason__c,  Reason_for_decline__c, Name, AccountId, IBB_Product__r.Category_Of_Product__c, RecordTypeId
                              FROM Opportunity 
                              WHERE Id =:oppId ];
  
  List < ARBCustomerAPIWrapper > customerAPIWrapperList = new List < ARBCustomerAPIWrapper > ();
  Map < String, Asset_Relationship__c > accountToAssetMap = new Map < String, Asset_Relationship__c > ();
        for ( Asset_Relationship__c assetRecord : [ SELECT Id, Relationship_To_Primary_Applicant1__c, Prospect_Customer__c 
                FROM Asset_Relationship__c
                WHERE Prospect_Customer__c  IN : accountIdSet ]) {
                    accountToAssetMap.put ( assetRecord.Prospect_Customer__c, assetRecord);
        }

    
 Map < Id, Account > accountUpdateMap = new Map < Id, Account > ();
  for ( Account accountRecordUpdate : [SELECT Id,Name, TN_accountId__c, RecordTypeId FROM Account WHERE Id IN : accountIdSet]) {
    accountUpdateMap.put ( accountRecordUpdate.Id, accountRecordUpdate);
  }
    
  for ( Account accountRecord : Database.query ( accountQuery ) ) {
    String requestBody = ARBCustomerAMLRequestHelper.buildCustomerRequest ( accountRecord, oppRecord, accountToAssetMap, false);
    System.debug (' requestBody NP multiple' + requestBody);
    String apiResponse = ARBAPIUtils.fetchAPIResponse ( requestBody, 'AMLHubAccountRequest' );
    if ( accountUpdateMap.containsKey ( accountRecord.id ) ) {
        ARBCustomerAPIWrapper customerWrapperObj = new ARBCustomerAPIWrapper ( requestBody, apiResponse, accountUpdateMap.get ( accountRecord.id ), oppRecord);
        customerAPIWrapperList.add ( customerWrapperObj );
    }
    

  }
      args = processAMLResponse ( customerAPIWrapperList );
      return args;
  }

  public static IBBEvents.CompleteEventArgs processAMLResponse ( List < ARBCustomerAPIWrapper > customerAPIWrapperList ) {
    List < Account > accountRecordUpdateList = new List < Account > ();
    List < Opportunity > oppRecordUpdateList = new List < Opportunity > ();
    List < Case > caseRecordList = new List < Case > ();

    Map < String, List < String > > customerDecisionMap = new Map < String, List < String > > ();
    
    ARBProcessDecisionWrapper decisionWrapperObj ;
    
    for ( ARBCustomerAPIWrapper wrapperObj : customerAPIWrapperList) {
      String apiResponse =  wrapperObj.responseBody;
      ARBCustomerAMLResponseModel responseObj = ARBCustomerAMLResponseModel.parse( apiResponse );
      String decision;
      if ( responseObj.TNResponse != null ) {
            if ( responseObj.TNResponse.accountId != null ) {
              wrapperObj.accountRecord.TN_accountId__c = ''+responseObj.TNResponse.accountId ;
              accountRecordUpdateList.add ( wrapperObj.accountRecord );
            }            
            if ( responseObj.TNResponse.status != null && 
            responseObj.TNResponse.status.code !=null ) {
              if ( responseObj.TNResponse.status.code == 'DECLINE' || responseObj.TNResponse.status.code == 'CLOSE') {
                wrapperObj.oppRecord.CAA_Decision__c = ''+responseObj.TNResponse.status.code;
                oppRecordUpdateList.add ( wrapperObj.oppRecord );
                decision =  responseObj.TNResponse.status.code ;
              }else if ( responseObj.TNResponse.status.code == 'REFERRED' ||
                      responseObj.TNResponse.status.code == 'AWAITING_RESPONSE' ||
                        responseObj.TNResponse.status.code == 'PENDING_EXTERNAL_APPROVAL') {
                System.debug(' inside Referral ');
                decision = responseObj.TNResponse.status.code;
                  if ( responseObj.TNResponse.status.code !=null ) {
                      if ( responseObj.TNResponse.status.code == 'REFERRED') {
                        wrapperObj.oppRecord.CAA_Decision__c   = 'ACCOUNT REFERRED';
                        oppRecordUpdateList.add ( wrapperObj.oppRecord );
                      }
                  
                 
                  }
                             
                 caseRecordList.add ( populateCaseData ( responseObj , wrapperObj.accountRecord,  wrapperObj.oppRecord ) ); 
            }
              else if ( responseObj.TNResponse.decision != null && 
              responseObj.TNResponse.decision.code !=null ) {
            if ( responseObj.TNResponse.decision.code == 'ACCEPT' 
                  || responseObj.TNResponse.decision.code == 'COMPLETE') {
                //args.ReturnValue = 'SUCCESS';
                decision = 'SUCCESS';
            }
            }
        }
        //args.DEResponse.Decision = args.ReturnValue ;
        if ( responseObj.InitialDecision =='ERROR') {
            //args.DEResponse.Decision = ''+ responseObj.InitialDecision ;
            //args.ErrorMessage = ''+responseObj.ErrorMessage;
            decision = 'ERROR'+';'+responseObj.ErrorMessage;
        }
    		system.debug('Decision New::'+Decision);      
          	system.debug('wrapperObj Id::'+wrapperObj.accountRecord.Id);
        if ( customerDecisionMap.containsKey ( ''+wrapperObj.accountRecord.Id ) ) {
          customerDecisionMap.get ( ''+wrapperObj.accountRecord.Id ).add (decision) ; 
        } else {
          customerDecisionMap.put ( ''+wrapperObj.accountRecord.Id, new List < String > { decision});
        }
          
        }
      
    }
    			system.debug('customerDecisionMap::'+customerDecisionMap);

      decisionWrapperObj = new ARBProcessDecisionWrapper ( accountRecordUpdateList, oppRecordUpdateList, caseRecordList, 
                                                            customerDecisionMap);
      IBBEvents.CompleteEventArgs args = new IBBEvents.CompleteEventArgs(); 
      args =  processDecisionResponse ( decisionWrapperObj );
      System.debug (' return from processing # ' + args);
      return args;
  }


  public static Case populateCaseData ( ARBCustomerAMLResponseModel responseObj, Account accountRecord, Opportunity oppRecord) {
      TruNarrative_Case_Setting__mdt caseSettings = TruNarrative_Case_Setting__mdt.getInstance('TN_Case_Settings');
      Map < String, String > caseRecordtypeMap = new Map < String, String > ();
      caseRecordtypeMap.put('Risk_Scheduled_Review','0123z0000007WwUAAU');
      caseRecordtypeMap.put('CAA_CASE','012D0000000KJujIAG');
      Date currentDate = System.today ();
      

      Case caseRecord = new Case ();
      caseRecord.AccountId = accountRecord.Id;
      if ( responseObj.TNResponse.Applications.size () > 0  ) {
        if ( responseObj.TNResponse.Applications[0].riskLevel != null ) {
        caseRecord.Description = responseObj.TNResponse.Applications[0].riskLevel;
        }
        if ( responseObj.TNResponse.Applications[0].nameReference != null ) {
          if ( accountRecord.RecordTypeId =='012D0000000QQfrIAG' ) {
            caseRecord.Subject = 'NP '+'Customer Onboarding -' + responseObj.TNResponse.Applications[0].nameReference;
          } else {
            caseRecord.Subject = 'Personal Customer Onboarding -' + responseObj.TNResponse.Applications[0].nameReference;
          }
        
        }
  
        if ( caseSettings!= null ) {
          if (oppRecord.recordTypeId =='012D0000000QWmKIAW' || oppRecord.recordTypeId == '012D0000000QnZzIAK') {
          caseRecord.RecordTypeId = caseRecordtypeMap.get('CAA_CASE' ) ;
          } else {
          caseRecord.RecordTypeId = caseRecordtypeMap.get(caseSettings.Case_Record_Type__c ) ;
          }
          
          caseRecord.OwnerId = caseSettings.Case_Owner__c ;
          caseRecord.Origin = caseSettings.Case_Origin__c;
          caseRecord.Status = caseSettings.Case_Status__c;
          caseRecord.Priority = caseSettings.Case_Priority__c;
          caseRecord.Opportunity__c = oppRecord.Id;
          caseRecord.Risk_Rating__c = caseSettings.Case_Risk_Rating__c;
  
          caseRecord.Date_to_Be_Actioned__c = currentDate.addDays( Integer.valueOf(caseSettings.Case_SLA__c));
         
        }
        
  
      }

      return caseRecord;


  }

  public static IBBEvents.CompleteEventArgs processDecisionResponse (  ARBProcessDecisionWrapper decisionWrapperObj ) {
      IBBEvents.CompleteEventArgs args = new IBBEvents.CompleteEventArgs();  
      if ( decisionWrapperObj.accountRecordUpdateList.size () > 0 ) {
          try {
            
            update decisionWrapperObj.accountRecordUpdateList;
          } catch ( Exception Ex ) {
              System.debug ('Exception while updating account record ' + Ex.getMessage () ); 
          }
      }
      if ( decisionWrapperObj.oppRecordUpdateList !=null && decisionWrapperObj.oppRecordUpdateList.size () > 0 ) {
        try {

          map<id,Opportunity> oppMap = new map<id,Opportunity>();

          //put all the values from the list to map. 
          oppMap.putAll(decisionWrapperObj.oppRecordUpdateList);
          if(oppMap.size()>0){
            update oppMap.values();
          }
        } catch ( Exception Ex ) {
            System.debug ('Exception while updating Opportunity record ' + Ex.getMessage () ); 
        }
      } 
      System.debug('decisionWrapperObj.caseRecordList.size ()'+decisionWrapperObj.caseRecordList.size());
      if ( decisionWrapperObj.caseRecordList.size () > 0 ) {
        try {
          if ( decisionWrapperObj.caseRecordList.size () > 0 ) {
              system.debug('caseRecordList::');
              insert decisionWrapperObj.caseRecordList;
            }
        } catch ( Exception Ex ) {
          System.debug ('Exception Occured while inserting case for multiple accounts ' + Ex.getMessage ());
        }
      }

      if ( decisionWrapperObj.customerDecisionMap != null ) {
        System.debug (' decisionWrapperObj.accountRecordUpdateList ' + decisionWrapperObj.accountRecordUpdateList.size () );
        String declineMessage = '';
        String errorMessage = '';
        String successMessage = '';
        String referMessage = '';
        List < String > declineList = new List < String > ();
        List < String > referList = new List < String > ();
        List < String > successList = new List < String > ();
        List < String > errorList = new List < String > ();

           for ( Account accountRecord : decisionWrapperObj.accountRecordUpdateList ) {
               for ( String decision : decisionWrapperObj.customerDecisionMap.get ( ''+accountRecord.Id ) ) {
                   System.debug (' Account ' + accountRecord.Id +'===>' + decision );
                   if ( decision == 'DECLINE' || decision == 'CLOSE') {
                       declineMessage = declineMessage + decision;
                       declineList.add ( decision);
                   }
                   if ( decision == 'REFERRED' || decision == 'AWAITING_RESPONSE' || decision == 'PENDING_EXTERNAL_APPROVAL') {
                    referMessage = referMessage + decision;
                    System.debug ('inside referral' +  referMessage);
                    referList.add ( decision );
                   }
                   if ( decision == 'ACCEPT' || decision == 'COMPLETE') {
                    successMessage = successMessage + decision;
                    successList.add ( decision);
                   }
                   if ( decision.contains ('ERROR')  ) {
                    String decisionVal = '';

                       if ( decision.contains (';')) {
                        List < String > splittedStringList = decision.split (';');
                          errorMessage = ''+accountRecord.Name +'==>' + errorMessage + splittedStringList[1]+'\n' ;
                       }
                       
                       errorList.add ( decision);
                   } else if ( decision == 'ERROR' ) {
                         args.DEResponse.Decision = 'ERROR' ;
                         return args;
                   }


               }
           }

           
           if ( declineList.size () > = 1 ) {
              System.debug (' declineList' + declineList.size ());
              args.DEResponse.Decision = 'DECLINE' ;
              return args;
           }
           if ( successList.size () > = 1 && ( referList.size () == 0 && declineList.size () == 0 && errorList.size () == 0)) {
            System.debug (' successList' + successList.size ());
            args.DEResponse.Decision = 'SUCCESS' ;
            return args;
          }
          if ( referList.size () > = 1 ) {
            System.debug (' referList' + referList.size ());
            args.DEResponse.Decision = 'REFERRED' ;
            return args;
          }
          if ( errorList.size () > = 1 ) {
            System.debug (' errorList' + errorList.size ());
            args.DEResponse.Decision = 'ERROR' ;
            args.ErrorMessage = errorMessage;
            return args;
          }



           

      }



      return args;
  }
  


  public static void invokeCustomerAMLAPI ( List < Account > accountList ) {
	
    Set < Id > accountIDSet = new Set < Id > ();
    
    for ( Account accountRecord : accountList ) {
      accountIDSet.add ( accountRecord.Id );
    }
    
    
      String accountQuery = ARBAPIUtils.buildAllFieldsQuery ('Account');
    
          accountQuery += ' WHERE Id IN:accountIdSet';
          System.debug (' accountQuery' + accountQuery);
      Map < String, String > oppAccountMap = new Map < String, String > ();
    Map < String, Account > accountIDRecordMap = new Map < String, Account > ();
    for ( Account accountRecord : Database.query ( accountQuery ) ) {
      accountIDRecordMap.put ( accountRecord.Id, accountRecord);
      
    }
    for ( Opportunity oppRecord : [SELECT Id, Reason__c,  Reason_for_decline__c, Name, AccountId, IBB_Product__r.Category_Of_Product__c, RecordTypeId
                                  FROM Opportunity 
                                  WHERE AccountId IN :accountIDSet] ) {
      
      oppAccountMap.put ( oppRecord.Id, oppRecord.AccountId);
    }							
      
      List < ARBCustomerAPIWrapper > customerAPIWrapperList = new List < ARBCustomerAPIWrapper > ();
      Map < String, Asset_Relationship__c > accountToAssetMap = new Map < String, Asset_Relationship__c > ();
            for ( Asset_Relationship__c assetRecord : [ SELECT Id, Relationship_To_Primary_Applicant1__c, Prospect_Customer__c 
                    FROM Asset_Relationship__c
                    WHERE Prospect_Customer__c  IN : accountIdSet ]) {
                        accountToAssetMap.put ( assetRecord.Prospect_Customer__c, assetRecord);
            }
    
      
      for ( Opportunity oppRecord : [SELECT Id, Reason__c,  Reason_for_decline__c, Name, AccountId, IBB_Product__r.Category_Of_Product__c, RecordTypeId
                                  FROM Opportunity 
                                  WHERE AccountId IN :accountIDSet ]) {
      Account accountRecordData ;
      if ( oppAccountMap.containsKey ( oppRecord.Id ) ) {
        String accountId = oppAccountMap.get ( oppRecord.Id );
        if ( accountIDRecordMap.containsKey ( accountId ) ) {
          accountRecordData = accountIDRecordMap.get ( accountId );
          String requestBody = ARBCustomerAMLRequestHelper.buildCustomerRequest ( accountRecordData, oppRecord, accountToAssetMap , true);
          System.debug (' requestBody' + requestBody);
          String apiResponse = ARBAPIUtils.fetchAPIResponse ( requestBody, 'AMLHubAccountRequest' );
          System.debug (' apiResponse' + apiResponse);
        }
        
      }
    
      }
         
      }

      // This method is used from Account Update Trigger 
      public static IBBEvents.CompleteEventArgs invokeCustomerUpdateAMLAPI ( Set < Id > accountIdSet, Map < String, String > oppAccountMap ) {
        IBBEvents.CompleteEventArgs args = new IBBEvents.CompleteEventArgs();
        
        List < ARBCustomerAPIWrapper > customerAPIWrapperList = new List < ARBCustomerAPIWrapper > ();
          Map < String, Asset_Relationship__c > accountToAssetMap = new Map < String, Asset_Relationship__c > ();
                  for ( Asset_Relationship__c assetRecord : [ SELECT Id, Relationship_To_Primary_Applicant1__c, Prospect_Customer__c 
                          FROM Asset_Relationship__c
                          WHERE Prospect_Customer__c  IN : accountIdSet ]) {
                              accountToAssetMap.put ( assetRecord.Prospect_Customer__c, assetRecord);
                  }
      
        String accountQuery = ARBAPIUtils.buildAllFieldsQuery ('Account');
      
          accountQuery += ' WHERE Id IN:accountIdSet';
          System.debug (' accountQuery' + accountQuery);
          Map < String, Account > accountIDRecordMap = new Map < String, Account > ();
          for ( Account accountRecord : Database.query ( accountQuery ) ) {
            accountIDRecordMap.put ( accountRecord.Id, accountRecord);
            
          }
          System.debug (' accountIDSet' + accountIDSet);

        
        
        for ( Opportunity oppRecord : [SELECT Id, Reason__c, Reason_for_decline__c, Name, AccountId, IBB_Product__r.Category_Of_Product__c, RecordTypeId
                                        FROM Opportunity 
                                        WHERE Id IN :oppAccountMap.keySet() ]) {
          Account accountRecordData ;
          System.debug (' oppAccountMap' + oppAccountMap);
          if ( oppAccountMap.containsKey ( oppRecord.Id ) ) {
            String accountId = oppAccountMap.get ( oppRecord.Id );
            if ( accountIDRecordMap.containsKey ( accountId ) ) {
              accountRecordData = accountIDRecordMap.get ( accountId );
              String requestBody = ARBCustomerAMLRequestHelper.buildCustomerRequest ( accountRecordData, oppRecord, accountToAssetMap , true);
              System.debug (' requestBody' + requestBody);
              String apiResponse = ARBAPIUtils.fetchAPIResponse ( requestBody, 'AMLHubAccountRequest' );
              System.debug (' apiResponse' + apiResponse);
              ARBCustomerAPIWrapper customerWrapperObj = new ARBCustomerAPIWrapper ( requestBody, apiResponse, accountRecordData, oppRecord);
              customerAPIWrapperList.add ( customerWrapperObj );
            }
              
            }
          
          }
          args = processAMLResponse ( customerAPIWrapperList );
          
          return args;
        }


        public static IBBEvents.CompleteEventArgs processRelatedEntityAMLResponse ( List < ARBCustomerAPIWrapper > customerAPIWrapperList) {

          List < Account > accountRecordUpdateList = new List < Account > ();
        List < Case > caseRecordList = new List < Case > ();
    
        Map < String, List < String > > customerDecisionMap = new Map < String, List < String > > ();
        
        ARBProcessDecisionWrapper decisionWrapperObj ;
        
        for ( ARBCustomerAPIWrapper wrapperObj : customerAPIWrapperList) {
          String apiResponse =  wrapperObj.responseBody;
          ARBCustomerAMLResponseModel responseObj = ARBCustomerAMLResponseModel.parse( apiResponse );
          String decision;
          if ( responseObj.TNResponse != null ) {
            if ( responseObj.TNResponse.accountId != null ) {
              wrapperObj.accountRecord.TN_accountId__c = ''+responseObj.TNResponse.accountId ;
              accountRecordUpdateList.add ( wrapperObj.accountRecord );
            }            
            if ( responseObj.TNResponse.status != null && 
            responseObj.TNResponse.status.code !=null ) {
            if ( responseObj.TNResponse.status.code == ARBAPIConstantValues.ARB_Referral_Referred ||
                  responseObj.TNResponse.status.code == ARBAPIConstantValues.ARB_Referral_Awaiting_response ||
                  responseObj.TNResponse.status.code == ARBAPIConstantValues.ARB_Referral_Pending_External) {
              System.debug(' inside Referral ');
              decision = responseObj.TNResponse.status.code;
              caseRecordList.add ( populateCaseData ( responseObj , wrapperObj.accountRecord,  wrapperObj.oppRecord ) ); 
            }
              else if ( responseObj.TNResponse.decision != null && 
              responseObj.TNResponse.decision.code !=null ) {
            if ( responseObj.TNResponse.decision.code == ARBAPIConstantValues.ARB_Referral_Accept 
                || responseObj.TNResponse.decision.code == ARBAPIConstantValues.ARB_Referral_Complete) {
              //args.ReturnValue = 'SUCCESS';
              decision = 'SUCCESS';
            }
            }
          }
          //args.DEResponse.Decision = args.ReturnValue ;
          if ( responseObj.InitialDecision =='ERROR') {
            //args.DEResponse.Decision = ''+ responseObj.InitialDecision ;
            //args.ErrorMessage = ''+responseObj.ErrorMessage;
            decision = 'ERROR'+';'+responseObj.ErrorMessage;
          }
            system.debug('Decision New::'+Decision);      
            system.debug('wrapperObj Id::'+wrapperObj.accountRecord.Id);
          if ( customerDecisionMap.containsKey ( ''+wrapperObj.accountRecord.Id ) ) {
            customerDecisionMap.get ( ''+wrapperObj.accountRecord.Id ).add (decision) ; 
          } else {
            customerDecisionMap.put ( ''+wrapperObj.accountRecord.Id, new List < String > { decision});
          }
            
          }
          
        }
              system.debug('customerDecisionMap::'+customerDecisionMap);
    
          decisionWrapperObj = new ARBProcessDecisionWrapper ( accountRecordUpdateList, caseRecordList, 
                                                                customerDecisionMap);
          IBBEvents.CompleteEventArgs args = new IBBEvents.CompleteEventArgs(); 
          args =  processDecisionResponse ( decisionWrapperObj );
          System.debug (' return from processing # ' + args);
          return args;
    
    }    
}