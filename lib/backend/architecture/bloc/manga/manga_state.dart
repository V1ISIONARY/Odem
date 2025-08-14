part of 'manga_bloc.dart';

@immutable
sealed class MangaState extends Equatable {
  const MangaState();

  @override
  List<Object?> get props => []; 
}

class OdemInitial extends MangaState {}
class ExtensionLoading extends MangaState {}
class ExtensionLoaded extends MangaState {
  final List<Extension> extensions;
  const ExtensionLoaded(this.extensions);
}
class ExtensionError extends MangaState {
  final String message;
  const ExtensionError(this.message);
}

class ExtensionInstalling extends MangaState {}
class ExtensionInstalled extends MangaState {
  final List<RecoModel> recommended;
  const ExtensionInstalled(this.recommended);
  @override
  List<Object?> get props => [recommended];
}

class FetchReco extends MangaState {
  final List<RecoModel> recommendManga;
  const FetchReco(this.recommendManga);
  @override
  List<Object?> get props => [recommendManga];
}

class FetchSearch extends MangaState {
  final List<RecoModel> recommendManga;
  const FetchSearch(this.recommendManga);
  @override
  List<Object?> get props => [recommendManga];
}

class LoadingMangaImage extends MangaState {
  const LoadingMangaImage();
}
class MangaImageLoaded extends MangaState {
  final List<MangaImgModel> images;
  const MangaImageLoaded(this.images);
  @override
  List<Object?> get props => [images];
}

class LoadingOdem extends MangaState {
  const LoadingOdem();
}

class LoadingSearch extends MangaState {
  const LoadingSearch();
}

class ErrorOdem extends MangaState {
  final String response;
  const ErrorOdem(this.response);
  @override
  List<Object?> get props => [response];
}
