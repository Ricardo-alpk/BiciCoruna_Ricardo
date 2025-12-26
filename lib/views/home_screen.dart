import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/stations_viewmodel.dart';
import 'station_detail_screen.dart'; // Para navegar al detalle
import 'widgets/top_stations_chart.dart'; // <--- IMPORTANTE: Importamos el gráfico nuevo

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Estaciones BiciCoruña'),
        backgroundColor: const Color.fromARGB(255, 102, 60, 255),
        foregroundColor: const Color.fromARGB(255, 162, 160, 255),
        actions: [
          // Botón de refrescar (opcional pero útil)
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              Provider.of<StationsViewModel>(context, listen: false).fetchStations();
            },
          )
        ],
      ),
      body: Consumer<StationsViewModel>(
        builder: (context, viewModel, child) {
          
          // Cargando
          if (viewModel.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          // Datos listos
          return Column(
            children: [
              // A. GRÁFICO DE BARRAS (TOP 5)
              
              TopStationsChart(stations: viewModel.stations),

              //LISTA DE ESTACIONES
              Expanded(
                child: ListView.builder(
                  itemCount: viewModel.stations.length,
                  itemBuilder: (context, index) {
                    final station = viewModel.stations[index];
                    
                    return Card(
                      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      child: ListTile(
                        // Icono dinámico (verde si hay bicis, rojo si no)
                        leading: CircleAvatar(
                          backgroundColor: station.bicisMecanicas > 0 ? Colors.green[100] : Colors.red[100],
                          child: Icon(
                            //Si hay bicis > Check, si no > Cruz
                            station.bicisMecanicas > 0 ? Icons.check : Icons.close,
                            color: station.bicisMecanicas > 0 ? Colors.green[800] : Colors.red[800],
                          ),
                        ),
                        // Nombre
                        title: Text(
                          station.nombre,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        // Datos rápidos
                        subtitle: Text('Bicis: ${station.bicisMecanicas} | Anclajes: ${station.anclajesLibres}'),
                        // Flechita
                        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                        
                        // Navegación al tocar
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => StationDetailScreen(station: station),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}