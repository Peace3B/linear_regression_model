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

  // Loading state for API calls
  bool _isLoading = false;

  Future<void> _predictGrade(BuildContext context) async {
    // Validate input ranges according to API constraints
    if (!_validateInputRanges()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

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
      "age": int.tryParse(ageController.text) ?? 16,
      "Medu": int.tryParse(meduController.text) ?? 0,
      "Fedu": int.tryParse(feduController.text) ?? 0,
      "traveltime": int.tryParse(traveltimeController.text) ?? 1,
      "studytime": int.tryParse(studytimeController.text) ?? 1,
      "failures": int.tryParse(failuresController.text) ?? 0,
      "famrel": int.tryParse(famrelController.text) ?? 4,
      "freetime": int.tryParse(freetimeController.text) ?? 3,
      "goout": int.tryParse(gooutController.text) ?? 3,
      "Dalc": int.tryParse(dalcController.text) ?? 1,
      "Walc": int.tryParse(walcController.text) ?? 1,
      "health": int.tryParse(healthController.text) ?? 5,
      "absences": int.tryParse(absencesController.text) ?? 0,
    };

    try {
      // Show loading indicator
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Row(
              children: [
                CircularProgressIndicator(color: Colors.white),
                SizedBox(width: 16),
                Text('Predicting grade...'),
              ],
            ),
            duration: Duration(seconds: 30),
          ),
        );
      }

      final response = await http.post(
        Uri.parse(
          "https://student-math-final-grade-submission.onrender.com/predict",
        ),
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
        },
        body: jsonEncode(input),
      ).timeout(
        const Duration(seconds: 30),
        onTimeout: () {
          throw Exception('Request timeout - please try again');
        },
      );

      // Hide loading snackbar
      if (context.mounted) {
        ScaffoldMessenger.of(context).clearSnackBars();
      }

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        final prediction = responseData["final_grade_prediction"];
        
        if (context.mounted) {
          Navigator.push(
            context,
            _createRoute(ResultScreen(
              prediction: prediction is double ? prediction : prediction.toDouble(),
              inputData: input,
            )),
          );
        }
      } else if (response.statusCode == 400) {
        // Handle validation errors from API
        final errorData = jsonDecode(response.body);
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Validation Error: ${errorData['detail'] ?? 'Invalid input data'}'),
              backgroundColor: Colors.red,
              duration: const Duration(seconds: 5),
            ),
          );
        }
      } else {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Server Error: ${response.reasonPhrase} (${response.statusCode})'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Connection Error: ${e.toString()}'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 5),
            action: SnackBarAction(
              label: 'Retry',
              onPressed: () => _predictGrade(context),
            ),
          ),
        );
      }
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  bool _validateInputRanges() {
    // Validate age (14-22)
    final age = int.tryParse(ageController.text);
    if (age == null || age < 14 || age > 22) {
      _showValidationError('Age must be between 14 and 22');
      return false;
    }

    // Validate education levels (0-4)
    final medu = int.tryParse(meduController.text);
    final fedu = int.tryParse(feduController.text);
    if (medu == null || medu < 0 || medu > 4) {
      _showValidationError('Mother\'s education must be between 0 and 4');
      return false;
    }
    if (fedu == null || fedu < 0 || fedu > 4) {
      _showValidationError('Father\'s education must be between 0 and 4');
      return false;
    }

    // Validate 1-5 scale fields
    final fieldsToValidate = {
      'Travel Time': traveltimeController,
      'Study Time': studytimeController,
      'Family Relations': famrelController,
      'Free Time': freetimeController,
      'Going Out': gooutController,
      'Workday Alcohol': dalcController,
      'Weekend Alcohol': walcController,
      'Health': healthController,
    };

    for (final entry in fieldsToValidate.entries) {
      final value = int.tryParse(entry.value.text);
      if (value == null || value < 1 || value > 5) {
        _showValidationError('${entry.key} must be between 1 and 5');
        return false;
      }
    }

    // Validate failures (0-3)
    final failures = int.tryParse(failuresController.text);
    if (failures == null || failures < 0 || failures > 3) {
      _showValidationError('Failures must be between 0 and 3');
      return false;
    }

    // Validate absences (0-100)
    final absences = int.tryParse(absencesController.text);
    if (absences == null || absences < 0 || absences > 100) {
      _showValidationError('Absences must be between 0 and 100');
      return false;
    }

    return true;
  }

  void _showValidationError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.orange,
        duration: const Duration(seconds: 3),
      ),
    );
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
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _isLoading
                      ? null
                      : () {
                          if (_formKey.currentState!.validate()) {
                            _predictGrade(context);
                          }
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: _isLoading
                      ? const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(width: 10),
                            Text("Predicting..."),
                          ],
                        )
                      : const Text(
                          "Predict Grade",
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                ),
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
        decoration: InputDecoration(
          labelText: label,
          hintText: _getHintForField(label),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        ),
        controller: controller,
        keyboardType: TextInputType.number,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter $label';
          }
          final intValue = int.tryParse(value);
          if (intValue == null) {
            return 'Please enter a valid number';
          }
          
          // Apply specific validation based on field type
          final validation = _validateFieldRange(label, intValue);
          if (validation != null) {
            return validation;
          }
          
          return null;
        },
      ),
    );
  }

  String? _getHintForField(String label) {
    switch (label.toLowerCase()) {
      case 'age':
        return '14-22 years';
      case String() when label.contains('education'):
        return '0-4 (0=none, 4=higher)';
      case String() when label.contains('time') || label.contains('relations') || 
                          label.contains('free') || label.contains('going') || 
                          label.contains('alcohol') || label.contains('health'):
        return '1-5 scale';
      case 'failures':
        return '0-3 past failures';
      case 'absences':
        return '0-100 school absences';
      default:
        return null;
    }
  }

  String? _validateFieldRange(String label, int value) {
    switch (label.toLowerCase()) {
      case 'age':
        return (value < 14 || value > 22) ? 'Age must be between 14-22' : null;
      case String() when label.contains('education'):
        return (value < 0 || value > 4) ? 'Education level must be 0-4' : null;
      case String() when label.contains('time') || label.contains('relations') || 
                          label.contains('free') || label.contains('going') || 
                          label.contains('alcohol') || label.contains('health'):
        return (value < 1 || value > 5) ? '${label} must be 1-5' : null;
      case 'failures':
        return (value < 0 || value > 3) ? 'Failures must be 0-3' : null;
      case 'absences':
        return (value < 0 || value > 100) ? 'Absences must be 0-100' : null;
      default:
        return null;
    }
  }
}

class ResultScreen extends StatelessWidget {
  final double prediction;
  final Map<String, dynamic>? inputData;

  const ResultScreen({super.key, required this.prediction, this.inputData});

  Color _getGradeColor(double grade) {
    if (grade >= 16) return Colors.green[700]!;
    if (grade >= 14) return Colors.blue[700]!;
    if (grade >= 12) return Colors.orange[700]!;
    if (grade >= 10) return Colors.red[600]!;
    return Colors.red[800]!;
  }

  String _getGradeDescription(double grade) {
    if (grade >= 16) return "Excellent Performance";
    if (grade >= 14) return "Good Performance";
    if (grade >= 12) return "Satisfactory Performance";
    if (grade >= 10) return "Needs Improvement";
    return "Poor Performance";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        backgroundColor: _getGradeColor(prediction),
        foregroundColor: Colors.white,
        title: const Text(
          "Grade Prediction Result",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                // Main Result Card
                Card(
                  elevation: 8.0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          prediction >= 14 ? Icons.star : Icons.warning,
                          size: 48,
                          color: _getGradeColor(prediction),
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          "Final Grade Prediction",
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 16,
                          ),
                          decoration: BoxDecoration(
                            color: _getGradeColor(prediction).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: _getGradeColor(prediction),
                              width: 2,
                            ),
                          ),
                          child: Column(
                            children: [
                              Text(
                                prediction.toStringAsFixed(2),
                                style: TextStyle(
                                  fontSize: 48,
                                  fontWeight: FontWeight.bold,
                                  color: _getGradeColor(prediction),
                                ),
                              ),
                              Text(
                                "out of 20",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          _getGradeDescription(prediction),
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: _getGradeColor(prediction),
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 20),
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.blue[50],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.info_outline, color: Colors.blue[700]),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  "This prediction is based on machine learning analysis of student performance factors.",
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.blue[700],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                
                const SizedBox(height: 16),
                
                // Action Buttons
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.arrow_back),
                        label: const Text("New Prediction"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {
                          // Share functionality could be added here
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Share functionality coming soon!"),
                            ),
                          );
                        },
                        icon: const Icon(Icons.share),
                        label: const Text("Share"),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
