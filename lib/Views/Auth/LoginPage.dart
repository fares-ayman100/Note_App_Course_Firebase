import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:notes_app_firebase/Widget/Custom%20_Logo.dart';
import 'package:notes_app_firebase/Widget/Custom_Material_Button.dart';
import 'package:notes_app_firebase/Widget/Text_Form.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool isLoading = false;
  GlobalKey<FormState> formstate = GlobalKey<FormState>();
  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();
  bool isvisibelP = true;

  Future signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    if (googleUser == null) {
      return;
    }

    // Obtain the auth details from the request
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    // Once signed in, return the UserCredential
    await FirebaseAuth.instance.signInWithCredential(credential);
    Navigator.of(context).pushNamedAndRemoveUntil('homePage', (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Container(
              padding: const EdgeInsets.only(left: 15, right: 15),
              child: ListView(
                children: [
                  Form(
                    key: formstate,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 50,
                        ),
                        const CustomLogo(),
                        const Center(
                          child: Text(
                            'Login',
                            style: TextStyle(
                                fontSize: 40,
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        Container(
                          height: 10,
                        ),
                        const Text(
                          'Email',
                          style: TextStyle(
                              fontSize: 22, fontWeight: FontWeight.w500),
                        ),
                        Container(
                          height: 10,
                        ),
                        CustomTextForm(
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'This field cannot be empty';
                            }
                            return null;
                          },
                          label: 'Email',
                          controler: email,
                          icon: const Icon(Icons.email),
                        ),
                        Container(
                          height: 10,
                        ),
                        const Text(
                          'Password',
                          style: TextStyle(
                              fontSize: 22, fontWeight: FontWeight.w500),
                        ),
                        Container(
                          height: 10,
                        ),
                        CustomTextForm(
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'This field cannot be empty';
                            }
                            return null;
                          },
                          label: 'Password',
                          controler: password,
                          icon: const Icon(Icons.lock),
                          obsecure: isvisibelP ? true : false,
                          suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                isvisibelP = !isvisibelP;
                              });
                            },
                            icon: Icon(isvisibelP
                                ? Icons.visibility_off
                                : Icons.visibility),
                          ),
                        ),
                        Container(
                          alignment: Alignment.topRight,
                          child: MaterialButton(
                            onPressed: () {
                              Navigator.of(context)
                                  .pushReplacementNamed('signUp');
                            },
                            child: InkWell(
                              onTap: () async {
                                if (email.text == '') {
                                  AwesomeDialog(
                                    context: context,
                                    dialogType: DialogType.error,
                                    animType: AnimType.rightSlide,
                                    title: 'Error',
                                    desc: 'Please enter your email address.',
                                  ).show();
                                  return;
                                }

                                try {
                                  await FirebaseAuth.instance
                                      .sendPasswordResetEmail(
                                          email: email.text);
                                  AwesomeDialog(
                                    context: context,
                                    dialogType: DialogType.success,
                                    animType: AnimType.rightSlide,
                                    title: 'Success',
                                    desc:
                                        'A password reset email has been sent to your email address.',
                                  ).show();
                                } catch (e) {
                                  AwesomeDialog(
                                    context: context,
                                    dialogType: DialogType.error,
                                    animType: AnimType.rightSlide,
                                    title: 'Error',
                                    desc: 'This email address does not exist.',
                                  ).show();
                                }
                              },
                              child: const Text(
                                'Forgot Password?',
                                textAlign: TextAlign.right,
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.blue,
                                ),
                              ),
                            ),
                          ),
                        ),
                        CustomMaterialButton(
                            title: 'Login',
                            icon: const Icon(
                              Icons.login,
                              color: Colors.white,
                              size: 22,
                            ),
                            onpressed: () async {
                              if (formstate.currentState!.validate()) {
                                try {
                                  setState(() {
                                    isLoading = true;
                                  });

                                  final credential = await FirebaseAuth.instance
                                      .signInWithEmailAndPassword(
                                    email: email.text,
                                    password: password.text,
                                  );

                                  setState(() {
                                    isLoading = false;
                                  });

                                  if (credential.user!.emailVerified) {
                                    Navigator.of(context)
                                        .pushReplacementNamed('homePage');
                                  } else {
                                    AwesomeDialog(
                                      context: context,
                                      dialogType: DialogType.error,
                                      animType: AnimType.rightSlide,
                                      title: 'Error',
                                      desc:
                                          'Please verify your email address before logging in.',
                                    ).show();
                                  }
                                } on FirebaseAuthException catch (e) {
                                  setState(() {
                                    isLoading = false;
                                  });

                                  String errorMessage =
                                      'Incorrect email or password. Please try again.';
                                  if (e.code == 'user-not-found' ||
                                      e.code == 'wrong-password') {
                                    errorMessage =
                                        'Incorrect email or password. Please try again.';
                                  }

                                  AwesomeDialog(
                                    context: context,
                                    dialogType: DialogType.error,
                                    animType: AnimType.rightSlide,
                                    title: 'Login Failed',
                                    desc: errorMessage,
                                  ).show();
                                } catch (e) {
                                  setState(() {
                                    isLoading = false;
                                  });

                                  AwesomeDialog(
                                    context: context,
                                    dialogType: DialogType.error,
                                    animType: AnimType.rightSlide,
                                    title: 'Error',
                                    desc:
                                        'An unexpected error occurred. Please try again.',
                                  ).show();
                                }
                              }
                            }),
                        Container(
                          height: 13,
                        ),
                        const Center(
                          child: Text(
                            'OR Login with',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                        Container(
                          height: 20,
                        ),
                        Row(
                          children: [
                            const SizedBox(
                              width: 30,
                            ),
                            SizedBox(
                              height: 70,
                              width: 70,
                              child: MaterialButton(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(60),
                                ),
                                color: Colors.white,
                                onPressed: () {},
                                child: Image.asset(
                                  'assets/facebook.webp',
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 30,
                            ),
                            SizedBox(
                              height: 70,
                              width: 70,
                              child: MaterialButton(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(60),
                                ),
                                color: Colors.white,
                                onPressed: () {
                                  signInWithGoogle();
                                },
                                child: Image.asset(
                                  'assets/google.jpeg',
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 30,
                            ),
                            SizedBox(
                              height: 70,
                              width: 70,
                              child: MaterialButton(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(60),
                                ),
                                color: Colors.white,
                                onPressed: () {},
                                child: Image.asset(
                                  'assets/apple.png',
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 30,
                            ),
                          ],
                        ),
                        Container(
                          height: 8,
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.of(context)
                                .pushReplacementNamed('signUp');
                          },
                          child: const Center(
                            child: Text.rich(
                              TextSpan(children: [
                                TextSpan(
                                  text: 'Don\'t have an account?  ',
                                  style: TextStyle(fontSize: 17),
                                ),
                                TextSpan(
                                  text: 'Register',
                                  style: TextStyle(
                                      fontSize: 20,
                                      color: Colors.blue,
                                      fontWeight: FontWeight.bold),
                                ),
                              ]),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
    );
  }
}
