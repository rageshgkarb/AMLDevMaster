public class ARBSubmitInfoRequestModel {

	public class Pages {
		public String filename;
	}

	public class TnMessage {
		public String module;
		public String auditRef;
		public String entityName;
		public String clientReference;
		public String journeyRef;
		public String nextAuditRef;
		public String requestDate;
		public List<Documents> documents;
	}

	public class SubmitInformationRequest {
		public String SFDCID;
		public Object TNAccountId;
		public String OpportunityId;
		public Object UpdateType;
		public Object ErrorCode;
		public Object ErrorMessage;
		public TnMessage tnMessage;
	}

	public SubmitInformationRequest SubmitInformationRequest;

	public class Documents {
		public String id;
		public String type;
		public List<Pages> pages;
	}

	
	public static ARBSubmitInfoRequestModel parse(String json) {
		return (ARBSubmitInfoRequestModel) System.JSON.deserialize(json, ARBSubmitInfoRequestModel.class);
	}
}