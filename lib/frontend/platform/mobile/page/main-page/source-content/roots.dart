import 'package:odem/backend/properties/local_properties.dart';
import 'package:odem/backend/model/extension.dart';
import '../../../widget/button/source_card.dart';
import 'package:flutter/material.dart';

class Roots extends StatefulWidget {
  const Roots({super.key});

  @override
  State<Roots> createState() => _RootsState();
}

class _RootsState extends State<Roots>
    with AutomaticKeepAliveClientMixin, SingleTickerProviderStateMixin {
  @override
  bool get wantKeepAlive => true;

  final localProperties = LocalProperties();
  int? selectedIndex;
  late AnimationController _rotationController;

  @override
  void initState() {
    super.initState();
    _rotationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );

    final initIdx = localProperties.selectedRootIndex.value;
    if (initIdx != null) {
      selectedIndex = initIdx;
    }

    localProperties.selectedRootIndex.addListener(() {
      final idx = localProperties.selectedRootIndex.value;
      setState(() {
        selectedIndex = idx;
      });
    });

    localProperties.rootsExtension.addListener(() {
      final list = localProperties.rootsExtension.value;
      if (list.isNotEmpty) {
        if (selectedIndex == null || selectedIndex! >= list.length) {
          final saved = localProperties.selectedRootIndex.value;
          setState(() {
            selectedIndex = saved ?? 0;
          });
        }
      } else {
        setState(() {
          selectedIndex = null;
        });
      }
    });
  }

  @override
  void dispose() {
    _rotationController.dispose();
    super.dispose();
  }

  Future<void> _onSourceCardTap(int idx, Extension extension) async {
    setState(() {
      selectedIndex = idx;
    });
    _rotationController.reset();
    _rotationController.forward();
    await localProperties.setMangaRootByIndex(idx);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      backgroundColor: Colors.black,
      body: ValueListenableBuilder<List<Extension>>(
        valueListenable: localProperties.rootsExtension,
        builder: (context, rootsExtensions, _) {
          if (rootsExtensions.isEmpty) {
            return const Center(
              child: Text(
                'No root extensions found',
                style: TextStyle(color: Colors.white),
              ),
            );
          }

          final centralizedIdx = localProperties.selectedRootIndex.value;
          final useIndex = centralizedIdx ?? selectedIndex;

          List<Extension> orderedExtensions = List.from(rootsExtensions);
          if (useIndex != null &&
              useIndex >= 0 &&
              useIndex < orderedExtensions.length) {
            final selectedItem = orderedExtensions.removeAt(useIndex);
            orderedExtensions.insert(0, selectedItem);
          }

          return AnimatedSwitcher(
            duration: const Duration(milliseconds: 500),
            transitionBuilder: (child, animation) {
              return FadeTransition(
                opacity: animation,
                child: child,
              );
            },
            child: ListView(
              key: ValueKey(orderedExtensions.map((e) => e.key).join(',')),
              padding: const EdgeInsets.symmetric(vertical: 10),
              children: orderedExtensions.asMap().entries.map((entry) {
                int idx = entry.key;
                Extension ext = entry.value;
                final isSelected = idx == 0;

                return GestureDetector(
                  onTap: () {
                    final originalIndex = rootsExtensions.indexOf(ext);
                    _onSourceCardTap(originalIndex, ext);
                  },
                  child: SourceCard(
                    sourceTitle: 'Roots',
                    within: isSelected,
                    extension: ext,
                    action: [
                      SizedBox(
                        width: 50,
                        child: Center(
                          child: isSelected
                            ? AnimatedBuilder(
                                animation: _rotationController,
                                builder: (context, child) {
                                  return Transform.rotate(
                                    angle: _rotationController.value * 2 * 3.1415926535,
                                    child: child,
                                  );
                                },
                                child: const Icon(
                                  Icons.cyclone,
                                  color: Colors.white,
                                  size: 20,
                                ),
                              )
                            : const Icon(
                                Icons.cyclone,
                                color: Colors.white38,
                                size: 20,
                              ),
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          );
        },
      ),
    );
  }

}
