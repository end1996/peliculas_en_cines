import 'package:flutter/material.dart';
import 'package:peliculas2/src/pages/home_page.dart';
import 'package:peliculas2/src/pages/pelicula_detalle.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Peliculas',
      initialRoute: '/',
      routes: <String,WidgetBuilder> {
        '/'      :(context) => HomePage(),
        'detalle':(context) => const PeliculaDetallePage(),
      }
    );
  }
}