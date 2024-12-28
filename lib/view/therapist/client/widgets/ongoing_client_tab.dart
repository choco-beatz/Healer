import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:healer_therapist/bloc/therapist/therapist_bloc.dart';
import 'package:healer_therapist/view/therapist/client/widgets/client_card_ongoing.dart';
import 'package:healer_therapist/view/therapist/client/widgets/client_detail.dart';
import 'package:healer_therapist/view/therapist/client/widgets/empty.dart';

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
        final clients = state.list;
        if (clients.isEmpty) {
          return const Center(child: EmptyClient());
        }
        return ListView.builder(
          itemCount: clients.length,
          itemBuilder: (context, index) {
            final client = clients[index];
            return GestureDetector(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ClientDetails(client: client),
                ),
              ),
              child: ClientCardOngoing(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                client: client,
              ),
            );
          },
        );
      },
    );
  }

  @override
  bool get wantKeepAlive => true; // Keeps this widget alive.
}
