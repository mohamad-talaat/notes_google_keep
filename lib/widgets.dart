import 'package:flutter/material.dart';
import 'package:get/get.dart';

customValidator(String value, int min, int max, String type) {
  if (type == "nameController") {
    if (!GetUtils.isUsername(value)) {
      return "not valid userName";
    }
  }

  if (type == "emailController") {
    if (!GetUtils.isEmail(value)) {
      return "not valid email";
    }
  }
  if (type == "phoneNumberController") {
    if (!GetUtils.isPhoneNumber(value)) {
      return "this is not Correct Number";
    }

    if (value == null || value.isEmpty) {
      return "the value cannot be empty ";
    }
    if (value.length < min) {
      return "the value cannot be less then $min ";
    }
    if (value.length > max) {
      return "the value cannot be longer than $max ";
    }
  }
}

class ShowPasswordClass extends GetxController {
  bool isshowPassword = true;
  showPassword() {
    isshowPassword = isshowPassword == true ? false : true;
    update();
  }
}

ShowPasswordClass controller = Get.put(ShowPasswordClass());

class customTextFormField extends StatelessWidget {
  final TextEditingController controller;
  final TextInputType keyboardType;
  final String label;
  bool? obsureText;
  final IconData? prefix;
  final IconData? suffixIcon;
  //final Function()? suffixPressed;
  final String? Function(String?)? validator;
  final void Function()? onPressed;
  final void Function()? onTap;
  // عشان onPressed تتنفذ لا تضع كلمة void or required
  // ولا حتي ال (){} دول تحت هنخليها كدا >>> suffixIcon: IconButton(onPressed:onPressed

  customTextFormField({
    Key? key,
    required this.controller,
    required this.keyboardType,
    required this.label,
    this.prefix,
    this.obsureText,
    this.suffixIcon,
    this.validator,
    this.onPressed,
    this.onTap,
  }) : super(key: key);

  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    dynamic fontcolor = isDark ? Colors.white : Colors.black;
    return Container(
      margin: EdgeInsets.only(top: 10),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        style: TextStyle(color: fontcolor),
        obscureText: obsureText == null || obsureText == false ? false : true,
        decoration: InputDecoration(
          border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10))),
          fillColor: Colors.deepPurple,
          prefixIconColor: Colors.cyan,
          contentPadding: EdgeInsets.symmetric(vertical: 18),
          label: Text(label),
          labelStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
          prefixIcon: Icon(prefix),
          suffixIcon: IconButton(onPressed: onPressed, icon: Icon(suffixIcon)),
        ),
        onTap: onTap,
        validator: validator,
      ),
    );
  }
}
