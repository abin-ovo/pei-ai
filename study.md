# flutter 学习

## 一、常见数据类型

### 1.数字
``` dart
int count = 3； // 整数
double price = 9.99; //浮点型
num value = 42; // int 或 double 的父类型
```

### 2.字符串
``` dart
String name = '喵喵';
String greeting = "早安呀 🌸";
String multi = '''
多行
文本
''';
```

### 3.布尔
``` dart
bool loaded = false;
bool isSelected = true;
```

### 4.空安全
<!-- Dart 默认变量不能为 null，需要显式加 ?： -->
``` dart
String? maybeNull; //可以是null
String notNull = 'a' //不能赋 null

int? x;
print(x ?? 0); //为null 时用 0
```

### 5.集合
``` dart
List<String> tags = ['kafei', '睡觉'];
Set<String> options = {'饭后', '空腹'};
Map<String, int> scores = {'quality': 70};
```

### 6.其他常用类型
``` dart
// 记录 （Dart 3）
(String, int) = ('拿铁', 80);
// 枚举
enum MemoryCategory { all, preference, habit };
// 函数类型
void Function(int) callback = (i) => print(i);
// 对象（自定义类）
class CoffeeRecord { ... };
```

### 7.特殊类型
``` dart
| 类型        |   说明                  ｜
|————————————｜————————————————————————｜
| dynamic    ｜任意类型，尽量少用         ｜
| Object     ｜所有非 null 对象的基类    ｜
| void       ｜无返回值（多用于函数       ｜
| Future<T>  ｜异步结果                 ｜
| Stream<T>  ｜异步数据流               ｜
```