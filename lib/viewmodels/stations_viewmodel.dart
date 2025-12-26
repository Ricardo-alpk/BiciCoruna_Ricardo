import 'package:flutter/material.dart';
import '../models/station.dart';
import '../data/StationRepository.dart';


class StationsViewModel extends ChangeNotifier {
  
  // 1. Instanciamos nuestro repositorio (el recolector de datos)
  final StationRepository _repository = StationRepository();

  
  // _stations: La lista de datos que mostraremos
  List<Station> _stations = [];
  // _isLoading: Un interruptor para saber si mostramos un cargando (spinner) o la lista
  bool _isLoading = false;

  
  // La pantalla usará estos getters para leer los datos, pero no puede modificarlos directamente.
  List<Station> get stations => _stations;
  bool get isLoading => _isLoading;

  // Constructor: Al crear este ViewModel, cargamos datos automáticamente
  StationsViewModel() {
    fetchStations();
  }

  
  Future<void> fetchStations() async {
    // Paso A: Ponemos el estado en "Cargando..."
    _isLoading = true;
    notifyListeners(); 

    try {
      _stations = await _repository.getStations();
    } catch (e) {
      print("Error: $e");
      
    } finally {
      
      _isLoading = false;
      notifyListeners(); 
    }
  }
}