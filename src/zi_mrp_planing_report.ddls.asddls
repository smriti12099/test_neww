@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'I View For MRP Planing Report'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_MRP_PLANING_REPORT 
as select from I_MaterialDocumentHeader_2 as header
left outer join I_MaterialDocumentItem_2 as item on header.MaterialDocument = item.MaterialDocument

{


key header.MaterialDocument,
key item.MaterialDocumentItem,
key header.MaterialDocumentYear,
header.DocumentDate,
header.PostingDate,
item.Material
}
