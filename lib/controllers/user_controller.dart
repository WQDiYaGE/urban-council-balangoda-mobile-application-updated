import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:urban_council/models/resident.dart';
import 'package:urban_council/services/user_service.dart';

class UserController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> submitDetails(
      String uid, String fName, String lName, String email) async {
    try {
      await _firestore.collection('residents').doc(uid).update({
        'first_name': fName,
        'last_name': lName,
        'email': email,
        'profileImage': '',
      });
    } catch (e) {
      e.toString();
    }
  }

  Future<void> handleLogin(String uid) async {
    // Fetch user details from Firestore
    DocumentSnapshot doc =
        await FirebaseFirestore.instance.collection('residents').doc(uid).get();

    if (doc.exists) {
      Resident currentUser = Resident.fromDocument(doc);
      UserService().setCurrentUser(currentUser);
    } else {
      // Handle the case where user data doesn't exist
    }
  }
}
