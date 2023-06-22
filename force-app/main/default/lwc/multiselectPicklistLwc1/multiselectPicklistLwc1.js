import { LightningElement, track, api } from 'lwc';

export default class ExampleLWC extends LightningElement {
    @api npdata = [];
    @track optionItems =[{label:'Receive Salary Benefits', name:'Receive Salary Benefits', value:'Receive Salary Benefits'},
                      {label:'Domestic Transfers In Out', name:'Domestic Transfers In Out', value:'Domestic Transfers In Out'},
                      {label:'Pay Bills Expenses', name:'Pay Bills Expenses', value:'Pay Bills Expenses'}, 
                      {label:'International Transfers In Out', name:'International Transfers In Out', value:'International Transfers In Out'},
                      {label:'Cash Deposit In Out', name:'Cash Deposit In Out', value:'Cash Deposit In Out'},
                      {label:'Saving Goals', name:'Saving Goals', value:'Saving Goals'},
                      {label:'Account holding restricted funds', name:'Account holding restricted funds', value:'Account holding restricted funds'},
                      {label:'VREQ', name:'VREQ', value:'VREQ'}];

    @track optionItemsMaster = [     {label:'Receive Salary Benefits', name:'Receive Salary Benefits', value:'Receive Salary Benefits'},
                      {label:'Domestic Transfers In Out', name:'Domestic Transfers In Out', value:'Domestic Transfers In Out'},
                      {label:'Pay Bills Expenses', name:'Pay Bills Expenses', value:'Pay Bills Expenses'}, 
                      {label:'International Transfers In Out', name:'International Transfers In Out', value:'International Transfers In Out'},
                      {label:'Cash Deposit In Out', name:'Cash Deposit In Out', value:'Cash Deposit In Out'},
                      {label:'Saving Goals', name:'Saving Goals', value:'Saving Goals'},
                      {label:'Account holding restricted funds', name:'Account holding restricted funds', value:'Account holding restricted funds'},
                      {label:'VREQ', name:'VREQ', value:'VREQ'}
    ];
    allValuesteitems=[];
    @api isDisabledListener =false;

    handleValueChange(event){
        console.log('handleValueChange : MS detail: ', JSON.stringify(event.detail));
        const rowId = event.detail.selectedrecord;
        console.log('rowId :handleValueChange ',rowId);
        let selectedarr = [];
        console.log('event.detail.values  : ',event.detail.values);
        selectedarr = JSON.parse(JSON.stringify(event.detail.values));
        console.log('selectedarr  : ',selectedarr);
        let selectedValues = [];
        for(let key in selectedarr) { 
            selectedValues.push(selectedarr[key].name);
        }
        console.log('rowId :selectedValues ',selectedValues);
        console.log('this.npdata :selectedValues ',JSON.stringify(this.npdata));
        let clientnpdata = [];
        clientnpdata = JSON.parse(JSON.stringify(this.npdata));
        for(let key in clientnpdata) { 
            if(clientnpdata[key].caccId == rowId){
              clientnpdata[key].caccNPAccount = JSON.stringify(selectedValues);  
            }
        }
        console.log('clientnpdata : ', clientnpdata);

        const oEvent = new CustomEvent('changemultiselect',
        {
            detail: {cnpdata: clientnpdata }
        });
        this.dispatchEvent(oEvent);
    }
    
    handleMultiSelectPicklistChange(event) {
        const rowId = event.target.dataset.rowId;
        const selectedValues = event.detail.value;
        const rowIndex = this.npdata.findIndex(row => row.id === rowId);
        if (rowIndex > -1) {
            this.npdata[rowIndex].column3 = selectedValues;
        }
    }
}