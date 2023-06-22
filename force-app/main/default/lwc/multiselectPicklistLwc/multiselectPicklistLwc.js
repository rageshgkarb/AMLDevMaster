import { LightningElement, api, wire, track } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';

export default class multiselectPicklist extends NavigationMixin(LightningElement)
{   
  @track values;
  @api items;
  @api itemsMaster=[];
  @track allValuesteitems=[];
  @api picklistName;
  @api picklistLabel;
  @api picklistPlaceholder;
  @api rowid;


  handleChangeItems(event) {
    this.value = event.target.value;
    if(!this.allValuesteitems.includes(this.value)){
      const q =this.itemsMaster.filter(elem=>{
          if(elem.name == this.value){
            return elem;
          }
        });
        console.log('q : ',JSON.parse(JSON.stringify(q)));
        this.allValuesteitems.push(q[0]);
    }
    this.allValuesteitemsDispatch();
    this.modifyOptionsitems();
  }

  handleItemRemove(event){
     this.value='';
      const valueRemoved = event.detail.item.name;
      console.log('valueRemoved : '+valueRemoved);
      console.log('this.allValues  : ',this.allValuesteitems);
      let i = 0;
      this.allValuesteitems.filter(elem=>{
          console.log('elem.name : ',elem.name);
          i++;
          if(elem.name == valueRemoved){
            console.log('valueRemoved : ',valueRemoved);
            console.log('i : ',i);
            this.allValuesteitems.splice(i-1,1);
          }
        });  
      this.allValuesteitemsDispatch();
      this.modifyOptionsitems();  

  }


  modifyOptionsitems()
  {
    //console.log('this.allValuesteitems : '+this.allValuesteitems);
    this.items=this.itemsMaster.filter(elem=>{
      //console.log('elem.name : '+elem.name);
      if(!this.allValuesteitems.includes(elem))
        return elem;
    });
  }

  allValuesteitemsDispatch(){
    console.log('rowid : ',this.rowid);
    console.log('called child dispatch');
    const evt = new CustomEvent('valuechange',{
      detail: {selectedrecord: this.rowid, values: this.allValuesteitems }
    });
    this.dispatchEvent(evt);
  }
}