import 'package:flutter/material.dart';
import '../designs/selfPanel.dart';
import 'todoPage.dart';

class PersonPage extends StatelessWidget {
  const PersonPage({super.key});

  /// 定义个人信息档案卡
  Widget _buildProfileCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(
          context,
        ).colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 32,
            backgroundColor: Colors.blueAccent,
            child: Icon(Icons.person, size: 36, color: Colors.white),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "用户名",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const Text(
                  "选择合适的网盘上传或下载数据",
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                // 使用buildStatusButton 组合按钮
                Wrap(
                  spacing: 8, // 按钮之间的间距
                  runSpacing: 8, // 换行间距
                  children: [
                    buildStatusButton(
                      context,
                      icon: Icons.cloud_queue,
                      label: "Google Drive",
                      color: Colors.blue,
                      onTap: () => print("点击了Google Drive"),
                    ),
                    buildStatusButton(
                      context,
                      icon: Icons.cloud_circle,
                      label: "百度网盘",
                      color: Colors.green,
                      onTap: () => print("点击了百度网盘"),
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

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const SizedBox(height: 60),
            _buildProfileCard(context),
            const SizedBox(height: 24),
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
      ),
    );
  }
}
