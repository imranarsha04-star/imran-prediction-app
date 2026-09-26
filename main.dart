import 'package:flutter/material.dart';
import 'data_model.dart';

void main() {
  runApp(const ImranPredictionApp());
}

class ImranPredictionApp extends StatelessWidget {
  const ImranPredictionApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Imran Prediction & Chart Engine',
      theme: ThemeData.dark().copyWith(
        primaryColor: Colors.blueAccent,
        scaffoldBackgroundColor: const Color(0xFF121212),
        cardColor: const Color(0xFF1E1E1E),
      ),
      home: const MarketHomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MarketHomeScreen extends StatefulWidget {
  const MarketHomeScreen({Key? key}) : super(key: key);

  @override
  State<MarketHomeScreen> createState() => _MarketHomeScreenState();
}

class _MarketHomeScreenState extends State<MarketHomeScreen> {
  String selectedMarket = 'Kalyan';

  final List<String> markets = [
    'Kalyan',
    'Sridevi',
    'Time Bazar',
    'Milan Day',
    'Sridevi Night',
    'Milan Night',
    'Kalyan Night',
    'Main Bazar'
  ];

  @override
  Widget build(BuildContext context) {
    final records = HistoricalDatabase.marketHistory[selectedMarket] ?? [];
    final predictions = HistoricalDatabase.getPredictedJodi(selectedMarket);

    return Scaffold(
      appBar: AppBar(
        title: Text('$selectedMarket - Historical & Pattern Engine'),
        backgroundColor: Colors.black87,
      ),
      body: Column(
        children: [
          // Market Selector Dropdown / Horizontal Scroll Chips
          Container(
            height: 60,
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: markets.length,
              itemBuilder: (context, index) {
                final market = markets[index];
                final isSelected = market == selectedMarket;
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                  child: ChoiceChip(
                    label: Text(market),
                    selected: isSelected,
                    selectedColor: Colors.blueAccent,
                    onSelected: (selected) {
                      setState(() {
                        selectedMarket = market;
                      });
                    },
                  ),
                );
              },
            ),
          ),

          // Prediction Banner
          Container(
            margin: const EdgeInsets.all(12),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.blueAccent.withOpacity(0.15),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.blueAccent, width: 1),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Algorithmic Predicted Jodi (1972-2026 Model):',
                  style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: predictions.map((jodi) {
                    return Chip(
                      backgroundColor: Colors.blue.shade900,
                      label: Text(
                        jodi,
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),

          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Historical Tracking & Chart Patterns:',
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
            ),
          ),

          // Chart Display with Visual Line Tracing & Blue Circles Custom Painter
          Expanded(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFF1E1E1E),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade800),
              ),
              child: Stack(
                children: [
                  // Custom Pattern & Line Tracing Painter Background
                  Positioned.fill(
                    child: CustomPaint(
                      painter: PatternLinePainter(),
                    ),
                  ),
                  // Records List View on top of tracing grid
                  ListView.builder(
                    itemCount: records.length,
                    itemBuilder: (context, index) {
                      final record = records[index];
                      return ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.blue.shade800,
                          child: Text(record.jodi),
                        ),
                        title: Text('Date: ${record.date}'),
                        subtitle: Text('Open Panna: ${record.openPanna}  |  Close Panna: ${record.closePanna}'),
                        trailing: const Icon(Icons.show_chart, color: Colors.blueAccent),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Custom Painter for Drawing Blue Circles and Connecting Tracking Lines
class PatternLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paintLine = Paint()
      ..color = Colors.blueAccent.withOpacity(0.6)
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke;

    final paintCircle = Paint()
      ..color = Colors.blue
      ..style = PaintingStyle.fill;

    final paintBorderCircle = Paint()
      ..color = Colors.white
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    final path = Path();
    
    // Sample coordinates simulating historical pattern nodes
    final points = [
      Offset(size.width * 0.2, size.height * 0.15),
      Offset(size.width * 0.5, size.height * 0.35),
      Offset(size.width * 0.3, size.height * 0.55),
      Offset(size.width * 0.7, size.height * 0.75),
      Offset(size.width * 0.8, size.height * 0.90),
    ];

    if (points.isNotEmpty) {
      path.moveTo(points[0].dx, points[0].dy);
      for (int i = 1; i < points.length; i++) {
        path.lineTo(points[i].dx, points[i].dy);
      }
      canvas.drawPath(path, paintLine);

      // Draw blue circle nodes on historical key points
      for (var point in points) {
        canvas.drawCircle(point, 8.0, paintCircle);
        canvas.drawCircle(point, 8.0, paintBorderCircle);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
