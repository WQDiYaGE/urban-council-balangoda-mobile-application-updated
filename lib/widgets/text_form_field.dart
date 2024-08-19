import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'colors.dart';

class MyTextFieldForm extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final String? hintText;
  final bool isObscure;
  final bool isRequierd;
  final List<TextInputFormatter>? inputFormatter;
  final FormFieldValidator? validator;
  final Function(String) onChanged;
  final TextInputType? keyboardType;

  const MyTextFieldForm({
    super.key,
    required this.controller,
    required this.labelText,
    this.isObscure = false,
    this.isRequierd = false,
    this.inputFormatter,
    this.validator,
    required this.onChanged,
    this.keyboardType,
    this.hintText,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Text(
              labelText,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
            ),
            const SizedBox(
              width: 5,
            ),
            const Text(
              '*',
              style: TextStyle(
                  fontSize: 16, fontWeight: FontWeight.w400, color: Colors.red),
            ),
          ],
        ),
        const SizedBox(
          height: 7,
        ),
        TextFormField(
          controller: controller,
          validator: validator,
          textAlign: TextAlign.start,
          maxLines: 1,
          inputFormatters: inputFormatter,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          onChanged: onChanged,
          keyboardType: keyboardType,
          obscureText: isObscure,
          decoration: InputDecoration(
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
            // errorText: widget.errorText.isNotEmpty ? widget.errorText : null,
            errorStyle: const TextStyle(color: Colors.red),
            counterStyle: const TextStyle(height: double.minPositive),
            counterText: "",
            hintText: hintText ?? labelText,
            hintStyle:
                const TextStyle(color: ColorTheme.hintColor, fontSize: 12),
            isDense: true,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide:
                    const BorderSide(color: ColorTheme.borderColor, width: 1)
                // borderSide: BorderSide.none,
                ),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide:
                    const BorderSide(color: ColorTheme.borderColor, width: 2)
                // borderSide: BorderSide.none,
                ),
            errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: Colors.red, width: 1)
                // borderSide: BorderSide.none,
                ),
            focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: Colors.red, width: 1)
                // borderSide: BorderSide.none,
                ),
          ),
        ),
      ],
    );
  }
}
