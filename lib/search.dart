import 'package:flutter/material.dart';
import 'package:notev2/home.dart';

class SearchResultsPage extends StatelessWidget {
  final String searchTerm;

  SearchResultsPage({
    required this.searchTerm,
  });

  @override
  Widget build(BuildContext context) {
    // Filter the list of titles based on the search term
    List filteredTitles = ak
        .where((title) =>
            title['title'].toLowerCase().contains(searchTerm.toLowerCase()))
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('Search Results'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Display search input on the result page
            Text(
              'Search Results for "$searchTerm"',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),

            // Display filtered titles
            Expanded(
              child: ListView.builder(
                itemCount: filteredTitles.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(filteredTitles[index]['title']),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
