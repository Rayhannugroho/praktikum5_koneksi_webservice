import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String namaImage = "";

  final dio = Dio();

  Future<String> uploadFile(List<int> file, String fileName) async {
    print("mulai");
    FormData formData = FormData.fromMap({
      "file": MultipartFile.fromBytes(
        file,
        filename: fileName,
        contentType: MediaType("image", "png"),
      ),
    });
    var response = await dio.post("http://127.0.0.1:8000/upload/", data: formData);

    print(response.statusCode);
    if (response.statusCode == 200) {
      setState(() {
        namaImage = fileName;
      });
    }
    return fileName;
  }

  Future<void> _getImageFromGallery() async {
    print("get image");
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);
    final bytes = await pickedImage?.readAsBytes();
    if (pickedImage != null) {
      print("mulai upload");
      await uploadFile(bytes!, pickedImage.name);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Image Picker Example'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              namaImage != ""
                  ? Image.network(
                      'http://127.0.0.1:8000/getimage/$namaImage',
                      height: 200,
                    )
                  : const Text("Image Tidak Tersedia"),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _getImageFromGallery,
                child: const Text('Select Image'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
