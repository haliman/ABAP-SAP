CLASS lhc_zr_vehicle_book_08 DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.
    METHODS:
      get_global_authorizations FOR GLOBAL AUTHORIZATION
        IMPORTING
        REQUEST requested_authorizations FOR ZrVehicleBook08
        RESULT result,
      CalculateTotalDays FOR DETERMINE ON MODIFY
        IMPORTING keys FOR ZrVehicleBook08~CalculateTotalDays,
      ValidateDates FOR VALIDATE ON SAVE
        IMPORTING keys FOR ZrVehicleBook08~ValidateDates,
      setInitialStatus FOR DETERMINE ON MODIFY
        IMPORTING keys FOR ZrVehicleBook08~setInitialStatus,
      CancelBooking FOR MODIFY
        IMPORTING keys FOR ACTION ZrVehicleBook08~CancelBooking RESULT result.
ENDCLASS.

CLASS lhc_zr_vehicle_book_08 IMPLEMENTATION.
  METHOD get_global_authorizations.
  ENDMETHOD.
  METHOD CalculateTotalDays.

    READ ENTITIES OF zr_vehicle_book_08 IN LOCAL MODE
        ENTITY ZrVehicleBook08
            FIELDS ( StartDate endDate )
            WITH CORRESPONDING #( keys )
        RESULT DATA(bookings).

    DATA: bookings_update TYPE TABLE FOR UPDATE zr_vehicle_book_08\\ZrVehicleBook08.

    LOOP AT bookings ASSIGNING FIELD-SYMBOL(<booking>).

      IF <booking>-StartDate IS INITIAL OR <booking>-EndDate IS INITIAL.
        CONTINUE.
      ENDIF.

      APPEND VALUE #(
                      %tky        = <booking>-%tky
                      Totaldays   = <booking>-EndDate - <booking>-StartDate
      ) TO bookings_update.

    ENDLOOP.

    MODIFY ENTITIES OF zr_vehicle_book_08 IN LOCAL MODE
        ENTITY ZrVehicleBook08
            UPDATE FIELDS (  Totaldays )
            WITH bookings_update.

  ENDMETHOD.

  METHOD ValidateDates.
    " 1. Leemos las instancias afectadas
    READ ENTITIES OF zr_vehicle_book_08 IN LOCAL MODE
        ENTITY ZrVehicleBook08
            FIELDS ( StartDate EndDate )
            WITH CORRESPONDING #( keys )
        RESULT DATA(bookings).

    "2. Fecha actual del sistema
    DATA(today) = cl_abap_context_info=>get_system_date(  ).

    "3. Limpiar mensajes anteriores de esta validation
    LOOP AT bookings ASSIGNING FIELD-SYMBOL(<booking>).
      APPEND VALUE #(
                      %tky        = <booking>-%tky
                      %state_area = 'VALIDATE_DATES'
                    ) TO reported-zrvehiclebook08.
    ENDLOOP.

    LOOP AT bookings ASSIGNING <booking>.
      "8. Fechas inicio y fin obligatorias
      IF <booking>-StartDate IS INITIAL OR <booking>-EndDate IS INITIAL.
        APPEND VALUE #(  %tky = <booking>-%tky ) TO failed-zrvehiclebook08.
        APPEND VALUE #(
            %tky                = <booking>-%tky
            %state_area         = 'VALIDATE_DATES'
            %msg                = new_message(
                                                id          = 'ZVEHICLE_BOOKING_08'
                                                number      = '001'
                                                severity    = if_abap_behv_message=>severity-error
                                             )
          ) TO reported-zrvehiclebook08.
        CONTINUE.
      ENDIF.

      " 4. StarDate no puede ser anterior a hoy
      IF <booking>-StartDate IS NOT INITIAL AND <booking>-StartDate < today.
        " 5. Registrar la instacia con error
        APPEND VALUE #(  %tky = <booking>-%tky ) TO failed-zrvehiclebook08.
        " 6. Mensaje 005
        APPEND VALUE #(
                        %tky                = <booking>-%tky
                        %state_area         = 'VALIDATE_DATES'
                        %msg                = new_message(
                                                            id          = 'ZVEHICLE_BOOKING_08'
                                                            number      = '005'
                                                            severity    = if_abap_behv_message=>severity-error
                                                         )
                        %element-startdate    = if_abap_behv=>mk-on
                      ) TO reported-zrvehiclebook08.
      ENDIF.

      " 7. EndDate no puede ser anterior a starDate
      IF  <booking>-StartDate IS NOT INITIAL
          AND <booking>-EndDate IS NOT INITIAL
          AND <booking>-EndDate < <booking>-StartDate.

        APPEND VALUE #(  %tky = <booking>-%tky ) TO failed-zrvehiclebook08.

        APPEND VALUE #(
                        %tky                = <booking>-%tky
                        %state_area         = 'VALIDATE_DATES'
                        %msg                = new_message(
                                                            id          = 'ZVEHICLE_BOOKING_08'
                                                            number      = '005'
                                                            severity    = if_abap_behv_message=>severity-error
                                                         )
                        %element-enddate    = if_abap_behv=>mk-on
                       ) TO reported-zrvehiclebook08.

      ENDIF.
    ENDLOOP.
  ENDMETHOD.

  METHOD setInitialStatus.
    READ ENTITIES OF zr_vehicle_book_08 IN LOCAL MODE
        ENTITY ZrVehicleBook08
            FIELDS ( Status )
            WITH CORRESPONDING #( keys )
        RESULT DATA(bookings).

    DELETE bookings WHERE Status IS NOT INITIAL.
    CHECK bookings IS NOT INITIAL.

    MODIFY ENTITIES OF zr_vehicle_book_08 IN LOCAL MODE
        ENTITY ZrVehicleBook08
            UPDATE FIELDS ( Status )
            WITH VALUE #(
                            FOR b IN bookings (
                                %tky = b-%tky
                                Status = 'OPEN'
                            )
                        ).
  ENDMETHOD.

  METHOD CancelBooking.
    READ ENTITIES OF zr_vehicle_book_08 IN LOCAL MODE
     ENTITY ZrVehicleBook08
       FIELDS ( Status StartDate )
       WITH CORRESPONDING #( keys )
     RESULT DATA(bookings).

    DATA(today) = cl_abap_context_info=>get_system_date( ).

    DATA bookings_update TYPE TABLE FOR UPDATE zr_vehicle_book_08\\ZrVehicleBook08.

    LOOP AT bookings ASSIGNING FIELD-SYMBOL(<booking>).

      " Ya cancelada
      IF <booking>-Status = 'CANCELED'.
        APPEND VALUE #( %tky = <booking>-%tky ) TO failed-zrvehiclebook08.
        APPEND VALUE #( %tky = <booking>-%tky
                        %msg = new_message( id       = 'ZVEHICLE_BOOKING_08'
                                            number   = '002'
                                            severity = if_abap_behv_message=>severity-error ) )
               TO reported-zrvehiclebook08.
        CONTINUE.
      ENDIF.

      " Fecha de inicio pasada
      IF <booking>-StartDate IS NOT INITIAL AND <booking>-StartDate < today.
        APPEND VALUE #( %tky = <booking>-%tky ) TO failed-zrvehiclebook08.
        APPEND VALUE #( %tky = <booking>-%tky
                        %msg = new_message( id       = 'ZVEHICLE_BOOKING_08'
                                            number   = '004'
                                            severity = if_abap_behv_message=>severity-error ) )
               TO reported-zrvehiclebook08.
        CONTINUE.
      ENDIF.

      " Cancelación correcta
      APPEND VALUE #( %tky = <booking>-%tky Status = 'CANCELED' ) TO bookings_update.
      APPEND VALUE #( %tky = <booking>-%tky
                      %msg = new_message( id       = 'ZVEHICLE_BOOKING_08'
                                          number   = '003'
                                          severity = if_abap_behv_message=>severity-success ) )
             TO reported-zrvehiclebook08.

    ENDLOOP.

    MODIFY ENTITIES OF zr_vehicle_book_08 IN LOCAL MODE
      ENTITY ZrVehicleBook08
        UPDATE FIELDS ( Status )
        WITH bookings_update.

    READ ENTITIES OF zr_vehicle_book_08 IN LOCAL MODE
      ENTITY ZrVehicleBook08
        ALL FIELDS WITH CORRESPONDING #( keys )
      RESULT DATA(result_bookings).

    result = VALUE #( FOR b IN result_bookings ( %tky = b-%tky %param = b ) ).

  ENDMETHOD.

ENDCLASS.
