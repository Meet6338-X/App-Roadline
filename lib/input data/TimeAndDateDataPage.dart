import 'package:flutter/material.dart';

class TimeAndDateDataPage extends StatefulWidget {
  const TimeAndDateDataPage({super.key});

  @override
  _TimeAndDateDataPageState createState() => _TimeAndDateDataPageState();
}

class _TimeAndDateDataPageState extends State<TimeAndDateDataPage> {
  // Define controllers for each text field
  final TextEditingController dateController = TextEditingController();
  final TextEditingController monthController = TextEditingController();
  final TextEditingController quarterController = TextEditingController();
  final TextEditingController seasonController = TextEditingController();
  final TextEditingController fuelPriceController = TextEditingController();
  final TextEditingController economicIndicatorController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    final textFieldBorderStyle = OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: const BorderSide(color: Colors.grey, width: 2),
    );

    // Function to build a text field with a controller
    Widget buildTextField(String label, TextEditingController controller) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: screenWidth * 0.045, // Responsive font size based on screen width
                fontWeight: FontWeight.bold,
                color: Colors.orange,
              ),
            ),
            const SizedBox(height: 6),
            TextField(
              controller: controller, // Attach the controller
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

    // Function to handle form submission
    void handleSubmit() {
      // Access data from controllers
      final date = dateController.text;
      final month = monthController.text;
      final quarter = quarterController.text;
      final season = seasonController.text;
      final fuelPrice = fuelPriceController.text;
      final economicIndicator = economicIndicatorController.text;

      // Simple validation check to ensure fields are not empty
      if (date.isEmpty ||
          month.isEmpty ||
          quarter.isEmpty ||
          season.isEmpty ||
          fuelPrice.isEmpty ||
          economicIndicator.isEmpty) {
        // Show an error message if any field is empty
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please fill in all fields')),
        );
        return;
      }

      // If everything is fine, show confirmation dialog
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Success'),
            content: const Text('Data Submitted'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Time and Date Data'),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(screenWidth * 0.05), // Adjust padding based on screen width
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Time and Date Data Fields with controllers
              buildTextField('Date', dateController),
              buildTextField('Month', monthController),
              buildTextField('Quarter', quarterController),
              buildTextField('Season', seasonController),
              buildTextField('Fuel Price Index', fuelPriceController),
              buildTextField('Economic Indicator', economicIndicatorController),

              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: handleSubmit, // Call handleSubmit when the button is pressed
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  minimumSize: Size(screenWidth * 0.9, screenHeight * 0.07), // Responsive button height
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