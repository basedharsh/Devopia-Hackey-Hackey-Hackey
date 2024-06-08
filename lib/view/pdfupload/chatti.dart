import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({Key? key}) : super(key: key);

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _questionController = TextEditingController();
  List<Map<String, String>> messages = [];

  void handleQuestion() async {
    String question = _questionController.text;
    if (question.isNotEmpty) {
      setState(() {
        messages.add({"type": "question", "text": question});
      });
      _questionController.clear();

      String prompt = "Answer the following question: '$question'.";

      try {
        final model = GenerativeModel(
            model: 'gemini-pro',
            apiKey: "AIzaSyCYMHQs8ZPkDC6vSAGqHor17luXQ6ZSXrA");
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
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text('Chat with AI'),
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

void main() {
  runApp(MaterialApp(
    home: ChatPage(),
  ));
}
