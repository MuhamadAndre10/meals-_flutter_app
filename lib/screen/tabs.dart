import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:meals_app/providers/favorite_provider.dart';
import 'package:meals_app/providers/filter_provider.dart';
import 'package:meals_app/providers/meals_provider.dart';
import 'package:meals_app/screen/categories.dart';
import 'package:meals_app/screen/filters.dart';
import 'package:meals_app/screen/meals.dart';
import 'package:meals_app/widgets/main_drawe.dart';

const kInitialFilter = {
  Filter.gluttenFree: false,
  Filter.loctoseFree: false,
  Filter.vegetarian: false,
  Filter.vegan: false,
};

class TabsScreen extends ConsumerStatefulWidget {
  const TabsScreen({super.key});

  @override
  ConsumerState<TabsScreen> createState() => _TabsScreenState();
}

class _TabsScreenState extends ConsumerState<TabsScreen> {
  int _selectedPageIndex = 0;

  // make a bucket for  the favorites meal
  Map<Filter, bool> _selectedFilter = kInitialFilter;


  // add a fanc for add or remove favorite meal.
  // void _toggleMealFavorite(Meal meal) {
  //   final isFavorite = _favoriteMeal.contains(meal);

  //   if (isFavorite) {
  //     setState(() {
  //       _favoriteMeal.remove(meal);
  //     });
  //     _showInfoMessage("Meal is no longer a favorite");
  //   } else {
  //     setState(() {
  //       _favoriteMeal.add(meal);
  //     });
  //     _showInfoMessage("added meal in favorite");
  //   }
  // }

  void selectedPage(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  void _setScreen(String identifier) async {
    Navigator.of(context).pop();
    if (identifier == "filters") {
      final result = await Navigator.of(context).push<Map<Filter, bool>>(
        MaterialPageRoute(
          builder: (context) => FiltersScreen(currentFilter: _selectedFilter),
        ),
      );

      setState(() {
        _selectedFilter = result ?? kInitialFilter; // keyword ?? : if null.
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final meals = ref.watch(mealProvider);

    final availableList = meals.where((meal) {
      if (_selectedFilter[Filter.gluttenFree]! && !meal.isGlutenFree) {
        return false;
      }
      if (_selectedFilter[Filter.loctoseFree]! && !meal.isLactoseFree) {
        return false;
      }
      if (_selectedFilter[Filter.vegetarian]! && !meal.isVegetarian) {
        return false;
      }
      if (_selectedFilter[Filter.vegan]! && !meal.isVegan) {
        return false;
      }
      return true;
    }).toList();

    Widget activePage = CategoriesScreen(
      availableList: availableList,
    );
    var activePageTitle = 'Categories';

    if (_selectedPageIndex == 1) {
      final favoriteMeals = ref.watch(favoriteMealProvider);
      activePage = MealsScreen(
        meals: favoriteMeals,
      );
      activePageTitle = 'Your favorites';
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(activePageTitle),
      ),
      drawer: MainDrawer(selectScreen: _setScreen),
      body: activePage,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedPageIndex,
        onTap: selectedPage,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.set_meal),
            label: "Categories",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.star),
            label: "Favorites",
          ),
        ],
      ),
    );
  }
}
