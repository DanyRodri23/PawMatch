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
      initialPage: currentIndex,
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    /// SI NO HAY FOTOS
    if (widget.images.isEmpty) {
      return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.black,
          iconTheme:
              const IconThemeData(
            color: Colors.white,
          ),
        ),
        body: const Center(
          child: Text(
            "Sin imágenes",
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
            ),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.black,

      body: Stack(
        children: [

          /// IMÁGENES
          PageView.builder(
            controller:
                _pageController,
            itemCount:
                widget.images.length,
            onPageChanged:
                (index) {
              setState(() {
                currentIndex =
                    index;
              });
            },
            itemBuilder:
                (_, index) {
              return InteractiveViewer(
                minScale: 1,
                maxScale: 4,
                child: Center(
                  child: Hero(
                    tag:
                        "gallery_${widget.images[index]}_$index",
                    child:
                        Image.network(
                      widget.images[index],
                      fit:
                          BoxFit.contain,

                      loadingBuilder:
                          (
                        context,
                        child,
                        progress,
                      ) {
                        if (progress ==
                            null) {
                          return child;
                        }

                        return const Center(
                          child:
                              CircularProgressIndicator(
                            color:
                                Colors.white,
                          ),
                        );
                      },

                      errorBuilder:
                          (
                        context,
                        error,
                        stackTrace,
                      ) {
                        return const Center(
                          child: Icon(
                            Icons
                                .broken_image,
                            color:
                                Colors.white54,
                            size:
                                55,
                          ),
                        );
                      },
                    ),
                  ),
                ),
              );
            },
          ),

          /// BOTÓN CERRAR
          SafeArea(
            child: Padding(
              padding:
                  const EdgeInsets.all(
                16,
              ),
              child: Row(
                children: [

                  _circleButton(
                    Icons.close,
                    () {
                      Navigator.pop(
                          context);
                    },
                  ),

                  const Spacer(),

                  Container(
                    padding:
                        const EdgeInsets.symmetric(
                      horizontal:
                          16,
                      vertical: 9,
                    ),
                    decoration:
                        BoxDecoration(
                      color:
                          Colors.black54,
                      borderRadius:
                          BorderRadius.circular(
                        30,
                      ),
                      border: Border.all(
                        color:
                            Colors.white12,
                      ),
                    ),
                    child: Text(
                      "${currentIndex + 1} / ${widget.images.length}",
                      style:
                          const TextStyle(
                        color:
                            Colors.white,
                        fontWeight:
                            FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          /// DOTS
          Positioned(
            bottom: 110,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment:
                  MainAxisAlignment
                      .center,
              children:
                  List.generate(
                widget.images.length,
                (index) {
                  final active =
                      index ==
                          currentIndex;

                  return AnimatedContainer(
                    duration:
                        const Duration(
                      milliseconds:
                          250,
                    ),
                    margin:
                        const EdgeInsets.symmetric(
                      horizontal:
                          4,
                    ),
                    width:
                        active
                            ? 22
                            : 8,
                    height: 8,
                    decoration:
                        BoxDecoration(
                      color:
                          active
                              ? Colors
                                  .white
                              : Colors
                                  .white24,
                      borderRadius:
                          BorderRadius.circular(
                        30,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),

          /// MINIATURAS
          Positioned(
            bottom: 26,
            left: 0,
            right: 0,
            child: SizedBox(
              height: 72,
              child: ListView.builder(
                scrollDirection:
                    Axis.horizontal,
                padding:
                    const EdgeInsets.symmetric(
                  horizontal: 14,
                ),
                itemCount:
                    widget.images.length,
                itemBuilder:
                    (_, index) {
                  final active =
                      index ==
                          currentIndex;

                  return GestureDetector(
                    onTap: () {
                      _pageController
                          .animateToPage(
                        index,
                        duration:
                            const Duration(
                          milliseconds:
                              300,
                        ),
                        curve:
                            Curves.ease,
                      );
                    },
                    child:
                        AnimatedContainer(
                      duration:
                          const Duration(
                        milliseconds:
                            220,
                      ),
                      width: 62,
                      margin:
                          const EdgeInsets.only(
                        right: 10,
                      ),
                      decoration:
                          BoxDecoration(
                        borderRadius:
                            BorderRadius.circular(
                          14,
                        ),
                        border:
                            Border.all(
                          color:
                              active
                                  ? Colors
                                      .blue
                                  : Colors
                                      .white24,
                          width: 2,
                        ),
                      ),
                      child:
                          ClipRRect(
                        borderRadius:
                            BorderRadius.circular(
                          12,
                        ),
                        child:
                            Image.network(
                          widget.images[index],
                          fit:
                              BoxFit.cover,
                        ),
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

  Widget _circleButton(
    IconData icon,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 46,
        height: 46,
        decoration:
            BoxDecoration(
          color:
              Colors.black54,
          shape:
              BoxShape.circle,
          border: Border.all(
            color:
                Colors.white12,
          ),
        ),
        child: Icon(
          icon,
          color:
              Colors.white,
        ),
      ),
    );
  }
}