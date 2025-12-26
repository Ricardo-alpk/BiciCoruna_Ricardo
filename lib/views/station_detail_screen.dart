import 'package:flutter/material.dart';
import '../models/station.dart';
import 'widgets/station_pie_chart.dart';
import '../utils/pdf_generator.dart';

class StationDetailScreen extends StatelessWidget {
  
  final Station station;

  const StationDetailScreen({super.key, required this.station});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(station.nombre),
        backgroundColor: const Color.fromARGB(255, 118, 0, 214),
        foregroundColor: const Color.fromARGB(255, 255, 255, 255),
      ),


      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // Llamamos a nuestra utilidad mágica
          PdfGenerator.generateAndPrint(station);
        },
        label: const Text("Exportar PDF"),
        icon: const Icon(Icons.picture_as_pdf),
        backgroundColor: const Color.fromARGB(255, 51, 6, 255),
        foregroundColor: Colors.white,
      ),



      body: SingleChildScrollView( 
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            
            _buildDecisionCard(),
            
            const SizedBox(height: 20),

            // 2. DATOS NUMÉRICOS
            Text("Estadísticas en tiempo real", style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 10),
            _buildStatRow(Icons.pedal_bike, "Bicis Mecánicas", station.bicisMecanicas.toString()),
            _buildStatRow(Icons.electric_bike, "E-bikes", station.bicisElectricas.toString()),
            _buildStatRow(Icons.local_parking, "Anclajes Libres", station.anclajesLibres.toString()),

            const SizedBox(height: 30),

            
            Text("Distribución de ocupación", style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 20),
            StationPieChart(station: station), // <--- Nuestro nuevo widget
          ],
        ),
      ),
    );
  }

  // Lógica: Me compensa bajar?
  Widget _buildDecisionCard() {
    String decision;
    Color color;
    IconData icon;
    String explicacion;

    if (station.bicisMecanicas == 0 && station.bicisElectricas == 0) {
      decision = "NO";
      color = Colors.red;
      icon = Icons.cancel;
      explicacion = "No hay bicicletas disponibles.";
    } else if (station.bicisElectricas > 0) {
      decision = "SÍ";
      color = Colors.green;
      icon = Icons.check_circle;
      explicacion = "¡Hay e-bikes disponibles! Corre.";
    } else {
      decision = "QUIZÁ";
      color = const Color.fromARGB(255, 0, 0, 0);
      icon = Icons.warning_amber;
      explicacion = "Solo hay bicis mecánicas. Te toca pedalear.";
    }

    return Card(
      color: color.withOpacity(0.1),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text("¿Me compensa bajar ahora?", style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, color: color, size: 40),
                const SizedBox(width: 10),
                Text(decision, style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: color)),
              ],
            ),
            const SizedBox(height: 5),
            Text(explicacion, style: TextStyle(color: color)),
          ],
        ),
      ),
    );
  }

  // Widget auxiliar para hacer filas de datos bonitas
  Widget _buildStatRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, color: Colors.grey[700]),
          const SizedBox(width: 10),
          Text(label, style: const TextStyle(fontSize: 16)),
          const Spacer(),
          Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}