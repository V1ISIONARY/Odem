import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';
import 'package:odem/backend/model/manga/reco.dart';
import 'package:odem/backend/repositories/manga-repository.dart';

part 'manga_event.dart';
part 'manga_state.dart';

class MangaBloc extends Bloc<MangaEvent, MangaState> {
  final MangaRepository repository;

  MangaBloc(this.repository) : super(LoadingOdem()) {

    on<LoadOdem>((event, emit) async {
      emit(LoadingOdem());
      try {
        final recommendManga = await repository.getRecommended();
        emit(FetchReco(recommendManga));
      } catch (e) {
        emit(ErrorOdem("Failed to fetch recommendation list"));
      }
    });

  }

}
