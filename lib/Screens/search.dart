import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '/Screens/widgets/buttomnavig.dart';

class MediaItem {
  String? title;
  String? posterPath;
  String? mediaType;
  MediaItem(this.title, this.posterPath, this.mediaType);
}

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false, home: SearchPage());
  }
}

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final apiKey = '8f78d38fb24129522724f8f66f81c75c';
  List<MediaItem> displayList = [];
  TextEditingController _searchController = TextEditingController();
  bool _isLoading = false;
  var _currentIndex = 2;
  @override
  void initState() {
    super.initState();
    _fetchAllMedia();
  }

  Future<void> _fetchAllMedia() async {
    setState(() {
      _isLoading = true;
    });

    final url = Uri.parse(
        'https://api.themoviedb.org/3/trending/all/day?api_key=$apiKey');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final results = data['results'] as List;

      setState(() {
        displayList = results.map((item) {
          return MediaItem(
            item['title'] ?? item['name'],
            item['poster_path'] != null
                ? 'https://image.tmdb.org/t/p/w500${item['poster_path']}'
                : null,
            item['media_type'],
          );
        }).toList();
        _isLoading = false;
      });
    } else {
      setState(() {
        _isLoading = false;
      });
      throw Exception('Failed to load trending media');
    }
  }

  Future<void> searchMedia(String query) async {
    if (query.isEmpty) {
      _fetchAllMedia();
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final url = Uri.parse(
        'https://api.themoviedb.org/3/search/multi?api_key=$apiKey&query=$query');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final results = data['results'] as List;

      setState(() {
        displayList = results.map((item) {
          return MediaItem(
            item['title'] ?? item['name'],
            item['poster_path'] != null
                ? 'https://image.tmdb.org/t/p/w500${item['poster_path']}'
                : null,
            item['media_type'],
          );
        }).toList();
        _isLoading = false;
      });
    } else {
      setState(() {
        _isLoading = false;
      });
      throw Exception('Failed to load search results');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Colors.black,
      ),
      backgroundColor: Colors.black,
      body: Padding(
        padding: EdgeInsets.all(10),
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              onChanged: (value) {
                searchMedia(value);
              },
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
                suffixIcon: IconButton(
                  icon: Icon(Icons.close),
                  onPressed: () {
                    _searchController.clear();
                    searchMedia('');
                  },
                ),
                suffixIconColor: Colors.white,
                prefixIcon: Icon(Icons.search),
                prefixIconColor: Colors.white,
                fillColor: Color.fromARGB(166, 73, 68, 68),
                filled: true,
                hintText: "Search for movies or TV shows",
                hintStyle: TextStyle(color: Colors.grey, fontSize: 18),
              ),
            ),
            SizedBox(height: 20),
            Text(
              "Search Results",
              style: TextStyle(
                color: Colors.white,
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Expanded(
              child: _isLoading
                  ? Center(child: CircularProgressIndicator())
                  : GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        childAspectRatio: 0.7,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                      ),
                      itemCount: displayList.length,
                      itemBuilder: (context, i) => GestureDetector(
                        onTap: () {
        
                        },
                        child: displayList[i].posterPath != null
                            ? Image.network(
                                displayList[i].posterPath!,
                                fit: BoxFit.cover,
                              )
                            : Container(
                                color: Colors.grey,
                              ),
                      ),
                    ),
            ),
          ],
        ),
      ),
   bottomNavigationBar: CustomBottomNavigationBarX(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
   
      ),    );
  }

}
