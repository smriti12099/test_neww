@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'I View For Production Report'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZPRD_REPORT
  as select from    I_MfgOrderDocdGoodsMovement as gm

    inner join      I_Plant                     as pl      on gm.ProductionPlant = pl.Plant

    inner join      I_GoodsMovementCube         as gc      on  gc.ManufacturingOrder       =  gm.ManufacturingOrder
                                                           and gc.MaterialDocument         =  gm.GoodsMovement
                                                           and gc.MaterialDocumentYear     =  gm.GoodsMovementYear
                                                           and gc.MaterialDocumentItem     =  gm.GoodsMovementItem
                                                           and gc.GoodsMovementIsCancelled <> 'X'
                                                           and gm.GoodsMovementType        =  '101'
                                                           and gm.GoodsMovementRefDocType  =  'F'

    inner join      I_ManufacturingOrder        as mo      on  gm.ManufacturingOrder = mo.ManufacturingOrder
                                                           and gm.ProductionPlant    = mo.ProductionPlant

    inner join      I_ProductDescription        as pd      on  gm.Material = pd.Product
                                                           and pd.Language = $session.system_language

    left outer join ZIMFGORDER_TOTALAMOUNT      as _totals on gm.ManufacturingOrder = _totals.ManufacturingOrder

    left outer join I_GLAccountText             as gat     on  gm.GLAccount = gat.GLAccount
                                                           and gat.Language = $session.system_language


{

  key gm.ManufacturingOrder,
  key gc.MaterialDocument,
      gc.MaterialDocumentItem,
      gm.PostingDate,
      gm.ProductionPlant,
      pl.PlantName,
      mo.MfgOrderActualStartDate,
      gm.Material,
      pd.ProductDescription,
      mo.ProductionUnit,

      @Semantics.quantity.unitOfMeasure: 'ProductionUnit'
      mo.ActualDeliveredQuantity,

      @Semantics.quantity.unitOfMeasure: 'ProductionUnit'
      mo.MfgOrderPlannedTotalQty,
      gm.BaseUnit,

      gc.MaterialDocumentYear,

      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      _totals.TotalOrderGoodsMovementAmount,

      _totals.CompanyCodeCurrency,

      gm.GLAccount,
      gat.GLAccountLongName,
      gm.Batch,

      case
         when mo.MfgOrderActualCompletionDate is null
              then 'No'
         else 'Yes'
      end as TecoStatus


}
group by
  gm.ProductionPlant,
  gm.ManufacturingOrder,
  pl.PlantName,
  gm.PostingDate,
  mo.MfgOrderActualStartDate,
  gm.Material,
  pd.ProductDescription,
  mo.ProductionUnit,
  mo.ActualDeliveredQuantity,
  mo.MfgOrderPlannedTotalQty,
  gm.BaseUnit,
  gc.MaterialDocument,
  gc.MaterialDocumentItem,
  gc.MaterialDocumentYear,
  _totals.CompanyCodeCurrency,
  gm.GLAccount,
  gat.GLAccountLongName,
  _totals.TotalOrderGoodsMovementAmount,
  gm.Batch,
  mo.MfgOrderActualCompletionDate
