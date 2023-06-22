import { LightningElement, track,api } from 'lwc';
import getAsset from '@salesforce/apex/UpdateSourceOfWealth.getAsset';
import saveAsset from '@salesforce/apex/UpdateSourceOfWealth.saveAsset';
import deleteAsset from '@salesforce/apex/UpdateSourceOfWealth.deleteAsset';


export default class DataTables extends LightningElement {
    showspinner;
    @api eddidfromparent;
    @api type;
    @api referenceId;
    @api isDisabledListener;
    @api tableLabel;
    @track table1Columns = [];
    @track table1Data = [];
    totalValue=0;

    connectedCallback(){
        console.log('this.eddidfromparent  DataTables '+this.eddidfromparent);
        console.log('this.type  DataTables '+this.type);
        console.log('this.referenceId ',this.referenceId);
        this.refresh();
        setTimeout(() => {
            this.calTotalAssets();
        }, 2000);
    }  

    refresh() {
        this.showspinner = true;
        this.table1Columns=[
            { label: 'Name', fieldName: 'name', editable: false },
            { label: 'Value', fieldName: 'value', type: 'text', editable:!this.isDisabledListener },
            {
                label: 'Change Since Last Review',
                fieldName: 'change',
                type: 'picklistColumn',
                editable: !this.isDisabledListener,
                typeAttributes: {
                    placeholder: 'Select an Option',
                    options: { fieldName: 'pickListOptions' }
                }
            },
            
            { label: 'Comments', fieldName: 'comments', type: 'text', editable: !this.isDisabledListener }
        ];
        getAsset({eddId:this.eddidfromparent,type: this.type,referenceId: this.referenceId})
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
           
    handleTable1Save(event){

        if(this.eddidfromparent == undefined){
            alert('Please save EDD to move ahead');
            return;
        }
        const draftValues = event.detail.draftValues;
        console.log(draftValues);
        if(draftValues[0].id.slice(0,3)=='row'){
            const row = Number(draftValues[0].id.slice(-1));
            console.log(row);
            for(let changes in draftValues[0]){
                if(changes!='id'){
                    this.table1Data[row][changes]=draftValues[0][changes];
                }
            }
        }

        //handleUpdateClick(draftValues);
        for(let obj=0;obj<this.table1Data.length;obj++){
            for(let changes in draftValues[0]){
                if(this.table1Data[obj].id==draftValues[0].id){
                    this.table1Data[obj][changes]=draftValues[0][changes];
                }
                this.table1Data[obj].value=Number(this.table1Data[obj].value).toFixed(2);
                this.table1Data[obj].eddId = this.eddidfromparent;
                this.table1Data[obj].source = 'Source Of Wealth';
                this.table1Data[obj].typeOfSource = this.type;
                this.table1Data[obj].referenceId = this.referenceId;
            }
        }
        this.calTotalAssets();
        console.log('calTotalAssets : '+ JSON.stringify(this.table1Data));
        this.template.querySelector("c-l-w-c-custom-datatable-type").draftValues = [];
        console.log('before save');
        this.showspinner = true;
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

    calTotalAssets(){
        
        for(let obj=0;obj<this.table1Data.length;obj++){
            this.totalValue+=Number(this.table1Data[obj].value);
        }
        const event1 = new CustomEvent('totalassetupdate',
        {
            'detail': this.totalValue,
            'id':this.referenceId
        });
        this.dispatchEvent(event1);
        console.log('event dispatched');
    }
   
    @api handleDeleteTable(tableid) {
        console.log(tableid);
        console.log(this.eddidfromparent);
        deleteAsset({referenceId: tableid,eddId: this.eddidfromparent});
    }
    
    @api handleDisable(){
        const clone = [
            { label: 'Name', fieldName: 'name', editable: false },
            { label: 'Value', fieldName: 'value', type: 'text', editable: false },
            {
                label: 'Change Since Last Review',
                fieldName: 'change',
                type: 'picklistColumn',
                editable: false,
                typeAttributes: {
                    placeholder: 'Select an Option',
                    options: { fieldName: 'pickListOptions' }
                }
            },
      
            { label: 'Comments', fieldName: 'comments', type: 'text', editable: false }
        ];
        console.log('updated tablecolumes',clone);
        this.table1Columns = clone;
    }
}