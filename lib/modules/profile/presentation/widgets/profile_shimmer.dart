import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ProfilePageShimmer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
            color: Colors.white,
            child: Shimmer.fromColors(
              baseColor: Colors.grey[300],
              highlightColor: Colors.grey[100],
              child: Row(
                children: [
                  Container(
                    width: 70,
                    height: 70,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(35),
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(width: 10,),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 120,
                        height: 17,
                        color: Colors.white,
                      ),
                      SizedBox(height: 5,),
                      Container(
                        width: 160,
                        height: 17,
                        color: Colors.white,
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
          buildSeparator(),
          shimmerItem(),
          buildSeparator(),
          shimmerItem(),
          buildSeparator(),
          shimmerItem()
        ],
      ),
    );
  }

  Widget buildSeparator () {
    return SizedBox(
      height: 25,
      child: Container(color: Colors.grey[200],),
    );
  }

  Widget shimmerItem () {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
      color: Colors.white,
      child: Shimmer.fromColors(
        baseColor: Colors.grey[300],
        highlightColor: Colors.grey[100],
        child: Row(
          children: [
            Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: Colors.white,
              ),
            ),
            SizedBox(width: 20,),
            Container(
              width: 180,
              height: 20,
              color: Colors.white,
            )
          ],
        )
      )
    );
  }
}