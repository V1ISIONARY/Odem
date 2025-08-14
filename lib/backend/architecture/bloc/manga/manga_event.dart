part of 'manga_bloc.dart';

@immutable
sealed class MangaEvent extends Equatable {
  const MangaEvent();

  @override
  List<Object?> get props => [];
}

class LoadExtensions extends MangaEvent {}
class InstallExtension extends MangaEvent {
  final String source;
  final bool fromExt;
  const InstallExtension(
    this.source,
    this.fromExt
  );

  @override
  List<Object?> get props => [source, fromExt];
}

class LoadOdem extends MangaEvent {
  const LoadOdem();
}

class LoadSearch extends MangaEvent {
  final String title;
  final String extKey;
  final bool isSearch;
  const LoadSearch(
    this.title,
    this.extKey,
    this.isSearch
  );
  @override
  List<Object?> get props => [
    title,
    extKey, 
    isSearch
  ];
}

class LoadImage extends MangaEvent {
  const LoadImage();
}

class FetchMangaImages extends MangaEvent {
  final String seriesPath;
  const FetchMangaImages(this.seriesPath);
  @override
  List<Object?> get props => [seriesPath];
}