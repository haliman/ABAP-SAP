CLASS zcl_cp03_08 DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_CP03_08 IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.

    "Instanciar el gestor de vuelos
    DATA(lo_manager) = NEW zcl_flight_manager_08(  ).

    "Declarar datos
    DATA lt_flights TYPE zif_flight_manager_08=>tt_flights.
    DATA ls_flight  TYPE zif_flight_manager_08=>ty_flight.
    DATA lv_total   TYPE zif_flight_manager_08=>ty_price.

    "Insertamos vuelos de prueba
    lt_flights = VALUE #(
      (
        airline     = 'LH'
        flight_num  = '0400'
        dest        = 'ESP'
        origin      = 'FRA'
        price       = '60.00'
        seats_free  = '4'
      )
      (
        airline     = 'AB'
        flight_num  = '0410'
        dest        = 'ITA'
        origin      = 'ESP'
        price       = '40.00'
        seats_free  = '50'
      )
      (
        airline     = 'LH'
        flight_num  = '0412'
        dest        = 'DEU'
        origin      = 'GBR'
        price       = '100.00'
        seats_free  = '50'
      )
    ).

    "--------------------------------------------
    "1. INSERTAR VUELOS VÁLIDOS
    "--------------------------------------------
    OUT->write( |1. Registro de vuelos| ).

    LOOP AT lt_flights INTO DATA(ls_new_flight).

        TRY.
            lo_manager->zif_flight_manager_08~add_flight(
                is_flight = ls_new_flight
            ).

            out->write( |Vuelo registrado: { ls_new_flight-airline } { ls_new_flight-flight_num }| ).
        CATCH zcx_flight_error_08 INTO DATA(lx_error).
            out->write( lx_error->get_text(  ) ).
        ENDTRY.

    ENDLOOP.

    "--------------------------------------------
    "2. INSERTAR VUELOS CON PRECIO INVALIDO
    "--------------------------------------------
     OUT->write( |2. Prueba de precio inválido| ).

     TRY.

        lo_manager->zif_flight_manager_08~add_flight(
            is_flight = VALUE #(
                airline     = 'LH'
                flight_num  = '0500'
                origin      = 'ESP'
                dest        = 'FRA'
                price       = '-01.00'
            )
        ).
     CATCH zcx_flight_error_08 INTO lx_error.
        out->write( | Excepcion de captura: { lx_error->get_text(  ) } | ).
     ENDTRY.

    "--------------------------------------------
    "3. INSERTAR VUELO DUPLICADO
    "--------------------------------------------
     OUT->write( |3. Prueba de vuelo duplicado| ).

     TRY.

        lo_manager->zif_flight_manager_08~add_flight(
            is_flight = VALUE #(
                airline     = 'LH'
                flight_num  = '0412'
                dest        = 'DEU'
                origin      = 'GBR'
                price       = '100.00'
                seats_free  = '50'
            )
        ).
     CATCH zcx_flight_error_08 INTO lx_error.
        out->write( | Excepcion de captura: { lx_error->get_text(  ) } | ).
     ENDTRY.

    "--------------------------------------------
    "4. VUELOS POR AEROLINEA
    "--------------------------------------------
     out->write( |4. Vuelos por aerolinea| ).

     DATA(lt_result) =
        lo_manager->zif_flight_manager_08~get_flights_by_airline(
            iv_airline = 'LH'
        ).

     out->write( lt_result ).

    "--------------------------------------------
    "5. VUELO más barato
    "--------------------------------------------
    out->write( |5. Vuelo más barato| ).

    TRY.

        ls_flight =
            lo_manager->zif_flight_manager_08~get_cheapest_flight(  ).

        out->write( ls_flight ).

    CATCH zcx_flight_error_08 INTO lx_error.
        out->write( | Excepcion de captura: { lx_error->get_text(  ) } | ).
    ENDTRY.

    "--------------------------------------------
    "6. Facturación total
    "--------------------------------------------
    out->write( |6. Facturación total| ).

    lv_total = lo_manager->zif_flight_manager_08~get_total_revenue( ).

    out->write( |Total: { lv_total }| ).

  ENDMETHOD.
ENDCLASS.
