public class ARBAccountReferralRequestModel{
    public CaseReferralRequest CaseReferralRequest;

    public class CaseReferralRequest{
        public string SFDCID;
        public string TNAccountId ;
        public string OpportunityId ;
        public string UpdateType;
        public string ErrorCode ;
        public string ErrorMessage ;
        public boolean PEP;
        public boolean AdverseMedia ;
        public boolean Sanctions;
        public boolean IDV;
        public boolean CIFAS ;
        public string nextAction ;
    
    
    
       public ARBTNAccountReferralRequestWH tnMessage;
    }

    public class ARBTNAccountReferralRequestWH
    {
        public string name { get; set; }
        public string referralReference { get; set; }
        public string uid { get; set; }
        public string status { get; set; }
        public DateTime updateDateTime { get; set; }
        public string riskLevel { get; set; }
        public string customerReference { get; set; }
        public NextAction nextAction { get; set; }
        public string clientApplicationReference { get; set; }
        public List<Document> documents { get; set; }
        public List<Flag> flags { get; set; }
        public DecisionReason decisionReason { get; set; }
        

   }

   public class DecisionReason
        {
            public Integer id { get; set; }
            public string label { get; set; }
        }



       public class Document
        {
            public string id { get; set; }
            public string type { get; set; }
           // public List<Page> pages { get; set; }
        }



       public class Flag
        {
            public string code { get; set; }
            public string label { get; set; }
        }



       public class NextAction
        {
            public Integer id { get; set; }
            public string label { get; set; }
        }



       /*public class Page
        {
            public string filename { get; set; }
            public string tag { get; set; }
        }*/



}