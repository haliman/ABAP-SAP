CLASS zcl_08_empleado DEFINITION
  PUBLIC
  CREATE PUBLIC .

  PUBLIC SECTION.
    DATA empleado_id    TYPE ztraining_empleado_id_08 READ-ONLY.
    DATA first_name     TYPE ztraining_first_name_08 READ-ONLY.
    DATA last_name      TYPE ztraining_last_name_08 READ-ONLY.

    METHODS constructor
        IMPORTING empleado_id TYPE ztraining_empleado_id_08
        RAISING zcx_ztraining_no_empleado_08.

  PROTECTED SECTION.
    DATA speciality TYPE ztraining_speciality_08.

  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_08_empleado IMPLEMENTATION.
  METHOD constructor.
    me->empleado_id = empleado_id.

    SELECT SINGLE first_name, LAST_name, speciality
        FROM zempleado_08
        WHERE empleado_id = @empleado_id
        INTO ( @me->first_name, @me->last_name, @me->speciality ).

    IF sy-subrc <> 0.
        RAISE EXCEPTION TYPE zcx_ztraining_no_empleado_08.
    ENDIF.
  ENDMETHOD.

ENDCLASS.
