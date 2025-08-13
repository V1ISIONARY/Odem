import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:odem/backend/model/extension.dart';
import '../schema/text_format.dart';

class SourceCard extends StatelessWidget {
  final Extension? extension;
  final String? sourceTitle;
  final bool within;
  final List<Widget>? action; // dynamic list of widgets for trailing actions

  const SourceCard({
    super.key,
    this.extension,
    this.sourceTitle,
    required this.within,
    this.action,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (within)
          Padding(
            padding: const EdgeInsets.only(top: 10, bottom: 10, left: 15),
            child: ContentTitle(title: sourceTitle ?? ''),
          ),
        Container(
          height: 50,
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 15),
          margin: const EdgeInsets.only(bottom: 10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                child: GestureDetector(
                  child: Container(
                    color: Colors.transparent,
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(5),
                          child: Builder(
                            builder: (context) {
                              String imageUrl = '';
                              if (extension?.logoImg.isNotEmpty ?? false) {
                                if (kIsWeb) {
                                  imageUrl = 'https://images.weserv.nl/?url=' +
                                      Uri.encodeComponent(
                                          extension!.logoImg.replaceFirst('https://', ''));
                                } else {
                                  imageUrl = extension!.logoImg;
                                }
                              }
                              return Image.network(
                                imageUrl,
                                width: 30,
                                height: 30,
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) => Image.asset(
                                  'lib/resources/image/static/solo.png',
                                  fit: BoxFit.cover,
                                  color: Colors.white,
                                ),
                              );
                            },
                          ),
                        ),
                        const SizedBox(width: 15),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ContentTitle(title: extension?.exName ?? ''),
                            ContentDescrip(description: '${extension?.language ?? ''} ⋅ ${extension?.version ?? ''}'),
                          ],
                        ),
                        const Spacer(),
                      ],
                    ),
                  ),
                ),
              ),
              if (action != null)
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: action!,
                ),
            ],
          ),
        ),
      ],
    );
  }
}