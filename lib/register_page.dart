import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:notes_google_keep/login_page.dart';
import 'package:notes_google_keep/widgets.dart';

ShowPasswordClass controller = Get.put(ShowPasswordClass());

class registerPage extends StatefulWidget {
  State<registerPage> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<registerPage> {
  var FormKeySignUp = GlobalKey<FormState>();
  final FormKey = GlobalKey<FormState>();
  ShowPasswordClass controller = Get.put(ShowPasswordClass());

  final TextEditingController emailController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController1 = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
//  SettingServices myServices = Get.find();

  Widget build(BuildContext context) {
    // final isDark = Theme.of(context).brightness == Brightness.dark;
//    dynamic fontcolor = isDark ? grayColor : mainColor;

    return Scaffold(
      body: Container(
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
        child: Form(
          key: FormKeySignUp,
          child: ListView(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 30,
                  ),
                  Center(
                      child: Text(
                    "Create a new account...",
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  )),
                  SizedBox(
                    height: 10,
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              customTextFormField(
                controller: usernameController,
                keyboardType: TextInputType.name,
                label: "Enter Your name".tr,
                prefix: Icons.email,
                validator: (value) {
                  return customValidator(value!, 2, 90, "usernameController");
                },
              ),
              SizedBox(height: 10),
              customTextFormField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                label: "Enter Your Email".tr,
                prefix: Icons.email,
                validator: (value) {
                  return customValidator(value!, 5, 90, "email");
                },
              ),
              SizedBox(
                height: 20.0,
              ),
              GetBuilder<ShowPasswordClass>(builder: (controller) {
                if (controller != null && controller.isshowPassword != null) {
                  // to solve the null problem
                  return customTextFormField(
                      obsureText: controller.isshowPassword,
                      controller: passwordController1,
                      keyboardType: TextInputType.visiblePassword,
                      label: "Enter New Password".tr,
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
                }
                return SizedBox(); // Or any other Widget you want to return as a default
              }),
              SizedBox(
                height: 20.0,
              ),
              GetBuilder<ShowPasswordClass>(builder: (controller) {
                if (controller != null && controller.isshowPassword != null)
                  return customTextFormField(
                      obsureText: controller.isshowPassword,
                      controller: passwordController,
                      keyboardType: TextInputType.name,
                      label: "Re Enter New Password".tr,
                      prefix: Icons.lock,
                      validator: (value) {
                        if (value != passwordController1.text) {
                          return 'Passwords do not match';
                        }
                        return customValidator(
                            value!, 6, 90, "passwordController1");
                      },
                      suffixIcon: controller.isshowPassword
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                      onPressed: () {
                        controller.showPassword();
                      }); // Add a default return statement if conditions aren't met
                return SizedBox(); // Or any other Widget you want to return as a default
              }),
              SizedBox(
                height: 30.0,
              ),
              MaterialButton(
                height: 50,
                child: Text(
                  "SIGN UP",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                color: Colors.grey[300],
                minWidth: double.infinity,
                onPressed: () async {
                  if (FormKeySignUp.currentState!.validate()) {
                    FormKeySignUp.currentState!.save();
                    try {
                      final credential = await FirebaseAuth.instance
                          .createUserWithEmailAndPassword(
                        email: emailController.text,
                        password: passwordController.text,
                      );
                      FirebaseAuth.instance.currentUser!
                          .sendEmailVerification();
                      Get.to(loginPage());
                    } on FirebaseAuthException catch (e) {
                      if (e.code == 'weak-password') {
                        print('The password provided is too weak.');
                        AwesomeDialog(
                          context: context,
                          dialogType: DialogType.error,
                          animType: AnimType.rightSlide,
                          title: 'Error',
                          desc: 'The password provided is too weak.',
                          btnCancelOnPress: () {},
                          btnOkOnPress: () {},
                        )..show();
                      } else if (e.code == 'email-already-in-use') {
                        print('The account already exists for that email.');
                        AwesomeDialog(
                          context: context,
                          dialogType: DialogType.error,
                          animType: AnimType.rightSlide,
                          title: 'Error',
                          desc: 'The account already exists for that email.',
                        )..show();
                      }
                    } catch (e) {
                      print(e);
                    }
                  }
                },
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Do you have any accout?".tr,
                      style: TextStyle(color: Colors.grey)),
                  TextButton(
                    child: Text(
                      "Sign in".tr,
                      style: TextStyle(
                        color: Colors.cyan[300],
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                      textAlign: TextAlign.end,
                    ),
                    onPressed: () {
                      Get.off(() => loginPage());
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
