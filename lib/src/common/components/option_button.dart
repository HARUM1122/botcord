// import 'package:flutter/material.dart';

// import 'custom_button.dart';

// class OptionButton extends StatelessWidget {
//   final double? width;
//   final double? height;
//   final Color backgroundColor;
//   final Color? onPressedColor;
//   final BorderRadius? borderRadius;
//   final Function() onPressed;
//   final Widget child;

//   const OptionButton({
//     this.width,
//     this.height,
//     required this.backgroundColor,
//     this.onPressedColor,
//     this.borderRadius,
//     required this.onPressed,
//     required this.child,
//     super.key
//   });

//   @override
//   Widget build(BuildContext context) {
//     return CustomButton(
//       width: width,
//       height: height,
//       onPressed: onPressed,
//       backgroundColor: backgroundColor,
//       onPressedColor: onPressedColor,
//       shape: RoundedRectangleBorder(
//         borderRadius: borderRadius ?? BorderRadius.zero
//       ),
//       applyClickAnimation: false,
//       child: child,
//     );
//   }
// }