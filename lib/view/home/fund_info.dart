import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trackizer/backend/auth/login.dart';
import 'package:trackizer/view/home/main_home.dart';
import 'package:trackizer/view/login/sign_up_view.dart';
import 'package:trackizer/view/main_tab/main_tab_view.dart';

import '../../common/color_extension.dart';
import '../../common_widget/primary_button.dart';
import '../../common_widget/round_textfield.dart';
import '../../common_widget/secondary_boutton.dart';

class FundInfoPage extends StatefulWidget {
  const FundInfoPage({Key? key}) : super(key: key);

  @override
  State<FundInfoPage> createState() => _FundInfoPageState();
}

class _FundInfoPageState extends State<FundInfoPage> {
  TextEditingController mutualFund = TextEditingController();
  TextEditingController fixedDeposit = TextEditingController();
  TextEditingController crypto = TextEditingController();
  TextEditingController stocks = TextEditingController();
  TextEditingController bonds = TextEditingController();

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
                title: "Mutual Fund",
                controller: mutualFund,
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 15),
              RoundTextField(
                title: "Fixed Deposit",
                controller: fixedDeposit,
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 15),
              RoundTextField(
                title: "Crypto",
                controller: crypto,
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 15),
              RoundTextField(
                title: "Stocks",
                controller: stocks,
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 15),
              RoundTextField(
                title: "Bonds",
                controller: bonds,
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 15),
              PrimaryButton(
                title: "Get Started",
                onPressed: () {
                  double mutualFundAmount = double.parse(mutualFund.text);
                  double fixedDepositAmount = double.parse(fixedDeposit.text);
                  double cryptoAmount = double.parse(crypto.text);
                  double stocksAmount = double.parse(stocks.text);
                  double bondsAmount = double.parse(bonds.text);

                  double totalInvestment = mutualFundAmount +
                      fixedDepositAmount +
                      cryptoAmount +
                      stocksAmount +
                      bondsAmount;

                  double mutualFundPercentage =
                      (mutualFundAmount / totalInvestment) * 100;
                  double fixedDepositPercentage =
                      (fixedDepositAmount / totalInvestment) * 100;
                  double cryptoPercentage =
                      (cryptoAmount / totalInvestment) * 100;
                  double stocksPercentage =
                      (stocksAmount / totalInvestment) * 100;
                  double bondsPercentage =
                      (bondsAmount / totalInvestment) * 100;

                  String finalRisk;
                  bool highRisk = (stocksPercentage + cryptoPercentage) > 33;
                  bool lowRisk =
                      (bondsPercentage + fixedDepositPercentage) > 33;
                  bool mediumRisk = mutualFundPercentage > 33;

                  if (highRisk) {
                    finalRisk = "High";
                  } else if (mediumRisk) {
                    finalRisk = "Medium";
                  } else if (lowRisk) {
                    finalRisk = "Low";
                  } else {
                    finalRisk =
                        "Undefined"; // In case none of the conditions are met
                  }

                  FirebaseFirestore.instance
                      .collection("users")
                      .doc(FirebaseAuth.instance.currentUser!.uid)
                      .update({
                    "MutualFund": mutualFund.text,
                    "FixedDeposit": fixedDeposit.text,
                    "Crypto": crypto.text,
                    "Stocks": stocks.text,
                    "Bonds": bonds.text,
                    "totalInvestment": totalInvestment.toString(),
                    "mutualFundPercentage": mutualFundPercentage.toString(),
                    "fixedDepositPercentage": fixedDepositPercentage.toString(),
                    "cryptoPercentage": cryptoPercentage.toString(),
                    "stocksPercentage": stocksPercentage.toString(),
                    "bondsPercentage": bondsPercentage.toString(),
                    "Current Risk": finalRisk,
                  }).then((value) {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => MainHome(),
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
