import 'package:flutter/material.dart';

List<Widget> getTypeChip(List<String> types, {bool showTypeText = false}) {
  var chips = <Widget>[];
  if (types.isEmpty) return [];
  for (var i = 0; i < types.length && i < 2; i++) {
    chips.add(Column(
      children: [
        Tooltip(
          message: types[i],
          child: Chip(
            label: getPokemonTypeIcon(
              types[i],
              getPokemonTypeIconColor(types[i]),
            ),
            backgroundColor: getGridTileColor(types[i]),
          ),
        ),
        showTypeText
            ? Text(
                types[i],
                style: TextStyle(
                  color: getPokemonBackgroundColor(types[i]).withAlpha(180),
                  fontWeight: FontWeight.w700,
                ),
              )
            : Container(),
      ],
    ));
  }
  return chips;
}

Color getGridTileColor(String type) {
  if (type == "Grass") return Colors.greenAccent;
  if (type == "Fire") return Colors.redAccent;
  if (type == "Water") return Colors.blue;
  if (type == "Poison") return Colors.deepPurpleAccent;
  if (type == "Electric") return Colors.amber;
  if (type == "Rock") return Colors.grey;
  if (type == "Ground") return Colors.brown;
  if (type == "Psychic") return Colors.indigo;
  if (type == "Fighting") return Colors.orange;
  if (type == "Bug") return Colors.lightGreenAccent;
  if (type == "Ghost") return Colors.deepPurple;
  if (type == "Normal") return Colors.black26;
  if (type == "Flying") return Colors.blue.shade500;
  return Colors.pink;
}

Color getPokemonBackgroundColor(String type) {
  if (type == "Grass") return Colors.greenAccent.shade700;
  if (type == "Fire") return Colors.redAccent.shade700;
  if (type == "Water") return Colors.blue.shade700;
  if (type == "Poison") return Colors.deepPurpleAccent.shade700;
  if (type == "Electric") return Colors.amber.shade800;
  if (type == "Rock") return Colors.grey.shade700;
  if (type == "Ground") return Colors.brown.shade800;
  if (type == "Psychic") return Colors.indigo.shade700;
  if (type == "Fighting") return Colors.orange.shade700;
  if (type == "Bug") return Colors.lightGreenAccent.shade700;
  if (type == "Ghost") return Colors.deepPurple.shade700;
  if (type == "Normal") return Colors.black54;
  if (type == "Flying") return Colors.blue.shade700;
  return Colors.pink;
}

Color getPokemonTypeIconColor(String type) {
  if (type == "Grass") return Colors.green.shade800;
  if (type == "Fire") return Colors.orange.shade300;
  if (type == "Water") return Colors.blue.shade800;
  if (type == "Poison") return Colors.purpleAccent.shade100;
  if (type == "Electric") return Colors.yellowAccent;
  if (type == "Rock") return Colors.grey.shade800;
  if (type == "Ground") return Colors.brown.shade200;
  if (type == "Psychic") return Colors.indigo.shade800;
  if (type == "Fighting") return Colors.orange.shade800;
  if (type == "Bug") return Colors.lightGreen.shade800;
  if (type == "Ghost") return Colors.deepPurple.shade800;
  if (type == "Normal") return Colors.black87;
  if (type == "Flying") return Colors.blue.shade100;
  return Colors.pink.shade200;
}

Icon getPokemonTypeIcon(String type, Color color) {
  if (type == "Grass") return Icon(Icons.grass, color: color);
  if (type == "Fire") return Icon(Icons.fireplace_rounded, color: color);
  if (type == "Water") return Icon(Icons.water_drop_rounded, color: color);
  if (type == "Poison") return Icon(Icons.bubble_chart_sharp, color: color);
  if (type == "Electric") return Icon(Icons.thunderstorm_rounded, color: color);
  if (type == "Rock") return Icon(Icons.cloud, color: color);
  if (type == "Ground") return Icon(Icons.landscape_rounded, color: color);
  if (type == "Psychic") return Icon(Icons.psychology, color: color);
  if (type == "Fighting") return Icon(Icons.waving_hand_rounded, color: color);
  if (type == "Bug") return Icon(Icons.bug_report_rounded, color: color);
  if (type == "Ghost") return Icon(Icons.people_outline, color: color);
  if (type == "Normal") return Icon(Icons.back_hand, color: color);
  if (type == "Flying") return Icon(Icons.flight, color: color);
  return Icon(Icons.star, color: color);
}
