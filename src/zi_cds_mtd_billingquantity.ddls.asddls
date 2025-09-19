@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'I View For Quantity sum from month start to system date'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_CDS_MTD_BillingQuantity as
 select from I_BillingDocumentItem as item
{
  key item.BillingDocument,
  key item.BillingDocumentItem,
  @Semantics.quantity.unitOfMeasure: 'BillingQuantityUnit'
  sum(item.BillingQuantity) as MonthTotalBillingQuantity,
  item.BillingQuantityUnit,
  item.TransactionCurrency,
   @Semantics.amount.currencyCode: 'TransactionCurrency'
  sum(item.NetAmount)as MonthTotalNetAmount
}
where item.CreationDate >= cast(
      concat(
        substring(cast($session.system_date as abap.char(8)), 1, 4),
        concat(
          '-',
          concat(
            substring('00', 1, 2 - length(substring(cast($session.system_date as abap.char(8)), 5, 2))),
            concat(substring(cast($session.system_date as abap.char(8)), 5, 2), '-01')
          )
        )
      ) as abap.dats ) 
  and item.CreationDate <= $session.system_date 
group by item.BillingDocument,
BillingDocumentItem,
item.BillingQuantityUnit,
TransactionCurrency
