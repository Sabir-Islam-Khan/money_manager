import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:money_manager/wrapper.dart';

import 'package:provider/provider.dart';

import '../../services/auth_service.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
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
              child: CircularProgressIndicator(color: Colors.greenAccent),
            ),
          )
        : Scaffold(
            appBar: AppBar(
              elevation: 0.0,
              backgroundColor: Colors.transparent,
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
                      "Sign Up",
                      style: GoogleFonts.roboto(
                          fontSize: 20, fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(
                      height: 7,
                    ),
                    Text(
                      "Create an account to start using the Money Manager",
                      style:
                          GoogleFonts.roboto(fontSize: 12, color: Colors.grey),
                    ),
                    const SizedBox(
                      height: 30,
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
                            "Email",
                            style: TextStyle(color: Colors.grey),
                          ),
                          const SizedBox(
                            width: 57,
                          ),
                          Flexible(
                            child: TextField(
                              controller: _emailController,
                              textInputAction: TextInputAction.next,
                              decoration: const InputDecoration.collapsed(
                                  hintText: "johndoe@example.com"),
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
                                  setState(() {
                                    isObsecured = !isObsecured;
                                  });
                                },
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 10,
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
                            isLoading = true;

                            authService.createUserWithEmailAndPassword(
                                _emailController.text,
                                _passwordController.text,
                                context);

                            isLoading = false;
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
