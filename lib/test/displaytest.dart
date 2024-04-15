import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:trackizer/backend/settings/settings.dart';
import 'package:trackizer/common/color_extension.dart';

class displayTest extends StatelessWidget {
  const displayTest({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Information'),
        centerTitle: true,
        backgroundColor: TColor.gray,
      ),
      body: Consumer<UserSettings>(
        builder: (context, userSettings, _) {
          if (userSettings.loading) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            final userData = userSettings.userData;
            return ListView(
              padding: EdgeInsets.all(16),
              children: [
                UserInfoItem(label: 'Name', value: userData?['name'] ?? ''),
                UserInfoItem(label: 'Age', value: userData?['age'] ?? ''),
                UserInfoItem(label: 'Job', value: userData?['job'] ?? ''),
                UserInfoItem(
                  label: 'Monthly Income',
                  value: userData?['monthlyIncome'] ?? '',
                ),
                UserInfoItem(label: 'PAN', value: userData?['pan'] ?? ''),
                UserInfoItem(
                  label: 'Preferred Instructions',
                  value: userData?['preferredInstructions'] ?? '',
                ),
              ],
            );
          }
        },
      ),
    );
  }
}

class UserInfoItem extends StatelessWidget {
  final String label;
  final String value;

  const UserInfoItem({
    Key? key,
    required this.label,
    required this.value,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Text(
              label,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(value),
          ),
        ],
      ),
    );
  }
}
