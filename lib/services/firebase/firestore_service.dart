import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> collection(
    String collectionName,
  ) {
    return _firestore.collection(collectionName);
  }

  Future<void> addDocument({
    required String collectionName,
    required Map<String, dynamic> data,
  }) async {
    await _firestore.collection(collectionName).add(data);
  }

  Future<void> setDocument({
    required String collectionName,
    required String documentId,
    required Map<String, dynamic> data,
  }) async {
    await _firestore
        .collection(collectionName)
        .doc(documentId)
        .set(data);
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> getDocument({
    required String collectionName,
    required String documentId,
  }) async {
    return await _firestore
        .collection(collectionName)
        .doc(documentId)
        .get();
  }

  Future<void> deleteDocument({
    required String collectionName,
    required String documentId,
  }) async {
    await _firestore
        .collection(collectionName)
        .doc(documentId)
        .delete();
  }
}