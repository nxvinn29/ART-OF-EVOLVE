import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> init() async {
    // Enable offline persistence
    _firestore.settings = const Settings(persistenceEnabled: true);
  }

  Future<List<Map<String, dynamic>>> getCollection(String path) async {
    final snapshot = await _firestore.collection(path).get();
    return snapshot.docs.map((d) => d.data()).toList();
  }

  Future<void> setDocument(
    String path,
    String id,
    Map<String, dynamic> data,
  ) async {
    await _firestore.collection(path).doc(id).set(data);
  }

  Future<void> deleteDocument(String path, String id) async {
    await _firestore.collection(path).doc(id).delete();
  }

  Stream<List<Map<String, dynamic>>> watchCollection(String path) {
    return _firestore.collection(path).snapshots().map((snapshot) {
      return snapshot.docs.map((d) => d.data()).toList();
    });
  }

  String get currentUserId {
    // Placeholder: In a real app, inject FirebaseAuth or generic Auth service
    // For now, assuming you handle auth elsewhere or use a mock ID for testing
    return 'user_id_placeholder';
  }
}
