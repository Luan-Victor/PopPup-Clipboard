*----------------------------------------------------------------------*
***INCLUDE LZGRP_POPUP_CLIPBOARDI01 .
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_9000  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_9000 INPUT.

  CASE sy-ucomm.
    WHEN con_exit OR con_back OR con_canc OR 'CONFIRM'.

      IF  sy-ucomm <> 'CONFIRM'.
        CLEAR <gt_table_data>.
        CLEAR gv_gjahr.
      ENDIF.

      CALL METHOD go_alv_9000->free.
      CALL METHOD go_cont_9000->free.

      CALL METHOD cl_gui_cfw=>flush.

      CLEAR go_cont_9000.
      CLEAR go_alv_9000.

      SET SCREEN 0.
      LEAVE SCREEN.

    WHEN 'CLIPBOARD'.

      PERFORM clipboard.

    WHEN 'DELETE'.

      PERFORM delete_row.

  ENDCASE.

ENDMODULE.                 " USER_COMMAND_9000  INPUT
