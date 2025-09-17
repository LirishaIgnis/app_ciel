/// Utilidad para formatear la duración de tiempo en diferentes estilos
String formatDuration(Duration duration) {
  final totalSeconds = duration.inSeconds;
  final minutos = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
  final segundos = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
  final centesimas = ((duration.inMilliseconds.remainder(1000)) ~/ 10).toString().padLeft(2, '0');

  if (totalSeconds >= 60) {
    //  Formato estándar MM:SS
    return "$minutos:$segundos";
  } else {
    //  Último minuto: formato SS:cc (centésimas)
    return "$segundos:$centesimas";
  }
}
