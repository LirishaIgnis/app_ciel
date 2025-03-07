import 'dart:typed_data';

class GameState {
  int minutos;
  int segundos;
  int marcadorLocal;
  int marcadorVisitante;
  int periodo;
  int faltasLocal;
  int faltasVisitante;

  //  Variables para el tiempo muerto
  int tiempoMuertoLocal = 0;
  int tiempoMuertoVisitante = 0;
  bool tiempoMuertoActivoLocal = false;
  bool tiempoMuertoActivoVisitante = false;

  GameState({
    this.minutos = 0,
    this.segundos = 0,
    this.marcadorLocal = 0,
    this.marcadorVisitante = 0,
    this.periodo = 1,
    this.faltasLocal = 0,
    this.faltasVisitante = 0,
  });

     /// **🔹 Trama optimizada para estados generales**
  Uint8List generarTramaEstado({required int tipoTrama, required int bitOscilacion}) {
    int valorMinutos = minutos;
    int valorSegundos = segundos;

    // 🕒 Si el tiempo es menor a 1 minuto, intercambiar valores
    if (minutos == 0) {
      valorMinutos = convertirDecimalAHex(segundos); // **Segundos en la posición de minutos**
      valorSegundos = 0x59; // **Milisegundos en la posición de segundos**
    } else {
      valorMinutos = convertirDecimalAHex(minutos);
      valorSegundos = convertirDecimalAHex(segundos);
    }

    return Uint8List.fromList([
      0xAA, 0xAB, 0xAC, //  Encabezado común
      tipoTrama, //  Tipo de trama (0x00 estándar, 0x01 menos de 1 min, 0x06 inicio sonido, 0x02 fin sonido)
      valorMinutos, //  Minutos o Segundos (según el caso)
      valorSegundos, //  Segundos o Milisegundos (según el caso)
      convertirDecimalAHex(marcadorLocal % 100), //  Decenas y unidades del marcador local
      convertirDecimalAHex(marcadorVisitante % 100), //  Decenas y unidades del marcador visitante
      codificarCentenas(marcadorLocal, marcadorVisitante), //  Centenas combinadas
      0x34, //  Dato fijo
      ((bitOscilacion & 0x0F) << 4) | (periodo & 0x0F), //  Bit oscilante y periodo combinados
      0xAD //  Fin de la trama
    ]);
  }

  /// **🔹 Trama estándar (tiempo mayor a un minuto)**
  Uint8List generarTramaEstadoPartido(int bitOscilacion) {
    return generarTramaEstado(tipoTrama: 0x00, bitOscilacion: bitOscilacion);
  }

  /// **🔹 Trama para tiempo menor a un minuto**
  Uint8List generarTramaTiempoMenorUnMinuto(int bitOscilacion) {
    return generarTramaEstado(tipoTrama: 0x01, bitOscilacion: bitOscilacion);
  }

  /// **🔹 Trama para inicio de tiempo muerto**
  Uint8List generarTramaTiempoMuertoInicio(int bitOscilacion) {
    return generarTramaEstado(tipoTrama: 0x06, bitOscilacion: bitOscilacion);
  }

  /// **🔹 Trama para fin de tiempo muerto**
  Uint8List generarTramaTiempoMuertoFin(int bitOscilacion) {
    return generarTramaEstado(tipoTrama: 0x02, bitOscilacion: bitOscilacion);
  }

  // -------------------------------------------------------------------
  // **✅ Sección Mantenida: Funciones de Nombres y Faltas**
  // -------------------------------------------------------------------

  /// **🔹 Genera la trama de nombres de equipo**
  Uint8List generarTramaNombreEquipo({required bool esLocal, required String nombreEquipo}) {
    String etiqueta = esLocal ? "ZF0" : "ZF1"; // Local: ZF1, Visitante: ZF0

    // 🔹 Asegurar que el nombre no tenga más de 12 caracteres
    nombreEquipo = nombreEquipo.padRight(12).substring(0, 12); 

    List<int> trama = [
      0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x01, // Bytes iniciales
      ...etiqueta.codeUnits, // 🔹 Insertar "ZF1" o "ZF0"
      0x02, 0x41, 0x42,  // 🔹 "AB" en ASCII
      0x1B, 0x30, 0x62,  // 🔹 Bytes de formato
      0x1A, 0x31, 0x0E, 0x32, // 🔹 Más bytes fijos
      ...nombreEquipo.codeUnits, // 🔹 Insertar nombre del equipo en ASCII
      0x04 // Fin de trama
    ];

    return Uint8List.fromList(trama);
  }

  /// **🔹 Genera la trama de faltas (21 bytes)**
  Uint8List generarTramaFaltas({required int bitOscilacion}) {
    return Uint8List.fromList([
      0xAA, 0xAB, 0xAC, // Encabezado
      0x00, // Tiempo menor  a un minuto 
      convertirDecimalAHex(minutos),
      convertirDecimalAHex(segundos),
      convertirDecimalAHex(marcadorLocal % 100),
      convertirDecimalAHex(marcadorVisitante % 100),
      codificarCentenas(marcadorLocal, marcadorVisitante),
      0x34, // Tiempo local ajustado
      ((bitOscilacion & 0x0F) << 4) | (periodo & 0x0F), // Bit oscilante y periodo combinados
      0xBA, // Indicador de trama de faltas
      0x30, // Estático (bit 13)
      0x30, // Estático (bit 14)
      ((periodo & 0x0F) << 4) | (faltasLocal & 0x0F), // Faltas locales (bit 15)
      0x30, // Estático (bit 16)
      ((periodo & 0x0F) << 4) | (faltasVisitante & 0x0F), // Faltas visitantes (bit 17)
      0x30, 0x30, 0x3B, // Datos adicionales
      0xAD // Fin de la trama
    ]);
  }

  // -------------------------------------------------------------------
  // **✅ Sección de Utilidades para Conversión de Datos**
  // -------------------------------------------------------------------

  /// **🔹 Convierte un valor decimal a su representación hexadecimal en BCD**
  int convertirDecimalAHex(int valor) {
    int parteEntera = valor ~/ 10;
    int parteUnidades = valor % 10;
    return (parteEntera << 4) | parteUnidades; // 🔹 Combina decenas y unidades
  }

  /// **🔹 Codifica las centenas del marcador local y visitante en un solo byte**
  int codificarCentenas(int marcadorLocal, int marcadorVisitante) {
    int centenaLocal = marcadorLocal ~/ 100;
    int centenaVisitante = marcadorVisitante ~/ 100;
    return (centenaLocal << 4) | centenaVisitante;
  }
}

