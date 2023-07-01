import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:volunteer_app/firebase/firebase_helper.dart';
import 'package:volunteer_app/modules/login/log_in.dart';

import '../../cubit/volunteer_cubit.dart';
import '../../cubit/volunteer_states.dart';

class SignUp extends StatelessWidget {
  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();
  final TextEditingController phone = TextEditingController();
  final TextEditingController full_name = TextEditingController();
  final TextEditingController national_id = TextEditingController();

  final GlobalKey<FormState> formkey = GlobalKey<FormState>();
  final FirebaseAuth auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => VolunteerCubit(),
      child: BlocConsumer<VolunteerCubit, VolunteerState>(
        listener: (context, state) {},
        builder: (context, state) {
          VolunteerCubit cubit = VolunteerCubit.get(context);
          return Scaffold(
            appBar: AppBar(
              title: const Text("Sign up"),
              centerTitle: true,
            ),
            body: SingleChildScrollView(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                child: Form(
                  key: formkey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 100),
                      const Text(
                        "Sing up: ",
                        style: TextStyle(fontSize: 25),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        validator: (String? val) {
                          if (val!.isEmpty) {
                            return "Email is required";
                          }
                          if (!val.contains("@")) {
                            return "Invalid Email formate";
                          }
                          return null;
                        },
                        controller: email,
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.email),
                          labelText: "E-mail",
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        validator: (String? val) {
                          if (val!.isEmpty) {
                            return "password is required";
                          }
                          return null;
                        },
                        obscureText: cubit.hidden,
                        controller: password,
                        keyboardType: TextInputType.visiblePassword,
                        decoration: InputDecoration(
                          suffixIcon: IconButton(
                            icon: cubit.hidden
                                ? const Icon(Icons.visibility)
                                : const Icon(Icons.visibility_off),
                            onPressed: () {
                              cubit.changeVisibilty();
                            },
                          ),
                          labelText: "Password",
                          border: const OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        validator: (String? val) {
                          if (val!.isEmpty) {
                            return "phone is required";
                          }
                          if (val.length != 11) {
                            return "invalid phone number";
                          }
                          String start = val.substring(0, 3);
                          if (!(start.contains("011") ||
                              start.contains("012") ||
                              start.contains("010") ||
                              start.contains("015"))) {
                            return "invalid phone number";
                          }
                          return null;
                        },
                        controller: phone,
                        keyboardType: TextInputType.phone,
                        decoration: const InputDecoration(
                          labelText: "phone",
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        validator: (String? val) {
                          if (val!.isEmpty) {
                            return "name is required";
                          }
                          return null;
                        },
                        controller: full_name,
                        keyboardType: TextInputType.name,
                        decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.person),
                          labelText: "Full name",
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        validator: (String? val) {
                          if (val!.isEmpty) {
                            return "national ID is required";
                          }
                          if (val.length != 14) {
                            return "Invalid national ID ";
                          }
                          return null;
                        },
                        controller: national_id,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: "national ID ",
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Container(
                        width: double.infinity,
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        decoration: const BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.all(
                            Radius.circular(40),
                          ),
                        ),
                        child: MaterialButton(
                          onPressed: () async {
                            if (formkey.currentState!.validate()
                                ? true
                                : false) {
                              FirebaseHelper.signUp(
                                email: email.text.trim(),
                                password: password.text.trim(),
                                context: context,
                                nationalId: national_id.text.trim(),
                                fullName: full_name.text.trim(),
                                phone: phone.text.trim(),
                                key: "",
                              );
                            }
                          },
                          child: Text(
                            "sign up ".toUpperCase(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text("do you already have an "),
                          TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => Login(),
                                ),
                              );
                            },
                            child: const Text("account"),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
