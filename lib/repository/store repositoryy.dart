import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;

class StoreRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String currentUid = firebase_auth.FirebaseAuth.instance.currentUser?.uid ?? "";

  Future<Map<String, dynamic>?> fetchStoreDoc() async {
    if (currentUid.isEmpty) return null;
    var doc = await _firestore.collection("sellers").doc(currentUid).get();
    if (doc.exists && doc.data() != null) {
      return doc.data();
    }
    return null;
  }

  Future<bool> updateStoreData(Map<String, dynamic> data) async {
    try {
      if (currentUid.isEmpty) return false;
      await _firestore.collection("sellers").doc(currentUid).set(data, SetOptions(merge: true));
      return true;
    } catch (e) {
      return false;
    }
  }
}