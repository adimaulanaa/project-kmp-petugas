import 'package:flutter/material.dart';
import 'package:kmp_petugas_app/theme/colors.dart';

import 'enum.dart';
import 'icon.dart';

class KmpFlatButton extends StatelessWidget {
  final void Function()? onPressed;
  final String title;
  final ButtonType buttonType;
  final String? icon;
  final double height;
  final double minWidth;
  final bool fullWidth;

  KmpFlatButton({
    required this.onPressed,
    required this.buttonType,
    required this.title,
    this.icon,
    this.height = 56.0,
    this.minWidth = 88,
    this.fullWidth = false,
  });

  KmpFlatButton.small({
    required this.onPressed,
    required this.buttonType,
    required this.title,
    this.icon,
    this.height = 32.0,
    this.minWidth = 88,
    this.fullWidth = false,
  });

  @override
  Widget build(BuildContext context) {
    Color? _buttonColor;
    late TextStyle _textStyle;

    if (onPressed == null) {
      _buttonColor = ColorPalette.disabledButonColor;
      _textStyle = TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.w800,
          fontFamily: 'Nunito');
    } else if (buttonType == ButtonType.primary) {
      _buttonColor = ColorPalette.primary;
      _textStyle = TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.w800,
          fontFamily: 'Nunito');
    } else if (buttonType == ButtonType.secondary) {
      _buttonColor = Colors.white;
      _textStyle = TextStyle(
          color: ColorPalette.primary,
          fontSize: 18,
          fontWeight: FontWeight.w800,
          fontFamily: 'Nunito');
    } else if (buttonType == ButtonType.fourth) {
      _buttonColor = Color(0xffFF941A).withOpacity(0.16);
      _textStyle = TextStyle(
          color: Color(0xffFF941A),
          fontSize: 18,
          fontWeight: FontWeight.w800,
          fontFamily: 'Nunito');
    } else if (buttonType == ButtonType.disable) {
      _buttonColor = Color(0xffC4C4C4);
      _textStyle = TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.w800,
          fontFamily: 'Nunito');
    } else {
      _buttonColor = Colors.white.withOpacity(0.35);
      _textStyle = TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.w800,
          fontFamily: 'Nunito');
    }
    final ButtonStyle style = ElevatedButton.styleFrom(
        elevation: 0,
        primary: _buttonColor,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(16))),
        textStyle: const TextStyle(fontSize: 18),
        minimumSize: Size(fullWidth ? double.infinity : minWidth, height));

    if (icon != null) {
      return ElevatedButton.icon(
        icon: SvgIcon(icon!),
        style: style,
        onPressed: onPressed,
        label: Text(
          title,
          style: _textStyle,
        ),
      );
    } else {
      return ElevatedButton(
        onPressed: onPressed,
        style: style,
        child: Text(
          title,
          style: _textStyle,
        ),
      );
    }
  }
}

class FrappeRaisedButton extends StatelessWidget {
  final void Function()? onPressed;
  final String title;
  final String? icon;
  final double height;
  final double minWidth;
  final Color color;
  final double? iconSize;
  final bool fullWidth;

  FrappeRaisedButton({
    required this.onPressed,
    required this.title,
    this.icon,
    this.iconSize,
    this.height = 36.0,
    this.color = Colors.white,
    this.minWidth = 88,
    this.fullWidth = false,
  });

  FrappeRaisedButton.small({
    required this.onPressed,
    required this.title,
    this.icon,
    this.iconSize,
    this.height = 32.0,
    this.color = Colors.white,
    this.minWidth = 88,
    this.fullWidth = false,
  });

  @override
  Widget build(BuildContext context) {
    if (icon != null) {
      return ButtonTheme(
        height: height,
        minWidth: fullWidth ? double.infinity : minWidth,
        child: RaisedButton.icon(
          color: color,
          label: Text(
            title,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50.0),
          ),
          icon: SvgIcon(
            icon!,
            size: iconSize,
          ),
          onPressed: onPressed,
        ),
      );
    } else {
      return ButtonTheme(
        height: height,
        minWidth: fullWidth ? double.infinity : minWidth,
        child: RaisedButton(
          color: color,
          onPressed: onPressed,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50.0),
          ),
          child: Text(
            title,
          ),
        ),
      );
    }
  }
}

class KmpIconButton extends StatelessWidget {
  final void Function()? onPressed;
  final ButtonType buttonType;
  final String icon;
  final double height;
  final double minWidth;
  final bool fullWidth;

  KmpIconButton({
    required this.onPressed,
    required this.buttonType,
    required this.icon,
    this.height = 36.0,
    this.minWidth = 88,
    this.fullWidth = false,
  });

  @override
  Widget build(BuildContext context) {
    Color _buttonColor;

    if (onPressed == null) {
      _buttonColor = ColorPalette.disabledButonColor;
    } else if (buttonType == ButtonType.primary) {
      _buttonColor = ColorPalette.primary;
    } else {
      _buttonColor = ColorPalette.secondary;
    }

    return Container(
      decoration: BoxDecoration(
        color: _buttonColor,
        borderRadius: BorderRadius.all(
          Radius.circular(50),
        ),
      ),
      child: ButtonTheme(
        height: height,
        minWidth: fullWidth ? double.infinity : minWidth,
        child: IconButton(
          icon: SvgIcon(icon),
          onPressed: onPressed,
        ),
      ),
    );
  }
}
