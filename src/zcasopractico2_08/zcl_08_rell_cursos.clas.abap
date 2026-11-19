CLASS zcl_08_rell_cursos DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
    TYPES: BEGIN OF ty_cursos,
        course_id       TYPE c LENGTH 4,
        title           TYPE /dmo/title,
        modality        TYPE c LENGTH 20,
        country_code    TYPE zcountry_code_08,
    END OF ty_cursos,
    tt_cursos TYPE STANDARD TABLE OF ty_cursos WITH NON-UNIQUE KEY course_id.


ENDCLASS.



CLASS zcl_08_rell_cursos IMPLEMENTATION.

  METHOD if_oo_adt_classrun~main.

    DATA lt_cursos TYPE STANDARD TABLE OF z08cursos.

    lt_cursos = VALUE #(

      ( course_id = 'C001' title = 'ABAP Basic'
        modality = 'PRESENCIAL' country_code = 'ES' )

      ( course_id = 'C002' title = 'ABAP Cloud'
        modality = 'ONLINE' country_code = '' )

      ( course_id = 'C003' title = 'SAP BTP'
        modality = 'PRESENCIAL' country_code = 'DE' )

      ( course_id = 'C004' title = 'CDS Views'
        modality = 'ONLINE' country_code = '' )

      ( course_id = 'C005' title = 'RAP Develo'
        modality = 'PRESENCIAL' country_code = 'ES' )

    ).

    INSERT z08cursos FROM TABLE @lt_cursos.

  ENDMETHOD.
ENDCLASS.
