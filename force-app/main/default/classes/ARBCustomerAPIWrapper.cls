public class ARBCustomerAPIWrapper {

	public String responseBody;
	public String requestBody;
	public Account accountRecord;
    public Opportunity oppRecord;
	
	
	public ARBCustomerAPIWrapper ( String requestBody, String responseBody, Account accountRecord, Opportunity oppRecord ) {
		this.requestBody = requestBody;
		this.responseBody = responseBody;
		this.accountRecord = accountRecord;
        this.oppRecord = oppRecord;
		
	}
	

}