import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TextFormFieldHelper extends StatefulWidget {
  final TextEditingController? controller;
  final bool isPassword;
  final String? hint, obscuringCharacter;
  final bool enabled;
  final int? maxLines, minLines, maxLength;
  final String? Function(String?)? onValidate;
  final void Function(String?)? onChanged, onFieldSubmitted, onSaved;
  final void Function()? onEditingComplete, onTap;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final Widget? suffixWidget, prefixIcon, prefix;
  final IconData? icon;
  final TextInputAction? action;
  final FocusNode? focusNode;
  final Color? fillColor;
  final double? hintFontSize;
  final double borderWidth;
  final double? borderRadius;
  final bool? isMobile;
  final double horizontalPadding;
  final double verticalPadding;

  TextFormFieldHelper({
    super.key,
    this.controller,
    this.hint,
    this.obscuringCharacter,
    this.onValidate,
    this.onChanged,
    this.onFieldSubmitted,
    this.onEditingComplete,
    this.onSaved,
    this.onTap,
    this.maxLength,
    this.keyboardType,
    this.inputFormatters,
    this.suffixWidget,
    this.icon,
    this.prefixIcon,
    this.prefix,
    this.action,
    this.focusNode,
    this.borderRadius,
    this.isMobile,
    this.isPassword = false,
    this.enabled = true,
    this.maxLines = 1,
    this.minLines = 1,
    this.fillColor = Colors.transparent,
    this.hintFontSize = 16,
    this.borderWidth = 1,
    this.horizontalPadding = 10,
    this.verticalPadding = 10,
  });

  @override
  State<TextFormFieldHelper> createState() => _TextFormFieldHelperState();
}

class _TextFormFieldHelperState extends State<TextFormFieldHelper> {
  late bool obscureText;
  TextDirection _textDirection = TextDirection.ltr;

  @override
  void initState() {
    super.initState();
    obscureText = widget.isPassword;
  }

  void _toggleObscureText() {
    setState(() => obscureText = !obscureText);
  }

  void _updateTextDirection(String text) {
    if (text.isEmpty) return;
    final isArabic = RegExp(r'^[\u0600-\u06FF]').hasMatch(text);
    setState(() {
      _textDirection = isArabic ? TextDirection.rtl : TextDirection.ltr;
    });
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      validator: widget.onValidate,
      onChanged: (text) {
        widget.onChanged?.call(text);
        _updateTextDirection(text);
      },
      onEditingComplete: widget.onEditingComplete,
      onFieldSubmitted: widget.onFieldSubmitted,
      onSaved: widget.onSaved,
      onTap: widget.onTap,
      maxLines: widget.maxLines,
      minLines: widget.minLines,
      maxLength: widget.maxLength,
      obscureText: obscureText,
      obscuringCharacter: widget.obscuringCharacter ?? '*',
      keyboardType: widget.keyboardType,
      inputFormatters: widget.inputFormatters,
      enabled: widget.enabled,
      textInputAction: widget.action ?? TextInputAction.next,
      focusNode: widget.focusNode,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      style: TextStyle(
        fontSize: 16,
        // fontFamily: FontFamilyHelper.tajawalArabic,
        color: Theme.of(context).primaryColor,
        fontWeight: FontWeight.w500,
      ),
      textAlign: widget.isMobile != null ? TextAlign.left : TextAlign.start,
      textDirection: widget.isMobile != null
          ? TextDirection.ltr
          : _textDirection,
      textAlignVertical: TextAlignVertical.center,
      decoration: InputDecoration(
        fillColor: widget.fillColor,
        filled: true,
        hintText: widget.hint,
        hintStyle: TextStyle(
          fontSize: widget.hintFontSize,
          color: Colors.grey,
          fontWeight: FontWeight.w500,
        ),
        errorMaxLines: 4,
        errorStyle: const TextStyle(color: Colors.red),
        prefixIcon: widget.prefixIcon,
        prefix: widget.prefix,
        suffixIcon: widget.isPassword
            ? GestureDetector(
                onTap: _toggleObscureText,
                child: Icon(
                  obscureText ? Icons.visibility_off : Icons.visibility,
                  color: Colors.grey,
                  size: 27,
                ),
              )
            : widget.suffixWidget,
        contentPadding: EdgeInsets.symmetric(
          horizontal: widget.horizontalPadding,
          vertical: widget.verticalPadding,
        ),
        border: outlineInputBorder(
          color: Colors.grey,
          width: widget.borderWidth,
        ),
        enabledBorder: outlineInputBorder(
          color: Colors.grey,
          width: widget.borderWidth,
        ),
        focusedBorder: outlineInputBorder(
          color: Colors.grey,
          width: widget.borderWidth,
        ),
        errorBorder: outlineInputBorder(
          color: Colors.red,
          width: widget.borderWidth,
        ),
        focusedErrorBorder: outlineInputBorder(
          color: Colors.red,
          width: widget.borderWidth,
        ),
      ),
    );
  }

  OutlineInputBorder outlineInputBorder({
    required Color color,
    required double width,
  }) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(widget.borderRadius ?? 40),
      borderSide: BorderSide(color: color, width: width),
    );
  }
}
