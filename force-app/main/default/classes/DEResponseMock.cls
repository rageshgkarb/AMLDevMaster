@IsTest
global class DEResponseMock implements HttpCalloutMock{
    
    private String response;
    
    public DEResponseMock(String response){
        this.response = response;
    }
     
    global HTTPResponse respond(HTTPRequest req){
        HTTPResponse res = new HTTPResponse();
        res.setHeader('Content-Type','application/json');
        res.setBody(response);
        res.setStatusCode(200);
        return res;
    }

}