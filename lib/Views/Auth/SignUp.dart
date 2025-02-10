import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:notes_app_firebase/Widget/Custom%20_Logo.dart';
import 'package:notes_app_firebase/Widget/Custom_Material_Button.dart';
import 'package:notes_app_firebase/Widget/Text_Form.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  GlobalKey<FormState> formstate = GlobalKey<FormState>();
  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();
  final TextEditingController username = TextEditingController();
  bool isvisibelP = true;
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.only(left: 10, right: 15),
        child: ListView(
          children: [
            Form(
              key: formstate,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(height: 50),
                  const CustomLogo(),
                  const Center(
                    child: Text(
                      'SignUp',
                      style: TextStyle(
                          fontSize: 40,
                          color: Colors.black,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  Container(height: 10),
                  const Text(
                    'Enter Your Personal Information',
                    style: TextStyle(fontSize: 22, color: Colors.grey),
                  ),
                  Container(height: 10),
                  const Text(
                    'Username',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                  ),
                  Container(height: 10),
                  CustomTextForm(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'This Field cannot be empty';
                      }
                      return null;
                    },
                    label: 'Username',
                    controler: username,
                    icon: const Icon(Icons.person),
                  ),
                  Container(height: 10),
                  const Text(
                    'Email',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                  ),
                  Container(height: 10),
                  CustomTextForm(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'This Field cannot be empty';
                      }
                      return null;
                    },
                    label: 'Email',
                    controler: email,
                    icon: const Icon(Icons.email),
                  ),
                  Container(height: 10),
                  const Text(
                    'Password',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                  ),
                  Container(height: 10),
                  CustomTextForm(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'This Field cannot be empty';
                      }
                      return null;
                    },
                    label: 'Password',
                    controler: password,
                    obsecure: isvisibelP ? true : false,
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          isvisibelP = !isvisibelP;
                        });
                      },
                      icon: Icon(
                          isvisibelP ? Icons.visibility_off : Icons.visibility),
                    ),
                  ),
                  Container(height: 30),
                  CustomMaterialButton(
                    title: 'SignUp',
                    icon: const Icon(
                      Icons.logout,
                      color: Colors.white,
                      size: 22,
                    ),
                    onpressed: () async {
                      if (formstate.currentState?.validate() ?? false) {
                        try {
                          final credential = await FirebaseAuth.instance
                              .createUserWithEmailAndPassword(
                            email: email.text,
                            password: password.text,
                          );
                          FirebaseAuth.instance.currentUser!
                              .sendEmailVerification();
                          Navigator.of(context).pushReplacementNamed('Login');
                        } on FirebaseAuthException catch (e) {
                          if (e.code == 'weak-password') {
                            print('Your password is too weak');
                            AwesomeDialog(
                              context: context,
                              dialogType: DialogType.info,
                              animType: AnimType.rightSlide,
                              title: 'Error',
                              desc: 'Your password is too weak',
                              btnCancelOnPress: () {},
                              btnOkOnPress: () {},
                            ).show();
                          } else if (e.code == 'email-already-in-use') {
                            print('The account already exists for that email.');
                            AwesomeDialog(
                              context: context,
                              dialogType: DialogType.info,
                              animType: AnimType.rightSlide,
                              title: 'Error',
                              desc:
                                  'The account already exists for that email.',
                              btnCancelOnPress: () {},
                              btnOkOnPress: () {},
                            ).show();
                          }
                        } catch (e) {
                          print(e);
                        }
                      } else {
                        print('Null Value');
                      }
                    },
                  ),
                  Container(height: 5),
                  InkWell(
                    onTap: () {
                      Navigator.of(context).pushReplacementNamed('Login');
                    },
                    child: const Center(
                      child: Text.rich(
                        TextSpan(children: [
                          TextSpan(
                            text: 'You Have An Account?  ',
                            style: TextStyle(fontSize: 17),
                          ),
                          TextSpan(
                            text: 'Login',
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
            ),
          ],
        ),
      ),
    );
  }
}

