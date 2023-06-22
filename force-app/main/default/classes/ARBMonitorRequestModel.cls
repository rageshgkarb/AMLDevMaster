public class ARBMonitorRequestModel {

	public class TnMessage {
		public String source;
		public String requestDate;
		public Integer referralId;
		public String url;
		public String details;
		public String clientApplicationReference;
		public String uid;
	}

	public MonitorRequest MonitorRequest;

	public class MonitorRequest {
		public String SFDCID;
		public Object TNAccountId;
		public String OpportunityId;
		public String Source;
		public TnMessage tnMessage;
	}

	
	public static ARBMonitorRequestModel parse(String json) {
		return (ARBMonitorRequestModel) System.JSON.deserialize(json, ARBMonitorRequestModel.class);
	}
}