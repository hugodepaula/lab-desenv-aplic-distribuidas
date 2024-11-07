import 'package:consumo_api_lol/champion.dart';
import 'package:consumo_api_lol/lol_api_service.dart';
import 'package:flutter/material.dart';



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
