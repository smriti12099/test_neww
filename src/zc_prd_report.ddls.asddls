@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'C View For Production Report'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}

@UI.headerInfo:   {
              typeName: 'PRD Report', typeNamePlural: 'PRD Reports'
              }
define view entity ZC_PRD_REPORT
  as select from ZI2_PRD_REPORT as a

{
@EndUserText.label: 'Process Order No'
  key ManufacturingOrder,
  key MaterialDocumentItem,
  key BillOfMaterialComponent,
      ProductionPlant,
      PlantName,
      MfgOrderActualStartDate,
      Material,
      ProductDescription,
      @Semantics.quantity.unitOfMeasure: 'ProductionUnit'
      MfgOrderPlannedTotalQty,
      ProductionUnit,
      MaterialDocumentYear,
      PostingDate,
      @Semantics.quantity.unitOfMeasure: 'ProductionUnit'
      ActualDeliveredQuantity,
      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      TotalOrderGoodsMovementAmount,
      GLAccount,
      GLAccountLongName,
      Batch,
      round(ComponentQtyBOM, 3)   as ComponentQtyBOM,
      // ComponentQtyBOM,
      ComponentDescription,
      BillOfMaterialItemUnit,
      IssueComponent,
      round(IssueComponentQty, 3) as IssueComponentQty,
      // IssueComponentQty,
      IssueComponentDescription,
      IssueComponentUOM,
      IssueValue,
      CompissuedGLCode,
      CompissuedGLdescription,
      TecoStatus,
      @Semantics.quantity.unitOfMeasure: 'ProductionUnit'
      BillOfMaterialItemQuantity,
      BaseUnit,
      CompanyCodeCurrency,
      BillOfMaterial,
      BillOfMaterialVariant,
      BillOfMaterialItemNodeNumber,
      @Semantics.quantity.unitOfMeasure: 'ProductionUnit'
      BOMHeaderQuantityInBaseUnit
}
