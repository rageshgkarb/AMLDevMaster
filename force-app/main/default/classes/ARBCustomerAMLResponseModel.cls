/*******************************************************************
* @Class Name      : ARBCustomerAMLResponseModel
* @Author          : RAGESH G
* @Created Date    : 17 August 2022
* @description      : This is model class used to parse the response form TruNarrative received via Middleware
* @JIRA            : 

  LOG   DATE        Author  UserStory         COMMENT      
* 001   17/08/2022  RG                       First Commit
********************************************************************/
public class ARBCustomerAMLResponseModel {
	
    public class Status {
		public String code;
		public String label;
	}

	public String MessageId;
	public Integer TNId;
	public String InitialDecision;
	public String Decision;
	public String ErrorCode;
	public String ErrorMessage;
	public List<RuleOutcomes> RuleOutcomes;
	public TNResponse TNResponse;

	public class JourneyId {
		public Integer id;
		public String name;
	}

	public class JourneyType {
		public Integer id;
		public String label;
	}

	public class Applications {
		public String uid;
		public String auditReference;
		public Integer runId;
		public JourneyId journeyId;
		public OrganisationId organisationId;
		public String country;
		public JourneyId user;
		public String nameReference;
		public String riskLevel;
		public JourneyType journeyType;
		public String startDateTime;
		public String endDateTime;
		public Status progressStatus;
		public Decision decision;
		public List<RulesetOutcomes> rulesetOutcomes;
		public List< Links> links;
	}
	
    public class Links {
        public String code;
        public String url; 
    }
	public class OrganisationId {
		public Integer id;
	}

	public class RuleOutcomes {
		public String RuleName;
		public Boolean Outcome;
		public Integer Score;
	}
	

	public class Decision {
		public String code;
		public String label;
	}

	public class RulesetOutcomes {
		public String reference;
		public Integer score;
		public List<ARBModelClassManager.RuleOutcomes> ruleOutcomes;
		public String riskLevel;
	}

	public class TNResponse {
		public Integer accountId;
		public Status status;
		public Decision decision;
		public List<Applications> Applications;
	}
        
	public static ARBCustomerAMLResponseModel parse(String json) {
		return (ARBCustomerAMLResponseModel) System.JSON.deserialize(json, ARBCustomerAMLResponseModel.class);
	}
}