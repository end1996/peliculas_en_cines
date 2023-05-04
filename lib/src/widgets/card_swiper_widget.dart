import 'package:flutter/material.dart';

import 'package:card_swiper/card_swiper.dart';
import '../models/pelicula_model.dart';

class CardSwiper extends StatelessWidget {
  
  final List<Pelicula> peliculas;

   const CardSwiper({super.key, required this.peliculas});

  @override
  Widget build(BuildContext context) {

    final dimensiones = MediaQuery.of(context).size;

    return Container(
      padding: const EdgeInsets.only(top: 10.0),
      height: dimensiones.height * 0.5,
      width: dimensiones.width,
      child: Swiper(
        layout: SwiperLayout.STACK,
        itemWidth: dimensiones.width * 0.7,
        itemHeight: dimensiones.height * 0.5,
        itemBuilder: (BuildContext context, int index) {

          peliculas[index].uniqueID = "${peliculas[index].id}-cardSwiper";

          return Hero(
            tag: peliculas[index].uniqueID.toString(),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20.0),
              child: GestureDetector(
                onTap: () => Navigator.pushNamed(context, 'detalle',arguments: peliculas[index]),
                child: FadeInImage(
                  image: NetworkImage(peliculas[index].getPosterImage().toString()),
                  placeholder: const AssetImage('assets/img/no-image.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          );
        },
        itemCount: peliculas.length,
        // pagination: const SwiperPagination(),
        // control: const SwiperControl(),
      ),
    );
  }
}