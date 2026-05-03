# Modern C++ 权威指南

> 本文档涵盖现代 C++ 常用语法（C++11~C++23 普及特性）以及 C++26 最新特性
> 风格参考：《Effective Modern C++》《C++ Core Guidelines》
> 更新时间：2026年5月

---

## 目录

- [第一部分：现代 C++ 普及语法（C++11 ~ C++23 已广泛应用）](#第一部分现代-c-普及语法c11--c23-已广泛应用)
  - [1. 智能指针：不再手动 delete](#1-智能指针不再手动-delete)
  - [2. auto 类型推导：让编译器帮你记类型](#2-auto-类型推导让编译器帮你记类型)
  - [3. 范围for循环：告别下标递增](#3-范围for循环告别下标递增)
  - [4. Lambda 表达式：函数对象随手定义](#4-lambda-表达式函数对象随手定义)
  - [5. constexpr：编译期计算](#5-constexpr编译期计算)
  - [6. 结构化绑定：拆解 pair / tuple 的优雅方式](#6-结构化绑定拆解-pair--tuple-的优雅方式)
  - [7. 统一初始化：`{}` 一把梭](#7-统一初始化--一把梭)
  - [8. std::optional：表示"可能没有值"](#8-stdoptional表示可能没有值)
  - [9. std::variant：类型安全的 union](#9-stdvariant类型安全的-union)
  - [10. std::string_view：只读字符串视图](#10-stdstring_view只读字符串视图)
  - [11. std::format / std::print：格式化输出](#11-stdformat--stdprint格式化输出)
  - [12. concepts：约束模板参数](#12-concepts约束模板参数)
  - [13. 模块（Modules）：include 的继任者](#13-模块modulesinclude-的继任者)
- [第二部分：C++26 最新特性（2026年正式发布）](#第二部分c26-最新特性2026年正式发布)
  - [1. Contracts：契约式编程](#1-contracts契约式编程)
  - [2. 静态反射（Reflection）：编译期自窥元数据](#2-静态反射reflection编译期自窥元数据)
  - [3. `std::expected<T, E>`：错误处理新范式](#3-stdexpectedt-e错误处理新范式)
  - [4. `std::flat_map` / `std::flat_set`：连续存储的容器](#4-stdflat_map--stdfalt_set连续存储的容器)
  - [5. `std::print` / `std::println`：终于像 Python 一样打印](#5-stdprint--stdprintln终于像-python-一样打印)
  - [6. `using enum`：消除枚举作用域冗余](#6-using-enum消除枚举作用域冗余)
  - [7. `std::to_underlying` / `std::byteswap`：工具函数补全](#7-stdtounderlying--stdbyteswap工具函数补全)
  - [8. 更多库改进](#8-更多库改进)
- [编译器支持速查](#编译器支持速查)

---

## 第一部分：现代 C++ 普及语法（C++11 ~ C++23 已广泛应用）

> 以下特性在 2026 年的生产代码中已属于"常规操作"，如果你还不熟悉，说明需要更新知识体系了。

### 1. 智能指针：不再手动 delete

**核心思想：** 谁申请谁释放，但用对象代替裸指针。RAII 原则——资源获取即初始化，析构函数自动释放。

```cpp
#include <memory>

// unique_ptr：独占所有权，不可复制，只能移动
std::unique_ptr<int> p1 = std::make_unique<int>(42);

// shared_ptr：共享所有权，引用计数，自动释放
std::shared_ptr<int> p2 = std::make_shared<int>(42);

// weak_ptr：shared_ptr 的观察者，不影响引用计数
std::weak_ptr<int> w = p2;
if (auto locked = w.lock()) {
    // 安全使用
}

// 旧式写法（2026年应避免）
int* raw = new int(42);
delete raw;  // ← 极易引发内存泄漏
```

**何时选谁：**

- 绝大多数场景 → `std::unique_ptr`（零额外开销）
- 需要共享所有权（如工厂返回对象） → `std::shared_ptr`
- 打破循环引用 → `std::weak_ptr`

---

### 2. auto 类型推导：让编译器帮你记类型

**核心思想：** 让编译器从初始化表达式推断变量类型，减少冗余书写，降低拼写错误。

```cpp
auto a = 42;              // int
auto b = 3.14;            // double
auto c = std::vector<int>{1, 2, 3};
auto& r = c;              // 保留引用
const auto& cr = c;       // 保留 const 引用
auto&& rr = c;            // 万能引用（转发引用）

// 旧式写法（2026年仍可读，但冗余）
std::vector<int>::iterator it = c.begin();
```

**注意：** `auto` 会丢弃引用和 cv 限定符（const/volatile）。如需保留，使用 `auto&`、`auto&&`、`const auto&`。

---

### 3. 范围for循环：告别下标递增

**核心思想：** 直接遍历容器元素，语法简洁，无下标越界风险。

```cpp
std::vector<int> nums = {1, 2, 3, 4, 5};

// C++11 起可用
for (int n : nums) {
    std::print("{} ", n);
}

// C++20 起可以加初始化
for (auto&& [i, n] : std::views::enumerate(nums)) {
    std::print("{}:{} ", i, n);
}

// 旧式写法（2026年应避免）
for (auto it = nums.begin(); it != nums.end(); ++it) {
    std::cout << *it << " ";
}
```

---

### 4. Lambda 表达式：函数对象随手定义

**核心思想：** 在需要函数对象的地方直接写匿名函数块，随用随定义，捕获周围变量。

```cpp
#include <algorithm>

std::vector<int> v = {5, 2, 8, 1, 9};

// 基本语法：[capture](params) -> ret { body }
std::sort(v.begin(), v.end(), [](int a, int b) {
    return a > b;  // 降序
});

// 捕获方式
int threshold = 5;
auto big = [threshold](int x) { return x > threshold; };        // 值捕获
auto big2 = [&threshold](int x) { return x > threshold; };       // 引用捕获（小心生命周期）
auto big3 = [=](int x) { return x > threshold; };               // 一切值捕获
auto big4 = [&](int x) { return x > threshold; };               // 一切引用捕获

// C++14 起：泛型 lambda（auto 参数）
auto printer = [](auto x) { std::print("{} ", x); };

// C++14 起：初始化捕获（移动语义等）
auto p = std::make_unique<int>(42);
auto captured = [p = std::move(p)] { return *p; };

// C++20 起：模板语法
auto tmpl = []<typename T>(T x) { return x; };

// C++20 起：constexpr lambda
constexpr auto sq = [](int x) { return x * x; };
static_assert(sq(3) == 9);
```

**何时用：** STL 算法回调、即时策略对象、作用域内短函数。

---

### 5. constexpr：编译期计算

**核心思想：** 标记为 constexpr 的函数和变量在编译期求值，减少运行时开销。

```cpp
// C++14 起 constexpr 函数可以包含更多语句
constexpr int factorial(int n) {
    int result = 1;
    for (int i = 2; i <= n; ++i) result *= i;
    return result;
}
static_assert(factorial(10) == 3628800);  // 编译期验证

// C++17 起 constexpr 可以操作 std::string_view
constexpr bool starts_with(std::string_view sv, std::string_view prefix) {
    return sv.size() >= prefix.size()
        && sv.substr(0, prefix.size()) == prefix;
}
static_assert(starts_with("hello", "hel"));

// C++20 起 constexpr 可以有虚拟函数、try/catch、动态分配（受限）
// C++26 进一步扩展 constexpr 边界
```

---

### 6. 结构化绑定：拆解 pair / tuple 的优雅方式

**核心思想：** 一行代码把结构拆成独立变量，命名清晰，代码可读。

```cpp
#include <map>

// pair
std::pair<std::string, int> p = {"Alice", 30};
auto [name, age] = p;
std::print("{} is {} years old\n", name, age);

// map 遍历时拆解
std::map<std::string, int> scores = {{"Bob", 85}, {"Carol", 92}};
for (auto&& [key, value] : scores) {
    std::print("{}: {}\n", key, value);
}

// 数组 / 结构体
int arr[3] = {1, 2, 3};
auto [a, b, c] = arr;

struct Point { double x, y; };
Point pt = {1.5, 2.5};
auto [px, py] = pt;
```

---

### 7. 统一初始化：`{}` 一把梭

**核心思想：** 大括号初始化 `{}` 统一所有场景——不经历缩窄转换，兼容聚合体和容器。

```cpp
// 大括号初始化
int x1 = 42;   // 两种写法等价
int x2{42};    // ← 统一写法（但注意：int x{} 是 0，不是报错）

// 容器初始化
std::vector<int> v1{1, 2, 3};
std::vector<int> v2 = {1, 2, 3};  // 等价，推荐

// 聚合体初始化（结构体/数组）
struct Config {
    int timeout = 30;
    bool debug = false;
};
Config cfg{.timeout = 60, .debug = true};  // C++20 designated initializer

// 缩窄检查（大括号会阻止）
int n = 3.14;   // 编译警告：缩窄转换
int m{3.14};    // 编译错误：不允许缩窄

// 避免最令人困惑的解析
std::vector<int> v(5, 1);   // 5 个元素，每个都是 1
std::vector<int> v2{5, 1};  // 2 个元素：5 和 1
```

---

### 8. std::optional：表示"可能没有值"

**核心思想：** 替代 NULL 指针和特殊值，明确表达"值可能缺失"的语义。

```cpp
#include <optional>

std::optional<int> find_user_id(const std::string& name) {
    if (name == "Alice") return 42;
    return std::nullopt;  // 没有值
}

auto result = find_user_id("Bob");
if (result) {
    std::print("User ID: {}\n", *result);
}

// C++23 起提供.value_or()
int id = find_user_id("Bob").value_or(-1);  // 没有则返回 -1

// 旧式 C 风格：返回特殊值（容易出错）
// int find_user_id(...) { if(...) return -1; }  ← 调用方易忘记检查
```

---

### 9. std::variant：类型安全的 union

**核心思想：** union 的类型安全版本，存储多种类型之一，访问时带类型检查。

```cpp
#include <variant>

std::variant<int, std::string, double> v = "hello";

v = 42;

// 安全访问方式 1：std::visit（推荐）
std::visit([](auto&& arg) {
    std::print("variant holds: {}\n", arg);
}, v);

// 安全访问方式 2：std::get_if
if (auto ptr = std::get_if<int>(&v)) {
    std::print("int: {}\n", *ptr);
}

// 旧式 union（不推荐）
union U { int i; double d; };  // 需要手动跟踪当前哪个字段有效
```

**注意：** `std::variant` 默认不允许空状态（类似 union）。如果需要无意义状态，结合 `std::optional`。

---

### 10. std::string_view：只读字符串视图

**核心思想：** 不持有数据，只引用外部字符串，只读访问，避免不必要的复制。

```cpp
#include <string_view>

void process(std::string_view sv) {  // 接受 string、const char*、string_view
    std::print("String: {}\n", sv);
}

std::string s = "hello world";
std::string_view sv = s;          // 不复制，零开销
std::string_view sv2 = "literal"; // 指向字面量，无复制

// 只读操作
std::print("Length: {}, first 5: {}\n", sv.size(), sv.substr(0, 5));
sv.remove_prefix(6);               // 移动起始位置，不复制数据

// 避免不必要的 std::string 复制
void log(std::string_view msg);   // ← 推荐：调用方可以零复制传入
// void log(const std::string& msg); // ← 差：调用方传 char* 需要复制
```

---

### 11. std::format / std::print：格式化输出

**核心思想：** 类型安全的格式化字符串，媲美 Python 的 f-string，告别 `printf` 的类型不安全。

```cpp
#include <format>    // C++20
#include <print>     // C++23（直接输出，无需 std::cout）

// C++23 std::print（推荐）
std::print("Name: {}, Age: {}, Score: {:.2f}\n", "Alice", 30, 98.567);

// C++20 std::format（生成字符串）
auto s = std::format("{} + {} = {}", 1, 2, 3);
std::println("Result: {}", s);

// 对齐和填充
std::print("{:>10} {:<8} {:^10}\n", "Right", "Left", "Center");

// 进制转换
std::print("Decimal: {}, Hex: {:x}, Binary: {:b}\n", 42, 42, 42);

// 旧式写法（2026年应减少使用）
printf("Name: %s, Age: %d\n", "Alice", 30);  // ← 类型不安全，编译器不报错
```

---

### 12. concepts：约束模板参数

**核心思想：** 为模板参数设定"约束条件"，让编译器错误信息从一团乱麻变成清晰的说明。

```cpp
#include <concepts>

// 定义约束
template <typename T>
concept Numeric = std::integral<T> || std::floating_point<T>;

// 使用约束
template <Numeric T>
T add(T a, T b) { return a + b; }

static_assert(Numeric<int>);      // 通过
static_assert(!Numeric<std::string>);  // 不通过

// C++20 标准库 concepts
template <std::ranges::range R>
void print_all(R&& r) {
    for (auto&& x : r) std::print("{} ", x);
}

// 旧式 SFINAE（2026年应避免）
template <typename T,
    typename = std::enable_if_t<std::is_integral_v<T>>>
T double_it(T v) { return v * 2; }
```

---

### 13. 模块（Modules）：include 的继任者

**核心思想：** 取代 `#include`，编译更快，命名空间更干净，消除宏污染头文件的隐患。

```cpp
// ---------- math.ixx（模块接口） ----------
module;  // 全局模块片段（隔离）
export module math;

export int add(int a, int b) { return a + b; }

// ---------- main.cpp ----------
import math;

int main() {
    std::print("{}\n", add(1, 2));
}
```

**优势：** 编译速度提升数倍（大型项目效果显著）；消除 `#define` 宏污染；更清晰的命名空间边界。

**现状：** C++20 引入，C++23 改进，C++26 继续完善。GCC 14+、Clang 16+、MSVC 19.36+ 已支持。

---

## 第二部分：C++26 最新特性（2026年正式发布）

> C++26 于 2026 年 3 月由 ISO 正式批准（ISO/IEC 14882:2026）。GCC 16、Clang 19、MSVC 19.52 已支持大部分特性。

### 1. Contracts：契约式编程

**一句话理解：** 为函数写"前置条件""后置条件"和"断言"，像写法律合同一样写代码，编译器帮你检查。

```cpp
// C++26 语法（GCC 16 实验性支持）
int divide(int a, int b)
    pre(a != 0)                              // 前置条件：输入必须满足
    post(int result : result == a / b)       // 后置条件：结果必须满足
{
    contract_assert(b != 0);                 // 运行时断言
    return a / b;
}

// 调用时若违反契约，抛出 std::contract_failure
try {
    divide(10, 0);
} catch (const std::contract_failure& e) {
    std::println("Contract violated: {}", e.what());
}
```

**三种契约：**

| 契约类型 | 关键字 | 含义 |
|---|---|---|
| 前置条件 | `pre(...)` | 调用者必须满足的条件（参数校验） |
| 后置条件 | `post(name : expr)` | 返回后必须满足的条件（结果校验） |
| 断言 | `contract_assert(...)` | 任意位置的运行时检查 |

**使用场景：** 关键函数（除法、内存分配、API 接口）的防御性编程，游戏引擎物理模块、金融计算等高可靠性场景。

---

### 2. 静态反射（Reflection）：编译期自窥元数据

**一句话理解：** 在编译期查询类型、结构体成员、枚举值等元信息，告别手写序列化、ORM 映射等样板代码。

```cpp
#include <meta>

struct User {
    int id;
    std::string name;
    double score;
};

// C++26 反射操作符：^^ 获取元信息
constexpr auto info = ^^User;

// 查询成员
constexpr auto members = std::meta::members_of(info);
static_assert(std::meta::name_of(members[0]) == "id");

// 编译期计算
constexpr int id_offset = std::meta::offset_of<^^User, "id">;

// 生成的代码片段可以写回源文件（通过 [[splice]]）
```

**典型应用场景：**

- 自动序列化 / 反序列化（告别手写 `Serialize()` 方法）
- JSON / Protobuf 代码自动生成
- 依赖注入容器自动绑定

```cpp
// 序列化示例（伪代码）
template <typename T>
std::string serialize(const T& obj) {
    std::string json = "{";
    auto members = std::meta::members_of(^^T);
    // 编译期展开成员名和值，自动拼接 JSON
    return json + "}";
}
```

---

### 3. `std::expected<T, E>`：错误处理新范式

**一句话理解：** 返回值要么是正常结果 `T`，要么是错误 `E`，没有异常开销，明确且高效。

```cpp
#include <expected>

std::expected<int, std::string> parse_int(std::string_view s) {
    int value = 0;
    // 解析失败
    if (s.empty()) {
        return std::unexpected("Empty string");
    }
    return value;
}

auto result = parse_int("42");
if (result) {
    std::print("Parsed: {}\n", *result);
} else {
    std::print("Error: {}\n", result.error());
}

// C++23 起可用
int val = parse_int("abc").value_or(0);
```

**对比异常：** `std::expected` 适合"已知会失败"的正常流程（如解析、I/O）；异常适合"真正意外"的错误。

---

### 4. `std::flat_map` / `std::flat_set`：连续存储的容器

**一句话理解：** 用两个并行数组代替树节点，实现更快的缓存命中和更低的内存开销。

```cpp
#include <flat_map>

std::flat_map<std::string, int> fm;
fm["Alice"] = 30;
fm["Bob"] = 25;

// 底层是连续存储：键在一个 vector，值在另一个 vector
// 插入/删除比 std::map 慢（需要移动元素）
// 查找和迭代比 std::map 快（缓存友好）

// 适用场景：查找密集型（哈希表级查找性能）+ 迭代密集型
// 不适用场景：频繁插入/删除 + 需要有序范围查找
```

---

### 5. `std::print` / `std::println`：终于像 Python 一样打印

**一句话理解：** C++23 已引入，C++26 继续完善，告别 `printf` 的类型安全隐患。

```cpp
#include <print>

std::println("Hello, {}! Pi is {:.4f}", "World", 3.14159);
std::print("No newline at end. ");
std::println("Auto newline here.");

// 文件输出
std::ofstream out("log.txt");
std::println(out, "Status: {} - Code: {}", "OK", 200);
```

---

### 6. `using enum`：消除枚举作用域冗余

**一句话理解：** 打开枚举作用域，无需重复写 `EnumClass::VALUE`，代码更简洁。

```cpp
enum class Color { Red, Green, Blue };

void draw(Color c) {
    // C++20 前：必须加前缀
    if (c == Color::Red) { /* ... */ }

    // C++20 起：using enum
    using enum Color;
    if (c == Red) { /* 更清晰 */ }
}

// 无 using enum 时（仍需要命名空间隔离）
enum class Status { Ok, Error, Pending };
using enum Status;
if (s == Ok) { }  // OK，但没有隔离，可能冲突
```

---

### 7. `std::to_underlying` / `std::byteswap`：工具函数补全

```cpp
#include <utility>

// C++23 起：C++26 继续推广
std::underlying_type_t<Color> u = std::to_underlying(Color::Red);

// C++23 起：字节序反转
#include <bit>
auto swapped = std::byteswap(0x12345678u);  // 0x78563412
```

---

### 8. 更多库改进

| 特性 | 简介 |
|---|---|
| `std::views::enumerate` | 遍历时同时获取索引和值 |
| `std::views::zip` | 并行遍历多个容器 |
| `std::views::chunk` | 按块划分容器 |
| `std::mdspan` | 多维数组视图（类 CUDA 风格） |
| `std::spanstream` | 用 `std::span` 作为字符串流底层 |
| `std::simd` | SIMD 矢量操作库（库层面支持） |
| `std::latch` / `std::barrier` | 线程同步原语（C++20 有，C++26 改进） |

---

## 编译器支持速查

| 特性 | GCC | Clang | MSVC |
|---|---|---|---|
| C++20 (`std::format`/concepts/ranges) | GCC 10+ | Clang 13+ | MSVC 19.29+ |
| C++23 (`std::print`/`std::expected`/flat_*) | GCC 13+ | Clang 17+ | MSVC 19.41+ |
| C++26 (Contracts/Reflection) | GCC 16+ (实验) | Clang 19+ (实验) | MSVC 19.52+ (预览) |
| C++26 (正式特性) | GCC 14+ (大多数) | Clang 17+ (大多数) | MSVC 19.36+ (大多数) |

> 启用方式：GCC `-std=c++26` 或 `-std=c++2c`；Clang 同；MSVC `/std:c++26` 或 `/std:c++latest`

---

*本文档为现代 C++ 快速参考，详尽语法建议查阅 [cppreference.com](https://en.cppreference.com/w/cpp) 和 [C++ Core Guidelines](https://isocpp.github.io/CppCoreGuidelines/)。*
