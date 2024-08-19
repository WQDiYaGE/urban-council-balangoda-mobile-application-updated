import 'package:flutter/material.dart';

import 'app_textStyle.dart';

class CommonButton extends StatelessWidget {
  final String title;
  final Color? color;
  final dynamic imgPath;
  final Color titleColor;
  final VoidCallback onPressed;
  const CommonButton({
    super.key,
    this.imgPath,
    required this.title,
    this.color = const Color(0xFF3B3B3B),
    required this.onPressed,
    this.titleColor = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          fixedSize: const Size(double.infinity, 50),
          backgroundColor: color,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            if (imgPath != null)
              ClipOval(
                child: Image.asset(
                  imgPath!,
                  fit: BoxFit.cover,
                  height: 20,
                  width: 20,
                ),
              ),
            Text(
              title,
              style: appTextStyle(
                titleColor,
                titleColor == Colors.white ? FontWeight.w400 : FontWeight.w500,
                16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
