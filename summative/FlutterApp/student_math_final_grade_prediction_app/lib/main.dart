import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

void main() {
  runApp(const GradePredictorApp());
}

class GradePredictorApp extends StatelessWidget {
  const GradePredictorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Math Grade Predictor',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const PredictionScreen(),
    );
  }
}

class PredictionScreen extends StatefulWidget {
  const PredictionScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _PredictionScreenState createState() => _PredictionScreenState();
}

class _PredictionScreenState extends State<PredictionScreen> {
  final _formKey = GlobalKey<FormState>();

  // Dropdown menu variables for categorical fields
  String school = "GP";
  String sex = "M";
  String address = "U";
  String famsize = "GT3";
  String pstatus = "T";
  String mjob = "teacher";
  String fjob = "teacher";
  String reason = "reputation";
  String guardian = "mother";
  String schoolsup = "yes";
  String famsup = "yes";
  String paid = "yes";
  String activities = "yes";
  String nursery = "yes";
  String higher = "yes";
  String internet = "yes";
  String romantic = "yes";

  // Text controllers for numerical fields
  final ageController = TextEditingController();
  final meduController = TextEditingController();
  final feduController = TextEditingController();
  final traveltimeController = TextEditingController();
  final studytimeController = TextEditingController();
  final failuresController = TextEditingController();
  final famrelController = TextEditingController();
  final freetimeController = TextEditingController();
  final gooutController = TextEditingController();
  final dalcController = TextEditingController();
  final walcController = TextEditingController();
  final healthController = TextEditingController();
  final absencesController = TextEditingController();

  Future<void> _predictGrade(BuildContext context) async {
    final input = {
      "school": school,
      "sex": sex,
      "address": address,
      "famsize": famsize,
      "Pstatus": pstatus,
      "Mjob": mjob,
      "Fjob": fjob,
      "reason": reason,
      "guardian": guardian,
      "schoolsup": schoolsup,
      "famsup": famsup,
      "paid": paid,
      "activities": activities,
      "nursery": nursery,
      "higher": higher,
      "internet": internet,
      "romantic": romantic,
      "age": int.tryParse(ageController.text) ?? 14,
      "Medu": int.tryParse(meduController.text) ?? 0,
      "Fedu": int.tryParse(feduController.text) ?? 0,
      "traveltime": int.tryParse(traveltimeController.text) ?? 1,
      "studytime": int.tryParse(studytimeController.text) ?? 1,
      "failures": int.tryParse(failuresController.text) ?? 0,
      "famrel": int.tryParse(famrelController.text) ?? 1,
      "freetime": int.tryParse(freetimeController.text) ?? 1,
      "goout": int.tryParse(gooutController.text) ?? 1,
      "Dalc": int.tryParse(dalcController.text) ?? 1,
      "Walc": int.tryParse(walcController.text) ?? 1,
      "health": int.tryParse(healthController.text) ?? 1,
      "absences": int.tryParse(absencesController.text) ?? 0,
    };

    try {
      final response = await http.post(
        Uri.parse(
          "https://student-math-final-grade-submission.onrender.com/predict",
        ),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(input),
      );
      if (response.statusCode == 200) {
        final prediction = jsonDecode(response.body)["final_grade_prediction"];
        if (context.mounted) {
          Navigator.push(
            context,
            _createRoute(ResultScreen(prediction: prediction)),
          );
        }
      } else {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: ${response.reasonPhrase}')),
          );
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  Route _createRoute(Widget screen) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => screen,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(0.0, 1.0);
        const end = Offset.zero;
        const curve = Curves.easeInOut;

        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        var fadeTween = Tween<double>(begin: 0.0, end: 1.0);

        return FadeTransition(
          opacity: animation.drive(fadeTween),
          child: SlideTransition(
            position: animation.drive(tween),
            child: child,
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Predict Math Grade"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildDropdownField(
                  "School", ["GP", "MS"], (value) => school = value!),
              _buildDropdownField("Sex", ["M", "F"], (value) => sex = value!),
              _buildDropdownField(
                  "Address", ["U", "R"], (value) => address = value!),
              _buildDropdownField(
                  "Family Size", ["GT3", "LE3"], (value) => famsize = value!),
              _buildDropdownField(
                  "Parent Status", ["T", "A"], (value) => pstatus = value!),
              _buildDropdownField(
                  "Mother's Job",
                  ["at_home", "health", "other", "services", "teacher"],
                  (value) => mjob = value!),
              _buildDropdownField(
                  "Father's Job",
                  ["at_home", "health", "other", "services", "teacher"],
                  (value) => fjob = value!),
              _buildDropdownField(
                  "Reason",
                  ["course", "home", "other", "reputation"],
                  (value) => reason = value!),
              _buildDropdownField("Guardian", ["mother", "father", "other"],
                  (value) => guardian = value!),
              _buildDropdownField("School Support", ["yes", "no"],
                  (value) => schoolsup = value!),
              _buildDropdownField(
                  "Family Support", ["yes", "no"], (value) => famsup = value!),
              _buildDropdownField(
                  "Paid Classes", ["yes", "no"], (value) => paid = value!),
              _buildDropdownField(
                  "Activities", ["yes", "no"], (value) => activities = value!),
              _buildDropdownField(
                  "Nursery", ["yes", "no"], (value) => nursery = value!),
              _buildDropdownField("Higher Education", ["yes", "no"],
                  (value) => higher = value!),
              _buildDropdownField(
                  "Internet", ["yes", "no"], (value) => internet = value!),
              _buildDropdownField("Romantic Relationship", ["yes", "no"],
                  (value) => romantic = value!),
              _buildNumericField("Age", ageController),
              _buildNumericField("Mother's Education (Medu)", meduController),
              _buildNumericField("Father's Education (Fedu)", feduController),
              _buildNumericField("Travel Time", traveltimeController),
              _buildNumericField("Study Time", studytimeController),
              _buildNumericField("Failures", failuresController),
              _buildNumericField("Family Relations", famrelController),
              _buildNumericField("Free Time", freetimeController),
              _buildNumericField("Going Out", gooutController),
              _buildNumericField(
                  "Workday Alcohol Consumption (Dalc)", dalcController),
              _buildNumericField(
                  "Weekend Alcohol Consumption (Walc)", walcController),
              _buildNumericField("Health", healthController),
              _buildNumericField("Absences", absencesController),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _predictGrade(context);
                  }
                },
                child: const Text("Predict"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDropdownField(
      String label, List<String> options, Function(String?) onChanged) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: DropdownButtonFormField<String>(
        decoration: InputDecoration(labelText: label),
        value: options[0],
        items: options.map((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
        onChanged: onChanged,
      ),
    );
  }

  Widget _buildNumericField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        decoration: InputDecoration(labelText: label),
        controller: controller,
        keyboardType: TextInputType.number,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter $label';
          }
          return null;
        },
      ),
    );
  }
}

class ResultScreen extends StatelessWidget {
  final double prediction;

  const ResultScreen({super.key, required this.prediction});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: const Text(
          "Prediction Result",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.blueAccent,
          ),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Card(
            elevation: 8.0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    "Prediction Summary",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.blueAccent,
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    "The final grade prediction for the student is:",
                    style: TextStyle(fontSize: 18),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 15),
                  Text(
                    prediction.toStringAsFixed(3),
                    style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: Colors.green[700],
                    ),
                  ),
                  const SizedBox(height: 30),
                  ElevatedButton.icon(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.arrow_back),
                    label: const Text("Back"),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
