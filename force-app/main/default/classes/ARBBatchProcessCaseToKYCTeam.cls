/*******************************************************************
* @Class Name      : ARBBatchProcessCaseToKYCTeam
* @Author          : RAGESH G
* @Created Date    : 10 January 2021
* @description 	   : This class is used to write all common functionalies across the application
* @JIRA            : SFD-271

  LOG   DATE        Author  UserStory       	COMMENT      
* 001   10/01/2021  RG                       First Commit
********************************************************************/
global class ARBBatchProcessCaseToKYCTeam implements Database.Batchable<KYC_Automated_Cases_SLA_Setting__mdt> {
	

	global Date currentDate ;
	global List < Id > kycSettingsIdList = new List < Id > ();
	
	global ARBBatchProcessCaseToKYCTeam( Date currentDate ) {
		Map < String , List < KYC_Automated_Cases_SLA_Setting__mdt  > > caseSettingsListMap = new Map < String , List < KYC_Automated_Cases_SLA_Setting__mdt  > >  ();
		 this.currentDate = currentDate;
		 Date todaysDate = currentDate;
		
		List < KYC_Automated_Cases_SLA_Setting__mdt > kycSettingsRecordList = new List < KYC_Automated_Cases_SLA_Setting__mdt > ();
		
		if ( ARBCommonUtils.isWorkingDay( todaysDate )) {

			DateTime currentDateTime = (DateTime) todaysDate ;
			String currentDay = currentDateTime.format('EEEE');
			String currentMonth = currentDateTime.format('MMMM');

			caseSettingsListMap = ARBCommonUtils.fetchKYCCaseSettingsMap ();

			Boolean isQuarterly = false;
			Boolean isSixMonth  = false;

			if ( currentMonth == 'January' || currentMonth == 'April' || currentMonth == 'July' || currentMonth == 'October' ) {
				isQuarterly = true;
			}

			if (  currentMonth == 'January' || currentMonth == 'June' || currentMonth == 'May' || currentMonth == 'March' 
			|| currentMonth == 'April' || currentMonth == 'September' || currentMonth == 'October') {
				isSixMonth = true;
			}
			BusinessHours businessHourRecord = [SELECT Id FROM BusinessHours WHERE IsDefault = true];
			DateTime firstWorkingDate = ARBCommonUtils.fetchFirstWorkingWeekday(businessHourRecord, currentDate);
			DateTime lastWorkingDate  = ARBCommonUtils.fetchLastWorkingWeekday(businessHourRecord, currentDate);

			
			for ( String keyString : caseSettingsListMap.keySet () ) {
				for ( KYC_Automated_Cases_SLA_Setting__mdt currentKYCSettings : caseSettingsListMap.get ( keyString) ) {
					if ( currentKYCSettings.Case_Triggger_Day__c =='Daily') {
						kycSettingsRecordList.add ( currentKYCSettings);	
					}
					if ( currentKYCSettings.Case_Triggger_Day__c == currentDay && currentKYCSettings.Case_Trigger_Frequency__c == 'Weekly') {
						kycSettingsRecordList.add ( currentKYCSettings);
					}
					if ( todaysDate == firstWorkingDate.date() && currentKYCSettings.Case_Triggger_Day__c == '1 Weekday' && currentKYCSettings.Case_Trigger_Frequency__c == 'Monthly') {
						kycSettingsRecordList.add ( currentKYCSettings);
					}
					
					if ( todaysDate == lastWorkingDate.date() && currentKYCSettings.Case_Triggger_Day__c == 'Last Weekday' && currentKYCSettings.Case_Trigger_Frequency__c == 'Monthly') {
						kycSettingsRecordList.add ( currentKYCSettings);
					}
					
					if ( todaysDate == firstWorkingDate.date() && currentKYCSettings.Case_Triggger_Day__c == '1 Weekday' && currentKYCSettings.Case_Trigger_Frequency__c == currentMonth ) {
						kycSettingsRecordList.add ( currentKYCSettings);
					}
					
					if ( todaysDate == firstWorkingDate.date() && currentKYCSettings.Case_Triggger_Day__c == '1 Weekday' && currentKYCSettings.Case_Trigger_Frequency__c == 'Quarterly' && isQuarterly) {
						kycSettingsRecordList.add ( currentKYCSettings);
					}
					
					if ( todaysDate == firstWorkingDate.date() && currentKYCSettings.Case_Triggger_Day__c == '1 Weekday' && currentKYCSettings.Case_Trigger_Frequency__c == '6 Months' && isSixMonth) {
						kycSettingsRecordList.add ( currentKYCSettings);
					}
				}
				
			}
			
			for (  KYC_Automated_Cases_SLA_Setting__mdt currentKYCSettings: kycSettingsRecordList) {
				System.debug ('currentKYCSettings' + currentKYCSettings.Case_Subject__c +'===='+currentKYCSettings.Case_Triggger_Day__c + ' - ' + currentKYCSettings.Case_Trigger_Frequency__c);
				kycSettingsIdList.add( currentKYCSettings.Id );
			}
		}

    }
    
    global Iterable< KYC_Automated_Cases_SLA_Setting__mdt >  start(Database.BatchableContext bc) {
		return [SELECT Id,Case_Subject__c , Case_Description_N__c, Case_SLA__c, Case_Assign_To__c, Case_Trigger_Time__c, Case_Trigger_Frequency__c, Case_Triggger_Day__c
		 FROM KYC_Automated_Cases_SLA_Setting__mdt WHERE Id IN :kycSettingsIdList];
    }
    
    global void execute(Database.BatchableContext bc, List<KYC_Automated_Cases_SLA_Setting__mdt> kycSettingsUpdateList ) {
		System.debug ('kycSettingsUpdateList=== ' + kycSettingsUpdateList);
		if ( kycSettingsUpdateList != null && kycSettingsUpdateList.size () > 0 ) {
			List < Case > caseRecordList = new List < Case > ();
			Map < String, String > caseRecordtypeMap = ARBCommonUtils.fetchCaseRecordTypeMap();
			Map < String, Id > queueSobjectMap = ARBCommonUtils.fetchQueueMap();
			for ( KYC_Automated_Cases_SLA_Setting__mdt kycSettingsRecord : kycSettingsUpdateList ) {
				Case caseRecord = new Case ();
				caseRecord.recordTypeid = caseRecordtypeMap.get(ARBConstantValues.CASE_RECORD_TYPE ) ;
				caseRecord.Subject = kycSettingsRecord.Case_Subject__c;
				caseRecord.Description = kycSettingsRecord.Case_Description_N__c;
				caseRecord.Priority = ARBConstantValues.CASE_PRIORITY;
				caseRecord.Status =  ARBConstantValues.CASE_STATUS;
				caseRecord.Origin =  ARBConstantValues.CASE_ORIGIN;
				if ( kycSettingsRecord.Case_SLA__c == '12h' ) {
					String hoursString = ''+kycSettingsRecord.Case_SLA__c.replaceAll ('h','');
					
					caseRecord.Date_to_Be_Actioned__c = currentDate.addDays( Integer.valueOf(hoursString));
					Integer slaHour = Integer.valueOf(kycSettingsRecord.Case_Trigger_Time__c);
					DateTime updatedTime = DateTime.newInstance(currentDate.year (), currentDate.month (), currentDate.day(), slaHour, 00, 00);

					caseRecord.Internal_SLA__c = updatedTime;
				} else {
					caseRecord.Date_to_Be_Actioned__c = currentDate.addDays( Integer.valueOf(kycSettingsRecord.Case_SLA__c));

				}
				
				Id relatedQueueId ;
				if ( queueSobjectMap.containsKey ( kycSettingsRecord.Case_Assign_To__c) ) {
					relatedQueueId = queueSobjectMap.get ( kycSettingsRecord.Case_Assign_To__c );
				}
				if( relatedQueueId != null){
					caseRecord.OwnerId = relatedQueueId;
				}
				caseRecordList.add ( caseRecord );
			}

			try {
				for ( Case caseRecord : caseRecordList ) {
					System.debug( '#Case Details ' + caseRecord.Subject);
				}
				Database.insert( caseRecordList );
			} catch ( Exception Exe ) {
				System.debug( ' Error occured ' + Exe.getMessage() );
			}

		} 
		

    }

    global void finish(Database.BatchableContext bc) {

    }
}