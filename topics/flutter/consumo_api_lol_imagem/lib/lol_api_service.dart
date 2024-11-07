import 'dart:convert';
import 'package:consumo_api_lol_imagem/champion.dart';
import 'package:http/http.dart' as http;


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

