import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'News API Demo',
      theme: ThemeData(
        primarySwatch: Colors.brown,
        appBarTheme: AppBarTheme(
          elevation: 8,
          shadowColor: Colors.brown[300],
        ),
      ),
      home: const NewsPage(),
    );
  }
}

class NewsPage extends StatefulWidget {
  const NewsPage({super.key});

  @override
  _NewsPageState createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage> {
  Future<List<dynamic>> fetchNews() async {
    final response = await http.get(Uri.parse('https://newsapi.org/v2/everything?q=tesla&from=2024-07-14&sortBy=publishedAt&apiKey=2112e5d7135e49ea81a7ee175f208543'));

    if (response.statusCode == 200) {
      Map<String, dynamic> jsonResponse = json.decode(response.body);
      return jsonResponse['articles'];
    } else {
      throw Exception('Failed to load news');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Icon(Icons.newspaper, color: Colors.white),
            SizedBox(width: 10),
            Text('Tesla News'),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              // Implement search functionality
            },
          ),
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              setState(() {});
            },
          ),
        ],
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Colors.brown.shade200, Colors.brown.shade400],
            ),
          ),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(20),
          ),
        ),
      ),
      body: FutureBuilder<List<dynamic>>(
        future: fetchNews(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                return Card(
                  elevation: 4,
                  margin: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                    side: BorderSide(
                      color: Colors.brown.shade200,
                      width: 1,
                    ),
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.brown.shade50, Colors.brown.shade100],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ListTile(
                          leading: CircleAvatar(
                            backgroundColor: Colors.brown.shade300,
                            child: Icon(Icons.article, color: Colors.white),
                          ),
                          title: Text(
                            snapshot.data![index]['title'],
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Colors.brown.shade800,
                            ),
                          ),
                          subtitle: Text(
                            snapshot.data![index]['description'],
                            style: TextStyle(fontSize: 14, color: Colors.brown.shade600),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              IconButton(
                                icon: Icon(Icons.thumb_up_outlined, color: Colors.brown),
                                onPressed: () {},
                              ),
                              IconButton(
                                icon: Icon(Icons.comment_outlined, color: Colors.brown),
                                onPressed: () {},
                              ),
                              IconButton(
                                icon: Icon(Icons.share_outlined, color: Colors.brown),
                                onPressed: () {},
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          } else if (snapshot.hasError) {
            return Center(child: Text("${snapshot.error}"));
          }

          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}