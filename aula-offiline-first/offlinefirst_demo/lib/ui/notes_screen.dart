import 'package:flutter/material.dart';
import '../model/note.dart';
import '../repository/notes_repository.dart';

class NotesScreen extends StatefulWidget {
  final NotesRepository repository;

  const NotesScreen({super.key, required this.repository});

  @override
  _NotesScreenState createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {
  List<Note> _notes = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadNotes();
  }

  Future<void> _loadNotes() async {
    setState(() {
      _isLoading = true;
    });

    // Usar o Stream para receber atualizações (primeiro local, depois remoto)
    await for (final notes in widget.repository.getNotes()) {
      setState(() {
        _notes = notes;
        _isLoading = false;
      });
    }
  }

  Future<void> _syncNotes() async {
    setState(() {
      _isLoading = true;
    });

    // Forçar sincronização
    await widget.repository.syncNotes();
    
    // Recarregar notas
    await _loadNotes();
  }

  Future<void> _addNote() async {
    final TextEditingController titleController = TextEditingController();
    final TextEditingController contentController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Nova Nota'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(labelText: 'Título'),
              ),
              TextField(
                controller: contentController,
                decoration: const InputDecoration(labelText: 'Conteúdo'),
                maxLines: 3,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () async {
                if (titleController.text.isNotEmpty && contentController.text.isNotEmpty) {
                  final note = Note(
                    title: titleController.text,
                    content: contentController.text,
                  );
                  
                  await widget.repository.addNote(note);
                  Navigator.pop(context);
                  _loadNotes();
                }
              },
              child: const Text('Salvar'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _editNote(Note note) async {
    final TextEditingController titleController = TextEditingController(text: note.title);
    final TextEditingController contentController = TextEditingController(text: note.content);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Editar Nota'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(labelText: 'Título'),
              ),
              TextField(
                controller: contentController,
                decoration: const InputDecoration(labelText: 'Conteúdo'),
                maxLines: 3,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () async {
                if (titleController.text.isNotEmpty && contentController.text.isNotEmpty) {
                  final updatedNote = note.copyWith(
                    title: titleController.text,
                    content: contentController.text,
                  );
                  
                  await widget.repository.updateNote(updatedNote);
                  Navigator.pop(context);
                  _loadNotes();
                }
              },
              child: const Text('Salvar'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notas'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _syncNotes,
            tooltip: 'Sincronizar',
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _notes.isEmpty
              ? const Center(child: Text('Nenhuma nota encontrada'))
              : ListView.builder(
                  itemCount: _notes.length,
                  itemBuilder: (context, index) {
                    final note = _notes[index];
                    return ListTile(
                      title: Text(note.title),
                      subtitle: Text(
                        note.content,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Indicador de sincronização
                          Icon(
                            note.synchronized ? Icons.cloud_done : Icons.cloud_off,
                            color: note.synchronized ? Colors.green : Colors.orange,
                            size: 20,
                          ),
                          IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () => _editNote(note),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () async {
                              await widget.repository.deleteNote(note.id!);
                              _loadNotes();
                            },
                          ),
                        ],
                      ),
                      onTap: () => _editNote(note),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addNote,
        tooltip: 'Adicionar Nota',
        child: const Icon(Icons.add),
      ),
    );
  }
}