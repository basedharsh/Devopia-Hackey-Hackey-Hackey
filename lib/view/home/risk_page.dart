import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RiskPage extends StatefulWidget {
  @override
  _RiskPageState createState() => _RiskPageState();
}

class _RiskPageState extends State<RiskPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Set the background color to black
      appBar: AppBar(
        title: Text('Investment Details'),
        backgroundColor:
            Colors.black, // Match the app bar color with the background
        elevation: 0,
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance
            .collection("users")
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasData && snapshot.data!.data() != null) {
            return SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: buildInvestmentTable(snapshot.data!),
              ),
            );
          } else if (snapshot.hasError) {
            return Center(
                child: Text("Error: ${snapshot.error}",
                    style: TextStyle(color: Colors.white)));
          } else {
            return Center(
                child: Text("No data available",
                    style: TextStyle(color: Colors.white)));
          }
        },
      ),
    );
  }

  Widget buildInvestmentTable(DocumentSnapshot data) {
    Map<String, dynamic> investmentData = data.data() as Map<String, dynamic>;
    return Card(
      color: Colors.grey[900], // Dark card for investment data
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10), // Rounded corners
        side: BorderSide(color: Colors.purple, width: 2), // Purple border
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: DataTable(
          headingTextStyle: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold), // Styling the header
          dataTextStyle: TextStyle(color: Colors.white70), // Styling the data
          columns: const [
            DataColumn(label: Text('Investment Type')),
            DataColumn(label: Text('Amount')),
            DataColumn(label: Text('Percentage')),
            DataColumn(label: Text('Risk')),
          ],
          rows: [
            DataRow(cells: [
              DataCell(Text('Mutual Fund')),
              DataCell(Text(investmentData['MutualFund'] ?? '0')),
              DataCell(Text('${investmentData['mutualFundPercentage']}%')),
              DataCell(Text('N/A')), // Modify as needed
            ]),
            DataRow(cells: [
              DataCell(Text('Fixed Deposit')),
              DataCell(Text(investmentData['FixedDeposit'] ?? '0')),
              DataCell(Text('${investmentData['fixedDepositPercentage']}%')),
              DataCell(Text('N/A')), // Modify as needed
            ]),
            DataRow(cells: [
              DataCell(Text('Crypto')),
              DataCell(Text(investmentData['Crypto'] ?? '0')),
              DataCell(Text('${investmentData['cryptoPercentage']}%')),
              DataCell(Text('N/A')), // Modify as needed
            ]),
            DataRow(cells: [
              DataCell(Text('Stocks')),
              DataCell(Text(investmentData['Stocks'] ?? '0')),
              DataCell(Text('${investmentData['stocksPercentage']}%')),
              DataCell(Text('N/A')), // Modify as needed
            ]),
            DataRow(cells: [
              DataCell(Text('Bonds')),
              DataCell(Text(investmentData['Bonds'] ?? '0')),
              DataCell(Text('${investmentData['bondsPercentage']}%')),
              DataCell(Text('N/A')), // Modify as needed
            ]),
          ],
        ),
      ),
    );
  }
}
