import 'dart:math';

import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';

class AdoptPetDialog extends StatefulWidget {
  const AdoptPetDialog({
    super.key,
    required this.petName,
  });

  final String petName;

  @override
  State<AdoptPetDialog> createState() => _AdoptPetDialogState();
}

class _AdoptPetDialogState extends State<AdoptPetDialog> {
  late ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();
    _confettiController =
        ConfettiController(duration: const Duration(seconds: 10));
    _confettiController.play();
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Align(
          alignment: Alignment.topCenter,
          child: ConfettiWidget(
            confettiController: _confettiController,
            blastDirectionality: BlastDirectionality.explosive,
            shouldLoop: true,
            colors: const <Color>[
              Colors.green,
              Colors.blue,
              Colors.pink,
              Colors.orange,
              Colors.purple
            ],
            createParticlePath: drawStar,
          ),
        ),
        AlertDialog(
          title: const Text(
            'Thank You',
            textAlign: TextAlign.center,
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                'You’ve now adopted ${widget.petName}',
                style: const TextStyle(
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Path drawStar(Size size) {
    double degToRad(double deg) => deg * (pi / 180.0);

    const int numberOfPoints = 5;
    final double halfWidth = size.width / 2;
    final double externalRadius = halfWidth;
    final double internalRadius = halfWidth / 2.5;
    final double degreesPerStep = degToRad(360 / numberOfPoints);
    final double halfDegreesPerStep = degreesPerStep / 2;
    final Path path = Path();
    final double fullAngle = degToRad(360);
    path.moveTo(size.width, halfWidth);

    for (double step = 0; step < fullAngle; step += degreesPerStep) {
      path.lineTo(halfWidth + externalRadius * cos(step),
          halfWidth + externalRadius * sin(step));
      path.lineTo(halfWidth + internalRadius * cos(step + halfDegreesPerStep),
          halfWidth + internalRadius * sin(step + halfDegreesPerStep));
    }
    path.close();
    return path;
  }
}
