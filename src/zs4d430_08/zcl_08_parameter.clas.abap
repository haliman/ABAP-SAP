CLASS zcl_08_parameter DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_08_PARAMETER IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.

    Data(lv_date) = cl_abap_context_info=>get_system_date(  ).
    SELECT FROM Z08_C_EmployeeQueryP(
                                        p_target_curr   = 'JPY'
*                                        p_date          = @lv_date
                                    )
        FIELDS employeeid,
               firstname,
               lastname,
               departmentid,

               departmentdescription,
               AssistanName,
               \_department\_head-lastname AS headname,

               MonthlySalaryConverted,
               CurrencyCode,
               CompanyAffiliation

        INTO TABLE @DATA(result).

    out->write( result ).

  ENDMETHOD.
ENDCLASS.
