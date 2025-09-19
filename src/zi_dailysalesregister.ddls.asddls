@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'I View For Daily Sales Ragister'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_DailySalesRegister
  as select from    I_SalesOrderItem
    inner join      I_BillingDocumentItem             on  I_SalesOrderItem.SalesOrder     = I_BillingDocumentItem.SalesDocument
                                                      and I_SalesOrderItem.SalesOrderItem = I_BillingDocumentItem.SalesDocumentItem
    left outer join I_Customer                        on I_SalesOrderItem.ShipToParty = I_Customer.Customer
    left outer join I_Product                         on I_SalesOrderItem.Material = I_Product.Product
    inner join      I_FiscalCalendarDate       as fiscal    on fiscal.CalendarDate = I_BillingDocumentItem.CreationDate
    left outer join ZI_CDS_MTD_BillingQuantity as MTD on  I_BillingDocumentItem.BillingDocument     = MTD.BillingDocument
                                                      and I_BillingDocumentItem.BillingDocumentItem = MTD.BillingDocumentItem
    left outer join I_Plant                           on I_SalesOrderItem.Plant = I_Plant.Plant
{
  key I_SalesOrderItem.Material     as SKU,
      I_Customer.Region             as State,
      I_Product.Division            as Division,
      I_SalesOrderItem.Plant        as SellingPlant,
      I_Plant.PlantName             as PlantName,
      I_Product.Brand               as Brand,
      I_Product.ProductHierarchy    as BrandName,
      I_BillingDocumentItem.BillingQuantityUnit,
      I_BillingDocumentItem.TransactionCurrency,
      @Semantics.quantity.unitOfMeasure: 'BillingQuantityUnit'
      MTD.MonthTotalBillingQuantity as MTDQuantity,
      @Semantics.amount.currencyCode: 'TransactionCurrency'
      MTD.MonthTotalNetAmount       as MTDValue,
      I_BillingDocumentItem.BillingDocumentDate as BillingDate,
      cast(
          sum(
              case
                  when I_BillingDocumentItem.BillingDocumentDate >= fiscal.FiscalYearStartDate
                   and I_BillingDocumentItem.BillingDocumentDate <= $session.system_date
                  then I_BillingDocumentItem.BillingQuantity
                  else 0
              end
          ) as abap.dec(15,3)
      )                             as YTD_Quantity,

      sum(
      case
         when I_BillingDocumentItem.BillingDocumentDate >= fiscal.FiscalYearStartDate
          and I_BillingDocumentItem.BillingDocumentDate <= $session.system_date
         then cast( I_BillingDocumentItem.NetAmount as abap.dec(15,2) )
         else cast( 0 as abap.dec(15,2) )
      end
      )                             as YTD_Value,


      cast( sum(
           case
               when I_BillingDocumentItem.BillingDocumentDate = $session.system_date
               then I_BillingDocumentItem.BillingQuantity
               else 0
           end
       )       as abap.dec(15,3) )  as Daily_Quantity,

      sum(
          case
              when I_BillingDocumentItem.BillingDocumentDate = $session.system_date
              then cast( I_BillingDocumentItem.NetAmount as abap.dec(15,2) )
         else cast( 0 as abap.dec(15,2) )
          end
      )                             as Daily_Value
}
group by
  I_SalesOrderItem.Product,
  I_SalesOrderItem.Material,
  I_Customer.Region,
  I_Product.Division,
  I_SalesOrderItem.Plant,
  I_SalesOrderItem.Plant,
  I_Product.Brand,
  I_Product.ProductHierarchy,
  I_BillingDocumentItem.BillingQuantityUnit,
  MTD.MonthTotalBillingQuantity,
  MTD.MonthTotalNetAmount,
  I_Plant.PlantName,
  I_BillingDocumentItem.TransactionCurrency,
  I_BillingDocumentItem.BillingDocumentDate
