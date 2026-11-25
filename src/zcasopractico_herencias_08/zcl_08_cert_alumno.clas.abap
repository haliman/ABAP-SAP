CLASS zcl_08_cert_alumno DEFINITION
  PUBLIC
  INHERITING FROM zcl_08_empleado
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    METHODS constructor
        IMPORTING empleado_id TYPE ztraining_empleado_id_08
        RAISING zcx_ztraining_no_empleado_08.

  PROTECTED SECTION.
  PRIVATE SECTION.
    DATA cert_number TYPE c LENGTH 10.

ENDCLASS.



CLASS zcl_08_cert_alumno IMPLEMENTATION.
  METHOD constructor.

    super->constructor( empleado_id = empleado_id ).

    SELECT SINGLE cert_number
        FROM zcert_empl_08
        WHERE empleado_id = @empleado_id
        INTO @me->cert_number.

    IF sy-subrc <> 0.
        RAISE EXCEPTION TYPE zcx_ztraining_no_empleado_08.
    ENDIF.


  ENDMETHOD.

ENDCLASS.
