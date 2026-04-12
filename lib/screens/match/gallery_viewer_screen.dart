import 'package:flutter/material.dart';

class GalleryViewerScreen extends StatefulWidget {
  final List images;
  final int initialIndex;

  const GalleryViewerScreen({
    super.key,
    required this.images,
    this.initialIndex = 0,
  });

  @override
  State<GalleryViewerScreen> createState() =>
      _GalleryViewerScreenState();
}

class _GalleryViewerScreenState
    extends State<GalleryViewerScreen> {

  late final PageController _pageController;
  late int currentIndex;

  @override
  void initState() {
    super.initState();

    currentIndex = widget.initialIndex;

    _pageController = PageController(
      initialPage: widget.initialIndex,
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,

      body: Stack(
        children: [

          /// IMÁGENES DESLIZABLES
          PageView.builder(
            controller: _pageController,
            itemCount: widget.images.length,
            onPageChanged: (index) {
              setState(() {
                currentIndex = index;
              });
            },
            itemBuilder: (_, index) {
              return InteractiveViewer(
                minScale: 1,
                maxScale: 4,
                child: Center(
                  child: Hero(
                    tag: "gallery_$index",
                    child: Image.network(
                      widget.images[index],
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              );
            },
          ),

          /// BOTÓN CERRAR
          Positioned(
            top: 55,
            left: 18,
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color.fromRGBO(
                    0,
                    0,
                    0,
                    0.35,
                  ),
                  border: Border.all(
                    color: const Color.fromRGBO(
                      255,
                      255,
                      255,
                      0.15,
                    ),
                  ),
                ),
                child: const Icon(
                  Icons.close,
                  color: Colors.white,
                ),
              ),
            ),
          ),

          /// CONTADOR
          Positioned(
            bottom: 45,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                padding:
                    const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: const Color.fromRGBO(
                    0,
                    0,
                    0,
                    0.45,
                  ),
                  borderRadius:
                      BorderRadius.circular(30),
                ),
                child: Text(
                  "${currentIndex + 1} / ${widget.images.length}",
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight:
                        FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
          ),

          /// INDICADORES
          Positioned(
            bottom: 95,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment:
                  MainAxisAlignment.center,
              children: List.generate(
                widget.images.length,
                (index) {
                  final active =
                      index == currentIndex;

                  return AnimatedContainer(
                    duration:
                        const Duration(
                      milliseconds: 250,
                    ),
                    margin:
                        const EdgeInsets.symmetric(
                      horizontal: 4,
                    ),
                    width: active ? 20 : 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: active
                          ? Colors.white
                          : Colors.white24,
                      borderRadius:
                          BorderRadius.circular(
                        20,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}