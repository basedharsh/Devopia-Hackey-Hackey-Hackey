// ignore_for_file: use_build_context_synchronously, file_names
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:trackizer/view/home/home_view.dart';

class UserSettings with ChangeNotifier {
  Map<String, dynamic>? userData;
  bool loading = false;
  UserSettings() {
    loading = true;
    getUserData();
  }

  void getUserData() async {
    await FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((value) {
      print(value.data());
      userData = value.data();
      loading = false;
      notifyListeners();
    });
  }
}
