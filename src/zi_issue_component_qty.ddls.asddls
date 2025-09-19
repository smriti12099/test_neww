@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'I View For Issue Component Qty (PRD Report)'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity zi_issue_component_qty
  as select distinct from ZI_ManufacturingOrderBOM    as bom
    left outer join       I_MfgOrderDocdGoodsMovement as gm         on  gm.ManufacturingOrder      = bom.ManufacturingOrder
                                                                    and gm.ProductionPlant         = bom.ProductionPlant
                                                                    and gm.GoodsMovementType       = '262'
                                                                    and gm.GoodsMovementRefDocType = 'F'
                                                                    and gm.Material                = bom.BillOfMaterialComponent
    left outer join       zi_issue_component          as ic         on  ic.ManufacturingOrder           = bom.ManufacturingOrder
                                                                    and ic.ProductionPlant              = bom.ProductionPlant
                                                                    and ic.BillOfMaterial               = bom.BillOfMaterial
                                                                    and ic.BillOfMaterialVariant        = bom.BillOfMaterialVariant
                                                                    and ic.BillOfMaterialItemNodeNumber = bom.BillOfMaterialItemNodeNumber
                                                                    and ic.BillOfMaterialComponent      = bom.BillOfMaterialComponent
   

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

      @Semantics.quantity.unitOfMeasure: 'BillOfMaterialItemUnit'
      cast( sum( ic.QuantityInEntryUnit ) as abap.dec(15,3) ) as QTYInEntryUnit261,

      @Semantics.quantity.unitOfMeasure: 'BillOfMaterialItemUnit'
      cast( sum( gm.QuantityInEntryUnit ) as abap.dec(15,3) ) as QTYInEntryUnit262,
      gm.Material                                             as ConsumedMaterial,

      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      cast(sum(gm.TotalGoodsMvtAmtInCCCrcy) as abap.dec(15,2)) as TotalGoodsMvtAmtInCCCrcy262,
       @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      cast(sum(ic.TotalGoodsMvtAmtInCCCrcy261) as abap.dec(15,2))                      as TotalGoodsMvtAmtInLCrcy261,



      gm.CompanyCodeCurrency
}
group by
  bom.ManufacturingOrder,
  bom.ProductionPlant,
  bom.ActualDeliveredQuantity,
  bom.BillOfMaterial,
  bom.BillOfMaterialVariant,
  bom.BillOfMaterialItemNodeNumber,
  bom.BillOfMaterialComponent,
  bom.BillOfMaterialItemQuantity,
  bom.BillOfMaterialItemUnit,
  bom.ProductDescription,
  gm.Material,
  gm.CompanyCodeCurrency
