public with sharing class ARBAPIUtils {
    
    public static String buildAllFieldsQuery(String ObjectName) {
        List<String> fields = new List<String>(Schema.getGlobalDescribe().get(ObjectName).getDescribe().fields.getMap().keySet());

        List < String > fieldList = new List < String > ();
        for ( String fieldName : fields ) {
            if ( !fieldName.contains('__pc')) {
                fieldList .add ( fieldName );
            }
        }
        fieldList.add ('Middle_Name__pc');
        fieldList.add ('Previous_Name__pc');
        String query  = 'SELECT '+String.join(fieldList , ',')+' FROM '+ObjectName;

        return query;
    }

    public static String formatDate(Date input) {
        //return d.year() + '-' + d.month() + '-' + d.day();
        Datetime output = Datetime.newInstanceGmt(input, Time.newInstance(0,0,0,0));
        // now output is the same as it was in `bar`
        return output.formatGmt('yyyy-MM-dd');
    }

    public static String fetchUniqueMessageId(){
        Blob b = Crypto.GenerateAESKey(128);
        String h = EncodingUtil.ConvertTohex(b);
        String guid = h.SubString(0,8)+ '-' + h.SubString(8,12) + '-' + h.SubString(12,16) + '-' + h.SubString(16,20) + '-' + h.substring(20);
        system.debug(guid);
        return guid;
    }

    public static String fetchAPIResponse ( String requestBody, string apiName ) {

         // Instantiate a new Http object
         Http httpObj = new Http();

         // Instantiate a new HTTP request
         // Specify request properties such as the endpoint, the POST method, etc. 
         HttpRequest httpRequestObj = new HttpRequest();
         String endpoint = TruNarrative_API_Settings__mdt.getInstance ( apiName ).API_Endpoint__c;
         httpRequestObj.setEndpoint( endpoint );
         httpRequestObj.setMethod('POST');
         httpRequestObj.setHeader('Content-Type', 'application/json');
         httpRequestObj.setHeader('Accept','application/json'); 
         httpRequestObj.setTimeout(120000);
         httpRequestObj.setBody(requestBody);
 
         // Send the request, and return a response
         HttpResponse res = httpObj.send(httpRequestObj);
         System.debug('>>> response ' + res.getBody());
         String apiResponse = res.getBody();
         System.debug ('res.getBody();' + apiResponse); 
         return apiResponse;
    }
}