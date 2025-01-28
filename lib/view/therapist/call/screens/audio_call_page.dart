import 'package:flutter/material.dart';
import 'package:healer_therapist/constants/colors.dart';
import 'package:healer_therapist/services/agora/agora_service.dart';
import 'package:healer_therapist/services/agora/constants.dart';
import 'package:healer_therapist/services/token.dart';

class AudioCallPage extends StatefulWidget {
  final String channelId;
  final int userId;
  final AgoraService agoraService;

  const AudioCallPage({
    super.key,
    required this.channelId,
    required this.userId,
    required this.agoraService,
  });

  @override
  State<AudioCallPage> createState() => _AudioCallPageState();
}

class _AudioCallPageState extends State<AudioCallPage> {
  bool isMuted = false;
  String? therapistId;

  @override
  void initState() {
    super.initState();
    _startAudioCall();
  }

  Future<void> getTherapistId() async {
    final id = await getUserId();
    setState(() {
      therapistId = id;
    });
  }

  Future<void> _startAudioCall() async {
    await widget.agoraService.joinAudioCall(
      channel,
      uid,
      token, 
    );
  }

  Future<void> _leaveCall() async {
    await widget.agoraService.leaveCall();
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Audio Call'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Audio Call in Progress',
            style: TextStyle(fontSize: 20),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                onPressed: () {
                  setState(() {
                    isMuted = !isMuted;
                  });
                  widget.agoraService.engine.muteLocalAudioStream(isMuted);
                },
                icon: Icon(
                  isMuted ? Icons.mic_off : Icons.mic,
                  color: isMuted ? red : main1,
                  size: 30,
                ),
              ),
              IconButton(
                onPressed: _leaveCall,
                icon: const Icon(
                  Icons.call_end,
                  color: red,
                  size: 30,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
