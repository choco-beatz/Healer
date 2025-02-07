import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:healer_therapist/bloc/therapist/therapist_bloc.dart';
import 'package:healer_therapist/constants/colors.dart';
import 'package:healer_therapist/constants/gradient.dart';
import 'package:healer_therapist/constants/space.dart';
import 'package:healer_therapist/constants/textstyle.dart';
import 'package:healer_therapist/model/client/client_model.dart';
import 'package:healer_therapist/view/therapist/client/widgets/request_button.dart';

class ClientCard extends StatelessWidget {
  const ClientCard({
    super.key,
    required this.request,
    required this.height,
    required this.width,
  });

  final double height;
  final double width;
  final RequestModel request;

  @override
  Widget build(BuildContext context) {
    final requestStatus = context.select<TherapistBloc, String?>((bloc) {
      final state = bloc.state;
      if (state is TherapistRequestStatusUpdated) {
        return state.requestStatus[request.id];
      }
      return null;
    });

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Stack(children: [
        _buildBackgroundImage(),
        _buildGradientOverlay(context, requestStatus),
      ]),
    );
  }

  Widget _buildBackgroundImage() {
    return Container(
      height: height * 0.25,
      width: width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        image: DecorationImage(
          image: NetworkImage(request.client.image),
          fit: BoxFit.cover,
          onError: (error, stackTrace) {},
        ),
      ),
    );
  }

  Widget _buildGradientOverlay(BuildContext context, String? requestStatus) {
    return Container(
      height: height * 0.25,
      width: width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [transparent, black.withOpacity(0.7)],
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              request.client.profile.name,
              style: buttonText,
              overflow: TextOverflow.ellipsis,
            ),
            Spacer(),
            requestStatus == "Accepted" || requestStatus == "Declined"
                ? _buildStatusText(requestStatus!)
                : _buildActionButtons(context),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusText(String status) {
    return Container(
      height: 45,
      width: 215,
      decoration: BoxDecoration(
        gradient: status == "Accepted" ? gradient : redGradient,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Center(
        child: Text(
          status,
          style: const TextStyle(
              color: white, fontSize: 20, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  /// Builds the Accept and Decline buttons for pending requests.
  Widget _buildActionButtons(BuildContext context) {
    return Row(
      children: [
        InkWell(
          onTap: () {
            context.read<TherapistBloc>().add(
                  RequestRespondEvent(
                      requestId: request.id, status: "Accepted"),
                );
            context.read<TherapistBloc>().add(OnGoingClientEvent());
          },
          child: buildButton(text: 'Accept'),
        ),
        hSpace,
        InkWell(
          onTap: () {
            context.read<TherapistBloc>().add(
                  RequestRespondEvent(
                      requestId: request.id, status: "Declined"),
                );
                context.read<TherapistBloc>().add(OnGoingClientEvent());
          },
          child: buildButton(text: 'Decline', imp: true),
        ),
      ],
    );
  }
}
