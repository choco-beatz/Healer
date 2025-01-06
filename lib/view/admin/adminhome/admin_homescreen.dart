import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:healer_therapist/bloc/admin/admin_bloc.dart';
import 'package:healer_therapist/constants/colors.dart';
import 'package:healer_therapist/constants/snackbar.dart';
import 'package:healer_therapist/view/admin/addtherapist/add_therapist_screen.dart';
import 'package:healer_therapist/widgets/floating_button.dart';
import 'package:healer_therapist/view/admin/adminhome/widgets/empty.dart';
import 'package:healer_therapist/view/admin/adminhome/widgets/home_app_bar.dart';
import 'package:healer_therapist/view/admin/adminhome/widgets/therapist_card.dart';
import 'package:healer_therapist/view/login/login_screen.dart';
import 'package:healer_therapist/view/admin/viewtherapist/view_therapist_screen.dart';
import 'package:healer_therapist/widgets/drawer.dart';

class AdminHome extends StatefulWidget {
  const AdminHome({super.key});

  @override
  State<AdminHome> createState() => _AdminHomeState();
}

class _AdminHomeState extends State<AdminHome> {
  @override
  void initState() {
    context.read<AdminBloc>().add(CkeckTokenEvent());
    context.read<AdminBloc>().add(FetchTherapistEvent());

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return SafeArea(
        child: Scaffold(
      drawer: const DrawerWidget(),
      body: BlocConsumer<AdminBloc, AdminState>(
        listener: (context, state) {
          log('redirect: ${state.redirectToLogin.toString()}');
          if (state.redirectToLogin == true) {
            Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => LoginScreen()));
          }
          if (state.hasError) {
            ScaffoldMessenger.of(context).showSnackBar(somethingWentWrong);
          }
        },
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          return Column(mainAxisSize: MainAxisSize.min, children: [
            HomeAppBar(height: height, width: width),
            Expanded(
              child: state.list.isEmpty
                  ? const EmptyTherapist()
                  : Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Theme(
                            data: ThemeData(
                                cupertinoOverrideTheme:
                                    const CupertinoThemeData(
                                        primaryColor: Colors.black87)),
                            child: CupertinoSearchTextField(
                              padding: const EdgeInsets.all(15),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color: fieldBG,
                                  border:
                                      Border.all(color: border, width: 1.5)),
                              onChanged: (value) => context
                                  .read<AdminBloc>()
                                  .add(SearchTherapistEvent(value)),
                            ),
                          ),
                          Expanded(child: BlocBuilder<AdminBloc, AdminState>(
                            builder: (context, state) {
                              final therapists = state.searchResults.isEmpty
                                  ? state.list
                                  : state.searchResults;
                              if (therapists.isEmpty) {
                                return const Center(
                                    child: Text("No results found"));
                              }
                              return ListView.builder(
                                  itemCount: therapists.length,
                                  // (state.searchResults.isEmpty
                                  //     ? state.list.length
                                  //     : state.searchResults.length),
                                  itemBuilder: (context, index) {
                                    final therapist = therapists[index];
                                    log(therapist.toString());
                                    return GestureDetector(
                                        onTap: () => Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    ViewTherapist(
                                                        therapist: therapist))),
                                        child: TherapistCard(
                                          height: height,
                                          width: width,
                                          therapist: therapist,
                                        ));
                                  });
                            },
                          ))
                        ],
                      ),
                    ),
            )
          ]);
        },
      ),
      floatingActionButton:  FloatingButton(text: ' Add Therapist',
      onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: ((context) => AddTherapist())));
        },),
    ));
  }
}
