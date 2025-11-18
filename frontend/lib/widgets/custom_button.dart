import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final Color? backgroundColor;
  final bool isLoading;
  final bool disabled;
  final String? loadingText;

  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.backgroundColor,
    this.isLoading = false,
    this.disabled = false,
    this.loadingText,
  });

  @override
  Widget build(BuildContext context) {
    final primary = backgroundColor ?? Colors.deepOrange;
    final bool effectiveDisabled = disabled || isLoading || onPressed == null;
    final bg = effectiveDisabled ? primary.withOpacity(0.45) : primary;

    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: effectiveDisabled ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: bg,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          elevation: 3,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 14),
          child: isLoading
              ? Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      loadingText ?? 'Authenticating...',
                      style: const TextStyle(color: Colors.white, fontSize: 15),
                    ),
                  ],
                )
              : Text(
                  text,
                  style: const TextStyle(fontSize: 16, color: Colors.white),
                ),
        ),
      ),
    );
  }
}
