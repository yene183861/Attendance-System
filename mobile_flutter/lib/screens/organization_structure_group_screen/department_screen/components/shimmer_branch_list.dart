import 'package:flutter/material.dart';
import 'package:firefly/configs/resources/barrel_const.dart';
import 'package:firefly/utils/size_config.dart';

class ShimmerBranchList extends StatelessWidget {
  const ShimmerBranchList({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const ClampingScrollPhysics(),
      padding: EdgeInsets.zero,
      itemCount: 5,
      itemBuilder: (context, index) => const ShimmerItemBranch(),
      separatorBuilder: (context, index) => Divider(
        color: COLOR_CONST.gray.withOpacity(0.5),
        height: 1,
      ),
    );
  }
}

class ShimmerItemBranch extends StatelessWidget {
  const ShimmerItemBranch({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: getProportionateScreenHeight(10)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 70,
            width: 80,
            margin: const EdgeInsets.only(right: 20),
            decoration: BoxDecoration(
                color: COLOR_CONST.gray.withOpacity(0.5),
                borderRadius: BorderRadius.circular(6)),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
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
