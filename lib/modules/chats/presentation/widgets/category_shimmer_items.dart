import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class CategoryShimmerItems extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    return Container(
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [1,2,3,4,5].map((e) {
            return Padding(
              padding: const EdgeInsets.only(right: 20),
              child: Column(
                children: [
                  Shimmer.fromColors(
                    child: Container(
                      width: 75,
                      height: 75,
                      color: Colors.white,
                    ), 
                    baseColor: Colors.grey[300], 
                    highlightColor: Colors.grey[350]
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Shimmer.fromColors(
                    baseColor: Colors.grey[300], 
                    highlightColor: Colors.grey[350],
                    child: Container(
                      width: 50,
                      height: 14,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      )
    );
  }
}