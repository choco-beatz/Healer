import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:healer_therapist/bloc/agora/agora_bloc.dart';
import 'package:healer_therapist/bloc/therapist/therapist_bloc.dart';
import 'package:healer_therapist/services/agora/constants.dart';
import 'package:healer_therapist/view/therapist/call/screens/audio_call_page.dart';
import 'package:healer_therapist/view/therapist/call/screens/video_call_page.dart';
import 'package:healer_therapist/view/therapist/call/widgets/contact_card.dart';
import 'package:healer_therapist/view/therapist/client/widgets/empty.dart';
import 'package:healer_therapist/widgets/appbar.dart';
import 'package:healer_therapist/view/therapist/client/widgets/client_detail.dart';

class Contacts extends StatefulWidget {
  const Contacts({super.key});

  @override
  State<Contacts> createState() => _ContactsState();
}

class _ContactsState extends State<Contacts> {
  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<TherapistBloc>().add(OnGoingClientEvent());
      context.read<AgoraBloc>().add(InitializeAgora(appId));
    });

    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(50),
        child: CommonAppBar(
          title: 'Clients',
        ),
      ),
      body: BlocBuilder<TherapistBloc, TherapistState>(
        builder: (context, therapistState) {
          // Check if therapist state contains clients
          if (therapistState.list.isNotEmpty) {
            final clients = therapistState.list;

            return BlocBuilder<AgoraBloc, AgoraState>(
              builder: (context, agoraState) {
                if (agoraState is AgoraLoadedState) {
                  return const Center(child: CircularProgressIndicator());
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
                            builder: (context) => ClientDetails(client: client),
                          ),
                        ),
                        child: ContactCard(
                          height: MediaQuery.of(context).size.height,
                          width: MediaQuery.of(context).size.width,
                          client: client,
                          onCall: () async {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => AudioCallPage(
                                  agoraService: agoraService,
                                  channelId: client.profile.id,
                                  userId: uid,
                                ),
                              ),
                            );
                          },
                          onVideoCall: () async {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => VideoCallPage(
                                  agoraService: agoraService,
                                  channelId: client.profile.id,
                                  userId: uid,
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  );
                } else if (agoraState is AgoraErrorState) {
                  print(agoraState.message);
                  return Center(
                    child: Text('Error: ${agoraState.message}'),
                  );
                } else {
                  return const Center(child: Text('Initializing Agora...'));
                }
              },
            );
          } else {
            return const Center(child: EmptyClient());
          }
        },
      ),
    );
  }
}
