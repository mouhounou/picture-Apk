import 'dart:io';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';

void main() {
  runApp(const MyApp());
}




class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: '',
      theme: ThemeData(

        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Mes photos'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}





class _MyHomePageState extends State<MyHomePage> {
  
  List<File> _images =[];
  late Size size = MediaQuery.of(context).size;
  int _index = 0;

  Future<void> _pickImages ({required ImageSource source}) async{
    ImagePicker picker = ImagePicker();
    XFile? xFile = await picker.pickImage(source: source);
    if (xFile != null){
      setState(() {
        String path = xFile.path;
        File? file = File(path);
        if (file != null){
          _images.add(file);
        }
      });
    }
  }

  void _removePicture (File file){
    setState(() {
      _images.remove(file);
    });
  }

  void _updateIndex(File file){
    setState(() {
      _index = _images.indexOf(file);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue.withOpacity(.7),
          title: Text(widget.title),
          centerTitle: true,
          actions: [
            IconButton(
                onPressed: (()=> _pickImages(source: ImageSource.gallery)),
                icon: Icon(FontAwesomeIcons.photoFilm)
            ),
            IconButton(
                onPressed: (() => _pickImages(source: ImageSource.camera)),
                icon:Icon(FontAwesomeIcons.camera)
            ),
          ],
        ),

        body:  SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 128,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: _images.map((img){
                      return InkWell(
                        onTap: (() => _updateIndex(img)),
                        onLongPress: (() => _removePicture(img)),
                        child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                          child:CircleAvatar(
                            radius: 54,
                            backgroundImage:  FileImage(img),
                          ),
                        )
                      );
                    }) .toList(),
                  ),
                ),
              ),

              const Divider(),
              Card(
                clipBehavior: Clip.antiAlias,
                margin: const EdgeInsets.all(16),
                child: Container(
                  height: size.width * 0.7,
                  width: size.width * 0.7,
                  child: (_images.isNotEmpty && _images.length - 1> _index)? Image.file(_images[_index], fit: BoxFit.cover,) : SizedBox(height: size.width * 0.7,) ,
                ),
              )
            ],
          ),
        )
    );
  }
}
