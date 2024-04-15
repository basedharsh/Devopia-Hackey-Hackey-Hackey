import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:trackizer/common/color_extension.dart';
import 'package:trackizer/common_widget/budgets_row.dart';
import 'package:trackizer/common_widget/custom_arc_180_painter.dart';

import '../settings/settings_view.dart';

class SpendingBudgetsView extends StatefulWidget {
  const SpendingBudgetsView({super.key});

  @override
  State<SpendingBudgetsView> createState() => _SpendingBudgetsViewState();
}

class _SpendingBudgetsViewState extends State<SpendingBudgetsView> {
  List budgetArr = [
    {
      "name": "Auto & Transport",
      "icon": "assets/img/auto_&_transport.png",
      "spend_amount": "25.99",
      "total_budget": "400",
      "left_amount": "250.01",
      "color": TColor.secondaryG
    },
    {
      "name": "Entertainment",
      "icon": "assets/img/entertainment.png",
      "spend_amount": "50.99",
      "total_budget": "600",
      "left_amount": "300.01",
      "color": TColor.secondary50
    },
    {
      "name": "Security",
      "icon": "assets/img/security.png",
      "spend_amount": "5.99",
      "total_budget": "600",
      "left_amount": "250.01",
      "color": TColor.primary10
    },
  ];

  @override
  void addCategory(Map<String, dynamic> category) {
    // Set default values if the properties are not provided
    category['color'] ??= TColor.primary10;
    category['icon'] ??= "assets/img/security.png";

    setState(() {
      budgetArr.add(category);
    });
  }

  Widget build(BuildContext context) {
    var media = MediaQuery.sizeOf(context);
    final Function(Map<String, dynamic>) onAddCategory;
    return Scaffold(
      backgroundColor: TColor.gray,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 35, right: 10),
              child: Row(
                children: [
                  Spacer(),
                  IconButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const SettingsView()));
                      },
                      icon: Image.asset("assets/img/settings.png",
                          width: 25, height: 25, color: TColor.gray30))
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
                      drwArcs: [
                        ArcValueModel(color: TColor.secondaryG, value: 20),
                        ArcValueModel(color: TColor.secondary, value: 45),
                        ArcValueModel(color: TColor.primary10, value: 70),
                      ],
                      end: 50,
                      width: 12,
                      bgWidth: 8,
                    ),
                  ),
                ),
                Column(
                  children: [
                    Text(
                      "\₹82,90",
                      style: TextStyle(
                          color: TColor.white,
                          fontSize: 24,
                          fontWeight: FontWeight.w700),
                    ),
                    Text(
                      "of \₹2,0000 budget",
                      style: TextStyle(
                          color: TColor.gray30,
                          fontSize: 12,
                          fontWeight: FontWeight.w500),
                    ),
                  ],
                )
              ],
            ),
            const SizedBox(
              height: 40,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: InkWell(
                borderRadius: BorderRadius.circular(16),
                onTap: () {},
                child: Container(
                  height: 64,
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: TColor.border.withOpacity(0.1),
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  alignment: Alignment.center,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Your budgets are on tack 👍",
                        style: TextStyle(
                            color: TColor.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            ListView.builder(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: budgetArr.length,
                itemBuilder: (context, index) {
                  var bObj = budgetArr[index] as Map? ?? {};

                  return BudgetsRow(
                    bObj: bObj,
                    onPressed: () {},
                  );
                }),
            //Add new category
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
              child: InkWell(
                borderRadius: BorderRadius.circular(16),
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    builder: (BuildContext context) {
                      return AddCategoryBottomSheet(onAddCategory: (category) {
                        // Add the new category to the list
                        setState(() {
                          budgetArr.add(category);
                        });
                        Navigator.pop(context); // Close the bottom sheet modal
                      });
                    },
                  );
                },
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
                              fontWeight: FontWeight.w600),
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
