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
  const InstallExtension(this.source);

  @override
  List<Object?> get props => [source];
}

class LoadOdem extends MangaEvent {
  const LoadOdem();
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