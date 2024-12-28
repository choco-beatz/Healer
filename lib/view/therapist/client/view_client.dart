import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:healer_therapist/bloc/therapist/therapist_bloc.dart';
import 'package:healer_therapist/constants/colors.dart';
import 'package:healer_therapist/view/therapist/client/widgets/client_request_tab.dart';
import 'package:healer_therapist/view/therapist/client/widgets/ongoing_client_tab.dart';

class ViewClient extends StatefulWidget {
  const ViewClient({super.key});

  @override
  State<ViewClient> createState() => _ViewClientState();
}

class _ViewClientState extends State<ViewClient>
    with SingleTickerProviderStateMixin {
  late TabController tabController;
  @override
  void initState() {
    super.initState();
    context.read<TherapistBloc>().add(OnGoingClientEvent());
    context.read<TherapistBloc>().add(FetchRequestEvent());
    tabController = TabController(length: 2, vsync: this);
    tabController.addListener(() {
      if (!tabController.indexIsChanging) {
        log('Tab changed to index: ${tabController.index}');
        if (mounted) {
          switch (tabController.index) {
            case 0:
              context.read<TherapistBloc>().add(OnGoingClientEvent());

              break;
            case 1:
              context.read<TherapistBloc>().add(FetchRequestEvent());
              break;
          }
        }
      }
    });
    // context.read<ClientBloc>().add(FetchClientEvent());
  }

  @override

  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 0,
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Therapists',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
          ),
          leading: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: const Icon(Icons.chevron_left, size: 30),
          ),
          backgroundColor: white,
          bottom: TabBar(
            controller: tabController,
            dividerColor: white,
            labelColor: white,
            unselectedLabelColor: main1,
            indicator: BoxDecoration(
                borderRadius: BorderRadius.circular(10), color: main1),
            tabs: const [
              Tab(text: "               On Going               "),
              Tab(text: "               Requests                "),
            ],
          ),
        ),
        body: TabBarView(
          controller: tabController,
          children: const [
            OnGoingClientsTab(),
            ClientRequestsTab(),
          ],
        ),
      ),
    );
  }
}
