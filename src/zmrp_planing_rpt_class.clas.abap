CLASS zmrp_planing_rpt_class DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
   data:
      username type string,
      pass type string.

    INTERFACES if_rap_query_provider .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZMRP_PLANING_RPT_CLASS IMPLEMENTATION.


METHOD if_rap_query_provider~select.

    DATA:  plant TYPE c LENGTH 4.

    DATA(lv_top) = io_request->get_paging(  )->get_page_size(  ).


**********************************************

    DATA(off) = io_request->get_paging( )->get_offset(  ).
    DATA(pag) = io_request->get_paging( )->get_page_size( ).
    DATA(lv_max_rows) = COND #( WHEN lv_top = if_rap_query_paging=>page_size_unlimited THEN 0
                                ELSE lv_top ).
    DATA(lv_skip)    = io_request->get_paging( )->get_offset( ).
    DATA(lsort) = io_request->get_sort_elements( ) .
    DATA(lv_conditions) = io_request->get_filter(  )->get_as_sql_string(  ).
    DATA(lt_fields)  = io_request->get_requested_elements( ).
    DATA(lt_sort)    = io_request->get_sort_elements( ).

    DATA(set) = io_request->get_requested_elements( )."  --> could be used for optimizations
    DATA(lvs) = io_request->get_search_expression( ).
    DATA(filter1) = io_request->get_filter(  ).
    DATA(p1) = io_request->get_parameters(  ).
    DATA(p2) = io_request->get_requested_elements(  ).

    TRY.
        DATA(ran) = io_request->get_filter( )->get_as_ranges( ).
      CATCH cx_rap_query_filter_no_range.
        "handle exception
    ENDTRY.

     DATA : lv_plant type string.
     DATA : lv_controller type string.

     DATA: lv_mrparea TYPE string.

    LOOP AT ran ASSIGNING FIELD-SYMBOL(<ls_ran>).
      CASE <ls_ran>-name.
        WHEN 'MATERIAL'.
          DATA(lv_material) = <ls_ran>-range.
        WHEN 'MRPAREA'.
          DATA(lv_area) = <ls_ran>-range.
          READ TABLE <ls_ran>-range INTO DATA(ls_area) WITH KEY sign = 'I' option = 'EQ'.
        WHEN 'MRPPLANT'.
        READ TABLE <ls_ran>-range INTO DATA(ls_plant) WITH KEY sign = 'I' option = 'EQ'.

        lv_plant = ls_plant-low.
        lv_mrparea = ls_area-low.

*       WHEN 'MRPCONTROLLER'.
*        READ TABLE <ls_ran>-range INTO DATA(ls_controller) WITH KEY sign = 'I' option = 'EQ'.

*       lv_controller = ls_controller-low.

      ENDCASE.
    ENDLOOP.

    DATA: lv_url TYPE string.
    DATA: attach_url TYPE string VALUE ''.
    DATA: token_http_client TYPE REF TO if_web_http_client,
          gt_return         TYPE STANDARD TABLE OF bapiret2.
    DATA : lv_url2 TYPE string.



*    lv_url = |https://my414464-api.s4hana.cloud.sap/sap/opu/odata/sap/API_MRP_MATERIALS_SRV_01/SupplyDemandItems?$filter=MRPPlant eq '{ plant }'|.
    lv_url = |https://my425943.s4hana.cloud.sap/sap/opu/odata/sap/API_MRP_MATERIALS_SRV_01/SupplyDemandItems/|. "&
*             |$filter=MRPPlant eq '{ plant }'|.
*    DATA(lv_filter) = '$filter=MRPPlant eq ''1710'' and  MRPController eq ''022'''.
*      DATA(lv_filter) = |$filter=MRPPlant eq '{ lv_plant }' and  MRPController eq '{ lv_controller }'|.

  DATA(lv_filter) = |$filter=MRPPlant eq '{ lv_plant } and MRPAREA eq '{ lv_mrparea }'|.



    TRY.
        token_http_client = cl_web_http_client_manager=>create_by_http_destination(
        i_destination = cl_http_destination_provider=>create_by_url( lv_url ) ).
      CATCH cx_web_http_client_error cx_http_dest_provider_error. "#EC NO_HANDLER
        "handle exception
    ENDTRY.


    DATA(token_request) = token_http_client->get_http_request( ).
    token_request->set_uri_path(
     EXPORTING
       i_uri_path = |{ lv_url }?{ lv_filter }|
      ).

    token_request->set_header_fields(
     VALUE #(
               ( name = 'Accept' value = 'application/json' )
               ( name = 'Content-Type'  value = 'application/json' )
               ( name = 'Cache-Control' value = 'no-cache' )
               ( name = 'x-csrf-token' value = 'fetch' )

*               ( name = 'Content-Type'  value = 'text/xml' )
*                ( name  = 'Response-Time'  value = '10000' ) " 10 seconds


                ) ).




    token_request->set_authorization_basic(
EXPORTING
i_username = 'Z_BP_ATTACH_EMAIL'
i_password = '7xi<yZk)tt/(kE)(yL5\<zd7(e(gx9#5q7o5yZMa'
).

    TRY.
        DATA(lv_token_response) = token_http_client->execute(
                              i_method  = if_web_http_client=>get )->get_text(  ).


      CATCH cx_web_http_client_error cx_web_message_error. "#EC NO_HANDLER
        "handle exception
    ENDTRY.


*     out->write( lv_token_response ).
*
*
    TYPES : BEGIN OF ty_result,
              Material                       TYPE c LENGTH 20,
              Mrparea                        TYPE c LENGTH 4,
              Mrpplant                       TYPE c LENGTH 4,
              Mrpplanningsegment             TYPE c LENGTH 10,
              Mrpplanningsegmenttype         TYPE c LENGTH 10,
              Materialshortageprofile        TYPE c LENGTH 10,
              Demandcategorygroup            TYPE c LENGTH 10,
              Demandcategorygroupname        TYPE c LENGTH 30,
              Receiptcategorygroup           TYPE c LENGTH 10,
              Receiptcategorygroupname       TYPE c LENGTH 20,
              Materialbaseunit               TYPE c LENGTH 10,
              Materialbaseunitisocode        TYPE c LENGTH 30,
              Materialbaseunitsapcode        TYPE c LENGTH 10,
              Unitofmeasurename              TYPE c LENGTH 30,
              Unitofmeasuretext              TYPE c LENGTH 30,
              Materialexternalid             TYPE c LENGTH 30,
              Mrpavailability                TYPE c LENGTH 20,
              Materialsafetystockqty         TYPE c LENGTH 30,
              Mrpelementopenquantity         TYPE c LENGTH 10,
              Mrpavailablequantity           TYPE c LENGTH 10,
              Mrpelement                     TYPE c LENGTH 30,
              Mrpelementavailyorrqmtdate     TYPE C LENGTH 10,
              Mrpelementbusinesspartner      TYPE c LENGTH 30,
              Mrpelementbusinesspartnername  TYPE c LENGTH 30,
              Mrpelementbusinesspartnertype  TYPE c LENGTH 20,
              Mrpelementcategory             TYPE c LENGTH 10,
              Mrpelementcategoryshortname    TYPE c LENGTH 30,
              Mrpelementcategoryname         TYPE c LENGTH 30,
              Mrpelementdocumenttype         TYPE c LENGTH 20,
              Mrpelementdocumenttypename     TYPE c LENGTH 30,
              Mrpelementispartiallydelivered TYPE c LENGTH 50,
              Mrpelementisreleased           TYPE c LENGTH 10,
              Mrpelementitem                 TYPE c LENGTH 10,
              Mrpelementquantityisfirm       TYPE c LENGTH 30,
              Mrpelementscheduleline         TYPE c LENGTH 10,
              Productionversion              TYPE c LENGTH 10,
              Sourcemrpelement               TYPE c LENGTH 20,
              Sourcemrpelementcategory       TYPE c LENGTH 10,
              Sourcemrpelementitem           TYPE c LENGTH 20,
              Sourcemrpelementscheduleline   TYPE c LENGTH 20,
              Storagelocation                TYPE c LENGTH 30,
              Timehorizoncode                TYPE c LENGTH 20,
              Exceptionmessagenumber         TYPE c LENGTH 50,
              Exceptionmessagetext           TYPE c LENGTH 50,
              Exceptionmessagenumber2        TYPE c LENGTH 50,
              Exceptionmessagetext2          TYPE c LENGTH 50,
              Periodtype                     TYPE c LENGTH 100,
              Periodorsegment                TYPE c LENGTH 100,
              Numberofworkdaysperperiod      TYPE c LENGTH 100,
              Numberofaggregateditems        TYPE c LENGTH 100,
              Mrpcontroller                  TYPE c LENGTH 10,
              Mrpelementreschedulingdate     TYPE c LENGTH 100,
              Plndindeprqmtversion           TYPE c LENGTH 100,
              Materialshortageprofilecount   TYPE c LENGTH 100,
              Mrpelementbpfullcombinedname   TYPE c LENGTH 100,
              Mrpelementbpshortcombinedname  TYPE c LENGTH 100,
              Mrpelementbpname1              TYPE c LENGTH 100,
            END OF ty_result.



    DATA: it_result TYPE TABLE OF ty_result,
          it_final  TYPE TABLE OF ty_result,
          ls_final  TYPE  ty_result.

*    DATA: it_zmrpf4 type table of ZF4_MRPCUSTABLE,
*          wa_zmrpf4 type ZF4_MRPCUSTABLE.

    DATA:lv_string1      TYPE string,
         lv_string2      TYPE string,
         lv_string3      TYPE string,
         lv_final_string TYPE string,
         lv_mat          TYPE string,
         lv_rest         TYPE string.



    SPLIT lv_token_response AT '[' INTO lv_string2 lv_string3.

    lv_string3 = |{ '[' && lv_string3 }|.

    /ui2/cl_json=>deserialize(
     EXPORTING
     json =  lv_string3
     pretty_name = /ui2/cl_json=>pretty_mode-camel_case
     CHANGING
     data   = it_result
     ).

    DATA(lv_flag) = 'x'.

    LOOP AT it_result ASSIGNING FIELD-SYMBOL(<wa_result>) WHERE Material IN lv_material
                                                            and    MRPArea  IN lv_area.
*                                                            and  mrpplant IN ls_plant.
*                                                               and mrpcontroller IN lv_controller .

      ls_final-Material = <wa_result>-Material.
      ls_final-Mrparea  = <wa_result>-Mrparea.
      ls_final-Mrpplant = <wa_result>-Mrpplant.
      ls_final-Mrpplanningsegment = <wa_result>-Mrpplanningsegment.
      ls_final-Mrpplanningsegmenttype = <wa_result>-Mrpplanningsegmenttype.
      ls_final-Materialshortageprofile = <wa_result>-Materialshortageprofile.
      ls_final-Demandcategorygroup = <wa_result>-Demandcategorygroup.
      ls_final-Demandcategorygroupname = <wa_result>-Demandcategorygroupname.
      ls_final-Receiptcategorygroup = <wa_result>-Receiptcategorygroup.
      ls_final-Receiptcategorygroupname = <wa_result>-Receiptcategorygroupname.
      ls_final-Materialbaseunit = <wa_result>-Materialbaseunit.
      ls_final-Materialbaseunitisocode = <wa_result>-Materialbaseunitisocode.
      ls_final-Materialbaseunitsapcode  = <wa_result>-Materialbaseunitsapcode.
      ls_final-Unitofmeasurename = <wa_result>-Unitofmeasurename.
      ls_final-Unitofmeasuretext = <wa_result>-Unitofmeasuretext.
      ls_final-Materialexternalid = <wa_result>-Materialexternalid.
      ls_final-Mrpavailability  = <wa_result>-Mrpavailability.
      ls_final-Materialsafetystockqty = <wa_result>-Materialsafetystockqty.
      ls_final-Mrpelementopenquantity = <wa_result>-Mrpelementopenquantity.
      ls_final-Mrpavailablequantity = <wa_result>-Mrpavailablequantity.
      ls_final-Mrpelement = <wa_result>-Mrpelement.
      ls_final-Mrpelementavailyorrqmtdate = <wa_result>-Mrpelementavailyorrqmtdate.
      ls_final-Mrpelementbusinesspartner = <wa_result>-Mrpelementbusinesspartner.
      ls_final-Mrpelementbusinesspartnername = <wa_result>-Mrpelementbusinesspartnername.
      ls_final-Mrpelementbusinesspartnertype = <wa_result>-Mrpelementbusinesspartnertype.
      ls_final-Mrpelementcategory = <wa_result>-Mrpelementcategory.
      ls_final-Mrpelementcategoryshortname = <wa_result>-Mrpelementcategoryshortname.
      ls_final-Mrpelementcategoryname = <wa_result>-Mrpelementcategoryname.
      ls_final-Mrpelementdocumenttype = <wa_result>-Mrpelementdocumenttype.
      ls_final-Mrpelementdocumenttypename = <wa_result>-Mrpelementdocumenttypename.
      ls_final-Mrpelementispartiallydelivered = <wa_result>-Mrpelementispartiallydelivered.
      ls_final-Mrpelementisreleased = <wa_result>-Mrpelementisreleased.
      ls_final-Mrpelementitem = <wa_result>-Mrpelementitem.
      ls_final-Mrpelementquantityisfirm = <wa_result>-Mrpelementquantityisfirm.
      ls_final-Mrpelementscheduleline = <wa_result>-Mrpelementscheduleline.
      ls_final-Productionversion = <wa_result>-Productionversion.
      ls_final-Sourcemrpelement = <wa_result>-Sourcemrpelement.
      ls_final-Sourcemrpelementcategory = <wa_result>-Sourcemrpelementcategory.
      ls_final-Sourcemrpelementitem = <wa_result>-Sourcemrpelementitem.
      ls_final-Sourcemrpelementscheduleline = <wa_result>-Sourcemrpelementscheduleline.
      ls_final-Storagelocation = <wa_result>-Storagelocation.
      ls_final-Timehorizoncode = <wa_result>-Timehorizoncode.
      ls_final-Exceptionmessagenumber = <wa_result>-Exceptionmessagenumber.
      ls_final-Exceptionmessagetext = <wa_result>-Exceptionmessagetext.
      ls_final-Exceptionmessagenumber2 = <wa_result>-Exceptionmessagenumber2.
      ls_final-Exceptionmessagetext2 = <wa_result>-Exceptionmessagetext2.
      ls_final-Periodtype =  <wa_result>-Periodtype.
      ls_final-Periodorsegment = <wa_result>-Periodorsegment.
      ls_final-Numberofworkdaysperperiod = <wa_result>-Numberofworkdaysperperiod.
      ls_final-Numberofaggregateditems = <wa_result>-Numberofaggregateditems.
      ls_final-Mrpcontroller = <wa_result>-Mrpcontroller.
      ls_final-Mrpelementreschedulingdate = <wa_result>-Mrpelementreschedulingdate.
      ls_final-Plndindeprqmtversion = <wa_result>-Plndindeprqmtversion.
      ls_final-Materialshortageprofilecount = <wa_result>-Materialshortageprofilecount.
      ls_final-Mrpelementbpfullcombinedname = <wa_result>-Mrpelementbpfullcombinedname.
      ls_final-Mrpelementbpshortcombinedname = <wa_result>-Mrpelementbpshortcombinedname.
      ls_final-Mrpelementbpname1 = <wa_result>-Mrpelementbpname1.

append : ls_final to it_final.
clear : ls_final.
    ENDLOOP.

     loop at it_final ASSIGNING FIELD-SYMBOL(<fa_final>).
*     wa_zmrpf4-material = <fa_final>-material.
*     wa_zmrpf4-mrparea = <fa_final>-mrparea.
*     wa_zmrpf4-mrpplant = <fa_final>-mrpplant.
*     wa_zmrpf4-mrpcontroller = <fa_final>-mrpcontroller.
*     append wa_zmrpf4 to it_zmrpf4.
     endloop.

*      Modify ZF4_MRPCUSTABLE from table @it_zmrpf4.



     select DISTINCT * FROM @it_final AS it_final      "#EC CI_NOWHERE
    order by  material
    into table @data(it_output)
    offset @lv_skip UP TO @lv_max_rows ROWS.


     SELECT COUNT( * )
    FROM @it_final AS it_final
    INTO @DATA(lv_totcount).




    io_response->set_total_number_of_records( lv_totcount ).
    io_response->set_data( it_output ).

*endif.

  ENDMETHOD.
ENDCLASS.
