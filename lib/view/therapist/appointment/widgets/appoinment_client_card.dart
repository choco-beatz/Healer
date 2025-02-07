import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:healer_therapist/bloc/appointment/appointment_bloc.dart';
import 'package:healer_therapist/constants/colors.dart';
import 'package:healer_therapist/constants/space.dart';
import 'package:healer_therapist/constants/textstyle.dart';
import 'package:healer_therapist/model/appointment/appointment_model.dart';
import 'package:healer_therapist/view/therapist/appointment/widgets/request_button.dart';
import 'package:intl/intl.dart';

class AppointmentClientCard extends StatefulWidget {
  const AppointmentClientCard({
    super.key,
    required this.appointment,
    required this.height,
    required this.width,
  });

  final double height;
  final double width;
  final AppointmentModel appointment;

  @override
  State<AppointmentClientCard> createState() => _AppointmentClientCardState();
}

class _AppointmentClientCardState extends State<AppointmentClientCard> {
  bool _isVisible = true;

  void _handleResponse(BuildContext context, String status) {
    context.read<AppointmentBloc>().add(
        RespondSlotEvent(appointmentId: widget.appointment.id, status: status));
    setState(() {
      _isVisible = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!_isVisible) return const SizedBox.shrink();

    return AnimatedOpacity(
      duration: const Duration(milliseconds: 300),
      opacity: _isVisible ? 1.0 : 0.0,
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        color: white,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  CircleAvatar(
                    backgroundColor: transparent,
                    radius: widget.width * 0.14,
                    child: ClipOval(
                      child: Image.network(
                        widget.appointment.client.image,
                        width: 80,
                        height: 80,
                        fit: BoxFit.fitHeight,
                      ),
                    ),
                  ),
                  hSpace, // Space between image and text
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(widget.appointment.client.profile.name,
                            style: smallBold),
                        smallSpace,
                        Text(
                          DateFormat('dd MMMM yyyy')
                              .format(DateTime.parse(widget.appointment.date)),
                          style: textFieldStyle,
                        ),
                        smallSpace,
                        Chip(
                          side: BorderSide.none,
                          backgroundColor: main1trans,
                          label: Text(
                            '${widget.appointment.startTime} - ${widget.appointment.endTime}',
                            style: colorTextStyle,
                          ),
                        ),
                        smallSpace,
                      ],
                    ),
                  ),
                ],
              ),

              if (widget.appointment.status == 'pending') ...[
                smallSpace,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    InkWell(
                      onTap: () => _handleResponse(context, 'accepted'),
                      child: buildButton(text: 'Accept'),
                    ),
                    InkWell(
                      onTap: () => _handleResponse(context, 'cancelled'),
                      child: buildButton(text: 'Decline', imp: true),
                    ),
                  ],
                ),
              ] else if (widget.appointment.status == 'accepted') ...[
                smallSpace,
                buildLongButton(text: 'Waiting for Payment'),
              ], // No need for `else` case, as `SizedBox.shrink()` is unnecessary.
            ],
          ),
        ),
      ),
    );
  }
}
