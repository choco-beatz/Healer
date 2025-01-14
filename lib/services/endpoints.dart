import 'package:healer_therapist/constants/constant.dart';

const loginUrl = '${baseUrl}auth/login';

const listTherapistUrl = '${baseUrl}admin/therapist/list';
const addTherapistUrl = '${baseUrl}admin/therapist';
const editTherapistUrl = '${baseUrl}admin/therapist/';
const deleteTherapistUrl = '${baseUrl}admin/therapist/';
const searchTherapistUrl =
    '${baseUrl}admin/search?target=user&role=therapist&query=';
const appointmentRespondUrl = '${baseUrl}appointment/respond';
const slotStatusUrl = '${baseUrl}appointment/therapist?status=';
const requestStatusUrl = '${baseUrl}requests/therapist?status=';
const requestRespondUrl = '${baseUrl}requests/respond';
const slotUrl = '${baseUrl}slots';
const profileUrl = '${baseUrl}user/profile';
const inboxUrl = '${baseUrl}chats';
