# Exemplo Flutter com geolocation 

Incorpora mapas e serviços de geolocalização. 

Usaremos o pacote 'geolocator' para acessar os serviços de localização do dispositivo e exibir a localização atual do usuário no mapa.

### Dependência

geolocator: ^13.0.1: Um pacote para acessar os serviços de localização do dispositivo.

[Flutter Geolocator Plugin](https://pub.dev/packages/geolocator)

Na pasta raiz do projeto:

```
flutter pub add geolocator

flutter pub get
```

### Passos

1. Crie um novo projeto Flutter:

2. Atualize o arquivo pubspec.yaml com as dependências conforme orientações acima acima.

3. Implementação mapas e geolocalização:
    - Importar os pacotes
      ```
      import 'package:flutter/material.dart';
      import 'package:flutter_map/flutter_map.dart';
      import 'package:latlong2/latlong.dart';
      import 'package:geolocator/geolocator.dart';
      ```

Passo 2 : Crie um StatefulWidget para a tela do mapa
Criaremos um StatefulWidget para gerenciar o estado do nosso mapa e localização:



class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  // Map and location-related code will go here
}


Step 3 : Initialize the MapController and user's location
Inside the '_MapScreenState' class, initialize the 'MapController' and the user's current location:



late final MapController _mapController;
LatLng _currentLocation = LatLng(28.6139, 77.2090); // Initial center (New Delhi, India)

@override
void initState() {
  super.initState();
  _mapController = MapController();
  _getCurrentLocation(); // Get the user's current location on widget initialization
}


Step 4 : Get the user's current location
Implement the '_getCurrentLocation' method to get the user's current location using the 'geolocator' package:



Future<void> _getCurrentLocation() async {
  try {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    setState(() {
      _currentLocation = LatLng(position.latitude, position.longitude);
    });
  } catch (e) {
    print('Error getting location: $e');
  }
}


Create the map UI
In the build method of the '_MapScreenState' class, create the UI for the map screen:



@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: Text('OpenStreetMap'),
    ),
    body: FlutterMap(
      mapController: _mapController,
      options: MapOptions(
        center: _currentLocation,
        zoom: 13.0,
      ),
      children: [
        TileLayer(
          urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
          subdomains: ['a', 'b', 'c'],
        ),
        MarkerLayer(
          markers: [
            Marker(
              width: 80.0,
              height: 80.0,
              point: _currentLocation,
              builder: (ctx) => Icon(
                Icons.location_on,
                size: 48.0,
                color: Colors.red,
              ),
            ),
          ],
        ),
      ],
    ),
  );
}


This code creates a Scaffold with an AppBar and a FlutterMap widget. The FlutterMap widget uses the MapController to control the map's state and the MapOptions to set the initial center and zoom level.

The TileLayer renders the OpenStreetMap tiles, and the MarkerLayer adds a marker at the user's current location, represented by an icon.

Run the Application
Connect an Android device or start an Android emulator, and run the app using the following command in your terminal:

flutter run


Complete Code for the Application
We have 2 files that are important in this project main.dart and map_screen.dart file .

1. main.dart file
Here is the complete code for that file :



import 'package:flutter/material.dart';
import 'map_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GeeksforGeeks Demo',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: MapScreen(),
    );
  }
}

2. map_screen.dart file


import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late final MapController _mapController;
  LatLng _center = LatLng(28.6139, 77.2090); // Initial center (New Delhi, India)

  @override
  void initState() {
    super.initState();
    _mapController = MapController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('GeeksforGeeks Maps'),
        backgroundColor: Color(0xFF2F8D46), // GeeksforGeeks primary green color
      ),
      body: FlutterMap(
        mapController: _mapController,
        options: MapOptions(
          initialCenter: _center,
          initialZoom: 13.0,
        ),
        children: [
          TileLayer(
            urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
            subdomains: ['a', 'b', 'c'],
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _getCurrentLocation,
        tooltip: 'Get Location',
        backgroundColor: Color(0xFF2F8D46), // GeeksforGeeks primary green color
        child: Icon(Icons.my_location, color: Colors.white),
      ),
    );
  }

  Future<void> _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Location services are disabled.')),
      );
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Location permissions are denied')),
        );
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              'Location permissions are permanently denied, we cannot request permissions.'),
        ),
      );
      return;
    }

    // When permissions are granted, get the position of the device.
    Position position = await Geolocator.getCurrentPosition();
    setState(() {
      _center = LatLng(position.latitude, position.longitude);
      _mapController.move(_center, 13.0);
    });
  }
}

e quando executamos o arquivo main.dart a saída será o Mapa de Nova Delhi , que é a localização inicial e quando clicamos no botão de geolocalização , ele mudará para a localização atual do usuário (neste caso para Ahmendabad)

Saída:
Visualização inicial do mapa
O aplicativo inicialmente centraliza o mapa em Nova Delhi, Índia

Visualização de localização do usuário
Ao clicar no botão de ação flutuante, o mapa é atualizado para a localização do usuário (simulado como Ahmedabad, Índia).



Conclusão
A integração de mapas e serviços de geolocalização em um aplicativo Flutter pode melhorar significativamente a funcionalidade e a experiência do usuário. Ao usar o pacote flutter_map com o OpenStreetMap, você pode evitar a necessidade de uma chave de API e informações de cobrança, tornando-o uma excelente opção para pequenos projetos ou para aqueles que estão apenas começando.

Nota: Outra alternativa gratuita é  o Mapbox, que oferece um nível gratuito e não requer informações de cartão para aplicativos de pequena escala. Você pode usar o  pacote mapbox_gl para integrar o Mapbox no Flutter.


J

jatssahf69
Notícia

3
Próximo Artigo
Como integrar o Google Maps em aplicativos Flutter?
Leituras semelhantes
Como adicionar polilinhas de rota ao Google Maps no Flutter?
O Google Maps é usado em muitos aplicativos Android. Podemos usar Polylines para representar rotas para vários destinos no Google Maps. Portanto, neste artigo, vamos adicionar polilinhas de rota ao Google Maps no Flutter. Passo a passo de implementaçãoPasso 1: Crie um novo projeto no Android StudioPara configurar o desenvolvimento do Flutter no Android Studio, consulte t
4 min de leitura
Como mover a câmera para qualquer posição no Google Maps no Flutter?
O Google Maps é um dos aplicativos mais usados hoje em dia para navegação. Se procurar por qualquer local, nossa câmera no Google Map se move para essa posição. Neste artigo, veremos como mover a câmera para qualquer posição no Google Maps no Flutter. Implementação passo a passoEtapa 1: criar um novo projeto no Android StudioPara configurar o desenvolvimento do Flutter
4 min de leitura
Como desenhar polígono no Google Maps no Flutter?
O Google Maps é usado em muitos aplicativos Android. Podemos usar polígonos para representar rotas ou áreas no Google Maps. Portanto, neste artigo, veremos como desenhar polígonos no Google Maps no Flutter. Implementação passo a passoEtapa 1: criar um novo projeto no Android StudioPara configurar o desenvolvimento do Flutter no Android Studio, consulte o Android Stu
4 min de leitura
Como obter a localização atual dos usuários no Google Maps no Flutter?
Hoje em dia, o Google Maps é um dos aplicativos populares para navegação ou localização de qualquer local. Com isso, podemos descobrir a localização atual de qualquer pessoa. Portanto, neste artigo, veremos como obter a localização atual dos usuários no Flutter. Implementação passo a passoEtapa 1: criar um novo projeto no Android StudioPara configurar o desenvolvimento do Flutter o
4 min de leitura
Como integrar o Google Maps em aplicativos Flutter?
Todos nós vimos que o Google Maps é usado por muitos aplicativos, como Ola, Uber, Swiggy e outros. Devemos configurar um projeto de API com a Plataforma Google Maps para integrar o Google Maps em nosso aplicativo Flutter. Neste artigo, veremos como integrar o Google Maps em aplicativos Flutter? Implementação passo a passoPasso 1: Cr
4 min de leitura
How to Add Custom Markers on Google Maps in Flutter?
Google Maps is one of the popular apps used nowadays for navigation or locating markers on Google Maps. We have seen markers on Google Maps for various locations. But In this article, we are going to see how to implement multiple custom markers on Google Maps in Flutter. Step By Step ImplementationStep 1: Create a New Project in Android StudioTo se
4 min read
Is Flutter Worth Learning? Top 7 Reasons to Learn Flutter
In today's era, the usage of smartphones has increased exponentially and so has the use of mobile applications and websites. Meanwhile, considering future career prospects, learning web development and mobile app development is strongly recommended for all individuals. And when we come to mobile app development, there are two most-popular open-sour
5 min read
Flutter - Sharing Data Among Flutter Pages
In this article, we are going to find the solution for the problem statement "Import/send data from one page to another in flutter". Before going into the topic, there are some pre-requisites. Pre-requisites:Basics of dart programming language.Setting up Flutter in VS code or Setting up Flutter in Android Studio.Creating first flutter app | Hello W
4 min read
Flutter Quill - Rich Text Editor in Flutter Application
Esta postagem explicará como integrar um editor de rich text ao seu aplicativo Flutter para que ele possa habilitar a edição de rich text. Há muito mais coisas que podemos fazer com Flutter Quill, mas eles podem se envolver um pouco. O exemplo abaixo é uma demonstração bastante básica do que queremos dizer. Vamos primeiro discutir o que é flutter quill e por que precisamos dele
5 min de leitura
Flutter - AlertDialog animado no Flutter
A animação de um AlertDialog no Flutter envolve o uso da estrutura de animações do Flutter para criar animações personalizadas para mostrar e ocultar o diálogo. Neste artigo, vamos adicionar uma animação a um AlertDialog. Um vídeo de amostra é fornecido abaixo para ter uma ideia sobre o que vamos fazer neste artigo. [vídeo mp4="https://media.geeksforgeeks.
4 min de leitura
Tags de artigo:
Tremulação