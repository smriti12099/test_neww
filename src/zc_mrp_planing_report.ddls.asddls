@EndUserText.label: 'Custom Entity For MRP Report'
@ObjectModel.query.implementedBy: 'ABAP:ZMRP_PLANING_RPT_CLASS'



@UI.headerInfo:   {
              typeName: 'MRP Details', typeNamePlural: 'MRP Details',
              title: {
                 type: #STANDARD,
                 value: 'Material'

                 }

              }
define root custom entity ZC_MRP_PLANING_REPORT
{
      @UI.facet                      : [{
                                      id          : 'idinformation',
                                      purpose     : #STANDARD,
                                      type        :  #IDENTIFICATION_REFERENCE,
                                      label       :  'MRP Details',
                                  position    :  10 }
                           ]

  key client                         : abap.clnt;



      @EndUserText.label             : 'Material'
      @UI.selectionField             : [{
      position                       : 10
       }]
      @UI.lineItem                   : [{
      position                       : 10 ,
      label                          : 'Material' }]
      @UI.textArrangement            : #TEXT_FIRST
      @UI.identification             : [{ position: 10 , label: 'Material' }]
      //    @Consumption.valueHelpDefinition: [{ entity: { element: 'material', name: 'ZIMRPMATF4' } }]
      // Field 1
  key Material                       : abap.char(20);


      @UI.selectionField             : [{
      position                       : 20
      }]
      @EndUserText.label             : 'MRPArea'
      @UI.lineItem                   : [{ position: 20, label: 'MRPArea' }]
      @UI.identification             : [{ position: 20 , label: 'MRPArea' }]
      //    @Consumption.valueHelpDefinition: [{ entity: { element: 'mrparea', name: 'ZIMRPAREAF4' } }]
  key MRPArea                        : abap.numc(4); // Purchase Order Item

//      @Consumption.filter.mandatory  : true
      @EndUserText.label             : 'MRPPlant'
      @UI.selectionField             : [{
      position                       : 30
       }]
      @UI.lineItem                   : [{
      position                       : 30 ,
      label                          : 'MRPPlant' }]
      @UI.textArrangement            : #TEXT_FIRST
      @UI.identification             : [{ position: 30 , label: 'MRPPlant' }]
//            @Consumption.valueHelpDefinition: [{ entity: { element: 'mrpplant', name: 'ZIMRPPLANTF4' } }]
            key MRPPlant               : abap.char(4);

       @EndUserText.label             : 'Mrpelementavailyorrqmtdate'
      @UI.lineItem                   : [{
      position                       : 220 ,
      label                          : 'Mrpelementavailyorrqmtdate' }]
      @UI.identification             : [{ position: 220 , label: 'Mrpelementavailyorrqmtdate' }]
      Mrpelementavailyorrqmtdate     : abap.char(10);
      
            @EndUserText.label             : 'Mrpelementcategoryshortname'
      @UI.lineItem                   : [{
      position                       : 270 ,
      label                          : 'Mrpelementcategoryshortname' }]
      @UI.identification             : [{ position: 270 , label: 'Mrpelementcategoryshortname' }]
      Mrpelementcategoryshortname    : abap.char(30);
      
    @EndUserText.label             : 'Sourcemrpelement'
      @UI.lineItem                   : [{
      position                       : 370 ,
      label                          : 'Sourcemrpelement' }]
      @UI.identification             : [{ position: 370 , label: 'Sourcemrpelement' }]
      Sourcemrpelement               : abap.char(20);

      @EndUserText.label             : 'Mrpavailablequantity'
      @UI.lineItem                   : [{
      position                       : 200 ,
      label                          : 'Mrpavailablequantity' }]
      @UI.identification             : [{ position: 200 , label: 'Mrpavailablequantity' }]
      Mrpavailablequantity           : abap.char(10);

      @EndUserText.label             : 'Mrpelementopenquantity'
      @UI.lineItem                   : [{
      position                       : 190 ,
      label                          : 'Mrpelementopenquantity' }]
      @UI.identification             : [{ position: 190 , label: 'Mrpelementopenquantity' }]
      Mrpelementopenquantity         : abap.char(10);
      
      

      @EndUserText.label             : 'Materialbaseunit'
      @UI.lineItem                   : [{
      position                       : 110 ,
      label                          : 'Materialbaseunit' }]
      @UI.identification             : [{ position: 110 , label: 'Materialbaseunit' }]
      Materialbaseunit               : abap.char(10);



}
