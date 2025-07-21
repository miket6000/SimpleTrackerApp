import 'package:gps_tracker/models/tracker_data.dart';

import '../models/gps_fix.dart';
import '../models/telemetry_model.dart';
import 'geo_tools.dart';

class TelemetryTracker {
  GpsFix? _remoteFix;
  GpsFix? _localFix;
  GpsFix? _lastRemoteFix;
  String? _remoteID;
  double? _newAltitude;
  int _rssi = 0;
  TelemetryModel? _latest;

  TelemetryModel? get telemetry => _latest;
  GpsFix? get remoteFix => _remoteFix;
  GpsFix? get localFix => _localFix;
  
  void updateRemote(RemoteResponse data) {
    _lastRemoteFix = _remoteFix;
    _remoteFix = data.fix;
    _remoteID = data.remoteId;
    _rssi = data.rssi;
    _updateTelemetry();
  }

  void updateLocal(LocalResponse data) {
    _localFix = data.fix;
    _updateTelemetry();
  }

  void _updateTelemetry() {
    double verticalVelocity = 0;

    if (_localFix == null || _remoteFix == null) {
      _latest = null;
      return;
    }

    if (_lastRemoteFix != null) {
      final dt = _remoteFix!.timestamp?.difference(_lastRemoteFix!.timestamp ?? DateTime(0)).inMilliseconds ?? 0 / 1000;
      final dz = _remoteFix!.altitude ?? 0 - (_lastRemoteFix!.altitude ?? 0);
      verticalVelocity = dt > 0 ? dz / dt : 0;
    }

    final distance = distanceBetween(
      _localFix!.latitude, _localFix!.longitude,
      _remoteFix?.latitude, _remoteFix!.longitude,
    );

    final bearing = bearingBetween(
      _localFix!.latitude, _localFix!.longitude,
      _remoteFix!.latitude, _remoteFix!.longitude,
    );

    final elevation = elevationBetween(
      _remoteFix!.altitude, _localFix!.altitude, distance,
    );

    _latest = TelemetryModel(
      remoteID: _remoteID!,
      remoteFix: _remoteFix!,
      localFix: _localFix!,
      rssi: _rssi,
      distance: distance,
      bearing: bearing,
      elevation: elevation,
      verticalVelocity: verticalVelocity,
    );
  }
}
