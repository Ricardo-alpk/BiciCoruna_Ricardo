class Station {
  final String id; // String para evitar errores de API
  final String nombre;
  final double latitud;
  final double longitud;
  final int bicisMecanicas; 
  final int bicisElectricas; 
  final int anclajesLibres; 

  const Station({
    required this.id,
    required this.nombre,
    required this.latitud,
    required this.longitud,
    required this.bicisMecanicas,
    required this.bicisElectricas,
    required this.anclajesLibres,
  });
}