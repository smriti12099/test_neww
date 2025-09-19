@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'C View For Daily Sales Ragister Report'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZC_DAILYSALESREGISTER
  as select from ZI_DailySalesRegister
{
      @UI.selectionField: [{ position: 30 }]
  key SKU,
      State,
      Division,
      @UI.selectionField: [{ position: 10 }]
      SellingPlant,
      PlantName,
      @UI.selectionField: [{ position: 20 }]
      Brand,
      BrandName,
      BillingQuantityUnit,
      TransactionCurrency,
     @Semantics.quantity.unitOfMeasure: 'BillingQuantityUnit'
      sum(MTDQuantity)    as MTDQuantity,

      @Semantics.amount.currencyCode: 'TransactionCurrency'
      sum(MTDValue)       as MTDValue,

      sum(YTD_Quantity)   as YTD_Quantity,
      sum(YTD_Value)      as YTD_Value,
      sum(Daily_Quantity) as Daily_Quantity,
      sum(Daily_Value)    as Daily_Value

//      @UI.selectionField: [{ position: 40 }]
//      BillingDate
}
group by
    SKU,
    State,
    Division,
    SellingPlant,
    PlantName,
    Brand,
    BrandName,
    BillingQuantityUnit,
    TransactionCurrency
//    BillingDate
