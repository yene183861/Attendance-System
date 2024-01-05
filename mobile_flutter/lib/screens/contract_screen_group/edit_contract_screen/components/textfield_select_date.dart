import 'package:firefly/configs/resources/barrel_const.dart';
import 'package:flutter/material.dart';

class SelectDateWidget extends StatelessWidget {
  const SelectDateWidget({
    super.key,
    required this.title,
    this.isRequired = false,
    required this.onTap,
    required this.date,
  });
  final String title;
  final bool isRequired;
  final Function() onTap;
  final String date;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              title,
              style: FONT_CONST.regular(
                  fontSize: 16, color: COLOR_CONST.cloudBurst),
            ),
            if (isRequired)
              Text(
                ' *',
                style: FONT_CONST.regular(
                    fontSize: 16, color: COLOR_CONST.portlandOrange),
              ),
          ],
        ),
        GestureDetector(
          onTap: onTap,
          child: Container(
            height: 50,
            width: 180,
            margin: const EdgeInsets.only(top: 5),
            padding: const EdgeInsets.symmetric(
              horizontal: 12,
            ),
            decoration: BoxDecoration(
                border: Border.all(color: COLOR_CONST.cloudBurst),
                borderRadius: BorderRadius.circular(8)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Text(
                    date,
                    style: FONT_CONST.regular(
                      color: COLOR_CONST.cloudBurst,
                      fontSize: 15,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(height: 5),
                const Icon(
                  Icons.calendar_month,
                  size: 20,
                  color: COLOR_CONST.cloudBurst,
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}
