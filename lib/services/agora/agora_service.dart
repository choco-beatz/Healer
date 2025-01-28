import 'dart:developer';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:healer_therapist/services/agora/constants.dart';
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
          logConfig: LogConfig(
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

  Future<void> joinVideoCall({
    required String callID,
    required int uid,
    required String token,
    required Function onLocalUserJoined,
    required Function(int) onUserJoined,
    required Function(int) onUserOffline,
  }) async {
    try {
      await engine.joinChannel(
        token: token,
        channelId: channel,
        uid: uid,
        options: const ChannelMediaOptions(),
      );

      engine.registerEventHandler(
        RtcEngineEventHandler(
          onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
            log("Local user ${connection.localUid} joined");
            onLocalUserJoined();
          },
          onUserJoined: (RtcConnection connection, int newRemoteUid, int elapsed) {
            log("Remote user $remoteUid joined");
            onUserJoined(newRemoteUid);
          },
          onUserOffline: (RtcConnection connection, int offlineRemoteUid,
              UserOfflineReasonType reason) {
            log("Remote user $offlineRemoteUid left channel");
            onUserOffline(offlineRemoteUid);
          },
        
        onTokenPrivilegeWillExpire: (RtcConnection connection, String token) {
          log(
              '[onTokenPrivilegeWillExpire] connection: ${connection.toJson()}, token: $token');
        },
      ),
      );
    } catch (e) {
      log('Error joining video call: $e');
    }
  }

  Future<void> joinAudioCall(String callID, int userID, String token) async {
    try {
      await engine.enableAudio();
      await engine.startPreview();
      await engine.joinChannel(
        token: token,
        channelId: channel,
        uid: userID,
        options: const ChannelMediaOptions(),
      );
      log("Joined audio call with Call ID: $callID and User ID: $userID");
    } catch (e) {
      log('Error joining audio call: $e');
    }
  }

  Future<void> leaveCall() async {
    await engine.leaveChannel();
    log("Left the call.");
  }

  Future<void> dispose() async {
    await engine.leaveChannel();
    await engine.release();
    log('Agora resources released.');
  }
}
