CLASS LHC_ZR_VEH_B_08 DEFINITION INHERITING FROM CL_ABAP_BEHAVIOR_HANDLER.
  PRIVATE SECTION.
    METHODS:
      GET_GLOBAL_AUTHORIZATIONS FOR GLOBAL AUTHORIZATION
        IMPORTING
           REQUEST requested_authorizations FOR ZrVehB08
        RESULT result,
      CalculateTotalDays FOR DETERMINE ON MODIFY
           importing keys FOR ZrVehB08~CalculateTotalDays,
      ValidateDates FOR VALIDATE ON SAVE
           IMPORTING keys FOR ZrVehB08~ValidateDates,
      setInitialStatus FOR DETERMINE ON MODIFY
           IMPORTING keys FOR ZrVehB08~setInitialStatus,
      CancelBooking FOR MODIFY
            IMPORTING keys FOR ACTION ZrVehB08~CancelBooking RESULT result.
ENDCLASS.

CLASS LHC_ZR_VEH_B_08 IMPLEMENTATION.
  METHOD GET_GLOBAL_AUTHORIZATIONS.
  ENDMETHOD.
  METHOD CalculateTotalDays.
    " 1. Leer las reservas afectadas
  READ ENTITIES OF zr_veh_b_08 IN LOCAL MODE
    ENTITY ZrVehB08
      FIELDS ( StartDate EndDate )
      WITH CORRESPONDING #( keys )
    RESULT DATA(bookings).

  DATA bookings_update TYPE TABLE FOR UPDATE zr_veh_b_08\\ZrVehB08.

  LOOP AT bookings INTO DATA(booking).

    " 2-3. Obtener fechas y comprobar que ambas tengan valor
    IF booking-StartDate IS INITIAL OR booking-EndDate IS INITIAL.
      CONTINUE.
    ENDIF.

    " 4. Calcular la diferencia (en días)
    DATA(total_days) = booking-EndDate - booking-StartDate.

    " 5. Preparar la actualización de TotalDays
    APPEND VALUE #( %tky      = booking-%tky
                    TotalDays = total_days ) TO bookings_update.

  ENDLOOP.

  " 6. Modificar la entidad mediante EML
  MODIFY ENTITIES OF zr_veh_b_08 IN LOCAL MODE
    ENTITY ZrVehB08
      UPDATE FIELDS ( TotalDays )
      WITH bookings_update.
  ENDMETHOD.

  METHOD ValidateDates.
    " 1. Leer las instancias afectadas
    READ ENTITIES OF zr_veh_b_08 IN LOCAL MODE
    ENTITY ZrVehB08
      FIELDS ( StartDate EndDate )
      WITH CORRESPONDING #( keys )
    RESULT DATA(bookings).

      " 3. Fecha actual del sistema (en ABAP Cloud no se puede usar sy-datum)
      DATA(today) = cl_abap_context_info=>get_system_date( ).

      " Limpiar mensajes anteriores de esta validation (importante con draft)
      LOOP AT bookings ASSIGNING FIELD-SYMBOL(<booking>).
        APPEND VALUE #( %tky        = <booking>-%tky
                        %state_area = 'VALIDATE_DATES' )
               TO reported-ZrVehB08.
      ENDLOOP.

      LOOP AT bookings ASSIGNING <booking>.

    "8. Fechas inicio y fin obligatorias
      IF <booking>-StartDate IS INITIAL OR <booking>-EndDate IS INITIAL.
        APPEND VALUE #(  %tky = <booking>-%tky ) TO failed-ZrVehB08.
        APPEND VALUE #(
            %tky                = <booking>-%tky
            %state_area         = 'VALIDATE_DATES'
            %msg                = new_message(
                                                id          = 'ZV_B_08'
                                                number      = '001'
                                                severity    = if_abap_behv_message=>severity-error
                                             )
          ) TO reported-ZrVehB08.
        CONTINUE.
      ENDIF.

        " 4. StartDate no puede ser anterior a hoy
        IF <booking>-StartDate IS NOT INITIAL AND <booking>-StartDate < today.

          " 6. Registrar la instancia con error
          APPEND VALUE #( %tky = <booking>-%tky ) TO failed-ZrVehB08.

          " 7. Mensaje 001 de la clase ZVEHICLE_BOOKING
          APPEND VALUE #( %tky               = <booking>-%tky
                          %state_area        = 'VALIDATE_DATES'
                          %msg               = new_message( id       = 'ZV_B_08'
                                                            number   = '005'
                                                            severity = if_abap_behv_message=>severity-error )
                          %element-startdate = if_abap_behv=>mk-on )
                 TO reported-ZrVehB08.

        ENDIF.

        " 5. EndDate no puede ser anterior a StartDate
        IF <booking>-StartDate IS NOT INITIAL
           AND <booking>-EndDate IS NOT INITIAL
           AND <booking>-EndDate < <booking>-StartDate.

          APPEND VALUE #( %tky = <booking>-%tky ) TO failed-ZrVehB08.

          APPEND VALUE #( %tky             = <booking>-%tky
                          %state_area      = 'VALIDATE_DATES'
                          %msg             = new_message( id       = 'ZV_B_08'
                                                          number   = '005'
                                                          severity = if_abap_behv_message=>severity-error )
                          %element-enddate = if_abap_behv=>mk-on )
                 TO reported-ZrVehB08.

        ENDIF.

      ENDLOOP.
  ENDMETHOD.

  METHOD setInitialStatus.

      READ ENTITIES OF zr_veh_b_08 IN LOCAL MODE
        ENTITY ZrVehB08
            FIELDS ( Status )
            WITH CORRESPONDING #( keys )
        RESULT DATA(bookings).

        DELETE bookings WHERE Status IS NOT INITIAL.
        CHECK bookings IS NOT INITIAL.

        MODIFY ENTITIES OF zr_veh_b_08 IN LOCAL MODE
            ENTITY ZrVehB08
                UPDATE FIELDS ( Status )
                WITH VALUE #(
                                FOR b IN bookings (
                                    %tky = b-%tky
                                    Status = 'OPEN'
                                )
                            ).

  ENDMETHOD.

  METHOD CancelBooking.
        READ ENTITIES OF zr_veh_b_08 IN LOCAL MODE
     ENTITY ZrVehB08
       FIELDS ( Status StartDate )
       WITH CORRESPONDING #( keys )
     RESULT DATA(bookings).

    DATA(today) = cl_abap_context_info=>get_system_date( ).

    DATA bookings_update TYPE TABLE FOR UPDATE zr_veh_b_08\\ZrVehB08.

    LOOP AT bookings ASSIGNING FIELD-SYMBOL(<booking>).

      " Ya cancelada
      IF <booking>-Status = 'CANCELLED'.
        APPEND VALUE #( %tky = <booking>-%tky ) TO failed-zrvehb08.
        APPEND VALUE #( %tky = <booking>-%tky
                        %msg = new_message( id       = 'ZV_B_08'
                                            number   = '002'
                                            severity = if_abap_behv_message=>severity-error ) )
               TO reported-ZrVehB08.
        CONTINUE.
      ENDIF.

      " Fecha de inicio pasada
      IF <booking>-StartDate IS NOT INITIAL AND <booking>-StartDate < today.
        APPEND VALUE #( %tky = <booking>-%tky ) TO failed-ZrVehB08.
        APPEND VALUE #( %tky = <booking>-%tky
                        %msg = new_message( id       = 'ZV_B_08'
                                            number   = '004'
                                            severity = if_abap_behv_message=>severity-error ) )
               TO reported-ZrVehB08.
        CONTINUE.
      ENDIF.

      " Cancelación correcta
      APPEND VALUE #( %tky = <booking>-%tky Status = 'CANCELLED' ) TO bookings_update.
      APPEND VALUE #( %tky = <booking>-%tky
                      %msg = new_message( id       = 'ZV_B_08'
                                          number   = '003'
                                          severity = if_abap_behv_message=>severity-success ) )
             TO reported-ZrVehB08.

    ENDLOOP.

    MODIFY ENTITIES OF zr_veh_b_08 IN LOCAL MODE
      ENTITY ZrVehB08
        UPDATE FIELDS ( Status )
        WITH bookings_update.

    READ ENTITIES OF zr_veh_b_08 IN LOCAL MODE
      ENTITY ZrVehB08
        ALL FIELDS WITH CORRESPONDING #( keys )
      RESULT DATA(result_bookings).

    result = VALUE #( FOR b IN result_bookings ( %tky = b-%tky %param = b ) ).
  ENDMETHOD.

ENDCLASS.
