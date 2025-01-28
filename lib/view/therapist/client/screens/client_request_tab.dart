import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:healer_therapist/bloc/therapist/therapist_bloc.dart';
import 'package:healer_therapist/view/therapist/client/widgets/client_card.dart';
import 'package:healer_therapist/view/therapist/client/widgets/client_detail.dart';
import 'package:healer_therapist/view/therapist/client/widgets/empty.dart';
import 'package:healer_therapist/widgets/loading.dart';

class ClientRequestsTab extends StatefulWidget {
  const ClientRequestsTab({super.key});

  @override
  ClientRequestsTabState createState() => ClientRequestsTabState();
}

class ClientRequestsTabState extends State<ClientRequestsTab>
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
          return const Center(child: EmptyClient());
        }
        return ListView.builder(
          itemCount: clients.length,
          itemBuilder: (context, index) {
            final request = clients[index];
            return GestureDetector(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ClientDetails(client: request.client),
                ),
              ),
              child: ClientCard(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                request: request,
              ),
            );
          },
        );
      } else if (state is ClientError) {
        return Center(child: Text(state.message));
      } else {
        return const EmptyClient();
      }
    });
  }

  @override
  bool get wantKeepAlive => true; // Keeps this widget alive.
}
