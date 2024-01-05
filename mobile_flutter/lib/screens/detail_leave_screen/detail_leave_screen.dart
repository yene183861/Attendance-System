import 'package:flutter/material.dart';

import '../../custom_widget/appbar_default_custom.dart';

class DetailLeaveScreen extends StatelessWidget {
  const DetailLeaveScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppbarDefaultCustom(title: 'Detail Leave', isCallBack: true),
          Expanded(
            child: Container(
              width: double.infinity,
              margin: EdgeInsets.only(top: 10),
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text('Thông tin phép năm '),
                      Text('2023'),
                    ],
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
