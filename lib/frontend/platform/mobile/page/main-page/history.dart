import 'package:flutter/material.dart';
import 'package:odem/backend/model/manga/recommend.dart';
import 'package:odem/frontend/platform/mobile/widget/button/history_card.dart';
import 'package:odem/frontend/platform/mobile/widget/schema/text_format.dart';
import 'package:odem/backend/properties/local_properties.dart';
import 'package:odem/backend/model/manga/chapter_detail.dart';

class History extends StatefulWidget {
  const History({super.key});

  @override
  State<History> createState() => _HistoryState();
}

class _HistoryState extends State<History> {
  final LocalProperties localProperties = LocalProperties();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
        centerTitle: false,
        title: const Text(
          'History',
          style: TextStyle(fontSize: 15, color: Colors.white),
        ),
        actions: [
          Container(
            width: 150,
            margin: const EdgeInsets.only(right: 10),
            color: Colors.transparent,
            child: Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () {},
                    child: const Icon(Icons.search_outlined,
                        color: Colors.white, size: 20),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () {},
                    child: const Icon(Icons.widgets_outlined,
                        color: Colors.white, size: 20),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () {},
                    child: const Icon(Icons.delete_sweep,
                        color: Colors.white, size: 20),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: 15),
        child: Builder(
          builder: (context) {
            final allManga = localProperties.libraryData.value.values
                .expand((list) => list.cast<RecoModel>())
                .toList();

            // Check if ANY chapter across all manga has percentage >= 90
            final hasHistory = allManga.any(
              (manga) => manga.chapterdetails.any((c) => c.percentage >= 90),
            );

            if (!hasHistory) {
              return const Center(
                child: Text(
                  "No history yet",
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
              );
            }

            return ListView(
              children: [
                HistoryCard(
                  zipdata: localProperties.libraryData.value,
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}