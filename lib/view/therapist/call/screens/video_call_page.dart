import 'package:flutter/material.dart';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:healer_therapist/services/agora/agora_service.dart';
import 'package:healer_therapist/services/agora/constants.dart';
import 'package:healer_therapist/services/token.dart';

class VideoCallPage extends StatefulWidget {
  final AgoraService agoraService;
  final String channelId;
  final int userId;

  const VideoCallPage({
    super.key,
    required this.agoraService,
    required this.channelId,
    required this.userId,
  });

  @override
  VideoCallPageState createState() => VideoCallPageState();
}

class VideoCallPageState extends State<VideoCallPage> {
  bool _localUserJoined = false;
  int? _remoteUid;

  @override
  void initState() {
    super.initState();
    _startCall();
  }



 Future<void> _startCall() async {
  await widget.agoraService.joinVideoCall(
    callID: widget.channelId,
   
    uid: uid, 
    onLocalUserJoined: () {
      setState(() {
        _localUserJoined = true;
      });
    },
    onUserJoined: (int remoteUid) {
      setState(() {
        _remoteUid = remoteUid;
      });
    },
    onUserOffline: (int remoteUid) {
      setState(() {
        _remoteUid = null;
      });
    },
  );
}


  Widget _buildRemoteVideo() {
    if (_remoteUid != null) {
      return AgoraVideoView(
        controller: VideoViewController.remote(
          rtcEngine: widget.agoraService.engine,
          canvas: VideoCanvas(uid: _remoteUid),
          connection: RtcConnection(channelId: widget.channelId),
        ),
      );
    } else {
      return const Text('Waiting for remote user to join...',
          textAlign: TextAlign.center);
    }
  }

  @override
  void dispose() {
    widget.agoraService.leaveCall();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Agora Video Call'),
        actions: [
          IconButton(
            icon: const Icon(Icons.call_end),
            onPressed: () async {
              await widget.agoraService.leaveCall();
              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          Center(child: _buildRemoteVideo()),
          Align(
            alignment: Alignment.topLeft,
            child: SizedBox(
              width: 100,
              height: 150,
              child: Center(
                child: _localUserJoined
                    ? AgoraVideoView(
                        controller: VideoViewController(
                          rtcEngine: widget.agoraService.engine,
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
}
