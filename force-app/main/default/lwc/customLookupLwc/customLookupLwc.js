import { LightningElement,api,wire} from 'lwc';
// import apex method from salesforce module 
//import fetchLookupData from '@salesforce/apex/CustomLookupLwcController.fetchLookupData';
import fetchLookupRecs from '@salesforce/apex/CustomLookupLwcController.fetchLookupRecs';

const DELAY = 300; // dealy apex callout timing in miliseconds  

export default class CustomLookupLwc extends LightningElement {
    // public properties with initial default values 
    @api label = 'Review Prepared ';
    @api placeholder = 'User'; 
    @api iconName = 'standard:user';
    @api sobjectapiname = 'User';
    isAccount = false;
    // private properties 
    lstResult = []; // to store list of returned records   
    hasRecords = true; 
    searchKey=''; // to store input field value    
    isSearchLoading = false; // to control loading spinner  
    delayTimeout;
    @api selectedrecord = {}; // to store selected lookup record in object formate 
    @api isDisabledListener=false;
    
    connectedCallback() {
        if(this.sobjectapiname == 'Account'){
            this.isAccount = true;
        }
        this.refresh();
        console.log('selectedrecord connectedCallback : ',JSON.stringify(this.selectedrecord));
        if(this.selectedrecord.Id != null){
            //this.handelSelectRecordHelper();
        }
    }

    renderedCallback(){
        console.log('selectedrecord renderedCallback : ',JSON.stringify(this.selectedrecord));
        if(this.selectedrecord.Id != null){
            this.handelSelectRecordHelper();
        }
    }
   
   refresh() {
       this.showspinner = true;
        fetchLookupRecs({searchKey: this.searchKey, sObjectApiName: this.sobjectapiname})
            .then(result => {
                if(result.status == 'SUCCESS'){
                    this.isSearchLoading = false;
                    let data = result.data;
                    this.hasRecords = data.length == 0 ? false : true; 
                    this.lstResult = data; 
                    this.showspinner = false;
                }else{
                    this.showspinner = false;
                    console.log('result error Msg : ',result);
                }
                
            })
            .catch(error => {
                this.showspinner = false;
                this.error = error;
            });
    }

    // wire function property to fetch search record based on user input
    /*@wire(fetchLookupData, { searchKey: '$searchKey' , sObjectApiName : '$sobjectapiname' })
     searchResult(value) {
        const { data, error } = value; // destructure the provisioned value
        this.isSearchLoading = false;
        if (data) {

             this.hasRecords = data.length == 0 ? false : true; 
             this.lstResult = JSON.parse(JSON.stringify(data)); 
         }
        else if (error) {
            console.log('(error---> ' + JSON.stringify(error));
         }
    };*/
       
  // update searchKey property on input field change  
    handleKeyChange(event) {
        // Debouncing this method: Do not update the reactive property as long as this function is
        // being called within a delay of DELAY. This is to avoid a very large number of Apex method calls.
        
        this.isSearchLoading = true;
        const searchKey = event.target.value;
        this.searchKey = searchKey;
        this.refresh();
    }


    // method to toggle lookup result section on UI 
    toggleResult(event){
        const lookupInputContainer = this.template.querySelector('.lookupInputContainer');
        const clsList = lookupInputContainer.classList;
        const whichEvent = event.target.getAttribute('data-source');
        switch(whichEvent) {
            case 'searchInputField':
                clsList.add('slds-is-open');
               break;
            case 'lookupContainer':
                clsList.remove('slds-is-open');    
            break;                    
           }
    }

   // method to clear selected lookup record  
   handleRemove(){
    this.searchKey = '';    
    this.selectedrecord = {};
    this.lookupUpdatehandler(undefined); // update value on parent component as well from helper function 
    
    // remove selected pill and display input field again 
    const searchBoxWrapper = this.template.querySelector('.searchBoxWrapper');
     searchBoxWrapper.classList.remove('slds-hide');
     searchBoxWrapper.classList.add('slds-show');

     const pillDiv = this.template.querySelector('.pillDiv');
     pillDiv.classList.remove('slds-show');
     pillDiv.classList.add('slds-hide');
  }

  // method to update selected record from search result 
handelselectedrecord(event){   
     var objId = event.target.getAttribute('data-recid'); // get selected record Id 
     this.selectedrecord = this.lstResult.find(data => data.Id === objId); // find selected record from list 
     console.log('this.selectedrecord : ',JSON.stringify(this.selectedrecord));
     this.lookupUpdatehandler(this.selectedrecord); // update value on parent component as well from helper function 
     this.handelSelectRecordHelper(); // helper function to show/hide lookup result container on UI
}

/*COMMON HELPER METHOD STARTED*/

handelSelectRecordHelper(){
    this.template.querySelector('.lookupInputContainer').classList.remove('slds-is-open');

     const searchBoxWrapper = this.template.querySelector('.searchBoxWrapper');
     searchBoxWrapper.classList.remove('slds-show');
     searchBoxWrapper.classList.add('slds-hide');

     const pillDiv = this.template.querySelector('.pillDiv');
     pillDiv.classList.remove('slds-hide');
     pillDiv.classList.add('slds-show');  

    if(this.sobjectapiname == 'Account'){
            
        this.searchKey = '';    
        this.selectedrecord = {};
        //this.lookupUpdatehandler(undefined); // update value on parent component as well from helper function 
        //alert('handelSelectRecordHelper ');
        // remove selected pill and display input field again 
        //const searchBoxWrapper = this.template.querySelector('.searchBoxWrapper');
        searchBoxWrapper.classList.remove('slds-hide');
        searchBoxWrapper.classList.add('slds-show');

        //const pillDiv = this.template.querySelector('.pillDiv');
        pillDiv.classList.remove('slds-show');
        pillDiv.classList.add('slds-hide');   
    }
}

// send selected lookup record to parent component using custom event
lookupUpdatehandler(value){   
    const oEvent = new CustomEvent('lookupupdate',
    {
        'detail': {selectedrecord: value, field: this.label }
    });
    this.dispatchEvent(oEvent);

    
}


}