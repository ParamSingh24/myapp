import 'package:flutter/material.dart';

class FoodCategorizerScreen extends StatefulWidget {
  const FoodCategorizerScreen({super.key});

  @override
  State<FoodCategorizerScreen> createState() => _FoodCategorizerScreenState();
}

class _FoodCategorizerScreenState extends State<FoodCategorizerScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Food Categorizer")),
      body: SingleChildScrollView( // Fix RenderFlex overflow
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min, // Prevents expansion
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Scan Food Item",
                style: TextStyle( // Removed GoogleFonts
                  fontSize: 24, fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Container(
                height: 200,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Center(child: Text("Camera Preview Here")),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  // TODO: Implement AI categorization
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Processing Image...")),
                  );
                },
                child: const Text("Analyze Food"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
