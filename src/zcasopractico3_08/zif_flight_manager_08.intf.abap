INTERFACE zif_flight_manager_08
  PUBLIC .
      TYPES ty_price TYPE p LENGTH 8 DECIMALS 2.

      TYPES: BEGIN OF ty_flight,
               airline    TYPE c LENGTH 2,
               flight_num TYPE n LENGTH 4,
               origin     TYPE c LENGTH 3,
               dest       TYPE c LENGTH 3,
               price      TYPE ty_price,
               seats_free TYPE i,
             END OF ty_flight.

      TYPES tt_flights TYPE STANDARD TABLE OF ty_flight
       WITH NON-UNIQUE KEY airline flight_num.

      METHODS add_flight
        IMPORTING
          is_flight TYPE ty_flight
        RAISING
          zcx_flight_error_08.

      METHODS get_flights_by_airline
        IMPORTING
            iv_airline TYPE ty_flight-airline
        RETURNING VALUE(rt_result) TYPE tt_flights.

    METHODS get_cheapest_flight
        RETURNING VALUE(rs_result) TYPE ty_flight
        RAISING zcx_flight_error_08.

    METHODS get_total_revenue
        RETURNING VALUE(rs_resutl) TYPE ty_price.

endinterface.
