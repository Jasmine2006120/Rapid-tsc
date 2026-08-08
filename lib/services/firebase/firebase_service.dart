import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class GreenWaveFirebaseService {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  User? get currentUser => auth.currentUser;

  Future<UserCredential> signInAnonymously() async {
    return await auth.signInAnonymously();
  }

  Future<void> saveVehicle({
    required String vehicleId,
    required String vehicleType,
  }) async {
    await firestore.collection('vehicles').doc(vehicleId).set({
      'vehicleId': vehicleId,
      'vehicleType': vehicleType,
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  Future<void> saveEmergencyRequest({
    required String vehicleId,
    required String category,
    required String destination,
    required int priorityScore,
  }) async {
    await firestore.collection('emergency_requests').add({
      'vehicleId': vehicleId,
      'category': category,
      'destination': destination,
      'priorityScore': priorityScore,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> emergencyRequests() {
    return firestore
        .collection('emergency_requests')
        .orderBy('createdAt', descending: true)
        .snapshots();
  }
}