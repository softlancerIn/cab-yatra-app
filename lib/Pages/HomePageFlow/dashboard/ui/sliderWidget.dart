import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import '../../../../cores/utils/helperFunctions.dart';
import '../dashboardModel.dart';

class SliderWidget extends StatefulWidget {
  final List<BannerItem> banners;
  const SliderWidget({super.key, required this.banners});

  @override
  State<SliderWidget> createState() => _SliderWidgetState();
}

class _SliderWidgetState extends State<SliderWidget> {
  @override
  Widget build(BuildContext context) {
    if (widget.banners.isEmpty) return const SizedBox.shrink();

    return CarouselSlider(
      items: widget.banners.map((item) {
        return Builder(
          builder: (BuildContext context) {
            return InkWell(
              onTap: () async {
                if (item.url.isNotEmpty) {
                  await HelperFunctions.launchExternalUrl(item.url);
                }
              },
              child: Container(
                width: MediaQuery.of(context).size.width,
                margin: const EdgeInsets.symmetric(horizontal: 12.0),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(
                    item.image,
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
          aspectRatio: 22 / 7,
          enlargeCenterPage: true,
          viewportFraction: 1,
          initialPage: 0,
          autoPlayInterval: const Duration(seconds: 7)),
    );
  }
}
