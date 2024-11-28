
import 'dart:developer';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:healer_therapist/model/therapist/therapist_model.dart';
import 'package:healer_therapist/services/admin/admin_service.dart';
import 'package:healer_therapist/services/token.dart';
import 'package:image_picker/image_picker.dart';

part 'admin_event.dart';
part 'admin_state.dart';

class AdminBloc extends Bloc<AdminEvent, AdminState> {
  final ImagePicker imagePicker = ImagePicker();
  

  AdminBloc() : super(AdminInitial(list: [])) {
    // tokenCheck = Stream.periodic(
    //   const Duration(minutes: 15),
    //   (_) => CkeckTokenEvent(),
    // ).listen(
    //   (event) {
    //     add(event);
    //   },
    // );

    // on<CkeckTokenEvent>(((event, emit) async {
    //   log(state.tokenValid.toString());

    //   if (state.tokenValid && state.isInitialized) return;
    //   final token = await getValidToken();

    //   if (token == null || isExpired(token)) {
    //     emit(AdminState(
    //         list: state.list,
    //         isLoading: false,
    //         hasError: true,
    //         redirectToLogin: true,
    //         isInitialized: false,
    //         message: '  Token expired!'));
    //   } else if (!isExpired(token)) {
    //     emit(AdminState(
    //         list: state.list,
    //         isLoading: false,
    //         tokenValid: true,
    //         isInitialized: true));
    //   } else {
    //     emit(AdminState(
    //         list: state.list,
    //         isLoading: false,
    //         hasError: true,
    //         redirectToLogin: true,
    //         isInitialized: false,
    //         message: '  Token expired!'));
    //   }
    // }));

    on<FetchTherapistEvent>(
      (event, emit) async {
        if (state.isLoading) return;

        try {
          final therapists = await fetchTherapist();
          log(therapists.toString());
          emit(AdminState(
              list: therapists,
              isLoading: false,
              searchResults: state.searchResults,
              isInitialized: true));
        } catch (e) {
          log(e.toString());
          emit(AdminState(
              list: state.list,
              searchResults: state.searchResults,
              isLoading: false,
              hasError: true,
              isInitialized: false,
              message: e.toString()));
        }
      },
    );

    on<PickImageEvent>((event, emit) async {
      final pickedFile =
          await imagePicker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        emit(AdminState(
          list: state.list,
          isLoading: false,
          pickedImage: File(pickedFile.path),
          isInitialized: state.isInitialized,
        ));
      } else {
        emit(AdminState(
          list: state.list,
          isLoading: false,
          isInitialized: state.isInitialized,
        ));
      }
    });

    on<AddTherapistEvent>(
      (event, emit) async {
        emit(AdminState(list: [], isAdding: true, isLoading: true));
        bool success = await addTherapist(event.therapist, event.imageFile);
        log(success.toString());
        final therapists = await fetchTherapist();
        if (success) {
          emit(AdminState(
              list: therapists,
              isAdding: false,
              isLoading: false,
              isSuccess: success,
              message: '  Therapist added successfully!'));
        } else {
          emit(AdminState(
              list: therapists,
              isAdding: false,
              isLoading: false,
              hasError: true,
              message: '  Failed to add Therapist'));
        }
      },
    );

    on<EditTherapistEvent>(
      (event, emit) async {
        emit(AdminState(list: state.list, isLoading: true));
        bool success =
            await editTherapist(event.therapist, event.imageFile, event.id);
        log(success.toString());
        final therapists = await fetchTherapist();
        if (success) {
          emit(AdminState(
              list: therapists,
              isLoading: false,
              isSuccess: success,
              message: '  Therapist edited successfully!'));
        } else {
          emit(AdminState(
              list: therapists,
              isLoading: false,
              hasError: true,
              message: '  Failed to edit Therapist'));
        }
      },
    );

    on<DeleteTherapistEvent>(
      (event, emit) async {
        emit(AdminState(list: state.list, isLoading: true));
        bool success = await deleteTherapist(event.id);
        log(success.toString());
        final therapists = await fetchTherapist();
        if (success) {
          emit(AdminState(
              list: therapists,
              isLoading: false,
              isSuccess: success,
              message: '  Therapist deleted successfully!'));
        } else {
          emit(AdminState(
              list: therapists,
              isLoading: false,
              hasError: true,
              message: '  Failed to delete Therapist'));
        }
      },
    );

    on<SearchTherapistEvent>((event, emit) async {
      log(event.searchText);
      if (event.searchText.isEmpty) {
        emit(AdminState(
          list: state.list,
          searchResults: state.list,
          isLoading: false,
          hasError: false,
          isInitialized: state.isInitialized,
          message: state.message,
        ));
      } else {
        final filteredResults = await searchTherapist(event.searchText);

        emit(AdminState(
          list: state.list,
          searchResults: filteredResults,
          isLoading: false,
          hasError: false,
          isInitialized: state.isInitialized,
          message: state.message,
        ));
      }
    });

    on<LogOutEvent>((event, emit) async {
      emit(AdminState(
    list: state.list,
    isLoading: true, 
  ));
  
  try {
    await clearToken(); 
    emit(AdminState(
      redirectToLogin: true,
      list: [],
      message: 'Logout successful!',
    ));
  } catch (e) {
    log('Logout failed: $e');

  
    emit(AdminState(
      list: state.list,
      isLoading: false,
      hasError: true,
      message: 'Logout failed. Please try again.',
    ));
  }

    });
  }
}