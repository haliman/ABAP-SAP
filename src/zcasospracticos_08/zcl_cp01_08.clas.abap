CLASS zcl_cp01_08 DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.

      TYPES: BEGIN OF ty_flight,
           airline      type /dmo/carrier_name,
           flight_num   TYPE /dmo/connection_id,
           origin       TYPE /dmo/airport_from_id,
           dest         TYPE /dmo/airport_to_id,
           price        TYPE /dmo/flight_price,
           seats_free   TYPE i,
      END OF ty_flight,
      tt_flights TYPE STANDARD TABLE OF ty_flight WITH EMPTY KEY.

       TYPES: BEGIN OF ty_stats,
              max_price     TYPE ty_flight-price,
              min_price     TYPE ty_flight-price,
              total_price   TYPE ty_flight-price,
        END OF ty_stats.
ENDCLASS.



CLASS zcl_cp01_08 IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.

*   Carga de datos
    DATA(lt_flights) = VALUE tt_flights(
        ( airline = 'LH' flight_num = '0400' origin = 'FRA' dest = 'JFK' price = '899.00' seats_free = 15 )
        ( airline = 'AA' flight_num = '0017' origin = 'JFK' dest = 'SFO' price = '450.50' seats_free = 0 )
        ( airline = 'IB' flight_num = '3740' origin = 'MAD' dest = 'BCN' price = '120.00' seats_free = 42  )
        ( airline = 'LH' flight_num = '0455' origin = 'FRA' dest = 'MAD' price = '310.75' seats_free = 8 )
        ( airline = 'AA' flight_num = '0064' origin = 'SFO' dest = 'JFK' price = '510.00' seats_free = 3 )
        ( airline = 'IB' flight_num = '3950' origin = 'BCN' dest = 'LHR' price = '275.30' seats_free = 0 )
        ( airline = 'LH' flight_num = '2030' origin = 'MUC' dest = 'FRA' price = '95.00' seats_free = 60 )
        ( airline = 'SQ' flight_num = '0026' origin = 'SIN' dest = 'FRA' price = '1250.00' seats_free = 5 )
    ).

    out->write( '=== CARGA DE DATOS INICIAL (MODELO DMO) ===' ).
    out->write( lt_flights ).
    out->write( |-| ).

    " Tarea 1.1: Clasificación de precios con COND
    out->write( '=== TAREA 1.1: Clasificación de precios (COND) ===' ).

    DATA(lt_classified) = VALUE string_table(
      FOR ls_flight IN lt_flights
      ( |{ ls_flight-airline }{ ls_flight-flight_num } { ls_flight-origin }->{ ls_flight-dest } | &&
        |{ ls_flight-price DECIMALS = 2 } EUR | &&
        COND string( WHEN ls_flight-price <  150  THEN `Económico`
                     WHEN ls_flight-price <= 500  THEN `Estándar`
                     WHEN ls_flight-price <= 1000 THEN `Premium`
                     ELSE                              `First Class` ) ) ).

    out->write( `--- Tarea 1.1: Clasificación de precios ---` ).
    out->write( lt_classified ).
*    Tarea 1.2: Filtrado Avanzado con Operadores lógicos (VALUE y FOR)
    DATA(lt_filtered) = VALUE tt_flights(
        FOR ls_flitht in lt_flights
        WHERE (
            seats_free > 0
            AND ( origin = 'FRA' OR dest = 'FRA' )
            AND price <= 1000
        )
        ( ls_flitht )
    ).
    out->write( '=== TAREA 1.2: Vuelos filtrados ===' ).
    out->write( lt_filtered ).

*    Tarea 1.3: Transformación y manipulación de cadenas
    DATA(lt_concat) = VALUE string_table(
        FOR ls_fligth IN lt_flights
        LET lv_code = |{ ls_fligth-airline }{ ls_fligth-flight_num }|
        IN
            ( |Código: { lv_code } | &&
              |Destino: { to_lower( ls_fligth-dest ) } | &&
              |Longitud: { strlen( lv_code ) } | )
    ).

    out->write( '=== TAREA 1.3: Transformación y manipulación de cadenas ===' ).
    out->write( lt_concat ).

*    Tarea 1.4: Cálculos agregados con REDUCE
    DATA(ls_stats) = REDUCE ty_stats(
        INIT s = VALUE ty_stats(  max_price = lt_flights[ 1 ]-price
                                  min_price = lt_flights[ 1 ]-price )
        FOR ls_flight IN lt_flights
        NEXT s-max_price    = nmax( val1 = s-max_price val2 = ls_flight-price )
             s-min_price    = nmin( val1 = s-min_price val2 = ls_flight-price )
             s-total_price  = s-total_price + ls_flight-price
    ).

    DATA(lv_lines)  = lines( lt_flights ).
    DATA(lv_avg)    = round( val = ls_stats-total_price / lv_lines dec = 2 ).

    DATA(lv_seats_total) = REDUCE i(
        INIT seats = 0
        FOR ls_flight IN lt_flights
        NEXT seats = seats + ls_flight-seats_free
    ).

    out->write( `=== Tarea 1.4: Métricas ===` ).
    out->write( |Precio máximo: { ls_stats-max_price DECIMALS = 2 } EUR| ).
    out->write( |Precio mínimo: { ls_stats-min_price DECIMALS = 2 } EUR| ).
    out->write( |Precio medio:  { lv_avg DECIMALS = 2 } EUR| ).
    out->write( |Plazas libres totales: { lv_seats_total }| ).


  ENDMETHOD.
ENDCLASS.
