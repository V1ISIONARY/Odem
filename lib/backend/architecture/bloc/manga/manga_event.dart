part of 'manga_bloc.dart';

@immutable
sealed class MangaEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadOdem extends MangaEvent {}
