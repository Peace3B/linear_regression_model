import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

// Enums for categorical data
enum School { GP, MS }

enum Sex { M, F }

enum Address { U, R }

enum FamilySize { GT3, LE3 }

enum ParentStatus { T, A }

enum Job { at_home, health, other, services, teacher }

enum Reason { course, home, other, reputation }

enum Guardian { mother, father, other }

enum YesNo { yes, no }

// Extension to get string values from enums
extension SchoolExtension on School {
  String get value => name;
}

extension SexExtension on Sex {
  String get value => name;
}

extension AddressExtension on Address {
  String get value => name;
}

extension FamilySizeExtension on FamilySize {
  String get value => name;
}

extension ParentStatusExtension on ParentStatus {
  String get value => name;
}

extension JobExtension on Job {
  String get value => name;
}

extension ReasonExtension on Reason {
  String get value => name;
}

extension GuardianExtension on Guardian {
  String get value => name;
}

extension YesNoExtension on YesNo {
  String get value => name;
}

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

  // Enum variables for categorical fields
  School school = School.GP;
  Sex sex = Sex.M;
  Address address = Address.U;
  FamilySize famsize = FamilySize.GT3;
  ParentStatus pstatus = ParentStatus.T;
  Job mjob = Job.teacher;
  Job fjob = Job.teacher;
  Reason reason = Reason.reputation;
  Guardian guardian = Guardian.mother;
  YesNo schoolsup = YesNo.yes;
  YesNo famsup = YesNo.yes;
  YesNo paid = YesNo.yes;
  YesNo activities = YesNo.yes;
  YesNo nursery = YesNo.yes;
  YesNo higher = YesNo.yes;
  YesNo internet = YesNo.yes;
  YesNo romantic = YesNo.yes;

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
      "school": school.value,
      "sex": sex.value,
      "address": address.value,
      "famsize": famsize.value,
      "Pstatus": pstatus.value,
      "Mjob": mjob.value,
      "Fjob": fjob.value,
      "reason": reason.value,
      "guardian": guardian.value,
      "schoolsup": schoolsup.value,
      "famsup": famsup.value,
      "paid": paid.value,
      "activities": activities.value,
      "nursery": nursery.value,
      "higher": higher.value,
      "internet": internet.value,
      "romantic": romantic.value,
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
              _buildEnumDropdownField<School>("School", School.values, school,
                  (value) => setState(() => school = value!)),
              _buildEnumDropdownField<Sex>("Sex", Sex.values, sex,
                  (value) => setState(() => sex = value!)),
              _buildEnumDropdownField<Address>("Address", Address.values,
                  address, (value) => setState(() => address = value!)),
              _buildEnumDropdownField<FamilySize>(
                  "Family Size",
                  FamilySize.values,
                  famsize,
                  (value) => setState(() => famsize = value!)),
              _buildEnumDropdownField<ParentStatus>(
                  "Parent Status",
                  ParentStatus.values,
                  pstatus,
                  (value) => setState(() => pstatus = value!)),
              _buildEnumDropdownField<Job>("Mother's Job", Job.values, mjob,
                  (value) => setState(() => mjob = value!)),
              _buildEnumDropdownField<Job>("Father's Job", Job.values, fjob,
                  (value) => setState(() => fjob = value!)),
              _buildEnumDropdownField<Reason>("Reason", Reason.values, reason,
                  (value) => setState(() => reason = value!)),
              _buildEnumDropdownField<Guardian>("Guardian", Guardian.values,
                  guardian, (value) => setState(() => guardian = value!)),
              _buildEnumDropdownField<YesNo>("School Support", YesNo.values,
                  schoolsup, (value) => setState(() => schoolsup = value!)),
              _buildEnumDropdownField<YesNo>("Family Support", YesNo.values,
                  famsup, (value) => setState(() => famsup = value!)),
              _buildEnumDropdownField<YesNo>("Paid Classes", YesNo.values, paid,
                  (value) => setState(() => paid = value!)),
              _buildEnumDropdownField<YesNo>("Activities", YesNo.values,
                  activities, (value) => setState(() => activities = value!)),
              _buildEnumDropdownField<YesNo>("Nursery", YesNo.values, nursery,
                  (value) => setState(() => nursery = value!)),
              _buildEnumDropdownField<YesNo>("Higher Education", YesNo.values,
                  higher, (value) => setState(() => higher = value!)),
              _buildEnumDropdownField<YesNo>("Internet", YesNo.values, internet,
                  (value) => setState(() => internet = value!)),
              _buildEnumDropdownField<YesNo>(
                  "Romantic Relationship",
                  YesNo.values,
                  romantic,
                  (value) => setState(() => romantic = value!)),
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

  Widget _buildEnumDropdownField<T extends Enum>(
      String label, List<T> options, T currentValue, Function(T?) onChanged) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: DropdownButtonFormField<T>(
        decoration: InputDecoration(labelText: label),
        value: currentValue,
        items: options.map((T value) {
          return DropdownMenuItem<T>(
            value: value,
            child: Text(_getEnumDisplayValue(value)),
          );
        }).toList(),
        onChanged: onChanged,
      ),
    );
  }

  String _getEnumDisplayValue<T extends Enum>(T enumValue) {
    switch (enumValue.runtimeType) {
      case School:
        return (enumValue as School).value;
      case Sex:
        return (enumValue as Sex).value;
      case Address:
        return (enumValue as Address).value;
      case FamilySize:
        return (enumValue as FamilySize).value;
      case ParentStatus:
        return (enumValue as ParentStatus).value;
      case Job:
        return (enumValue as Job).value;
      case Reason:
        return (enumValue as Reason).value;
      case Guardian:
        return (enumValue as Guardian).value;
      case YesNo:
        return (enumValue as YesNo).value;
      default:
        return enumValue.name;
    }
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
