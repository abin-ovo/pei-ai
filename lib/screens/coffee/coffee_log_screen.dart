import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/character_illustration.dart';
import '../../core/widgets/mew_card.dart';
import '../../core/widgets/mew_chip.dart';
import '../../core/widgets/toast_overlay.dart';
import '../../models/coffee_record.dart';
import '../../providers/app_state.dart';

class CoffeeLogScreen extends StatefulWidget {
  const CoffeeLogScreen({super.key});

  @override
  State<CoffeeLogScreen> createState() => _CoffeeLogScreenState();
}

class _CoffeeLogScreenState extends State<CoffeeLogScreen> {
  int _timeIndex = 2;
  int _typeIndex = 0;
  int _sizeIndex = 1;
  final Set<String> _options = {'饭后'};
  final _feelingCtrl = TextEditingController();

  static const _times = ['早上', '中午', '下午', '傍晚'];
  static const _types = ['美式', '拿铁', '生椰拿铁', '焦糖玛奇朵', '其他'];
  static const _sizes = ['小杯', '中杯', '大杯', '超大杯'];
  static const _optionLabels = ['加浓', '低因', '加糖', '空腹', '饭后'];

  @override
  void dispose() {
    _feelingCtrl.dispose();
    super.dispose();
  }

  int _caffeineForSize(String size) {
    switch (size) {
      case '小杯':
        return 60;
      case '大杯':
        return 120;
      case '超大杯':
        return 160;
      default:
        return 80;
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('记咖啡'),
        actions: [
          TextButton(
            onPressed: () {},
            child: const Text(
              '记录说明',
              style: TextStyle(color: AppColors.primary, fontSize: 14),
            ),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _buildSummaryCard(state),
          const SizedBox(height: 24),
          _buildQuestion('1. 什么时候喝的？', MewChipRow(
            options: _times,
            selectedIndex: _timeIndex,
            onSelected: (i) => setState(() => _timeIndex = i),
          )),
          const SizedBox(height: 20),
          _buildQuestion('2. 喝了什么咖啡？', _buildTypeGrid()),
          const SizedBox(height: 20),
          _buildQuestion('3. 杯量是多少？', MewChipRow(
            options: _sizes,
            selectedIndex: _sizeIndex,
            onSelected: (i) => setState(() => _sizeIndex = i),
          )),
          const SizedBox(height: 20),
          _buildQuestion('4. 其他信息 (可选)', _buildOptions()),
          const SizedBox(height: 20),
          _buildFeelingInput(),
          const SizedBox(height: 100),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: ElevatedButton.icon(
            onPressed: () => _submit(context),
            icon: const Icon(Icons.check, size: 20),
            label: const Text('记录完成'),
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryCard(AppState state) {
    return MewCard(
      color: AppColors.primaryPale,
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '今日已记录 ${state.todayCoffeeCount} 杯咖啡',
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '咖啡因总量预估 ${state.todayCaffeineMg}mg',
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          const CharacterIllustration(
            variant: CharacterVariant.coffee,
            height: 72,
          ),
        ],
      ),
    );
  }

  Widget _buildQuestion(String title, Widget child) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        child,
      ],
    );
  }

  Widget _buildTypeGrid() {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: List.generate(_types.length, (i) {
        final selected = _typeIndex == i;
        return GestureDetector(
          onTap: () => setState(() => _typeIndex = i),
          child: Container(
            width: (MediaQuery.of(context).size.width - 56) / 3,
            padding: const EdgeInsets.symmetric(vertical: 14),
            decoration: BoxDecoration(
              color: selected ? AppColors.primary : AppColors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: selected ? AppColors.primary : AppColors.border,
              ),
            ),
            child: Column(
              children: [
                Text(
                  '☕',
                  style: TextStyle(
                    fontSize: 22,
                    color: selected ? Colors.white70 : null,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _types[i],
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
                    color: selected ? AppColors.white : AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _buildOptions() {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: _optionLabels.map((label) {
        final selected = _options.contains(label);
        return MewChip(
          label: label,
          selected: selected,
          onTap: () {
            setState(() {
              if (selected) {
                _options.remove(label);
              } else {
                _options.add(label);
              }
            });
          },
        );
      }).toList(),
    );
  }

  Widget _buildFeelingInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '此刻感受 (可选)',
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _feelingCtrl,
          maxLength: 60,
          maxLines: 3,
          decoration: const InputDecoration(
            hintText: '记录一下此刻的感受...',
          ),
          onChanged: (_) => setState(() {}),
        ),
      ],
    );
  }

  Future<void> _submit(BuildContext context) async {
    final state = context.read<AppState>();
    final size = _sizes[_sizeIndex];
    final record = CoffeeRecord(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      recordedAt: DateTime.now(),
      timeSlot: _times[_timeIndex],
      coffeeType: _types[_typeIndex],
      size: size,
      options: _options.toList(),
      feeling: _feelingCtrl.text.isEmpty ? null : _feelingCtrl.text,
      caffeineMg: _caffeineForSize(size),
    );
    await state.addCoffeeRecord(record);
    if (context.mounted) {
      showMewToast(context, state.lastInstantReply ?? '记录完成！');
      Navigator.pop(context);
    }
  }
}
