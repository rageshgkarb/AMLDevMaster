public class ARBCaseInserionProcess implements Queueable {

    public List < Case > caseRecordList = new List < Case > ();

    public ARBCaseInserionProcess( List < Case > caseRecordList  ){
		
        this.caseRecordList =caseRecordList;
    }

    public void execute(QueueableContext qCntxt){
        try {
			if ( this.caseRecordList.size () > 0 ) {
				insert this.caseRecordList;
			  }
		} catch ( Exception Ex ) {
			System.debug ('Exception Occured while inserting case for multiple accounts ' + Ex.getMessage ());
		}
        
    }
}