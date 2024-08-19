import 'package:cloud_firestore/cloud_firestore.dart';

class Resident {
  final String uid;
  final String firstName;
  final String lastName;
  final String email;
  final String profileUrl;
  final String phone;

  Resident({
    required this.uid,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.profileUrl,
    required this.phone,
  });

  // Factory constructor to create a Resident from Firestore document
  factory Resident.fromDocument(DocumentSnapshot doc) {
    return Resident(
      uid: doc.id,
      firstName: doc['first_name'] ?? '',
      lastName: doc['last_name'] ?? '',
      email: doc['email'] ?? '',
      profileUrl: doc['profileImage'] ?? '',
      phone: doc['phone'] ?? '',
    );
  }
}
