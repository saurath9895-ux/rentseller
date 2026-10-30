import 'package:cloud_firestore/cloud_firestore.dart';

class UserAccountService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future fetchUserData(String userId) async {
    try {
      DocumentSnapshot doc = await _firestore.collection("users").doc(userId).get();
      if (doc.exists) {
        return doc.data() as Map<String, dynamic>?;
      }
      return null;
    } catch (e) {
      return null;
    }
  }
}