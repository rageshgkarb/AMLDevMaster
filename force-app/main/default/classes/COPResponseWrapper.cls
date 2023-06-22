public class COPResponseWrapper {
    
	@InvocableVariable(label='MsgId')
    public String MsgId;
    
    @InvocableVariable(label='MsgType')
    public String MsgType;
    
    @InvocableVariable(label='Matched' required=true)
    public Boolean Matched;
    
    @InvocableVariable(label='ReasonCode' required=true)
    public String ReasonCode;
    
    @InvocableVariable(label='Name' required=true)
    public String Name;
    
    @InvocableVariable(label='SecondaryRefRequired' required=true)
    public Boolean SecondaryRefRequired;
    
    @InvocableVariable(label='Code' required=true)
    public String Code;
    
    @InvocableVariable(label='Message' required=true)
    public String Message;
    
    @InvocableVariable(label='StatusCode' required=true)
    public Integer StatusCode;
    
    public List<ErrorInfo> Errors { get; set; }
    
    public class ErrorInfo {
        public String ErrorCode { get; set; }
        public String Message { get; set; }
        public String Path { get; set; }
    }
	

}