@AbapCatalog.sqlViewName: 'ZMFGORDERTOTAL'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Manufacturing Order Total Amount'
@Metadata.ignorePropagatedAnnotations: true
define view ZIMFGORDER_TOTALAMOUNT as select from I_GoodsMovementCube as gc
  
  // Join to the goods movement details to get the amount
  inner join I_MfgOrderDocdGoodsMovement as gm_amt on  gc.MaterialDocument     = gm_amt.GoodsMovement
                                                   and gc.MaterialDocumentYear = gm_amt.GoodsMovementYear
                                                   and gc.MaterialDocumentItem   = '0001'
                                                   and gc.GoodsMovementIsCancelled <> 'X'
                                                   and gm_amt.GoodsMovementRefDocType  = 'F'
{
      // The key for our aggregation 
  key gc.ManufacturingOrder,
      
      // The currency for the amount
      gm_amt.CompanyCodeCurrency,
      
      // Calculate the sum for all items of the non-cancelled documents
      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      sum(gm_amt.TotalGoodsMvtAmtInCCCrcy) as TotalOrderGoodsMovementAmount

}
// Group by the order and currency to get a single total
where gc.GoodsMovementIsCancelled <> 'X'
group by
  gc.ManufacturingOrder,
  gm_amt.CompanyCodeCurrency
