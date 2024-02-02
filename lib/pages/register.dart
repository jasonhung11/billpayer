import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:test_app/api/userAPI.dart';
import 'package:test_app/main.dart';
import 'package:test_app/pages/login.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  bool _isObscureText = true;
  bool _isEmailValid = true;
  bool _isPasswordValid = true;
  bool _isUsernameValid = true;
  bool _isConfirmPasswordValid = true;
  @override
  void initState() {
    super.initState();
    _isObscureText = true;
    // bool _isEmailValid = true;
    // bool _isPasswordValid = true;
  }

  void setTextFieldError(bool setValue) {
    _isEmailValid = setValue;
    _isPasswordValid = setValue;
    _isUsernameValid = setValue;
    _isConfirmPasswordValid = setValue;
  }

  final registerSuccessMessage = SnackBar(
    content: Text("Registered!"),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // extendBodyBehindAppBar: true,
        body: SafeArea(
            child: Container(
                padding: const EdgeInsets.only(left: 15, right: 15.0, top: 5),
                child: Column(children: [
                  const Spacer(),
                  const Text(
                    "Register to Billpayer",
                    style: TextStyle(fontSize: 30),
                  ),
                  const Spacer(),
                  Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: TextField(
                        controller: emailController,
                        decoration: InputDecoration(
                          labelText: 'Email',
                          border: OutlineInputBorder(),
                          hintText: 'Email',
                          errorText:
                              _isEmailValid ? null : "Value Can't Be Empty",
                        ),
                      )),
                  Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: TextField(
                        controller: usernameController,
                        decoration: InputDecoration(
                          labelText: 'Username',
                          border: OutlineInputBorder(),
                          hintText: 'Username',
                          errorText:
                              _isUsernameValid ? null : "Value Can't Be Empty",
                        ),
                      )),
                  Padding(
                      padding: const EdgeInsets.only(bottom: 15),
                      child: TextField(
                        controller: passwordController,
                        obscureText: _isObscureText,
                        enableSuggestions: false,
                        autocorrect: false,
                        decoration: InputDecoration(
                          suffixIcon: IconButton(
                              onPressed: () => {
                                    setState(() {
                                      _isObscureText = !_isObscureText;
                                    })
                                  },
                              icon: const Icon(Icons.visibility)),
                          labelText: 'Password',
                          border: const OutlineInputBorder(),
                          hintText: 'Password',
                          errorText:
                              _isPasswordValid ? null : "Value Can't Be Empty",
                        ),
                      )),
                  Padding(
                      padding: EdgeInsets.only(bottom: 15),
                      child: TextField(
                        controller: confirmPasswordController,
                        obscureText: true,
                        enableSuggestions: false,
                        autocorrect: false,
                        decoration: InputDecoration(
                          // suffixIcon: IconButton(
                          //     onPressed: () => {
                          //           setState(() {
                          //             _isObscureText = !_isObscureText;
                          //           })
                          //         },
                          //     icon: Icon(Icons.visibility)),
                          labelText: 'Confirm Password',
                          border: OutlineInputBorder(),
                          hintText: 'Confirm Password',
                          errorText: _isConfirmPasswordValid
                              ? null
                              : "Value Can't Be Empty",
                        ),
                      )),
                  ElevatedButton(
                    // style: style,
                    onPressed: () async => {
                      if (emailController.text.trim() == "")
                        {
                          setState(
                            () => _isEmailValid = false,
                          )
                        },
                      if (usernameController.text.trim() == "")
                        {
                          setState(
                            () => _isUsernameValid = false,
                          )
                        },
                      //password requirement
                      if (passwordController.text.length <= 8)
                        {
                          setState(
                            () => _isPasswordValid = false,
                          )
                        }
                      else if (passwordController.text !=
                          confirmPasswordController.text)
                        {
                          setState(
                            () => {
                              _isPasswordValid = false,
                              _isConfirmPasswordValid = false
                            },
                          )
                        }
                      else
                        {
                          setTextFieldError(true),
                          if (await register({
                                "username": usernameController.text,
                                "email": emailController.text,
                                // need hash password
                                "password": passwordController.text
                              }) !=
                              null)
                            // display successful message
                            {
                              print("Register successfully"),
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(registerSuccessMessage),
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const LoginPage()),
                              )
                            }
                          else
                            {
                              // show Register fail messageß
                              print("Register fail")
                            }
                        }
                    },
                    child: const Text('Register'),
                  ),
                  const Spacer(),
                  const Text("Already have Account?"),
                  TextButton(
                      onPressed: () => {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const LoginPage()),
                            )
                          },
                      child: const Text("Login")),
                  const Spacer(),
                ]))));
  }
}
