// import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:healer_therapist/constants/colors.dart';
import 'package:healer_therapist/constants/textstyle.dart';
import 'package:healer_therapist/services/agora/agora_service.dart';
import 'package:healer_therapist/services/agora/constants.dart';
import 'package:healer_therapist/services/token.dart';
import 'package:healer_therapist/widgets/loading.dart';
import 'package:permission_handler/permission_handler.dart';

class VideoCallPage extends StatefulWidget {
  final String channel;
  final AgoraService agoraService;

  const VideoCallPage({
    super.key,
    required this.channel,
    required this.agoraService,
  });

  @override
  VideoCallPageState createState() => VideoCallPageState();
}

class VideoCallPageState extends State<VideoCallPage> {
  String? token;
  int? _remoteUid;
  bool _localUserJoined = false;
  bool _isMuted = false;
  bool _isFrontCamera = true;
  late RtcEngine _engine;

  @override
  void initState() {
    super.initState();
    initAgora();
  }

  Future<void> initAgora() async {
    token = await getAgoraToken();
    await [Permission.microphone, Permission.camera].request();

    //create the engine
    _engine = createAgoraRtcEngine();
    await _engine.initialize(const RtcEngineContext(
      appId: appId,
      channelProfile: ChannelProfileType.channelProfileLiveBroadcasting,
    ));

    _engine.registerEventHandler(
      RtcEngineEventHandler(
        onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
          setState(() {
            _localUserJoined = true;
          });
        },
        onUserJoined: (RtcConnection connection, int remoteUid, int elapsed) {
          setState(() {
            _remoteUid = remoteUid;
          });
        },
        onUserOffline: (RtcConnection connection, int remoteUid,
            UserOfflineReasonType reason) {
          setState(() {
            _remoteUid = null;
          });
        },
        onTokenPrivilegeWillExpire: (RtcConnection connection, String token) {},
      ),
    );

    await _engine.setClientRole(role: ClientRoleType.clientRoleBroadcaster);
    await _engine.enableVideo();
    await _engine.startPreview();

    await _engine.joinChannel(
      token: token!,
      channelId: channel,
      uid: 0,
      options: const ChannelMediaOptions(),
    );
  }

  @override
  void dispose() {
    _dispose();
    super.dispose();
  }

  Future<void> _dispose() async {
    await _engine.leaveChannel();
    await _engine.release();
  }

  void _toggleMute() {
    setState(() => _isMuted = !_isMuted);
    _engine.muteLocalAudioStream(_isMuted);
  }

  void _switchCamera() {
    setState(() => _isFrontCamera = !_isFrontCamera);
    _engine.switchCamera();
  }

  void _endCall() {
    Navigator.pop(context);
  }

  // Create UI with local view and remote view
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Stack(
        children: [
          _remoteVideo(height, width),
          Positioned(
            top: 40,
            left: 20,
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: main1,
                borderRadius: BorderRadius.circular(15),
              ),
              child: _localUserJoined
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: SizedBox(
                        width: 100,
                        height: 100,
                        child: AgoraVideoView(
                          controller: VideoViewController(
                            rtcEngine: _engine,
                            canvas: const VideoCanvas(uid: 0),
                          ),
                        ),
                      ),
                    )
                  : const Loading(),
            ),
          ),
          Positioned(
            bottom: 30,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Material(
                  type: MaterialType.transparency,
                  child: FloatingActionButton(
                    backgroundColor: _isMuted ? red : white,
                    onPressed: _toggleMute,
                    child: Icon(_isMuted ? Icons.mic_off : Icons.mic,
                        color: black),
                  ),
                ),
                Material(
                  type: MaterialType.transparency,
                  child: FloatingActionButton(
                    backgroundColor: red,
                    onPressed: _endCall,
                    child: const Icon(Icons.call_end, color: white),
                  ),
                ),
                Material(
                  type: MaterialType.transparency,
                  child: FloatingActionButton(
                    backgroundColor: white,
                    onPressed: _switchCamera,
                    child: const Icon(Icons.switch_camera, color: black),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _remoteVideo(double height, double width) {
    if (_remoteUid != null) {
      return AgoraVideoView(
        controller: VideoViewController.remote(
          rtcEngine: _engine,
          canvas: VideoCanvas(uid: _remoteUid),
          connection: const RtcConnection(channelId: channel),
        ),
      );
    } else {
      return Center(
        child: Stack(
          children: [
            const Loading(),
            Positioned(
              top: height * 0.48,
              left: width * 0.25,
              child: const Text(
                'The client will join soon...',
                style: smallBold,
              ),
            ),
          ],
        ),
      );
    }
  }
}
