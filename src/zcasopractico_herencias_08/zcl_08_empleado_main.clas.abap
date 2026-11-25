CLASS zcl_08_empleado_main DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_08_empleado_main IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.
  TRY.
    DATA(lo_cert) = NEW zcl_08_cert_alumno( empleado_id = '00001' ).
    out->write( |{ lo_cert->first_name } { lo_cert->last_name }| ).
  CATCH zcx_ztraining_no_empleado_08  INTO DATA(lx).
    out->write( lx->get_text( ) ).
ENDTRY.
  ENDMETHOD.
ENDCLASS.
