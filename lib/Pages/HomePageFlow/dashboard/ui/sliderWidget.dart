import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';


import '../../../../cores/utils/helperFunctions.dart';
class SliderWidget extends StatefulWidget {
  const SliderWidget({super.key});

  @override
  State<SliderWidget> createState() => _SliderWidgetState();
}

class _SliderWidgetState extends State<SliderWidget> {
  List bannerList = [
    'assets/images/banner22.png',
    'assets/images/banner22.png',
  ];
  @override
  Widget build(BuildContext context) {
    return CarouselSlider(
      items: bannerList.map((image) {
        return Builder(
          builder: (BuildContext context) {
            return InkWell(
              onTap: () async {
                if (image.url != null && image.url!.isNotEmpty) {
                  await HelperFunctions.launchExternalUrl(image.url!);
                } else {
                  print('No URL available for this banner.');
                }
              },
              child: Container(
                width: MediaQuery.of(context).size.width,
                margin: const EdgeInsets.symmetric(horizontal: 14.0),
                decoration: BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.asset(
                    // image.image.toString(),
                    'assets/images/banner22.png',
                    fit: BoxFit.fill,
                    errorBuilder: (context, url, error) => Image.asset(
                      'assets/images/banner22.png',
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
              ),
            );
          },
        );
      }).toList(),
      options: CarouselOptions(
          onPageChanged: (index, reason) {},
          autoPlay: true,
          aspectRatio: 20 / 9,
          enlargeCenterPage: true,
          viewportFraction: 1,
          initialPage: 0,
          autoPlayInterval: const Duration(seconds: 7)),
    );
  }
}
