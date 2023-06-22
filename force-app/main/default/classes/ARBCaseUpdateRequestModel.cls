global class ARBCaseUpdateRequestModel {

    public String SFDCID;
    public String TNAccountId;
    public String OpportunityId;
    public String UpdateType;
    public TnMessage tnMessage;
    
    public class Status {
        public String code;
        public String label;
        
    }
    
    public class TnMessage {
        public String accountId;
        public String accountReference; 
        public String name;
        public Status status;
        public Status decision;
        public String updateDate;

    }
}