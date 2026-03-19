import 'package:flutter/material.dart';
import 'pages/homePage.dart';
import 'pages/calibrationPage.dart';
import 'pages/personPage.dart';

enum PageIndex {
  home(0, 'home'),
  calibration(1, 'calibration'),
  person(2, 'person');

  // 定义存储的值
  final int value;
  final String label;

  const PageIndex(this.value, this.label);
}

class ControlPage extends StatefulWidget {
  const ControlPage({super.key, required this.title});

  final String title;

  @override
  State<ControlPage> createState() => _ControlPageState();
}

class _ControlPageState extends State<ControlPage> {
  PageIndex _selectedIndex = PageIndex.home; // 当前选中的菜单索引
  final List<PageIndex> _history = []; // 页面切换历史记录

  /// 切换页面的函数，接受一个 PageIndex 参数和一个可选的 isBack 参数
  /// 如果 isBack 为 true，表示这是一个返回操作，不会记录当前页面到历史记录中；否则会记录当前页面
  /// 如果新页面和当前页面相同，则不执行任何操作
  void _changePage(PageIndex index, {bool isBack = false}) {
    if (_selectedIndex == index) {
      return;
    }
    setState(() {
      if (!isBack) {
        // 不是返回操作，记录当前页面到历史记录
        _history.add(_selectedIndex);
      }
      _selectedIndex = index;
    });
  }

  /// 显示底部弹窗的函数，接受一个 BuildContext 参数
  /// 弹窗中包含一个日期时间选择器、两个下拉选择框和一个文本输入框，以及一个保存按钮
  /// 显示底部弹窗的主函数
  void _showMyBottomSheet(BuildContext context) {
    // 定义临时变量用于存储弹窗内的选择状态
    DateTime selectedDateTime = DateTime.now();
    String? selectedRoute;
    String? selectedType;
    String selectedUnit = 'pmol/L'; // 默认单位
    final TextEditingController doseController = TextEditingController();
    final TextEditingController concentrationController =
        TextEditingController();

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // 1. 头部标题
                    _buildBottomSheetHeader(
                      _selectedIndex == PageIndex.home ? "新增记录" : "新增校准",
                    ),

                    // 2. 表单区域
                    if (_selectedIndex == PageIndex.home)
                      _buildMedicationForm(
                        context,
                        selectedDateTime: selectedDateTime,
                        selectedRoute: selectedRoute,
                        selectedType: selectedType, // 传入当前值
                        doseController: doseController,
                        setModalState: setModalState,
                        // 新增两个回调函数来同步外部变量
                        onRouteChanged: (val) => selectedRoute = val,
                        onTypeChanged: (val) => selectedType = val,
                        onDateChanged: (val) => selectedDateTime = val,
                      )
                    else if (_selectedIndex == PageIndex.calibration)
                      _buildCalibrationForm(
                        context,
                        selectedDateTime,
                        concentrationController,
                        selectedUnit,
                        setModalState,
                      ),

                    const SizedBox(height: 30),

                    // 3. 保存按钮
                    _buildSaveButton(context, () {
                      if (_selectedIndex == PageIndex.home) {
                        print("保存给药数据: ${doseController.text}");
                      } else {
                        print(
                          "保存校准数据: ${concentrationController.text} $selectedUnit",
                        );
                      }
                      Navigator.pop(context);
                    }),

                    const SizedBox(height: 20),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  /// 函数 A: 构建顶部标题和装饰条
  Widget _buildBottomSheetHeader(String title) {
    return Column(
      children: [
        Container(
          width: 40,
          height: 5,
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        const SizedBox(height: 20),
        Text(
          title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildMedicationForm(
    BuildContext context, {
    required DateTime selectedDateTime,
    required String? selectedRoute,
    required String? selectedType,
    required TextEditingController doseController,
    required StateSetter setModalState,
    required Function(DateTime) onDateChanged, // 同步日期
    required Function(String?) onRouteChanged, // 同步途径
    required Function(String?) onTypeChanged, // 同步类型
  }) {
    final Map<String, List<String>> routeToTypes = {
      '口服': ['EV', 'E'],
      '肌肉注射': ['EB', 'EV'],
      '凝胶': ['E'],
    };

    String formattedDateTime =
        "${selectedDateTime.year}-${selectedDateTime.month.toString().padLeft(2, '0')}-${selectedDateTime.day.toString().padLeft(2, '0')} "
        "${selectedDateTime.hour.toString().padLeft(2, '0')}:${selectedDateTime.minute.toString().padLeft(2, '0')}";

    return Column(
      children: [
        ListTile(
          title: const Text("给药时间"),
          subtitle: Text(formattedDateTime),
          leading: const Icon(Icons.calendar_today, color: Colors.blueAccent),
          onTap: () async {
            final DateTime? date = await _pickDateTime(
              context,
              selectedDateTime,
            );
            if (date != null) {
              setModalState(() {
                onDateChanged(date); // 修改外部变量
              });
            }
          },
        ),
        const Divider(),

        // 给药途径
        DropdownButtonFormField<String>(
          decoration: const InputDecoration(
            labelText: '给药途径',
            prefixIcon: Icon(Icons.alt_route),
          ),
          initialValue: selectedRoute,
          items: routeToTypes.keys
              .map((v) => DropdownMenuItem(value: v, child: Text(v)))
              .toList(),
          onChanged: (val) {
            setModalState(() {
              onRouteChanged(val); // 修改外部变量
              // 联动逻辑：如果不匹配，通知外部清空药物类型
              if (val != null && !routeToTypes[val]!.contains(selectedType)) {
                onTypeChanged(null);
              }
            });
          },
        ),
        const SizedBox(height: 15),

        // 药物类型
        DropdownButtonFormField<String>(
          decoration: InputDecoration(
            labelText: '药物类型',
            prefixIcon: const Icon(Icons.medication),
            hintText: selectedRoute == null ? "请先选择给药途径" : "请选择药物类型",
          ),
          initialValue: selectedType, // 这里的 value 会随着 setModalState 重新传入最新值
          items:
              (selectedRoute == null
                      ? <String>[]
                      : routeToTypes[selectedRoute]!)
                  .map((v) => DropdownMenuItem(value: v, child: Text(v)))
                  .toList(),
          onChanged: selectedRoute == null
              ? null
              : (val) {
                  setModalState(() {
                    onTypeChanged(val);
                  });
                },
        ),
        const SizedBox(height: 15),

        // 药物剂量
        TextField(
          controller: doseController,

          keyboardType: const TextInputType.numberWithOptions(decimal: true),

          decoration: const InputDecoration(
            labelText: '药物剂量',

            suffixText: 'mg',

            prefixIcon: Icon(Icons.straighten),

            border: OutlineInputBorder(),
          ),
        ),
      ],
    );
  }

  /// 函数 D: 构建设备校准表单 (校准页专用)
  Widget _buildCalibrationForm(
    BuildContext context,
    DateTime selectedDateTime,
    TextEditingController concentrationController,
    String selectedUnit, // 需在主函数定义变量 String selectedUnit = 'pmol/L';
    StateSetter setModalState,
  ) {
    String formattedDateTime =
        "${selectedDateTime.year}-${selectedDateTime.month.toString().padLeft(2, '0')}-${selectedDateTime.day.toString().padLeft(2, '0')} "
        "${selectedDateTime.hour.toString().padLeft(2, '0')}:${selectedDateTime.minute.toString().padLeft(2, '0')}";

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 1. 检查时间选择
        ListTile(
          contentPadding: EdgeInsets.zero,
          title: const Text(
            "检查时间",
            style: TextStyle(color: Colors.black54, fontSize: 14),
          ),
          subtitle: Text(
            formattedDateTime,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.black87,
              fontWeight: FontWeight.bold,
            ),
          ),
          leading: const Icon(Icons.history, color: Colors.blueAccent),
          trailing: const Icon(Icons.edit, size: 20),
          onTap: () async {
            final DateTime? date = await _pickDateTime(
              context,
              selectedDateTime,
            );
            if (date != null) {
              setModalState(() => selectedDateTime = date);
            }
          },
        ),
        const SizedBox(height: 20),

        // 2. 激素浓度输入框（带单位选择）
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 浓度值输入
            Expanded(
              flex: 2,
              child: TextField(
                controller: concentrationController,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                decoration: const InputDecoration(
                  labelText: '激素浓度',
                  hintText: '0.00',
                  prefixIcon: Icon(Icons.opacity, color: Colors.blueAccent),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            // 单位选择框
            Expanded(
              flex: 1,
              child: DropdownButtonFormField<String>(
                initialValue: selectedUnit,
                decoration: const InputDecoration(
                  labelText: '单位',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                  ),
                ),
                items: ['pmol/L', 'pg/mL']
                    .map(
                      (u) => DropdownMenuItem(
                        value: u,
                        child: Text(u, style: const TextStyle(fontSize: 13)),
                      ),
                    )
                    .toList(),
                onChanged: (val) {
                  if (val != null) setModalState(() => selectedUnit = val);
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  /// 函数 C: 构建底部的保存按钮
  Widget _buildSaveButton(BuildContext context, VoidCallback onPressed) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blueAccent,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
        onPressed: onPressed,
        child: const Text(
          "保存记录",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  /// 抽取出来的日期时间选择器逻辑
  Future<DateTime?> _pickDateTime(
    BuildContext context,
    DateTime initialDate,
  ) async {
    final DateTime? date = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      builder: _pickerThemeBuilder,
    );

    if (date == null) return null;

    final TimeOfDay? time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(initialDate),
      initialEntryMode: TimePickerEntryMode.input,
      builder: (context, child) => MediaQuery(
        data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
        child: _pickerThemeBuilder(context, child!),
      ),
    );

    if (time == null) return null;

    return DateTime(date.year, date.month, date.day, time.hour, time.minute);
  }

  /// 统一的选择器主题构建器：实现白底蓝调风格
  Widget _pickerThemeBuilder(BuildContext context, Widget? child) {
    return Theme(
      data: Theme.of(context).copyWith(
        // 配置核心颜色方案
        colorScheme: const ColorScheme.light(
          primary: Colors.blueAccent, // 选中的圆形背景、指针、确认按钮文字颜色
          onPrimary: Colors.white, // 选中圆形内部的文字/数字颜色
          surface: Colors.white, // 弹窗的背景色
          onSurface: Colors.black87, // 未选中的文字、数字颜色
        ),
        // 配置底部文本按钮样式（取消/确定）
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: Colors.blueAccent, // 按钮文字颜色
            textStyle: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        // 针对 TimePicker 键盘输入模式下的输入框样式优化
        inputDecorationTheme: const InputDecorationTheme(
          labelStyle: TextStyle(color: Colors.blueAccent),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.blueAccent, width: 2),
          ),
        ),
      ),
      child: child!,
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: _history.isEmpty, // 如果历史为空，允许退出 App；否则拦截
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        if (_history.isNotEmpty) {
          final previousIndex = _history.removeLast();
          _changePage(previousIndex, isBack: true);
        }
      },
      child: Scaffold(
        extendBody: true, // 让body延伸到底部，底部导航栏会悬浮在上面
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          surfaceTintColor: Colors.transparent,
          // 智能返回按钮
          leading: _history.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () {
                    // 取出历史记录中的最后一个
                    final previousIndex = _history.removeLast();
                    _changePage(previousIndex, isBack: true);
                  },
                )
              : null, // 如果没有历史记录，则不显示返回键
        ),
        body: switch (_selectedIndex) {
          PageIndex.home => const HomePage(),
          PageIndex.calibration => const CalibrationPage(),
          PageIndex.person => const PersonPage(),
        },
        floatingActionButton:
            (_selectedIndex == PageIndex.home ||
                _selectedIndex == PageIndex.calibration)
            ? FloatingActionButton.extended(
                onPressed: () {
                  _showMyBottomSheet(context);
                },
                icon: const Icon(Icons.add),
                label: Text(
                  ((_selectedIndex == PageIndex.home) ? "新增记录" : "新增校准"),
                ),
              )
            : null,
        bottomNavigationBar: BottomBar(
          currentIndex: _selectedIndex,
          onTap: (index) => _changePage(index), // 传递回调函数给 BottomBar
        ),
      ),
    );
  }
}

class BottomBar extends StatelessWidget {
  final PageIndex currentIndex;
  final ValueChanged<PageIndex> onTap;

  const BottomBar({super.key, required this.currentIndex, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.9),
            borderRadius: BorderRadius.circular(40),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              _buildPillButton(
                index: PageIndex.home,
                icon: Icons.home,
                label: "home",
                activeColor: Colors.blue.shade600,
                inactiveColor: Colors.blue.shade50,
                onTap: () => onTap(PageIndex.home), // 调用父组件传入的回调
              ),
              const SizedBox(width: 12),
              _buildPillButton(
                index: PageIndex.calibration,
                icon: Icons.tune,
                label: "calibration",
                activeColor: Colors.green.shade600,
                inactiveColor: Colors.green.shade50,
                onTap: () => onTap(PageIndex.calibration), // 调用父组件传入的回调
              ),
              const SizedBox(width: 12),
              _buildPillButton(
                index: PageIndex.person,
                icon: Icons.person,
                label: "person",
                activeColor: Colors.orange.shade600,
                inactiveColor: Colors.orange.shade50,
                onTap: () => onTap(PageIndex.person), // 调用父组件传入的回调
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// 构建单个 pill 风格按钮的函数，接受按钮的索引、图标、标签、激活颜色、非激活颜色和点击回调
  Widget _buildPillButton({
    required PageIndex index,
    required IconData icon,
    required String label,
    required Color activeColor,
    required Color inactiveColor,
    required VoidCallback onTap,
  }) {
    // 使用传入的 currentIndex 判断是否选中
    bool isSelected = currentIndex == index;

    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          height: 50,
          decoration: BoxDecoration(
            color: isSelected ? activeColor : inactiveColor,
            borderRadius: BorderRadius.circular(25),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: activeColor.withValues(alpha: 0.4),
                      blurRadius: 12,
                      offset: const Offset(0, 6),
                    ),
                  ]
                : [],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: isSelected ? Colors.white : activeColor),
              const SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                  color: isSelected ? Colors.white : activeColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
