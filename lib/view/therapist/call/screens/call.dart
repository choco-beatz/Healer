import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:healer_therapist/bloc/agora/agora_bloc.dart';
import 'package:healer_therapist/bloc/therapist/therapist_bloc.dart';
import 'package:healer_therapist/constants/colors.dart';
import 'package:healer_therapist/model/client/client_model.dart';
import 'package:healer_therapist/services/agora/constants.dart';
import 'package:healer_therapist/services/chat/socket.dart';
import 'package:healer_therapist/view/therapist/call/screens/audio_call_page.dart';
import 'package:healer_therapist/view/therapist/call/screens/video_call_page.dart';
import 'package:healer_therapist/view/therapist/call/widgets/contact_card.dart';
import 'package:healer_therapist/view/therapist/client/widgets/empty.dart';
import 'package:healer_therapist/widgets/appbar.dart';
import 'package:healer_therapist/view/therapist/client/widgets/client_detail.dart';
import 'package:healer_therapist/widgets/loading.dart';

class Contacts extends StatefulWidget {
  final String userId;
  final SocketService socketService;
  const Contacts(
      {super.key, required this.userId, required this.socketService});

  @override
  State<Contacts> createState() => _ContactsState();
}

class _ContactsState extends State<Contacts> {
  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<TherapistBloc>().add(OnGoingClientEvent());
      context.read<AgoraBloc>().add(InitializeAgora(appId, widget.userId));
    });

    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(50),
        child: CommonAppBar(
          title: 'Clients',
        ),
      ),
      body: BlocListener<AgoraBloc, AgoraState>(
        listener: (context, state) {
          if (state is AgoraErrorState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Agora Error: ${state.error}')),
            );
          }
        },
        child: BlocBuilder<TherapistBloc, TherapistState>(
          builder: (context, state) {
            if (state is ClientLoading) {
              return const Loading();
            } else if (state is ClientLoaded) {
              final clients = state.list;
              if (clients.isEmpty) {
                return const Center(child: EmptyClient());
              }

              return BlocBuilder<AgoraBloc, AgoraState>(
                builder: (context, agoraState) {
                  if (agoraState is AgoraInitial) {
                    return const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircularProgressIndicator(),
                          SizedBox(height: 16),
                          Text('Initializing Agora...'),
                        ],
                      ),
                    );
                  } else if (agoraState is AgoraLoadedState &&
                      agoraState.agoraService != null) {
                    final agoraService = agoraState.agoraService;

                    return ListView.builder(
                      itemCount: clients.length,
                      itemBuilder: (context, index) {
                        final client = clients[index].client;

                        return GestureDetector(
                            onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        ClientDetails(client: client),
                                  ),
                                ),
                            child: ContactCard(
                              height: MediaQuery.of(context).size.height,
                              width: MediaQuery.of(context).size.width,
                              client: client,
                              onCall: () => _navigateToAudioCall(
                                  context, client, agoraState),
                              onVideoCall: () => _navigateToVideoCall(
                                  context, client, agoraState),
                              onDetails: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      ClientDetails(client: client),
                                ),
                              ),
                            ));
                      },
                    );
                  } else if (agoraState is AgoraErrorState) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.error, color: red, size: 50),
                          Text(
                              'Agora Initialization Failed: ${agoraState.error}'),
                          ElevatedButton(
                            onPressed: () => context
                                .read<AgoraBloc>()
                                .add(InitializeAgora(appId, widget.userId)),
                            child: const Text('Retry'),
                          ),
                        ],
                      ),
                    );
                  }
                  return const Center(child: CircularProgressIndicator());
                },
              );
            } else {
              return const Center(
                child: EmptyClient(),
              );
            }
          },
        ),
      ),
    );
  }

  void _navigateToAudioCall(
      BuildContext context, ClientModel client, AgoraLoadedState agoraState) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AudioCallPage(
          agoraService: agoraState.agoraService,
          channelId: channel,
          userId: uid,
        ),
      ),
    );
  }

  void _navigateToVideoCall(BuildContext context, ClientModel client,
    AgoraLoadedState agoraState) async {
  try {
    // // First, set up the call-started listener
    // widget.socketService.listenToEvent('call-started', (dynamic data) {
    //   // Handle the response
    //   ScaffoldMessenger.of(context).showSnackBar(
    //     const SnackBar(content: Text('Call started successfully!')),
    //   );
       widget.socketService.emitEvent('start-call', {
      'from': widget.userId,
      'to': client.id,
    });
      // Navigate to the call page
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => VideoCallPage(
            agoraService: agoraState.agoraService,
            channel: channel,
          ),
        ),
      );

    //   // Clean up the listener
    //   widget.socketService.removeEventListener('call-started');
    // });

    // Then, in a separate step, emit the start-call event
   

  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Failed to start video call: $e')),
    );
  }
}

  @override
  void dispose() {
    context.read<AgoraBloc>().add(InitializeAgora(appId, widget.userId));
    super.dispose();
  }
}
