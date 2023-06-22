@RestResource(urlMapping='/MonitorRequestAPI/*')
global with sharing class ARBMonitorRequestAPI {

  /* @Purpose - Method to invoke the update Account API from middleware ( from TruNarrative )
   * @Params  - ARBCaseUpdateRequestModel- model record for quote update request
          
   * @return ARBMonitorAPIResponseModel with updated order details.
  */
  @HTTPPost
  global static ARBMonitorAPIResponseModel invokeMonitorAPIRequest( ) {
      
      
      System.RestRequest     request    = System.RestContext.request;
      System.RestResponse    response   = System.RestContext.response;         
      ARBMonitorRequestModel wrpData = new ARBMonitorRequestModel(); 
      wrpData = (ARBMonitorRequestModel)System.JSON.deserialize(request.requestBody.toString(), ARBMonitorRequestModel.class);
        
      ARBMonitorAPIResponseModel responseInstance = new ARBMonitorAPIResponseModel ();
    
      return responseInstance;
  
  }



}