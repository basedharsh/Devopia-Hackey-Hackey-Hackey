import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:uuid/uuid.dart';
import 'package:trackizer/backend/settings/settings.dart'; // Verify the path is correct

class GroupAddPage extends StatefulWidget {
  const GroupAddPage({super.key});

  @override
  State<GroupAddPage> createState() => _GroupAddPageState();
}

class _GroupAddPageState extends State<GroupAddPage> {
  TextEditingController txtCode = TextEditingController();
  TextEditingController txtName = TextEditingController();
  TextEditingController txtReason = TextEditingController();
  TextEditingController txtAmount = TextEditingController();
  var uuid = Uuid();

  @override
  Widget build(BuildContext context) {
    UserSettings userSettings = Provider.of<UserSettings>(context);
    Color secondaryColor = Color(0xffFF7966); // Custom secondary color
    Color primaryColor = Colors.purple;

    return Scaffold(
      appBar: AppBar(
        title: Text("Add Group"),
        backgroundColor: Colors.black,
        elevation: 0,
      ),
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Card(
                color: Colors.grey[900], // Dark card background
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    children: [
                      TextField(
                        controller: txtName,
                        style: TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10)),
                          labelText: 'Group Name',
                          labelStyle: TextStyle(color: Colors.white),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: primaryColor),
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      TextField(
                        controller: txtReason,
                        style: TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10)),
                          labelText: 'Reason',
                          labelStyle: TextStyle(color: Colors.white),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: primaryColor),
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      TextField(
                        controller: txtAmount,
                        style: TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10)),
                          labelText: 'Amount',
                          labelStyle: TextStyle(color: Colors.white),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: primaryColor),
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: userSettings.loading ||
                                userSettings.userData == null
                            ? null
                            : () async {
                                String groupId = uuid.v4();
                                String uid =
                                    FirebaseAuth.instance.currentUser!.uid;
                                String? userName =
                                    userSettings.userData?['userName'];

                                List<String> members = userName != null
                                    ? [userName]
                                    : ['Unknown User'];

                                await FirebaseFirestore.instance
                                    .collection("groups")
                                    .doc(groupId)
                                    .set({
                                  "name": txtName.text,
                                  "reason": txtReason.text,
                                  "amount": txtAmount.text,
                                  "amountLeft": txtAmount.text,
                                  "code": groupId,
                                  "members": members,
                                  uid: 0,
                                  "createdBy": uid,
                                  "createdByName": userName ?? 'Unknown',
                                });

                                await FirebaseFirestore.instance
                                    .collection("users")
                                    .doc(uid)
                                    .update({
                                  "groups": FieldValue.arrayUnion([groupId]),
                                });

                                Share.share(
                                    'Group Created!!!\nName: ${txtName.text}\nReason for saving: ${txtReason.text}\nAmount to be saved: ${txtAmount.text}\nCode to Join: $groupId');
                              },
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: secondaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Text("Create Group"),
                      ),
                      SizedBox(height: 20),
                      Text("OR",
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white)),
                      SizedBox(height: 20),
                      Text("Enter the code to join a group",
                          style: TextStyle(fontSize: 14, color: Colors.white)),
                      SizedBox(height: 10),
                      TextField(
                        controller: txtCode,
                        style: TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10)),
                          labelText: 'Code',
                          labelStyle: TextStyle(color: Colors.white),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: primaryColor),
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () async {
                          await FirebaseFirestore.instance
                              .collection("groups")
                              .doc(txtCode.text)
                              .update({
                            "members": FieldValue.arrayUnion(
                                [FirebaseAuth.instance.currentUser!.uid]),
                            FirebaseAuth.instance.currentUser!.uid: 0,
                          });
                          await FirebaseFirestore.instance
                              .collection("users")
                              .doc(FirebaseAuth.instance.currentUser!.uid)
                              .update({
                            "groups": FieldValue.arrayUnion([txtCode.text]),
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: secondaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Text("Join"),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
