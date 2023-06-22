public class COPResponseWrapperLightning {
    
	@AuraEnabled
    public String MsgId;
    
    @AuraEnabled
    public String MsgType;
    
    @AuraEnabled
    public Boolean Matched;
    
    @AuraEnabled
    public String ReasonCode;
    
    @AuraEnabled
    public String Name;
    
    @AuraEnabled
    public Boolean SecondaryRefRequired;
    
    @AuraEnabled
    public String Code;
    
    @AuraEnabled
    public String Message;
    
    @AuraEnabled
    public String StatusCode;
    
    @AuraEnabled
    public List<ErrorInfo> Errors { get; set; }
    
    public class ErrorInfo {
        @AuraEnabled public String ErrorCode { get; set; }
        @AuraEnabled public String Message { get; set; }
        @AuraEnabled public String Path { get; set; }
    }
	

}