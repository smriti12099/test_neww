CLASS zcl_sales_rpt DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_rap_query_provider .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_SALES_RPT IMPLEMENTATION.


  METHOD if_rap_query_provider~select.

  IF io_request->is_data_requested( ).

      DATA: lt_response    TYPE TABLE OF zdd_cds_i_sales_,
            ls_response    LIKE LINE OF lt_response,
            lt_responseout LIKE lt_response,
            ls_responseout LIKE LINE OF lt_responseout.

      DATA(lv_top)           = io_request->get_paging( )->get_page_size( ).
      DATA(lv_skip)          = io_request->get_paging( )->get_offset( ).
      DATA(lv_max_rows) = COND #( WHEN lv_top = if_rap_query_paging=>page_size_unlimited THEN 0
                                  ELSE lv_top ).

      DATA(lt_clause)        = io_request->get_filter( )->get_as_ranges( ).
      DATA(lt_parameter)     = io_request->get_parameters( ).
      DATA(lt_fields)        = io_request->get_requested_elements( ).
      DATA(lt_sort)          = io_request->get_sort_elements( ).

      TRY.
          DATA(lt_filter_cond) = io_request->get_filter( )->get_as_ranges( ).
        CATCH cx_rap_query_filter_no_range INTO DATA(lx_no_sel_option).
      ENDTRY.


     LOOP AT lt_filter_cond INTO DATA(ls_filter_cond).
  IF ls_filter_cond-name = 'SALESDOCUMENT'.
    DATA(lt_salesdocument) = ls_filter_cond-range[].
  ELSEIF ls_filter_cond-name = 'ORDERDATE'.
    DATA(lt_orderdate) = ls_filter_cond-range[].
  ELSEIF ls_filter_cond-name = 'SALES_AMOUNT'.
    DATA(lt_sales_amount) = ls_filter_cond-range[].
  ELSEIF ls_filter_cond-name = 'SALES_CURRENCY'.
    DATA(lt_sales_currency) = ls_filter_cond-range[].
  ELSEIF ls_filter_cond-name = 'CUSTOMER'.
    DATA(lt_customer) = ls_filter_cond-range[].
  ELSEIF ls_filter_cond-name = 'CUSTOMER_NAME'.
    DATA(lt_customer_name) = ls_filter_cond-range[].
  ELSEIF ls_filter_cond-name = 'STATUS'.
    DATA(lt_status) = ls_filter_cond-range[].
  ELSEIF ls_filter_cond-name = 'ISPERMITTED'.
    DATA(lt_ispermitted) = ls_filter_cond-range[].
  ENDIF.
ENDLOOP.


   SELECT FROM ztab_sales AS a
  FIELDS
    a~client,
    a~salesdocument,
    a~orderdate,
    a~sales_amount,
    a~sales_currency,
    a~customer,
    a~customer_name,
    a~status,
    a~ispermitted
  where a~salesdocument    IN @lt_salesdocument
    AND a~orderdate        IN @lt_orderdate
    AND a~sales_amount     IN @lt_sales_amount
    AND a~sales_currency   IN @lt_sales_currency
    AND a~customer         IN @lt_customer
    AND a~customer_name    IN @lt_customer_name
    AND a~status           IN @lt_status
    AND a~ispermitted      IN @lt_ispermitted
  INTO TABLE @DATA(it_sales).


     LOOP AT it_sales INTO DATA(wa).
  CLEAR ls_response.
  ls_response-salesdocument   = wa-salesdocument.
  ls_response-orderdate       = wa-orderdate.
  ls_response-sales_amount    = wa-sales_amount.
  ls_response-sales_currency  = wa-sales_currency.
  ls_response-customer        = wa-customer.
  ls_response-customer_name   = wa-customer_name.
  ls_response-status          = wa-status.
  ls_response-ispermitted     = wa-ispermitted.

  APPEND ls_response TO lt_response.
ENDLOOP.

SORT lt_response BY salesdocument.

      lv_max_rows = lv_skip + lv_top.
      IF lv_skip > 0.
        lv_skip = lv_skip + 1.
      ENDIF.

      CLEAR lt_responseout.
      LOOP AT lt_response ASSIGNING FIELD-SYMBOL(<lfs_out_line_item>) FROM lv_skip TO lv_max_rows.
        ls_responseout = <lfs_out_line_item>.
        APPEND ls_responseout TO lt_responseout.
      ENDLOOP.

      io_response->set_total_number_of_records( lines( lt_response ) ).
      io_response->set_data( lt_responseout ).


    ENDIF.

  ENDMETHOD.
ENDCLASS.
