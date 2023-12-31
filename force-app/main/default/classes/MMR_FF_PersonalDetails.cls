public class MMR_FF_PersonalDetails extends MMR_PageControllerBase
{
    public List<Account> Accs{get;set;}
    public List<Applicant__c> Applicants{get;set;}
    
    
    public MMR_FF_PersonalDetails()
    {   
        Accs = new List<Account>();
        for(String accid : lstAccountIds )
        {
            String soql = LiabilitiesHelperFunctions.SoqlQuery('MMR_FF_PersonalDetails') + ',No_Contact__c,Contact_by_Email_New__c,Contact_by_Newsletter_New__c,Contact_by_Post_New__c,Contact_by_SMS_New__c,Contact_by_Telephone_New__c from account where id = \'' + accid + '\''  ;
            Account a = DataBase.Query(soql);
            Accs.add(a);
        }
        
        Applicants = [select id, HTBQ1__c,HTBQ2__c,HTBQ3__c from applicant__c where opportunity__c = :bopp.id order by applicant_number__c];
    }
    
    public PageReference GoAddresses()
    {
        SaveData();
        return new PageReference('/apex/MMR_FF_Addresses?id=' + eventid);
    }  
    
    public PageReference GoAddressesLightning()
    {
        SaveData();
        return new PageReference('/apex/MMR_FF_Addresses_lightning?id=' + eventid);
    }   
    
    public PageReference GoProperty()
    {
        SaveData();
        return new PageReference('/apex/MMR_FF_PropertyDetails?id=' + eventid);
    } 
    
     public PageReference GoPropertyLightning()
    {
        SaveData();
        return new PageReference('/apex/MMR_FF_PropertyDetails_Lightning?id=' + eventid);
    } 
    
    public PageReference GoIncome()
    {
        SaveData();
        return new PageReference('/apex/MMR_FF_Income?id=' + eventid);
    } 
    
    public PageReference GoIncomeLightning()
    {
        SaveData();
        return new PageReference('/apex/MMR_FF_Income_Lightning?id=' + eventid);
    }     
    
  
    public PageReference Setup_Ownership()
    {
        Accs = new List<Account>();
        for(String accid : lstAccountIds )
        {
            String soql = LiabilitiesHelperFunctions.SoqlQuery('MMR_FF_Ownership') + ' from account where id = \'' + accid + '\''  ;
            Account a = DataBase.Query(soql);
            Accs.add(a);
        }
        return null;
    }
    
    private void LoadProperty()
    {
        String soql = LiabilitiesHelperFunctions.SoqlQuery('MMR_FF_Property') + ' from Property_information__c where PersonAccount__c in' + AccountIds ;
        m_AllProperty= DataBase.Query(soql);
    }
    
    Transient List<Property_information__c> m_AllProperty;    
    public List<Property_information__c> AllProperty
    {
        get{
            if(m_AllProperty == null)
            {
                LoadProperty();
            }
            return m_AllProperty;
        }       
    }
    
    public List<Property_information__c > GetProperty(String applicantNo)
    {
        String id = Accs [integer.valueof(applicantNo)-1].id;
        system.debug('Acc Id ' + id);
        system.debug('ACc list ' + lstAccountIds );
        List<Property_information__c> lst= new List<Property_information__c >();
        for(Property_information__c p : AllProperty)
        {
            if(p.PersonAccount__c == id)
            {
                lst.add(p);
            }
        }    
    
        return lst;
    }
    
    public List<SelectOption> selApplicant
    {
        get{
            List<SelectOption> options= new List<SelectOption>();
            options.add(new SelectOption('','--Select--'));
            Integer i = 1;
            for(Account a : Accs )
            {
                options.add(new SelectOption(a.id,'Applicant ' + i + ' ' +a.name));
                i++;
            }
            return options;
        }
    }

    public PageReference SaveProperty()
    {
        Boolean isNew = true;
        Property_information__c prop = new Property_information__c ();
        
        System.debug('ID:' + EditProperty.id);
        
        if(EditProperty.id != null)
        {
                      
                    
                    String soql = LiabilitiesHelperFunctions.SoqlQuery('MMR_FF_Property') + ' from Property_information__c where id= \'' + EditProperty.id + '\'';
                    
                    List<Property_information__c> props = database.query(soql);
                    
                    if(props.size() > 0)
                    {
                        prop = props[0];
                    }
                  
                    
                    isNew = false;
                    
                    system.debug('Found property id :' + EditProperty.id);
           
        }
        
        
        prop.PersonAccount__c = EditProperty.PersonAccount__c;         
        prop.First_line_of_address__c = EditProperty.First_line_of_address__c;
        prop.Date_purchased__c= EditProperty.Date_purchased__c;
        prop.ExisitingMortgageHPPLender__c= EditProperty.ExisitingMortgageHPPLender__c;
        prop.Amount_of_monthly_repayment__c= EditProperty.Amount_of_monthly_repayment__c;
        prop.IsBTLProperty__c= EditProperty.IsBTLProperty__c;                                
        prop.Amount_of_monthly_rent_received__c= EditProperty.Amount_of_monthly_rent_received__c;  
        
        system.debug(prop);
        
        
        try
        {
            upsert prop;
            EditProperty = new Property_information__c ();
            LoadProperty();
        }
        catch(Exception ex)
        {
            
        }
        return null;
    }
    
    public Property_information__c EditProperty
    {
        get{
            if(EditProperty == null)
            {
                EditProperty = new Property_information__c ();
            }
            return EditProperty;
        }
        set;
    }
    
    public PageReference RemoveItem(String id)
    {
        Integer i = 0;
        Property_information__c del;
        
        for(Property_information__c p : AllProperty)
        {
            if(p.id == id)
            {
                del = AllProperty.Remove(i);
                break;   
            }        
            i++;
        }
        
        if(del != null)
        {
            delete del;
        }            
    
        
    system.debug('Remove main controller :' + id);
        return null;
    }

    private List<Account>UpdateAccounts(List<Account> accounts)
    {
        for(Account a : accounts)
        {
            a = updateAccountTotal(a);
            a = updateMktPrefs(a);
        }
        return accounts;
    }

    // C0697
    private Account updateMktPrefs(Account a)
    {
        if(a.No_Contact__c==null)
        {
            a.No_Contact__c = false;
        }

        a.Contact_by_Email_New__c = !a.No_Contact__c && a.Contact_by_Email_New__c;
        a.Contact_by_Newsletter_New__c = !a.No_Contact__c && a.Contact_by_Newsletter_New__c;
        a.Contact_by_Post_New__c = !a.No_Contact__c && a.Contact_by_Post_New__c;
        a.Contact_by_SMS_New__c = !a.No_Contact__c && a.Contact_by_SMS_New__c;
        a.Contact_by_Telephone_New__c = !a.No_Contact__c && a.Contact_by_Telephone_New__c;

        return a;
    }

    private Account updateAccountTotal(Account a)
    {
        Integer numProp = 0;
        Integer numBtl =0;
        for(Property_information__c p : AllProperty)
        {
            if(a.id == p.Personaccount__c)
            {
                if(p.IsBTLProperty__c)
                {
                    numBtl++;
                }
                else
                {
                    numProp++;
                }
            }
        }
        a.Other_properties_do_you_currently_own__c = string.valueof(numProp);
        a.BTL_Properties__c = string.valueof(numBtl);

        return a;
    }
    
    private void SaveData()
    {
         try
        {
        //update num btl and num properties
        Accs = UpdateAccounts(Accs);    
        
        update Applicants;
        
        update Accs;
        
        }
        catch(Exception ex)
        {
            throw ex;
        }
    }
    
    public PageReference Save()
    {
       SaveData();
        return null;
    }

}