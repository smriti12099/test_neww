@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'I View ForMfg Order Material Doc (PRD Report)'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity Zi_MfgOrderMaterialDoc as select distinct from I_MfgOrderDocdGoodsMovement as mgmt
    inner join I_GoodsMovementCube as cube
      on  mgmt.ManufacturingOrder = cube.ManufacturingOrder
      and mgmt.GoodsMovement      = cube.MaterialDocument
      and mgmt.GoodsMovementYear  = cube.MaterialDocumentYear
    inner join ZI_ManufacturingOrderBOM as bom
      on  mgmt.ManufacturingOrder = bom.ManufacturingOrder
      and mgmt.ProductionPlant    = bom.ProductionPlant
{
  key mgmt.ManufacturingOrder,
      mgmt.Material,
      mgmt.PostingDate,
      mgmt.ProductionPlant,
 
      /* ✅ pick just one document per BOM component */
      min(cube.MaterialDocument)   as MaterialDocument,
      mgmt.GoodsMovementYear       as MaterialDocumentYear,
 
      bom.BillOfMaterialComponent
}
where
      mgmt.GoodsMovementType        = '101'
  and mgmt.GoodsMovementRefDocType  = 'F'
  and cube.GoodsMovementIsCancelled <> 'X'
group by
      mgmt.ManufacturingOrder,
      mgmt.Material,
      mgmt.PostingDate,
      mgmt.ProductionPlant,
      mgmt.GoodsMovementYear,
      bom.BillOfMaterialComponent;
