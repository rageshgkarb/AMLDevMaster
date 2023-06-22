public class OpportunityLetterGeneratorHelper {
    
    @future(callout = true)
    public static void generateOppLetters(Set<Id> oppIds){
        CongaSettings conga = new CongaSettings();
         
        system.debug('conga.QueryDataId'+conga.QueryDataId);
        List<Docugen_Template__c> template = [select id, Template_Name__c from Docugen_Template__c
                                              where Template_Name__c ='Liabilities Decline Letter v1.1'
                                              order by Template_Name__c ];
        String OutputName = '';
        
        List<RESTDocugenButtonController.QueryItem> Items = new List<RESTDocugenButtonController.QueryItem>();
        RESTDocugenButtonController.QueryItem item = new RESTDocugenButtonController.QueryItem();
        item.Alias = 'App2';item.Id = 'a5aD0000000GmgC';
        Items.add(item);
        
        RESTDocugenButtonController.QueryItem item1 = new RESTDocugenButtonController.QueryItem();
        item1.Alias = 'App3';item1.Id = 'a5aD0000000GmgB';
        Items.add(item);
        
        RESTDocugenButtonController.QueryItem item2 = new RESTDocugenButtonController.QueryItem();
        item2.Alias = 'App4';item2.Id = 'a5aD0000000GmgA';
        Items.add(item);
        
        RESTDocugenButtonController.QueryItem item3 = new RESTDocugenButtonController.QueryItem();
        item3.Alias = 'Prod';item3.Id = 'a5aD0000000Gmex';
        Items.add(item);
        
        
        for(Id oppId: oppIds){
            conga.CallCongaButtonSave(oppId, template[0].Id,Items,outputname);
            String url = buildUrl(oppId,conga.QueryDataId);       
            system.debug('--url--'+url);
            CallDocuGenOld(url,conga.QueryDataId);
        }
        
    }
    
    public static void CallDocuGenOld(String url,String QueryDataId)
    {
        String serverUrl = LiabilitiesHelperFunctions.GetServerUrl;
        //create conga doc
        Http h = new Http();
        HttpRequest req = new HttpRequest();
        req.setEndpoint(url);
        req.setMethod('GET');
        req.setTimeout(120000);
        
        HttpResponse res = h.send(req);
        String Response = res.getBody().trim();
        system.debug(Response);
        
        if(Response.left(3).equalsIgnoreCase( '00P'))
        {
         
            
        }else{
            if(Response.left(3).equalsIgnoreCase( '068')){
                
            }else{
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, response));
            } 
        }        
    }
    
    public static String buildUrl(Id id,String QueryDataId)
    {
        String url = CongaUrl() + '?session=';
        String uiThemeDisplayed = UserInfo.getUiTheme();
        
        if(uiThemeDisplayed != Label.LightningThemeValue){
             url += UserInfo.getSessionId();
        }else{
             url +=  LexSessionController.fetchUserSessionId();
        }
        String serverUrl = System.Url.getSalesforceBaseUrl().toExternalForm();
        String partnerServerUrl = serverUrl + '/services/Soap/u/42.0';
        
        url += '&serverUrl=' + partnerServerUrl; 
        url += '&id=' + id;
        
        url += '&dataid=' + QueryDataId;
        
        
        return url;
    }
    
    public static String CongaUrl()
    {
        List<Webservice_Setting__c> settings = Webservice_Setting__c.getall().values();
        
        for(Webservice_Setting__c s : settings)
        {
            if(s.name == 'Docugen Service Endpoint')
                return s.Value__c;
        }
        return '';        
    }
}