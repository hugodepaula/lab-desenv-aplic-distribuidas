import 'package:flutter/material.dart';


class Movie {
  final String title;
  final String director;
  final String synopsis;

  Movie({
    required this.title,
    required this.director,
    required this.synopsis,
  });
}




class MovieListScreen extends StatelessWidget {
  // Lista de filmes
  final List<Movie> movies = [
    Movie(
      title: 'O Poderoso Chefão',
      director: 'Francis Ford Coppola',
      synopsis: 'Uma saga sobre a máfia italiana...',
    ),
    Movie(
      title: 'Forrest Gump',
      director: 'Robert Zemeckis',
      synopsis: 'A história de um homem que vive várias aventuras...',
    ),
    Movie(
      title: 'Interestelar',
      director: 'Christopher Nolan',
      synopsis: 'Uma jornada épica pelo espaço e tempo...',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lista de Filmes'),
      ),
      body: ListView.builder(
        itemCount: movies.length,
        itemBuilder: (context, index) {
          final movie = movies[index];
          return ListTile(
            title: Text(movie.title),
            subtitle: Text(movie.director),
            onTap: () {
              // Navega para a tela de detalhes, enviando o filme selecionado
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MovieDetailScreen(movie: movie),
                ),
              );
            },
          );
        },
      ),
    );
  }
}


class MovieDetailScreen extends StatelessWidget {
  final Movie movie;

  // Construtor que recebe o filme selecionado
  MovieDetailScreen({required this.movie});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(movie.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Diretor: ${movie.director}',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Text(
              'Sinopse:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              movie.synopsis,
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'App de Filmes',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MovieListScreen(),
    );
  }
}
