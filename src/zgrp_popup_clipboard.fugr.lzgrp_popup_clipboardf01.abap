*----------------------------------------------------------------------*
***INCLUDE LZGRP_POPUP_CLIPBOARDF01 .
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Form  DISPLAY_POPUP
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM display_popup .

  DATA: ls_layout  TYPE lvc_s_layo,
        ls_stable  TYPE lvc_s_stbl.

  FIELD-SYMBOLS: <fcat> LIKE LINE OF gt_fcat.

* Update total rows
  gv_total_rows = lines( <gt_table_data> ).

* Edit layout
  CLEAR ls_layout.
  ls_layout-sel_mode   = 'A'.
  ls_layout-no_toolbar = 'X'.

  LOOP AT gt_fcat ASSIGNING <fcat>.
    <fcat>-col_opt = abap_true.
  ENDLOOP.

  IF go_cont_9000 IS BOUND.

    go_alv_9000->set_frontend_fieldcatalog( it_fieldcatalog = gt_fcat ).

    ls_stable-row = abap_true.
    ls_stable-col = abap_true.

    go_alv_9000->refresh_table_display(
      EXPORTING
        is_stable      = ls_stable        " With Stable Rows/Columns
      EXCEPTIONS
        finished       = 1                " Display was Ended (by Export)
        OTHERS         = 2   ).
    IF sy-subrc <> 0.
      MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
        WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
    ENDIF.

  ELSE.

* Cria o Container para a tela do ALV
    CREATE OBJECT go_cont_9000
      EXPORTING
        container_name              = 'GO_CONTAINER'
      EXCEPTIONS
        cntl_error                  = 1
        cntl_system_error           = 2
        create_error                = 3
        lifetime_error              = 4
        lifetime_dynpro_dynpro_link = 5
        OTHERS                      = 6.
    IF sy-subrc IS NOT INITIAL.
      LEAVE TO LIST-PROCESSING.
    ENDIF.

* Cria Instância do ALV, referenciando o Container gerado acima
    CREATE OBJECT go_alv_9000
      EXPORTING
        i_parent = go_cont_9000.

* Exibe o ALV
    go_alv_9000->set_table_for_first_display(
     EXPORTING
       i_save                        = 'A'                 " Save Layout
       is_layout                     = ls_layout           " Layout
      CHANGING
       it_outtab                     = <gt_table_data>         " Output Table
       it_fieldcatalog               = gt_fcat                 " Field Catalog
     EXCEPTIONS
       invalid_parameter_combination = 1                " Wrong Parameter
       program_error                 = 2                " Program Errors
       too_many_lines                = 3                " Too many Rows in Ready for Input Grid
       OTHERS                        = 4 ).

    IF sy-subrc <> 0.
      MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
        WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
    ENDIF.

  ENDIF.

ENDFORM.                    " DISPLAY_POPUP
*&---------------------------------------------------------------------*
*&      Form  CLIPBOARD
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM clipboard.

  DATA: lt_clipboard TYPE STANDARD TABLE OF ty_clipboard,
        lv_length    TYPE i.

  FIELD-SYMBOLS: <clipboard> LIKE LINE OF lt_clipboard,
                 <row_data>    TYPE any,
                 <fcat>        LIKE LINE OF gt_fcat,
                 <field>       TYPE any.

  CALL METHOD cl_gui_frontend_services=>clipboard_import
    IMPORTING
      data                 = lt_clipboard
      length               = lv_length
    EXCEPTIONS
      cntl_error           = 1
      error_no_gui         = 2
      not_supported_by_gui = 3
      OTHERS               = 4.
  IF sy-subrc <> 0.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
               WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.

  LOOP AT lt_clipboard ASSIGNING <clipboard>.
    APPEND INITIAL LINE TO <gt_table_data> ASSIGNING <row_data>.
    LOOP AT gt_fcat ASSIGNING <fcat>.
      ASSIGN COMPONENT <fcat>-fieldname OF STRUCTURE <row_data> TO <field>.
      IF <field> IS ASSIGNED.
        <field> = <clipboard>-field.
      ENDIF.
    ENDLOOP.
  ENDLOOP.

  SORT <gt_table_data>.
  DELETE ADJACENT DUPLICATES FROM <gt_table_data> COMPARING ALL FIELDS.

ENDFORM.                    " CLIPBOARD
*&---------------------------------------------------------------------*
*&      Form  DELETE_ROW
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM delete_row .

  DATA: lt_rows TYPE lvc_t_row.
  FIELD-SYMBOLS: <row> LIKE LINE OF lt_rows.

  CALL METHOD go_alv_9000->get_selected_rows
    IMPORTING
      et_index_rows = lt_rows.
  CALL METHOD cl_gui_cfw=>flush.

  SORT lt_rows BY index DESCENDING.

  LOOP AT lt_rows ASSIGNING <row>.
    DELETE <gt_table_data> INDEX <row>-index.
  ENDLOOP.

ENDFORM.                    " DELETE_ROW
