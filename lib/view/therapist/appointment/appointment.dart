import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:healer_therapist/bloc/appointment/appointment_bloc.dart';
import 'package:healer_therapist/constants/colors.dart';
import 'package:healer_therapist/constants/textstyle.dart';
import 'package:healer_therapist/view/therapist/appointment/screens/appointment_respond.dart';
import 'package:healer_therapist/view/therapist/appointment/screens/appointment_schedule.dart';
import 'package:healer_therapist/view/therapist/appointment/screens/appointment_upcoming.dart';

class Appointment extends StatefulWidget {
  const Appointment({super.key});

  @override
  State<Appointment> createState() => _AppoinmentState();
}

class _AppoinmentState extends State<Appointment>
    with SingleTickerProviderStateMixin {
  late TabController tabController;
  @override
  void initState() {
    super.initState();
    // context.read<TherapistBloc>().add(OnGoingClientEvent());
    // context.read<TherapistBloc>().add(FetchRequestEvent());
    tabController = TabController(length: 3, vsync: this);
    tabController.addListener(() {
      if (!tabController.indexIsChanging) {
        log('Tab changed to index: ${tabController.index}');
        if (mounted) {
          switch (tabController.index) {
            case 0:
              // context.read<TherapistBloc>().add(OnGoingClientEvent());

              break;
            case 1:
              // context.read<TherapistBloc>().add(FetchRequestEvent());
              break;
            case 2:
              context.read<AppointmentBloc>().add(FetchSlotsEvent());
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
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Appointments',
            style: smallBold,
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
              Tab(text: "     Upcoming      "),
              Tab(text: "     Requests      "),
              Tab(text: "     Schedule      "),
            ],
          ),
        ),
        body: TabBarView(
          controller: tabController,
          children: const [
            AppointmentStatus(status: 'confirmed'),
            AppointmentRespond(status: 'pending'),
            AppointmentScheduleTab(),
          ],
        ),
      ),
    );
  }
}
