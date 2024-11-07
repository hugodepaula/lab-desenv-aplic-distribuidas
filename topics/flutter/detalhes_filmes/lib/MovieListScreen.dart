import 'package:detalhes_filmes/MovieDetailScreen.dart';
import 'package:detalhes_filmes/movie.dart';
import 'package:flutter/material.dart';

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
