String formattedDate() {
  DateTime now = DateTime.now();
  List<String> months = [
    'Enero', 'Febrero', 'Marzo', 'Abril', 'Mayo', 'Junio', 'Julio', 'Agosto',
    'Septiembre', 'Octubre', 'Noviembre', 'Diciembre'
  ];
  List<String> weekdays = [
    'Lunes', 'Martes', 'Miércoles', 'Jueves', 'Viernes', 'Sábado', 'Domingo'
  ];
  String day = now.day.toString();
  String weekday = weekdays[now.weekday - 1];
  String month = months[now.month - 1];
  return '$weekday $day de $month';
}