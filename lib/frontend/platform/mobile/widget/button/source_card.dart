import 'package:flutter/material.dart';
import 'package:odem/backend/model/extension.dart';
import '../schema/text_format.dart';

class SourceCard extends StatelessWidget {
  final Extension? extension;
  final String? sourceTitle;
  final bool within;
  final List<Widget>? action; 

  const SourceCard({
    super.key,
    this.extension,
    this.sourceTitle,
    required this.within,
    this.action,
  });

  String getWeservUrl(String originalUrl) {
    final noProtocol = originalUrl.replaceFirst(RegExp(r'^https?://'), '');
    final parts = noProtocol.split('/'); 
    final domain = parts.first;
    final pathSegments = parts.sublist(1).map(Uri.encodeComponent).join('/');
    return 'https://images.weserv.nl/?url=$domain/$pathSegments';
  }

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
          color: Colors.black,
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
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(5),
                          child: Builder(
                            builder: (context) {
                              return Image.network(
                                getWeservUrl(extension!.logoImg),
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
                            RichText(
                              text: TextSpan(
                                style: TextStyle(color: Colors.white70, fontSize: 10),
                                children: [
                                  TextSpan(text: '${extension?.language ?? ''} ⋅ ${extension?.version ?? ''} ⋅ '),
                                  TextSpan(
                                    text: '${extension?.contentAge ?? ''}',
                                    style: TextStyle(
                                      color: (extension?.contentAge == '18+')
                                        ? Colors.red
                                        : (extension?.contentAge == '13+')
                                          ? Colors.green
                                          : (extension?.contentAge == '7+')
                                            ? const Color.fromARGB(255, 124, 169, 206)
                                            : Colors.white70,
                                    ),
                                  ),
                                ],
                              ),
                            ),

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