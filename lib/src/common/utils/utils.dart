import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:bottom_sheet/bottom_sheet.dart';
import 'package:image_picker/image_picker.dart';
import 'package:animated_snack_bar/animated_snack_bar.dart';

void showDialogBox({required BuildContext context, required Widget child}) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.all(12),
        child: child
      );
  });
}

void showSheet({
  required BuildContext context, 
  required Widget Function(BuildContext context, ScrollController controller, double offset) builder, 
  required double height,
  required double maxHeight,
  BorderRadius? borderRadius,
  Color? color,
}) {
  showFlexibleBottomSheet(
    context: context,
    minHeight: 0,
    initHeight: height,
    maxHeight: maxHeight,
    bottomSheetBorderRadius: borderRadius,
    bottomSheetColor: color,
    anchors: [0, height, maxHeight],
    builder: builder,
    useRootScaffold: false
  );
}

void showSnackBar({
  required BuildContext context,
  required String theme,
  Widget? leading,
  required String msg,

}) {
  AnimatedSnackBar(
    desktopSnackBarPosition: DesktopSnackBarPosition.topCenter,
    duration: const Duration(seconds: 3),
    builder: (
      (context) => IntrinsicWidth(
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: appTheme<Color>(theme, light: const Color(0xFFFFFFFF), dark: const Color(0xFF25282F), midnight: const Color(0xFF25282F)),
            borderRadius: BorderRadius.circular(25)
          ),
          child: Row(
            children: [
              leading!,
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  msg,
                  style: TextStyle(
                    color: appTheme<Color>(theme, light: const Color(0xFF000000), dark: const Color(0xFFFFFFFF), midnight: const Color(0xFFFFFFFF)),
                    fontFamily: 'GGSansSemibold',
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 4)
            ],
          ),
        ),
      )
    ),
  ).show(context);
}


T appTheme<T> (String theme, {
  required T light, 
  required T dark, 
  required T midnight
}) => switch(theme) {
  'light' => light,
  'dark' => dark,
  _=> midnight
};

Future<(Uint8List, String)?> pickImage() async {
  final XFile? image = await ImagePicker().pickImage(source: ImageSource.gallery);
  if (image != null) {
    Uint8List bytes = await image.readAsBytes();
    String format = image.path.split('.').last;
    final img = await decodeImageFromList(bytes);
    return img.width  >= 128 
    && img.height >= 128 
    && bytes.length < 8 * 1024 * 1024 
    ? const {'png', 'jpg', 'jpeg'}.contains(format)
      ? (bytes, format)
      : null
    : null;
  }
  return null;
}