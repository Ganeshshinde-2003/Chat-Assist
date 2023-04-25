import 'package:flutter/material.dart';
import 'package:voiceassist/palette.dart';

class FeatureBox extends StatelessWidget {
  final Color color;
  final String headerText;
  final String discip;
  const FeatureBox({Key? key, required this.color, required this.headerText, required this.discip}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 35, vertical: 10),
      decoration: BoxDecoration(
        color: color,
        borderRadius: const BorderRadius.all(Radius.circular(15)),
      ),
      child: Padding(
        padding: const EdgeInsets.only(top: 20, left: 15, bottom: 20,),
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Text(headerText, style: const TextStyle(
                fontFamily: "Cera pro",
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Pallete.blackColor,
              ),),
            ),
            const SizedBox(height: 3,),
            Padding(
              padding: const EdgeInsets.only(right: 20),
              child: Text(discip, style: const TextStyle(
                fontFamily: "Cera pro",
                color: Pallete.blackColor,
              ),),
            )

          ],
        ),
      ),
    );
  }
}
