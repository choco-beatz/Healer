import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:healer_therapist/bloc/therapist/therapist_bloc.dart';
import 'package:healer_therapist/services/socket/socket.dart';
import 'package:healer_therapist/view/therapist/chat/widgets/chat_card.dart';
import 'package:healer_therapist/view/therapist/client/widgets/client_detail.dart';
import 'package:healer_therapist/view/therapist/client/widgets/empty.dart';
import 'package:healer_therapist/widgets/appbar.dart';

class Chat extends StatelessWidget {
  final SocketService socketService;

  const Chat({super.key, required this.socketService});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(50),
        child: CommonAppBar(
          title: 'Chat',
        ),
      ),
      body: BlocBuilder<TherapistBloc, TherapistState>(
        builder: (context, state) {
          final clients = state.list;

          if (clients.isEmpty) {
            return const Center(child: EmptyClient());
          }
          return ListView.builder(
            itemCount: clients.length,
            itemBuilder: (context, index) {
              final client = clients[index].client;
              print(client);
              return GestureDetector(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ClientDetails(client: client),
                  ),
                ),
                child: ChatCard(
                  socketService: socketService,
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  client: client,
                ),
              );
            },
          );
        },
      ),
    );
  }
}
