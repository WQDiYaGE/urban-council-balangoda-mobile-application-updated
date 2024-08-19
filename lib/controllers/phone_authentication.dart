import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:urban_council/services/user_service.dart';

class PhoneAuthentication {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Check if user data exists in Firestore
  Future<bool> checkIfUserExists(String uid) async {
    try {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('residents')
          .doc(uid)
          .get();
      return userDoc.exists;
    } catch (e) {
      return false;
    }
  }

  //store userData
  Future<void> storeUserData(User user) async {
    try {
      await FirebaseFirestore.instance
          .collection('residents')
          .doc(user.uid)
          .set({'phone': user.phoneNumber, 'id': user.uid});
    } catch (e) {
      e.toString();
    }
  }

//signout user
  Future<void> logOutUser() async {
    await _auth.signOut();
    await UserService().logout();
  }

//store phone number

  Future<void> storeNumber(String phoneNo) async {
    try {
      await _firestore.collection('residents').doc(phoneNo).set({
        'phoneNumber': phoneNo,
      });
    } catch (e) {
      e.toString();
    }
  }
}
