import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:healer_therapist/bloc/appointment/appointment_bloc.dart';
import 'package:healer_therapist/constants/colors.dart';
import 'package:healer_therapist/constants/space.dart';
import 'package:healer_therapist/constants/textstyle.dart';
import 'package:healer_therapist/model/appointment/appointment_model.dart';
import 'package:intl/intl.dart';
import '../../appointment/widgets/request_button.dart';

class AppointmentRespondCard extends StatefulWidget {
  const AppointmentRespondCard({
    super.key,
    required this.appointment,
    required this.height,
    required this.width,
  });

  final double height;
  final double width;
  final AppointmentModel appointment;

  @override
  State<AppointmentRespondCard> createState() => _AppointmentRespondCardState();
}

class _AppointmentRespondCardState extends State<AppointmentRespondCard> {
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
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Card(
          color: white,
          child: SizedBox(
            height: widget.height * 0.22,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                        padding: const EdgeInsets.only(left: 15),
                        child: CircleAvatar(
                            backgroundColor: transparent,
                            radius: widget.width * 0.14,
                            child: (widget.appointment.client.image
                                        .split('.')
                                        .last ==
                                    'png')
                                ? Image.network(
                                    fit: BoxFit.fitHeight,
                                    widget.appointment.client.image,
                                    width: 80,
                                    height: 80,
                                  )
                                : ClipOval(
                                    child: Image.network(
                                      fit: BoxFit.fitHeight,
                                      widget.appointment.client.image,
                                      width: 80,
                                      height: 80,
                                    ),
                                  ))),
                    SizedBox(
                      width: widget.width * 0.62,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          smallSpace,
                          Text(widget.appointment.client.profile.name,
                              style: smallBold),
                          smallSpace,
                          Text(
                            DateFormat('dd MMM yyyy')
                                .format(DateTime.parse(widget.appointment.date))
                                .toUpperCase(),
                            style: textFieldStyle,
                          ),
                          smallSpace,
                          Chip(
                            side: BorderSide.none,
                            backgroundColor: main1trans,
                            label: Text(
                                '${widget.appointment.startTime} - ${widget.appointment.endTime}',
                                style: colorTextStyle),
                          ),
                          smallSpace,
                        ],
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    InkWell(
                        onTap: () => _handleResponse(context, 'accepted'),
                        child: buildButton(text: 'Accept')),
                    InkWell(
                        onTap: () => _handleResponse(context, 'cancelled'),
                        child: buildButton(text: 'Decline', imp: true))
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
