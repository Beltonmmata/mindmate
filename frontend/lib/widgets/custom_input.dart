import 'package:flutter/material.dart';

class CustomInput extends StatefulWidget {
  final TextEditingController controller;
  final String? hintText;
  final String? label;
  final bool isPassword;
  final String? Function(String?)? validator;

  const CustomInput({
    super.key,
    required this.controller,
    this.hintText,
    this.label,
    this.isPassword = false,
    this.validator,
  });

  @override
  State<CustomInput> createState() => _CustomInputState();
}

class _CustomInputState extends State<CustomInput> {
  bool _obscure = false;

  @override
  void initState() {
    super.initState();
    _obscure = widget.isPassword;
  }

  @override
  Widget build(BuildContext context) {
    final primary =
        Colors.deepOrange; // use app primary (deepOrange) for focus border

    return TextFormField(
      controller: widget.controller,
      obscureText: _obscure,
      validator: widget.validator,
      decoration: InputDecoration(
        labelText: widget.label ?? widget.hintText,
        floatingLabelBehavior: FloatingLabelBehavior.auto,
        hintText: widget.hintText,
        filled: true,
        fillColor: Colors.grey[70],
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 18,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide(color: Colors.transparent),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide(color: primary, width: 2),
        ),
        suffixIcon: widget.isPassword
            ? IconButton(
                icon: Icon(_obscure ? Icons.visibility_off : Icons.visibility),
                onPressed: () => setState(() => _obscure = !_obscure),
              )
            : null,
      ),
    );
  }
}
