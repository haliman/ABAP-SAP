CLASS zcl_clear_booking_08 DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_clear_booking_08 IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.
      DELETE FROM zvhcle_book_08_d.
       out->write( |Filas borradas en la draft: { sy-dbcnt }| ).
  ENDMETHOD.
ENDCLASS.
