class Note {
  final int? id;
  final String title;
  final String content;
  final bool synchronized;

  Note({
    this.id,
    required this.title,
    required this.content,
    this.synchronized = false,
  });

  // Criar uma cópia do Note com campos atualizados
  Note copyWith({
    int? id,
    String? title,
    String? content,
    bool? synchronized,
  }) {
    return Note(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      synchronized: synchronized ?? this.synchronized,
    );
  }

  // Converter Note para Map (para salvar no banco)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'synchronized': synchronized ? 1 : 0,
    };
  }

  // Criar Note a partir de Map (ao ler do banco)
  factory Note.fromMap(Map<String, dynamic> map) {
    return Note(
      id: map['id'],
      title: map['title'],
      content: map['content'],
      synchronized: map['synchronized'] == 1,
    );
  }

  // Criar Note a partir de JSON (ao ler da API)
  factory Note.fromJson(Map<String, dynamic> json) {
    return Note(
      id: json['id'],
      title: json['title'],
      content: json['content'],
      synchronized: true, // Por padrão, dados da API são considerados sincronizados
    );
  }

  // Converter Note para JSON (para enviar à API)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'content': content,
    };
  }
}