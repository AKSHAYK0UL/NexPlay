import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class ListImageWidget extends StatelessWidget {
  String imageUrl;
  ListImageWidget(this.imageUrl);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.blue.shade50,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: CachedNetworkImage(
          imageUrl: imageUrl,
          fit: BoxFit.fill,
        ),
      ),
    );
  }
}
