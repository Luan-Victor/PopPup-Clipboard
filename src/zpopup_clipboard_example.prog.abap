*&---------------------------------------------------------------------*
*& Report  ZPOPUP_CLIPBOARD_EXAMPLE
*&
*&---------------------------------------------------------------------*
*&
*&
*&---------------------------------------------------------------------*

REPORT  zpopup_clipboard_example.

DATA: ls_dimension TYPE zsdimension,
      lt_data      TYPE zct_string.

START-OF-SELECTION.

  ls_dimension-start_column = 1.
  ls_dimension-start_line   = 1.
  ls_dimension-end_column   = 40.
  ls_dimension-end_line     = 15.

* Call pop-up
  CALL FUNCTION 'ZFPOPUP_CLIPBOARD'
    EXPORTING
     I_DIMENSION  = ls_dimension
      i_structure = 'ZBELNRD'
      i_titlebar  = 'Paste entries'
    IMPORTING
      e_table     = lt_data.
*   E_GJAHR           =
