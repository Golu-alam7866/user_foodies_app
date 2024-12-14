import 'package:flutter/material.dart';

class CustomTextFormFields extends StatelessWidget {
   const CustomTextFormFields({super.key,
     required this.controller,
     required this.labelText,
     this.textInputAction,
     this.validator,
     this.keyboardType,
     this.prefixIcon,
     this.suffixIcon,
     this.onChanged,
     this.enabled,
     this.onTap
   });

   final TextEditingController controller;
   final TextInputType? keyboardType;
   final String? Function(String?)? validator;
   final TextInputAction? textInputAction;
   final String? labelText;
   final Widget? prefixIcon;
   final Widget? suffixIcon;
   final void Function(String)? onChanged;
   final bool? enabled;
   final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onTap: onTap,
      enabled: enabled,
      controller: controller,
      keyboardType: keyboardType,
      validator: validator,
      textInputAction: textInputAction,
      onChanged: onChanged,
      decoration: InputDecoration(
        border: const OutlineInputBorder(),
        labelText: labelText,
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon
      ),
    );
  }
}
