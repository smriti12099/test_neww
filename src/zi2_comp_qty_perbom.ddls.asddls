@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'I2  View For Component QTY as per BOM'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI2_COMP_QTY_PERBOM
  as select distinct from I_ManufacturingOrder        as mo
    inner join            ZI_ManufacturingOrderBOM    as bom on  mo.ManufacturingOrder = bom.ManufacturingOrder
                                                             and mo.ProductionPlant    = bom.ProductionPlant

    inner join            I_BillOfMaterialHeaderDEX_2 as b   on  b.BillOfMaterial        = mo.BillOfMaterial
                                                             and b.BillOfMaterialVariant = mo.BillOfMaterialVariant
{
  key mo.ManufacturingOrder,
      mo.ManufacturingOrderItem,
      mo.BillOfMaterial,
      bom.BillOfMaterialComponent,

      cast(
        round(
          ( bom.BillOfMaterialItemQuantity * mo.ActualDeliveredQuantity )
          / ( b.BOMHeaderQuantityInBaseUnit ),
          3
        )
        as abap.dec(15,3)
      ) as ComponentQtyBOM,
      @Semantics.quantity.unitOfMeasure: 'BillOfMaterialItemUnit'
      b.BOMHeaderQuantityInBaseUnit,
      bom.BillOfMaterialItemUnit
}
