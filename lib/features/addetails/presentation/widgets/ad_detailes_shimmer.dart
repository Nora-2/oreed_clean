import 'package:flutter/material.dart';
import 'package:oreed_clean/core/utils/shared_widgets/shimmer.dart';

class AdDetailsShimmerLoading extends StatelessWidget {
  const AdDetailsShimmerLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F6),
      body: SafeArea(
        bottom: false,
        child: CustomScrollView(
          slivers: [
            // AppBar with image shimmer
            SliverAppBar(
              automaticallyImplyLeading: false,
              expandedHeight: 250,
              backgroundColor: Colors.white,
              flexibleSpace: FlexibleSpaceBar(
                background: Stack(
                  children: [
                    // Main image shimmer
                    const ShimmerBox(width: double.infinity, height: 250),
                    // Top action buttons
                    Positioned(
                      top: 10,
                      left: 10,
                      right: 10,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            width: 40,
                            height: 40,
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                            child: const ShimmerBox(
                              width: 40,
                              height: 40,
                              borderRadius: BorderRadius.all(
                                Radius.circular(20),
                              ),
                            ),
                          ),
                          Row(
                            children: [
                              Container(
                                width: 35,
                                height: 35,
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                ),
                                child: const ShimmerBox(
                                  width: 35,
                                  height: 35,
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(17.5),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Container(
                                width: 35,
                                height: 35,
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                ),
                                child: const ShimmerBox(
                                  width: 35,
                                  height: 35,
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(17.5),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Thumbnails shimmer
                  Padding(
                    padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
                    child: SizedBox(
                      height: 70,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: 5,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: const ShimmerBox(width: 70, height: 70),
                            ),
                          );
                        },
                      ),
                    ),
                  ),

                  // Title and Price Card shimmer
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: const Color(0x14000000)),
                      ),
                      child: const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Title
                          ShimmerBox(height: 24, width: double.infinity),
                          SizedBox(height: 8),
                          ShimmerBox(height: 24, width: 200),
                          SizedBox(height: 16),

                          // Price and views row
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              ShimmerBox(height: 20, width: 120),
                              ShimmerBox(height: 20, width: 80),
                            ],
                          ),
                          SizedBox(height: 12),

                          // Location
                          Row(
                            children: [
                              ShimmerBox(
                                height: 16,
                                width: 16,
                                borderRadius: BorderRadius.all(
                                  Radius.circular(4),
                                ),
                              ),
                              SizedBox(width: 8),
                              ShimmerBox(height: 16, width: 150),
                            ],
                          ),
                          SizedBox(height: 8),

                          // Date
                          Row(
                            children: [
                              ShimmerBox(
                                height: 16,
                                width: 16,
                                borderRadius: BorderRadius.all(
                                  Radius.circular(4),
                                ),
                              ),
                              SizedBox(width: 8),
                              ShimmerBox(height: 16, width: 100),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Details Table shimmer
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: const Color(0x14000000)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const ShimmerBox(height: 20, width: 120),
                          const SizedBox(height: 16),
                          ...List.generate(6, (index) {
                            return const Padding(
                              padding: EdgeInsets.only(bottom: 12),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  ShimmerBox(height: 16, width: 100),
                                  ShimmerBox(height: 16, width: 80),
                                ],
                              ),
                            );
                          }),
                        ],
                      ),
                    ),
                  ),

                  // Description Card shimmer
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: const Color(0x14000000)),
                      ),
                      child: const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ShimmerBox(height: 20, width: 100),
                          SizedBox(height: 12),
                          ShimmerBox(height: 16, width: double.infinity),
                          SizedBox(height: 8),
                          ShimmerBox(height: 16, width: double.infinity),
                          SizedBox(height: 8),
                          ShimmerBox(height: 16, width: double.infinity),
                          SizedBox(height: 8),
                          ShimmerBox(height: 16, width: 200),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 80), // Space for bottom bar
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(color: Color(0x11000000))),
        ),
        child: SafeArea(
          top: false,
          child: Row(
            children: [
              Expanded(
                child: Container(
                  height: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const ShimmerBox(height: 50, width: double.infinity),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Container(
                  height: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const ShimmerBox(height: 50, width: double.infinity),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
