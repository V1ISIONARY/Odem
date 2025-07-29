import 'package:flutter_bloc/flutter_bloc.dart';

class sourcePage extends Cubit<int> {

  sourcePage() : super(0);
  void changeSelectedIndex(int index) {
    emit(index);
  }
  
}

class BottomNavBloc extends Cubit<int> {
  BottomNavBloc() : super(0);

  void changeSelectedIndex(int index) => emit(index);
}