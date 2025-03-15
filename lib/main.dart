import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(); // Load .env file
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Google Food Rescue',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const FoodCategorizerScreen(),
    );
  }
}

class FoodCategorizerScreen extends StatefulWidget {
  const FoodCategorizerScreen({super.key});

  @override
  _FoodCategorizerScreenState createState() => _FoodCategorizerScreenState();
}

class _FoodCategorizerScreenState extends State<FoodCategorizerScreen> {
  final TextEditingController _foodController = TextEditingController();
  String _result = '';
  bool _isLoading = false;

  Future<void> _fetchCategory() async {
    setState(() {
      _isLoading = true;
      _result = '';
    });

    final String apiKey = dotenv.env['GEMINI_API_KEY'] ?? '';

    if (apiKey.isEmpty) {
      setState(() {
        _result = "Error: API key is missing!";
        _isLoading = false;
      });
      return;
    }

    final String foodName = _foodController.text.trim();
    if (foodName.isEmpty) {
      setState(() {
        _result = "Error: Please enter a food name.";
        _isLoading = false;
      });
      return;
    }

    try {
      final Uri url = Uri.parse(
          "https://generativelanguage.googleapis.com/v1/models/gemini-pro:generateContent?key=$apiKey");

      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "contents": [
            {
              "parts": [
                {
                  "text": "Given the food item '$foodName', classify it into one of the following categories: Fruits, Vegetables, Dairy, Grains, Meat, Seafood, Snacks, Beverages, Other. Provide only the category name as the response."
                }
              ]
            }
          ]
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        String? category = data['candidates']?[0]['content']['parts']?[0]['text'];

        if (category == null || category.isEmpty) {
          _result = "Error: Could not categorize food.";
        } else {
          _result = "Category: $category";
        }
      } else {
        _result = "Error: API request failed. Check API key and network.";
      }
    } catch (e) {
      _result = "Error: $e";
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Google Food Rescue'),
        backgroundColor: Colors.deepPurple.shade50,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Enter Food Name",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _foodController,
              decoration: InputDecoration(
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                filled: true,
                fillColor: Colors.grey[200],
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _isLoading ? null : _fetchCategory,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              child: _isLoading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text("Categorize Food"),
            ),
            const SizedBox(height: 20),
            Text(
              _result,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.red.shade700),
            ),
          ],
        ),
      ),
    );
  }
}
