import '../../../../core/error/exceptions.dart';
import '../../../../shared/services/firebase/firebase_service.dart';
import '../models/check_out_model.dart';

abstract interface class ICheckOutRemoteDatasource {
  Future<void> push(CheckOutModel model);
}

class CheckOutRemoteDatasource implements ICheckOutRemoteDatasource {
  final FirebaseService _firebase;

  static const String _collection = 'check_outs';

  const CheckOutRemoteDatasource(this._firebase);

  @override
  Future<void> push(CheckOutModel model) async {
    try {
      await _firebase.addDocument(_collection, model.toFirestore());
    } on RemoteException {
      rethrow;
    } catch (e) {
      throw RemoteException('CheckOut remote push failed: $e');
    }
  }
}
