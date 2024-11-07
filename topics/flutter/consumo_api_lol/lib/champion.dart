
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
