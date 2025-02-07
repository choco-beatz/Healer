import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:healer_therapist/bloc/admin/admin_bloc.dart';
import 'package:healer_therapist/constants/colors.dart';
import 'package:healer_therapist/constants/snackbar.dart';
import 'package:healer_therapist/view/admin/add_therapist/add_therapist_screen.dart';
import 'package:healer_therapist/widgets/empty.dart';
import 'package:healer_therapist/widgets/floating_button.dart';
import 'package:healer_therapist/view/admin/admin_home/widgets/home_app_bar.dart';
import 'package:healer_therapist/view/admin/admin_home/widgets/therapist_card.dart';
import 'package:healer_therapist/view/login/login_screen.dart';
import 'package:healer_therapist/view/admin/view_therapist/view_therapist_screen.dart';
import 'package:healer_therapist/widgets/drawer.dart';
import 'package:healer_therapist/widgets/loading.dart';

class AdminHome extends StatefulWidget {
  const AdminHome({super.key});

  @override
  State<AdminHome> createState() => _AdminHomeState();
}

class _AdminHomeState extends State<AdminHome> {
  @override
  void initState() {
    super.initState();
    context.read<AdminBloc>().add(CkeckTokenEvent());
    context.read<AdminBloc>().add(FetchTherapistEvent());
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
              return const Loading();
            }

            // When therapists list is empty and no search query is present, show EmptyTherapist.
            if (state.list.isEmpty && state.searchQuery.isEmpty) {
              return const Center(
                  child: Empty(
                title: 'No Therapist Found',
                subtitle: 'Add a therapist to view them here',
                image: 'asset/emptyOngoing.jpg',
              ));
            }

            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                HomeAppBar(height: height, width: width),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      children: [
                        // Search Bar
                        CupertinoSearchTextField(
                          padding: const EdgeInsets.all(15),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: fieldBG,
                            border: Border.all(color: border, width: 1.5),
                          ),
                          onChanged: (value) => context
                              .read<AdminBloc>()
                              .add(SearchTherapistEvent(value)),
                        ),
                        // Therapist List
                        Expanded(child: BlocBuilder<AdminBloc, AdminState>(
                          builder: (context, state) {
                            final therapists = state.searchQuery.isEmpty
                                ? state.list
                                : state.searchResults;

                            // Show "No results found" if search query is not empty and there are no results
                            if (state.searchQuery.isNotEmpty &&
                                state.searchResults.isEmpty) {
                              return const Center(
                                  child: Text("No results found"));
                            }

                            // Show the therapist list
                            return GridView.builder(
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                childAspectRatio:
                                    0.75, // Adjusted for better spacing
                                mainAxisSpacing:
                                    0, // Reduced space between rows
                                crossAxisSpacing:
                                    0, // Consistent spacing between columns
                              ),
                              itemCount: therapists.length,
                              itemBuilder: (context, index) {
                                final therapist = therapists[index];
                                return GestureDetector(
                                  onTap: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          ViewTherapist(therapist: therapist),
                                    ),
                                  ),
                                  child: TherapistCard(
                                    height: height, // Adjusted height
                                    width: width, // Adjusted width
                                    therapist: therapist,
                                  ),
                                );
                              },
                            );
                          },
                        )),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
        floatingActionButton: FloatingButton(
          text: 'Add Therapist',
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AddTherapist()),
            );
          },
        ),
      ),
    );
  }
}
