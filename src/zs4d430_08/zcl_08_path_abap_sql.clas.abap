CLASS zcl_08_path_abap_sql DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_08_PATH_ABAP_SQL IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.

  SELECT FROM /DMO/I_Connection_R
    FIELDS  AirlineID,
            ConnectionID,

*            _Airline.name, No es correcto
            \_Airline-name,
*            _Airline-Name, No es correcto
*            _Airline~Name, No es correcto
*            \_Airline~Name, No es correcto


*            \_Airline-_Currency-CurrencyISOCode, No es correcto
*            \_Airline-\_Currency-CurrencyISOCode, No es correcto
            \_Airline\_Currency-CurrencyISOCode,
*            \_Airline~\_Currency~CurrencyISOCode, No es correcto
*            \_Airline\_Currency~CurrencyISOCode, No es correcto

*            \_Airline\_Currency\_Text[                     Language = 'E' ]-CurrencyShortName AS CurrencyNameEN,
            \_Airline\_Currency\_Text[   MANY TO ONE WHERE Language = 'D' ]-CurrencyShortName AS CurrencyNameDE,
*            \_Airline\_Currency\_Text[                     Language = 'E' ]-CurrencyShortName AS CurrencyNameEN,
*            \_Airline-\_Currency-\_Text[ MANY TO ONE WHERE Language = 'D' ]-CurrencyShortName AS CurrencyNameDE,
*            \_Airline~\_Currency~\_Text[ 1:                Language = 'E' ]-CurrencyShortName AS CurrencyNameEN,

            DepartureAirport,
            DestinationAirport

    INTO TABLE @DATA(result).

    out->write(
        data = result
        name = 'Seleccion resultado'
    ).
  ENDMETHOD.
ENDCLASS.
