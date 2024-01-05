import 'package:flutter/material.dart';
import 'package:firefly/configs/resources/image_const.dart';

import '../../../configs/resources/barrel_const.dart';

class HeaderAuthScreen extends StatelessWidget {
  const HeaderAuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        Image.asset(
          IMAGE_CONST.imgAttendanceTimesheet.path,
          fit: BoxFit.cover,
          height: 280,
          width: double.infinity,
        ),
        Container(
          height: 280,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              colors: [
                COLOR_CONST.backgroundColor,
                Colors.transparent,
              ],
            ),
          ),
        ),
        // Positioned(
        //   bottom: 20,
        //   child: Image.asset(
        //     IMAGE_CONST.logoAppWithName.path,
        //     height: 90,
        //   ),
        // ),
      ],
    );
  }
}
