import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:healer_therapist/bloc/chat/chat_bloc.dart';
import 'package:healer_therapist/bloc/therapist/therapist_bloc.dart';
import 'package:healer_therapist/services/chat/socket.dart';
import 'package:healer_therapist/view/therapist/chat/screens/contacts.dart';
import 'package:healer_therapist/view/therapist/chat/widgets/message_card.dart';
import 'package:healer_therapist/widgets/empty.dart';
import 'package:healer_therapist/widgets/floating_button.dart';
import 'package:healer_therapist/view/therapist/chat/screens/message_screen.dart';
import 'package:healer_therapist/widgets/appbar.dart';
import 'package:healer_therapist/widgets/loading.dart';
import 'package:intl/intl.dart';

class Inbox extends StatelessWidget {
  final SocketService socketService;
  const Inbox({super.key, required this.socketService});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // log('ChatEvent');
      context.read<ChatBloc>().add(LoadChatsEvent());
    });
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(50),
        child: CommonAppBar(
          title: 'Inbox',
        ),
      ),
      body: BlocBuilder<ChatBloc, ChatState>(
        builder: (context, state) {
          if (state is ChatLoading) {
            return const Loading();
          } else if (state is ChatsLoaded) {
            final chats = state.chats;
            if (chats.isEmpty) {
              return const Empty(
                  title: "Your Inbox is Empty",
                  subtitle:
                      "No messages yet! Conversations with your clients will appear here.",
                  image: 'asset/emptyInbox.jpg');
            }
            return ListView.builder(
              itemCount: chats.length,
              itemBuilder: (context, index) {
                final chat = chats[index];
                final participant = chat.participants.first;
                final lastMessageText = chat.lastMessage.text;

                return InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => BlocProvider(
                                create: (context) =>
                                    ChatBloc()..add(LoadMessagesEvent(chat.id)),
                                child: ChatScreen(
                                  name: participant.profile.name,
                                  image: participant.image,
                                  id: chat.lastMessage.to,
                                  socketService: socketService,
                                ))));
                  },
                  child: MessageCard(
                    socketService: socketService,
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    lastMessage: lastMessageText,
                    name: participant.profile.name,
                    time: DateFormat('hh:mm a')
                        .format(chat.lastMessage.createdAt),
                    image: participant.image,
                  ),
                );
              },
            );
          } else if (state is ChatError) {
            return Center(child: Text(state.error));
          } else {
            return const Center(child: Text('No data available.'));
          }
        },
      ),
      floatingActionButton: FloatingButton(
        text: ' Start a new chat',
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => MultiBlocProvider(
                    providers: [
                      BlocProvider(
                        create: (context) =>
                            TherapistBloc()..add(OnGoingClientEvent()),
                      ),
                      BlocProvider(
                        create: (context) => ChatBloc()..add(LoadChatsEvent()),
                      ),
                    ],
                    child: Contact(
                      socketService: socketService,
                    ),
                  )),
        ),
      ),
    );
  }
}
