import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:healer_therapist/bloc/appointment/appointment_bloc.dart';
import 'package:healer_therapist/constants/colors.dart';
import 'package:healer_therapist/constants/space.dart';
import 'package:healer_therapist/constants/textstyle.dart';
import 'package:healer_therapist/view/therapist/appointment/widgets/time_text_field.dart';
import 'package:healer_therapist/widgets/button.dart';
import 'package:healer_therapist/widgets/textformfield.dart';
import 'package:intl/intl.dart';

void showAddSlotDialog(String day, BuildContext context, Map<String, List<Map<String, dynamic>>> weeklySlots) {
  TextEditingController startTimeController = TextEditingController();
  TextEditingController endTimeController = TextEditingController();
  TextEditingController amountController = TextEditingController();
  final GlobalKey<FormState> formkey = GlobalKey<FormState>();

  Future<void> selectTime(
      BuildContext context, TextEditingController controller) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (pickedTime != null) {
      final now = DateTime.now();
      final pickedDateTime = DateTime(
        now.year,
        now.month,
        now.day,
        pickedTime.hour,
        pickedTime.minute,
      );

      final formattedTime = DateFormat("hh:mm a").format(pickedDateTime);

      controller.text = formattedTime;
    }
  }

  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          title: const Text(
            "Set time slot",
            style: smallBold,
            textAlign: TextAlign.center,
          ),
          content: SizedBox(
            width: 300,
            child: Form(
              key: formkey,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Start Time',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                    smallSpace,
                    TextFormField(
                      controller: startTimeController,
                      readOnly: true,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (value) => value == null || value.isEmpty
                          ? 'Please enter the Start Time'
                          : null,
                      decoration: timeTextField(
                        'Start Time',
                        InkWell(
                          onTap: () {
                            selectTime(context, startTimeController);
                          },
                          child: const Icon(Icons.more_time),
                        ),
                      ),
                      cursorColor: Colors.black26,
                      style: textFieldStyle,
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'End Time',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                    smallSpace,
                    TextFormField(
                      controller: endTimeController,
                      readOnly: true,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the End Time';
                      }
                      if (startTimeController.text == value) {
                        return 'Start Time and End Time must not be the same';
                      }
                      final startTime = DateFormat("hh:mm")
                          .parse(startTimeController.text);
                      final endTime = DateFormat("hh:mm").parse(value);
                      if (startTime.isAfter(endTime)) {
                        return 'Start Time must be before End Time';
                      }
                      return null;
                    },
                      decoration: timeTextField(
                        'End Time',
                        InkWell(
                          onTap: () {
                            selectTime(context, endTimeController);
                          },
                          child: const Icon(Icons.more_time, color: textColor),
                        ),
                      ),
                      cursorColor: Colors.black26,
                      style: textFieldStyle,
                    ),
                    space,
                    buildTextFormField(
                      label: "Amount",
                      controller: amountController,
                      validator: (value) => value == null || value.isEmpty
                          ? 'Please enter the End Time'
                          : null,
                    ),
                    space,
                    InkWell(
                        onTap: () {
                          if (formkey.currentState!.validate()) {
                             final existingSlots = weeklySlots[day] ?? [];
                          final newSlot = {
                            'startTime': startTimeController.text,
                            'endTime': endTimeController.text,
                            'amount': int.parse(amountController.text),
                          };

                          final isDuplicate = existingSlots.any((slot) =>
                              slot['startTime'] == newSlot['startTime'] &&
                              slot['endTime'] == newSlot['endTime']);

                          if (isDuplicate) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Slot already exists!'),
                                backgroundColor: Colors.red,
                              ),
                            );
                            return;
                          }

                          context.read<AppointmentBloc>().add(
                                AddTimeSlotEvent(
                                  day,
                                  startTimeController.text,
                                  endTimeController.text,
                                  int.parse(amountController.text),
                                ),
                              );
                          Navigator.of(context).pop();
                          }
                        },
                        child: const Button(text: 'Add'))
                  ],
                ),
              ),
            ),
          ));
    },
  );
}
