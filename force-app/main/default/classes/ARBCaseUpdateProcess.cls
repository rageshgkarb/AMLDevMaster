public class ARBCaseUpdateProcess implements Queueable{
	
    public List<Account> accListToCreateContacts;
	public ARBCustomerAMLResponseModel responseObj;
	public Account accountRecord;
    public Opportunity oppRecord;
	
    public ARBCaseUpdateProcess( ARBCustomerAMLResponseModel responseObj , Account accountRecord, Opportunity oppRecord ){
		
        this.responseObj=responseObj;
		this.accountRecord = accountRecord;
        this.oppRecord = oppRecord;
    }
    public void execute(QueueableContext qCntxt){
		TruNarrative_Case_Setting__mdt caseSettings = TruNarrative_Case_Setting__mdt.getInstance('TN_Case_Settings');
		Map < String, String > caseRecordtypeMap = new Map < String, String > ();
		caseRecordtypeMap.put('Risk_Scheduled_Review','0123z0000007WwUAAU');
		caseRecordtypeMap.put('CAA_CASE','012D0000000KJujIAG');
		Map < String, Id > queueSobjectMap = ARBCommonUtils.fetchQueueMap();
		Date currentDate = System.today ();
		
        
		Case caseRecord = new Case();
		//caseRecord.ContactId = accountRecord.Id;
		caseRecord.AccountId = accountRecord.Id;

		if ( responseObj.TNResponse.Applications.size () > 0  ) {
		  if ( responseObj.TNResponse.Applications[0].riskLevel != null ) {
			caseRecord.Subject = responseObj.TNResponse.Applications[0].riskLevel;
			caseRecord.Description = responseObj.TNResponse.Applications[0].riskLevel;
		  }
		  if ( responseObj.TNResponse.Applications[0].nameReference != null ) {
			if ( accountRecord.RecordTypeId =='012D0000000QQfrIAG' ) {
			  caseRecord.Subject = 'NP '+'Customer Onboarding -' + responseObj.TNResponse.Applications[0].nameReference;
			} else {
			  caseRecord.Subject = 'Perosnal Customer Onboarding -' + responseObj.TNResponse.Applications[0].nameReference;
			}
		  
		  }

		  if ( caseSettings!= null ) {
			  if (this.oppRecord.recordTypeId =='012D0000000QWmKIAW') {
				caseRecord.RecordTypeId = caseRecordtypeMap.get('CAA_CASE' ) ;
			  } else {
				caseRecord.RecordTypeId = caseRecordtypeMap.get(caseSettings.Case_Record_Type__c ) ;
			  }
			  
			  caseRecord.OwnerId = caseSettings.Case_Owner__c ;
			  System.debug ('caseRecord.OwnerId:' + caseRecord.OwnerId);
			  caseRecord.Origin = caseSettings.Case_Origin__c;
			  caseRecord.Status = caseSettings.Case_Status__c;
			  caseRecord.Priority = caseSettings.Case_Priority__c;
              caseRecord.Opportunity__c = this.oppRecord.Id;
			  caseRecord.Risk_Rating__c = caseSettings.Case_Risk_Rating__c;

			  caseRecord.Date_to_Be_Actioned__c = currentDate.addDays( Integer.valueOf(caseSettings.Case_SLA__c));
			 
		  }
		  

		}
		
					
		try {
			if ( caseRecord.AccountId != null ) {
				insert caseRecord;
			  }
			  

		} catch ( Exception Ex ) {
			System.debug ('Exception Occured ' + Ex.getMessage ());
		}
		
		
    }    
}