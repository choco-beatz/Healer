import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:healer_therapist/bloc/therapist/therapist_bloc.dart';
import 'package:healer_therapist/constants/colors.dart';
import 'package:healer_therapist/view/therapist/client/screens/client_request_tab.dart';
import 'package:healer_therapist/view/therapist/client/screens/ongoing_client_tab.dart';

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
    tabController = TabController(length: 2, vsync: this);
    tabController.addListener(() {
      if (!tabController.indexIsChanging) {
        log('Tab changed to index: ${tabController.index}');
        if (mounted) {
          switch (tabController.index) {
            case 0:
              Future.microtask(() =>
                  context.read<TherapistBloc>().add(OnGoingClientEvent()));

              break;
            case 1:
              break;
          }
        }
      }
    });
    Future.microtask(
        () => context.read<TherapistBloc>().add(OnGoingClientEvent()));
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 0,
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Clients',
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
          children: [
            BlocProvider(
              create: (context) => TherapistBloc()..add(OnGoingClientEvent()),
              child: const OnGoingClientsTab(),
            ),
            BlocProvider(
              create: (context) => TherapistBloc()..add(FetchRequestEvent()),
              child: const ClientRequestsTab(),
            ),
          ],
        ),
      ),
    );
  }
}
