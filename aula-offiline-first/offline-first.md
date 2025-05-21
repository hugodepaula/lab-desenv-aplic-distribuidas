# 🧪 Roteiro de Aula Prática: Aplicações Offline-First com Flutter e Spring Boot

## 🎯 Objetivo

Desenvolver uma aplicação Flutter com persistência local (offline-first) utilizando o padrão Repository e o banco de dados local Hive, integrada a uma API REST desenvolvida em Spring Boot que lê dados de um arquivo `.json`.

---

## 🧠 Conceitos Envolvidos

* **Arquitetura offline-first**: padrão de design em que os dados são acessados preferencialmente do armazenamento local. A sincronização com o servidor é feita somente quando a conexão estiver disponível.
* **Padrão Repository**: separa a lógica de acesso aos dados da lógica de apresentação, facilitando testes e manutenção.
* **Persistência local com Hive**: Hive é um banco de dados local, rápido e leve, adequado para Flutter. Ele armazena dados diretamente no dispositivo.
* **Verificação de conectividade**: com o pacote `connectivity_plus`, podemos detectar se há acesso à internet no momento.
* **Requisições HTTP**: realizadas com o pacote `http`, para consumir dados da API.
* **Serialização JSON**: processo de converter objetos em mapas JSON e vice-versa.
* **Leitura de JSON com Jackson (Java)**: utilizada no backend para carregar dados de um arquivo `.json`.
* **Sincronização**: Processo que garante que os dados entre o cliente e o servidor estejam atualizados após um período offline.
* **Detecção de Conectividade**: Capacidade de verificar se o dispositivo está conectado à internet.

---

## 💻 Tecnologias Utilizadas

| Tecnologia        | Função                                                                    |
| ----------------- | ------------------------------------------------------------------------- |
| Flutter           | Framework para construir a interface do aplicativo                        |
| Hive              | Banco de dados local leve e rápido (NoSQL) usado para persistência        |
| Connectivity Plus | Plugin Flutter para detectar o estado da conexão com a internet           |
| Spring Boot       | Framework Java para criar APIs REST rapidamente                           |
| Jackson           | Biblioteca Java para serializar e desserializar JSON                      |
| Lombok            | Biblioteca para reduzir boilerplate no Java (getters/setters automáticos) |
| HTTP (Dart)       | Biblioteca para realizar requisições REST no Flutter                      |


---

## 🖥️ Backend: API Spring Boot

# Construção da API REST com Spring Boot

### Criação do Projeto

Use o Spring Initializr:

Nome: todo-api

Dependências:

Spring Web → cria endpoints REST.

DevTools → recarregamento automático durante o desenvolvimento.

Lombok → para reduzir boilerplate (como getters/setters).

## 📂 Arquivo JSON para a API

`todos.json`:

```json
[
  {"id": 1, "title": "Comprar pão", "completed": false},
  {"id": 2, "title": "Estudar Flutter", "completed": true}
]
```

Colocar o arquivo em `src/main/resources/`.

### Modelo de Dados com Lombok

```java
package com.example.demo;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class Todo {
    private Long id;
    private String title;
    private boolean completed;
}


```

`@Data` = cria getters, setters, equals, hashCode, etc.

`@AllArgsConstructor` e `@NoArgsConstructor` = construtores padrão.

### 2. Controlador que lê do JSON

```java
package com.example.demo;

import java.io.IOException;
import java.io.InputStream;
import java.util.Arrays;
import java.util.List;

import org.springframework.core.io.ClassPathResource;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.fasterxml.jackson.databind.ObjectMapper;

@RestController
@RequestMapping("/api/todos")
@CrossOrigin(origins = "*")
public class TodoController {
    private final List<Todo> todos;

    public TodoController() throws IOException {
        ObjectMapper mapper = new ObjectMapper();
        InputStream is = new ClassPathResource("todos.json").getInputStream();
        todos = Arrays.asList(mapper.readValue(is, Todo[].class));
    }

    @GetMapping
    public List<Todo> getAll() {
        return todos;
    }
}

```


`@RestController`: Define um controlador REST.

`@RequestMapping`: Define o caminho base da API.

`ObjectMapper`: Converte JSON em objetos Java.

`ClassPathResource`: Carrega o arquivo do classpath.


---

## 📱 Frontend: Flutter


### Criar projeto

```bash
flutter create offline_first_demo
cd offline_first_demo
```


### Adicionar dependências ao `pubspec.yaml`

```yaml
dependencies:
  flutter:
    sdk: flutter
  http: ^1.4.0            # Requisições HTTP
  hive: ^2.2.3            # Banco local NoSQL
  hive_flutter: ^1.1.0    # Integração com Flutter
  hive_generator: ^2.0.0
  build_runner: ^2.3.3
  path_provider: ^2.0.12  # Acesso a diretórios do sistema
  connectivity_plus: ^5.0.2 # Verificação de conexão
```

### Modelo de dados `Todo`

```dart
import 'package:hive/hive.dart';

part 'Todo.g.dart'; // necessário para gerar o adapter automaticamente

@HiveType(typeId: 0)
class Todo extends HiveObject {
  @HiveField(0)
  final int id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final bool completed;

  Todo({required this.id, required this.title, required this.completed});

  factory Todo.fromJson(Map<String, dynamic> json) => Todo(
    id: json['id'],
    title: json['title'],
    completed: json['completed'],
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'completed': completed,
  };
}
```

> **Explicação**: Essa classe representa o modelo de dado `Todo`. Utilizamos `HiveType` e `HiveField` para permitir o armazenamento local no Hive (necessário para Hive serializar os objetos). `HiveObject` permite salvar e manipular dados no Hive. O método `fromJson` transforma um mapa em objeto, e `toJson` faz o contrário.


Por padrão, o `Hive` só consegue salvar tipos primitivos como:

`int, double, String, bool, List, Map`.

Se você quiser armazenar uma classe personalizada (como um `Todo`, por exemplo), você precisa registrar um `TypeAdapter` para que o Hive saiba como converter o objeto em dados binários e vice-versa.

#### Gere o adaptador com o comando na raiz do projeto:

`flutter packages pub run build_runner build`

Esse comando vai gerar o arquivo `todo.g.dart`, contendo o `TodoAdapter`.

### Repositório `TodoRepository`

```dart
import 'dart:convert';

import 'package:hive/hive.dart';
import 'package:offline_first/Todo.dart';
import 'package:http/http.dart' as http;

class TodoRepository {
  final String apiUrl = 'http://localhost:8080/api/todos';

  Future<List<Todo>> fetchTodosOnline() async {
    final response = await http.get(Uri.parse(apiUrl));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as List;
      final todos = data.map((json) => Todo.fromJson(json)).toList();
      await saveTodosLocally(todos);
      return todos;
    } else {
      throw Exception('Erro ao carregar todos');
    }
  }

  Future<void> saveTodosLocally(List<Todo> todos) async {
    final box = Hive.box<Todo>('todos');
    await box.clear();
    await box.addAll(todos);
  }

  List<Todo> fetchTodosOffline() {
    final box = Hive.box<Todo>('todos');
    return box.values.toList();
  }
}
```

> **Explicação**: Esse repositório separa a lógica de acesso aos dados. Ele verifica se está online e salva os dados localmente após baixar. Se estiver offline, usa os dados já armazenados.


## 💡 O que é `Future`

`Future` é uma representação de um valor que estará disponível no futuro, geralmente resultado de uma operação assíncrona, como uma requisição HTTP ou leitura de arquivo.

```dart
Future<String> saudacao() async {
  await Future.delayed(Duration(seconds: 2));
  return 'Olá, mundo!';
}
```

> **Explicação**: O `await` pausa a execução da função até que o valor esteja pronto, sem travar a aplicação.

---


### Configuração do Hive no `main.dart`

```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(TodoAdapter());
  await Hive.openBox<Todo>('todos');
  runApp( MaterialApp(
   home: HomeScreen(),
  ));
}
```

> **Explicação**: Esse trecho inicializa o Hive, registra o adaptador do modelo e abre uma "caixa" onde os dados serão armazenados.

### Tela principal `HomeScreen`

```dart
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:offline_first/Todo.dart';
import 'package:offline_first/TodoRepository.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final repo = TodoRepository();
  List<Todo> todos = [];

  @override
  void initState() {
    super.initState();
    loadTodos();
  }

  Future<void> loadTodos() async {
    final connectivity = await Connectivity().checkConnectivity();
    if (connectivity == ConnectivityResult.none) {
      todos = repo.fetchTodosOffline();
    } else {
      todos = await repo.fetchTodosOnline();
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Offline-First Todos')),
      body: ListView.builder(
        itemCount: todos.length,
        itemBuilder: (context, index) {
          final todo = todos[index];
          return ListTile(
            title: Text(todo.title),
            trailing: Icon(
              todo.completed ? Icons.check : Icons.close,
              color: todo.completed ? Colors.green : Colors.red,
            ),
          );
        },
      ),
    );
  }
}
```

> **Explicação**: No método `loadTodos`, a função checa se o dispositivo tem conexão. Se não tiver, os dados vêm do Hive. Caso tenha, os dados vêm da API e são salvos localmente. O `setState` atualiza a interface.

---


## ⚙️ Como a Aplicação Funciona Offline

### 🔁 Fluxo completo:

1. O app inicia e executa `loadTodos()`.
2. O pacote `connectivity_plus` verifica se há conexão com a internet.
3. Se **houver conexão**, o app faz uma requisição HTTP para a API Spring Boot:

   * Os dados recebidos da API são convertidos em objetos `Todo`.
   * Esses dados são salvos localmente usando Hive.
4. Se **não houver conexão**, o app busca os dados que já estavam salvos no Hive.
5. Os dados (de qualquer origem) são exibidos na interface.

### 🧪 Testando:

* Execute o app com o backend ligado e conexão ativa ➝ os dados vêm da API.
* Desligue a internet ou o backend ➝ os dados vêm do armazenamento local Hive.

---

## 📚 Conclusão

Esse roteiro mostra como construir uma aplicação Flutter que continue funcional mesmo sem conexão com a internet. O uso da arquitetura offline-first é essencial para experiências robustas em ambientes com conectividade instável. Ao integrar Hive, Repository e conectividade, os alunos entendem como separar as responsabilidades e garantir resiliência no frontend móvel.

Deseja adicionar exercícios ou uma atividade avaliativa ao final da aula?
