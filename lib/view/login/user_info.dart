import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trackizer/backend/auth/login.dart';
import 'package:trackizer/view/login/sign_up_view.dart';
import 'package:trackizer/view/main_tab/main_tab_view.dart';

import '../../common/color_extension.dart';
import '../../common_widget/primary_button.dart';
import '../../common_widget/round_textfield.dart';
import '../../common_widget/secondary_boutton.dart';

class UserInfoPage extends StatefulWidget {
  const UserInfoPage({super.key});

  @override
  State<UserInfoPage> createState() => _UserInfoPageState();
}

class _UserInfoPageState extends State<UserInfoPage> {
  TextEditingController txtName = TextEditingController();
  TextEditingController txtAge = TextEditingController();
  TextEditingController txtJob = TextEditingController();
  TextEditingController txtMoi = TextEditingController();
  TextEditingController txtPan = TextEditingController();
  TextEditingController txtPrei = TextEditingController();
  bool isRemember = false;

  @override
  Widget build(BuildContext context) {
    LoginAuthorization loginAuth = Provider.of<LoginAuthorization>(context);
    var media = MediaQuery.sizeOf(context);
    return Scaffold(
      backgroundColor: TColor.gray,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Image.asset("assets/img/app_logo.png",
              //     width: media.width * 0.5, fit: BoxFit.contain),
              const Spacer(),
              RoundTextField(
                title: "Name",
                controller: txtName,
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(
                height: 15,
              ),
              RoundTextField(
                title: "Age",
                controller: txtAge,
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(
                height: 15,
              ),
              RoundTextField(
                title: "Occupation",
                controller: txtJob,
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(
                height: 15,
              ),
              RoundTextField(
                title: "Monthly Income",
                controller: txtMoi,
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(
                height: 15,
              ),
              RoundTextField(
                title: "PAN Card",
                controller: txtPan,
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(
                height: 15,
              ),
              RoundTextField(
                title: "Preffered Instructions",
                controller: txtPrei,
                obscureText: true,
              ),

              const SizedBox(
                height: 50,
              ),

              PrimaryButton(
                title: "Get Started",
                onPressed: () {
                  FirebaseFirestore.instance
                      .collection("users")
                      .doc(FirebaseAuth.instance.currentUser!.uid)
                      .update(
                    {
                      "name": txtName.text,
                      "age": txtAge.text,
                      "job": txtJob.text,
                      "monthlyIncome": txtMoi.text,
                      "pan": txtPan.text,
                      "preferredInstructions": txtPrei.text,
                    },
                  ).then((value) {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const MainTabView(),
                      ),
                    );
                  });
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
