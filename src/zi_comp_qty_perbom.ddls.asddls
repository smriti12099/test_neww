@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'I View For Component QTY as per BOM'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_comp_qty_perBOm as select distinct from I_ManufacturingOrder      as a
    inner join            I_BillOfMaterialHeaderDEX_2 as b on  b.BillOfMaterial        = a.BillOfMaterial
                                                         and b.BillOfMaterialVariant = a.BillOfMaterialVariant
    inner join            I_BillOfMaterialItemBasic as c on  c.BillOfMaterial               = b.BillOfMaterial
//                                                         and c.BillOfMaterialItemNodeNumber = b.BillOfMaterialItemNodeNumber
{
  key a.ManufacturingOrder,
      a.ProductionPlant,
     cast( a.BillOfMaterial as abap.char(8) ) as BillOfMaterial,
      a.BillOfMaterialVariant,
 //     b.BillOfMaterialItemNodeNumber,
      c.BillOfMaterialComponent,
      @Semantics.quantity.unitOfMeasure: 'BillOfMaterialItemUnit'
      c.BillOfMaterialItemQuantity,
      c.BillOfMaterialItemUnit,
      @Semantics.quantity.unitOfMeasure: 'BillOfMaterialItemUnit'
      b.BOMHeaderQuantityInBaseUnit
}
where
  c.IsDeleted <> 'X'
