import 'package:flutter_riverpod/flutter_riverpod.dart';

enum Filter {
  gluttenFree,
  loctoseFree,
  vegetarian,
  vegan,
}

class FiltersNotifer extends StateNotifier<Map<Filter, bool>> {
  FiltersNotifer()
      : super({
          Filter.gluttenFree: false,
          Filter.loctoseFree: false,
          Filter.vegetarian: false,
          Filter.vegan: false,
        });

  // method untuk memanipulasi state.
  void setFilter(Filter filter, bool isActive) {
    state = {
      ...state,
      filter: isActive,
    };
  }
}

final filtersProviders =
    StateNotifierProvider<FiltersNotifer, Map<Filter, bool>>(
        (ref) => FiltersNotifer());
