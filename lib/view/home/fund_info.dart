import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:trackizer/common/color_extension.dart';
import 'package:trackizer/common_widget/primary_button.dart';
import 'package:trackizer/common_widget/round_textfield.dart';

class FundInfoPage extends StatefulWidget {
  const FundInfoPage({Key? key}) : super(key: key);

  @override
  State<FundInfoPage> createState() => _FundInfoPageState();
}

class _FundInfoPageState extends State<FundInfoPage> {
  TextEditingController budget = TextEditingController();
  TextEditingController maxLossEndured = TextEditingController();
  TextEditingController age = TextEditingController();
  TextEditingController bucket = TextEditingController();
  TextEditingController ratioLow = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TColor.gray,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              RoundTextField(
                title: "Budget",
                controller: budget,
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 15),
              RoundTextField(
                title: "Max Loss Endured",
                controller: maxLossEndured,
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 15),
              RoundTextField(
                title: "Age",
                controller: age,
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 15),
              RoundTextField(
                title: "Bucket",
                controller: bucket,
              ),
              const SizedBox(height: 15),
              RoundTextField(
                title: "Ratio Low",
                controller: ratioLow,
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 15),
              PrimaryButton(
                title: "Get Started",
                onPressed: () async {
                  // String url = "http://127.0.0.1:5000/create_portfolio";
                  String url = "http://10.0.2.2:5000/create_portfolio";
                  var data = [
                    {
                      'emp': 1,
                      'budget': int.parse(budget.text),
                      'max_loss_endured': int.parse(maxLossEndured.text),
                      'age': int.parse(age.text),
                      'bucket': bucket.text,
                      'ratio_low': double.parse(ratioLow.text)
                    }
                  ];

                  final response = await http.post(
                    Uri.parse(url),
                    headers: {"Content-Type": "application/json"},
                    body: jsonEncode({"employees": data}),
                  );

                  if (response.statusCode == 200) {
                    var jsonResponse = jsonDecode(response.body);
                    print(jsonResponse);
                  } else {
                    print('Failed to get data from server');
                  }
                },
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
