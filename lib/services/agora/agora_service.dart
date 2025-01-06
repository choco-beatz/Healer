import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:healer_therapist/services/agora/constants.dart';
import 'package:permission_handler/permission_handler.dart';



class AgoraService {
  late RtcEngine engine;
  bool localUserJoined = false;
  int? remoteUid;

  Future<void> initializeAgora(String appId) async {
    await [Permission.microphone, Permission.camera].request();

    engine = createAgoraRtcEngine();
    await engine.initialize(RtcEngineContext(appId: appId));

    // Enable the video module
    await engine.enableVideo();
    // Enable local video preview
    await engine.startPreview();

    // Register event handler
    engine.registerEventHandler(
      RtcEngineEventHandler(
        onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
          print("Local user ${connection.localUid} joined");
          localUserJoined = true;
          // Handle UI or state updates here if needed
        },
        onUserJoined: (RtcConnection connection, int remoteUid, int elapsed) {
          print("Remote user $remoteUid joined");
          remoteUid = remoteUid;
          // Handle UI or state updates here if needed
        },
        onUserOffline: (RtcConnection connection, int remoteUid, UserOfflineReasonType reason) {
          print("Remote user $remoteUid left channel");
          remoteUid = 0;
        },
      ),
    );
  }

  Future<void> joinVideoCall({
  required String callID,
  required int uid,
  required Function onLocalUserJoined,
  required Function(int) onUserJoined,
  required Function(int) onUserOffline,
}) async {
  await engine.joinChannel(
    token: token, 
    channelId: callID,
    uid: uid,
    options: const ChannelMediaOptions(),
  );

  engine.registerEventHandler(
    RtcEngineEventHandler(
      onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
        print("Local user ${connection.localUid} joined");
        onLocalUserJoined();
      },
      onUserJoined: (RtcConnection connection, int remoteUid, int elapsed) {
        print("Remote user $remoteUid joined");
        onUserJoined(remoteUid);
      },
      onUserOffline: (RtcConnection connection, int remoteUid, UserOfflineReasonType reason) {
        print("Remote user $remoteUid left channel");
        onUserOffline(remoteUid);
      },
    ),
  );
}

Future<void> joinAudioCall(String callID, int userID, String token) async {
    await engine.enableAudio();
    await engine.joinChannel(
      token: token,
      channelId: callID,
      uid: userID,
      options: const ChannelMediaOptions(),
    );

    print("Joined audio call with Call ID: $callID and User ID: $userID");
  }
  Future<void> leaveCall() async {
    await engine.leaveChannel();
    print("Left the call.");
  }
}
