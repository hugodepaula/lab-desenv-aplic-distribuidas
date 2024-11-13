# Usando o `geolocator` no Flutter

Criar uma aplicação Flutter que exibe a localização atual do usuário (latitude e longitude) usando apenas o pacote `geolocator`

## Passo 1: Criar o Projeto Flutter


## Passo 2: Adicionar a Dependência geolocator

1. No arquivo pubspec.yaml, adicione o pacote geolocator para obter a localização do usuário:

```dart
dependencies:
  flutter:
    sdk: flutter
  geolocator: ^9.0.0
```

2. Execute o comando para instalar as dependências:

```dart
flutter pub get
```


## Passo 3: Configurar Permissões de Localização

### Para Android


1. No arquivo `android/app/src/main/AndroidManifest.xml`, adicione as permissões de acesso à localização:

```xml
<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
<uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION" />
```

### Para iOS
1. No arquivo `ios/Runner/Info.plist`, adicione as seguintes linhas para solicitar permissão de localização ao usuário:

```xml
<key>NSLocationWhenInUseUsageDescription</key>
<string>Precisamos da sua localização para mostrar a posição atual.</string>
```


## Passo 4: Criar a Interface e Implementar a Função de Localização

1. No arquivo `lib/main.dart`, substitua o código pelo seguinte:

```dart
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Localização com Geolocator',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: LocationScreen(),
    );
  }
}

class LocationScreen extends StatefulWidget {
  @override
  _LocationScreenState createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  String _location = 'Localização não encontrada';

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Verifica se o serviço de localização está ativo
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      setState(() {
        _location = 'Serviço de localização desativado.';
      });
      return;
    }

    // Verifica se temos permissão para acessar a localização
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        setState(() {
          _location = 'Permissão de localização negada.';
        });
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      setState(() {
        _location = 'Permissão de localização negada permanentemente.';
      });
      return;
    }

    // Obtém a posição atual e atualiza a interface
    Position position = await Geolocator.getCurrentPosition();
    setState(() {
      _location = 'Latitude: ${position.latitude}, Longitude: ${position.longitude}';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Geolocator - Localização Atual')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            _location,
            style: TextStyle(fontSize: 20),
            textAlign: TextAlign.center,
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _getCurrentLocation,
        child: Icon(Icons.location_searching),
        tooltip: 'Atualizar Localização',
      ),
    );
  }
}
```