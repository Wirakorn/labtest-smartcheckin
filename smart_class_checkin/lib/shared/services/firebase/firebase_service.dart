import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import '../../../core/error/exceptions.dart';

/// Thin wrapper around [FirebaseFirestore].
/// Feature datasources call this service rather than using Firestore directly.
class FirebaseService {
  final FirebaseFirestore? _injectedFirestore;

  FirebaseService({FirebaseFirestore? firestore})
      : _injectedFirestore = firestore;

  FirebaseFirestore get _firestore {
    if (_injectedFirestore != null) {
      return _injectedFirestore;
    }

    // Keep the app usable without Firebase setup. Repository layer treats
    // remote sync as best-effort and will keep local SQLite data as source-of-truth.
    if (Firebase.apps.isEmpty) {
      throw const RemoteException('Firebase is not initialized');
    }

    return FirebaseFirestore.instance;
  }

  // ── Write ────────────────────────────────────────────────
  /// Adds a new document to [collection]. Returns the generated document ID.
  Future<String> addDocument(
    String collection,
    Map<String, dynamic> data,
  ) async {
    try {
      final ref = await _firestore.collection(collection).add({
        ...data,
        'createdAt': FieldValue.serverTimestamp(),
      });
      return ref.id;
    } catch (e) {
      throw RemoteException('addDocument failed: $e');
    }
  }

  /// Sets (upserts) a document with a known [docId].
  Future<void> setDocument(
    String collection,
    String docId,
    Map<String, dynamic> data, {
    bool merge = true,
  }) async {
    try {
      await _firestore
          .collection(collection)
          .doc(docId)
          .set(data, SetOptions(merge: merge));
    } catch (e) {
      throw RemoteException('setDocument failed: $e');
    }
  }

  /// Updates specific fields on an existing document.
  Future<void> updateDocument(
    String collection,
    String docId,
    Map<String, dynamic> data,
  ) async {
    try {
      await _firestore.collection(collection).doc(docId).update({
        ...data,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw RemoteException('updateDocument failed: $e');
    }
  }

  // ── Read ─────────────────────────────────────────────────
  Future<Map<String, dynamic>?> getDocument(
    String collection,
    String docId,
  ) async {
    try {
      final snap = await _firestore.collection(collection).doc(docId).get();
      return snap.exists ? snap.data() : null;
    } catch (e) {
      throw RemoteException('getDocument failed: $e');
    }
  }

  Future<List<Map<String, dynamic>>> getCollection(
    String collection, {
    String? orderByField,
    bool descending = true,
    int? limit,
  }) async {
    try {
      Query<Map<String, dynamic>> query = _firestore.collection(collection);
      if (orderByField != null) {
        query = query.orderBy(orderByField, descending: descending);
      }
      if (limit != null) query = query.limit(limit);

      final snapshot = await query.get();
      return snapshot.docs.map((d) => {'id': d.id, ...d.data()}).toList();
    } catch (e) {
      throw RemoteException('getCollection failed: $e');
    }
  }
}
