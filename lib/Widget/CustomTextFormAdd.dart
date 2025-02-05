import 'package:flutter/material.dart';

class Customtextformadd extends StatelessWidget {
  const Customtextformadd(
      {super.key,
      required this.label,
      required this.controler,
      this.icon,
      this.obsecure = false,
      this.suffixIcon,
      required this.validator});
  final String label;
  final TextEditingController controler;
  final Icon? icon;
  final bool obsecure;
  final Widget? suffixIcon;
  final String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: validator,
      obscureText: obsecure,
      controller: controler,
      decoration: InputDecoration(
        prefixIcon: icon,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 25, vertical: 18),
        labelText: label,
        suffixIcon: suffixIcon,
        hintStyle: TextStyle(color: Colors.grey[400], fontSize: 18),
        filled: true,
        fillColor: Colors.grey[250],
        border: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.grey),
          borderRadius: BorderRadius.circular(60),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(60),
          borderSide: const BorderSide(color: Colors.grey),
        ),
      ),
    );
  }
}
