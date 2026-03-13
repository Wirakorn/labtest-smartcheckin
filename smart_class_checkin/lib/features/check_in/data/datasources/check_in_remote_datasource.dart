import '../../../../core/error/exceptions.dart';
import '../../../../shared/services/firebase/firebase_service.dart';
import '../models/check_in_model.dart';

abstract interface class ICheckInRemoteDatasource {
  /// Pushes check-in data to Firestore. Returns the Firestore document ID.
  Future<String> push(CheckInModel model);
}

class CheckInRemoteDatasource implements ICheckInRemoteDatasource {
  final FirebaseService _firebase;

  static const String _collection = 'check_ins';

  const CheckInRemoteDatasource(this._firebase);

  @override
  Future<String> push(CheckInModel model) async {
    try {
      return await _firebase.addDocument(_collection, model.toFirestore());
    } on RemoteException {
      rethrow;
    } catch (e) {
      throw RemoteException('CheckIn remote push failed: $e');
    }
  }
}
