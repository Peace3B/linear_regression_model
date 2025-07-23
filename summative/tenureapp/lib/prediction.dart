import 'package:flutter/material.dart';
import 'model/api.dart';

class PredictionPage extends StatefulWidget {
  @override
  _PredictionPageState createState() => _PredictionPageState();
}

class _PredictionPageState extends State<PredictionPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController totalWorkingYearsController =
      TextEditingController();
  final TextEditingController yearsInCurrentRoleController =
      TextEditingController();
  final TextEditingController yearsSinceLastPromotionController =
      TextEditingController();
  final TextEditingController yearsWithCurrManagerController =
      TextEditingController();
  final TextEditingController jobLevelController = TextEditingController();
  final TextEditingController monthlyIncomeController = TextEditingController();

  String? predictionResult;

  void fetchPrediction() async {
    if (_formKey.currentState!.validate()) {
      final predictionService = PredictionService();
      final prediction = await predictionService.getPrediction(
        age: double.parse(ageController.text),
        totalWorkingYears: double.parse(totalWorkingYearsController.text),
        yearsInCurrentRole: double.parse(yearsInCurrentRoleController.text),
        yearsSinceLastPromotion:
            double.parse(yearsSinceLastPromotionController.text),
        yearsWithCurrManager: double.parse(yearsWithCurrManagerController.text),
        jobLevel: double.parse(jobLevelController.text),
        monthlyIncome: double.parse(monthlyIncomeController.text),
      );

      setState(() {
        predictionResult = prediction;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 240, 222, 184),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 158, 121, 66),
        title: Text('Job Tenure Calculator'),
        titleTextStyle: TextStyle(
          color: Colors.black,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: ageController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: 'Age'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your age';
                  }
                  final age = double.tryParse(value);
                  if (age == null || age < 18 || age > 61) {
                    return 'Age must be between 18 and 61';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: totalWorkingYearsController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: 'Total Working Years'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your total working years';
                  }
                  final years = double.tryParse(value);
                  if (years == null || years < 0 || years > 40) {
                    return 'Total working years must be between 0 and 40';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: yearsInCurrentRoleController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: 'Years in Current Role'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your years in current role';
                  }
                  final years = double.tryParse(value);
                  if (years == null || years < 0 || years > 18) {
                    return 'Years in current role must be between 0 and 18';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: yearsSinceLastPromotionController,
                keyboardType: TextInputType.number,
                decoration:
                    InputDecoration(labelText: 'Years Since Last Promotion'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your years since last promotion';
                  }
                  final years = double.tryParse(value);
                  if (years == null || years < 0 || years > 15) {
                    return 'Years since last promotion must be between 0 and 15';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: yearsWithCurrManagerController,
                keyboardType: TextInputType.number,
                decoration:
                    InputDecoration(labelText: 'Years with Current Manager'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your years with current manager';
                  }
                  final years = double.tryParse(value);
                  if (years == null || years < 0 || years > 17) {
                    return 'Years with current manager must be between 0 and 17';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: jobLevelController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: 'Job Level'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your job level';
                  }
                  final level = double.tryParse(value);
                  if (level == null || level < 1 || level > 5) {
                    return 'Job level must be between 1 and 5';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: monthlyIncomeController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: 'Monthly Income'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your monthly income';
                  }
                  final income = double.tryParse(value);
                  if (income == null || income < 0 || income > 20000) {
                    return 'Monthly income must be between 0 and 20000';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: fetchPrediction,
                child: const Text('Get Prediction'),
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.black,
                ),
              ),
              const SizedBox(height: 20),
              if (predictionResult != null)
                Text(
                  'This person will likely spend $predictionResult years on the job',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
