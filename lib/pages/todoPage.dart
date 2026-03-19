import 'package:flutter/material.dart';

class TodoPage extends StatelessWidget {
  const TodoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("施工中"),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // 施工图标喵 🚧
            const Icon(
              Icons.construction_rounded,
              size: 100,
              color: Colors.orangeAccent,
            ),
            const SizedBox(height: 24),
            const Text(
              "功能开发中...",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.5,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              "正在努力施工，敬请期待喵~",
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 40),
            // 加个线性进度条增加“施工感”喵
            SizedBox(
              width: 200,
              child: LinearProgressIndicator(
                backgroundColor: Colors.grey[200],
                color: Colors.orangeAccent,
                minHeight: 6,
              ),
            ),
          ],
        ),
      ),
    );
  }
}