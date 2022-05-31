import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../services/auth_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool isObsecured = true;
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);

    return isLoading
        ? const Scaffold(
            body: Center(
              child: CircularProgressIndicator(color: Colors.green),
            ),
          )
        : Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0.0,
              leading: GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: const Icon(
                  Icons.arrow_back,
                  color: Colors.black,
                ),
              ),
            ),
            body: SingleChildScrollView(
              child: Container(
                margin: const EdgeInsets.only(left: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 15.0,
                    ),
                    Text(
                      "Welcome Back!",
                      style: GoogleFonts.roboto(
                          fontSize: 20, fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(
                      height: 7,
                    ),
                    Text(
                      "Please Sign in to your account.",
                      style:
                          GoogleFonts.roboto(fontSize: 12, color: Colors.grey),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Container(
                      margin: const EdgeInsets.only(right: 18),
                      padding: const EdgeInsets.only(left: 15),
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: const BorderRadius.all(
                          Radius.circular(5),
                        ),
                      ),
                      height: 50,
                      child: Row(
                        children: [
                          const Text(
                            "Email",
                            style: TextStyle(color: Colors.grey),
                          ),
                          const SizedBox(
                            width: 57,
                          ),
                          Flexible(
                            child: TextField(
                              controller: _emailController,
                              textCapitalization: TextCapitalization.words,
                              textInputAction: TextInputAction.next,
                              decoration: const InputDecoration.collapsed(
                                hintText: "johndoe@example.com",
                              ),
                              keyboardType: TextInputType.text,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      margin: const EdgeInsets.only(right: 18),
                      padding: const EdgeInsets.only(left: 15),
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: const BorderRadius.all(
                          Radius.circular(5),
                        ),
                      ),
                      height: 50,
                      child: Row(
                        children: [
                          const Text(
                            "Password",
                            style: TextStyle(color: Colors.grey),
                          ),
                          const SizedBox(
                            width: 30,
                          ),
                          Flexible(
                            child: TextField(
                              controller: _passwordController,
                              textInputAction: TextInputAction.done,
                              obscureText: isObsecured,
                              decoration: const InputDecoration.collapsed(
                                  hintText: "********"),
                            ),
                          ),
                          ClipOval(
                            child: Material(
                              color: Colors.transparent,
                              child: IconButton(
                                splashColor: Colors.greenAccent,
                                icon: isObsecured
                                    ? const Icon(Icons.visibility_off)
                                    : const Icon(Icons.visibility),
                                onPressed: () {
                                  setState(
                                    () {
                                      isObsecured = !isObsecured;
                                    },
                                  );
                                },
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 10, top: 10.0),
                      child: Align(
                        alignment: Alignment.bottomRight,
                        child: TextButton(
                          child: const Text("Forgot password?"),
                          onPressed: () {
                            // Navigator.push(
                            //   context,
                            //   MaterialPageRoute(
                            //     builder: (context) =>
                            //         const ResetPasswordScreen(),
                            //   ),
                            // );
                          },
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(right: 20),
                      child: SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          child: const Text("Continue"),
                          style: ElevatedButton.styleFrom(
                            primary: Colors.green,
                          ),
                          onPressed: () {
                            if (_emailController.value.text.isEmpty ||
                                _passwordController.value.text.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  backgroundColor: Colors.red,
                                  content: Text(
                                    "Please fill every field",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              );
                            } else {
                              try {
                                setState(() {
                                  isLoading = true;
                                });
                                authService
                                    .signinWithEmailPassword(
                                        _emailController.value.text,
                                        _passwordController.value.text,
                                        context)
                                    .then(
                                  (value) {
                                    Navigator.pop(context);
                                  },
                                );
                                _emailController.clear();
                                _passwordController.clear();
                                setState(() {
                                  isLoading = false;
                                });
                              } catch (e) {
                                log(e.toString(), name: "failed to log in");
                              }
                            }
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
  }
}
