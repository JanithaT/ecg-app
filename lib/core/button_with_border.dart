import 'package:flutter/material.dart';

class ButtonWithBorder extends StatelessWidget {
  const ButtonWithBorder({
    Key? key,
    required this.label,
    required this.labelColor,
    required this.backgroundColor,
    required this.borderColor,
    this.textStyle,
    this.textAlign,
    required this.onPressed,
    this.buttonHeight,
  }) : super(key: key);

  final void Function()? onPressed;
  final Color backgroundColor;
  final Color borderColor;
  final String label;
  final Color labelColor;
  final TextStyle? textStyle;
  final TextAlign? textAlign;
  final double? buttonHeight;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: buttonHeight ?? 40,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          backgroundColor: backgroundColor,
          side: BorderSide(
            width: 1,
            color: borderColor,
          ),
        ),
        child: Text(
          label,
          textAlign: textAlign,
          style:
               textStyle!.copyWith(
                  color: labelColor,
                )
            
        ),
      ),
    );
  }
}
