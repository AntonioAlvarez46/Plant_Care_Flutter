enum WateringUnit { horas, dias }

class Plant {
  const Plant({
    required this.id,
    required this.nombre,
    required this.regar,
    required this.unidad,
    required this.ultimoRiego,
  });

  final String id;
  final String nombre;
  final int regar;
  final WateringUnit unidad;
  final DateTime ultimoRiego;

  factory Plant.fromJson(Map<String, dynamic> json) => Plant(
        id: json['id'] as String,
        nombre: json['nombre'] as String,
        regar: json['regar'] as int,
        unidad: WateringUnit.values.byName(json['unidad'] as String),
        ultimoRiego: DateTime.parse(
                (json['ultimo_riego'] ?? json['created_at']) as String)
            .toLocal(),
      );

  Duration get intervalo => unidad == WateringUnit.horas
      ? Duration(hours: regar)
      : Duration(days: regar);

  DateTime get proximoRiego => ultimoRiego.add(intervalo);

  Duration restante(DateTime now) => proximoRiego.difference(now);

  double nivelAgua(DateTime now) {
    final nivel = restante(now).inSeconds / intervalo.inSeconds;
    return nivel.clamp(0.0, 1.0).toDouble();
  }
}