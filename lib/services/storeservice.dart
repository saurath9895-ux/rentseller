import 'package:cloud_firestore/cloud_firestore.dart';

class StoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<DocumentSnapshot> fetchStoreDoc(String uid) async {
    return await _firestore.collection("sellers").doc(uid).get();
  }

  Future<void> saveStoreDoc(String uid, Map<String, dynamic> data) async {
    await _firestore.collection("sellers").doc(uid).set(data, SetOptions(merge: true));
  }
}