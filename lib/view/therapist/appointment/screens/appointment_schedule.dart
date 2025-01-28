// import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:healer_therapist/bloc/appointment/appointment_bloc.dart';
import 'package:healer_therapist/constants/colors.dart';
import 'package:healer_therapist/constants/textstyle.dart';
import 'package:healer_therapist/view/therapist/appointment/widgets/add_slot.dart';
import 'package:healer_therapist/view/therapist/appointment/widgets/week_day.dart';
import 'package:healer_therapist/widgets/button.dart';
import 'package:healer_therapist/widgets/loading.dart';

class AppointmentScheduleTab extends StatefulWidget {
  const AppointmentScheduleTab({super.key});

  @override
  State<AppointmentScheduleTab> createState() => _AppointmentState();
}

class _AppointmentState extends State<AppointmentScheduleTab> {
  final List<String> allWeekdays = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday',
  ];

  @override
  void initState() {
    super.initState();
    context.read<AppointmentBloc>().add(FetchSlotsEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: BlocBuilder<AppointmentBloc, AppointmentState>(
            builder: (context, state) {
          if (state is AppointmentLoading) {
            return const Loading();
          } else if (state is AppointmentError) {
            return Center(
              child: Text(
                state.message,
                style: const TextStyle(color: red),
              ),
            );
          } else if (state is AppointmentLoaded) {
            final weeklySlots = state.weeklySlots;
            final isActiveDays = state.isActiveDays;

            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: allWeekdays.length,
                    itemBuilder: (context, index) {
                      String day = allWeekdays[index];
                      final slots = weeklySlots[day] ?? [];
                      final isActive = isActiveDays[day] ?? false;

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Checkbox(
                                activeColor: main1,
                                side: MaterialStateBorderSide.resolveWith(
                                  (Set<MaterialState> states) {
                                    if (!states
                                        .contains(MaterialState.selected)) {
                                      return const BorderSide(
                                          color: main1trans, width: 2);
                                    }
                                    return const BorderSide(color: main1);
                                  },
                                ),
                                value: isActive,
                                onChanged: (value) {
                                  context.read<AppointmentBloc>().add(
                                        ToggleDayActiveEvent(
                                            day, value ?? false),
                                      );
                                },
                              ),
                              weekDays(text: day),
                              const SizedBox(width: 10),
                              Flexible(
                                child: SizedBox(
                                  height: 60,
                                  child: ListView(
                                    scrollDirection: Axis.horizontal,
                                    children: slots.map((slot) {
                                      var times =
                                          '${slot['startTime']}-${slot['endTime']}';
                                      return Padding(
                                        padding:
                                            const EdgeInsets.only(right: 10),
                                        child: Chip(
                                          side: BorderSide.none,
                                          deleteIcon: const Icon(Icons.cancel),
                                          backgroundColor: main1trans,
                                          label: Text(times,
                                              style: colorTextStyle),
                                          deleteIconColor: main1trans,
                                          onDeleted: () {
                                            var splitTimes = times.split('-');
                                            context.read<AppointmentBloc>().add(
                                                  RemoveTimeSlotEvent(
                                                      day,
                                                      splitTimes[0],
                                                      splitTimes[1]),
                                                );
                                          },
                                        ),
                                      );
                                    }).toList(),
                                  ),
                                ),
                              ),
                              IconButton(
                                icon: const Icon(
                                  Icons.add_circle,
                                  color: main1,
                                  size: 30,
                                ),
                                onPressed: () {
                                  showAddSlotDialog(day, context, weeklySlots);
                                },
                              ),
                            ],
                          ),
                        ],
                      );
                    },
                  ),
                ),
                InkWell(
                  onTap: () {
                    if (state.hasChanges) {
                      context.read<AppointmentBloc>().add(SubmitSlotsEvent());
                    }
                  },
                  child: Button(
                    text: 'Apply',
                    deActivate: state.hasChanges == false ? true : false,
                  ),
                ),
              ],
            );
          } else {
            context.read<AppointmentBloc>().add(FetchSlotsEvent());
            return const Loading();
          }
        }),
      ),
    );
  }
}
