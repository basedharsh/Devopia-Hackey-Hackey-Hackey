import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:trackizer/common/color_extension.dart';
import 'package:trackizer/view/group/group_add.dart';
import 'package:trackizer/view/group/group_details.dart';

class GroupsDisplayPage extends StatefulWidget {
  const GroupsDisplayPage({super.key});

  @override
  State<GroupsDisplayPage> createState() => _GroupsDisplayPageState();
}

class _GroupsDisplayPageState extends State<GroupsDisplayPage> {
  Map<String, dynamic>? userData;
  List<Map<String, dynamic>?> groupsData = [];

  @override
  void initState() {
    super.initState();
    FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((value) {
      setState(() {
        userData = value.data();
      });
      for (String groupId in userData!["groups"]) {
        FirebaseFirestore.instance
            .collection("groups")
            .doc(groupId)
            .get()
            .then((value) {
          setState(() {
            groupsData.add(value.data());
          });
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Saving'),
        backgroundColor: TColor.gray,
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const GroupAddPage()),
              );
            },
          ),
        ],
      ),
      body: Scaffold(
        backgroundColor: TColor.gray,
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 20),
              Text(
                "My Savings",
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge
                    ?.copyWith(color: Colors.white),
              ),
              SizedBox(height: 20),
              Card(
                color: Colors.black,
                margin: const EdgeInsets.all(8),
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                  side: BorderSide(color: Colors.purple, width: 2),
                ),
                child: ListTile(
                  onTap: () {
                    // Navigator.of(context).push(
                    //   MaterialPageRoute(
                    //     builder: (context) =>
                    //         GroupDetailsPage(groupData: group),
                    //   ),
                    // );
                  },
                  title: Text(
                    "House",
                    style: TextStyle(color: Colors.white),
                  ),
                  subtitle: Text(
                    "1000000",
                    style: TextStyle(color: Colors.grey[500]),
                  ),
                  trailing: Icon(Icons.arrow_forward_ios, color: Colors.white),
                ),
              ),
              SizedBox(height: 20),
              Text(
                "Group Savings",
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge
                    ?.copyWith(color: Colors.white),
              ),
              ListView.builder(
                shrinkWrap: true,
                itemCount: groupsData.length,
                itemBuilder: (context, index) {
                  var group = groupsData[index];
                  if (group == null ||
                      !(group is Map) ||
                      group["name"] == null ||
                      group["amount"] == null) {
                    // Return a placeholder or an error widget if the group is null or improperly structured
                    return SizedBox
                        .shrink(); // This can be changed to show an error message or a placeholder
                  }

                  return Card(
                    color: Colors.black,
                    margin: const EdgeInsets.all(8),
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                      side: BorderSide(color: Colors.purple, width: 2),
                    ),
                    child: ListTile(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) =>
                                GroupDetailsPage(groupData: group),
                          ),
                        );
                      },
                      title: Text(
                        group[
                            "name"], // Assuming null checks or defaults are handled already
                        style: TextStyle(color: Colors.white),
                      ),
                      subtitle: Text(
                        group["amount"]
                            .toString(), // Using toString() for safety
                        style: TextStyle(color: Colors.grey[500]),
                      ),
                      trailing:
                          Icon(Icons.arrow_forward_ios, color: Colors.white),
                    ),
                  );
                },
              ),
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (context) => const GroupAddPage()),
                  );
                },
                icon: Icon(Icons.group_add, color: Colors.white),
                label: Text("Create/Join Group"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey[850],
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
