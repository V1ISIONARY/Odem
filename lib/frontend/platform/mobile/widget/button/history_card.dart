import 'package:flutter/material.dart';
import 'package:odem/backend/properties/local_properties.dart';
import '../schema/text_format.dart';
import 'package:odem/backend/model/manga/chapter_detail.dart';
import 'package:intl/intl.dart'; 

class HistoryCard extends StatelessWidget {
  final Map<String, List<dynamic>> zipdata;

  const HistoryCard({
    super.key,
    required this.zipdata,
  });

  String getNumericChapter(String chapter) {
    final match = RegExp(r'\d+(\.\d+)?').firstMatch(chapter);
    return match?.group(0) ?? '0';
  }

  Map<String, dynamic>? getTopChapter(dynamic manga) {

    final localProperties = LocalProperties();
    final chapters = (manga.chapterdetails as List<ChapterDetail>?)
        ?.where((c) => c.percentage >= 90 && getNumericChapter(c.chapter).isNotEmpty)
        .toList();
    if (chapters == null || chapters.isEmpty) return null;

    chapters.sort((a, b) {
      final numA = double.parse(getNumericChapter(a.chapter));
      final numB = double.parse(getNumericChapter(b.chapter));
      return numB.compareTo(numA);
    });

    final top = chapters.first;
    return {
      'main_image': localProperties.getWeservUrl(manga.main_image),
      'chapter': getNumericChapter(top.chapter),
      'mangaId': manga.mangaid ?? 'unknownId',
      'title': manga.title ?? 'N/A',
      'percentage': top.percentage,
      'timeRead': top.timeRead,
    };
  }

  String formatDateTime(DateTime time) {
    return DateFormat("MMM d, yyyy h:mma").format(time);
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final Map<String, List<Map<String, dynamic>>> groupedItems = {
      'Today': [],
      'Yesterday': [],
      'Last Week': [],
      'Last Month': [],
      'Earlier': [],
    };

    final items = <Map<String, dynamic>>[];
    zipdata.forEach((sourceKey, mangaList) {
      for (var manga in mangaList) {
        final top = getTopChapter(manga);
        if (top != null) items.add(top);
      }
    });

    for (var item in items) {
      final date = item['timeRead'] as DateTime; 
      final difference = now.difference(date).inDays;

      if (difference == 0) {
        groupedItems['Today']!.add(item);
      } else if (difference == 1) {
        groupedItems['Yesterday']!.add(item);
      } else if (difference <= 7) {
        groupedItems['Last Week']!.add(item);
      } else if (difference <= 30) {
        groupedItems['Last Month']!.add(item);
      } else {
        groupedItems['Earlier']!.add(item);
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: groupedItems.entries
          .map((entry) {
            if (entry.value.isEmpty) return <Widget>[];

            final widgets = <Widget>[
              Padding(
                padding: const EdgeInsets.only(bottom: 15),
                child: ContentTitle(title: entry.key),
              ),
            ];

            widgets.addAll(entry.value.map((item) => _buildHistoryRow(item)));

            return widgets;
          })
          .expand((element) => element)
          .toList(),
    );
  }

  Widget _buildHistoryRow(Map<String, dynamic> item) {
    return Container(
      width: double.infinity,
      color: Colors.black,
      margin: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 80,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(5),
              child: (item['main_image'] as String?)?.isNotEmpty ?? false
                ? Image.network(
                    item['main_image'],
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Image.asset(
                        'lib/resources/image/static/solo.png',
                        fit: BoxFit.cover,
                        color: Colors.white,
                      );
                    },
                  )
                : Image.asset(
                    'lib/resources/image/static/solo.png',
                    fit: BoxFit.cover,
                    color: Colors.white,
                  ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ContentTitle(title: item['title'] ?? 'N/A'),
                ContentDescrip(
                  description:
                    'Chapter ${item['chapter']} ⋅ ${formatDateTime(item['timeRead'] as DateTime)}',
                  size: 9,
                ),
              ],
            ),
          ),
          const Spacer(),
          const Icon(Icons.delete_outline, size: 20, color: Colors.grey),
        ],
      ),
    );
  }
}