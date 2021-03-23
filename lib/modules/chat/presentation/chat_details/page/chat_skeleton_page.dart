import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../widgets/divider_wrapper.dart';

class ChatSkeletonPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Container(
            child: Stack(
              children: [
                Column(
                  children: [
                    Shimmer.fromColors(
                      child: Container(
                        height: 228,
                        color: Colors.white,
                      ), 
                      baseColor: Colors.grey[300], 
                      highlightColor: Colors.grey[350]
                    ),
                    Container(
                      height: 115, 
                      color: Colors.grey[200],
                    )
                  ],
                ),
                Positioned(
                  bottom: 20,
                  left: 16,
                  right: 16,
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    width: MediaQuery.of(context).size.width - 32,
                    decoration: BoxDecoration(
                      color: Colors.white54,
                      borderRadius: BorderRadius.circular(16)
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Shimmer.fromColors(
                              child: Container(
                                width: 140,
                                height: 20,
                                color: Colors.white,
                              ), 
                              baseColor: Colors.grey[300], 
                              highlightColor: Colors.grey[350]
                            ),
                            SizedBox(height: 4),
                            Shimmer.fromColors(
                              child: Container(
                                width: 240,
                                height: 24,
                                color: Colors.white,
                              ), 
                              baseColor: Colors.grey[300], 
                              highlightColor: Colors.grey[350]
                            ),
                          ],
                        ),
                        Divider(),
                        Shimmer.fromColors(
                          child: Container(
                            width: 280,
                            height: 16,
                            color: Colors.white,
                          ), 
                          baseColor: Colors.grey[300], 
                          highlightColor: Colors.grey[350]
                        ),
                      ],
                    )
                  )
                )
              ],
            )
          ),
          DividerWrapper(
            children: [
               Shimmer.fromColors(
                child: Container(
                  height: 64,
                  color: Colors.white,
                ), 
                baseColor: Colors.grey[300], 
                highlightColor: Colors.grey[350]
              ),
              Shimmer.fromColors(
                child: Container(
                  height: 64,
                  color: Colors.white,
                ), 
                baseColor: Colors.grey[300], 
                highlightColor: Colors.grey[350]
              ),
            ]
          ),
        ],
      ),
    );
  }
}