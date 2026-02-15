import 'package:bloc/bloc.dart';

class SubcategoriesCubit extends Cubit<List<Map<String, dynamic>>> {
  SubcategoriesCubit() : super([]);
  void loadCategories(List<Map<String, dynamic>> data) {
    emit(data);
  }

  void clear() => emit([]);
}
