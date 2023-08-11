import 'package:cheese_client/src/components/ui/common/header.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class HomePageLoading extends StatelessWidget {
  const HomePageLoading({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const Header(title: ""),
      body: Shimmer.fromColors(
          baseColor: Colors.grey.shade300,
          highlightColor: Colors.grey.shade100,
          enabled: true,
          child: SingleChildScrollView(
              physics: const NeverScrollableScrollPhysics(),
              child: Container(
                  padding: const EdgeInsets.all(32.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Container(
                        width: 240,
                        height: 24,
                        color: Colors.white,
                      ),
                      const SizedBox(height: 16),
                      Container(
                        width: 160,
                        height: 12,
                        color: Colors.white,
                      ),
                      const SizedBox(height: 16),
                      Row(children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Container(
                            width: 72,
                            height: 72,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(width: 8),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Container(
                            width: 72,
                            height: 72,
                            color: Colors.white,
                          ),
                        ),
                      ]),
                      const SizedBox(height: 16),
                      AspectRatio(
                        aspectRatio: 1.0,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Container(
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(100),
                            child: Container(
                              width: 72,
                              height: 72,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(width: 8),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(100),
                            child: Container(
                              width: 72,
                              height: 72,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      )
                    ],
                  )))),
    );
  }
}
