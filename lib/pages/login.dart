import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test_app/api/userAPI.dart';
import 'package:test_app/main.dart';
import 'package:test_app/pages/register.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool _isObscureText = true;
  bool _isEmailValid = true;
  bool _isPasswordValid = true;
  String userName = "";
  void enterHomePage() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const MyHomePage()),
    );
  }

  void setUserDetail(String userId, String userName) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      prefs.setString('userId', userId);
      prefs.setString('username', userName);
    });
  }

  @override
  void initState() {
    super.initState();
    _isObscureText = true;
  }

  @override
  Widget build(BuildContext context) {
    User? user;
    return Scaffold(
        // extendBodyBehindAppBar: true,
        body: SafeArea(
            child: Container(
                padding: const EdgeInsets.only(left: 15, right: 15.0, top: 5),
                child: Column(children: [
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
                              icon: Icon(Icons.visibility)),
                          labelText: 'Password',
                          border: OutlineInputBorder(),
                          hintText: 'Password',
                          errorText:
                              _isPasswordValid ? null : "Value Can't Be Empty",
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
                      if (passwordController.text.trim() == "")
                        {
                          setState(
                            () => _isPasswordValid = false,
                          )
                        }
                      else
                        {
                          user = await loginWithPassword(
                              emailController.text, passwordController.text),
                          userName = user!.displayName == null
                              ? ""
                              : user!.displayName!,
                          print(userName + "userNameeeee"),
                          if (user != null)
                            {
                              print("userIdaaaaa: " +
                                  user!.uid +
                                  " user!.displayName:" +
                                  userName),
                              setUserDetail(user!.uid, userName),
                              print("login successfully"),
                              enterHomePage()
                            }
                          else
                            {
                              // show login fail message
                              print("login fail")
                            }
                        }
                    },
                    child: const Text('Login'),
                  ),
                  const Padding(padding: EdgeInsets.only(bottom: 10)),
                  TextButton(
                    onPressed: () async {
                      try {
                        final user = await loginWithGoogle();
                        if (user != null) {
                          enterHomePage();
                        }
                      } on FirebaseAuthException catch (e) {
                        print(e);
                      } catch (e) {
                        print(e.toString() + "fasd");
                      }
                    },
                    style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        minimumSize: Size(50, 30),
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        alignment: Alignment.centerLeft),
                    child: const Text('Login With Google'),
                  ),
                  const Padding(padding: EdgeInsets.only(bottom: 10)),
                  TextButton(
                    onPressed: () async {
                      // register
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const RegisterPage()),
                      );
                    },
                    style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        minimumSize: const Size(50, 30),
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        alignment: Alignment.centerLeft),
                    child: const Text('Register'),
                  ),
                  const Spacer(),
                ]))));
  }
}
