CLASS zcl_cp02_08 DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
    TYPES: BEGIN OF ty_reserva,
             id_reserva TYPE i,
             airline    TYPE c LENGTH 2,
             num_vuelo  TYPE n LENGTH 4,
             pasajero   TYPE string,
             fecha      TYPE d,
             precio     TYPE p LENGTH 8 DECIMALS 2,
             estado     TYPE c LENGTH 1,
           END OF ty_reserva.

    TYPES tt_reservas TYPE STANDARD TABLE OF ty_reserva
        WITH NON-UNIQUE KEY id_reserva.
    TYPES ty_precio TYPE p LENGTH 8 DECIMALS 2.

ENDCLASS.



CLASS zcl_cp02_08 IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.

*    Carga inicial
    DATA(lt_res) = VALUE tt_reservas(
      ( id_reserva = 1 airline = 'LH' num_vuelo = '0400'
        pasajero = |Ana Garcia|    fecha = '20260515'
        precio = '899.00' estado = 'A' )
      ( id_reserva = 2 airline = 'IB' num_vuelo = '3740'
        pasajero = |Carlos Lopez|  fecha = '20260515'
        precio = '120.00' estado = 'A' )
      ( id_reserva = 3 airline = 'AA' num_vuelo = '0017'
        pasajero = |John Smith|    fecha = '20260520'
        precio = '450.50' estado = 'A' )
      ( id_reserva = 4 airline = 'LH' num_vuelo = '0455'
        pasajero = |Maria Perez|   fecha = '20260520'
        precio = '310.75' estado = 'A' )
      ( id_reserva = 5 airline = 'IB' num_vuelo = '3740'
        pasajero = |Pedro Ruiz|    fecha = '20260515'
        precio = '120.00' estado = 'C' )
      ( id_reserva = 6 airline = 'SQ' num_vuelo = '0026'
        pasajero = |Lisa Tan|      fecha = '20260601'
        precio = '1250.00' estado = 'A' )
      ( id_reserva = 7 airline = 'LH' num_vuelo = '0400'
        pasajero = |Hans Muller|   fecha = '20260515'
        precio = '899.00' estado = 'A' )
      ( id_reserva = 8 airline = 'AA' num_vuelo = '0064'
        pasajero = |Sarah Jones|   fecha = '20260525'
        precio = '510.00' estado = 'A' )
    ).

*    Tarea 2.1: Altas e inserciones en memoria
    APPEND VALUE #( id_reserva = 9 airline = 'LH' num_vuelo = '0400'
                    pasajero = |Sebastian| fecha = '20260515'
                    precio = '901.00' estado = 'A'
     ) TO lt_res.
    APPEND VALUE #( id_reserva = 10 airline = 'SQ' num_vuelo = '0026'
                    pasajero = |Seba| fecha = '20260601'
                    precio = '1150.00' estado = 'A'
     ) TO lt_res.
    out->write( |***Tarea 2.1: Altas e Inserciones en Memoria***| ).
    out->write( lt_res ).

*    Tarea 2.2: Modificación de datos (In-Place y Masivas)
    "   Declaramos un único puntero al principio para utilizarlo en todos los cambios masivos.
    FIELD-SYMBOLS <fs_item> LIKE LINE OF lt_res.

    READ TABLE lt_res WITH KEY id_reserva = 3 ASSIGNING <fs_item>.

    IF sy-subrc = 0.
      <fs_item>-precio = '480.00'.
    ENDIF.

    LOOP AT lt_res ASSIGNING <fs_item> WHERE airline = 'LH'.
      <fs_item>-precio = <fs_item>-precio * '0.90'.
    ENDLOOP.

    out->write( |***Tarea 2.2: Modificaciones de Datos (In-Place y Masivas)***| ).
    out->write( lt_res ).

*    Tarea 2.3: Cancelaciones y Borrado de Registros


    LOOP AT lt_res ASSIGNING <fs_item> WHERE  id_reserva = 4.
      <fs_item>-estado = 'C'.
    ENDLOOP.

    DATA(filas_iniciales) = lines( lt_res ).

    DELETE lt_res WHERE estado = 'C'.

    DATA(Total_filas) = filas_iniciales - lines( lt_res ).
    out->write( |***Tarea 2.3: Cancelaciones y Borrado de Registros***| ).
    out->write( lt_res ).
    out->write( |Nº de registros borrados: { total_filas }| ).

*    Tarea 2.4: Métodos de Búsqueda y Consulta
    DATA(lv_pasajero) = 'Lisa Tan'.
    READ TABLE lt_res WITH KEY pasajero = lv_pasajero TRANSPORTING NO FIELDS.

    IF sy-subrc = 0.
      out->write( |Se ha encontrado a { lv_pasajero } como pasajera.| ).
    ELSE.
      out->write( |No se ha encontrado a { lv_pasajero } como pasajera.| ).
    ENDIF.

    DATA(lv_reserva) = 6.
    READ TABLE lt_res WITH KEY id_reserva = lv_reserva REFERENCE INTO DATA(lr_reserva).
    IF sy-subrc = 0.
      out->write( |Nº Reserva realizada por { lr_reserva->pasajero } | ).
    ELSE.
      out->write(  |No se encontro la reserva { lv_reserva }| ).
    ENDIF.

    TRY.
        lv_pasajero = lt_res[ id_reserva = 1 ]-pasajero.
        out->write( |Pasajero encontrado { lv_pasajero }| ).
      CATCH cx_sy_itab_line_not_found.
        out->write( |Error: No se encontró la reserva especificada.| ).
    ENDTRY.
*    Tarea 2.5: Agrupación, Conteo y Sumatorios
    DATA(lt_resumen) = VALUE tt_reservas(
        FOR ls_res IN lt_res WHERE ( estado = 'A' )
            ( ls_res )
    ).


    LOOP AT lt_resumen INTO DATA(ls_resumen)
         GROUP BY ( airline = ls_resumen-airline )
         ASCENDING
         ASSIGNING FIELD-SYMBOL(<group>).

      " 1. Número de registros del grupo
      DATA(lv_count) = REDUCE i(
          INIT contador = 0
          FOR ls_res IN GROUP <group>
          NEXT contador = contador + 1
     ).

      " 2. Calcular el importe total mediante REDUCE
      DATA(lv_importe_total) = REDUCE ty_precio(
        INIT importe_total = CONV ty_precio( 0 )
        FOR ls_res IN GROUP <group>
        NEXT importe_total = importe_total + ls_res-precio
      ).

      " 3. Calcular el precio medio
      DATA(lv_avg) = round(
        val = CONV decfloat34( lv_importe_total ) / lv_count
        dec = 2
      ).

      " 4. Mostrar resultados
      out->write(
        |Aerolínea: { <group>-airline }, | &&
        |Cantidad: { lv_count }, | &&
        |Total: { lv_importe_total } EUR, | &&
        |Precio Medio: { lv_avg } EUR|
      ).

    ENDLOOP.


  ENDMETHOD.
ENDCLASS.
