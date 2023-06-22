import { LightningElement, track,api } from 'lwc';
import getAsset from '@salesforce/apex/UpdateSourceOfFunds.getAsset';
import saveAsset from '@salesforce/apex/UpdateSourceOfFunds.saveAsset';

const TABLE1_COLUMNS = [
    { label: 'Name', fieldName: 'name', editable: false },
    {
        label: 'Change Since Last Review',
        fieldName: 'change',
        type: 'picklistColumn',
        editable: true,
        typeAttributes: {
            placeholder: 'Select an Option',
            options: { fieldName: 'pickListOptions' }
        }
    },
       
    { label: 'Comments', fieldName: 'comments', type: 'text', editable: true }
];

export default class DataTables extends LightningElement {
    showspinner;
    @api eddidfromparent;

    connectedCallback(){
        console.log('this.eddidfromparent  DataTables'+this.eddidfromparent);
        this.refresh();
    } 

     refresh() {
       this.showspinner = true;
        getAsset({eddId:this.eddidfromparent})
            .then(result => {
                if(result.status == 'SUCCESS'){
				this.showspinner = false;
                    console.log('result.assetSOWF : getAsset '+JSON.stringify(result.assetSOWF));
                    this.table1Data = JSON.parse(JSON.stringify(result.assetSOWF));
                }else{
                    this.showspinner = false;
                    console.log('result error Msg : ',result.statusMsg);
                }
                
            }).catch(error => {
                this.showspinner = false;
                this.error = error;
            });

        }
    
    @track table1Data = [];

   

    get table1Columns() {
        return TABLE1_COLUMNS;
    }

    handleTable1Save(event) {
        if(this.eddidfromparent == undefined){
            alert('Please save EDD to move ahead');
        }
        const draftValues = event.detail.draftValues;
        console.log(draftValues[0]);
        console.log(this.table1Data[draftValues[0].id-1]);
        for(let obj=0;obj<this.table1Data.length;obj++){
            for(let changes in draftValues[0]){
                if(this.table1Data[obj].id==draftValues[0].id){
                    this.table1Data[obj][changes]=draftValues[0][changes];
                }
                this.table1Data[obj].eddId = this.eddidfromparent;
                this.table1Data[obj].source = 'Source Of Funds';
            }
        }

        console.log('278 line'+ JSON.stringify(this.table1Data));
        this.template.querySelector("c-l-w-c-custom-datatable-type").draftValues = [];
        this.showspinner = true;
        //apexcall
        saveAsset({assetData:JSON.stringify(this.table1Data)})
        .then(result => {
            if(result.status == 'SUCCESS'){
            this.showspinner = false;
                console.log('result.assetSOWF : '+JSON.stringify(result.assetSOWF));
                this.table1Data = JSON.parse(JSON.stringify(result.assetSOWF));
            }else{
                this.showspinner = false;
                console.log('result error Msg : ',result.statusMsg);
            }
            
        })
        .catch(error => {
            this.showspinner = false;
            this.error = error;
        });

    }
}