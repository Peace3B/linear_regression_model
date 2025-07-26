import 'dart:convert';
import 'package:http/http.dart' as http;

// Test script to verify API integration
class ApiTester {
  static const String baseUrl = "https://student-math-final-grade-submission.onrender.com";
  
  static Future<void> testApiConnection() async {
    print("🔬 Testing API Connection...");
    print("="*50);
    
    // Test data that matches API constraints
    final testData = {
      "school": "GP",
      "sex": "M",
      "address": "U",
      "famsize": "GT3",
      "Pstatus": "T",
      "Mjob": "teacher",
      "Fjob": "teacher",
      "reason": "reputation",
      "guardian": "mother",
      "schoolsup": "yes",
      "famsup": "yes",
      "paid": "yes",
      "activities": "yes",
      "nursery": "yes",
      "higher": "yes",
      "internet": "yes",
      "romantic": "yes",
      "age": 16,
      "Medu": 2,
      "Fedu": 3,
      "traveltime": 2,
      "studytime": 3,
      "failures": 0,
      "famrel": 4,
      "freetime": 3,
      "goout": 2,
      "Dalc": 1,
      "Walc": 2,
      "health": 5,
      "absences": 5
    };
    
    try {
      print("📤 Sending test request...");
      print("URL: $baseUrl/predict");
      print("Data: ${jsonEncode(testData)}");
      print("");
      
      final response = await http.post(
        Uri.parse("$baseUrl/predict"),
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
        },
        body: jsonEncode(testData),
      ).timeout(
        const Duration(seconds: 30),
        onTimeout: () {
          throw Exception('Request timeout after 30 seconds');
        },
      );
      
      print("📥 Response received:");
      print("Status Code: ${response.statusCode}");
      print("Headers: ${response.headers}");
      print("Body: ${response.body}");
      print("");
      
      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        final prediction = responseData["final_grade_prediction"];
        
        print("✅ API Test Successful!");
        print("🎯 Predicted Grade: $prediction");
        print("📊 Grade Range: 0-20");
        print("💡 Integration Status: WORKING");
        
      } else {
        print("❌ API Test Failed!");
        print("🔍 Error Details:");
        try {
          final errorData = jsonDecode(response.body);
          print("   ${errorData['detail'] ?? 'Unknown error'}");
        } catch (e) {
          print("   Raw response: ${response.body}");
        }
      }
      
    } catch (e) {
      print("💥 Connection Error:");
      print("   $e");
      print("");
      print("🔧 Troubleshooting Tips:");
      print("   1. Check internet connection");
      print("   2. Verify API server is running");
      print("   3. Check firewall settings");
      print("   4. Try again in a few minutes");
    }
    
    print("="*50);
  }
  
  static Future<void> testInvalidData() async {
    print("🧪 Testing API Validation...");
    print("="*30);
    
    // Test with invalid age
    final invalidData = {
      "school": "GP",
      "sex": "M",
      "age": 25, // Invalid: should be 14-22
      "Medu": 2,
      "Fedu": 3,
      // ... other required fields with valid values
    };
    
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/predict"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(invalidData),
      );
      
      if (response.statusCode == 400) {
        print("✅ Validation working correctly");
        print("📝 Error: ${response.body}");
      } else {
        print("⚠️  Unexpected response: ${response.statusCode}");
      }
      
    } catch (e) {
      print("❌ Validation test failed: $e");
    }
  }
}

// Run this in a separate dart file to test the API
void main() async {
  await ApiTester.testApiConnection();
  await ApiTester.testInvalidData();
}
