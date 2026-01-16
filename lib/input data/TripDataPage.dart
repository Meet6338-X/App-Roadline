import 'package:demo1/input%20data/VehiclesDataPage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TripDataPage extends StatelessWidget {
  const TripDataPage({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    final textFieldBorderStyle = OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: const BorderSide(color: Colors.grey, width: 2),
    );

    final TextEditingController tripIdController = TextEditingController();
    final TextEditingController dateController = TextEditingController();
    final TextEditingController vehicleIdController = TextEditingController();
    final TextEditingController driverIdController = TextEditingController();
    final TextEditingController distanceKmController = TextEditingController();
    final TextEditingController durationHrsController = TextEditingController();
    final TextEditingController cargoWeightKgController = TextEditingController();
    final TextEditingController routeTypeController = TextEditingController();
    final TextEditingController fuelCostController = TextEditingController();
    final TextEditingController maintenanceCostController = TextEditingController();
    final TextEditingController tollsFeesController = TextEditingController();
    final TextEditingController driverWagesController = TextEditingController();
    final TextEditingController driverIncentivesController = TextEditingController();
    final TextEditingController miscellaneousCostController = TextEditingController();
    final TextEditingController totalExpensesController = TextEditingController();
    final TextEditingController profitLossController = TextEditingController();

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
              keyboardType: label.contains("Cost") ||
                  label.contains("Distance") ||
                  label.contains("Weight") ||
                  label.contains("Duration") ||
                  label.contains("Expenses") ||
                  label.contains("Profit")
                  ? TextInputType.number
                  : TextInputType.text,
            ),
          ],
        ),
      );
    }

    Future<void> uploadTripData() async {
      try {
        await FirebaseFirestore.instance.collection("Trip").add({
          'tripId': tripIdController.text,
          'date': dateController.text,
          'vehicleId': vehicleIdController.text,
          'driverId': driverIdController.text,
          'distanceKm': double.tryParse(distanceKmController.text) ?? 0.0,
          'durationHrs': double.tryParse(durationHrsController.text) ?? 0.0,
          'cargoWeightKg': double.tryParse(cargoWeightKgController.text) ?? 0.0,
          'routeType': routeTypeController.text,
          'fuelCost': double.tryParse(fuelCostController.text) ?? 0.0,
          'maintenanceCost': double.tryParse(maintenanceCostController.text) ?? 0.0,
          'tollsAndParkingFees': double.tryParse(tollsFeesController.text) ?? 0.0,
          'driverWages': double.tryParse(driverWagesController.text) ?? 0.0,
          'driverIncentives': double.tryParse(driverIncentivesController.text) ?? 0.0,
          'miscellaneousCost': double.tryParse(miscellaneousCostController.text) ?? 0.0,
          'totalExpenses': double.tryParse(totalExpensesController.text) ?? 0.0,
          'profitOrLoss': double.tryParse(profitLossController.text) ?? 0.0,
          'timestamp': FieldValue.serverTimestamp(),
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Trip data uploaded successfully!")),
        );

        // Clear all controllers after successful upload
        tripIdController.clear();
        dateController.clear();
        vehicleIdController.clear();
        driverIdController.clear();
        distanceKmController.clear();
        durationHrsController.clear();
        cargoWeightKgController.clear();
        routeTypeController.clear();
        fuelCostController.clear();
        maintenanceCostController.clear();
        tollsFeesController.clear();
        driverWagesController.clear();
        driverIncentivesController.clear();
        miscellaneousCostController.clear();
        totalExpensesController.clear();
        profitLossController.clear();

        // Navigate to the VehicleDataPage after successful upload
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const VehiclesDataPage()),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to upload trip data: $e")),
        );
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Trip Data'),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(screenWidth * 0.05),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildTextField('Trip ID', tripIdController),
              buildTextField('Date', dateController),
              buildTextField('Vehicle ID', vehicleIdController),
              buildTextField('Driver ID', driverIdController),
              buildTextField('Distance (km)', distanceKmController),
              buildTextField('Duration (hrs)', durationHrsController),
              buildTextField('Cargo Weight (kg)', cargoWeightKgController),
              buildTextField('Route Type', routeTypeController),
              buildTextField('Fuel Cost (INR)', fuelCostController),
              buildTextField('Maintenance Cost (INR)', maintenanceCostController),
              buildTextField('Tolls & Parking Fees (INR)', tollsFeesController),
              buildTextField('Driver Wages (INR)', driverWagesController),
              buildTextField('Driver Incentives (INR)', driverIncentivesController),
              buildTextField('Miscellaneous Cost (INR)', miscellaneousCostController),
              buildTextField('Total Expenses (INR)', totalExpensesController),
              buildTextField('Profit/Loss (INR)', profitLossController),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: uploadTripData,
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