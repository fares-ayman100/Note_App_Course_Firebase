import 'package:flutter/material.dart';
import 'package:notes_app_firebase/Const/const.dart';

class CustomMaterialButton extends StatelessWidget {
  const CustomMaterialButton({
    super.key,
    required this.onpressed,
    required this.title,
    this.icon,
  });

  final Function()? onpressed;
  final String title;
  final Icon? icon;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 180,
        height: 60,
        child: MaterialButton(
          color: kprimarycolor,
          onPressed: onpressed,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(60),
          ),
          padding: EdgeInsets.zero,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              icon ?? const SizedBox(), // إذا لم يكن هناك أيقونة، ضع SizedBox()
              if (icon != null) const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 25,
                  color: Colors.white,
                  
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
