@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'I View For Quantity sum from FY start to system date'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_CDS_YTD_BillingQuantity as  select from I_BillingDocumentItem as item
  inner join I_FiscalCalendarDate as fiscal
    on fiscal.CalendarDate = item.CreationDate
{
  key item.BillingDocument,
  @Semantics.quantity.unitOfMeasure: 'BillingQuantityUnit'
  sum(item.BillingQuantity) as TotalBillingQuantity,
  item.BillingQuantityUnit
}
where fiscal.FiscalYearStartDate <= item.CreationDate
  and item.CreationDate <= $session.system_date
group by item.BillingDocument,
         item.BillingQuantityUnit
 

