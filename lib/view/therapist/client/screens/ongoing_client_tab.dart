import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:healer_therapist/bloc/therapist/therapist_bloc.dart';
import 'package:healer_therapist/view/therapist/client/widgets/client_card_ongoing.dart';
import 'package:healer_therapist/view/therapist/client/widgets/client_detail.dart';
import 'package:healer_therapist/widgets/empty.dart';
import 'package:healer_therapist/widgets/loading.dart';

class OnGoingClientsTab extends StatefulWidget {
  const OnGoingClientsTab({super.key});

  @override
  OnGoingClientsTabState createState() => OnGoingClientsTabState();
}

class OnGoingClientsTabState extends State<OnGoingClientsTab>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BlocBuilder<TherapistBloc, TherapistState>(
      builder: (context, state) {
        if (state is ClientLoading) {
          return const Loading();
        } else if (state is ClientLoaded) {
          final clients = state.list;
          if (clients.isEmpty) {
            return const Empty(
              title: "No Ongoing Clients",
              subtitle: "Once you start working with clients, their details will appear here.",
              image: "asset/emptyOngoing.jpg",
            );
          }
          return ListView.builder(
            itemCount: clients.length,
            itemBuilder: (context, index) {
              final request = clients[index].client;
              return GestureDetector(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ClientDetails(client: request),
                  ),
                ),
                child: ClientCardOngoing(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  client: request,
                ),
              );
            },
          );
        } else if (state is ClientError) {
          return Center(child: Text(state.message));
        } else {
          return const Empty(
              title: "No Ongoing Clients",
              subtitle: "Once you start working with clients, their details will appear here.",
              image: "asset/emptyOngoing.jpg",
            );
        }
      },
    );
  }

  @override
  bool get wantKeepAlive => true; // Keeps this widget alive.
}
