import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/actores_model.dart';
import '../models/pelicula_model.dart';

class PeliculasProvider {
  final String _url = "api.themoviedb.org";
  final String _apikey = 'd84ef9790befdc914eab675e2517d2ba';
  final String _language = "es-ES";
  int _popularesPage = 0;
  final List<Pelicula> _populares = [];
  bool _cargando = false;
  //El broadcast añade listener en todo el app para usar la propiedad
  final _popularesStreamController =
      StreamController<List<Pelicula>>.broadcast();

  //Este getter se encarga de añadir peliculas al Stream
  Function(List<Pelicula>) get popularesSink =>
      _popularesStreamController.sink.add;
  //Este getter se encarga de escuchar las peliculas
  Stream<List<Pelicula>> get popularesStream =>
      _popularesStreamController.stream;

  //En este caso el "?" no se puede usar porque no puede retornar nulo
  //Este método se llama para cerrar el stream, aun sin tener la sugerencia
  void disposeStreams() {
    _popularesStreamController.close();
  }

//Este método se utiliza para optimizar código repetitivo
  Future<List<Pelicula>> _procesarRespuesta(Uri url) async {
    final resp = await http.get(url);
    final decodedData = json.decode(resp.body);

    final peliculas = Peliculas.fromJsonList(decodedData['results']);
    // print(peliculas.items[12].title);
    // return [];
    return peliculas.items;
  }

  Future<List<Pelicula>> getEnCines() async {
    final url = Uri.http(_url, '3/movie/now_playing',
        {'api_key': _apikey, 'language': _language});

    return await _procesarRespuesta(url);
  }

  Future<List<Pelicula>> getPopulares() async {
    if (_cargando) return [];
    _cargando = true;
    _popularesPage++;
    //Con protocolo http carga mas rapido las imagenes
    final url = Uri.http(_url, '3/movie/popular', {
      'api_key': _apikey,
      'language': _language,
      'page': _popularesPage.toString(),
    });

    final resp = await _procesarRespuesta(url);
    _populares.addAll(resp);
    popularesSink(_populares);
    _cargando = false;
    return resp;
  }

  Future<List<Actor>> getCast(String peliId) async {
    final url = Uri.http(_url, '3/movie/$peliId/credits',
        {'api_key': _apikey, 'language': _language});

    final resp = await http.get(url);
    //se añadió to String en resp.body
    final decodedData = json.decode(resp.body);

    final cast = Cast.fromJsonList(decodedData['cast']);

    return cast.actores;
  }

  Future<List<Pelicula>> searchMovie(String query) async {
    final url = Uri.http(_url, '3/search/movie', {
      'api_key': _apikey,
      'language': _language,
      'query': query,
    });

    return await _procesarRespuesta(url);
  }
}
