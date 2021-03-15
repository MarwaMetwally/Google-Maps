import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class AllUsers {
  String userId;
  String email;
  String name;
  String phone;

  AllUsers({this.userId, this.email, this.name, this.phone});

  AllUsers.fromSnapshot(DataSnapshot dataSnapshot) {
    userId = dataSnapshot.key;
    email = dataSnapshot.value["email"];
    name = dataSnapshot.value["name"];
    phone = dataSnapshot.value["phone"];
  }
}
