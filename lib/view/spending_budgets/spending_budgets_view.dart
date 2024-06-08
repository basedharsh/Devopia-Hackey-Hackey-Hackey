import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:trackizer/common/color_extension.dart';
import 'package:trackizer/common_widget/budgets_row.dart';
import 'package:trackizer/common_widget/custom_arc_180_painter.dart';
import '../settings/settings_view.dart';

import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:trackizer/common/color_extension.dart';
import 'package:trackizer/common_widget/budgets_row.dart';
import 'package:trackizer/common_widget/custom_arc_180_painter.dart';

class SpendingBudgetsView extends StatefulWidget {
  const SpendingBudgetsView({Key? key}) : super(key: key);

  @override
  State<SpendingBudgetsView> createState() => _SpendingBudgetsViewState();
}

class _SpendingBudgetsViewState extends State<SpendingBudgetsView> {
  List<Map<String, dynamic>> budgetArr = [
    {
      "name": "Stock1",
      "icon": "assets/img/auto_&_transport.png",
      "color": Colors.red,
    },
    {
      "name": "Stock2",
      "icon": "assets/img/entertainment.png",
      "color": TColor.secondary50,
    },
    {
      "name": "Stock3",
      "icon": "assets/img/security.png",
      "color": TColor.primary10,
    },
    {
      "name": "Stock4",
      "icon": "assets/img/auto_&_transport.png",
      "color": TColor.secondaryG,
    },
    {
      "name": "Stock5",
      "icon": "assets/img/auto_&_transport.png",
      "color": TColor.secondaryG,
    },
  ];

  Timer? timer;
  Random random = Random();

  @override
  void initState() {
    super.initState();
    allocateBudget(); // Allocate budget when the widget initializes
    startSimulation(); // Start simulation to update budget dynamically
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  void startSimulation() {
    timer = Timer.periodic(Duration(seconds: 1), (Timer t) {
      setState(() {
        updateBudget();
      });
    });
  }

  void allocateBudget() {
    final int totalBudget = 50000;
    int remainingBudget = totalBudget;
    for (var budgetItem in budgetArr) {
      int maxAllocation = (remainingBudget * 0.2).toInt();
      int allocatedAmount = random.nextInt(maxAllocation) + 1;
      remainingBudget -= allocatedAmount;
      budgetItem['total_budget'] = allocatedAmount;
      budgetItem['spend_amount'] = (allocatedAmount * 0.75).toInt();
      budgetItem['left_amount'] = (allocatedAmount * 0.25).toInt();
    }
  }

  void updateBudget() {
    for (var budgetItem in budgetArr) {
      int spendAmount = budgetItem['spend_amount'];
      double changePercentage = random.nextDouble() * 0.1 - 0.05;
      spendAmount += (spendAmount * changePercentage).toInt();
      spendAmount = spendAmount < 0 ? 0 : spendAmount;

      budgetItem['spend_amount'] = spendAmount;
      budgetItem['left_amount'] = budgetItem['total_budget'] - spendAmount;
    }
  }

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;

    // Calculate total spent and total budget
    double totalSpent =
        budgetArr.fold(0, (sum, item) => sum + item['spend_amount']);
    double totalBudget =
        budgetArr.fold(0, (sum, item) => sum + item['total_budget']);
    double spentPercentage = (totalSpent / totalBudget) * 100;

    return Scaffold(
      backgroundColor: TColor.gray,
      resizeToAvoidBottomInset:
          true, // Ensure layout resizes to avoid bottom inset
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 35, right: 10),
            child: Row(
              children: [
                Spacer(),
                IconButton(
                  onPressed: () {},
                  icon: Image.asset(
                    "assets/img/settings.png",
                    width: 25,
                    height: 25,
                    color: TColor.gray30,
                  ),
                )
              ],
            ),
          ),
          Stack(
            alignment: Alignment.bottomCenter,
            children: [
              Container(
                width: media.width * 0.5,
                height: media.width * 0.30,
                child: CustomPaint(
                  painter: CustomArc180Painter(
                    drwArcs: budgetArr.map((budget) {
                      // Extract color and percentage from each budget item
                      Color color = budget['color'];
                      double percentage =
                          budget['spend_amount'] / budget['total_budget'] * 100;

                      // Create ArcValueModel with the extracted color and percentage
                      return ArcValueModel(color: color, value: percentage);
                    }).toList(),
                    end: 50,
                    width: 12,
                    bgWidth: 8,
                  ),
                ),
              ),
              Column(
                children: [
                  Text(
                    "\₹${totalSpent.toStringAsFixed(2)}",
                    style: TextStyle(
                      color: TColor.white,
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    "of \₹${totalBudget.toStringAsFixed(2)} budget",
                    style: TextStyle(
                      color: TColor.gray30,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              )
            ],
          ),
          const SizedBox(
            height: 40,
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              itemCount: budgetArr.length,
              itemBuilder: (context, index) {
                var bObj = budgetArr[index];

                return BudgetsRow(
                  bObj: bObj,
                  onPressed: () {},
                );
              },
            ),
          ),
          //Add new category
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
            child: InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: () {},
              child: DottedBorder(
                dashPattern: const [5, 4],
                strokeWidth: 1,
                borderType: BorderType.RRect,
                radius: const Radius.circular(16),
                color: TColor.border.withOpacity(0.1),
                child: Container(
                  height: 64,
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  alignment: Alignment.center,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Add new category ",
                        style: TextStyle(
                          color: TColor.gray30,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Image.asset(
                        "assets/img/add.png",
                        width: 12,
                        height: 12,
                        color: TColor.gray30,
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 110,
          ),
        ],
      ),
    );
  }
}

class AddCategoryBottomSheet extends StatefulWidget {
  final Function(Map<String, dynamic>) onAddCategory;

  const AddCategoryBottomSheet({Key? key, required this.onAddCategory})
      : super(key: key);

  @override
  State<AddCategoryBottomSheet> createState() => _AddCategoryBottomSheetState();
}

class _AddCategoryBottomSheetState extends State<AddCategoryBottomSheet> {
  // Controllers for text fields
  final TextEditingController nameController = TextEditingController();

  final TextEditingController spendAmountController = TextEditingController();

  final TextEditingController totalBudgetController = TextEditingController();

  final TextEditingController leftAmountController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Add New Category',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 20),
          TextField(
            controller: nameController,
            decoration: InputDecoration(labelText: 'Name'),
          ),
          TextField(
            controller: spendAmountController,
            decoration: InputDecoration(labelText: 'Spend Amount'),
          ),
          TextField(
            controller: totalBudgetController,
            decoration: InputDecoration(labelText: 'Total Budget'),
          ),
          TextField(
            controller: leftAmountController,
            decoration: InputDecoration(labelText: 'Left Amount'),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () async {
              Map<String, dynamic> newCategory = {
                'name': nameController.text,
                'spend_amount': spendAmountController.text,
                'total_budget': totalBudgetController.text,
                'left_amount': leftAmountController.text,
                'color': TColor.primary10
                    .toString(), // Store color as string or suitable format
                'icon':
                    "assets/img/security.png", // Default icon or based on category type
              };

              // Add the new category to Firestore under the current user's document
              var user = FirebaseAuth.instance.currentUser;
              if (user != null) {
                await FirebaseFirestore.instance
                    .collection('users')
                    .doc(user.uid)
                    .collection('categories')
                    .add(newCategory);
              }

              widget.onAddCategory(newCategory);
              Navigator.pop(context); // Close the bottom sheet modal
            },
            child: Text('Add Category'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    // Dispose of controllers when the widget is disposed
    nameController.dispose();
    spendAmountController.dispose();
    totalBudgetController.dispose();
    leftAmountController.dispose();
    super.dispose();
  }
}
