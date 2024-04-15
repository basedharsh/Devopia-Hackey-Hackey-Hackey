import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:trackizer/common/color_extension.dart';
import 'package:trackizer/view/home/fund_info.dart';
import 'package:trackizer/view/home/risk_page.dart';
import 'package:trackizer/view/settings/settings_view.dart';

class MainHome extends StatefulWidget {
  @override
  State<MainHome> createState() => _MainHomeState();
}

class _MainHomeState extends State<MainHome> {
  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: TColor.gray,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(vertical: 40),
              decoration: BoxDecoration(
                color: TColor.gray70.withOpacity(0.5),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(25),
                  bottomRight: Radius.circular(25),
                ),
              ),
              child: SafeArea(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: Icon(Icons.arrow_back, color: TColor.gray30),
                    ),
                    Text(
                      'Dashboard',
                      style: TextStyle(color: TColor.gray30, fontSize: 26),
                    ),
                    IconButton(
                      onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const SettingsView())),
                      icon: Icon(Icons.settings, color: TColor.gray30),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Card(
                color: TColor.gray70.withOpacity(0.5),
                elevation: 5,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: FutureBuilder<DocumentSnapshot>(
                    future: FirebaseFirestore.instance
                        .collection("users")
                        .doc(FirebaseAuth.instance.currentUser!.uid)
                        .get(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasData && snapshot.data!.exists) {
                        Map<String, dynamic> data =
                            snapshot.data!.data() as Map<String, dynamic>;
                        return Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            _buildExpansionTile(
                                'Current Risk', Colors.green, data, () {
                              Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => RiskPage(),
                              ));
                              print('Risk Score: ${data['riskScore']}');
                            }),
                            SizedBox(height: 10),
                            Container(
                              height: media.width *
                                  0.6, // Adjust height to fit both chart and list
                              child: _buildPieChartWithDetails(data),
                            ),
                            SizedBox(height: 10),
                            _buildExpansionTile(
                                'MutualFund', Colors.green, data, () {
                              print('MutualFund: ${data['MutualFund']}');
                            }),
                            SizedBox(height: 10),
                            _buildExpansionTile(
                                'FixedDeposit', Colors.purple, data, () {}),
                            SizedBox(height: 10),
                            _buildExpansionTile(
                                'Crypto', Colors.orange, data, () {}),
                            SizedBox(height: 10),
                            _buildExpansionTile(
                                'Stocks', Colors.yellow, data, () {}),
                            _buildExpansionTile(
                                'Bonds', Colors.cyanAccent, data, () {}),
                            SizedBox(height: 10), // Add some space
                            ElevatedButton(
                              onPressed: () {
                                // Add your button's onPressed logic here
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) =>
                                        const FundInfoPage()));
                              },
                              child: Text('Add Invetements',
                                  style: TextStyle(color: Colors.black)),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors
                                    .yellow, // Set button background color to yellow
                              ),
                            ),
                            SizedBox(height: 40),
                          ],
                        );
                      } else {
                        return Text("No data available");
                      }
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExpansionTile(String title, Color color,
      Map<String, dynamic> data, VoidCallback onTap) {
    var itemContent = data[title] ?? 'N/A';
    return Container(
      width: double.infinity,
      height: 60,
      child: ElevatedButton(
        onPressed: onTap, // Use the onTap callback here
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title, style: TextStyle(color: TColor.white)),
            Text(itemContent.toString(), style: TextStyle(color: TColor.white)),
          ],
        ),
        style: ElevatedButton.styleFrom(
          foregroundColor: color,
          backgroundColor: Colors.black,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
            side: BorderSide(color: color),
          ),
        ),
      ),
    );
  }

  Widget _buildPieChartWithDetails(Map<String, dynamic> data) {
    List<PieChartSectionData> sections = [
      PieChartSectionData(
        color: Colors.green,
        value: double.tryParse(data['mutualFundPercentage'] ?? '0') ?? 0,
        title: 'MF',
        showTitle: true,
        titleStyle: TextStyle(color: Colors.white, fontSize: 16),
      ),
      PieChartSectionData(
        color: Colors.purple,
        value: double.tryParse(data['fixedDepositPercentage'] ?? '0') ?? 0,
        title: 'FD',
        showTitle: true,
        titleStyle: TextStyle(color: Colors.white, fontSize: 16),
      ),
      PieChartSectionData(
        color: Colors.orange,
        value: double.tryParse(data['cryptoPercentage'] ?? '0') ?? 0,
        title: 'Crypto',
        showTitle: true,
        titleStyle: TextStyle(color: Colors.white, fontSize: 16),
      ),
      PieChartSectionData(
        color: Colors.yellow,
        value: double.tryParse(data['stocksPercentage'] ?? '0') ?? 0,
        title: 'Stocks',
        showTitle: true,
        titleStyle: TextStyle(color: Colors.white, fontSize: 16),
      ),
      PieChartSectionData(
        color: Colors.cyanAccent,
        value: double.tryParse(data['bondsPercentage'] ?? '0') ?? 0,
        title: 'Bonds',
        showTitle: true,
        titleStyle: TextStyle(color: Colors.white, fontSize: 16),

        // Add other properties if needed
      ),

      // Add other sections similarly...
    ];

    return SingleChildScrollView(
      child: Column(
        children: [
          PieChart(
            PieChartData(
              sections: sections,
              sectionsSpace: 0,
              centerSpaceRadius: 40,
            ),
          ),
          Column(
            children: sections
                .map((section) => ListTile(
                      leading: Icon(Icons.circle, color: section.color),
                      title: Text(
                          "${section.title}: ${section.value.toStringAsFixed(2)}%",
                          style: TextStyle(color: Colors.white)),
                    ))
                .toList(),
          ),
        ],
      ),
    );
  }
}
