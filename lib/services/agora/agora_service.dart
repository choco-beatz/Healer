import 'dart:convert';
import 'dart:developer';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:healer_therapist/services/agora/constants.dart';
import 'package:healer_therapist/services/api_helper.dart';
import 'package:healer_therapist/services/endpoints.dart';
import 'package:healer_therapist/services/token.dart';
import 'package:permission_handler/permission_handler.dart';

class AgoraService {
  late RtcEngine engine;

  bool localUserJoined = false;
  int? remoteUid;

  // Initialize Agora RTC engine and RTM client
  Future<void> initializeAgora(String appId) async {
    try {
      // Ensure permissions are granted before initialization
      await [Permission.microphone, Permission.camera].request();
      if (!await _checkPermissions()) {
        throw 'Permissions not granted';
      }

      // Initialize Agora RTC engine
      engine = createAgoraRtcEngine();
      await engine.initialize(
        RtcEngineContext(
          appId: appId,
          channelProfile: ChannelProfileType.channelProfileLiveBroadcasting,
          logConfig: const LogConfig(
            level: LogLevel.logLevelError,
          ),
        ),
      );
      log('Agora RTC engine initialized successfully.');
    } catch (e) {
      log('Agora Initialization Error: $e');
      throw 'Agora initialization failed. Check app ID, permissions, and network.';
    }
  }

  Future<bool> _checkPermissions() async {
    final micStatus = await Permission.microphone.status;
    final cameraStatus = await Permission.camera.status;

    if (!micStatus.isGranted || !cameraStatus.isGranted) {
      final results =
          await [Permission.microphone, Permission.camera].request();

      return results.values.every((status) => status.isGranted);
    }
    return true;
  }

 Future<bool> fetchAgoraToken() async {
  try {
    final response = await makeRequest(
      agoraTokenUrl,
      'POST',
      body: jsonEncode({"channelName": channel, "uid": '0'}),
    );

    if (response == null || response.statusCode != 200) {
      log('Failed to fetch Agora token');
      return false;
    }

    final responseData = jsonDecode(response.body);
    final tokenValue = responseData['token'].toString();

    if (tokenValue.isNotEmpty) {
      await secureStorage.write(key: 'agoraToken', value: tokenValue);
      return true;
    }
  } catch (e) {
    log('Error fetching token: $e');
  }
  return false;
}

}
