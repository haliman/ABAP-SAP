CLASS zcl_flight_manager_08 DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES zif_flight_manager_08.

  PROTECTED SECTION.
  PRIVATE SECTION.
    DATA mt_flights TYPE zif_flight_manager_08=>tt_flights.
ENDCLASS.



CLASS zcl_flight_manager_08 IMPLEMENTATION.

  METHOD zif_flight_manager_08~add_flight.

    "Validar que el precio sea mayor que cero
    IF is_flight-price <= 0.
      RAISE EXCEPTION TYPE zcx_flight_error_08.
    ENDIF.

    "Comprobar si el vuelo existe
    IF line_exists(
        mt_flights[
            airline     = is_flight-airline
            flight_num  = is_flight-flight_num
        ]
    ).
      RAISE EXCEPTION TYPE zcx_flight_error_08.
    ENDIF.

    INSERT is_flight INTO TABLE mt_flights.

  ENDMETHOD.

  METHOD zif_flight_manager_08~get_cheapest_flight.

    "Comprobamos si existen vuelos
    IF mt_flights IS INITIAL.
        RAISE EXCEPTION TYPE zcx_flight_error_08.
    ENDIF.

    rs_result = REDUCE #(
        INIT ls_cheapest = mt_flights[ 1 ]

        FOR ls_flight IN mt_flights
        NEXT ls_cheapest = COND #(
            WHEN ls_flight-price < ls_cheapest-price
                THEN ls_flight
            ELSE ls_cheapest
        )
    ).

  ENDMETHOD.

  METHOD zif_flight_manager_08~get_flights_by_airline.
    rt_result = VALUE #(
        FOR ls_flight IN mt_flights
        WHERE ( airline = iv_airline )
        ( ls_flight )
    ).
  ENDMETHOD.

  METHOD zif_flight_manager_08~get_total_revenue.
    rs_resutl = REDUCE #(
        INIT lv_total = CONV zif_flight_manager_08=>ty_price( 0 )

        FOR ls_flight IN mt_flights
        NEXT lv_total = lv_total + ls_flight-price
    ).
  ENDMETHOD.

ENDCLASS.
