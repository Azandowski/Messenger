import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class CellShimmerItem extends StatelessWidget {
  
  final double circleSize;

  const CellShimmerItem({
    this.circleSize = 60,
    Key key, 
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Shimmer.fromColors(
        child: Row(
          children: [
            Container(
              width: circleSize,
              height: circleSize,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                color: Colors.white,
              ),
            ),
            SizedBox(width: 10,),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 70,
                  color: Colors.white,
                  height: 15,
                ),
                SizedBox(height: 4,),
                Container(
                  width: 170,
                  color: Colors.white,
                  height: 14,
                ),
              ],
            )
          ],
        ),
        baseColor: Colors.grey[300], 
        highlightColor: Colors.grey[350]
      ),
    );
  }
}