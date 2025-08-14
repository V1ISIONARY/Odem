import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';
import 'package:odem/backend/model/extension.dart';
import 'package:odem/backend/model/manga/chapter_detail.dart';
import 'package:odem/backend/model/manga/recommend.dart';
import 'package:odem/backend/repositories/manga-repository.dart';

part 'manga_event.dart';
part 'manga_state.dart';

class MangaBloc extends Bloc<MangaEvent, MangaState> {
  final MangaRepository repository;

  MangaBloc(this.repository) : super(OdemInitial()) {

    on<LoadExtensions>((event, emit) async {
      emit(ExtensionLoading());
      try {
        final extensions = await repository.fetchExtensions();
        emit(ExtensionLoaded(extensions));
      } catch (e) {
        emit(ExtensionError(e.toString()));
      }
    });

    on<LoadOdem>((event, emit) async {
      emit(LoadingOdem());
      try {
        final recommendManga = await repository.getRecommended();
        emit(FetchReco(recommendManga));
      } catch (e) {
        emit(ErrorOdem("Failed to fetch recommendation list"));
      }
    });

    on<LoadSearch>((event, emit) async {
      emit(LoadingSearch());
      try {
        final searchingManga = await repository.searchManga(
          event.title, 
          event.extKey,
          event.isSearch
        );
        emit(FetchSearch(searchingManga));
      } catch (e) {
        emit(ErrorOdem("Failed to fetch recommendation list"));
      }
    });

    on<InstallExtension>((event, emit) async {
      emit(ExtensionInstalling());
      try {
        final installingExt = await repository.InstallExtension(event.source, event.fromExt);
        emit(ExtensionInstalled(installingExt));
      } catch (e) {
        emit(ErrorOdem("Failed to install extension"));
      }
    });

    on<FetchMangaImages>((event, emit) async {
      emit(LoadingMangaImage());
      try {
        final images = await repository.fetchMangaImages(event.seriesPath);
        emit(MangaImageLoaded(images));
      } catch (e) {
        emit(ErrorOdem(e.toString()));
      }
    });

  }

}
