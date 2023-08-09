import 'package:cheese_client/src/components/ui/common/header.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ProfilePageLoading extends StatelessWidget {
  const ProfilePageLoading({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const Header(title: "マイページ"),
      body: Shimmer.fromColors(
          baseColor: Colors.grey.shade300,
          highlightColor: Colors.grey.shade100,
          enabled: true,
          child: SingleChildScrollView(
              physics: NeverScrollableScrollPhysics(),
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    const SizedBox(height: 16),
                    const CircleAvatar(
                      radius: 42,
                      backgroundColor: Colors.white,
                    ),
                    const SizedBox(height: 16),
                    Container(
                      width: 100,
                      height: 24,
                      color: Colors.white,
                    ),
                    const SizedBox(height: 16),
                    Container(
                      width: 200,
                      height: 24,
                      color: Colors.white,
                    ),
                    const SizedBox(height: 16),
                    GridView.count(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisCount: 2,
                      children: List.generate(
                        4,
                        (index) => Container(
                          margin: const EdgeInsets.all(8),
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ))),
    );
  }
}
