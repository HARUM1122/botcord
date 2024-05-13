import 'package:flutter/material.dart';
import 'dart:core';

double translate = 0;
/// Display sections
enum RevealSide { left, main }

/// Widget to display three view panels with the [OverlappingPanels.main] being
/// in the center, [OverlappingPanels.left] and [OverlappingPanels.right] also
/// revealing from their respective sides. Just like you will see in the
/// Discord mobile app's navigation.
class OverlappingPanels extends StatefulWidget {
  final Widget? left;
  final Widget main;
  final double restWidth;
  final ValueChanged<RevealSide>? onSideChange;

  const OverlappingPanels({this.left,
    required this.main,
    this.restWidth = 12,
    this.onSideChange,
    Key? key})
      : super(key: key);

  static OverlappingPanelsState? of(BuildContext context) {
    return context.findAncestorStateOfType<OverlappingPanelsState>();
  }

  @override
  State<StatefulWidget> createState() {
    return OverlappingPanelsState();
  }
}

class OverlappingPanelsState extends State<OverlappingPanels> with TickerProviderStateMixin {
  AnimationController? controller;

  double _calculateGoal(double width, int multiplier) => 
    (multiplier * width) + (-multiplier * widget.restWidth);

  void _onApplyTranslation() {
    final double width = MediaQuery.of(context).size.width;

    final AnimationController animationController = AnimationController(vsync: this, duration: const Duration(milliseconds: 200));

    
    if (translate.abs() >= width / 2) {
      final goal = _calculateGoal(width, 1);

      final Tween<double> tween = Tween(begin: translate, end: goal);

      final Animation animation = tween.animate(animationController);

      animation.addListener(() {
        setState(() {
          translate = animation.value;
        });
      });
    } else {
      final Animation<double> animation = Tween<double>(begin: translate, end: 0).animate(animationController);

      animation.addListener(() {
        setState(() => translate = animation.value);
      });
    }
    animationController.forward();
  }

  void revealLeft() {
    if (translate != 0) return;

    final double width = MediaQuery.of(context).size.width;
    

    final double goal = _calculateGoal(width, 1);

    final AnimationController animationController = AnimationController(vsync: this, duration: const Duration(milliseconds: 200));
    
    final Animation<double> animation = Tween<double>(begin: translate, end: goal).animate(animationController);

    animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _onApplyTranslation();
        animationController.dispose();
      }
    });

    animation.addListener(() {
      setState(() {
        translate = animation.value;
      });
    });
    animationController.forward();
  }

  void onTranslate(double delta) {
    setState(() {
      final trns = translate + delta;
      if (trns > 0 && widget.left != null) {
        translate = trns;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Offstage(
        offstage: translate < 0,
        child: widget.left,
      ),
      Transform.translate(
        offset: Offset(translate, 0),
        child: widget.main,
      ),
      GestureDetector(
        behavior: HitTestBehavior.translucent,
        onHorizontalDragUpdate: (details) {
          onTranslate(details.delta.dx);
        },
        onHorizontalDragEnd: (details) {
          _onApplyTranslation();
        },
      ),
    ]);
  }
}

























// import 'package:flutter/material.dart';
// import 'dart:core';

// // const double bleedWidth = 0;
// double translate = 0;
// /// Display sections
// enum RevealSide { left, right, main }

// /// Widget to display three view panels with the [OverlappingPanels.main] being
// /// in the center, [OverlappingPanels.left] and [OverlappingPanels.right] also
// /// revealing from their respective sides. Just like you will see in the
// /// Discord mobile app's navigation.
// class OverlappingPanels extends StatefulWidget {
//   /// The left panel
//   final Widget? left;

//   /// The main panel
//   final Widget main;

//   /// The offset to use to keep the main panel visible when the left or right
//   /// panel is revealed.
//   final double restWidth;

//   /// A callback to notify when a panel reveal has completed.
//   final ValueChanged<RevealSide>? onSideChange;

//   const OverlappingPanels({this.left,
//     required this.main,
//     this.restWidth = 12,
//     this.onSideChange,
//     Key? key})
//       : super(key: key);

//   static OverlappingPanelsState? of(BuildContext context) {
//     return context.findAncestorStateOfType<OverlappingPanelsState>();
//   }

//   @override
//   State<StatefulWidget> createState() {
//     return OverlappingPanelsState();
//   }
// }

// class OverlappingPanelsState extends State<OverlappingPanels>
//     with TickerProviderStateMixin {
//   AnimationController? controller;

//   double _calculateGoal(double width, int multiplier) {
//     return (multiplier * width) + (-multiplier * widget.restWidth);
//   }

//   void _onApplyTranslation() {
//     final mediaWidth = MediaQuery
//         .of(context)
//         .size
//         .width;

//     final animationController = AnimationController(
//         vsync: this, duration: const Duration(milliseconds: 200));

//     animationController.addStatusListener((status) {
//       if (status == AnimationStatus.completed) {
//         if (widget.onSideChange != null) {
//           widget.onSideChange!(translate == 0
//               ? RevealSide.main
//               : (translate > 0 ? RevealSide.left : RevealSide.right));
//         }
//         animationController.dispose();
//       }
//     });

//     if (translate.abs() >= mediaWidth / 2) {
//       final multiplier = (translate > 0 ? 1 : -1);
//       final goal = _calculateGoal(mediaWidth, multiplier);
//       final Tween<double> tween = Tween(begin: translate, end: goal);

//       final animation = tween.animate(animationController);

//       animation.addListener(() {
//         setState(() {
//           translate = animation.value;
//         });
//       });
//     } else {
//       final animation =
//       Tween<double>(begin: translate, end: 0).animate(animationController);

//       animation.addListener(() {
//         setState(() {
//           translate = animation.value;
//         });
//       });
//     }

//     animationController.forward();
//   }

//   void reveal(RevealSide direction) {
//     // can only reveal when showing main
//     if (translate != 0) {
//       return;
//     }

//     final mediaWidth = MediaQuery
//         .of(context)
//         .size
//         .width;

//     final multiplier = (direction == RevealSide.left ? 1 : -1);
//     final goal = _calculateGoal(mediaWidth, multiplier);

//     final animationController = AnimationController(
//         vsync: this, duration: const Duration(milliseconds: 200));

//     animationController.addStatusListener((status) {
//       if (status == AnimationStatus.completed) {
//         _onApplyTranslation();
//         animationController.dispose();
//       }
//     });

//     final animation = Tween<double>(begin: translate, end: goal).animate(animationController);

//     animation.addListener(() {
//       setState(() {
//         translate = animation.value;
//       });
//     });

//     animationController.forward();
//   }

//   void onTranslate(double delta) {
//     setState(() {
//       final trns = translate + delta;
//       if (trns > 0 && widget.left != null) {
//         translate = trns;
//       }
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Stack(children: [
//       Offstage(
//         offstage: translate < 0,
//         child: widget.left,
//       ),
//       Transform.translate(
//         offset: Offset(translate, 0),
//         child: widget.main,
//       ),
//       GestureDetector(
//         behavior: HitTestBehavior.translucent,
//         onHorizontalDragUpdate: (details) {
//           onTranslate(details.delta.dx);
//         },
//         onHorizontalDragEnd: (details) {
//           _onApplyTranslation();
//         },
//       ),
//     ]);
//   }
// }


// ADD THIS INSIDE `ONAPPLYTRANSITION`


// animationController.addStatusListener((status) {
//       if (status == AnimationStatus.completed) {
//         if (widget.onSideChange != null) {
//           widget.onSideChange!(translate == 0 ? RevealSide.main : RevealSide.left);
//         }
//         animationController.dispose();
//       }
//     });
