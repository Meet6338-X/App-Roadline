import 'package:demo1/input%20data/TimeAndDateDataPage.dart';
import 'package:flutter/material.dart';

class RouteAndRegionPage extends StatefulWidget {
  const RouteAndRegionPage({super.key});

  @override
  _RouteAndRegionPageState createState() => _RouteAndRegionPageState();
}

class _RouteAndRegionPageState extends State<RouteAndRegionPage> {
  final TextEditingController routeTypeController = TextEditingController();
  final TextEditingController regionController = TextEditingController();
  final TextEditingController roadConditionController = TextEditingController();
  final TextEditingController tollRatesController = TextEditingController();
  final TextEditingController fuelPriceController = TextEditingController();
  final TextEditingController weatherConditionsController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    final textFieldBorderStyle = OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: const BorderSide(color: Colors.grey, width: 2),
    );

    Widget buildTextField(String label, TextEditingController controller) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: screenWidth * 0.045,
                fontWeight: FontWeight.bold,
                color: Colors.orange,
              ),
            ),
            const SizedBox(height: 6),
            TextField(
              controller: controller,
              decoration: InputDecoration(
                hintText: label,
                border: textFieldBorderStyle,
                focusedBorder: textFieldBorderStyle,
                enabledBorder: textFieldBorderStyle,
                filled: true,
                fillColor: Colors.white,
              ),
            ),
          ],
        ),
      );
    }

    void handleSubmit() {
      final routeType = routeTypeController.text;
      final region = regionController.text;
      final roadCondition = roadConditionController.text;
      final tollRates = tollRatesController.text;
      final fuelPrice = fuelPriceController.text;
      final weatherConditions = weatherConditionsController.text;

      if (routeType.isEmpty ||
          region.isEmpty ||
          roadCondition.isEmpty ||
          tollRates.isEmpty ||
          fuelPrice.isEmpty ||
          weatherConditions.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please fill in all fields!')),
        );
        return;
      }

      // Navigate to TimeAndDatePage
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const TimeAndDateDataPage()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Route and Region Data'),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(screenWidth * 0.05),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildTextField('Route Type', routeTypeController),
              buildTextField('Region', regionController),
              buildTextField('Road Condition Index', roadConditionController),
              buildTextField('Toll Rates Index', tollRatesController),
              buildTextField('Fuel Price Index', fuelPriceController),
              buildTextField('Weather Conditions', weatherConditionsController),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: handleSubmit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  minimumSize: Size(screenWidth * 0.9, screenHeight * 0.07),
                ),
                child: const Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}