import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../../models/station.dart';

class TopStationsChart extends StatelessWidget {
  final List<Station> stations;

  const TopStationsChart({super.key, required this.stations});

  @override
  Widget build(BuildContext context) {
    final sortedStations = List<Station>.from(stations);
    sortedStations.sort((a, b) => b.bicisMecanicas.compareTo(a.bicisMecanicas));
    final top5 = sortedStations.take(5).toList();

    if (top5.isEmpty) return const SizedBox();

    return Card(
      margin: const EdgeInsets.all(16),
      elevation: 4,
      shadowColor: Colors.purple.withOpacity(0.2), 
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                // Icono del gráfico en Púrpura
                Icon(Icons.bar_chart_rounded, color: Colors.deepPurple),
                SizedBox(width: 8),
                Text(
                  "Top 5: Mayor disponibilidad",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.deepPurple),
                ),
              ],
            ),
            const SizedBox(height: 20),

            SizedBox(
              height: 300,
              child: RotatedBox(
                quarterTurns: 1, 
                child: BarChart(
                  BarChartData(
                    alignment: BarChartAlignment.spaceAround,
                    maxY: top5.first.bicisMecanicas.toDouble() + 5,
                    
                    barTouchData: BarTouchData(
                      enabled: true,
                      touchTooltipData: BarTouchTooltipData(
                        tooltipRoundedRadius: 8,
                        tooltipBgColor: Colors.deepPurple, // Tooltip morado
                        rotateAngle: -90,
                        tooltipPadding: const EdgeInsets.all(8),
                        tooltipMargin: 8,
                        getTooltipItem: (group, groupIndex, rod, rodIndex) {
                          return BarTooltipItem(
                            '${top5[groupIndex].nombre}\n',
                            const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                            children: [
                              TextSpan(
                                text: '${rod.toY.toInt()} bicis',
                                style: const TextStyle(color: Colors.amberAccent),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                    
                    titlesData: FlTitlesData(
                      show: true,
                      leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      
                      
                      rightTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 40,
                          getTitlesWidget: (value, meta) {
                            return SideTitleWidget(
                              axisSide: meta.axisSide,
                              child: RotatedBox(
                                quarterTurns: -1, // esto es para poner el numero de pie
                                child: Text(
                                  value.toInt().toString(),
                                  style: const TextStyle(fontSize: 10, color: Colors.grey),
                                ),
                              ),
                            );
                          },
                        ),
                      ),

                      // NOMBRES (Visualmente izquierda)
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 110,
                          getTitlesWidget: (double value, TitleMeta meta) {
                            final index = value.toInt();
                            if (index >= 0 && index < top5.length) {
                              return SideTitleWidget(
                                axisSide: meta.axisSide,
                                child: RotatedBox(
                                  quarterTurns: -1, 
                                  child: SizedBox(
                                    width: 100,
                                    child: Text(
                                      top5[index].nombre,
                                      style: const TextStyle(
                                        fontSize: 11, 
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black87
                                      ),
                                      textAlign: TextAlign.end,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ),
                              );
                            }
                            return const Text('');
                          },
                        ),
                      ),
                    ),

                    borderData: FlBorderData(show: false),
                    gridData: FlGridData(
                      show: true,
                      drawVerticalLine: false,
                      drawHorizontalLine: true,
                      getDrawingHorizontalLine: (value) => FlLine(
                        color: Colors.grey.withOpacity(0.1),
                        strokeWidth: 1,
                      ),
                    ),

                    barGroups: top5.asMap().entries.map((entry) {
                      final index = entry.key;
                      final station = entry.value;

                      return BarChartGroupData(
                        x: index,
                        barRods: [
                          BarChartRodData(
                            toY: station.bicisMecanicas.toDouble(),
                            // GRADIENTE PÚRPURA PROFESIONAL
                            gradient: const LinearGradient(
                              colors: [Colors.deepPurple, Colors.purpleAccent],
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                            ),
                            width: 20,
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(6),
                              topRight: Radius.circular(6),
                            ),
                          ),
                        ],
                      );
                    }).toList(),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}