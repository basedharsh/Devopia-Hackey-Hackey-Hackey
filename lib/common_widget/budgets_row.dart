import 'package:flutter/material.dart';
import '../common/color_extension.dart';

class BudgetsRow extends StatelessWidget {
  final Map bObj;
  final VoidCallback onPressed;

  const BudgetsRow({Key? key, required this.bObj, required this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var iconPath = bObj["icon"] ??
        "assets/img/entertainment.png"; // Provide default icon path if null

    // Ensure denominator is not zero or null
    var totalBudget = double.tryParse(bObj["total_budget"] ?? "1") ?? 1;
    var proVal =
        (double.tryParse(bObj["left_amount"] ?? "0") ?? 0) / totalBudget;

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onPressed,
        child: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            border: Border.all(
              color: TColor.border.withOpacity(0.05),
            ),
            color: TColor.gray60.withOpacity(0.1),
            borderRadius: BorderRadius.circular(16),
          ),
          alignment: Alignment.center,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Image.asset(
                      iconPath, // Use iconPath instead of bObj["icon"]
                      width: 30,
                      height: 30,
                      color: TColor.gray40,
                    ),
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          bObj["name"] ?? "", // Ensure name is not null
                          style: TextStyle(
                              color: TColor.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w600),
                        ),
                        Text(
                          "\₹${bObj["left_amount"] ?? "0"} left to spend", // Ensure left_amount is not null
                          style: TextStyle(
                              color: TColor.gray30,
                              fontSize: 12,
                              fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "\₹${bObj["spend_amount"] ?? "0"}",
                        style: TextStyle(
                            color: TColor.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w600),
                      ),
                      Text(
                        "of \₹${bObj["total_budget"] ?? "0"}",
                        style: TextStyle(
                            color: TColor.gray30,
                            fontSize: 12,
                            fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(
                height: 8,
              ),
              LinearProgressIndicator(
                backgroundColor: TColor.gray60,
                valueColor: AlwaysStoppedAnimation(bObj["color"]),
                minHeight: 3,
                value: proVal.isFinite ? proVal : 0, // Check for finite value
              )
            ],
          ),
        ),
      ),
    );
  }
}
