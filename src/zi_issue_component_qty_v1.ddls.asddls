@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'I View For Issue Component Qty v1 (PRD Report)'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity zi_issue_component_qty_v1
  as select from zi_issue_component_qty
{
  key ManufacturingOrder,
  key BillOfMaterialComponent,
      ProductionPlant,
      BillOfMaterial,
      BillOfMaterialVariant,
      BillOfMaterialItemNodeNumber,
      BillOfMaterialItemUnit,
      ProductDescription,
      sum(QTYInEntryUnit261)           as QTYInEntryUnit261,
      sum(QTYInEntryUnit262)           as QTYInEntryUnit262,
      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      sum(TotalGoodsMvtAmtInLCrcy261)  as TotalGoodsMvtAmtInCCCrcy261,
      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      sum(TotalGoodsMvtAmtInCCCrcy262) as TotalGoodsMvtAmtInCCCrcy262,
      ConsumedMaterial,
      CompanyCodeCurrency,
      //      cast( coalesce(sum(QTYInEntryUnit261), 0) - coalesce(sum(QTYInEntryUnit262), 0) as abap.dec(15,3)) as IssueComponentQty,
      cast(
        round(
          coalesce(sum(QTYInEntryUnit261), 0) - coalesce(sum(QTYInEntryUnit262), 0),
          3
        )
        as abap.dec(15,3)
      )                                as IssueComponentQty,
      cast( coalesce(sum(TotalGoodsMvtAmtInLCrcy261), 0)  - coalesce(sum(TotalGoodsMvtAmtInCCCrcy262), 0)  as abap.dec(15,2)
      )                                as IssueValue
}
group by
  ManufacturingOrder,
  BillOfMaterialComponent,
  ProductionPlant,
  BillOfMaterial,
  BillOfMaterialVariant,
  BillOfMaterialItemNodeNumber,
  BillOfMaterialItemUnit,
  ProductDescription,
  ConsumedMaterial,
  CompanyCodeCurrency
