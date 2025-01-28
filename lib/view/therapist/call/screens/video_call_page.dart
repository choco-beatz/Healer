import 'dart:math';
import 'package:flutter/material.dart';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:healer_therapist/bloc/agora/agora_bloc.dart';
import 'package:healer_therapist/services/agora/agora_service.dart';
import 'package:healer_therapist/services/agora/constants.dart';
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

int? _remoteUid;
  bool _localUserJoined = false;
  late RtcEngine _engine;

  @override
  void initState() {
    super.initState();
    initAgora();
  }

  Future<void> initAgora() async {
    // retrieve permissions
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
          debugPrint("local user ${connection.localUid} joined");
          setState(() {
            _localUserJoined = true;
          });
        },
        onUserJoined: (RtcConnection connection, int remoteUid, int elapsed) {
          debugPrint("remote user $remoteUid joined");
          setState(() {
            _remoteUid = remoteUid;
          });
        },
        onUserOffline: (RtcConnection connection, int remoteUid,
            UserOfflineReasonType reason) {
          debugPrint("remote user $remoteUid left channel");
          setState(() {
            _remoteUid = null;
          });
        },
        onTokenPrivilegeWillExpire: (RtcConnection connection, String token) {
          debugPrint(
              '[onTokenPrivilegeWillExpire] connection: ${connection.toJson()}, token: $token');
        },
      ),
    );

    await _engine.setClientRole(role: ClientRoleType.clientRoleBroadcaster);
    await _engine.enableVideo();
    await _engine.startPreview();

    await _engine.joinChannel(
      token: token,
      channelId: channel,
      uid: 0,
      options: const ChannelMediaOptions(),
    );
  }

  @override
  void dispose() {
    super.dispose();

    _dispose();
  }

  Future<void> _dispose() async {
    await _engine.leaveChannel();
    await _engine.release();
    
  }

  // Create UI with local view and remote view
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Agora Video Call'),
      ),
      body: Stack(
        children: [
          Center(
            child: _remoteVideo(),
          ),
          Align(
            alignment: Alignment.topLeft,
            child: SizedBox(
              width: 100,
              height: 150,
              child: Center(
                child: _localUserJoined
                    ? AgoraVideoView(
                        controller: VideoViewController(
                          rtcEngine: _engine,
                          canvas: const VideoCanvas(uid: 0),
                        ),
                      )
                    : const CircularProgressIndicator(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Display remote user's video
  Widget _remoteVideo() {
    if (_remoteUid != null) {
      return AgoraVideoView(
        controller: VideoViewController.remote(
          rtcEngine: _engine,
          canvas: VideoCanvas(uid: _remoteUid),
          connection: const RtcConnection(channelId: channel),
        ),
      );
    } else {
      return const Text(
        'Please wait for remote user to join',
        textAlign: TextAlign.center,
      );
    }
  }
}

  // bool localUserJoined = false;
  // int? _remoteUid;
  // bool _isMuted = false;
  // bool _isCameraOff = false;
  // late AgoraBloc _agoraBloc;
  // late int _uid;

  // @override
  // void initState() {
  //   super.initState();
  //   _agoraBloc = context.read<AgoraBloc>();
  //   _uid = 100000 + Random().nextInt(900000); // Generate random UID
  //   _setupCall();
  // }

  // Future<void> _setupCall() async {
  //   await widget.agoraService.engine.enableVideo();
  //   await widget.agoraService.engine.startPreview();
    
  //   _agoraBloc.add(JoinVideoCall(
  //     token: token,
  //     callID: widget.channel,
  //     uid: _uid,
  //     callerId: _uid.toString(),
  //   ));
  // }

  // void _toggleMute() {
  //   setState(() {
  //     _isMuted = !_isMuted;
  //     widget.agoraService.engine.muteLocalAudioStream(_isMuted);
  //   });
  // }

  // void _toggleCamera() {
  //   setState(() {
  //     _isCameraOff = !_isCameraOff;
  //     widget.agoraService.engine.enableLocalVideo(!_isCameraOff);
  //   });
  // }

  // @override
  // void dispose() {
  //   widget.agoraService.engine.stopPreview();
  //   _agoraBloc.add(LeaveCall());
  //   super.dispose();
  // }

  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     appBar: AppBar(
  //       title: const Text('Video Call'),
  //       actions: [
  //         IconButton(
  //           icon: const Icon(Icons.call_end),
  //           onPressed: () {
  //             _agoraBloc.add(LeaveCall());
  //             Navigator.pop(context);
  //           },
  //         ),
  //       ],
  //     ),
  //     body: BlocListener<AgoraBloc, AgoraState>(
  //       listener: (context, state) {
  //         if (state is RemoteUserJoinedState) {
  //           setState(() => _remoteUid = state.remoteUid);
  //         }
  //         if (state is VideoCallJoinedState) {
  //           setState(() => localUserJoined = true);
  //         }
  //         if (state is AgoraErrorState) {
  //           ScaffoldMessenger.of(context).showSnackBar(
  //             SnackBar(content: Text(state.error)),
  //           );
  //         }
  //       },
  //       child: Stack(
  //         children: [
  //           Center(
  //             child: _remoteUid != null
  //                 ? AgoraVideoView(
  //                     controller: VideoViewController.remote(
  //                       rtcEngine: widget.agoraService.engine,
  //                       canvas: VideoCanvas(uid: _remoteUid),
  //                       connection: RtcConnection(channelId: widget.channel),
  //                     ),
  //                   )
  //                 : const Text('Waiting for remote user...'),
  //           ),
  //           Align(
  //             alignment: Alignment.topRight,
  //             child: SizedBox(
  //               width: 100,
  //               height: 150,
  //               child: AgoraVideoView(
  //                 controller: VideoViewController(
  //                   rtcEngine: widget.agoraService.engine,
  //                   canvas: const VideoCanvas(uid: 0),
  //                 ),
  //               ),
  //             ),
  //           ),
  //           Align(
  //             alignment: Alignment.bottomCenter,
  //             child: Padding(
  //               padding: const EdgeInsets.only(bottom: 20),
  //               child: Row(
  //                 mainAxisAlignment: MainAxisAlignment.center,
  //                 children: [
  //                   IconButton(
  //                     icon: Icon(_isMuted ? Icons.mic_off : Icons.mic),
  //                     onPressed: _toggleMute,
  //                   ),
  //                   IconButton(
  //                     icon: Icon(_isCameraOff ? Icons.videocam_off : Icons.videocam),
  //                     onPressed: _toggleCamera,
  //                   ),
  //                 ],
  //               ),
  //             ),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }
