import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:volunteer_app/cubit/volunteer_cubit.dart';
import 'package:volunteer_app/firebase/firebase_helper.dart';

import '../../cubit/volunteer_states.dart';

class Login extends StatelessWidget {
  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => VolunteerCubit(),
      child: BlocConsumer<VolunteerCubit, VolunteerState>(
        listener: (context, state) {},
        builder: (context, state) {
          VolunteerCubit cubit = VolunteerCubit.get(context);
          return Scaffold(
            appBar: AppBar(),
            body: Container(
              width: double.infinity,
              padding: EdgeInsets.all(20),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 100,
                    ),
                    const Text(
                      "Login: ",
                      style: TextStyle(
                        fontSize: 25,
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      validator: (String? val) {
                        if (val!.isEmpty) {
                          return "Emial is required";
                        }
                        if (!val.contains("@")) {
                          return "invalid Email";
                        }
                        return null;
                      },
                      controller: email,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.email),
                        labelText: "Email",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      validator: (String? val) {
                        if (val!.isEmpty) {
                          return "Password is required";
                        }
                        return null;
                      },
                      obscureText: cubit.hiddenLogin,
                      controller: password,
                      keyboardType: TextInputType.visiblePassword,
                      decoration: InputDecoration(
                        suffixIcon: IconButton(
                          onPressed: () {
                            cubit.changeLoginVisiblity();
                          },
                          icon: Icon(cubit.hiddenLogin
                              ? Icons.visibility
                              : Icons.visibility_off),
                        ),
                        labelText: "Password",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(40),
                      ),
                      child: MaterialButton(
                        onPressed: () {
                          FirebaseHelper.login(
                              email: email.text.trim(),
                              password: password.text.trim(),
                              context: context);
                        },
                        child: Text(
                          "login".toUpperCase(),
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
