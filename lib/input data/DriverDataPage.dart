import 'package:demo1/input%20data/ExpenseBreakdownPage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DriverDataPage extends StatefulWidget {
  const DriverDataPage({super.key});

  @override
  _DriverDataPageState createState() => _DriverDataPageState();
}

class _DriverDataPageState extends State<DriverDataPage> {
  // Define TextEditingControllers for each field
  final TextEditingController driverIdController = TextEditingController();
  final TextEditingController driverNameController = TextEditingController();
  final TextEditingController experienceController = TextEditingController();
  final TextEditingController baseWageController = TextEditingController();
  final TextEditingController totalTripsController = TextEditingController();
  final TextEditingController performanceScoreController = TextEditingController();
  final TextEditingController accidentsCountController = TextEditingController();
  final TextEditingController incentivesController = TextEditingController();

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
                fontSize: screenWidth * 0.045, // Responsive font size based on screen width
                fontWeight: FontWeight.bold,
                color: Colors.orange,
              ),
            ),
            const SizedBox(height: 6),
            TextField(
              controller: controller, // Assign the controller here
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

    // Function to upload driver data to Firebase
    Future<void> uploadDriverData() async {
      final driverData = {
        'driverId': driverIdController.text,
        'driverName': driverNameController.text,
        'experience': int.parse(experienceController.text),
        'baseWage': double.parse(baseWageController.text),
        'totalTripsCompleted': int.parse(totalTripsController.text),
        'performanceScore': double.parse(performanceScoreController.text),
        'accidentsCount': int.parse(accidentsCountController.text),
        'driverIncentives': double.parse(incentivesController.text),
        'timestamp': FieldValue.serverTimestamp(),
      };

      try {
        // Add data to Firestore collection
        await FirebaseFirestore.instance.collection('Drivers').add(driverData);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Driver data added successfully!')),
        );
        // After submitting, navigate to the Expense Breakdown page
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const ExpenseBreakdownPage()),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to add driver data: $e')),
        );
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Driver Data'),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(screenWidth * 0.05), // Adjust padding based on screen width
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Driver Data Fields with controllers
              buildTextField('Driver ID', driverIdController),
              buildTextField('Driver Name', driverNameController),
              buildTextField('Experience (Years)', experienceController),
              buildTextField('Base Wage (INR)', baseWageController),
              buildTextField('Total Trips Completed', totalTripsController),
              buildTextField('Average Performance Score', performanceScoreController),
              buildTextField('Accidents Count', accidentsCountController),
              buildTextField('Driver Incentives Total (INR)', incentivesController),

              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  // Call the function to upload driver data to Firebase
                  uploadDriverData();
                },
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