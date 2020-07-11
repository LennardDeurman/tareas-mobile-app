import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class TareasIcons {

  static Map<String, IconData> get categoryIcons {
    return {
      'Kantine': FontAwesomeIcons.clock,
      'Algemeen': FontAwesomeIcons.flag,
      'Goals': FontAwesomeIcons.footballBall,
      'Controle': FontAwesomeIcons.userSecret,
      'Arbitrage': FontAwesomeIcons.certificate
    };
  }

}