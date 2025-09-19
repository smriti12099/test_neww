@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'I View For Mfg Order Doc Min Max (PRD Report)'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_MfgOrderDoc_MinMax as select from I_GoodsMovementCube as cube
{
  key cube.ManufacturingOrder,
      min(cube.MaterialDocument) as MinMaterialDocument,
      max(cube.MaterialDocument) as MaxMaterialDocument
}
where cube.GoodsMovementIsCancelled <> 'X'
group by cube.ManufacturingOrder;
