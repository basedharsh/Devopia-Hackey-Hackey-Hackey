import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:trackizer/common_widget/primary_button.dart';

class GroupDetailsPage extends StatefulWidget {
  final Map<String, dynamic> groupData;
  const GroupDetailsPage({Key? key, required this.groupData}) : super(key: key);

  @override
  State<GroupDetailsPage> createState() => _GroupDetailsPageState();
}

class _GroupDetailsPageState extends State<GroupDetailsPage> {
  TextEditingController txtAmount = TextEditingController();
  String geminiData = '';

  void geminiRequest() async {
    final model = GenerativeModel(
        model: 'gemini-pro', apiKey: "AIzaSyBCSI9ZhY7bQUfH27Uht6METwbfehACZQQ");
    String prompt =
        "Optimize Savings Strategy based on how to save money ${widget.groupData['amount']} for ${widget.groupData['reason']},Make sure it isnt the usual stuff like save on ur spending and other things give ebtter responses as in where to invest for it to grow? but good content maximum 10 lines not necesarily 10 points but not more than that. the user should be intrigued to read ";
    final content = [Content.text(prompt)];
    try {
      final response = await model.generateContent(content);
      setState(() {
        geminiData = response.text!.replaceAll('*', ''); // Remove all asterisks
      });
    } catch (e) {
      print('Error generating content: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme =
        Theme.of(context).copyWith(dividerColor: Colors.transparent);
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text('Group Details'),
        backgroundColor: Colors.black,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Card(
              color: Colors.grey[900], // Dark background for the card
              margin: const EdgeInsets.all(12),
              elevation: 8, // Adds shadow under the card for a lifted effect
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15), // Rounded corners
                side: BorderSide(
                    color: Colors.purpleAccent,
                    width: 2), // Purple border for some pop
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Name: ${widget.groupData["name"]}",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold)),
                    SizedBox(height: 8), // Adds space between rows
                    Text("Purpose: ${widget.groupData["reason"]}",
                        style: TextStyle(color: Colors.white70, fontSize: 16)),
                    SizedBox(height: 8),
                    Text("Total Amount: ${widget.groupData["amount"]}",
                        style: TextStyle(color: Colors.white, fontSize: 16)),
                    SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Amount Left:",
                            style:
                                TextStyle(color: Colors.white, fontSize: 16)),
                        Text("${widget.groupData["amountLeft"]}",
                            style: TextStyle(
                                color: Colors.greenAccent,
                                fontSize: 16,
                                fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text("Members and Their Contributions",
                style: TextStyle(color: Colors.white, fontSize: 18)),
            ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: (widget.groupData["members"] as List<dynamic>).length,
              itemBuilder: (context, index) {
                var memberId = widget.groupData["members"][index];
                bool isCurrentUser =
                    memberId == FirebaseAuth.instance.currentUser!.uid;
                return Container(
                  margin:
                      const EdgeInsets.symmetric(vertical: 4.0, horizontal: 10),
                  decoration: BoxDecoration(
                    border: Border.all(
                        color:
                            isCurrentUser ? Colors.purple : Colors.grey[800]!),
                    borderRadius: BorderRadius.circular(8.0),
                    color: Colors.grey[850],
                  ),
                  child: ListTile(
                    title:
                        Text(memberId, style: TextStyle(color: Colors.white)),
                    subtitle: Text(widget.groupData[memberId].toString(),
                        style: TextStyle(color: Colors.white70)),
                  ),
                );
              },
            ),
            const SizedBox(height: 20),
            TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.purple)),
                labelText: 'Enter Amount',
                labelStyle: TextStyle(color: Colors.white),
                enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.purple)),
              ),
              style: TextStyle(color: Colors.white),
              controller: txtAmount,
            ),
            const SizedBox(height: 10),
            PrimaryButton(
              title: "Pay",
              onPressed: () {
                Map<String, dynamic> data = widget.groupData;
                data["amountLeft"] =
                    (int.parse(data["amountLeft"]) - int.parse(txtAmount.text))
                        .toString();
                data[FirebaseAuth.instance.currentUser!.uid] = (int.parse(
                            data[FirebaseAuth.instance.currentUser!.uid] ??
                                '0') +
                        int.parse(txtAmount.text))
                    .toString();
                FirebaseFirestore.instance
                    .collection("groups")
                    .doc(widget.groupData["code"])
                    .update(data);
                Navigator.of(context).pop();
              },
            ),
            const SizedBox(height: 20),
            PrimaryButton(
              title: "Get Recommendations",
              onPressed: geminiRequest,
            ),
            if (geminiData.isNotEmpty)
              Card(
                color: Colors.grey[800],
                margin: const EdgeInsets.all(10),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SingleChildScrollView(
                    child: Text(
                      geminiData,
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
