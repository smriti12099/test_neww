@EndUserText.label: 'Custom CDS View for Sales List Report'
@UI.headerInfo: {typeName: 'Sales Document'}
@ObjectModel.query.implementedBy: 'ABAP:ZCL_SALES_RPT'
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define custom entity zdd_cds_i_sales_
{
    //@UI.selectionField: [{ position: 1 }]
    //@UI.lineItem: [{ position: 1, label: 'Client' }]
    //key client : abap.clnt;

    @UI.selectionField: [{ position: 2 }]
    @UI.lineItem: [{ position: 2, label: 'Sales Document' }]
    key salesdocument : abap.numc(10);

    @UI.selectionField: [{ position: 3 }]
    @UI.lineItem: [{ position: 3, label: 'Order Date' }]
    orderdate : abap.dats;

    @UI.lineItem: [{ position: 4, label: 'Sales Amount' }]
    @Semantics.amount.currencyCode: 'sales_currency'
    sales_amount : abap.curr(7,2);


    @UI.lineItem: [{ position: 5, label: 'Currency' }]
    sales_currency : abap.cuky;

    @UI.selectionField: [{ position: 6 }]
    @UI.lineItem: [{ position: 6, label: 'Customer Number' }]
    customer : abap.numc(10);

    @UI.selectionField: [{ position: 7 }]
    @UI.lineItem: [{ position: 7, label: 'Customer Name' }]
    customer_name : abap.char(50);

    @UI.selectionField: [{ position: 8 }]
    @UI.lineItem: [{ position: 8, label: 'Status' }]
    status : abap.char(1);

    @UI.selectionField: [{ position: 9 }]
    @UI.lineItem: [{ position: 9, label: 'Is Permitted' }]
    ispermitted : abap_boolean;
}
