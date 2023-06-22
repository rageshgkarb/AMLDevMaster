public without sharing class ARBCustomerERTriggerHandler implements ARBTriggerHandler {
    private boolean triggerIsExecuting;
    private integer triggerSize;
    public ARBCustomerERTriggerHelper helper;
    public ARBCustomerERTriggerHandler (boolean triggerIsExecuting, integer triggerSize) {
        this.triggerIsExecuting = triggerIsExecuting;
        this.triggerSize = triggerSize;
        this.helper = new ARBCustomerERTriggerHelper();
    }
    
    public void afterInsert( List<Related_Customer_Entity_Relationship__c> newCustomerEntityList) {

        Map < String, Map < Id, Related_Customer_Entity__c > > relatedBusinessCustomerMap = fetchBusinessRelatedMap ( newCustomerEntityList );
        helper.processRelatedEntityRecords ( relatedBusinessCustomerMap );
    }
    public void afterUpdate(List<Related_Customer_Entity_Relationship__c> newCustomerEntityList) {
        Map < String, Map < Id, Related_Customer_Entity__c > > relatedBusinessCustomerMap = fetchBusinessRelatedMap ( newCustomerEntityList );
        helper.processRelatedEntityRecords ( relatedBusinessCustomerMap );
    }
    public void afterUndelete( List<Related_Customer_Entity_Relationship__c> newCustomerEntityList ) {

        Map < String, Map < Id, Related_Customer_Entity__c > > relatedBusinessCustomerMap = fetchBusinessRelatedMap ( newCustomerEntityList );
        helper.processRelatedEntityRecords ( relatedBusinessCustomerMap );
    }

    // This method used to return the full map of business account => Related Entity  = > Related Entity Account
    public Map < String, Map < Id, Related_Customer_Entity__c > > fetchBusinessRelatedMap ( List<Related_Customer_Entity_Relationship__c> newCustomerEntityList ) {
        Map < String, Map < Id, Related_Customer_Entity__c > > relatedBusinessCustomerMap = new Map < String, Map < Id, Related_Customer_Entity__c > > ();

        for ( Related_Customer_Entity_Relationship__c relatedEntityRel :  [SELECT Percent_Ownership__c, Position_Held__c, Relationship_Type__c, Related_Customer_Entity__r.First_Name__c,
        Related_Customer_Entity__r.Address_Country__c,Related_Customer_Entity__r.Business_Name__c, Related_Customer_Entity__r.Account__r.Name_of_entity__c,Related_Customer_Entity__r.Post_Code__c,Related_Customer_Entity__r.Middle_Name__c,
        Related_Customer_Entity__r.Address_Street__c, Related_Customer_Entity__r.Address_State__c,Related_Customer_Entity__r.Last_name__c,
        Related_Customer_Entity__r.Address_City__c,Related_Customer_Entity__r.Date_of_Birth__c,Related_Customer_Entity__r.EBS_Id__c,
        Related_Customer_Entity__r.RecordType.DeveloperName,Related_Customer_Entity__r.Name__c,
        Related_Customer_Entity__r.Company_Registration_Number__c,Related_Customer_Entity__r.Date_of_incorporation__c,Related_Customer_Entity__r.Country_of_Residence__c,
        Related_Customer_Entity__r.Nationality__c,Related_Customer_Entity__r.Country_Of_Incorporation__c,Related_Customer_Entity__r.Account__c, Related_Customer_Entity__r.Account__r.RecordTypeId, Account__c, Related_Customer_Entity__r.Account__r.Name
        FROM Related_Customer_Entity_Relationship__c WHERE Id IN : newCustomerEntityList]) {
            if ( relatedBusinessCustomerMap.containsKey (  relatedEntityRel.Account__c ) ) {
                relatedBusinessCustomerMap.get (  relatedEntityRel.Account__c ).put ( relatedEntityRel.Related_Customer_Entity__r.Account__c,  relatedEntityRel.Related_Customer_Entity__r);
            } else {
                relatedBusinessCustomerMap.put (  relatedEntityRel.Account__c, new Map < Id, Related_Customer_Entity__c > { 
                    relatedEntityRel.Related_Customer_Entity__r.Account__c=> relatedEntityRel.Related_Customer_Entity__r});
            }
        }

        return relatedBusinessCustomerMap;
    }
}