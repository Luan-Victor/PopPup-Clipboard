FUNCTION-POOL zgrp_popup_clipboard.         "MESSAGE-ID ..

CONSTANTS: con_true TYPE char1 VALUE 'X',

           con_ok   TYPE sy-ucomm VALUE 'OK',
           con_exit TYPE sy-ucomm VALUE '&F12',
           con_canc TYPE sy-ucomm VALUE '&F15',
           con_back TYPE sy-ucomm VALUE '&F03'.

TYPES: BEGIN OF ty_bkpf,
        belnr TYPE bkpf-belnr,
       END OF ty_bkpf,

       BEGIN OF ty_clipboard,
         field(1024) TYPE c,
       END OF ty_clipboard.

DATA: "go_report      TYPE REF TO zcl_subcontratacao,
      "gt_report      TYPE TABLE OF ty_bkpf,
      go_alv_9000    TYPE REF TO cl_gui_alv_grid,
      go_cont_9000   TYPE REF TO cl_gui_custom_container,
      go_parent_9000 TYPE REF TO cl_gui_container,
      gv_gjahr       TYPE bkpf-gjahr,
      gv_total_rows  TYPE i,
      gs_structure   TYPE RSRD1-DDTYPE_VAL,
      gt_fcat        TYPE lvc_t_fcat,
      gv_titlebar    TYPE string.

FIELD-SYMBOLS: <gt_table_data> TYPE STANDARD TABLE.

* INCLUDE LZGRP_POPUP_CLIPBOARDD...          " Local class definition
