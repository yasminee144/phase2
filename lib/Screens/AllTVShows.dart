import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: AllTvItems(),
    );
  }
}

class AllTvItems extends StatefulWidget {
  const AllTvItems({super.key});

  @override
  State<AllTvItems> createState() => _AllTvItemsState();
}

class _AllTvItemsState extends State<AllTvItems> {
  List<TvItem> tvShows = [];
  bool isLoading = false;
  int currentPage = 1;
  final scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    loadTvShows();
    scrollController.addListener(_scrollListener);
  }

  void _scrollListener() {
    if (scrollController.position.pixels ==
        scrollController.position.maxScrollExtent) {
      loadTvShows();
    }
  }

  Future<void> loadTvShows() async {
    if (isLoading) return;
    setState(() => isLoading = true);

    try {
      final newTvShows = await fetchTvShows(currentPage);
      setState(() {
        tvShows.addAll(newTvShows);
        currentPage++;
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
      print('Error loading TV shows: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(
          'Popular TV Shows',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: tvShows.isEmpty && isLoading
          ? Center(child: CircularProgressIndicator())
          : GridView.builder(
              controller: scrollController,
              padding: EdgeInsets.all(8),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 2 / 3,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
              itemCount: tvShows.length + (isLoading ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == tvShows.length) {
                  return Center(child: CircularProgressIndicator());
                }
                final tvShow = tvShows[index];
                return GestureDetector(
                  onTap: () => _showTvDetails(context, tvShow),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      'https://image.tmdb.org/t/p/w500${tvShow.posterPath}',
                      fit: BoxFit.cover,
                    ),
                  ),
                );
              },
            ),
    );
  }

  void _showTvDetails(BuildContext context, TvItem tvShow) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.34,
          decoration: BoxDecoration(
            color: Color.fromARGB(255, 20, 20, 20),
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        'https://image.tmdb.org/t/p/w500${tvShow.posterPath}',
                        width: 95,
                        height: 140,
                        fit: BoxFit.cover,
                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            tvShow.name,
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                          SizedBox(height: 2),
                          Text(
                            tvShow.firstAirDate ?? 'N/A',
                            style: TextStyle(color: Colors.white),
                          ),
                          Text(
                            tvShow.overview ?? 'No overview available.',
                            maxLines: 4,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(fontSize: 14, color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.close, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Row(
                  children: [
                    Expanded(
                        child: ElevatedButton.icon(
                      icon: Icon(Icons.play_arrow),
                      label: Text(
                        'Play',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                    )),
                    SizedBox(width: 30),
                    Column(
                      children: [
                        IconButton(
                          icon: Icon(
                            Icons.download,
                            color: Colors.white,
                          ),
                          onPressed: () {},
                        ),
                        Transform.translate(
                          offset: Offset(0, -4.0),
                          child: Text(
                            "Download",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w300),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(width: 30),
                    Column(
                      children: [
                        IconButton(
                          icon: Icon(Icons.slow_motion_video,
                              color: Colors.white),
                          onPressed: () {},
                        ),
                        Transform.translate(
                          offset: Offset(0, -4.0),
                          child: Text(
                            "Preview",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w300),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(width: 30),
                  ],
                ),
              ),
              Divider(
                thickness: 0.5,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TvDetailsPage(tvShow: tvShow),
                      ),
                    );
                  },
                  child: Row(
                    children: [
                      Icon(Icons.info_outline, color: Colors.white),
                      SizedBox(width: 10),
                      Text(
                        'Details & More',
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class TvDetailsPage extends StatefulWidget {
  final TvItem tvShow;

  const TvDetailsPage({Key? key, required this.tvShow}) : super(key: key);

  @override
  _TvDetailsPageState createState() => _TvDetailsPageState();
}

class _TvDetailsPageState extends State<TvDetailsPage> {
  late Future<List<Season>> seasonsFuture;

  @override
  void initState() {
    super.initState();
    seasonsFuture = fetchSeasons(widget.tvShow.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 200.0,
            floating: false,
            pinned: true,
            backgroundColor: Colors.black,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(''),
              background: Image.network(
                'https://image.tmdb.org/t/p/w500${widget.tvShow.posterPath}',
                fit: BoxFit.cover,
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    widget.tvShow.name,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                          '${widget.tvShow.firstAirDate?.split('-')[0] ?? 'N/A'} | HD | ★ ${widget.tvShow.voteAverage}',
                          style: TextStyle(color: Colors.grey)),
                      SizedBox(height: 16),
                      ElevatedButton(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              size: 30,
                              Icons.play_arrow,
                              color: Colors.black,
                            ),
                            SizedBox(width: 10),
                            Text(
                              'Play',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                          ],
                        ),
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.black,
                          minimumSize: Size(double.infinity, 50),
                        ),
                      ),
                      SizedBox(height: 8),
                      ElevatedButton(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.download,
                              color: Colors.white,
                            ),
                            SizedBox(width: 10),
                            Text(
                              'Download',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey[800],
                          foregroundColor: Colors.white,
                          minimumSize: Size(double.infinity, 50),
                        ),
                      ),
                      SizedBox(height: 16),
                      Text(widget.tvShow.overview ?? 'No overview available.',
                          style: TextStyle(color: Colors.white)),
                      SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          _buildIconButton(Icons.add, 'My List'),
                          SizedBox(width: 10),
                          _buildIconButton(Icons.thumb_up_off_alt, 'Rate'),
                          SizedBox(width: 10),
                          _buildIconButton(Icons.share, 'Share'),
                        ],
                      ),
                    ],
                  ),
                ),
                Divider(color: Colors.grey),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text('SEASONS',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold)),
                ),
                FutureBuilder<List<Season>>(
                  future: seasonsFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return Center(child: Text('No seasons available.'));
                    } else {
                      final seasons = snapshot.data!;
                      return Column(
                        children: seasons.map((season) {
                          return ListTile(
                            title: Text(
                              season.name,
                              style: TextStyle(color: Colors.white),
                            ),
                            onTap: () => _showSeasonSelector(context, season),
                          );
                        }).toList(),
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showSeasonSelector(BuildContext context, Season season) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.black45,
      builder: (BuildContext context) {
        return FutureBuilder<List<Episode>>(
          future: fetchEpisodes(widget.tvShow.id, season.seasonNumber),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(child: Text('No episodes available.'));
            } else {
              final episodes = snapshot.data!;
              return ListView.builder(
                itemCount: episodes.length,
                itemBuilder: (context, index) {
                  final episode = episodes[index];
                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius:
                              BorderRadius.vertical(top: Radius.circular(4)),
                          child: Image.network(
                            'https://image.tmdb.org/t/p/w500${episode.stillPath}',
                            fit: BoxFit.cover,
                            height: 180,
                            width: double.infinity,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            episode.name,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text(
                            episode.overview ?? 'No description available.',
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        SizedBox(height: 8),
                      ],
                    ),
                  );
                },
              );
            }
          },
        );
      },
    );
  }

  Widget _buildIconButton(IconData icon, String label) {
    return Column(
      children: [
        Icon(icon, color: Colors.white),
        SizedBox(height: 4),
        Text(label, style: TextStyle(color: Colors.white)),
      ],
    );
  }
}

class TvItem {
  final int id;
  final String name;
  final String? firstAirDate;
  final String? overview;
  final String posterPath;
  final double voteAverage;

  TvItem({
    required this.id,
    required this.name,
    this.firstAirDate,
    this.overview,
    required this.posterPath,
    required this.voteAverage,
  });

  factory TvItem.fromJson(Map<String, dynamic> json) {
    return TvItem(
      id: json['id'],
      name: json['name'] ?? 'No name',
      firstAirDate: json['first_air_date'],
      overview: json['overview'],
      posterPath: json['poster_path'] ?? '',
      voteAverage: (json['vote_average'] as num).toDouble(),
    );
  }
}

class Season {
  final int seasonNumber;
  final String name;

  Season({
    required this.seasonNumber,
    required this.name,
  });

  factory Season.fromJson(Map<String, dynamic> json) {
    return Season(
      seasonNumber: json['season_number'],
      name: json['name'],
    );
  }
}

class Episode {
  final int episodeNumber;
  final String name;
  final String? airDate;
  final String? overview;
  final String stillPath;

  Episode({
    required this.episodeNumber,
    required this.name,
    this.airDate,
    this.overview,
    required this.stillPath,
  });

  factory Episode.fromJson(Map<String, dynamic> json) {
    return Episode(
      episodeNumber: json['episode_number'],
      name: json['name'],
      airDate: json['air_date'],
      overview: json['overview'],
      stillPath: json['still_path'] ?? '',
    );
  }
}

Future<List<TvItem>> fetchTvShows(int page) async {
  final apiKey = '8f78d38fb24129522724f8f66f81c75c';
  final url =
      'https://api.themoviedb.org/3/tv/popular?api_key=$apiKey&page=$page';
  final response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    final jsonResponse = json.decode(response.body);
    final results = jsonResponse['results'] as List<dynamic>;
    return results.map((item) => TvItem.fromJson(item)).toList();
  } else {
    throw Exception('Failed to load TV shows');
  }
}

Future<List<Season>> fetchSeasons(int tvShowId) async {
  final apiKey = '8f78d38fb24129522724f8f66f81c75c';
  final url = 'https://api.themoviedb.org/3/tv/$tvShowId?api_key=$apiKey';
  final response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    final jsonResponse = json.decode(response.body);
    final seasons = jsonResponse['seasons'] as List<dynamic>;
    return seasons.map((item) => Season.fromJson(item)).toList();
  } else {
    throw Exception('Failed to load seasons');
  }
}

Future<List<Episode>> fetchEpisodes(int tvShowId, int seasonNumber) async {
  final apiKey = '8f78d38fb24129522724f8f66f81c75c';
  final url =
      'https://api.themoviedb.org/3/tv/$tvShowId/season/$seasonNumber?api_key=$apiKey';
  final response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    final jsonResponse = json.decode(response.body);
    final episodes = jsonResponse['episodes'] as List<dynamic>;
    return episodes.map((item) => Episode.fromJson(item)).toList();
  } else {
    throw Exception('Failed to load episodes');
  }
}
