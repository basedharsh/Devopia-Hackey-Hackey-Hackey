import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:http/http.dart' as http;

class PDFuploadPage extends StatefulWidget {
  const PDFuploadPage({Key? key}) : super(key: key);

  @override
  State<PDFuploadPage> createState() => _PDFuploadPageState();
}

class _PDFuploadPageState extends State<PDFuploadPage> {
  String geminiData = '';
  final TextEditingController _questionController = TextEditingController();
  List<Map<String, String>> messages = [];

  Future<void> fetchData() async {
    var url = Uri.parse('http://10.0.2.2:5000/pdfToText');
    try {
      var response = await http.get(url);
      if (response.statusCode == 200) {
        var jsonResponse = json.decode(response.body);
        setState(() {
          geminiData =
              jsonResponse['pdfText'] as String; // Store the full PDF text
        });
      } else {
        print('Failed to load data: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  void handleQuestion() async {
    String question = _questionController.text;
    if (question.isNotEmpty) {
      setState(() {
        messages.add({"type": "question", "text": question});
      });
      _questionController.clear();

      // Use the first 1000 characters of the PDF content or less for context
      String prompt =
          "Conduct a thorough analysis of the provided PDF data. Extract key insights and use these insights to formulate a detailed response. Based on your comprehensive analysis, answer the following question: '$question'.\n\nPDF Data Snippet: '${geminiData.substring(0, 4000)}. Just make sure you dont say i cant provide or i cant provide that use your thinking and give data.'";

      try {
        final model = GenerativeModel(
            model: 'gemini-pro',
            apiKey: "AIzaSyCxBZQi438SjAauLWAYVynhLwHVr1WgB6k");
        final content = [Content.text(prompt)];
        final response = await model.generateContent(content);
        setState(() {
          messages.add({
            "type": "answer",
            "text": response.text!.replaceAll('*', '') // Process response text
          });
        });
      } catch (e) {
        setState(() {
          messages
              .add({"type": "answer", "text": 'Error generating content: $e'});
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    fetchData(); // Fetch PDF data on init
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text('Investment Details'),
        backgroundColor: Colors.black,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: messages.length,
                itemBuilder: (context, index) {
                  var message = messages[index];
                  return Align(
                    alignment: message['type'] == "question"
                        ? Alignment.centerLeft
                        : Alignment.centerRight,
                    child: Container(
                      margin: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                      padding:
                          EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                      decoration: BoxDecoration(
                        color: Colors.deepPurple,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        message['text']!,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _questionController,
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: "Ask a question...",
                      hintStyle: TextStyle(color: Colors.grey),
                      border: OutlineInputBorder(),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.deepPurple),
                      ),
                    ),
                  ),
                ),
                IconButton(
                  onPressed: handleQuestion,
                  icon: Icon(Icons.send, color: Colors.deepPurple),
                ),
              ],
            ),
            SizedBox(
              height: 150,
            )
          ],
        ),
      ),
    );
  }
}
