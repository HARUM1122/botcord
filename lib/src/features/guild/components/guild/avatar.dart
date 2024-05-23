// import 'package:flutter/material.dart';
// import 'package:cached_network_image/cached_network_image.dart';

// class GulidAvatar extends StatelessWidget {
//   final String imageUrl;
//   final Widget? errorWidget;

//   const GulidAvatar({
//     required this.imageUrl, 
//     this.errorWidget,
//     super.key
//   });

//   @override
//   Widget build(BuildContext context) => CachedNetworkImage(
//     imageUrl: imageUrl,
//     errorListener: (value) {},
//     errorWidget: errorWidget != null ?  (context, url, error) => errorWidget! : null,
//   );  
// }