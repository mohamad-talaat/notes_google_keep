import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:notes_google_keep/home_page.dart';
import 'package:notes_google_keep/register_page.dart';
import 'package:notes_google_keep/widgets.dart';

Future<Object?> signInWithGoogle() async {
  // Trigger the authentication flow
  final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

  if (googleUser == null) {
    return 0;
  }

  // Obtain the auth details from the request
  final GoogleSignInAuthentication? googleAuth =
      await googleUser?.authentication;

  // Create a new credential
  final credential = GoogleAuthProvider.credential(
    accessToken: googleAuth?.accessToken,
    idToken: googleAuth?.idToken,
  );

  // Once signed in, return the UserCredential
  await FirebaseAuth.instance.signInWithCredential(credential);
  return Get.off(HomePage());
}

class loginPage extends StatelessWidget {
  final FormKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  ShowPasswordClass controller = Get.put(ShowPasswordClass());
  // SettingServices myservices =Get.put(SettingServices());

  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.grey[100],
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                margin: const EdgeInsets.all(20),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(color: Colors.white, boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    spreadRadius: 1,
                    blurRadius: 7,
                    offset: const Offset(0, 3), // changes position of shadow
                  ),
                ]),
                child: Column(
                  children: [
                    const SizedBox(
                      height: 40,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text(
                              'Welcome!',
                              style: TextStyle(
                                  fontSize: 23, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              'Sign in to continue',
                              style: TextStyle(color: Colors.grey),
                            ),
                          ],
                        ),
                        GestureDetector(
                          child: Text(
                            'SignIn',
                            style: TextStyle(
                              color: Colors.grey,
                            ),
                          ),
                          onTap: () {
                            //TODO: go to
                          },
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Form(
                        key: FormKey,
                        child: Column(
                          children: [
                            customTextFormField(
                              controller: emailController,
                              keyboardType: TextInputType.emailAddress,
                              label: "Enter Your Email ",
                              prefix: Icons.email,
                              validator: (value) {
                                return customValidator(
                                    value!, 5, 90, "emailController");
                              },
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            GetBuilder<ShowPasswordClass>(
                                builder: (controller) {
                              return customTextFormField(
                                  obsureText: controller.isshowPassword,
                                  controller: passwordController,
                                  keyboardType: TextInputType.name,
                                  label: "Enter Your Password",
                                  prefix: Icons.lock,
                                  validator: (value) {
                                    return customValidator(
                                        value!, 6, 90, "passwordController");
                                  },
                                  suffixIcon: controller.isshowPassword
                                      ? Icons.visibility_outlined
                                      : Icons.visibility_off_outlined,
                                  onPressed: () {
                                    controller.showPassword();
                                  });
                            }),
                            const SizedBox(
                              height: 2,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                TextButton(
                                  onPressed: () async {
                                    try {
                                      await FirebaseAuth.instance
                                          .sendPasswordResetEmail(
                                              email: emailController.text);
                                      AwesomeDialog(
                                        context: context,
                                        dialogType: DialogType.success,
                                        animType: AnimType.rightSlide,
                                        //  title: 'Error',
                                        desc:
                                            'go to your Email to reset password.',
                                      )..show();
                                    } catch (e) {
                                      print("error is ____ $e");

                                      AwesomeDialog(
                                        context: context,
                                        dialogType: DialogType.error,
                                        animType: AnimType.rightSlide,
                                        title: 'Error',
                                        desc: 'Please enter an correct Email.',
                                      ).show();
                                    }
                                  },
                                  child: Text('Forget Password?',
                                      style: TextStyle(
                                          fontSize: 14, color: Colors.cyan)),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 25,
                            ),
                            MaterialButton(
                              color: Colors.grey[300],
                              minWidth: double.infinity,
                              child: Text('SIGN IN'),
                              onPressed: () async {
                                if (FormKey.currentState!.validate()) {
                                  try {
                                    final user =
                                        FirebaseAuth.instance.currentUser;
                                    /*      if (user != null && user.emailVerified) {
                                     Get.off(HomePage());
                                    } else {AwesomeDialog(
                                        context: context,
                                        dialogType: DialogType.error,
                                        animType: AnimType.rightSlide,
                                        title: 'Error',
                                        desc: 'Please Verify your Email first.',
                                      )..show(); */
                                    // }

                                    // تسجيل الدخول فقط إذا كان البريد الإلكتروني متحقق منه
                                    final credential = await FirebaseAuth
                                        .instance
                                        .signInWithEmailAndPassword(
                                      email: emailController.text,
                                      password: passwordController.text,
                                    );
                                    Get.off(HomePage());

                                    // إذا لزم الأمر، قم بالانتقال إلى HomePage() هنا
                                  } on FirebaseAuthException catch (e) {
                                    // معالجة الاستثناءات في حالة حدوث خطأ أثناء تسجيل الدخول
                                    if (e.code == 'user-not-found') {
                                      print('No user found for that email.');
                                      AwesomeDialog(
                                        context: context,
                                        dialogType: DialogType.error,
                                        animType: AnimType.rightSlide,
                                        title: 'Error',
                                        desc: 'No user found for that email.',
                                      ).show();
                                    } else if (e.code == 'wrong-password') {
                                      print(
                                          'Wrong password provided for that user.');
                                      AwesomeDialog(
                                        context: context,
                                        dialogType: DialogType.error,
                                        animType: AnimType.rightSlide,
                                        title: 'Error',
                                        desc:
                                            'Wrong password provided for that user.',
                                      )..show();
                                    }
                                  }
                                }
                              },
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text("Don't have any account?",
                                    style: TextStyle(color: Colors.grey)),
                                TextButton(
                                  child: Text(
                                    "Register",
                                    style: TextStyle(
                                      color: Colors.cyan[300],
                                      fontWeight: FontWeight.bold,
                                      fontSize: 17,
                                    ),
                                    textAlign: TextAlign.end,
                                  ),
                                  onPressed: () {
                                    Get.off(() => registerPage());
                                  },
                                ),
                              ],
                            ),
                          ],
                        )),
                  ],
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              const Text(
                '-OR-',
                style: TextStyle(fontSize: 18),
              ),
              const SizedBox(
                height: 30,
              ),
              InkWell(
                onTap: () {
                  //   signInWithFacebook();
                },
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.grey[300]!, width: .5)),
                  margin:
                      const EdgeInsets.only(left: 20, right: 20, bottom: 15),
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: const [
                      Icon(
                        Icons.facebook,
                        color: Colors.blue,
                      ),
                      Text('Sign In With Facebook')
                    ],
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  signInWithGoogle();
                },
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.grey[300]!, width: .5)),
                  margin:
                      const EdgeInsets.only(left: 20, right: 20, bottom: 15),
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: const [
                      Icon(
                        Icons.social_distance,
                        color: Colors.red,
                      ),
                      Text('Sign In With Google    ')
                    ],
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
