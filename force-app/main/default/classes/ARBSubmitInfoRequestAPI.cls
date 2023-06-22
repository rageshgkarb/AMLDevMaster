@RestResource(urlMapping='/SubmitInfoRequestAPI/*')
global with sharing class ARBSubmitInfoRequestAPI {

  /* @Purpose - Method to invoke the update Account API from middleware ( from TruNarrative )
   * @Params  - ARBSubmitInfoRequestModel- model record for quote update request
          
   * @return ARBSubmitInfoAPIResponseModel with updated order details.
  */
  @HTTPPost
  global static ARBSubmitInfoAPIResponseModel invokeSubmitInfoAPIRequest( ) {
      
      
      System.RestRequest     request    = System.RestContext.request;
      System.RestResponse    response   = System.RestContext.response;         
      ARBSubmitInfoRequestModel wrpData = new ARBSubmitInfoRequestModel(); 
      wrpData = (ARBSubmitInfoRequestModel)System.JSON.deserialize(request.requestBody.toString(), ARBSubmitInfoRequestModel.class);
        
      ARBSubmitInfoAPIResponseModel responseInstance = new ARBSubmitInfoAPIResponseModel ();
    
      return responseInstance;
  
  }



}