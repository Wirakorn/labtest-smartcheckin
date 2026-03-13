import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/check_out_entity.dart';
import '../../domain/usecases/perform_check_out_usecase.dart';
import '../../../../features/check_in/domain/repositories/i_check_in_repository.dart';
import '../../../../shared/services/location/location_service.dart';
import 'check_out_event.dart';
import 'check_out_state.dart';

class CheckOutBloc extends Bloc<CheckOutEvent, CheckOutState> {
  final PerformCheckOutUseCase _performCheckOut;
  final LocationService _locationService;
  final ICheckInRepository _checkInRepository;

  double? _lat;
  double? _lng;
  String? _qrCode;
  int? _checkInId;

  CheckOutBloc({
    required PerformCheckOutUseCase performCheckOut,
    required LocationService locationService,
    required ICheckInRepository checkInRepository,
  })  : _performCheckOut = performCheckOut,
        _locationService = locationService,
        _checkInRepository = checkInRepository,
        super(const CheckOutInitial()) {
    on<CheckOutStarted>(_onStarted);
    on<CheckOutLocationAcquired>(_onLocationAcquired);
    on<CheckOutQrScanned>(_onQrScanned);
    on<CheckOutFormSubmitted>(_onFormSubmitted);
    on<CheckOutReset>(_onReset);
  }

  Future<void> _onStarted(
    CheckOutStarted event,
    Emitter<CheckOutState> emit,
  ) async {
    emit(const CheckOutLocationLoading());
    try {
      // Fetch GPS and latest checkInId in parallel
      final results = await Future.wait([
        _locationService.getCurrentPosition(),
        _checkInRepository.getLatestCheckIn(event.studentId),
      ]);

      final position = results[0] as dynamic;
      _lat = position.latitude as double;
      _lng = position.longitude as double;

      final checkInResult = results[1] as dynamic;
      checkInResult.fold(
        (failure) => _checkInId = null,
        (entity) => _checkInId = entity?.id,
      );

      if (_checkInId == null) {
        emit(const CheckOutFailureState(
            'ไม่พบข้อมูล Check-in กรุณาเช็คชื่อเข้าเรียนก่อน'));
        return;
      }

      emit(CheckOutAwaitingQr(latitude: _lat!, longitude: _lng!));
    } catch (e) {
      emit(CheckOutFailureState(e.toString()));
    }
  }

  void _onLocationAcquired(
    CheckOutLocationAcquired event,
    Emitter<CheckOutState> emit,
  ) {
    _lat = event.latitude;
    _lng = event.longitude;
    emit(CheckOutAwaitingQr(latitude: _lat!, longitude: _lng!));
  }

  void _onQrScanned(
    CheckOutQrScanned event,
    Emitter<CheckOutState> emit,
  ) {
    _qrCode = event.qrCode;
    emit(CheckOutFormReady(
      latitude: _lat!,
      longitude: _lng!,
      qrCode: _qrCode!,
    ));
  }

  Future<void> _onFormSubmitted(
    CheckOutFormSubmitted event,
    Emitter<CheckOutState> emit,
  ) async {
    if (_lat == null || _lng == null || _qrCode == null) {
      emit(const CheckOutFailureState('GPS or QR data missing. Please retry.'));
      return;
    }

    emit(const CheckOutSaving());

    final entity = CheckOutEntity(
      checkInId: _checkInId!,
      studentId: event.studentId,
      checkOutTime: DateTime.now(),
      gpsLatitude: _lat!,
      gpsLongitude: _lng!,
      learnedToday: event.learnedToday,
      feedback: event.feedback,
      postClassMood: event.postClassMood,
      qrCode: _qrCode!,
    );

    final result = await _performCheckOut(entity);

    result.fold(
      (failure) => emit(CheckOutFailureState(failure.message)),
      (saved) => emit(CheckOutSuccess(saved)),
    );
  }

  void _onReset(CheckOutReset event, Emitter<CheckOutState> emit) {
    _lat = null;
    _lng = null;
    _qrCode = null;
    _checkInId = null;
    emit(const CheckOutInitial());
  }
}
