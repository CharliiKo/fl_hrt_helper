import 'package:flutter/material.dart';

/// 首页
/// 该页面展示了当前估算的血药浓度数值、一个简单的血药浓度变化图表，以及按周分组的给药记录列表。通过使用Card组件和自定义Painter，增强了界面的视觉效果和数据的可读性。同时提供了交互式的状态标签按钮和对话框，帮助用户更好地理解自己的数据状态。
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  double _scrollValue = 0.0; // 默认情况下显示最新数据（scrollValue = 0.0）

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 120),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildConcentrationSection(context),
          const SizedBox(height: 24),
          _buildChartSection(),
          const SizedBox(height: 24),
          _buildRecordsSection(),
        ],
      ),
    );
  }

  /// 当前估算血药浓度
  /// 该部分使用了Card组件进行美化，展示了当前估算的血药浓度数值，并且提供了两个状态标签按钮，分别用于说明当前数值处于标准范围内和数据可能不准确的情况。点击按钮会弹出相应的对话框，提供更详细的信息和提示。
  Widget _buildConcentrationSection(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.opacity, color: Colors.blueAccent),
                SizedBox(width: 8),
                Text(
                  '当前估算血药浓度',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Center(
              child: Column(
                children: [
                  RichText(
                    text: const TextSpan(
                      style: TextStyle(color: Colors.black),
                      children: [
                        TextSpan(
                          text: '125.4',
                          style: TextStyle(
                            fontSize: 36,
                            fontWeight: FontWeight.bold,
                            color: Colors.blueAccent,
                          ),
                        ),
                        TextSpan(
                          text: ' pmol/L',
                          style: TextStyle(fontSize: 18, color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                  const Text(
                    '最后更新: 2026-03-19 12:00',
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _buildStatusButton(
                  context,
                  icon: Icons.check_circle_outline,
                  label: '处于标准范围内',
                  color: Colors.green,
                  onTap: () => _showRangeDialog(context),
                ),
                _buildStatusButton(
                  context,
                  icon: Icons.info_outline,
                  label: '数据可能不准确',
                  color: Colors.orange,
                  onTap: () => _showAccuracyTip(context),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// 辅助构建状态标签按钮
  /// 该方法创建了一个带有图标和文本的状态标签按钮，使用InkWell实现点击效果，并且通过传入的颜色参数来区分不同状态的视觉风格。
  Widget _buildStatusButton(BuildContext context,
      {required IconData icon,
      required String label,
      required Color color,
      required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          border: Border.all(color: color.withValues(alpha: 0.2)),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 14, color: color),
            const SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(
                  fontSize: 12, color: color, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }

  /// 标准范围说明对话框
  /// 该对话框提供了当前标准血药浓度范围的说明，并且显示了用户当前估算值的位置，帮助用户理解自己的数据状态。同时在对话框底部添加了一个确认按钮，增强了交互体验。
  void _showRangeDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('标准范围说明'),
        content: const Text(
            '当前标准血药浓度范围建议为：100.0 - 200.0 pmol/L。\n\n您的当前估算值为 125.4 pmol/L，处于正常参考区间内。'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context), child: const Text('确定')),
        ],
      ),
    );
  }

  /// 准确性提示对话框
  /// 该对话框解释了当前估算血药浓度数值的来源和局限性，强调了个体代谢差异可能导致的估算偏差，并且提醒用户该数值仅供参考，不能替代实际的血液检测结果。
  void _showAccuracyTip(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('准确性提示'),
        content: const Text(
            '该数值是根据您的给药记录通过算法估算所得，并非实际血液检测结果。由于个体代谢差异，估算值可能与实际浓度存在偏差，仅供参考。'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context), child: const Text('了解')),
        ]
        )
    );
  }

  /// 血药浓度图表
  /// 该部分使用了CustomPaint来绘制一个简单的折线图，并且通过Slider来控制显示的数据范围，实现了类似于滚动查看历史数据的效果。同时在图表下方添加了时间轴标签，增强了数据的可读性。
  Widget _buildChartSection() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.show_chart, color: Colors.green),
                SizedBox(width: 8),
                Text(
                  '血药浓度图表',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // 使用 CustomPaint 绘制简单的折线图
            Container(
              height: 180,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(8),
              ),
              child: ClipRect(
                child: CustomPaint(
                  painter: _SimpleLineChartPainter(scrollOffset: _scrollValue),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.history, size: 16, color: Colors.grey),
                const SizedBox(width: 8),
                const Text(
                  "拖动查看历史",
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
                Expanded(
                  child: SliderTheme(
                    data: SliderTheme.of(context).copyWith(
                      trackHeight: 10,
                      activeTrackColor: Colors.green.withValues(alpha: 0.2),
                      inactiveTrackColor: Colors.green.withValues(alpha: 0.1),
                      thumbColor: Colors.green,
                      overlayColor: Colors.green.withValues(alpha: 0.1),
                      trackShape: const RoundedRectSliderTrackShape(),
                      thumbShape: const _SquareSliderThumbShape(
                        enabledThumbRadius: 8,
                        elevation: 4,
                      ),
                    ),
                    child: Slider(
                      value: 1.0 - _scrollValue, // 水平翻转方向
                      min: 0.0,
                      max: 1.0,
                      onChanged: (value) {
                        setState(() {
                          _scrollValue = 1.0 - value; // 反转回原始逻辑供 Painter 使用
                        });
                      },
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// 已增加的记录
  /// 该部分模拟了按周分组的给药记录展示，使用Card和ListTile进行美化，并且在每周的标题栏显示该周的时间范围和记录数量。
  Widget _buildRecordsSection() {

    // 模拟按周分组的数据
    final List<Map<String, dynamic>> weeklyGroups = [
      {
        'weekRange': '本周 (03-16 至 03-22)',
        'records': [
          {'id': 5, 'time': '2026-03-19 10:00', 'dose': '2.0 mg'},
          {'id': 4, 'time': '2026-03-17 09:30', 'dose': '2.0 mg'},
        ]
      },
      {
        'weekRange': '上周 (03-09 至 03-15)',
        'records': [
          {'id': 3, 'time': '2026-03-14 10:00', 'dose': '2.0 mg'},
          {'id': 2, 'time': '2026-03-11 10:00', 'dose': '1.5 mg'},
          {'id': 1, 'time': '2026-03-09 10:00', 'dose': '1.5 mg'},
        ]
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.0, vertical: 8.0),
          child: Row(
            children: [
              Icon(Icons.list_alt, color: Colors.orange),
              SizedBox(width: 8),
              Text(
                '已增加的记录',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
        ...weeklyGroups.map((group) => _buildWeeklyCard(group)),
      ],
    );
  }

  /// 构建单周记录卡片
  /// 该方法根据传入的周数据构建一个Card组件，展示该周的时间范围和记录列表。每条记录使用ListTile展示，包含给药次数、时间和剂量信息，并且在标题栏显示该周的记录数量。
  Widget _buildWeeklyCard(Map<String, dynamic> group) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 周标题栏
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.orange.withValues(alpha: 0.1),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  group['weekRange'],
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.orange,
                  ),
                ),
                Text(
                  '共 ${group['records'].length} 条',
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ),
          // 该周 the 记录列表
          ListView.separated(
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: group['records'].length,
            separatorBuilder: (context, index) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final record = group['records'][index];
              return ListTile(
                dense: true,
                leading: const CircleAvatar(
                  radius: 14,
                  backgroundColor: Colors.blueAccent,
                  child: Icon(Icons.medication, color: Colors.white, size: 14),
                ),
                title: Text('第 ${record['id']} 次给药'),
                subtitle: Text(record['time']),
                trailing: Text(
                  record['dose'],
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.blue[800],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

/// 折线图绘制Painter
/// 该Painter根据传入的scrollOffset参数动态调整显示的数据范围，实现类似于滚动查看历史数据的效果。
class _SimpleLineChartPainter extends CustomPainter {
  final double scrollOffset;
  _SimpleLineChartPainter({required this.scrollOffset});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.green
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final fillPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Colors.green.withValues(alpha: 0.3), Colors.green.withValues(alpha: 0.0)],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    // 模拟 20 个数据点
    final List<double> dataPoints = [
      80, 95, 120, 110, 130, 150, 140, 160, 155, 170,
      165, 180, 175, 190, 185, 200, 195, 210, 205, 220
    ];

    // 模拟对应的时间轴
    final List<String> timeLabels = [
      "08:00", "09:00", "10:00", "11:00", "12:00", "13:00",
      "14:00", "15:00", "16:00", "17:00", "18:00", "19:00",
      "20:00", "21:00", "22:00", "23:00", "00:00", "01:00",
      "02:00", "03:00"
    ];

    final double maxVal = 250;
    final double spacing = size.width / 6; // 屏幕内显示约 6 个点
    final double totalWidth = (dataPoints.length - 1) * spacing;
    
    // 计算当前的偏移（scrollOffset 为 0.0 时显示最新，1.0 时显示最早）
    final double currentOffset = (totalWidth - size.width + spacing) * (1.0 - scrollOffset);

    canvas.save();
    canvas.translate(-currentOffset, 0);

    final path = Path();
    final fillPath = Path();

    for (int i = 0; i < dataPoints.length; i++) {
      double x = i * spacing;
      double y = size.height - (dataPoints[i] / maxVal * size.height);

      if (i == 0) {
        path.moveTo(x, y);
        fillPath.moveTo(x, size.height);
        fillPath.lineTo(x, y);
      } else {
        path.lineTo(x, y);
        fillPath.lineTo(x, y);
      }
      
      if (i == dataPoints.length - 1) {
        fillPath.lineTo(x, size.height);
        fillPath.close();
      }
    }

    // 绘制阴影填充
    canvas.drawPath(fillPath, fillPaint);
    // 绘制折线
    canvas.drawPath(path, paint);

    // 绘制数据点
    final pointPaint = Paint()..color = Colors.green..style = PaintingStyle.fill;
    final whitePaint = Paint()..color = Colors.white..style = PaintingStyle.fill;
    for (int i = 0; i < dataPoints.length; i++) {
      double x = i * spacing;
      double y = size.height - (dataPoints[i] / maxVal * size.height);
      canvas.drawCircle(Offset(x, y), 5, pointPaint);
      canvas.drawCircle(Offset(x, y), 3, whitePaint);
    }

    // 遍历绘制时间文字
    for (int i = 0; i < dataPoints.length; i++) {
      double x = i * spacing;
      
      // 使用 TextPainter 来处理文字绘制
      final textPainter = TextPainter(
        text: TextSpan(
          text: timeLabels[i],
          style: TextStyle(color: Colors.grey, fontSize: 10),
        ),
        textDirection: TextDirection.ltr,
      )..layout();

      // 将文字绘制在数据点下方，记得居中对齐处理
      textPainter.paint(
        canvas, 
        Offset(x - textPainter.width / 2, size.height - 15) // 15 是预留的底部高度
      );
    }

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _SimpleLineChartPainter oldDelegate) {
    return oldDelegate.scrollOffset != scrollOffset;
  }
}

/// 自定义Slider滑块形状
/// 该类实现了一个带有阴影效果的圆形滑块，增强了视觉层次感和交互反馈。
class _SquareSliderThumbShape extends SliderComponentShape {
  final double enabledThumbRadius;
  final double elevation;

  const _SquareSliderThumbShape({
    this.enabledThumbRadius = 6,
    this.elevation = 1,
  });

  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) {
    return Size.square(enabledThumbRadius * 2);
  }

  @override
  void paint(
    PaintingContext context,
    Offset center, {
    required Animation<double> activationAnimation,
    required Animation<double> enableAnimation,
    required bool isDiscrete,
    required TextPainter labelPainter,
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    required TextDirection textDirection,
    required double value,
    required double textScaleFactor,
    required Size sizeWithOverflow,
  }) {
    final canvas = context.canvas;
    final size = enabledThumbRadius * 2;

    // 绘制阴影
    final shadowPaint = Paint()
      ..color = Colors.black.withValues(alpha: 0.2)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2);

    canvas.drawOval(
      Rect.fromCenter(
        center: center,
        width: size,
        height: size,
      ),
      shadowPaint,
    );

    // 绘制滑块
    final thumbPaint = Paint()
      ..color = sliderTheme.thumbColor ?? Colors.blue
      ..style = PaintingStyle.fill;

    canvas.drawOval(
      Rect.fromCenter(
        center: center,
        width: size,
        height: size,
      ),
      thumbPaint,
    );
  }
}