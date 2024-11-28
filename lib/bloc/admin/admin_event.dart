// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'admin_bloc.dart';

class AdminEvent {}

// class LoginEvent extends AdminEvent {
//   LoginModel data;
//   LoginEvent({
//     required this.data,
//   });
// }

// class CkeckTokenEvent extends AdminEvent {}

class FetchTherapistEvent extends AdminEvent {}

class PickImageEvent extends AdminEvent {}

class AddTherapistEvent extends AdminEvent {
  TherapistModel therapist;
  File? imageFile;
  AddTherapistEvent({
    required this.therapist,
    this.imageFile,
  });
}

class EditTherapistEvent extends AdminEvent {
  TherapistModel therapist;
  String id;
  File? imageFile;
  EditTherapistEvent({
    required this.therapist,
    required this.id,
    this.imageFile,
  });
}

class DeleteTherapistEvent extends AdminEvent {
  String id;
  DeleteTherapistEvent({
    required this.id,
  });
}

class SearchTherapistEvent extends AdminEvent {
  final String searchText;

  SearchTherapistEvent(this.searchText);
}

class LogOutEvent extends AdminEvent {}