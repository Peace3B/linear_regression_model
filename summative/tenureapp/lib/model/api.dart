import 'package:http/http.dart' as http;
import 'dart:convert';

class PredictionService {
  Future<String?> getPrediction({
    required double age,
    required double totalWorkingYears,
    required double yearsInCurrentRole,
    required double yearsSinceLastPromotion,
    required double yearsWithCurrManager,
    required double jobLevel,
    required double monthlyIncome,
  }) async {
    const url = 'https://api-durq.onrender.com/predict';

    // Prepare the request body
    final requestBody = {
      "age": age,
      "total_working_years": totalWorkingYears,
      "years_in_current_role": yearsInCurrentRole,
      "years_since_last_promotion": yearsSinceLastPromotion,
      "years_with_curr_manager": yearsWithCurrManager,
      "job_level": jobLevel,
      "monthly_income": monthlyIncome,
    };

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        return responseData["They will likely spend "].toString();
      } else {
        print('Failed to get prediction: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error occurred: $e');
      return null;
    }
  }
}
