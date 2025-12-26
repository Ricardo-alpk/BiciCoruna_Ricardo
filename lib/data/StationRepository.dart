import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/station.dart';

class StationRepository {
  final String _infoUrl =
      'https://acoruna.publicbikesystem.net/customer/gbfs/v2/gl/station_information';
  final String _statusUrl =
      'https://acoruna.publicbikesystem.net/customer/gbfs/v2/gl/station_status';

  Future<List<Station>> getStations() async {
    try {
      //return [];  //temporalmente devuelve una lista vacia para no dar error

      //llamamos a las APIs esperamos con awai
      final responseInfo = await http.get(Uri.parse(_infoUrl));
      final responseStatus = await http.get(Uri.parse(_statusUrl));

      //si va bien , pues que devuelvan un ok (200)

      if (responseInfo.statusCode == 200 && responseStatus.statusCode == 200) {
        //de texto a mapas de dart
        final Map<String, dynamic> jsonInfo = json.decode(responseInfo.body);
        final Map<String, dynamic> jsonStatus = json.decode(
          responseStatus.body,
        );

        //return[];

        //sacamos la listas de datos
        final List<dynamic> infoList = jsonInfo['data']['stations'];
        final List<dynamic> statusList = jsonStatus['data']['stations'];

        //se prepara la lista vacia donde se guardaran las estacioibnes completas
        List<Station> stations = [];

        //se recorre la info y se busca elstatus correspondiente
        for (var info in infoList) {
          var status = statusList.firstWhere(
            (element) => element['station_id'] == info['station_id'],
            orElse: () => null,
          );

          //si se encuenta (info + status), se creara un objeto
          if (status != null) {
            final station = Station(
              id: info['station_id'], // El ID viene como String en el JSON
              nombre: info['name'],
              // Convertimos a double por seguridad
              latitud: (info['lat'] as num).toDouble(),
              longitud: (info['lon'] as num).toDouble(),

              // Datos del status
              bicisMecanicas:
                  status['num_bikes_available'] ?? 0, // Si es nulo, ponemos 0
              //la dejo en 0 por ahora hasta ajustar la logica
              bicisElectricas: 0,
              anclajesLibres: status['num_docks_available'] ?? 0,
            );

            stations.add(station);
          }
        }
        return stations;
      } else {
        throw Exception('Error al cargar los datos de BiciCoruña');
      }
    } catch (e) {
      throw Exception('Error al cargar los datos: $e');
    }
  }
}
