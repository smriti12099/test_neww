@AbapCatalog.sqlViewName: 'ZBOMSUMMARY'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'BOM Summary'
@Metadata.ignorePropagatedAnnotations: true
define view ZBOM_SUMMARY as  select from I_BillOfMaterialItemDEX_3
{
 key BillOfMaterial,
  BillOfMaterialVariant,
// BillOfMaterialItemNodeNumber,
  count(*) as ItemCount
  
}
group by BillOfMaterial, BillOfMaterialVariant;
