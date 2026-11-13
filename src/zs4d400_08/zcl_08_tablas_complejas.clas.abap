CLASS zcl_08_tablas_complejas DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_08_tablas_complejas IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.
    TYPES: BEGIN OF st_connection,
             carrier_id      TYPE /dmo/carrier_id,
             connection_id   TYPE /dmo/connection_id,
             airport_from_id TYPE /dmo/airport_from_id,
             airport_to_id   TYPE /dmo/airport_to_id,
             carrier_name    TYPE /dmo/carrier_name,
           END OF st_connection.


*    Ejemplo 1: Tablas interenas simples y complejas
**********************************************************************
    "Tabla simple
    DATA numbers TYPE TABLE OF i.
    "Tabla compleja
    DATA connections TYPE TABLE OF st_connection.

    " Insertar datos en tabla simple
    numbers = VALUE #(
      ( 10 )
      ( 20 )
      ( 30 )
      ( 40 )
      ( 50 )
    ).

    " Insertar datos en tabla compleja
    connections = VALUE #(
      ( carrier_id = 'LH'
        connection_id = '0400'
        airport_from_id = 'FRA'
        airport_to_id = 'JFK'
        carrier_name = 'Lufthansa' )

      ( carrier_id = 'AA'
        connection_id = '0017'
        airport_from_id = 'JFK'
        airport_to_id = 'LAX'
        carrier_name = 'American Airlines' )

      ( carrier_id = 'IB'
        connection_id = '0750'
        airport_from_id = 'MAD'
        airport_to_id = 'BCN'
        carrier_name = 'Iberia' )

      ( carrier_id = 'FR'
        connection_id = '1020'
        airport_from_id = 'MAD'
        airport_to_id = 'SVQ'
        carrier_name = 'Ryanair' )
    ).

    out->write( `__________________________________________` ).
    out->write( `Ejemplo 1: Tabla interna compleja y simple` ).
    out->write(
                data = numbers
                name = 'Tabla simple: '
    ).
    out->write(
                data = connections
                name = 'Tabla compleja: '
    ).

*    Ejemplo 2: Tablas internas complejas
**********************************************************************

    DATA connections_2 TYPE STANDARD TABLE OF st_connection WITH NON-UNIQUE DEFAULT KEY.

    DATA connections_3 TYPE SORTED TABLE OF st_connection WITH NON-UNIQUE KEY carrier_id connection_id.

    DATA connections_4 TYPE HASHED TABLE OF st_connection WITH UNIQUE KEY carrier_id connection_id.

    connections_2 = VALUE #(
      ( carrier_id = 'LH'
        connection_id = '0400'
        airport_from_id = 'FRA'
        airport_to_id = 'JFK'
        carrier_name = 'Lufthansa' )

      ( carrier_id = 'AA'
        connection_id = '0017'
        airport_from_id = 'JFK'
        airport_to_id = 'LAX'
        carrier_name = 'American Airlines' )

      ( carrier_id = 'IB'
        connection_id = '0750'
        airport_from_id = 'MAD'
        airport_to_id = 'BCN'
        carrier_name = 'Iberia' )

      ( carrier_id = 'FR'
        connection_id = '1020'
        airport_from_id = 'MAD'
        airport_to_id = 'SVQ'
        carrier_name = 'Ryanair' )
    ).

    connections_3 = VALUE #(
      ( carrier_id = 'LH'
        connection_id = '0400'
        airport_from_id = 'FRA'
        airport_to_id = 'JFK'
        carrier_name = 'Lufthansa' )

      ( carrier_id = 'AA'
        connection_id = '0017'
        airport_from_id = 'JFK'
        airport_to_id = 'LAX'
        carrier_name = 'American Airlines' )

      ( carrier_id = 'IB'
        connection_id = '0750'
        airport_from_id = 'MAD'
        airport_to_id = 'BCN'
        carrier_name = 'Iberia' )

      ( carrier_id = 'FR'
        connection_id = '1020'
        airport_from_id = 'MAD'
        airport_to_id = 'SVQ'
        carrier_name = 'Ryanair' )
    ).

        connections_4 = VALUE #(
      ( carrier_id = 'LH'
        connection_id = '0400'
        airport_from_id = 'FRA'
        airport_to_id = 'JFK'
        carrier_name = 'Lufthansa' )

      ( carrier_id = 'AA'
        connection_id = '0017'
        airport_from_id = 'JFK'
        airport_to_id = 'LAX'
        carrier_name = 'American Airlines' )

      ( carrier_id = 'IB'
        connection_id = '0750'
        airport_from_id = 'MAD'
        airport_to_id = 'BCN'
        carrier_name = 'Iberia' )

      ( carrier_id = 'FR'
        connection_id = '1020'
        airport_from_id = 'MAD'
        airport_to_id = 'SVQ'
        carrier_name = 'Ryanair' )
    ).

    out->write(
                data = connections_2
                name = 'Tabla standar: '
    ).
    out->write(
            data = connections_3
            name = 'Tabla sort: '
).
    out->write(
            data = connections_4
            name = 'Tabla Hash: '
).


    TYPES tt_connections TYPE SORTED TABLE OF st_connection
                              WITH UNIQUE KEY carrier_id
                                              connection_id.

    DATA connections_5 TYPE tt_connections.

  ENDMETHOD.
ENDCLASS.
