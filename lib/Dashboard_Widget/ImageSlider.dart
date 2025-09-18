import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class ImageSlider extends StatefulWidget {
  const ImageSlider({super.key});

  @override
  State<ImageSlider> createState() => _ImageSliderState();
}

class _ImageSliderState extends State<ImageSlider> {
  final myItems = [
    'images/food1.jpg',
    'images/food2.jpg',
    'images/food3.jpg',
    'images/food4.jpg',
    'images/coffee1.jpg',
    'images/coffee2.jpg',
    'images/coffee3.jpg',
  ];

  int myCurrentIndex = 0;

  String getCategory(int index) {
    if (index <= 3) return 'Food';
    if (index <= 7) return 'Coffee Shop';
    return 'Restaurant';
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CarouselSlider.builder(
          itemCount: myItems.length,
          itemBuilder: (context, index, realIndex) {
            final item = myItems[index];
            return Stack(
              children: [
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        // ignore: deprecated_member_use
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.asset(
                      item,
                      fit: BoxFit.cover,
                      width: double.infinity,
                    ),
                  ),
                ),
                Positioned(
                  bottom: 20,
                  left: 20,
                  right: 20,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          getCategory(index),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
          options: CarouselOptions(
            autoPlay: true,
            height: 260,
            enlargeCenterPage: true,
            autoPlayCurve: Curves.easeInOut,
            autoPlayAnimationDuration: const Duration(milliseconds: 900),
            autoPlayInterval: const Duration(seconds: 3),
            onPageChanged: (index, reason) {
              setState(() {
                myCurrentIndex = index;
              });
            },
          ),
        ),
        const SizedBox(height: 20),
        AnimatedSmoothIndicator(
          activeIndex: myCurrentIndex,
          count: myItems.length,
          effect: const ExpandingDotsEffect(
            dotHeight: 10,
            dotWidth: 10,
            spacing: 8,
            expansionFactor: 3,
            activeDotColor: Color(0xff213448),
            dotColor: Colors.white54,
          ),
        ),
      ],
    );
  }
}
