@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'I View For BOM Components (PRD Report)'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_ManufacturingOrderBOM
  as select distinct from I_ManufacturingOrder      as a
    inner join            I_BillOfMaterialItemDEX_3 as b on  b.BillOfMaterial        = a.BillOfMaterial
                                                         and b.BillOfMaterialVariant = a.BillOfMaterialVariant
    inner join            I_BillOfMaterialItemBasic as c on  c.BillOfMaterial               = b.BillOfMaterial
                                                         and c.BillOfMaterialItemNodeNumber = b.BillOfMaterialItemNodeNumber
    inner join            I_ProductDescription      as d on  d.Product  = c.BillOfMaterialComponent
                                                         and d.Language = 'E'
{
  key a.ManufacturingOrder,
      a.ProductionPlant,
      @Semantics.quantity.unitOfMeasure: 'BillOfMaterialItemUnit'
      a.ActualDeliveredQuantity,
      cast( a.BillOfMaterial as abap.char(8) ) as BillOfMaterial,
      a.BillOfMaterialVariant,
      b.BillOfMaterialItemNodeNumber,
      c.BillOfMaterialComponent,
      @Semantics.quantity.unitOfMeasure: 'BillOfMaterialItemUnit'
      c.BillOfMaterialItemQuantity,
      c.BillOfMaterialItemUnit,
      d.ProductDescription
}
where
  c.IsDeleted <> 'X'
