@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'I View For Issue Component (PRD Report)'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity zi_issue_component
  as select distinct from ZI_ManufacturingOrderBOM    as bom
    left outer join       I_MfgOrderDocdGoodsMovement as gm on  gm.ManufacturingOrder      = bom.ManufacturingOrder
                                                            and gm.ProductionPlant         = bom.ProductionPlant
                                                            and gm.GoodsMovementType       = '261'
                                                          
                                                            and gm.Material                = bom.BillOfMaterialComponent
    inner join            I_ProductDescription        as d  on  d.Product  = gm.Material
                                                            and d.Language = 'E'
    inner join            I_GLAccountText             as pd on  pd.GLAccount = gm.GLAccount
                                                            and pd.Language  = 'E'
{
  key bom.ManufacturingOrder,
      bom.ProductionPlant,
      @Semantics.quantity.unitOfMeasure: 'BillOfMaterialItemUnit'
      bom.ActualDeliveredQuantity,
      bom.BillOfMaterial,
      bom.BillOfMaterialVariant,
      bom.BillOfMaterialItemNodeNumber,
      bom.BillOfMaterialComponent,
      @Semantics.quantity.unitOfMeasure: 'BillOfMaterialItemUnit'
      bom.BillOfMaterialItemQuantity,
      bom.BillOfMaterialItemUnit,
      bom.ProductDescription,

      gm.Material          as ConsumedMaterial,
      @Semantics.quantity.unitOfMeasure: 'BillOfMaterialItemUnit'
      gm.QuantityInEntryUnit,
      d.ProductDescription as IssueComponentDescription,
      gm.EntryUnit         as IssueComponentUOM,
      gm.CompanyCodeCurrency,
      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
  sum( gm.TotalGoodsMvtAmtInCCCrcy )                      as TotalGoodsMvtAmtInCCCrcy261,
      gm.GLAccount,
      pd.GLAccountLongName,


      case
         when gm.Material is not null
         then gm.Material
         else ''
      end                  as IssueComponent
}
group by
  bom.ManufacturingOrder,
  bom.ProductionPlant,
  bom.BillOfMaterial,
  bom.BillOfMaterialVariant,
  bom.BillOfMaterialItemNodeNumber,
  bom.BillOfMaterialComponent,
  bom.ActualDeliveredQuantity,
  bom.BillOfMaterialItemQuantity,
  bom.BillOfMaterialItemUnit,
  bom.ProductDescription,
  gm.Material,
  gm.QuantityInEntryUnit,
  d.ProductDescription,
  gm.EntryUnit,
  gm.CompanyCodeCurrency,
  gm.GLAccount,
  pd.GLAccountLongName

