import 'package:demo1/input%20data/RouteAndRegionPage.dart';
import 'package:flutter/material.dart';

class ExpenseBreakdownPage extends StatefulWidget {
  const ExpenseBreakdownPage({super.key});

  @override
  _ExpenseBreakdownPageState createState() => _ExpenseBreakdownPageState();
}

class _ExpenseBreakdownPageState extends State<ExpenseBreakdownPage> {
  // Define TextEditingControllers for each field
  final TextEditingController tripIdController = TextEditingController();
  final TextEditingController expenseCategoryController = TextEditingController();
  final TextEditingController amountController = TextEditingController();
  final TextEditingController dateController = TextEditingController();

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
                fontSize: screenWidth * 0.045, // Responsive font size
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

    // Function to handle submission
    void handleSubmit() {
      final tripId = tripIdController.text;
      final expenseCategory = expenseCategoryController.text;
      final amount = amountController.text;
      final date = dateController.text;

      if (tripId.isNotEmpty &&
          expenseCategory.isNotEmpty &&
          amount.isNotEmpty &&
          date.isNotEmpty) {
        // Add validation or save data logic here

        // After validation, navigate to the Route and Region page
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const RouteAndRegionPage()),
        );
      } else {
        // Show an error message if any field is empty
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Please fill in all the fields.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Expense Breakdown'),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(screenWidth * 0.05), // Adjust padding
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildTextField('Trip ID', tripIdController),
              buildTextField('Expense Category', expenseCategoryController),
              buildTextField('Amount (INR)', amountController),
              buildTextField('Date', dateController),

              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: handleSubmit, // Call handleSubmit
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  minimumSize: Size(screenWidth * 0.9, screenHeight * 0.07), // Responsive button
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
