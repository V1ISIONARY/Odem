part of 'manga_bloc.dart';

@immutable
sealed class MangaState extends Equatable {
  const MangaState();
  @override
  List<Object> get props => [];
}

class FetchReco extends MangaState {
  final List<RecoModel> recommendManga;
  const FetchReco(this.recommendManga);

  @override
  List<Object> get props => [recommendManga];
}

class LoadingOdem extends MangaState {}
class ErrorOdem extends MangaState {
  final String response;
  const ErrorOdem(this.response);

  @override
  List<Object> get props => [response];
}