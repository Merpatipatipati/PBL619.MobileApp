import 'package:flutter/material.dart';

class PanduanCarouselWidget extends StatelessWidget {
  final PageController pageController;
  final int currentSlide;
  final List<Map<String, dynamic>> panduanData;
  final ValueChanged<int> onPageChanged;

  const PanduanCarouselWidget({
    super.key,
    required this.pageController,
    required this.currentSlide,
    required this.panduanData,
    required this.onPageChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 180,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: PageView.builder(
                controller: pageController,
                onPageChanged: onPageChanged,
                itemCount: panduanData.length,
                itemBuilder: (context, index) {
                  final panduan = panduanData[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => panduan['page'],
                        ),
                      );
                    },
                    child: Stack(
                      children: [
                        Container(
                          width: double.infinity,
                          height: 180,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage(panduan['image']),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Container(
                          width: double.infinity,
                          height: 180,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.transparent,
                                Colors.black.withValues(alpha: 0.8),
                              ],
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 20,
                          left: 20,
                          right: 20,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                panduan['title'],
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                panduan['subtitle'],
                                style: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              panduanData.length,
              (index) => Container(
                margin: const EdgeInsets.symmetric(horizontal: 3),
                width: currentSlide == index ? 20 : 8,
                height: 8,
                decoration: BoxDecoration(
                  color: currentSlide == index
                      ? const Color.fromARGB(255, 8, 143, 78)
                      : Colors.grey.withValues(alpha: 0.4),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
