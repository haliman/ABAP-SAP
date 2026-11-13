CLASS zcl_08_path_expr DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_08_path_expr IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.

  SELECT
    FROM Z08_C_EmployeeQuery
    FIELDS employeeid,
           firstname,
           lastname,
           departmentid,
           DepartmentDescription,
           AssistantName,
           \_Department\_Head-LastName AS headname
    INTO TABLE @DATA(result).

    out->write( result ).

  ENDMETHOD.
ENDCLASS.
