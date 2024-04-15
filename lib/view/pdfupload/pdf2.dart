import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:http/http.dart' as http;

class PdfPage2 extends StatefulWidget {
  const PdfPage2({Key? key}) : super(key: key);

  @override
  State<PdfPage2> createState() => _PdfPage2State();
}

class _PdfPage2State extends State<PdfPage2> {
  // void fetchData() async {
  //   // Replace the URL with your API endpoint
  //   var url = Uri.parse('http://10.0.2.2:5000/pdfToText');
  //   var response = await http.get(url);

  //   if (response.statusCode == 200) {
  //     // Request successful, parse the response
  //     print('Response: ${response.body}');
  //   } else {
  //     // Request failed
  //     print('Failed to load data: ${response.statusCode}');
  //   }
  // }
  String pdfData = '';
  String geminiData = '';
  void geminiRequest(String pdfData) async {
    try {
      final model = GenerativeModel(
          model: 'gemini-pro',
          apiKey: "AIzaSyDD5xI1fIhIl5ppCgbrwcbFPKJHiHKj6d4");

      // final prompt = 'Analyze the following data:\n\n${pdfData}';
      String prompt =
          "Process Investment Data and give full analysis and report for Display (make the response clear and concise): $pdfData";
      // String prompt =
      //     "The text given below includes personal information, PAN details, and a list of investments with folio numbers, investment values, market values, profit/loss statistics, and other relevant data. Expected Output: Extract and display the investor's name and PAN card number at the top of the output. Construct a detailed table with the following columns based on the provided text input: Folio No., Scheme Name, Invested Value (INR), Market Value (INR), Gain/Loss (Absolute), Gain/Loss (%), Balance Units, NAV Date, NAV. Details: The API should parse the input text to identify and extract necessary details. For personal details (e.g., name, PAN), the API should locate these at the beginning of the text and highlight or separate them for easy visibility. Investment data should be formatted into a structured table as specified. Handle variations in text formatting and ensure the table is accurate and reflective of the input data. Use Case: This API function is ideal for financial analysts or individual investors who need to convert raw text data from financial documents into organized, easily interpretable formats. This can aid in better decision-making and record-keeping.\n\nProcess Investment Data is : $pdfData";
      final content = [Content.text(prompt)];
      final response = await model.generateContent(content);
      print("Generated Response");
      setState(() {
        geminiData = response.text!;
      });
      print(response.text);
    } catch (e) {
      print('Error generating content: $e');
      // Handle the error gracefully, maybe show a message to the user
    }
  }

  Future<String> fetchData() async {
    var url = Uri.parse('http://10.0.2.2:5000/pdfToText');

    try {
      var response = await http.get(url);

      if (response.statusCode == 200) {
        // Convert the response body to JSON
        var jsonResponse = json.decode(response.body);

        // Print the JSON response
        // print('Response JSON: $jsonResponse');

        // Example: Access a specific field from the JSON response
        var pdfText = jsonResponse['pdfText'];
        print('pdfText: $pdfText');
        return pdfText;
      } else {
        // Request failed
        print('Failed to load data: ${response.statusCode}');
        return '';
      }
    } catch (e) {
      // Handle exceptions
      print('Error: $e');
      return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              ElevatedButton(
                child: Text("Upload PDF"),
                onPressed: () async {
                  // fetchData();
                  geminiRequest(await fetchData());
                },
              ),
              SingleChildScrollView(
                child: Text(geminiData),
              )
            ],
          ),
        ),
      ),
    );
  }
}
