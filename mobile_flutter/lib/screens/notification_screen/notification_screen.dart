import 'package:flutter/material.dart';
import 'package:firefly/screens/app_router.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.of(context).pushNamed(AppRouter.SCAN_FACE_SCREEN);
                },
                child: Container(
                    color: Colors.grey,
                    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                    child: Text('Đăng ký khuôn mặt')),
              ),
              SizedBox(
                height: 20,
              ),
              GestureDetector(
                onTap: () {},
                child: Container(
                    color: Colors.blueGrey,
                    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                    child: Text('Chấm công')),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
