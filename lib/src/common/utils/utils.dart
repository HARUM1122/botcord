import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:intl/intl.dart';
import 'package:bottom_sheet/bottom_sheet.dart';
import 'package:image_picker/image_picker.dart';
import 'package:animated_snack_bar/animated_snack_bar.dart';

 Future<T?> showDialogBox<T>({required BuildContext context, required Widget child}) {
  return showDialog<T>(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.all(12),
        child: child
      );
  });
}

Future<T?> showSheet<T>({
  required BuildContext context, 
  required Widget Function(BuildContext context, ScrollController controller, double offset) builder, 
  required double height,
  required double maxHeight,
  BorderRadius? borderRadius,
  Color? color,
}) {
  return showFlexibleBottomSheet<T?>(
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

String formatDateTime(DateTime dateTime) {
  dateTime = dateTime.toLocal();
  final now = DateTime.now();
  final difference = now.difference(dateTime);
  final dayDifference = difference.inDays;
  final hourFormat = DateFormat('h:mm a');

  if (dayDifference == 0) {
    return 'Today at ${hourFormat.format(dateTime)}';
  } else if (dayDifference == 1) {
    return 'Yesterday at ${hourFormat.format(dateTime)}';
  } else if (dayDifference < 7) {
    final weekdayFormat = DateFormat('EEEE');
    return 'Last ${weekdayFormat.format(dateTime)} at ${hourFormat.format(dateTime)}';
  } else {
    return DateFormat('M/d/yyyy').format(dateTime);
  }
}

String formatDuration(int seconds) {
  if (seconds < 60) {
    return '$seconds seconds';
  } else if (seconds < 3600) {
    int minutes = seconds ~/ 60;
    return minutes == 1 ? '1 minute' : '$minutes minutes';
  } else if (seconds < 86400) {
    int hours = seconds ~/ 3600;
    return hours == 1 ? '1 hour' : '$hours hours';
  } else {
    int days = seconds ~/ 86400;
    return days == 1 ? '1 day' : '$days days';
  }
}