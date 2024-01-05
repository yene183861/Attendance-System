import 'package:flutter/material.dart';
import 'package:firefly/configs/resources/barrel_const.dart';

class ItemStatusLeave extends StatelessWidget {
  const ItemStatusLeave(
      {super.key,
      required this.title,
      required this.isSelected,
      required this.onTap});
  final String title;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          decoration: BoxDecoration(
              gradient: null, borderRadius: BorderRadius.circular(30)),
          child: Text(
            title,
            style: FONT_CONST.bold(
              color:
                  isSelected ? COLOR_CONST.white : COLOR_CONST.charlestonGreen,
              fontSize: 14,
            ),
          ),
        ),
      ),
    );
  }
}
