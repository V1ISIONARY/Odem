import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:odem/backend/architecture/bloc/manga/manga_bloc.dart';
import 'package:odem/backend/model/extension.dart';
import 'package:odem/backend/properties/local_properties.dart';
import 'package:odem/frontend/platform/mobile/widget/schema/text_format.dart';
import '../../../widget/button/source_card.dart';

class Migrate extends StatefulWidget {
  const Migrate({super.key});

  @override
  State<Migrate> createState() => _MigrateState();
}

class _MigrateState extends State<Migrate> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  final localProperties = LocalProperties();
  int? loadingIndex;

  Future<void> _onSourceCardTap(int index, Extension? ext) async {
    if (loadingIndex != null) return;
    setState(() {
      loadingIndex = index;
    });
    if (ext != null) {
      context.read<MangaBloc>().add(InstallExtension(ext.key)); 
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BlocListener<MangaBloc, MangaState>(
      listener: (context, state) {
        if (state is ExtensionInstalled || state is ErrorOdem) {
          setState(() {
            loadingIndex = null; 
          });
        }
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                padding: EdgeInsets.only(
                  right: 15,
                  left: 15,
                  bottom: 14
                ),
                child: Row(
                  children: [
                    const ContentTitle(title: "Select a source to migrate from"),
                    const Spacer(),
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                          },
                          child: Container(
                            width: 50,
                            child: const Center(
                              child: Icon(
                                Icons.sort_by_alpha,
                                size: 20,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                          },
                          child: Container(
                            width: 50,
                            child: const Center(
                              child: Icon(
                                Icons.arrow_upward_outlined,
                                size: 20,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ValueListenableBuilder<List<Extension>>(
                  valueListenable: localProperties.migrateExtension,
                  builder: (context, migrateExtensions, _) {
                    if (migrateExtensions.isEmpty) {
                      return const Center(
                        child: Text(
                          'No extensions to migrate',
                          style: TextStyle(color: Colors.white),
                        ),
                      );
                    }

                    return ListView.builder(
                      itemCount: migrateExtensions.length,
                      itemBuilder: (context, index) {
                        final ext = migrateExtensions[index];
                        final isLoading = loadingIndex == index;

                        return GestureDetector(
                          child: SourceCard(
                            sourceTitle: '',
                            within: false,
                            extension: ext,
                            action: [
                              GestureDetector(
                                onTap: isLoading
                                  ? null
                                  : () => _onSourceCardTap(index, ext),
                                child: Container(
                                  width: 50,
                                  child: Center(
                                    child: isLoading
                                      ? const SizedBox(
                                          width: 20,
                                          height: 20,
                                          child: CircularProgressIndicator(
                                            color: Colors.white,
                                            strokeWidth: 2,
                                          ),
                                        )
                                      : SvgPicture.asset(
                                        'lib/resources/svg/database_upload.svg',
                                        color: Colors.white,
                                        height: 20,
                                        width: 20,
                                      )
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}