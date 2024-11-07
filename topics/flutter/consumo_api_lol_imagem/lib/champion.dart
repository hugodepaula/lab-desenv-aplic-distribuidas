
class Champion {
  final String id;
  final String name;
  final String title;
  final String blurb;
  final String imageUrl;

  Champion({
    required this.id,
    required this.name,
    required this.title,
    required this.blurb,
    required this.imageUrl,
  });
  
// Método para criar um objeto Champion a partir de um JSON
  factory Champion.fromJson(Map<String, dynamic> json) {
    return Champion(
      id: json['id'] ?? '',
      name: json['name'] ?? 'Nome não disponível',
      title: json['title'] ?? 'Título não disponível',
      blurb: json['blurb'] ?? 'Descrição não disponível',
      imageUrl:
          'https://ddragon.leagueoflegends.com/cdn/13.7.1/img/champion/${json['id']}.png',
    );
  }
}
