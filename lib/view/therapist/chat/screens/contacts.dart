import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:healer_therapist/bloc/chat/chat_bloc.dart';
import 'package:healer_therapist/bloc/therapist/therapist_bloc.dart';
import 'package:healer_therapist/services/chat/socket.dart';
import 'package:healer_therapist/view/therapist/chat/screens/message_screen.dart';
import 'package:healer_therapist/view/therapist/chat/widgets/chat_card.dart';
import 'package:healer_therapist/view/therapist/chat/widgets/message_card.dart';
import 'package:healer_therapist/widgets/appbar.dart';
import 'package:healer_therapist/widgets/empty.dart';
import 'package:healer_therapist/widgets/loading.dart';
import 'package:intl/intl.dart';

class Contact extends StatelessWidget {
  final SocketService socketService;

  const Contact({super.key, required this.socketService});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(50),
        child: CommonAppBar(
          title: 'All Clients',
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: BlocBuilder<TherapistBloc, TherapistState>(
          builder: (context, state) {
            if (state is ClientLoading) {
              return const Loading();
            } else if (state is ClientLoaded) {
              final clients = state.list;

              if (clients.isEmpty) {
                return const Empty(
                  title: 'No Clients to Chat With',
                  subtitle:
                      "Start conversations with your clients here once they reach out to you.",
                  image: "asset/emptyContact.jpg",
                );
              }

              return BlocBuilder<ChatBloc, ChatState>(
                builder: (context, chatState) {
                  if (chatState is ChatLoading) {
                    return const Loading();
                  } else if (chatState is ChatsLoaded) {
                    final chats = chatState.chats;

                    return ListView.builder(
                      itemCount: clients.length,
                      itemBuilder: (context, index) {
                        final client = clients[index].client;

                        // **Check if chats is empty before accessing it**
                        if (chats.isEmpty || index >= chats.length) {
                          return GestureDetector(
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ChatScreen(
                                  name: client.profile.name,
                                  image: client.image,
                                  id: client.id,
                                  socketService: socketService,
                                ),
                              ),
                            ),
                            child: ChatCard(
                              socketService: socketService,
                              height: MediaQuery.of(context).size.height,
                              width: MediaQuery.of(context).size.width,
                              client: client,
                            ),
                          );
                        } else {
                          final chat = chats[index];

                          return GestureDetector(
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => BlocProvider(
                                  create: (context) => ChatBloc()
                                    ..add(LoadMessagesEvent(chat.id)),
                                  child: ChatScreen(
                                    name: client.profile.name,
                                    image: client.image,
                                    id: client.id,
                                    socketService: socketService,
                                  ),
                                ),
                              ),
                            ),
                            child: MessageCard(
                              socketService: socketService,
                              height: MediaQuery.of(context).size.height,
                              width: MediaQuery.of(context).size.width,
                              lastMessage: chat.lastMessage.text,
                              name: client.profile.name,
                              time: DateFormat('hh:mm a')
                                  .format(chat.lastMessage.createdAt),
                              image: client.image,
                            ),
                          );
                        }
                      },
                    );
                  } else {
                    return const Center(child: Text('Error loading chats'));
                  }
                },
              );
            } else {
              return const SizedBox.shrink();
            }
          },
        ),
      ),
    );
  }
}
