import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../../models/station.dart';

class StationPieChart extends StatelessWidget {
  final Station station;

  const StationPieChart({super.key, required this.station});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        
        SizedBox(
          height: 200,
          child: PieChart(
            PieChartData(
              sectionsSpace: 2, 
              centerSpaceRadius: 40, 
              sections: _getSections(),
            ),
          ),
        ),
        const SizedBox(height: 20),
        
        
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _LegendItem(color: Colors.green, text: "Mecánicas"),
            const SizedBox(width: 15),
            _LegendItem(color: Colors.blue, text: "Eléctricas"),
            const SizedBox(width: 15),
            _LegendItem(color: Colors.grey, text: "Libres"),
          ],
        ),
      ],
    );
  }

  List<PieChartSectionData> _getSections() {
    // se muestra si el valor es mayor que 0
    return [
      if (station.bicisMecanicas > 0)
        PieChartSectionData(
          color: Colors.green,
          value: station.bicisMecanicas.toDouble(),
          title: '${station.bicisMecanicas}',
          radius: 50,
          titleStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
        ),
      if (station.bicisElectricas > 0)
        PieChartSectionData(
          color: Colors.blue,
          value: station.bicisElectricas.toDouble(),
          title: '${station.bicisElectricas}',
          radius: 50,
          titleStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
        ),
      if (station.anclajesLibres > 0)
        PieChartSectionData(
          color: Colors.grey,
          value: station.anclajesLibres.toDouble(),
          title: '${station.anclajesLibres}',
          radius: 50,
          titleStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
        ),
    ];
  }
}

class _LegendItem extends StatelessWidget {
  final Color color;
  final String text;

  const _LegendItem({required this.color, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(width: 16, height: 16, color: color),
        const SizedBox(width: 4),
        Text(text),
      ],
    );
  }
}