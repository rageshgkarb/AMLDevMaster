import { api, LightningElement, track } from 'lwc';
import { CloseActionScreenEvent } from 'lightning/actions';

export default class RedirectToPreAppointmentScreening extends LightningElement {
    get recordId(){
        return this.recordId;
    }

    @api
    set recordId(value){
        this.dispatchEvent(new CloseActionScreenEvent());
        window.open("/apex/MMR_eligibility_Lightning?existingaccountid="+value, "_blank", "toolbar=yes,scrollbars=yes,resizable=yes,top=800,left=800,width=800,height=800");
    } 
}