import 'package:flutter/material.dart';

class CustomTextField extends StatefulWidget {
  const CustomTextField({
    Key? key,
    required this.textEditingController,
    this.autoCorrect = true,
    required this.hintText,
    required this.labelText,
    this.validator,
    this.textInputType = TextInputType.text,
    this.isPassword = false,
  }) : super(key: key);

  final TextEditingController textEditingController;
  final bool autoCorrect;
  final String hintText;
  final String labelText;
  final String? Function(String?)? validator;
  final TextInputType textInputType;
  final bool isPassword;

  @override
  _CustomTextFieldState createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  final ValueNotifier<bool> obscureText = ValueNotifier<bool>(false);
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: obscureText,
      builder: (BuildContext context, bool value, dynamic child) {
        return TextFormField(
          controller: widget.textEditingController,
          autocorrect: widget.autoCorrect,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.grey[200],
            border: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.circular(5.0),
            ),
            hintText: widget.hintText,
            labelText: widget.labelText,
            suffixIcon: widget.isPassword == false
                ? const SizedBox()
                : IconButton(
                    icon: const Icon(Icons.remove_red_eye_outlined),
                    onPressed: () => obscureText.value = !obscureText.value,
                  ),
          ),
          keyboardType: widget.textInputType,
          obscureText: value,
          validator: (String? val) => widget.validator!(val?.trim()),
        );
      },
    );
  }
}
