CLASS zcl_08_course_catalog DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    TYPES: BEGIN OF ty_cursos,
        course_id       TYPE c LENGTH 4,
        title           TYPE /dmo/title,
        modality        TYPE c LENGTH 20,
        country_code    TYPE zcountry_code_08,
    END OF ty_cursos,
    tt_cursos TYPE STANDARD TABLE OF ty_cursos WITH NON-UNIQUE KEY course_id.

    INTERFACES if_oo_adt_classrun .

    METHODS get_available_courses
        IMPORTING
            i_country_code TYPE zcountry_code_08
        RETURNING VALUE(r_courses) TYPE tt_cursos.

  PROTECTED SECTION.
  PRIVATE SECTION.


ENDCLASS.

CLASS zcl_08_course_catalog IMPLEMENTATION.

  METHOD if_oo_adt_classrun~main.
    DATA(lt_cursos) = get_available_courses(
        i_country_code = 'ES'
    ).

    out->write( lt_cursos ).

  ENDMETHOD.

  METHOD get_available_courses.

    SELECT FROM z08cursos
        FIELDS
            course_id,
            title,
            modality,
            country_code
        WHERE country_code = @i_country_code OR modality = 'ONLINE'
        ORDER BY course_id ASCENDING
        INTO TABLE @r_courses.

  ENDMETHOD.

ENDCLASS.
