import 'package:flutter/material.dart';
import 'package:firefly/configs/resources/barrel_const.dart';
import 'package:firefly/utils/size_config.dart';

class ShimmerTicketItem extends StatelessWidget {
  const ShimmerTicketItem({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Container(
            height: 65,
            width: 85,
            margin: const EdgeInsets.only(right: 20),
            decoration: BoxDecoration(
                color: COLOR_CONST.gray.withOpacity(0.5),
                borderRadius: BorderRadius.circular(6)),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: double.infinity,
                  color: COLOR_CONST.gray.withOpacity(0.5),
                  child: const Text(''),
                ),
                const SizedBox(height: 5),
                Container(
                  width: 100,
                  color: COLOR_CONST.gray.withOpacity(0.5),
                  child: const Text(''),
                ),
                const SizedBox(height: 5),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 5),
                      decoration: BoxDecoration(
                          color: COLOR_CONST.gray.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(6)),
                      width: 70,
                      height: 20,
                    ),
                    const HorizontalSpacing(of: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 5),
                      decoration: BoxDecoration(
                          color: COLOR_CONST.gray.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(6)),
                      width: 70,
                      height: 20,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
