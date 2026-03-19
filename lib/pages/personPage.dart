import 'package:flutter/material.dart';
import '../designs/selfPanel.dart';
import 'todoPage.dart';

class PersonPage extends StatelessWidget {
  const PersonPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          const SizedBox(height: 40),
          MenuOption(
            icon: Icons.settings,
            title: "设置",
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const TodoPage()),
              );
            },
          ),
          const SizedBox(height: 16),
                    MenuOption(
            icon: Icons.cloud_upload,
            title: "备份至云端",
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const TodoPage()),
              );
            },
          ),
          const SizedBox(height: 16),
          MenuOption(
            icon: Icons.cloud_download,
            title: "从云端同步",
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const TodoPage()),
              );
            },
          ),
        ],
      ),
    );
  }
}


