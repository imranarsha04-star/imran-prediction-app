import 'package:flutter/material.dart';
import 'data_model.dart'; // Database model file ko import kiya

void main() {
  runApp(const ImranPredictionApp());
}

class ImranPredictionApp extends StatelessWidget {
  const ImranPredictionApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Imran Pro Prediction & System',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: const Color(0xFF0F172A),
      ),
      home: const PredictionHomeScreen(),
    );
  }
}

class PredictionHomeScreen extends StatefulWidget {
  const PredictionHomeScreen({Key? key}) : super(key: key);

  @override
  State<PredictionHomeScreen> createState() => '_PredictionHomeScreenState();
}

class _PredictionHomeScreenState extends State<PredictionHomeScreen> {
  String selectedMarket = 'Kalyan';
  
  final List<String> markets = [
    'Sridevi',
    'Time Bazar',
    'Milan Day',
    'Kalyan',
    'Sridevi Night',
    'Milan Night',
    'Kalyan Night',
    'Main Bazar'
  ];

  bool isMarketOff(String market) {
    DateTime now = DateTime.now();
    // Sunday off rule for specific markets
    if ((market == 'Kalyan Night' || market == 'Main Bazar') && 
        now.weekday == DateTime.sunday) {
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    bool marketOff = isMarketOff(selectedMarket);
    // Fetching dynamic analysis based on 1972-2026 database engine
    List<String> predictedJodis = HistoricalDatabase.getPredictedJodi(selectedMarket);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E293B),
        title: const Text(
          'Imran Pro Prediction & DPBoss System',
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Market Selector Dropdown
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: const Color(0xFF1E293B),
                borderRadius: BorderRadius.circular(8),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: selectedMarket,
                  dropdownColor: const Color(0xFF1E293B),
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                  icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
                  items: markets.map((String market) {
                    return DropdownMenuItem<String>(
                      value: market,
                      child: Text(market),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedMarket = newValue!;
                    });
                  },
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Run Analysis Button
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0284C7),
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () {
                setState(() {
                  // Triggers re-calculation from historical patterns
                });
              },
              child: const Text(
                'RUN ADVANCED ANALYSIS',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 16),

            // Analytical Report Box
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF1E293B),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFF334155)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Advanced Analytical Report:',
                    style: TextStyle(color: Colors.lightBlueAccent, fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Market: $selectedMarket',
                    style: const TextStyle(color: Colors.white, fontSize: 14),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Text(
                        'Schedule Status: ',
                        style: TextStyle(color: Colors.white, fontSize: 14),
                      ),
                      Text(
                        marketOff ? '🟡 Market OFF Today' : '🟢 Market OPEN Today',
                        style: TextStyle(
                          color: marketOff ? Colors.amber : Colors.greenAccent,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Predicted Strong Jodi:',
                    style: TextStyle(color: Colors.white70, fontSize: 13),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      JodiBadge(number: predictedJodis[0], color: Colors.redAccent),
                      const SizedBox(width: 8),
                      JodiBadge(number: predictedJodis[1], color: Colors.redAccent),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Predicted Support Jodi:',
                    style: TextStyle(color: Colors.white70, fontSize: 13),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      JodiBadge(number: predictedJodis[2], color: Colors.redAccent),
                      const SizedBox(width: 8),
                      JodiBadge(number: predictedJodis[3], color: Colors.redAccent),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    marketOff 
                      ? 'Logic Note: Aaj market off hai. Calculation aane wale open din ke anusar ki gayi hai.'
                      : 'Logic Note: 1972-2026 data patterns aur frequency ke aadhar par calculation ki gayi hai.',
                    style: const TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class JodiBadge extends StatelessWidget {
  final String number;
  final Color color;

  const JodiBadge({Key? key, required this.number, required this.color}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
      child: Text(
        number,
        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
    );
  }
}
