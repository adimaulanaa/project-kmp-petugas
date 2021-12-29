import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SvgIcon extends StatelessWidget {
  final String path;
  final Color? color;
  final double? size;

  const SvgIcon(
    this.path, {
    this.color,
    this.size = 24,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: size,
      width: size,
      child: SvgPicture.asset(
        path,
        color: color,
      ),
    );
  }
}
