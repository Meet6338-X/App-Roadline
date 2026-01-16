import 'package:demo1/input%20data/DriverDataPage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class VehiclesDataPage extends StatefulWidget {
  const VehiclesDataPage({super.key});

  @override
  _VehiclesDataPageState createState() => _VehiclesDataPageState();
}

class _VehiclesDataPageState extends State<VehiclesDataPage> {
  // Define TextEditingControllers for each field
  final TextEditingController vehicleIdController = TextEditingController();
  final TextEditingController vehicleTypeController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController fuelEfficiencyController = TextEditingController();
  final TextEditingController maintenanceCostController = TextEditingController();
  final TextEditingController insuranceController = TextEditingController();
  final TextEditingController leaseLoanPaymentController = TextEditingController();
  final TextEditingController registrationFeesController = TextEditingController();

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

    // Function to upload vehicle data to Firebase
    Future<void> uploadVehicleData() async {
      final vehicleData = {
        'vehicleId': vehicleIdController.text,
        'vehicleType': vehicleTypeController.text,
        'age': int.parse(ageController.text),
        'fuelEfficiency': double.parse(fuelEfficiencyController.text),
        'annualMaintenanceCost': double.parse(maintenanceCostController.text),
        'vehicleInsurance': double.parse(insuranceController.text),
        'vehicleLeaseLoanPayment': double.parse(leaseLoanPaymentController.text),
        'registrationFees': double.parse(registrationFeesController.text),
        'timestamp': FieldValue.serverTimestamp(),
      };

      try {
        // Add data to Firestore collection
        await FirebaseFirestore.instance.collection('Vehicles').add(vehicleData);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Vehicle data added successfully!')),
        );
        // After submitting, navigate to the DriverDataPage
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const DriverDataPage()),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to add vehicle data: $e')),
        );
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Vehicles Data'),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(screenWidth * 0.05), // Adjust padding based on screen width
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Vehicles Data Fields with controllers
              buildTextField('Vehicle ID', vehicleIdController),
              buildTextField('Vehicle Type', vehicleTypeController),
              buildTextField('Age (Years)', ageController),
              buildTextField('Fuel Efficiency (km/l)', fuelEfficiencyController),
              buildTextField('Annual Maintenance Cost (INR)', maintenanceCostController),
              buildTextField('Vehicle Insurance (INR)', insuranceController),
              buildTextField('Vehicle Lease or Loan Payment (INR)', leaseLoanPaymentController),
              buildTextField('Registration Fees (INR)', registrationFeesController),

              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  // Call the function to upload vehicle data to Firebase
                  uploadVehicleData();
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