import 'package:flutter/material.dart';
import 'package:food_ordering_app/model/popular_restaurant_detail_screen_model.dart';

class SearchViewModel extends ChangeNotifier {
  List<PopularRestaurantDetailScreenModel> _allRestaurants = [];

  List<PopularRestaurantDetailScreenModel> _filteredRestaurants = [];

  List<PopularRestaurantDetailScreenModel> get restaurants =>
      _filteredRestaurants;

  String _searchQuery = "";

  String get searchQuery => _searchQuery;

  // Load restaurant data
  void setRestaurants(List<PopularRestaurantDetailScreenModel> restaurants) {
    _allRestaurants = restaurants;
    _filteredRestaurants = restaurants;

    notifyListeners();
  }

  // Search logic
  void searchRestaurant(String query) {
    _searchQuery = query;

    if (query.isEmpty) {
      _filteredRestaurants = _allRestaurants;
    } else {
      _filteredRestaurants = _allRestaurants.where((restaurant) {
        return restaurant.name.toLowerCase().contains(query.toLowerCase());
      }).toList();
    }

    notifyListeners();
  }

  // Clear search
  void clearSearch() {
    _searchQuery = "";

    _filteredRestaurants = _allRestaurants;

    notifyListeners();
  }
}
