import 'package:flutter/material.dart';

import 'package:cached_network_image/cached_network_image.dart';

class ProfilePicWidget extends StatelessWidget {
  final dynamic image;
  final double radius;
  final Color backgroundColor;
  final EdgeInsets? padding;
  final Function()? onPressed;
  final Widget? child;

  const ProfilePicWidget({
    required this.image, 
    required this.radius,
    required this.backgroundColor,
    this.padding,
    this.onPressed, 
    this.child,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: radius,
        height: radius,
        padding: padding,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: backgroundColor
        ),
        child: CircleAvatar(
          backgroundImage: (image is String
          ? CachedNetworkImageProvider(image)
          : MemoryImage(image)) as ImageProvider<Object>,
          backgroundColor: Colors.transparent,
          child: child,
        ),
      ),
    );  
  }
}