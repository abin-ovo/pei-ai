# MEWMORY · 猫咪 AI 陪伴 App

基于设计稿实现的 Flutter 应用，支持 **iOS / Android / Web (H5)**。

## 产品闭环

### A · 日常陪伴闭环
- 首页根据时间、睡眠/咖啡记录生成猫咪问候
- 快捷记录咖啡 / 睡眠，完成后即时 Toast 回应
- 自动生成「猫咪观察」与「今日小建议」卡片

### B · 习惯洞察闭环
- 连续记录 3 天以上触发初步观察（实验室 + 首页洞察）
- 实验室：趋势图、关联分析、猫咪关键发现
- 周报：统计网格、趋势图、关键发现与建议

### C · 记忆关系闭环
- 重复偏好（如常喝拿铁）生成记忆候选
- 弹窗询问「要我记住吗」
- 确认后写入记忆中心，问候更个性化

## 技术栈

- Flutter 3.x
- `provider` 状态管理
- `fl_chart` 图表
- `shared_preferences` 本地持久化

## 运行

```bash
# 安装依赖
flutter pub get

# iOS / Android
flutter run

# Web (H5)
flutter run -d chrome
# 或构建
flutter build web
```

## 项目结构

```
lib/
├── app.dart                 # 应用入口
├── main.dart
├── core/
│   ├── theme/               # 设计系统颜色与 ThemeData
│   └── widgets/             # 通用组件（Chip、气泡、底栏等）
├── models/                  # 数据模型
├── providers/               # AppState（三闭环业务逻辑）
├── services/                # 问候、洞察、记忆检测
└── screens/
    ├── home/                # 首页
    ├── coffee/              # 记咖啡
    ├── sleep/               # 记睡眠
    ├── lab/                 # 实验室
    ├── memory/              # 记忆中心
    ├── weekly/              # 周报
    ├── profile/             # 我的
    └── shell/               # 主导航壳
```

## 设计规范

主色 `#FF8FAE`，背景 `#FDF2F5`，圆角 16–24px，详见 `lib/core/theme/app_colors.dart`。

设计参考图位于 `assets/images/`。
