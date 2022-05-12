import 'package:flutter/material.dart';

class TsField extends StatelessWidget {
  final String hintText;
  final GestureTapCallback? onPress;
  final TextInputAction? action;
  final IconData? icon;
  final FormFieldValidator validator;
  final TextEditingController controller;
  final bool hide;
  final TextInputType? keyboardType;
  final int? length;
  final TextAlign align;
  final Icon? prefixIcon;

  const TsField(
      {Key? key,
      required this.hintText,
      this.onPress,
      this.icon,
      required this.validator,
      required this.controller,
      required this.hide,
      this.keyboardType,
      this.length,
      this.action,
      this.align = TextAlign.start,
      this.prefixIcon})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscureText: hide,
      controller: controller,
      validator: validator,
      textInputAction: action,
      maxLength: length,
      keyboardType: keyboardType,
      textAlign: align,
      decoration: InputDecoration(
        hintText: hintText,
        filled: true,
        fillColor: Colors.white,
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(10),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(10),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.red),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.red),
        ),
        counter: const Offstage(),
        prefixIcon: prefixIcon,
        suffixIcon: GestureDetector(
          onTap: onPress,
          child: Icon(icon),
        ),
      ),
    );
  }
}
