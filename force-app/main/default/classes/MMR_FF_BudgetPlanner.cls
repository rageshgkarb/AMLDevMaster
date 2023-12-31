public class MMR_FF_BudgetPlanner extends MMR_PageControllerBase
{
    transient List<BudgetPlannerConfig__c> m_BudgetConfig;
    public String DropdownSelected { get; set; }
    public HPP_extended_opportunity__c ExOpp { get; set; }

    public List<String> Values
    {
        get {
            LoadConfig();
            List<String> lst = new List<String> ();
            for (BudgetPlannerConfig__c c : m_BudgetConfig)
            {
                Decimal value = GetValue(c);
                
                if(c.Use_ONS_Only__c)
                {
                    for(Budget_Planner_Item__c item : AllItems)
                    {
                        if(item.BudgetPlannerConfig__c == c.ID && value!=item.Applicant_Total__c)
                        {
                            item.Applicant_Total__c=value;
                            break;
                        }
                    }
                }
                system.debug('ValueId :' + value);

                if (value == null)
                {
                    lst.add('0.00');
                }
                else
                {
                    if (c.Car_Bill__c)
                    {
                        value = value * NoCars;
                    }
                    lst.add(string.valueof(value));
                }
            }

            system.debug('no values:' + lst.size());
            return lst;
        }
    }

    public void CalcBudget()
    {
        if (!bopp.Is_Joint_Application__c && Accs.size() == 1 && NoDependants == 0)
        {
            ExOpp.Budget_Figures__c = 'Single App';
            return;
        }

        if (!bopp.Is_Joint_Application__c && Accs.size() == 1 && NoDependants == 1)
        {
            ExOpp.Budget_Figures__c = 'Single App + 1 dependent';
            return;
        }

        if (!bopp.Is_Joint_Application__c && Accs.size() == 1 && NoDependants == 2)
        {
            ExOpp.Budget_Figures__c = 'Single App + 2 dependents';
            return;
        }

        if (Accs.size() == 3 && NoDependants == 0)
        {
            ExOpp.Budget_Figures__c = 'Triple';
            return;
        }

        if (Accs.size() == 3 && NoDependants > 0)
        {
            ExOpp.Budget_Figures__c = 'Triple with children';
            return;
        }

        if (NoDependants == 0)
        {
            ExOpp.Budget_Figures__c = 'Joint App';
            return;
        }

        if (NoDependants == 1)
        {
            ExOpp.Budget_Figures__c = 'Joint App + 1 dependent';
            return;
        }

        if (NoDependants == 2)
        {
            ExOpp.Budget_Figures__c = 'Joint App + 2 dependent';
            return;
        }

        if (NoDependants > 2)
        {
            ExOpp.Budget_Figures__c = 'Joint App 3 or more dependents';
            return;
        }

        ExOpp.Budget_Figures__c = 'Single App';
        return;

    }

    private Decimal GetValue(BudgetPlannerConfig__c c)
    {
        if (ExOpp.Budget_Figures__c.equalsIgnoreCase('Single App'))
        return c.SingleApp__c;

        if (ExOpp.Budget_Figures__c.equalsIgnoreCase('Single App + 1 dependent'))
        return c.Single_App_1_Dep__c;

        if (ExOpp.Budget_Figures__c.equalsIgnoreCase('Single App + 2 dependents'))
        return c.Single_App_2_Dep__c;

        if (ExOpp.Budget_Figures__c.equalsIgnoreCase('Joint App'))
        return c.Joint_App__c;

        if (ExOpp.Budget_Figures__c.equalsIgnoreCase('Joint App + 1 dependent'))
        return c.Joint_App_1_Dep__c;

        if (ExOpp.Budget_Figures__c.equalsIgnoreCase('Joint App + 2 dependent'))
        return c.Joint_App_2_Dep__c;

        if (ExOpp.Budget_Figures__c.equalsIgnoreCase('Joint App 3 or more dependents'))
        return c.Joint_App_3_Dep__c;

        if (ExOpp.Budget_Figures__c.equalsIgnoreCase('Triple'))
        return c.Triple__c;

        if (ExOpp.Budget_Figures__c.equalsIgnoreCase('Triple with children'))
        return c.Triple_with_children__c;

        return 0;
    }

    public PageReference Prev()
    {
        SaveData();
        return new PageReference('/apex/mmr_ff_credit?id=' + eventid);
    }

    public PageReference Complete()
    {
        try {
            SaveData();
        }
        catch(Exception ex) {
            System.debug('Exception on Update exOpp : ' + ex);
        }

        CompleteEvent();
        return GoToNextEvent();

        return null;
    }

    private void LoadConfig()
    {
        if (m_BudgetConfig == null)
        {
            // C0635 Get BudgetPlanner Version to retrieve correct items
            // C0597 HPP-BTL Start
            //case: 01938975  Start
            if (IsBTL)
            {
                m_BudgetConfig = [select id, Paid_within_months__c, Monthly_payment_percent__c, Use_ONS_Only__c, IsStressed__c,
                                  SingleApp__c, Joint_App__c, Joint_App_1_Dep__c, Joint_App_3_Dep__c, Joint_App_2_Dep__c, Triple__c, Triple_with_children__c, Single_App_1_Dep__c, Single_App_2_Dep__c,
                                  SingleApp_ONS__c, Joint_App_ONS__c, Joint_App_1_Dep_ONS__c, Joint_App_3_Dep_ONS__c, Joint_App_2_Dep_ONS__c, Triple_ONS__c, Triple_with_children_ONS__c, Single_App_1_Dep_ONS__c, Single_App_2_Dep_ONS__c,
                                  Car_Bill__c, Personal_Debt__c, name
                                  from BudgetPlannerConfig__c
                                  where name != 'New Premier Budget Planner Config' and  (V1__c = :is_BP_V1 or V2__c = :is_BP_V2)
                                  order by Order__c];
            }
            else
            {
                m_BudgetConfig = [select id, Paid_within_months__c, Monthly_payment_percent__c, Use_ONS_Only__c, IsStressed__c,
                                  SingleApp__c, Joint_App__c, Joint_App_1_Dep__c, Joint_App_3_Dep__c, Joint_App_2_Dep__c, Triple__c, Triple_with_children__c, Single_App_1_Dep__c, Single_App_2_Dep__c,
                                  SingleApp_ONS__c, Joint_App_ONS__c, Joint_App_1_Dep_ONS__c, Joint_App_3_Dep_ONS__c, Joint_App_2_Dep_ONS__c, Triple_ONS__c, Triple_with_children_ONS__c, Single_App_1_Dep_ONS__c, Single_App_2_Dep_ONS__c,
                                  Car_Bill__c, Personal_Debt__c, name
                                  from BudgetPlannerConfig__c
                                  where (name != 'HPP' and name!='Income Assisted BTL Deficit' and name != 'New Premier Budget Planner Config') and (V1__c = :is_BP_V1 or V2__c = :is_BP_V2)
                                  order by Order__c];
            }
            // C0597 HPP-BTL End
            //case: 01938975  End

        }
    }

    public List<BudgetPlannerConfig__c> BudgetConfig
    {
        get
        {
            LoadConfig();
            return m_BudgetConfig;
        }
        set;
    }

    public List<Account> Accs { get; set; }
    public List<Budget_Planner_Item__c> AllItems { get; set; }

    public void CreateMap()
    {
        // C0635 Get BudgetPlanner Version to retrieve correct items
        // C0597 HPP-BTL Start
        //case: 01938975  Start
        if (IsBTL)
        {
            AllItems = [select id, Name, bdm_comments__c, BudgetPlannerConfig__c, Applicant_Total__c, BudgetPlannerConfig__r.Personal_Debt__c, BudgetPlannerConfig__r.name, BudgetPlannerConfig__r.SingleApp__c, BudgetPlannerConfig__r.Joint_App__c, BudgetPlannerConfig__r.Joint_App_1_Dep__c, BudgetPlannerConfig__r.Joint_App_2_Dep__c, BudgetPlannerConfig__r.Joint_App_3_Dep__c,
                        BudgetPlannerConfig__r.Triple__c, BudgetPlannerConfig__r.Triple_with_children__c, BudgetPlannerConfig__r.Use_ONS_Only__c from Budget_Planner_Item__c
                        where Opportunity__c = :opportunityId and (BudgetPlannerConfig__r.name != 'New Premier Budget Planner Config') and(budgetplannerconfig__r.V1__c = :is_BP_V1 or budgetplannerconfig__r.V2__c = :is_BP_V2)
                        order by BudgetPlannerConfig__r.order__c];
        }
        else
        {
            AllItems = [select id, Name, bdm_comments__c, BudgetPlannerConfig__c, Applicant_Total__c, BudgetPlannerConfig__r.Personal_Debt__c, BudgetPlannerConfig__r.name, BudgetPlannerConfig__r.SingleApp__c, BudgetPlannerConfig__r.Joint_App__c, BudgetPlannerConfig__r.Joint_App_1_Dep__c, BudgetPlannerConfig__r.Joint_App_2_Dep__c, BudgetPlannerConfig__r.Joint_App_3_Dep__c,
                        BudgetPlannerConfig__r.Triple__c, BudgetPlannerConfig__r.Triple_with_children__c, BudgetPlannerConfig__r.Use_ONS_Only__c from Budget_Planner_Item__c
                        where Opportunity__c = :opportunityId and (BudgetPlannerConfig__r.name != 'HPP' and BudgetPlannerConfig__r.name != 'Income Assisted BTL Deficit' and BudgetPlannerConfig__r.name != 'New Premier Budget Planner Config') and (budgetplannerconfig__r.V1__c = :is_BP_V1 or budgetplannerconfig__r.V2__c = :is_BP_V2)
                        order by BudgetPlannerConfig__r.order__c];
        }
        // C0597 HPP-BTL End
        //case: 01938975  End
    }

    public void GetItems()
    {
        if (AllItems == null)
        {
            AllItems = new List<Budget_Planner_item__c> ();
        }

        //load debts
        String soql = LiabilitiesHelperFunctions.SoqlQuery('MMR_FF_Financial_Debts') + ' from Person_Debts__c where Owner_of_debt__c in' + AccountIds;
        List<Person_Debts__c> m_AllDebts = DataBase.Query(soql);

        ExOpp = [select Budget_Figures__c from HPP_extended_opportunity__c where opportunity__c = :opportunityId];

        if (ExOpp.Budget_Figures__c == null)
        {
            CalcBudget();
        }


        system.debug('DEBTS:' + m_AllDebts);
        for (BudgetPlannerConfig__c c : BudgetConfig)
        {
            budget_planner_item__c found;
            system.debug('Size Items :' + AllItems.size());
            for (Budget_Planner_item__c item : AllItems)
            {
                if (item.budgetPlannerConfig__c == c.id)
                {
                    system.debug('Found item : ' + item.name);
                    found = item;


                    if (c.Personal_Debt__c != null)
                    {
                        system.debug('Checking debts for ' + c.Personal_Debt__c);
                        Decimal value = 0;

                        for (Person_Debts__c d : m_AllDebts)
                        {
                            system.debug(c.Personal_Debt__c + ' == ' + d.Type_of_debt__c);
                            for (string debt : GetPersonalDebt(c.Personal_Debt__c)) // Handle comma separated PersonalDebts
                            {
                                if (debt == d.Type_of_debt__c)
                                {
                                    //update debt values
                                    system.debug('Calculating value for ' + d.Type_of_debt__c);
                                    value += CalculateMonthlyPayment(d, c);
                                }
                            }
                        }
                        system.debug('Setting ' + c.Personal_Debt__c + ' ' + item.name + ' to ' + value);
                        found.Applicant_Total__c = value;
                    }
                    break;
                }


            }
            if (found == null)
            {
                system.debug('New Item ' + c.name);
                found = new budget_planner_item__c();
                found.Opportunity__c = opportunityid;
                found.budgetplannerconfig__c = c.id;

                if (c.Personal_Debt__c != null)
                {
                    Decimal value = 0;
                    for (Person_Debts__c d : m_AllDebts)
                    {
                        for (string debt : GetPersonalDebt(c.Personal_Debt__c)) // Handle comma separated PersonalDebts in BudgetPlannerConfigs
                        {
                            if (debt == d.Type_of_debt__c)
                            {
                                if (d.Monthly_repayment__c != null)
                                {
                                    value += CalculateMonthlyPayment(d, c);
                                }
                            }
                        }
                    }
                    found.Applicant_Total__c = value;
                }
                else
                {
                    // With V2 we now use ONS figures if use_ONS_Only is set and also set all others to zero by default
                    if (is_BP_V2)
                    {
                        if (!c.IsStressed__c)
                        if (c.Use_ONS_Only__c)
                        {
                            found.Applicant_Total__c = ONS(c, ExOpp.Budget_Figures__c);
                        }
                        else
                        {
                            found.Applicant_Total__c = 0;
                        }
                    }
                }

                AllItems.add(found);
            }
        }

        //Integer i = 1/0;
        upsert AllItems;
        CreateMap();


    }

    public static decimal CalculateMonthlyPayment(Person_Debts__c debt, BudgetPlannerConfig__c config)
    {
        system.debug('Paid off : ' + debt.Will_this_debt_be_paid_off_by_this_app__c);
        if (debt.Will_this_debt_be_paid_off_by_this_app__c)
        return 0;

        system.debug('HPP Cleared : ' + debt.Cleared_before_HPP_starts__c);
        if (debt.Cleared_before_HPP_starts__c != null)
        {
            if (debt.Cleared_before_HPP_starts__c.equalsIgnoreCase('Yes'))
            {
                return 0;
            }
        }

        system.debug('Paid off within : ' + config.Paid_within_months__c);
        if (config.Paid_within_months__c != null)
        {
            Date paidOff = date.today().addMonths(integer.valueof(config.Paid_within_months__c));
            if (debt.PaidOffDebt__c != null)
            {
                system.debug('Paid off before : ' + paidOff + ' Paid: ' + debt.PaidOffDebt__c);
                if (debt.PaidOffDebt__c <= paidOff)
                {
                    return 0;
                }
            }
        }

        system.debug('Debt percent : ' + config.Monthly_payment_percent__c);
        if (config.Monthly_payment_percent__c != null)
        {
            system.debug('Debt balance: ' + debt.Outstanding_balance__c);
            if (debt.Outstanding_balance__c == null)
            return 0;

            if (debt.Monthly_repayment__c == null)
            return debt.Outstanding_balance__c * config.Monthly_payment_percent__c / 100;

            return debt.Monthly_repayment__c;
        }
        else
        {
            system.debug('Debt monthly payment: ' + debt.Monthly_repayment__c);
            if (debt.Monthly_repayment__c == null)
            return 0;

            return debt.Monthly_repayment__c;
        }
    }

    public void SaveData()
    {
        try
        {


            update AllItems;
            update Exopp;
            update bopp;
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

    public Integer NoCars { get; set; }
    public Integer NoDependants { get; set; }

    public PageReference Setup()
    {
        Accs = DataBase.Query('select id, name,No_of_depenents__c,Number_of_cars__c from account where id in ' + accountids);

        NoCars = 0;
        NoDependants = 0;
        for (Account a : accs)
        {
            if (a.Number_of_cars__c != null)
            NoCars += integer.valueof(a.Number_of_cars__c);
            if (a.No_of_depenents__c != null)
            NoDependants += integer.valueof(a.No_of_depenents__c);
        }
        CreateMap();
        GetItems();
        return null;
    }

    private string[] GetPersonalDebt(string origDebt)
    {
        return origDebt.split(',');
    }
}