import { LightningElement,api,wire,track } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import eddformbase from 'c/eddformbase';
import getCustomerDetails from '@salesforce/apex/EDDFormHandler.getCustomerDetails';
import save from '@salesforce/apex/EDDFormHandler.save';
export default class EDDForm extends eddformbase {
    linkAccIds = [];
    toLinkAccs = [];
    selectedAccs = [];
    custAccs = [];
    changecustAccs = [];
    sows = [];
    sofs = [];
    AssetsLiabs = [];
    linkacc;
    templinkacc;
    @track flagIndicatingDataHasBeenLoadedInVariables = false;
    @track kycselectedDate;
    @track RMdateofApproval;
    @track MLROdateofApproval;
    @track AMLOCdateofApproval;
    @track IssuedDate;
    @track NextRenewalDate;
    referenceText = '';
    jsonReferenceName = [];
    buttonStatus = true;
    submitEDDform = false;
    datatableStatus =!this.submitEDDform;
    @track relatedCustomerAccounts = [];
    
    columnsList = [{ label: 'Signatory Customer', fieldName: 'accountHolderName', editable: false }];
    
   @track relatedCustomerEntity = [];

    entitycolumnsList = [{ label: 'Related Customer Entity', fieldName: 'relatedCustomerEntities', editable: false }]; 
    
    // data = [{ id: '1', name: 'Document 1', type: 'ID', location: 'Location 1', issuedDate: '2022-01-01', nextRenewalDate: '2023-01-01', comments: 'Comment 1' },      { id: '2', name: 'Document 2', type: 'POA', location: 'Location 2', issuedDate: '2022-02-01', nextRenewalDate: '2023-02-01', comments: 'Comment 2' },      { id: '3', name: 'Document 3', type: 'SOW', location: 'Location 3', issuedDate: '2022-03-01', nextRenewalDate: '2023-03-01', comments: 'Comment 3' }    ];

    // IDVcolumns = [{ label: 'Document name', fieldName: 'name', type: 'text' },{ label: 'Purpose', fieldName: 'type', type: 'picklist', options: [{ label: 'ID', value: 'ID' },{ label: 'POA', value: 'POA' },{ label: 'SOW', value: 'SOW' },{ label: 'SOF', value: 'SOF' },{ label: 'Other', value: 'Other' }]
    //   },
    //   { label: 'Location', fieldName: 'location', type: 'picklist', 
    //     options: [
    //       { label: 'Location 1', value: 'Location 1' },
    //       { label: 'Location 2', value: 'Location 2' },
    //       { label: 'Location 3', value: 'Location 3' },
    //       { label: 'Location 4', value: 'Location 4' },
    //       { label: 'Other', value: 'Other' }
    //     ]
    //   },
    //   { label: 'Issued Date', fieldName: 'issuedDate', type: 'date' },
    //   { label: 'Next renewal date', fieldName: 'nextRenewalDate', type: 'date' },
    //   { label: 'Comments', fieldName: 'comments', type: 'text' }
    // ];
    
    allValuesteitems=[];

    connectedCallback(){
        console.log('This is value I got from Visualforce page '+this.recordId);
        console.log('data table status',this.datatableStatus);
        this.refresh();
        setTimeout(() => {
            this.handleTableLoad();
        }, 5000);
        
   }  

   refresh() {
       this.showspinner = true;
       
        getCustomerDetails({caseRecordId:this.recordId})
            .then(result => {
                
                console.log('getCustomerDetails : ',JSON.parse(JSON.stringify(result)));
                if(result.status == 'SUCCESS'){
                    this.customerDetail = result.customerDetails;
                    this.toLinkAccs = result.customerDetails.linkaccounts;
                    this.relatedCustomerAccounts = result.customerDetails.accountHolders;
                    this.relatedCustomerEntity = result.customerDetails.relatedCustomerEntity;
                    this.custAccs = result.customerDetails.customeraccounts;
                    console.log('this.custAccs : ',JSON.stringify(this.custAccs));
                    this.sows = result.sow;
                    console.log('this.customerDetail : ',this.customerDetail);
                    this.reviewType = this.customerDetail.reviewType;
                    if(this.customerDetail.relationshipManager != undefined && this.customerDetail.relationshipManager != null){
                        this.relationshipManager = this.customerDetail.relationshipManager;
                        console.log('this.relationshipManager : '+this.relationshipManager);
                    }
                    
                    this.department = this.customerDetail.department;
                    this.customerName = this.customerDetail.customerName;
                    this.caseNumberTitle = 'EDD Case : '+this.customerDetail.eddReviewCaseNo;
                    this.caseNumber = this.customerDetail.eddReviewCaseNo;
                    this.caseId = this.customerDetail.caseId;
                    this.ebsId = this.customerDetail.ebsId;
                    this.eddId = this.customerDetail.eddId;
                    this.itemCount = this.customerDetail.itemCount;
                    this.jsonReferenceName = JSON.parse(this.customerDetail.jsonReferenceName);
                    console.log('getCustomerDetails this.eddId : ',this.eddId);
                    console.log('this is itemcount '+this.itemCount);
                    this.accountId = this.customerDetail.accountId;
                    this.riskRating = this.customerDetail.riskRating;
                    this.reviewPreparedBy = this.customerDetail.reviewPreparedBy;
                    if(this.customerDetail.relationshipManagerWrap != undefined && this.customerDetail.relationshipManagerWrap != null){
                        this.relationshipManagerWrap = this.customerDetail.relationshipManagerWrap;
                        console.log('this.relationshipManagerWrap  : ',this.relationshipManagerWrap);
                    }
                    if(this.customerDetail.reviewPreparedByWrap != undefined && this.customerDetail.reviewPreparedByWrap != null){
                        this.reviewPreparedByWrap = this.customerDetail.reviewPreparedByWrap;
                        console.log('this.reviewPreparedByWrap  : ',this.reviewPreparedByWrap);
                    }
                    this.onboardingcaseno = this.customerDetail.onboardingcaseno;
                    if(this.customerDetail.onboardingCasenoWrap != undefined && this.customerDetail.onboardingCasenoWrap != null){
                        this.onboardingCasenoWrap = this.customerDetail.onboardingCasenoWrap;
                        console.log('this.onboardingCasenoWrap  : ',this.onboardingCasenoWrap);
                    }

                     this.kycAnalyst = this.customerDetail.kycAnalyst;
                    if(this.customerDetail.kycAnalystWrap != undefined && this.customerDetail.kycAnalystWrap != null){
                        this.kycAnalystWrap = this.customerDetail.kycAnalystWrap;
                        console.log('this.kycAnalystWrap  : ',this.kycAnalystWrap);
                    }
                    this.mlroName = this.customerDetail.mlroName;
                    if(this.customerDetail.mlroWrap != undefined && this.customerDetail.mlroWrap != null){
                        this.mlroWrap = this.customerDetail.mlroWrap;
                        console.log('this.mlroWrap  : ',this.mlroWrap);
                    }

                    this.dateOfSubmission = this.customerDetail.dateOfSubmission;
                    this.entityType = this.customerDetail.entityType;
                    console.log('entity type', this.entityType);
                    this.registeredAddress = this.customerDetail.registeredAddress;
                    this.tradingAddress = this.customerDetail.tradingAddress;
                    this.registrationNumber = this.customerDetail.registrationNumber;
                    this.countryOfIncorporation = this.customerDetail.countryOfIncorporation;
                    this.contactMethod = this.customerDetail.contactMethod;
                    this.contactLastMade = this.customerDetail.contactLastMade;
                    this.methodMostRecentContact = this.customerDetail.methodMostRecentContact;
                    this.customerConvertedDate = this.customerDetail.customerConvertedDate;
                    this.sourceOfFunds = this.customerDetail.sourceOfFunds;
                    this.sourceOfFundsCountry = this.customerDetail.sourceOfFundsCountry;
                    this.internationalFundTransferFrequency = this.customerDetail.internationalFundTransferFrequency;
                    this.intFundTransferSource = this.customerDetail.intFundTransferSource;
                    this.estMonthlyVolumeInward = this.customerDetail.estMonthlyVolumeInward;
                    this.estMonthlyVolumeOutward = this.customerDetail.estMonthlyVolumeOutward;
                    this.estCashWithdrawalFrequency = this.customerDetail.estCashWithdrawalFrequency;
                    this.estCashDeprequency = this.customerDetail.estCashDeprequency;
                    this.overallCompCreditTurnover = this.customerDetail.overallCompCreditTurnover;
                    this.expAnnualTurnover = this.customerDetail.expAnnualTurnover;
                    this.EDDsupportinginformation = this.customerDetail.EDDsupportinginformation;
                    this.SourceofComments = this.customerDetail.SourceofComments;
                    this.sofChangesince = this.customerDetail.sofChangesince;
                    this.rationalePepStatus = this.customerDetail.rationalePepStatus;
                    this.IDVValidationComments = this.customerDetail.IDVValidationComments;
                    this.SanctionsScreeningComments= this.customerDetail.SanctionsScreeningComments;
                    this.PepComments = this.customerDetail.PepComments;
                    this.AdversMediaMatchComments = this.customerDetail.AdversMediaMatchComments;
                    this.IDVvalidationcheck = this.customerDetail.IDVvalidationcheck;
                    this.kycselectedDate = this.customerDetail.kycselectedDate;
                    this.pepScreeningmatch = this.customerDetail.pepScreeningmatch;
                    this.sanctionsscreeningmatch = this.customerDetail.sanctionsscreeningmatch;
                    this.AdverseMediaScreeningPositiveMatchplusmatchtype = this.customerDetail.AdverseMediaScreeningPositiveMatchplusmatchtype;
                    this.adversemediamatch = this.customerDetail.adversemediamatch;
                    this.KYCRecommendation = this.customerDetail.KYCRecommendation;
                    this.KycAnalystComments =this.customerDetail.KycAnalystComments;
                    this.RMRecomComments =this.customerDetail.RMRecomComments;
                    this.RMRecommendation = this.customerDetail.RMRecommendation;
                    this.MLROCRAOverride = this.customerDetail.MLROCRAOverride;
                    this.RationaleforMLROCRAOverride = this.customerDetail.RationaleforMLROCRAOverride;
                    this.MLRORecommendation = this.customerDetail.MLRORecommendation;
                    this.MLRORecomComments = this.customerDetail.MLRORecomComments;
                    this.AMLOCRecomComments = this.customerDetail.AMLOCRecomComments;
                    this.AMLOCRecommendation = this.customerDetail.AMLOCRecommendation;
                    this.abtCustomer = this.customerDetail.abtCustomer;
                    this.corporatestructure = this.customerDetail.corporatestructure;
                    this.rrcorporatestructure = this.customerDetail.rrcorporatestructure;
                    this.spvtrust = this.customerDetail.spvtrust;
                    this.reasonEntityType = this.customerDetail.reasonEntityType;
                    this.structurecomplex = this.customerDetail.structurecomplex;
                    this.IDVsatisfied = this.customerDetail.IDVsatisfied;
                    this.ScreenedParties = this.customerDetail.ScreenedParties;
                    this.PEPScreeningPositiveMatch = this.customerDetail.PEPScreeningPositiveMatch;
                    this.ScreenedRelationship = this.customerDetail.ScreenedRelationship;
                    this.SanctionScreeningPositiveMatch = this.customerDetail.SanctionScreeningPositiveMatch;
                    this.ScreenedPartiesComments = this.customerDetail.ScreenedPartiesComments;
                    this.IDVPurpose = this.customerDetail.IDVPurpose;
                    this.IDVLocation = this.customerDetail.IDVLocation;
                    this.IDVPartiesComments = this.customerDetail.IDVPartiesComments;
                    this.RMdateofApproval = this.customerDetail.RMdateofApproval;
                    this.MLROdateofApproval = this.customerDetail.MLROdateofApproval;
                    this.AMLOCdateofApproval = this.customerDetail.AMLOCdateofApproval;
                    this.totalAssets = this.customerDetail.totalAssets;
                    this.totalLibs = this.customerDetail.totalLibs;
                    this.netWorth = this.customerDetail.netWorth;
                    this.IssuedDate = this.customerDetail.IssuedDate;
                    this.NextRenewalDate = this.customerDetail.NextRenewalDate;
                    this.SourceofWealthComments = this.customerDetail.SourceofWealthComments;
                    this.submitEDDform = this.customerDetail.isSubmittedEDD;
                    this.AppendixIDVLocation = this.customerDetail.AppendixIDVLocation;
                   // this.RMName =this.customerDetail.RMName;
                   
                    
                    this.politicallyExposedCompany = this.customerDetail.politicallyExposedCompany;
                    this.hrProhibitedsanctionedCORforSignif = this.customerDetail.hrProhibitedsanctionedCORforSignif;
                    this.hrProhibitedsanctionedCORforUBOsI = this.customerDetail.hrProhibitedsanctionedCORforUBOsI;
                    this.noe = this.customerDetail.noe;
                    this.empType = this.customerDetail.empType;
                    this.countryOfNationality = this.customerDetail.countryOfNationality;
                    this.countryOfResidence = this.customerDetail.countryOfResidence;
                    this.totelNetWorth = this.customerDetail.totelNetWorth;
                    this.sourceOfWealth = this.customerDetail.sourceOfWealth;
                    this.pep = this.customerDetail.pep;
                    this.countryOfPEP = this.customerDetail.countryOfPEP;
                    this.pepAssociate = this.customerDetail.pepAssociate;
                    this.orgType  = this.customerDetail.orgType;
                    this.layersOfOwner  = this.customerDetail.layersOfOwner;
                    this.lengthOfEst  = this.customerDetail.lengthOfEst;
                    this.balanceSheet  = this.customerDetail.balanceSheet;
                    this.sancIndCheck  = this.customerDetail.sancIndCheck;
                    this.negNewsScreen  = this.customerDetail.negNewsScreen;
                    this.preDecExited  = this.customerDetail.preDecExited;
                    this.natureOfBusiNPAA  = this.customerDetail.natureOfBusiNPAA;
                    this.showspinner = false;
                }else{
                    this.showspinner = false;
                    console.log('result error Msg : ',result.statusMsg);
                }

                this.flagIndicatingDataHasBeenLoadedInVariables  = true;
                
            })
            .catch(error => {
                
                this.showspinner = false;
                this.error = error;
                console.log('this.error : ',this.error);
            });
        
    }

    changemultiselect(event){
        console.log('event.detail.cnpdata : ',JSON.parse(JSON.stringify(event.detail.cnpdata)));
        this.changecustAccs = JSON.parse(JSON.stringify(event.detail.cnpdata));
    }

    handlebacktoCase(){
        alert('Work in Progress');
        return;
    }

    handlemaincountriesOp(){
    }
    handleValueChange(event){

    }
    

    handleChangereviewType(event){
        this.reviewType = event.target.value;
    }
    handleChangeexpAnnualTurnover(event){
        this.expAnnualTurnover = event.target.value;
        console.log('this.expAnnualTurnover : ',this.expAnnualTurnover);
    }

    handleChangeabtCustomer(event){
        this.abtCustomer = event.target.value;
        console.log('this.abtCustomer : ',this.abtCustomer);
    }

    handleSourceofWealthComments(event){
        this.SourceofWealthComments = event.target.value;
        console.log('this.SourceofWealthComments : ',this.SourceofWealthComments);
    }


    handleChangedepartment(){}
    handleChangemethodMostRecentContact(){}
    
    handleChangecorporatestructure(event){
        this.corporatestructure = event.target.value;
        console.log('this.corporatestructure : ',this.corporatestructure);
    }
    handleChangerrcorporatestructure(event){
        this.rrcorporatestructure = event.target.value;
        console.log('this.rrcorporatestructure : ',this.rrcorporatestructure);
    }
    handleChangespvtrust(event){
        this.spvtrust = event.target.value;
        console.log('this.spvtrust : ',this.spvtrust);
    }
    handleChangereasonEntityType(event){
        this.reasonEntityType = event.target.value;
        console.log('this.reasonEntityType : ',this.reasonEntityType);
    }
    handleChangestructurecomplex(event){
        this.structurecomplex = event.target.value;
        console.log('this.structurecomplex : ',this.structurecomplex);
    }
    handleChangeIDVsatisfied(event){
        this.IDVsatisfied = event.target.value;
        console.log('this.IDVsatisfied : ',this.IDVsatisfied);
    }
    handleChangeEDDsupportinginformation(event){
        this.EDDsupportinginformation = event.target.value;
        console.log('this.EDDsupportinginformation : ',this.EDDsupportinginformation);
    }
    handleChangerationalePepStatus(event){
        this.rationalePepStatus = event.target.value;
        console.log('this.rationalePepStatus : ',this.rationalePepStatus);
    }
    handleChangepepScreeningmatch(event){
        this.pepScreeningmatch = event.target.value;
        console.log('this.pepScreeningmatch : ',this.pepScreeningmatch);
    }
    handleChangesanctionsscreeningmatch(event){
        this.sanctionsscreeningmatch = event.target.value;
        console.log('this.sanctionsscreeningmatch : ',this.sanctionsscreeningmatch );
    }


    handleAdverseMediaScreeningPositiveMatchplusmatchtype(event){
        this.AdverseMediaScreeningPositiveMatchplusmatchtype = event.target.value;
        console.log('this.AdverseMediaScreeningPositiveMatchplusmatchtype : ',this.AdverseMediaScreeningPositiveMatchplusmatchtype );
    }
    handleChangeadversemediamatch(event){
        this.adversemediamatch = event.target.value;
        console.log('this.adversemediamatch : ',this.adversemediamatch );
    }
    handleChangeIDVvalidationcheck(event){
        this.IDVvalidationcheck = event.target.value;
         console.log('this.IDVvalidationcheck : ',this.IDVvalidationcheck);
    }

    handleAdversMediaMatchComments(event){
            this.AdversMediaMatchComments = event.target.value;
            console.log('this.AdversMediaMatchComments: ',this.AdversMediaMatchComments);
    }

    handleSourceofComments(event){
         this.SourceofComments = event.target.value;
            console.log('this.SourceofComments: ',this.SourceofComments);
    }

    handlesofChangesince(event){
        this.sofChangesince = event.target.value;
            console.log('this.sofChangesince: ',this.sofChangesince);
    }

    handleChangeKYCRecommendation(event){
        this.KYCRecommendation = event.target.value;
        console.log('this.KYCRecommendation: ',this.KYCRecommendation);
    }

    handleKycAnalystComments(event){
        this.KycAnalystComments =event.target.value;
        console.log('this.KycAnalystComments ',this.KycAnalystComments);
    }

    handleRMRecomComments(event){
        this.RMRecomComments =event.target.value;
        console.log('this.RMRecomComments ',this.RMRecomComments);
    }

   /* handlehandleRMName(event){
        this.RMName =event.target.value;
        console.log('this.RMName ',this.RMName);
    } */

    handleChangeRMRecommendation(event){
         this.RMRecommendation =event.target.value;
        console.log('this.RMRecommendation ',this.RMRecommendation);
        
    }
    handleChangeMLROCRAOverride(event){
         this.MLROCRAOverride =event.target.value;
        console.log('this.MLROCRAOverride ',this.MLROCRAOverride);
        
    }

    handleRationaleforMLROCRAOverride(event){
         this.RationaleforMLROCRAOverride =event.target.value;
        console.log('this.RationaleforMLROCRAOverride ',this.RationaleforMLROCRAOverride);

    }


    handleChangeMLRORecommendation(event){
         this.MLRORecommendation =event.target.value;
        console.log('this.MLRORecommendation ',this.MLRORecommendation);
    }
    handleMLROReccomendationComments(event){
         this.MLRORecomComments =event.target.value;
        console.log('this.MLRORecomComments ',this.MLRORecomComments);
    }

    handleScreenedParties(event){
         this.ScreenedParties =event.target.value;
        console.log('this.ScreenedParties ',this.ScreenedParties);
    }

    handlePEPScreeningPositiveMatch(event){
         this.PEPScreeningPositiveMatch =event.target.value;
        console.log('this.PEPScreeningPositiveMatch ',this.PEPScreeningPositiveMatch);
    }

    
    handleScreenedRelationship(event){
         this.ScreenedRelationship =event.target.value;
        console.log('this.ScreenedRelationship ',this.ScreenedRelationship);
    }

    handleSanctionScreeningPositiveMatch(event){
         this.SanctionScreeningPositiveMatch =event.target.value;
        console.log('this.SanctionScreeningPositiveMatch ',this.SanctionScreeningPositiveMatch);
    }

    handleScreenedPartiesComments(event){
         this.ScreenedPartiesComments =event.target.value;
        console.log('this.ScreenedPartiesComments ',this.ScreenedPartiesComments);
    }

    handleIDVPurpose(event){
        this.idvitems[Number(event.target.dataset.id)-1].purposevalue = event.target.value;
        console.log('aaa',this.idvitems[Number(event.target.dataset.id)-1].purposevalue);
        console.log('idvitems',this.idvitems);
    }

       handleIDVLocation(event){
        this.idvitems[Number(event.target.dataset.id)-1].AppendixIDVLocation = event.target.value;
        console.log('IDVLOCATION',this.idvitems[Number(event.target.dataset.id)-1].AppendixIDVLocation);
        // this.IDVLocation =event.target.value;
        console.log('idvitems',this.idvitems);
        //console.log('this.IDVLocation ',this.IDVLocation);
    }

        handleAppendixIDVLocation(event){
         this.AppendixIDVLocation =event.target.value;
        console.log('this.AppendixIDVLocation ',this.AppendixIDVLocation);
    }

    handleIDVPartiesComments(event){
         this.IDVPartiesComments =event.target.value;
        console.log('this.IDVPartiesComments ',this.IDVPartiesComments);
    }

    handleAMLOCRecomComments(event){
         this.AMLOCRecomComments =event.target.value;
        console.log('this.AMLOCRecomComments ',this.AMLOCRecomComments);
    }

    handleChangeAMLOCRecommendation(event){
         this.AMLOCRecommendation =event.target.value;
        console.log('this.AMLOCRecommendation ',this.AMLOCRecommendation);
    }

    handleKycDateChange(event) {
        this.kycselectedDate = event.target.value;
         console.log('this.kycselectedDate ',this.kycselectedDate);
    }

    handleChangecountryOfIncorporation(){}
    handleChangesourceOfFundsCountry(){}
    

    handleIDVValidationComments(event){
        this.IDVValidationComments =event.target.value;
    }
    handlePepComments(event){
        this.PepComments =event.target.value;
        console.log('this.PepComments: ',this.PepComments);
        
    }
    handleSanctionsScreeingComments(event){
        this.SanctionsScreeningComments =event.target.value;
        console.log('this.SanctionsScreeningComments ',this.SanctionsScreeningComments);
    }

    handleRMdateofApproval(event){
        this.RMdateofApproval =event.target.value;
        console.log('this.RMdateofApproval ',this.RMdateofApproval);
    }

    handleMLROdateofApproval(event){
        this.MLROdateofApproval =event.target.value;
        console.log('this.MLROdateofApproval ',this.MLROdateofApproval);
    }

    handleAMLOCdateofApproval(event){
        this.AMLOCdateofApproval =event.target.value;
        console.log('this.AMLOCdateofApproval ',this.AMLOCdateofApproval);
    }

    handleIssuedDate(event){
        this.IssuedDate =event.target.value;
        console.log('this.IssuedDate ',this.IssuedDate);
    }

    handleNextRenewalDate(event){
        this.NextRenewalDate =event.target.value;
        console.log('this.NextRenewalDate ',this.NextRenewalDate);

    }

    handletotalAsset(event){
        this.totalAssets=event.detail;
        console.log('this.totalAssets',event.detail);
        this.calculateNetWorth();
        console.log('key of template' +event.id);
        
    }
    handletotalLibs(event){
        this.totalLibs=event.detail;
        console.log('this.totalLibs',event.detail);
        this.calculateNetWorth();
    }
    calculateNetWorth() {
        return this.totalAssets + this.totalLibs;
    }

    handleSubmitEDD(event){
        this.showspinner = true;
        this.submitEDDform = true;
        this.tables=this.template.querySelectorAll("c-source-of-wealth");

        for(var i=0; i<this.tables.length;i++){
            this.tables[i].handleDisable();
        }
        this.handleSave('submitEDD');
      
    }

    handleSaveasdraft(event){
        this.showspinner = true;
        this.handleSave('saveasdraft');
    }

    @track items=[];

    handleAddAL(event){
        console.log('handle add table is invoked');
        this.maxVal = 0;
        for (let item=0; item< this.items.length;item++){
            if(this.maxVal<Number(this.items[item].id)){
                this.maxVal=Number(this.items[item].id);
            }
        }
        const newItem = {
            id: this.maxVal + 1,
            ref: this.referenceText,
        };
        this.items.push(newItem);
        this.jsonReferenceName.push(newItem);
        this.referenceText='';
        this.buttonStatus=true;
    }
    handleRemoveTable(event){
        for(let index=0;index<this.items.length;index++){
            if(this.items[index].id==event.target.dataset.id){
                this.items.splice(index,1)
                this.jsonReferenceName.splice(index,1);
                this.template.querySelector("c-source-of-wealth").handleDeleteTable(event.target.dataset.id);
                break;
            }
        }
    }

    handleTableLoad(){
        for(let i=0;i<this.itemCount;i++){
            this.items.push(this.jsonReferenceName[i]);
        }
    }


    handleReferenceChange(event) {
        this.referenceText = event.target.value;
        if(this.referenceText == ''){
            this.buttonStatus=true;
        }
        else{
            this.buttonStatus=false;
        }
        console.log('this.referenceText',this.referenceText);
    }

    @track 
    productOptions =[{label:'Product 1', name:'Product 1', value:'Product 1'},
                    {label:'Product 2', name:'Product 2', value:'Product 2'},
                    {label:'Product 3', name:'Product 3', value:'Product 3'}];

    handleProductOptions(event){
        console.log('handleProductOptions :', JSON.stringify(event.detail));
        const rowId = event.detail.selectedrecord;
        console.log('rowId :handleProductOptions ',rowId);
        this.selectedProductOptions= event.detail.values;
        console.log('this.selectedProductOptions',JSON.stringify(this.selectedProductOptions));

    }                    

    handleSave(mode){
        this.showspinner = true;
            console.log('handleSaveasdraft this.eddId : '+this.eddId+' mode : '+mode);
        let saveObj = {
            eddId :this.eddId,
            itemCount: this.items.length,
            accountId : this.accountId,
            caseId : this.caseId,
            reviewType : this.reviewType,
            jsonReferenceName: JSON.stringify(this.jsonReferenceName),
            relationshipManager :  this.relationshipManager,
            reviewPreparedBy :this.reviewPreparedBy,
            onboardingcaseno : this.onboardingcaseno,
            kycAnalyst : this.kycAnalyst,
            mlroName : this.mlroName,
            expAnnualTurnover: this.expAnnualTurnover,
            linkaccounts : this.toLinkAccs,
			abtCustomer : this.abtCustomer,
			corporatestructure : this.corporatestructure,
			rrcorporatestructure : this.rrcorporatestructure,
			spvtrust : this.spvtrust,
			reasonEntityType : this.reasonEntityType,
			structurecomplex : this.structurecomplex,
			IDVsatisfied : this.IDVsatisfied,
			EDDsupportinginformation : this.EDDsupportinginformation,
			rationalePepStatus : this.rationalePepStatus,
			datecheckscompleted : this.datecheckscompleted,
            datecheckscompletedApproval : this.datecheckscompletedApproval,
			IDVvalidationcheck : this.IDVvalidationcheck,
            kycselectedDate : this.kycselectedDate,
            AdversMediaMatchComments : this.AdversMediaMatchComments,
            adversemediamatch : this.adversemediamatch,
            IDVValidationComments : this.IDVValidationComments,
            SourceofComments : this.SourceofComments,
            sofChangesince : this.sofChangesince,
            PepComments : this.PepComments,
            SanctionsScreeningComments : this.SanctionsScreeningComments,
			pepScreeningmatch : this.pepScreeningmatch,
			sanctionsscreeningmatch : this.sanctionsscreeningmatch,
            AdverseMediaScreeningPositiveMatchplusmatchtype : this.AdverseMediaScreeningPositiveMatchplusmatchtype,
			//adversemediamatch : this.adversemediamatch,
			KYCRecommendation : this.KYCRecommendation,
			RMRecommendation : this.RMRecommendation,
			MLROCRAOverride : this.MLROCRAOverride,
            RationaleforMLROCRAOverride : this.RationaleforMLROCRAOverride,
			MLRORecommendation : this.MLRORecommendation,
            MLRORecomComments : this.MLRORecomComments,
            ScreenedParties : this.ScreenedParties,
			AMLOCRecommendation : this.AMLOCRecommendation,
			AMLOCdateofApproval : this.AMLOCdateofApproval,
            AMLOCRecomComments : this.AMLOCRecomComments,
			RMRecomComments : this.RMRecomComments,
			RMName : this.RMName,
            MLROName: this.MLROName,
            RMdateofApproval : this.RMdateofApproval,
            MLROdateofApproval : this.MLROdateofApproval,
            KycAnalystComments : this.KycAnalystComments,
            PEPScreeningPositiveMatch : this.PEPScreeningPositiveMatch,
            ScreenedRelationship : this.ScreenedRelationship,
            SanctionScreeningPositiveMatch : this.SanctionScreeningPositiveMatch,
            ScreenedPartiesComments : this.ScreenedPartiesComments,
            IDVPurpose : this.IDVPurpose,
            IDVLocation : this.IDVLocation,
            IDVPartiesComments : this.IDVPartiesComments,
            totalAssets : this.totalAssets,
            totalLibs : this.totalLibs,
            netWorth : this.netWorth,
            customeraccounts : this.changecustAccs,
            IssuedDate : this.IssuedDate,
            NextRenewalDate : this.NextRenewalDate,
            SourceofWealthComments : this.SourceofWealthComments,
            isSubmittedEDD : this.submitEDDform,
            AppendixIDVLocation : this.AppendixIDVLocation
        }
        console.log('saveObj : ',JSON.stringify(saveObj));
        save({saveObjdata : JSON.stringify(saveObj), savemode : mode})
        .then(result => {
            console.log('saveAsDraftEDD : ',JSON.parse(JSON.stringify(result)));
            if(result.status == 'SUCCESS'){
                this.customerDetail = result.customerDetails;
                    this.toLinkAccs = this.customerDetail.linkaccounts;
                    this.selectedAccs = result.linkaccounts;
                    this.custAccs = result.customeraccounts;
                    this.sows = result.sow;
                    console.log('this.customerDetail : ',this.customerDetail);
                    this.reviewType = this.customerDetail.reviewType;
                    if(this.customerDetail.relationshipManager != undefined && this.customerDetail.relationshipManager != null){
                        this.relationshipManager = this.customerDetail.relationshipManager;
                        console.log('this.relationshipManager : '+this.relationshipManager);
                    }
                    this.department = this.customerDetail.department;
                    this.customerName = this.customerDetail.customerName;
                    this.caseNumberTitle = 'EDD Case : '+this.customerDetail.eddReviewCaseNo;
                    this.caseNumber = this.customerDetail.eddReviewCaseNo;
                    this.caseId = this.customerDetail.caseId;
                    this.ebsId = this.customerDetail.ebsId;
                    this.eddId = this.customerDetail.eddId;
                    console.log('getCustomerDetails this.eddId : ',this.eddId);
                    this.accountId = this.customerDetail.accountId;
                    this.riskRating = this.customerDetail.riskRating;
                    this.reviewPreparedBy = this.customerDetail.reviewPreparedBy;
                    this.onboardingcaseno = this.customerDetail.onboardingcaseno;
                    this.kycAnalyst = this.customerDetail.kycAnalyst;
                    this.mlroName = this.customerDetail.mlroName;
                    this.dateOfSubmission = this.customerDetail.dateOfSubmission;
                    
                    this.entityType = this.customerDetail.entityType;
                    this.registeredAddress = this.customerDetail.registeredAddress;
                    this.tradingAddress = this.customerDetail.tradingAddress;
                    this.registrationNumber = this.customerDetail.registrationNumber;
                    this.countryOfIncorporation = this.customerDetail.countryOfIncorporation;
                    this.contactMethod = this.customerDetail.contactMethod;
                    this.contactLastMade = this.customerDetail.contactLastMade;
                    this.methodMostRecentContact = this.customerDetail.methodMostRecentContact;
                    this.customerConvertedDate = this.customerDetail.customerConvertedDate;
                    this.sourceOfFunds = this.customerDetail.sourceOfFunds;
                    this.sourceOfFundsCountry = this.customerDetail.sourceOfFundsCountry;
                    this.internationalFundTransferFrequency = this.customerDetail.internationalFundTransferFrequency;
                    this.intFundTransferSource = this.customerDetail.intFundTransferSource;
                    this.estMonthlyVolumeInward = this.customerDetail.estMonthlyVolumeInward;
                    this.estMonthlyVolumeOutward = this.customerDetail.estMonthlyVolumeOutward;
                    this.estCashWithdrawalFrequency = this.customerDetail.estCashWithdrawalFrequency;
                    this.estCashDeprequency = this.customerDetail.estCashDeprequency;
                    this.overallCompCreditTurnover = this.customerDetail.overallCompCreditTurnover;
                    this.expAnnualTurnover = this.customerDetail.expAnnualTurnover;
                    this.EDDsupportinginformation = this.customerDetail.EDDsupportinginformation;
                    this.politicallyExposedCompany = this.customerDetail.politicallyExposedCompany;
                    this.hrProhibitedsanctionedCORforSignif = this.customerDetail.hrProhibitedsanctionedCORforSignif;
                    this.hrProhibitedsanctionedCORforUBOsI = this.customerDetail.hrProhibitedsanctionedCORforUBOsI;
                    this.noe = this.customerDetail.noe;
                    this.empType = this.customerDetail.empType;
                    this.countryOfNationality = this.customerDetail.countryOfNationality;
                    this.countryOfResidence = this.customerDetail.countryOfResidence;
                    this.totelNetWorth = this.customerDetail.totelNetWorth;
                    this.sourceOfWealth = this.customerDetail.sourceOfWealth;
                    this.pep = this.customerDetail.pep;
                    this.countryOfPEP = this.customerDetail.countryOfPEP;
                    this.pepAssociate = this.customerDetail.pepAssociate;
                    this.orgType  = this.customerDetail.orgType;
                    this.layersOfOwner  = this.customerDetail.layersOfOwner;
                    this.lengthOfEst  = this.customerDetail.lengthOfEst;
                    this.balanceSheet  = this.customerDetail.balanceSheet;
                    this.sancIndCheck  = this.customerDetail.sancIndCheck;
                    this.negNewsScreen  = this.customerDetail.negNewsScreen;
                    this.preDecExited  = this.customerDetail.preDecExited;
                    this.natureOfBusiNPAA  = this.customerDetail.natureOfBusiNPAA;
                    this.IDVValidationComments = this.customerDetail.IDVValidationComments;
                    this.SanctionsScreeningComments = this.customerDetail.SanctionsScreeningComments;
                    this.AdversMediaMatchComments = this.customerDetail.AdversMediaMatchComments;
                    this.IDVvalidationcheck = this.customerDetail.IDVvalidationcheck;
                    this.kycselectedDate = this.customerDetail.kycselectedDate;
                    this.pepScreeningmatch = this.customerDetail.pepScreeningmatch;
                    this.sanctionsscreeningmatch = this.customerDetail.sanctionsscreeningmatch;
                    this.AdverseMediaScreeningPositiveMatchplusmatchtype = this.customerDetail.AdverseMediaScreeningPositiveMatchplusmatchtype;
                    this.adversemediamatch = this.customerDetail.adversemediamatch;
                    this.KYCRecommendation = this.customerDetail.KYCRecommendation;
                    this.KycAnalystComments =this.customerDetail.KycAnalystComments;
                    this.RMRecomComments =this.customerDetail.RMRecomComments;
                    this.RMRecommendation = this.customerDetail.RMRecommendation;
                    this.MLROCRAOverride = this.customerDetail.MLROCRAOverride;
                    this.RationaleforMLROCRAOverride = this.customerDetail.RationaleforMLROCRAOverride;
                    this.MLRORecommendation = this.customerDetail.MLRORecommendation;
                    this.MLRORecomComments = this.customerDetail.MLRORecomComments;
                    this.ScreenedParties = this.customerDetail.ScreenedParties;
                    this.AMLOCRecomComments = this.customerDetail.AMLOCRecomComments;
                    this.AMLOCRecommendation = this.customerDetail.AMLOCRecommendation;
                    this.corporatestructure =  this.customerDetail.corporatestructure;
                    this.abtCustomer = this.customerDetail.abtCustomer;
                    this.rrcorporatestructure = this.customerDetail.rrcorporatestructure;
                    this.spvtrust = this.customerDetail.spvtrust;
                    this.reasonEntityType = this.customerDetail.reasonEntityType;
                    this.structurecomplex = this.customerDetail.structurecomplex;
                    this.IDVsatisfied = this.customerDetail.IDVsatisfied;
                    this.PEPScreeningPositiveMatch = this.customerDetail.PEPScreeningPositiveMatch;
                    this.ScreenedRelationship = this.customerDetail.ScreenedRelationship;
                    this.SanctionScreeningPositiveMatch = this.customerDetail.SanctionScreeningPositiveMatch;
                    this.ScreenedPartiesComments = this.customerDetail.ScreenedPartiesComments;
                    this.IDVPurpose = this.customerDetail.IDVPurpose;
                    this.IDVLocation = this.customerDetail.IDVLocation;
                    this.IDVPartiesComments = this.customerDetail.IDVPartiesComments;
                    this.RMdateofApproval = this.customerDetail.RMdateofApproval;
                    this.MLROdateofApproval = this.customerDetail.MLROdateofApproval;
                    this.AMLOCdateofApproval = this.customerDetail.AMLOCdateofApproval;
                    this.totalAssets = this.customerDetail.totalAssets;
                    this.totalLibs = this.customerDetail.totalLibs;
                    this.netWorth = this.customerDetail.netWorth;
                    this.IssuedDate = this.customerDetail.IssuedDate;
                    this.NextRenewalDate = this.customerDetail.NextRenewalDate;
                    this.SourceofWealthComments = this.customerDetail.SourceofWealthComments;
                    this.jsonReferenceName = JSON.parse(this.customerDetail.jsonReferenceName);
                    this.isSubmittedEDD = this.customerDetail.isSubmittedEDD;
                    this.AppendixIDVLocation = this.customerDetail.AppendixIDVLocation;
                    //this.RMName =this.customerDetail.RMName;

                    console.log('Save Complete');

                    const toastEvent = new ShowToastEvent({ title: 'Success!', message: 'Record has been created successfully!', variant: 'success' }); 
                    this.dispatchEvent(toastEvent);
                    this.showspinner = false;
            }else{
                this.showspinner = false;
                console.log('result error Msg : ',result.statusMsg);
            }
            
            })
            .catch(error => {
            this.showspinner = false;
            this.error = error;
            });
        this.showspinner = false;
    }

    handleSaveEDD(){
        const dataDefPopup = this.template.querySelector('[data-id="submitEDD"]');
        dataDefPopup.show();
    }
    cancelsaveEDD(event)
    {
        const popup = this.template.querySelector('[data-id="submitEDD"]');
        popup.hide();
    }
    handleRemoveAcc(){}

    handleAccountchange(event){
        this.linkacc = event.target.value;
        this.templinkacc = event.target.value;
        console.log('this.linkacc : '+this.linkacc);
    }

    handleSelectedlookup(event){
        //this.relationshipManager = event.target.value;
        console.log('JSON.stringify(event.detail) : ',JSON.stringify(event.detail));
        let selection = JSON.parse(JSON.stringify(event.detail));
        console.log('this.selection : ',selection.selectedrecord.Id);
        console.log('this.field : ',selection.field);
        if(selection.field == 'Relationship Manager'){
            this.relationshipManager = selection.selectedrecord.Id;
        }else if(selection.field == 'Review prepared by'){
            this.reviewPreparedBy = selection.selectedrecord.Id;
        }else if(selection.field == 'Onboarding Case Number'){
            this.onboardingcaseno = selection.selectedrecord.Id;
        }else if(selection.field == 'KYC Analyst'){
            this.kycAnalyst = selection.selectedrecord.Id;
        }else if(selection.field == 'MLRO Name'){
            this.mlroName = selection.selectedrecord.Id;
        
        }else if(selection.field == 'Customers'){
            let linkSelAcc = { caccebsid: selection.selectedrecord.EBSId ,caccId: selection.selectedrecord.Id , caccName : selection.selectedrecord.Name, caccNameebs: selection.selectedrecord.Name+' '+selection.selectedrecord.EBSId };
            this.toLinkAccs= JSON.parse(JSON.stringify(this.toLinkAccs));
            this.toLinkAccs.push(linkSelAcc);
        }
        
        console.log('this.relationshipManager : ',this.relationshipManager);
        console.log('this.reviewPreparedBy : ',this.reviewPreparedBy);
        console.log('this.onboardingcaseno : ',this.onboardingcaseno);
        console.log('this.kycAnalyst : ',this.kycAnalyst);
        console.log('this.mlroName : ',this.mlroName);
        console.log('this.toLinkAccs : ',this.toLinkAccs);
    }
}