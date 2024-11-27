import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class Champion {
  final String id;
  final String name;
  final String title;
  final String blurb;

  Champion({
    required this.id,
    required this.name,
    required this.title,
    required this.blurb,
  });

  // Método para converter JSON em um objeto Champion
  factory Champion.fromJson(Map<String, dynamic> json) {
    return Champion(
      id: json['id'] ?? '',
      name: json['name'] ?? 'Nome não disponível',
      title: json['title'] ?? 'Título não disponível',
      blurb: json['blurb'] ?? 'Descrição não disponível',
    );
  }
}




class ApiService {
  final String apiUrl = 'https://ddragon.leagueoflegends.com/cdn/13.7.1/data/en_US/champion.json';

  Future<List<Champion>> fetchChampions() async {
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      Map<String, dynamic> data = json.decode(response.body);
      List<dynamic> championsData = data['data'].values.toList();
      return championsData.map((json) => Champion.fromJson(json)).toList();
    } else {
      throw Exception('Falha ao carregar campeões');
    }
  }
}




class ChampionListScreen extends StatefulWidget {
  @override
  _ChampionListScreenState createState() => _ChampionListScreenState();
}

class _ChampionListScreenState extends State<ChampionListScreen> {
  late Future<List<Champion>> futureChampions;
  final ApiService apiService = ApiService();

  @override
  void initState() {
    super.initState();
    futureChampions = apiService.fetchChampions();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lista de Campeões'),
      ),
      body: FutureBuilder<List<Champion>>(
        future: futureChampions,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erro: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('Nenhum campeão disponível'));
          } else {
            final champions = snapshot.data!;
            return ListView.builder(
              itemCount: champions.length,
              itemBuilder: (context, index) {
                final champion = champions[index];
                return ListTile(
                  title: Text(champion.name),
                  subtitle: Text(champion.title),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ChampionDetailScreen(champion: champion),
                      ),
                    );
                  },
                );
              },
            );
          }
        },
      ),
    );
  }
}


class ChampionDetailScreen extends StatelessWidget {
  final Champion champion;

  ChampionDetailScreen({required this.champion});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(champion.name),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              champion.title,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Text(
              'Descrição:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              champion.blurb,
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
      title: 'App de Campeões de LOL',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ChampionListScreen(),
    );
  }
}
