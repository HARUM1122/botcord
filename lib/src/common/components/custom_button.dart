import 'package:flutter/material.dart';

class CustomButton extends StatefulWidget {
  final bool? enabled;
  final double? width;
  final double? height;
  final Color backgroundColor;
  final Color? onPressedColor;
  final RoundedRectangleBorder? shape;
  final bool applyClickAnimation;
  final double? animationUpperBound;
  final Function() onPressed;
  final Widget child;

  const CustomButton({
    this.enabled,
    this.width,
    this.height,
    required this.backgroundColor,
    this.onPressedColor,
    this.shape,
    required this.applyClickAnimation,
    this.animationUpperBound,
    required this.onPressed,
    required this.child,
    super.key
  });

  @override
  State<CustomButton> createState() => CustomButtonState();
}

class CustomButtonState extends State<CustomButton> with TickerProviderStateMixin{
  double _buttonScale = 1;
  AnimationController? _controller;
  @override
  void initState() {
    if (widget.applyClickAnimation) {
        _controller = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 100),
        lowerBound: 0.0,
        upperBound: widget.animationUpperBound ?? 0.02
      )..addListener(() => setState(() {}));
    }
    super.initState();
  }
  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    _buttonScale  = 1 - (_controller?.value ?? 0);
    return Transform.scale(
      scale: _buttonScale,
      child: SizedBox(
        width: widget.width,
        height: widget.height,
        child: Material(
          color: widget.backgroundColor,
          shape: widget.shape,
          child: InkWell(
            borderRadius: widget.shape?.borderRadius != null ? widget.shape!.borderRadius as BorderRadius : null,
            overlayColor: MaterialStatePropertyAll(!(widget.enabled ?? true) ? widget.backgroundColor : widget.onPressedColor ?? widget.backgroundColor),
            splashFactory: NoSplash.splashFactory,
            onTapUp: (widget.enabled ?? true) ? (_) {
              _controller?.reverse();
              widget.onPressed();
            } : null,
            onTapDown: (widget.enabled ?? true) ? (_) =>  _controller?.forward() :  null,
            onTapCancel: (widget.enabled ?? true) ? _controller?.reverse : null,
            child: widget.child,
          ),
        ),
      ),
    );
  }
}