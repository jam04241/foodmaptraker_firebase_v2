import 'package:flutter/material.dart';

class NotificationBox extends StatefulWidget {
  const NotificationBox({super.key});

  @override
  State<NotificationBox> createState() => _NotificationBoxState();
}

class _NotificationBoxState extends State<NotificationBox> {
  @override
  Widget build(BuildContext context) {
    return Card(
      color: Color(0xff213448),
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
      child: ListTile(
        leading: const CircleAvatar(
          radius: 25,
          backgroundImage: AssetImage("images/mommyjupeta.jpg"),
          // 👉 if you want to test without asset, use:
          // child: Icon(Icons.person),
        ),
        title: const Text(
          "Mommy Jupeta",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        subtitle: const Text(
          "Reacted to your review",
          style: TextStyle(color: Colors.white70),
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "11:59",
              style: TextStyle(fontSize: 12, color: Colors.white54),
            ),
            IconButton(
              icon: const Icon(Icons.more_horiz, color: Colors.white),
              onPressed: () {
                // TODO: options here later
              },
            ),
          ],
        ),
      ),
    );
  }
}
