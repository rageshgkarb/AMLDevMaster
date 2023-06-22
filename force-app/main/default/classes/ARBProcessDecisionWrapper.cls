public class ARBProcessDecisionWrapper {

	public List < Account > accountRecordUpdateList = new List < Account > ();
	public List < Opportunity > oppRecordUpdateList = new List < Opportunity > ();
	public List < Case > caseRecordList = new List < Case > ();
    public Map < String, List < String > > customerDecisionMap = new Map < String, List < String > > ();
	
	
	public ARBProcessDecisionWrapper ( List < Account > accountRecordUpdateList , List < Opportunity > oppRecordUpdateList , 
                                        List < Case > caseRecordList, Map < String, List < String > > customerDecisionMap  ) {
		this.accountRecordUpdateList = accountRecordUpdateList;
		this.oppRecordUpdateList = oppRecordUpdateList;
		this.caseRecordList = caseRecordList;
        this.customerDecisionMap = customerDecisionMap;
	}

	public ARBProcessDecisionWrapper ( List < Account > accountRecordUpdateList , 
                                        List < Case > caseRecordList, Map < String, List < String > > customerDecisionMap  ) {
		this.accountRecordUpdateList = accountRecordUpdateList;
		this.caseRecordList = caseRecordList;
        this.customerDecisionMap = customerDecisionMap;
	}
	
	
	

}