import 'package:flutter/material.dart';
import 'package:food_dash_app/cores/constants/color.dart';
import 'package:food_dash_app/cores/utils/sizer_utils.dart';
import 'package:google_fonts/google_fonts.dart';

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
    this.maxLine = 1,
    this.textInputAction,
    this.enable = true,
    this.onDone,
    this.onTap,
    this.onChange,
  }) : super(key: key);

  final TextEditingController textEditingController;
  final bool autoCorrect;
  final String hintText;
  final String labelText;
  final String? Function(String?)? validator;
  final Function()? onDone;
  final TextInputType textInputType;
  final bool isPassword;
  final bool enable;
  final int? maxLine;
  final TextInputAction? textInputAction;
  final Function()? onTap;
  final Function()? onChange;

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
        return GestureDetector(
          onTap: () {
            if (widget.onTap == null) return;
            widget.onTap!();
          },
          child: TextFormField(
            enabled: widget.enable,
            maxLines: widget.maxLine,
            cursorColor: kcPrimaryColor,
            style: GoogleFonts.raleway(),
            controller: widget.textEditingController,
            autocorrect: widget.autoCorrect,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.red),
                borderRadius: BorderRadius.circular(sizerSp(5.0)),
              ),
              hintText: widget.hintText,
              // labelText: widget.labelText,
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
            textInputAction: widget.textInputAction,
            onFieldSubmitted: (_) {
              if (widget.onDone != null) {
                widget.onDone!();
              }
            },
            onChanged: (_) {
              if (widget.onChange == null) return;

              widget.onChange!();
            },
          ),
        );
      },
    );
  }
}
