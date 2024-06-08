import 'package:flutter/material.dart';

import 'package:cached_network_image/cached_network_image.dart';

class AvatarWidget extends StatelessWidget {
  final dynamic image;
  final double radius;
  final Color backgroundColor;
  final EdgeInsets? padding;
  final Function()? onPressed;
  final Widget ? errorWidget;
  final Widget? child;

  const AvatarWidget({
    required this.image, 
    required this.radius,
    required this.backgroundColor,
    this.padding,
    this.onPressed,
    this.errorWidget,
    this.child,
    super.key
  });

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onPressed,
    child: Container(
      width: radius,
      height: radius,
      padding: padding,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: backgroundColor
      ),
      child: image is String 
      ? CachedNetworkImage(
        imageUrl: image,
        errorListener: (value) {},
        errorWidget: errorWidget != null ?  (context, url, error) => errorWidget! : null,
        imageBuilder: (context, imageProvider) => CircleAvatar(
          backgroundImage: imageProvider,
          backgroundColor: Colors.transparent,
          child: child,
        ) 
      ) 
      : CircleAvatar(
          backgroundImage: MemoryImage(image),
          backgroundColor: Colors.transparent,
          child: child,
      )
    ),
  );  
}



        // imageBuilder: (context, imageProvider) => DecoratedBox(
        //   decoration: BoxDecoration(
        //     shape: BoxShape.circle,
        //     image: DecorationImage(
        //       image: imageProvider,
        //       fit: BoxFit.cover
        //     )
        //   ),
        //   child: child,
          
        // )
      //   imageBuilder: (context, imageProvider) => Container(
      //               height: 250.0,
      //               width: 250.0,
      //               decoration: BoxDecoration(
      //               border: Border.all(
      //               color: Colors.black,
      //               ),
      //               borderRadius: BorderRadius.all(Radius.circular(10)),
      //               color: Colors.white,
      //               image: DecorationImage(
      //               image: imageProvider,
      //               fit: BoxFit.cover,
      //               ),
      //               ),
      //             ),
      // ),
      // child: CircleAvatar(
      //   backgroundImage: (image is String
      //   ? CachedNetworkImageProvider(image)
      //   : MemoryImage(image)) as ImageProvider<Object>,
      //   backgroundColor: Colors.transparent,
      //   onBackgroundImageError: (error, stackTrace) {
      //     print(error);
      //   },
      //   child: child,