@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'I View 2 For PRD Report'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI2_PRD_REPORT
  as select distinct from ZPRD_REPORT               as prd
    inner join            ZI_ManufacturingOrderBOM  as bom        on  prd.ManufacturingOrder = bom.ManufacturingOrder
                                                                  and prd.ProductionPlant    = bom.ProductionPlant

    inner join            ZI2_COMP_QTY_PERBOM       as comp       on  prd.ManufacturingOrder      = comp.ManufacturingOrder
                                                                  and bom.BillOfMaterialComponent = comp.BillOfMaterialComponent

    left outer join       zi_issue_component        as icomp      on  prd.ManufacturingOrder      = icomp.ManufacturingOrder
                                                                  and bom.BillOfMaterialComponent = icomp.BillOfMaterialComponent
    left outer join       zi_issue_component_qty    as icompqty   on  prd.ManufacturingOrder      = icomp.ManufacturingOrder
                                                                  and bom.BillOfMaterialComponent = icomp.BillOfMaterialComponent
    left outer join       zi_issue_component_qty_v1 as icompqtyv1 on  prd.ManufacturingOrder      = icompqtyv1.ManufacturingOrder
                                                                  and bom.BillOfMaterialComponent = icompqtyv1.BillOfMaterialComponent


{

  key     prd.ManufacturingOrder,

         prd.MaterialDocumentItem,
 //        prd.MaterialDocument,

          prd.ProductionPlant,
          prd.PlantName,
          prd.MfgOrderActualStartDate,
          prd.Material,
          prd.ProductDescription,
          @Semantics.quantity.unitOfMeasure: 'ProductionUnit'
          prd.MfgOrderPlannedTotalQty,
          prd.ProductionUnit,
          prd.MaterialDocumentYear,
          prd.PostingDate,
          @Semantics.quantity.unitOfMeasure: 'ProductionUnit'
          prd.ActualDeliveredQuantity,
          @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
          prd.TotalOrderGoodsMovementAmount,
          prd.GLAccount,
          prd.GLAccountLongName,
          prd.Batch,
          bom.BillOfMaterialComponent,
          comp.ComponentQtyBOM,
          bom.ProductDescription  as ComponentDescription,
          bom.BillOfMaterialItemUnit,
          icomp.IssueComponent,
          icompqtyv1.IssueComponentQty,
          icomp.IssueComponentDescription,
          icomp.IssueComponentUOM,
          @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
          icompqtyv1.IssueValue,
          icomp.GLAccount         as CompissuedGLCode,
          icomp.GLAccountLongName as CompissuedGLdescription,
          prd.TecoStatus,



          @Semantics.quantity.unitOfMeasure: 'ProductionUnit'
          bom.BillOfMaterialItemQuantity,
          prd.BaseUnit,
          prd.CompanyCodeCurrency,
          /* BOM details */
          bom.BillOfMaterial,
          bom.BillOfMaterialVariant,
          bom.BillOfMaterialItemNodeNumber,
          /* Calculated component qty */
          @Semantics.quantity.unitOfMeasure: 'ProductionUnit'
          comp.BOMHeaderQuantityInBaseUnit

}
