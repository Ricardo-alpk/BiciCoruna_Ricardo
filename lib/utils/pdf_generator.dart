import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw; // pw será nuestro "Flutter para PDFs"
import 'package:printing/printing.dart';
import '../models/station.dart';

class PdfGenerator {
  
  // Función estática para no tener que instanciar la clase
  static Future<void> generateAndPrint(Station station) async {
    
    // 1. Creamos un documento PDF vacío
    final pdf = pw.Document();

    // 2. Definimos qué hora es ahora mismo
    final now = DateTime.now();
    final dateStr = "${now.day}/${now.month}/${now.year} - ${now.hour}:${now.minute}";

    // 3. Agregamos una página al documento
    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          // Aquí diseñamos el folio igual que diseñamos una pantalla
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              // Título
              pw.Header(
                level: 0,
                child: pw.Text("Informe de Estación BiciCoruña", style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
              ),
              
              pw.SizedBox(height: 20),
              
              // Datos generales
              pw.Text("Estación: ${station.nombre}", style: pw.TextStyle(fontSize: 18)),
              pw.Text("ID: ${station.id}"),
              pw.Text("Fecha del informe: $dateStr"),
              
              pw.Divider(),
              pw.SizedBox(height: 20),

              // Tabla de estadísticas
              pw.Text("Estado Actual", style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 10),

              // Creamos una tabla simple
              pw.Table.fromTextArray(
                context: context,
                data: <List<String>>[
                  <String>['Tipo', 'Cantidad'], // Cabecera
                  <String>['Bicis Mecánicas', station.bicisMecanicas.toString()],
                  <String>['Bicis Eléctricas', station.bicisElectricas.toString()],
                  <String>['Anclajes Libres', station.anclajesLibres.toString()],
                ],
              ),

              pw.SizedBox(height: 30),

              // Conclusión
              pw.Container(
                padding: const pw.EdgeInsets.all(10),
                decoration: pw.BoxDecoration(
                  border: pw.Border.all(),
                  color: PdfColors.grey200,
                ),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text("Resumen:", style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                    pw.Text(_getDecisionText(station)),
                  ]
                )
              ),
              
              pw.Spacer(),
              pw.Text("Documento generado automáticamente por BiciCoruña App", style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey)),
            ],
          );
        },
      ),
    );

    // 4. Abrimos la vista previa de impresión del móvil
    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
    );
  }

  // Una pequeña ayuda para poner texto según los datos (igual que en la pantalla)
  static String _getDecisionText(Station station) {
    if (station.bicisMecanicas == 0 && station.bicisElectricas == 0) {
      return "No hay bicicletas disponibles en este momento.";
    } else if (station.bicisElectricas > 0) {
      return "Estación recomendada: Dispone de bicicletas eléctricas.";
    } else {
      return "Estación operativa: Solo dispone de bicicletas mecánicas.";
    }
  }
}