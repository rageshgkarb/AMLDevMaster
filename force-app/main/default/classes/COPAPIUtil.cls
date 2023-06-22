public class COPAPIUtil {
    
	@InvocableMethod
    public static List <COPResponseWrapper> execute (List<Requests> requestList) {
        return COPCallout(requestList[0]);
    }

  public class Requests {
    @InvocableVariable(label='Name' required=true)
    public String name;
      
   @InvocableVariable(label='Account Number' required=true)
    public String accountNumber;
      
    @InvocableVariable(label='Sort code' required=true)
    public String sortCode;
      
    @InvocableVariable(label='Account Type' required=true)
    public String accountType;
      
      
  }
     @auraenabled
    public static COPResponseWrapperLightning lwcexecute(String name,String accountNumber,String sortCode, String accountType){
        System.debug('params::'+name+' '+accountNumber+' '+sortCode+' '+accountType);
        Requests params = new Requests();
        params.name=name;
        params.accountNumber = accountNumber;
        params.sortCode = sortCode;
        params.accountType = accountType;
        List<COPResponseWrapper> result = COPCallout(params);
        System.debug('lwc execute result: '+result[0]);
        COPResponseWrapperLightning responseWrapper = (COPResponseWrapperLightning)JSON.deserialize(JSON.serialize(result[0]), COPResponseWrapperLightning.class);
        System.debug('lwc execute result: :'+responseWrapper);

        return responseWrapper;
    }
    
    
    public static List<COPResponseWrapper> COPCallout(Requests request){
       
        HttpRequest req = new HttpRequest();
        req.setMethod('POST');
        req.setHeader('Content-Type','application/x-www-form-urlencoded');

        CoPSitesettings__c cops = [Select ClientId__c,clientSecret__c,Scope__c from CoPSitesettings__c];
        
        String clientId=cops.ClientId__c;
        String clientSecret = cops.clientSecret__c;
        String scope = cops.Scope__c;
        System.debug('cops::'+cops);
        
		req.setEndpoint('https://login.microsoftonline.com/c98335da-657e-48a4-b6d4-d2a106e4df97/oauth2/v2.0/token');
        req.setBody('grant_type=client_credentials' + '&client_id='+clientId + '&client_secret='+clientSecret + '&scope='+scope);
        Http http = new Http();
        HTTPResponse response = http.send(req);
        System.debug('Body ' + response.getBody());
        System.debug('Status ' + response.getStatus());
        System.debug('Status code ' + response.getStatusCode());
        
        Map<String,String> resp1 = (Map<String,String>)JSON.deserialize(response.getbody(),Map<String,String>.class);
        System.debug('access token'+resp1.get('access_token'));
        String access_token=resp1.get('access_token');
        
        
        
        if(access_token!=null){
            
			Id userId = UserInfo.getUserId();
            User currentUser = [select Id,name,email from User where Id=:userId];
            system.debug('currentUser::'+currentUser);
            
            MessageWrapper reqWrapper = new MessageWrapper();
            reqWrapper.MsgId = fetchUniqueMessageId();
            reqWrapper.MsgType = 'COP';
			reqWrapper.Channel = 2;
			reqWrapper.CustomerId = '123456';
			reqWrapper.UserId = currentUser.Id;
			reqWrapper.UserEmail = currentUser.email;
            reqWrapper.IPAddress = GetUserIPAddress(userId);
            reqWrapper.AccountType = request.accountType;
            reqWrapper.Name = request.name;
            reqWrapper.Identification = request.sortCode+request.accountNumber;
           // reqWrapper.SecondaryRef = 'Account 1';
            system.debug('reqWrapper::'+reqWrapper);
            
            Http http2 = new Http();
            HttpRequest req2 = new HttpRequest();
            req2.setHeader('Authorization','Bearer ' + access_token);
            req2.setHeader('Content-Type','application/json');
            req2.setHeader('accept','application/json');
            req2.setBody(JSON.serialize(reqWrapper));
            req2.setMethod('POST');
            req2.setEndpoint('https://integrationhubgateway-apim.azure-api.net/SFCOPRequester/api/COPRequester');
            System.debug('(reqWrapper)'+JSON.serialize(reqWrapper));

            HttpResponse res2 = http2.send(req2);
            System.debug('res2 ' + res2);
            System.debug('resBody ' + res2.getBody());
            System.debug('rfesStatus ' + res2.getStatus());
            System.debug('resStatus code ' + res2.getStatusCode());
            COPResponseWrapper responseWrapper = (COPResponseWrapper)JSON.deserialize(res2.getBody(), COPResponseWrapper.class);
            responseWrapper.StatusCode = res2.getStatusCode();
            System.debug('responseWrapper::'+responseWrapper);
            return new List<COPResponseWrapper>{responseWrapper};
        }

        return new List<COPResponseWrapper>{new COPResponseWrapper()};
        
    }
    
    public class MessageWrapper {
        public String MsgId;
        public String MsgType ;
        public Integer Channel;
        public String CustomerId;
        public String UserId ;
        public String UserEmail ;
        public String IPAddress ;
        public String AccountType ;
        public String Name ;
        public String Identification ;
        public String SecondaryRef;
    }    
    
    public static String GetUserIPAddress(Id userId) {
        
        AuthSession ip = [SELECT SourceIp FROM AuthSession WHERE UsersId =:userId ORDER BY CreatedDate DESC LIMIT 1]; 
        system.debug('ip.SourceIp::'+ip.SourceIp);
        return ip.SourceIp;
    }
    
   public static String fetchUniqueMessageId(){
        Blob b = Crypto.GenerateAESKey(128);
        String h = EncodingUtil.ConvertTohex(b);
        String guid = h.SubString(0,8)+ '-' + h.SubString(8,12) + '-' + h.SubString(12,16) + '-' + h.SubString(16,20) + '-' + h.substring(20);
        system.debug(guid);
        return guid;
    } 
}