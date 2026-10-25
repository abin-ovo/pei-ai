import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/character_illustration.dart';
import '../../core/widgets/emoji_rating.dart';
import '../../core/widgets/mew_card.dart';
import '../../core/widgets/mew_chip.dart';
import '../../core/widgets/toast_overlay.dart';
import '../../models/sleep_record.dart';
import '../../providers/app_state.dart';

class SleepLogScreen extends StatefulWidget {
  const SleepLogScreen({super.key});

  @override
  State<SleepLogScreen> createState() => _SleepLogScreenState();
}

class _SleepLogScreenState extends State<SleepLogScreen> {
  String _bedtime = '22:30';
  int _latencyIndex = 1;
  int _qualityIndex = 3;
  int _wakeIndex = 1;
  int _feelingIndex = 3;
  final _notesCtrl = TextEditingController();

  static const _latencies = ['<15分钟', '15-30分钟', '30-60分钟', '>60分钟'];
  static const _wakeCounts = ['0次', '1次', '2-3次', '3次以上'];

  @override
  void dispose() {
    _notesCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('记睡眠'),
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
          _buildHeroBanner(),
          const SizedBox(height: 24),
          _buildQuestion('1. 你几点上床的？', _buildTimePicker()),
          const SizedBox(height: 20),
          _buildQuestion('2. 你大概花了多久入睡？', MewChipRow(
            options: _latencies,
            selectedIndex: _latencyIndex,
            onSelected: (i) => setState(() => _latencyIndex = i),
          )),
          const SizedBox(height: 20),
          _buildQuestion('3. 昨晚睡眠质量如何？', EmojiRating(
            selectedIndex: _qualityIndex,
            onChanged: (i) => setState(() => _qualityIndex = i),
          )),
          const SizedBox(height: 20),
          _buildQuestion('4. 夜间醒来次数', MewChipRow(
            options: _wakeCounts,
            selectedIndex: _wakeIndex,
            onSelected: (i) => setState(() => _wakeIndex = i),
          )),
          const SizedBox(height: 20),
          _buildQuestion('5. 今天起床感觉？', EmojiRating(
            selectedIndex: _feelingIndex,
            onChanged: (i) => setState(() => _feelingIndex = i),
          )),
          const SizedBox(height: 20),
          _buildNotesInput(),
          const SizedBox(height: 100),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: ElevatedButton.icon(
            onPressed: () => _submit(context),
            icon: const Icon(Icons.check, size: 20),
            label: const Text('保存睡眠记录'),
          ),
        ),
      ),
    );
  }

  Widget _buildHeroBanner() {
    return MewCard(
      color: AppColors.lavender,
      child: Column(
        children: [
          const CharacterIllustration(
            variant: CharacterVariant.sleep,
            height: 120,
          ),
          const SizedBox(height: 8),
          const Text(
            '昨晚睡得怎么样呀？\n记录睡眠，帮助猫咪更懂你 🌙',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14, height: 1.5),
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
          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 12),
        child,
      ],
    );
  }

  Widget _buildTimePicker() {
    return GestureDetector(
      onTap: () async {
        final parts = _bedtime.split(':');
        final picked = await showTimePicker(
          context: context,
          initialTime: TimeOfDay(
            hour: int.parse(parts[0]),
            minute: int.parse(parts[1]),
          ),
        );
        if (picked != null) {
          setState(() {
            _bedtime =
                '${picked.hour.toString().padLeft(2, '0')}:${picked.minute.toString().padLeft(2, '0')}';
          });
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          children: [
            const Icon(Icons.access_time, color: AppColors.primary, size: 20),
            const SizedBox(width: 12),
            Text(
              _bedtime,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const Spacer(),
            const Icon(Icons.keyboard_arrow_down, color: AppColors.textHint),
          ],
        ),
      ),
    );
  }

  Widget _buildNotesInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '补充记录 (可选)',
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _notesCtrl,
          maxLength: 60,
          maxLines: 3,
          decoration: const InputDecoration(hintText: '有什么想补充的吗...'),
        ),
      ],
    );
  }

  Future<void> _submit(BuildContext context) async {
    final state = context.read<AppState>();
    final record = SleepRecord(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      recordedAt: DateTime.now(),
      bedtime: _bedtime,
      latency: _latencies[_latencyIndex],
      qualityIndex: _qualityIndex,
      wakeCount: _wakeCounts[_wakeIndex],
      wakeFeelingIndex: _feelingIndex,
      notes: _notesCtrl.text.isEmpty ? null : _notesCtrl.text,
    );
    await state.addSleepRecord(record);
    if (context.mounted) {
      showMewToast(context, state.lastInstantReply ?? '保存成功！');
      Navigator.pop(context);
    }
  }
}
