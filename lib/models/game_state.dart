import 'dart:typed_data';

class GameState {
  int minutos;
  int segundos;
  int milisegundos;
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
    this.milisegundos = 0,
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
      valorSegundos = convertirDecimalAHex((milisegundos ~/ 10).clamp(0, 99)); // **Milisegundos en formato BCD**
    } else {
      valorMinutos = convertirDecimalAHex(minutos);
      valorSegundos = convertirDecimalAHex(segundos);
    }

    return Uint8List.fromList([
      0xAA, 0xAB, 0xAC, //  Encabezado común
      tipoTrama, //  Tipo de trama (0x00 estándar o pausa, 0x01 menos de 1 min activo, etc.)
      valorMinutos, //  Minutos o Segundos (según el caso)
      valorSegundos, //  Segundos o Milisegundos (según el caso)
      convertirDecimalAHex(marcadorLocal % 100), //  Decenas y unidades del marcador local
      convertirDecimalAHex(marcadorVisitante % 100), //  Decenas y unidades del marcador visitante
      codificarCentenas(marcadorLocal, marcadorVisitante), //  Centenas combinadas
      0x34, //  Tiempos muertos
      ((bitOscilacion & 0x0F) << 4) | (periodo & 0x0F), //  Bit oscilante y periodo combinados
      0xAD //  Fin de la trama
    ]);
  }

  /// **🔹 Trama estándar (tiempo mayor a un minuto)**
  Uint8List generarTramaEstadoPartido(int bitOscilacion) {
    return generarTramaEstado(tipoTrama: 0x00, bitOscilacion: bitOscilacion);
  }

  /// **🔹 Trama para tiempo menor a un minuto**
  Uint8List generarTramaTiempoMenorUnMinuto(int bitOscilacion, {bool enPausa = false}) {
    final tipoTrama = enPausa ? 0x00 : 0x01;
    return generarTramaEstado(tipoTrama: tipoTrama, bitOscilacion: bitOscilacion);
  }

  /// **🔹 Trama para inicio de sonido **
  Uint8List generarTramaTiempoMuertoInicio(int bitOscilacion) {
    return generarTramaEstado(tipoTrama: 0x06, bitOscilacion: bitOscilacion);
  }

  /// **🔹 Trama para fin de sonido**
  Uint8List generarTramaTiempoMuertoFin(int bitOscilacion) {
    return generarTramaEstado(tipoTrama: 0x02, bitOscilacion: bitOscilacion);
  }

  /// **🔹 Genera la trama de nombres de equipo**
  Uint8List generarTramaNombreEquipo({required bool esLocal, required String nombreEquipo}) {
    String etiqueta = esLocal ? "ZF0" : "ZF1";
    nombreEquipo = nombreEquipo.padRight(12).substring(0, 12);

    List<int> trama = [
      0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x01,
      ...etiqueta.codeUnits,
      0x02, 0x41, 0x42,
      0x1B, 0x30, 0x62,
      0x1A, 0x31, 0x0E, 0x32,
      ...nombreEquipo.codeUnits,
      0x04
    ];

    return Uint8List.fromList(trama);
  }

  /// **🔹 Genera la trama de faltas (21 bytes)**
  Uint8List generarTramaFaltas({required int bitOscilacion}) {
    return Uint8List.fromList([
      0xAA, 0xAB, 0xAC,
      0x00,
      convertirDecimalAHex(minutos),
      convertirDecimalAHex(segundos),
      convertirDecimalAHex(marcadorLocal % 100),
      convertirDecimalAHex(marcadorVisitante % 100),
      codificarCentenas(marcadorLocal, marcadorVisitante),
      0x34,
      ((bitOscilacion & 0x0F) << 4) | (periodo & 0x0F),
      0xBA,
      0x30,
      0x30,
      ((periodo & 0x0F) << 4) | (faltasLocal & 0x0F),
      0x30,
      ((periodo & 0x0F) << 4) | (faltasVisitante & 0x0F),
      0x30, 0x30, 0x3B,
      0xAD
    ]);
  }

  int convertirDecimalAHex(int valor) {
    int parteEntera = valor ~/ 10;
    int parteUnidades = valor % 10;
    return (parteEntera << 4) | parteUnidades;
  }

  int codificarCentenas(int marcadorLocal, int marcadorVisitante) {
    int centenaLocal = marcadorLocal ~/ 100;
    int centenaVisitante = marcadorVisitante ~/ 100;
    return (centenaLocal << 4) | centenaVisitante;
  }
}


