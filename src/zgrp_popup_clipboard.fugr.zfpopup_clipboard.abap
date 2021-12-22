FUNCTION zfpopup_clipboard.
*"----------------------------------------------------------------------
*"*"Interface local:
*"  IMPORTING
*"     REFERENCE(I_DIMENSION) TYPE  ZSDIMENSION OPTIONAL
*"     REFERENCE(I_STRUCTURE) TYPE  RSRD1-DDTYPE_VAL
*"     REFERENCE(I_TITLEBAR) TYPE  STRING
*"  EXPORTING
*"     REFERENCE(E_TABLE) TYPE  ZCT_STRING
*"     REFERENCE(E_GJAHR) TYPE  BKPF-GJAHR
*"----------------------------------------------------------------------

  DATA: lt_table_data  TYPE REF TO data.

  FIELD-SYMBOLS: <row_data> TYPE any,
                 <table>    LIKE LINE OF e_table,
                 <fcat>     LIKE LINE OF gt_fcat,
                 <field>    TYPE any.

  gs_structure = i_structure.
  gv_titlebar  = i_titlebar.

* Create dinamic table to receive import data
  CALL FUNCTION 'LVC_FIELDCATALOG_MERGE'
    EXPORTING
      i_structure_name       = gs_structure
    CHANGING
      ct_fieldcat            = gt_fcat
    EXCEPTIONS
      inconsistent_interface = 1
      program_error          = 2
      OTHERS                 = 3.
  IF sy-subrc <> 0.
    RETURN.
  ENDIF.

  cl_alv_table_create=>create_dynamic_table(
   EXPORTING
    i_style_table             = 'X'
    it_fieldcatalog           = gt_fcat
   IMPORTING
    ep_table                  = lt_table_data
   EXCEPTIONS
    generate_subpool_dir_full = 1
    OTHERS                    = 2 ).

  ASSIGN lt_table_data->* TO <gt_table_data>.

* Call Pop-Up
  IF i_dimension IS NOT INITIAL.

    CALL SCREEN 9000 STARTING AT i_dimension-start_column i_dimension-start_line
                     ENDING AT i_dimension-end_column i_dimension-end_line.

  ELSE.

    CALL SCREEN 9000 STARTING AT 1 1 ENDING AT 40 15.

  ENDIF.

* Return Values
  LOOP AT <gt_table_data> ASSIGNING <row_data>.
    APPEND INITIAL LINE TO e_table ASSIGNING <table>.
    LOOP AT gt_fcat ASSIGNING <fcat>.
      ASSIGN COMPONENT <fcat>-fieldname OF STRUCTURE <row_data> TO <field>.
      IF sy-tabix = 1.
        <table> = <field>.
      ELSE.
        CONCATENATE <table> <field> INTO <table>.
      ENDIF.
    ENDLOOP.
  ENDLOOP.

  e_gjahr = gv_gjahr.

ENDFUNCTION.
