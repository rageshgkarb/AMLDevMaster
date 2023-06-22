import { LightningElement,track,api,wire } from 'lwc';
import {LoadShow,LoadHide,getParameters} from 'c/caaUtility';
import { MessageContext } from 'lightning/messageService';
import ISASetup from '@salesforce/apex/CAA_Product_Detail_Controller_lightning.ISASetup';
import FTD from '@salesforce/apex/CAA_Product_Detail_Controller_lightning.FTD';
import COPCallout from '@salesforce/apex/COPAPIUtil.lwcexecute';

export default class Caa_FTD extends LightningElement {
    Product={
        MaturityTransferToInternalAccount : '',
        MaturityTransferToExternalAccount : '',
        MaturityTransferToExternalSortCode : '',
        MaturityTransferToExternalAccountName : '',
        ProfitTransferToExternalAccountName : '',
        ProfitTransferToExternalAccount : '',
        ProfitTransferToExternalSortCode : '',
        ProfitTransferToInternalAccount : '',
        ProfitMaturityTransferToExternalAccountName : '',
        ProfitMaturityTransferToExternalAccount : '',
        ProfitMaturityTransferToExternalSortCode : '',
        ProfitMaturityTransferToInternalAccount :''
    };
    @api 
    EventlogId;
    extId;
    ISAYears;
    opp;
    ISAYears;
    TermMonths;
    LessThanOr12Months;
    isMaturity = false;
    isProfit = false;
    isProfitMaturity = false;
    MaturityTransferToType = '';
    MaturityTransferExisting =false;
    MaturityTransferExternal = false;
    ProfitTransferExisting = false;
    ProfitTransferExternal = false;
    ProfitMaturityTransferExternal = false;
    ProfitMaturityTransferExisting = false;
    isCompleteButton = false;
    isErrorMessage = false;
    ErrorMessage = '';
    showTemplate = false;
    isExternalError=false;
    isExternalSuccess=false;
    ExternalErrorMessage1='';
    ExternalSuccessMessage1='';
    isExternalError2=false;
    isExternalSuccess2=false;
    ExternalErrorMessage2='';
    ExternalSuccessMessage2='';
    copVerifyButton1 = true;
    copVerifyButton2 = true; 
    MaturityTransferExternalbutton = false;
    ProfitTransferExternalButton = false;
    @wire(MessageContext)
    messageContext;
    async connectedCallback(){
         
            console.log("caaftd Lwc Comp Loaded");
            this.getQueryParameters();
            ISASetup({EventLogId:this.EventlogId,extid:this.extId})
                .then(result=>{
                console.log('Line no: 20'+result); 
                this.showTemplate = true;
                let wrap = result;
                this.TermMonths = wrap.TermMonths;
                this.LessThanOr12Months = wrap.LessThanOr12Months;
                console.log('this.LessThanOr12Months: '+this.LessThanOr12Months);
                }).catch(error=>{
                this.result=error;
                console.log(JSON.stringify(error));
                });

            console.log('EventLogId 76'+this.EventlogId);
            
    }
    
    getQueryParameters(){

        var params = {};

        var search = location.search.substring(1);

             if (search) {

            params = JSON.parse('{"' + search.replace(/&/g, '","').replace(/=/g, '":"') + '"}', (key, value) => 

            {
                return key === "" ? value : decodeURIComponent(value)

            });
            console.log(JSON.stringify(params));
            this.extId = params.extid;
            this.EventlogId = params.id;
            console.log('Event log ID 95:' +this.EventlogId );
            console.log('External ID 96: '+this.extid);
        
        }
    }

    onWhatToDoWithProfit(event){
        console.log(event.target.value);
        this.isMaturity =false;
        this.isProfit = false;
        this.isProfitMaturity = false;
        this.Product.WhatToDoWithProfit = event.target.value;
        if(this.Product.WhatToDoWithProfit == 'invest'){
            this.Product.ProfitTransferToInternalAccount = '';
            this.Product.ProfitTransferToType = '';
            this.Product.ProfitTransferToExternalAccountName = '';
            this.Product.ProfitTransferToExternalAccount = '';
            this.Product.ProfitTransferToExternalSortCode = '';
            this.ProfitTransferExternal = false;
            this.ProfitTransferExisting = false;
            this.isMaturity =true;
        }
        if(this.Product.WhatToDoWithProfit =='quarterly'){
            this.isProfit = true;
            this.isMaturity = true;
        }
        this.isCompleteButton = this.ShowCompleteButton();
        console.log('product data::'+JSON.stringify(this.Product));
    }
    //not using for now..
    OptionsOnMaturity(event){
        console.log(event.target.value);
        this.isMaturity =false;
        this.isProfit = false;
        this.isProfitMaturity = false;
        this.Product.OptionsOnMaturity = event.target.value;
        if(this.Product.OptionsOnMaturity  == 'retained'){
            this.isMaturity =true;
        }
        if(this.Product.OptionsOnMaturity  == 'external'){
            this.isProfit = true;
        }
        if(this.Product.OptionsOnMaturity  =='internal'){
            this.isProfitMaturity = true;
        }
        this.isCompleteButton = this.ShowCompleteButton();
        console.log(this.isCompleteButton );
    }
    
    onMaturityChange(event){
        this.Product[event.target.name] = event.target.value;
        console.log('this.Product.[this.event.name] '+this.Product[event.target.name]);
        console.log('isCompleteButton::'+this.isCompleteButton );
        if(this.Product.MaturityTransferToType == 'existing'){
            this.isCompleteButton = this.ShowCompleteButton();
        }
        if(this.Product.MaturityTransferToType == 'external'){
            if(this.Product.MaturityTransferToExternalAccountName!='' && this.Product.MaturityTransferToExternalAccount!='' 
            && this.Product.MaturityTransferToExternalSortCode!=''){
            console.log('filled all');
            this.copVerifyButton1=false;
            }else{
                this.copVerifyButton1=true;
            }
        }
        
    }

    onProfitChange(event){
        this.Product[event.target.name] = event.target.value;
        if(this.Product.ProfitTransferToType == 'existing'){
            this.isCompleteButton = this.ShowCompleteButton();
        }

        if(this.Product.ProfitTransferToType == 'external'){
            if(this.Product.ProfitTransferToExternalAccountName!='' && this.Product.ProfitTransferToExternalAccount!='' 
            && this.Product.ProfitTransferToExternalSortCode!=''){
            console.log('filled all');
            this.copVerifyButton2=false;
            }else{
                this.copVerifyButton2=true;
            }
        }
    }

    onMaturityTransferToType(event){
        this.MaturityTransferExisting =false;
        this.MaturityTransferExternal = false;
        this.MaturityTransferExternalbutton = false;
        this.isErrorMessage = false;
        this.Product.MaturityTransferToType =event.target.value;
        if(this.Product.MaturityTransferToType == 'existing'){
            this.MaturityTransferExisting =true;
        }
        if(this.Product.MaturityTransferToType == 'external'){
            this.MaturityTransferExternal = true;
            this.MaturityTransferExternalbutton = true;
        }
        this.isCompleteButton = this.ShowCompleteButton();
        console.log(this.isCompleteButton );
    }

    onProfitTransferToType(event){
        this.ProfitTransferExisting =false;
        this.ProfitTransferExternal = false;
        this.ProfitTransferExternalButton = false;
        this.isErrorMessage = false;
        this.Product.ProfitTransferToType =event.target.value;
        if(this.Product.ProfitTransferToType == 'existing'){
            this.ProfitTransferExisting =true;
        }
        if(this.Product.ProfitTransferToType == 'external'){ 
            this.ProfitTransferExternal = true;
            this.ProfitTransferExternalButton = true;
        }
        this.isCompleteButton = this.ShowCompleteButton();

    }

    onProfitMaturityTransferToType(event){
        this.ProfitMaturityTransferExternal = false;
        this.ProfitMaturityTransferExisting = false;
        this.isErrorMessage = false;
        this.Product.ProfitMaturityTransferToType =event.target.value;
        if(this.Product.ProfitMaturityTransferToType == 'existing'){
            this.ProfitMaturityTransferExisting =true;
        }
        if(this.Product.ProfitMaturityTransferToType == 'external'){    
            this.ProfitMaturityTransferExternal = true;
        }
    }

   

    ShowCompleteButton(){
		console.log('this.Product line 153: '+JSON.stringify(this.Product));
		if(!this.Product ||  (!this.Product.OptionsOnMaturity && !this.Product.WhatToDoWithProfit) ){
            console.log('situation 1:0');
            return false;
        } 
        //for 'At maturity option'
		if(this.Product.WhatToDoWithProfit && this.Product.WhatToDoWithProfit=='invest') {
            console.log('line 157');
            return this.MaturityValid();
        }
 
		if(this.Product.WhatToDoWithProfit && this.Product.WhatToDoWithProfit=='quarterly'){
            console.log('into fdsjfds');
            return this.MaturityValid() && this.ProfitValid();
        } 
		
		return true; 	
	}	

    MaturityValid(){
        
        console.log("MaturityValid");
        console.log('line 165:' +JSON.stringify(this.Product));
	if(!this.Product.MaturityTransferToType) return false;
	
	if(this.Product.MaturityTransferToType == 'existing'){
        console.log('line no 229');
        console.log('value of exiting account::'+this.Product.MaturityTransferToInternalAccount);
        console.log('value of exiting account T/F::'+(!this.Product.MaturityTransferToInternalAccount));
        console.log('length check::'+this.Product.MaturityTransferToInternalAccount.toString().length);
        console.log('nan check--'+isNaN(this.Product.MaturityTransferToInternalAccount));
	    if(this.Product.MaturityTransferToInternalAccount==null || 
        (this.Product.MaturityTransferToInternalAccount.toString().length != 8 || isNaN(this.Product.MaturityTransferToInternalAccount))){
            console.log('condition succeeded');
            return false;
        } 
	}

	if(this.Product.MaturityTransferToType == 'external'){
        console.log('line 184: '+this.Product.MaturityTransferToExternalSortCode);
	    if(!this.Product.MaturityTransferToExternalAccount || !this.Product.MaturityTransferToExternalSortCode) return false;
	    if(this.Product.MaturityTransferToExternalAccount.toString().length != 8  || this.Product.MaturityTransferToExternalSortCode.toString().length != 6) return false;
        if(!this.isExternalSuccess) return false;
	}
	return true;
    }

    ProfitValid(){
        console.log("ProfitValid");
    if(!this.Product.ProfitTransferToType){
        console.log('line 245');
        return false;
    } 

    if(this.Product.ProfitTransferToType == 'existing'){
        console.log('line 250');
        // if(!this.Product.ProfitTransferToInternalAccount || this.Product.ProfitTransferToInternalAccount.toString().length != 8){
        //     console.log('line 252');
        //     return false;
        // } 

        if(this.Product.ProfitTransferToInternalAccount.toString().length != 8 || isNaN(this.Product.ProfitTransferToInternalAccount)){
            console.log('condition succeeded');
            return false;
        } 
    }

    if(this.Product.ProfitTransferToType == 'external'){
        console.log('external succeeded');
        if(!this.Product.ProfitTransferToExternalAccount || !this.Product.ProfitTransferToExternalSortCode) return false;
        if((this.Product.ProfitTransferToExternalAccount.toString().length != 8 && !isNaN(this.Product.ProfitTransferToExternalAccount))|| this.Product.ProfitTransferToExternalSortCode.toString().length != 6) return false;
        if(!this.isExternalSuccess2) return false;

    }
    console.log('returned true');
    return true;
    }

    Complete(){
        console.log('Entering into complete function');
        console.log('this.EventlogId 227: '+this.EventlogId);

        if(!this.EventlogId) return null;                
        // --serviceApplication.LoadShow('Processing...');
        LoadShow('Processing...',this.messageContext);
        FTD({eventLogId : this.EventlogId,data: this.Product})
        .then(result=>{
            console.log(JSON.stringify(result));
                if(result.Success)
                {
                    this.SuccessMessage = 'Completed';
                    if(result.URL)
                    {
                        console.log(result.URL.FormatURL());//$window.location.href = result.URL.FormatURL();
                        window.location.href = result.URL.FormatURL();
                    }
                    else
                    {                                
                        console.log('else part LoadHide'); //-- serviceApplication.LoadHide(false);
                        LoadHide(false,this.messageContext);
                    } 
                }
                else
                {
                    console.log('Result not success Load hide'); //---serviceApplication.LoadHide(false);
                    LoadHide(false,this.messageContext);
                this.ErrorMessage = result.Error;
                this.isErrorMessage = true;
                }
            }).catch(error =>{
                serviceApplication.LoadHide(false); 
                this.ErrorMessage = error;
                console.log('JS Catch Load Hide' + JSON.stringify(error)); //---serviceApplication.LoadHide(false);
                LoadHide(false,this.messageContext);
            }
           );
    }

    CopExternalAccountMaturity(){
        COPCallout({
                name:this.Product.MaturityTransferToExternalAccountName,
                accountNumber: this.Product.MaturityTransferToExternalAccount,
                sortCode: this.Product.MaturityTransferToExternalSortCode,
                accountType:'Business'
            }).then(result => {
            console.log(JSON.stringify(result));
            console.log('result message ReasonCode;::'+result.ReasonCode);
            if(result.Code=='ERROR' || result.StatusCode=='500'){
                this.showCopErrorMessage(result.Code,'ExternalErrorMessage1')
            }else{
                this.showCopSuccessMessage(result.ReasonCode,'ExternalSuccessMessage1');
            }

        }) .catch(error => {
            this.ExternalErrorMessage1=error;
            console.log(error);
            this.isExternalError=true;
        }); 
    }

    CopExternalAccountProfit(){
        COPCallout({
                name:this.Product.ProfitTransferToExternalAccountName,
                accountNumber: this.Product.ProfitTransferToExternalAccount,
                sortCode: this.Product.ProfitTransferToExternalSortCode,
                accountType:'Business'
            }).then(result => {
            console.log(JSON.stringify(result));
            console.log('result message ReasonCode;::'+result.ReasonCode);
            if(result.Code=='ERROR' || result.StatusCode=='500'){
                this.showCopErrorMessage(result.Code,'ExternalErrorMessage2')
            }else{
                this.showCopSuccessMessage(result.ReasonCode,'ExternalSuccessMessage2');
            }

        }) .catch(error => {
            this.ExternalErrorMessage2=error;
            console.log(error);
            this.isExternalError2=true;
        }); 
    }

    showCopSuccessMessage(successMessage,messagePlaceholder){
        if(messagePlaceholder=='ExternalSuccessMessage1'){
            console.log('successMessgae::'+successMessage);
            this.MaturityTransferExternalbutton=false;
            this.isExternalSuccess=true;
            this.ExternalSuccessMessage1=successMessage;
            this.isCompleteButton = this.ShowCompleteButton();
        }

        if(messagePlaceholder=='ExternalSuccessMessage2'){
            this.ProfitTransferExternalButton = false;
            this.isExternalSuccess2=true;
            this.ExternalSuccessMessage2=successMessage;
            this.isCompleteButton = this.ShowCompleteButton();
        }

    }

    showCopErrorMessage(errorMessage,messagePlaceholder){
        console.log('errorMessage::'+errorMessage);

        if(messagePlaceholder=='ExternalErrorMessage1'){
            this.isExternalError1=true;
            this.ExternalErrorMessage1=errorMessage;
        }

        if(messagePlaceholder=='ExternalErrorMessage2'){
            this.isExternalError2=true;
            this.ExternalErrorMessage2 = errorMessage;
        }

    }

}