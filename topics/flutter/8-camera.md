# Usando a `camera` no Flutter

Criar uma aplicação Flutter que utiliza a câmera do dispositivo para capturar e exibir imagens tiradas pelo usuário.

## Passo 1: Criar o Projeto Flutter


## Passo 2: Adicionar a Dependência da Camera

1. No arquivo pubspec.yaml, adicione o pacote camera para acessar do usuário:

```dart
dependencies:
  flutter:
    sdk: flutter
  camera: ^0.10.0+1
```

2. Execute o comando para instalar as dependências:

```dart
flutter pub get
```


## Passo 3: Configurar Permissões de Camera

### Para Android


1. No arquivo `android/app/src/main/AndroidManifest.xml`, adicione as permissões de acesso à camera:

```xml
<uses-permission android:name="android.permission.CAMERA" />
```

### Para iOS
1. No arquivo `ios/Runner/Info.plist`, adicione as seguintes linhas para solicitar permissão de camera ao usuário:

```xml
<key>NSCameraUsageDescription</key>
<string>Esta aplicação precisa acessar a câmera para capturar fotos.</string>
```


## Passo 4: Criar a Interface e Implementar a Função de Acessar a Câmera e Capturar Imagens

1. No arquivo `lib/main.dart`, substitua o código pelo seguinte:

```dart
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

// Função para iniciar o aplicativo com câmeras disponíveis
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Obtém as câmeras disponíveis no dispositivo
  final cameras = await availableCameras();
  runApp(MyApp(cameras: cameras));
}

class MyApp extends StatelessWidget {
  final List<CameraDescription> cameras;

  MyApp({required this.cameras});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Exemplo de Câmera',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: CameraScreen(cameras: cameras),
    );
  }
}

class CameraScreen extends StatefulWidget {
  final List<CameraDescription> cameras;

  CameraScreen({required this.cameras});

  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  late CameraController _cameraController;
  XFile? _imageFile;

  @override
  void initState() {
    super.initState();
    // Inicializa a câmera
    _cameraController = CameraController(
      widget.cameras.first,
      ResolutionPreset.medium,
    );
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    try {
      await _cameraController.initialize();
      setState(() {});
    } catch (e) {
      print("Erro ao inicializar a câmera: $e");
    }
  }

  @override
  void dispose() {
    _cameraController.dispose();
    super.dispose();
  }

  Future<void> _takePicture() async {
    try {
      if (!_cameraController.value.isInitialized) {
        print("Câmera não está inicializada");
        return;
      }

      // Captura uma foto e a armazena
      final image = await _cameraController.takePicture();
      setState(() {
        _imageFile = image;
      });
    } catch (e) {
      print("Erro ao capturar a imagem: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Exemplo de Câmera')),
      body: Column(
        children: [
          Expanded(
            child: _cameraController.value.isInitialized
                ? CameraPreview(_cameraController)
                : Center(child: CircularProgressIndicator()),
          ),
          if (_imageFile != null)
            Image.file(File(_imageFile!.path), height: 200, fit: BoxFit.cover),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: _takePicture,
              child: Text('Tirar Foto'),
            ),
          ),
        ],
      ),
    );
  }
}
```