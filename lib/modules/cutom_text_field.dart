import 'package:flutter/material.dart';

class CustomTextField extends StatefulWidget {
  final String label;
  final String hint;
  final TextEditingController controller;
  final bool isPass;
  final FormFieldValidator<String>? validator;
  final int? maxLines;

  const CustomTextField(

      {
    super.key,
    required this.label,
    required this.hint,
    required this.controller,
    required this.isPass,
    this.validator,
        this.maxLines,
  });

  @override
  _CustomTextFieldState createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool _isObscured = true; 

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      obscureText: widget.isPass ? _isObscured : false,
      decoration: InputDecoration(
        labelText: "Enter ${widget.label}",
        hintText: widget.hint,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.black45),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.blue.shade500),
          borderRadius: BorderRadius.circular(10),
        ),
        suffixIcon: widget.isPass
            ? IconButton(
                icon: Icon(
                  _isObscured ? Icons.visibility_off : Icons.visibility,
                  color: Colors.grey,
                ),
                onPressed: () {
                  setState(() {
                    _isObscured = !_isObscured; 
                  });
                },
              )
            : null, 
      ),
      validator: widget.validator ?? (value) {
        return null;
      },
    );
  }
}
