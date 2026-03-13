import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/check_in_entity.dart';
import '../../domain/usecases/perform_check_in_usecase.dart';
import '../../../../shared/services/location/location_service.dart';
import 'check_in_event.dart';
import 'check_in_state.dart';

class CheckInBloc extends Bloc<CheckInEvent, CheckInState> {
  final PerformCheckInUseCase _performCheckIn;
  final LocationService _locationService;

  // Transient state held between events
  double? _lat;
  double? _lng;
  String? _qrCode;

  CheckInBloc({
    required PerformCheckInUseCase performCheckIn,
    required LocationService locationService,
  })  : _performCheckIn = performCheckIn,
        _locationService = locationService,
        super(const CheckInInitial()) {
    on<CheckInStarted>(_onStarted);
    on<CheckInLocationAcquired>(_onLocationAcquired);
    on<CheckInQrScanned>(_onQrScanned);
    on<CheckInFormSubmitted>(_onFormSubmitted);
    on<CheckInReset>(_onReset);
  }

  // ── Handlers ─────────────────────────────────────────────

  Future<void> _onStarted(
    CheckInStarted event,
    Emitter<CheckInState> emit,
  ) async {
    emit(const CheckInLocationLoading());
    try {
      final position = await _locationService.getCurrentPosition();
      _lat = position.latitude;
      _lng = position.longitude;
      emit(CheckInAwaitingQr(latitude: _lat!, longitude: _lng!));
    } catch (e) {
      emit(CheckInFailureState(e.toString()));
    }
  }

  void _onLocationAcquired(
    CheckInLocationAcquired event,
    Emitter<CheckInState> emit,
  ) {
    _lat = event.latitude;
    _lng = event.longitude;
    emit(CheckInAwaitingQr(latitude: _lat!, longitude: _lng!));
  }

  void _onQrScanned(
    CheckInQrScanned event,
    Emitter<CheckInState> emit,
  ) {
    _qrCode = event.qrCode;
    emit(CheckInFormReady(
      latitude: _lat!,
      longitude: _lng!,
      qrCode: _qrCode!,
    ));
  }

  Future<void> _onFormSubmitted(
    CheckInFormSubmitted event,
    Emitter<CheckInState> emit,
  ) async {
    if (_lat == null || _lng == null || _qrCode == null) {
      emit(const CheckInFailureState('GPS or QR data missing. Please retry.'));
      return;
    }

    emit(const CheckInSaving());

    final entity = CheckInEntity(
      studentId: event.studentId,
      checkInTime: DateTime.now(),
      gpsLatitude: _lat!,
      gpsLongitude: _lng!,
      previousTopic: event.previousTopic,
      expectedTopic: event.expectedTopic,
      mood: event.mood,
      qrCode: _qrCode!,
    );

    final result = await _performCheckIn(entity);

    result.fold(
      (failure) => emit(CheckInFailureState(failure.message)),
      (saved) => emit(CheckInSuccess(saved)),
    );
  }

  void _onReset(CheckInReset event, Emitter<CheckInState> emit) {
    _lat = null;
    _lng = null;
    _qrCode = null;
    emit(const CheckInInitial());
  }
}
