import 'package:flutter/widgets.dart';
import 'package:odem/backend/model/manga/reco.dart';

class LocalProperties extends ChangeNotifier {

  static final LocalProperties _instance = LocalProperties._internal();
  factory LocalProperties() => _instance;
  LocalProperties._internal();

  final ValueNotifier<List<RecoModel>> recommendManga = ValueNotifier([]);

}