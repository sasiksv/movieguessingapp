import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'moviescreen.dart';
import 'main.dart';

class GenreSelectionScreen extends StatefulWidget {
  const GenreSelectionScreen({super.key});

  @override
  _GenreSelectionScreenState createState() => _GenreSelectionScreenState();
}

class _GenreSelectionScreenState extends State<GenreSelectionScreen> {
  String? selectedCategory;

  final Map<String, List<String>> genreCategories = {
    'Fiction': [
      'Action',
      'Thriller',
      'Adventure',
      'Crime',
      'Fantasy',
      'Sci-Fi',
      'Horror',
      'War'
    ],
    'Non-Fiction': ['Biographical', 'Sports'],
    'Comedy': ['Comedy', 'Sitcom'],
    'Art': ['Musical'],
    'Animated': ['Animated'],
    'Romance': ['Romance'],
  };

  @override
  void initState() {
    super.initState();
    _loadSelectedCategory();
  }

  Future<void> _loadSelectedCategory() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      // Start with null category on app launch
      selectedCategory = null;
    });
  }

  Future<void> _saveSelectedCategory(String? category) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (category != null && category.isNotEmpty) {
      await prefs.setString('selectedCategory', category);
    } else {
      await prefs.remove('selectedCategory');
    }
  }

  Future<void> _navigateToMoviesScreen(String genre) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Only save the quote progress index
    int startIndex = prefs.getInt('quote_progress_$genre') ?? 0;

    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) =>
            MoviesScreen(genre: genre, startIndex: startIndex),
      ),
    );

    // Increment the quote progress after navigating
    await prefs.setInt('quote_progress_$genre', startIndex + 1);
  }

  // Override the back button to navigate between category and genre selection
  Future<bool> _onWillPop() async {
    // Check if a genre is selected
    if (selectedCategory != null) {
      setState(() {
        // Reset the category to null, so the category screen is shown again
        selectedCategory = null;
      });
      _saveSelectedCategory(
          null); // Optional: Save the state in SharedPreferences
      return false; // Prevent the default back navigation
    }
    return true; // Allow the default back navigation
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: SafeArea(
        child: Scaffold(
          backgroundColor: const Color(0xFF066867),
          appBar: const CustomAppBar(
            title: '',
            showBackButton: false, // Disable the back button
          ),
          body: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  selectedCategory == null
                      ? 'Select the movie category \n         you want to play'
                      : 'Select the Genre',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: selectedCategory == null
                      ? _buildCategorySelection()
                      : _buildGenreSelection(),
                ),
              ),
            ],
          ),
          bottomNavigationBar: const CustomBottomNavigationBar(),
        ),
      ),
    );
  }

  // Build the category selection grid
  Widget _buildCategorySelection() {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, // Two columns
        childAspectRatio: 1.5, // Controls button width/height ratio
        crossAxisSpacing: 16.0, // Space between columns
        mainAxisSpacing: 16.0, // Space between rows
      ),
      itemCount: genreCategories.keys.length,
      itemBuilder: (context, index) {
        String category = genreCategories.keys.elementAt(index);
        return ElevatedButton(
          onPressed: () {
            setState(() {
              selectedCategory = category;
            });
            _saveSelectedCategory(category);
          },
          style: ElevatedButton.styleFrom(
            foregroundColor: const Color(0xFF6BB634),
            backgroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 12.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
              side: const BorderSide(
                width: 8,
                color: Color(0xFF99C2C2),
              ),
            ),
            elevation: 5, // This color shows when clicked
          ),
          child: Text(
            category,
            style: const TextStyle(
                fontSize: 18, color: Colors.black, fontWeight: FontWeight.bold),
          ),
        );
      },
    );
  }

  // Build the genre selection grid
  Widget _buildGenreSelection() {
    List<String> genres = genreCategories[selectedCategory] ?? [];
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, // Two columns
        childAspectRatio: 1.3, // Adjusted to make the circle aspect ratio 1:1
        crossAxisSpacing: 16.0, // Space between columns
        mainAxisSpacing: 16.0, // Space between rows
      ),
      itemCount: genres.length,
      itemBuilder: (context, index) {
        String genre = genres[index];
        return ElevatedButton(
          onPressed: () => _navigateToMoviesScreen(genre),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            foregroundColor: const Color(0xFF6BB634),
            padding: const EdgeInsets.symmetric(vertical: 12.0),
            shape: const CircleBorder(
              side: BorderSide(
                color: Color(0xFF99C2C2), // Define the border color here
                width: 8, // Border width
              ),
            ), // Makes the button circular
          ),
          child: Text(
            genre,
            style: const TextStyle(
                fontSize: 18, color: Colors.black, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
        );
      },
    );
  }
}
