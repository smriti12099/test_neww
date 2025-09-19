CLASS lhc_ZC_MRP_PLANING_REPORT DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR zc_mrp_planing_report RESULT result.

    METHODS get_global_authorizations FOR GLOBAL AUTHORIZATION
      IMPORTING REQUEST requested_authorizations FOR zc_mrp_planing_report RESULT result.

    METHODS create FOR MODIFY
      IMPORTING entities FOR CREATE zc_mrp_planing_report.

    METHODS update FOR MODIFY
      IMPORTING entities FOR UPDATE zc_mrp_planing_report.

    METHODS delete FOR MODIFY
      IMPORTING keys FOR DELETE zc_mrp_planing_report.

    METHODS read FOR READ
      IMPORTING keys FOR READ zc_mrp_planing_report RESULT result.

    METHODS lock FOR LOCK
      IMPORTING keys FOR LOCK zc_mrp_planing_report.

ENDCLASS.

CLASS lhc_ZC_MRP_PLANING_REPORT IMPLEMENTATION.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD get_global_authorizations.
  ENDMETHOD.

  METHOD create.
  ENDMETHOD.

  METHOD update.
  ENDMETHOD.

  METHOD delete.
  ENDMETHOD.

  METHOD read.
  ENDMETHOD.

  METHOD lock.
  ENDMETHOD.

ENDCLASS.

CLASS lsc_ZC_MRP_PLANING_REPORT DEFINITION INHERITING FROM cl_abap_behavior_saver.
  PROTECTED SECTION.

    METHODS finalize REDEFINITION.

    METHODS check_before_save REDEFINITION.

    METHODS save REDEFINITION.

    METHODS cleanup REDEFINITION.

    METHODS cleanup_finalize REDEFINITION.

ENDCLASS.

CLASS lsc_ZC_MRP_PLANING_REPORT IMPLEMENTATION.

  METHOD finalize.
  ENDMETHOD.

  METHOD check_before_save.
  ENDMETHOD.

  METHOD save.
  ENDMETHOD.

  METHOD cleanup.
  ENDMETHOD.

  METHOD cleanup_finalize.
  ENDMETHOD.

ENDCLASS.
