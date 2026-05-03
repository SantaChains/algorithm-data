# Rust 精进学习路线（基础语法后）

基于工程化实践与深度进阶需求，按核心能力→实战场景→性能优化→生态扩展分层推进，兼顾理论与落地。

## 一、 夯实进阶核心语法（突破所有权瓶颈）

### 深入所有权与生命周期

重点攻克：`'static` 生命周期、生命周期省略规则、子类型与协变/逆变、借用检查器底层逻辑。

学习资源：官方文档 + 《Rust 程序设计》第 10-12 章。

练习：实现一个安全的自引用结构体（不用 unsafe）、手写带生命周期的泛型缓存。

### 高级类型与模式匹配

掌握：enum 高级用法（递归枚举、状态机设计）、Option/Result 组合子（map/and_then/or_else）、模式解构（嵌套解构、if let/while let）、match 守卫。

练习：用 enum 实现 HTTP 状态码的类型安全处理、用组合子重构嵌套 match 代码（消除金字塔地狱）。

### Trait 高级特性

核心：关联类型、trait object（动态分发）、Sized 约束、Default/From/Into 转换、trait 继承与超 Trait。

关键实践：实现一个自定义迭代器（Iterator trait）、用 trait object 设计多态日志组件。

## 二、 实战场景驱动（从工具到服务）

### 1. 命令行工具开发（快速出活）

技术栈：clap（参数解析）+ anyhow/thiserror（错误处理）+ tokio（异步 CLI）+ indicatif（进度条）。

实战项目：

- 实现一个文件批量重命名工具（支持正则匹配、预览功能）。
- 开发一个异步日志分析器（读取大文件，统计关键词频率，输出可视化报告）。

核心要点：错误处理规范化（自定义错误类型）、配置文件解析（serde + toml/yaml）。

### 2. 异步编程（Rust 服务端核心）

#### 基础异步模型

吃透：Future trait 原理、async/await 执行流程、Pin 与非固定类型、Waker 唤醒机制。

资源：《Rust 异步编程》+ tokio 官方教程。

#### 主流运行时选型与实战

- tokio：工业级异步运行时，主攻服务端（TCP/UDP/HTTP 服务），练习：实现一个异步 TCP 回显服务器（支持并发连接）。
- async-std：轻量级运行时，API 更贴近标准库，适合工具类异步场景。

关键：理解 spawn 条件、select! 宏、JoinHandle 管理、异步安全（Send/Sync 约束）。

### 3. 服务端开发（进阶方向）

框架选型：

- axum（最流行，基于 tokio，路由宏友好）：练习实现一个 RESTful API 服务（用户 CRUD + JWT 认证 + 数据库交互）。
- actix-web（高性能，成熟生态）：适合高并发场景，学习中间件开发。

配套技术：

- 数据库：sqlx（异步 SQL，类型安全查询）+ postgres/mysql，或 diesel（ORM，同步优先）。
- 序列化：serde + json/msgpack。

## 三、 性能优化与底层能力（进阶工程师必备）

### 零成本抽象与性能调优

核心：`#[inline]` 与内联策略、泛型单态化原理、避免隐式拷贝（Copy trait 谨慎实现）、内存布局优化（`#[repr(C)]`/`#[repr(packed)]`）。

工具：cargo bench（基准测试）+ flamegraph（火焰图分析）+ cargo clippy（性能 lint）。

实践：优化一个数组排序函数（对比泛型版与具体类型版性能差异）、分析 Vec 扩容的性能开销。

### unsafe Rust 与底层编程

适用场景：性能关键路径、FFI 调用、硬件交互，严禁滥用。

必学：unsafe 块的 5 大能力（裸指针操作、可变静态变量、union 访问、调用 unsafe 函数、实现 unsafe trait）、内存安全准则。

练习：用裸指针实现一个无锁单链表（手动管理内存）、调用 C 语言动态库（FFI 实战）。

### 并发编程深度优化

同步原语：Mutex/RwLock 性能对比、Arc 引用计数优化、Condvar 条件变量、Barrier 屏障。

无锁编程：crossbeam-utils（原子类型、无锁队列）、lockfree 库。

实践：实现一个线程安全的全局配置管理器（读写分离，用 RwLock 优化读性能）。

## 四、 生态扩展与工程化实践

### Cargo 高级用法

掌握：自定义 build.rs（编译时生成代码、链接系统库）、cargo workspace（多包项目管理）、cargo publish（发布自己的 crate）、profiles 配置（调试/发布模式优化）。

实践：创建一个多 crate 工作区（拆分 lib 与 bin，配置依赖共享）。

### 跨平台与嵌入式开发（可选方向）

跨平台：std::os 模块、cfg 条件编译（区分 Windows/Linux/macOS）。

嵌入式：rust-embedded 生态、STM32 开发板实战、no_std 环境配置（脱离标准库）。

### 开源贡献与社区融入

步骤：从修复小 bug（good first issue）开始 → 提交文档改进 → 参与 crate 开发。

推荐 crate：clap/tokio/axum（issue 活跃，文档完善）。

## 五、 核心学习资源清单

| 类型 | 推荐内容 | 适用阶段 |
|------|----------|----------|
| 书籍 | 《Rust 权威指南》（第 2 版） | 进阶核心语法 |
| 书籍 | 《Rust 高性能编程》 | 性能优化 |
| 官方文档 | Rust Nomicon（死灵之书） | Unsafe Rust |
| 在线课程 | Rust 异步编程实战（B 站：张汉东） | 异步开发 |
| 实战项目 | 全阶段练习 | 全面 |
| 社区 | Rust 中文社区 + Reddit r/rust | 问题解决 + 资讯 |

## 关键原则

- **练大于看**：每学一个知识点，必须手写代码验证（比如生命周期理解，写 10 个例子比看 100 页书管用）。
- **聚焦场景**：优先选自己感兴趣的方向（CLI/服务端/嵌入式）深入，避免泛而不精。
- **善用工具**：cargo clippy 查代码问题，cargo fmt 统一格式，rust-analyzer 提升 IDE 体验。


## 推荐
- [ ] 学习Rust的异步编程
- [ ] 多语言编程
- [ ] wasm
- [ ] 


所有权、借用、生命周期（内存安全、无 GC、高性能核心）
Trait、泛型、错误处理 Result/thiserror/anyhow
异步（可选但推荐）tokio
模块系统、Cargo 工作空间（大型项目必备）
unsafe Rust、FFI、ABI 调用约定（混合汇编 / C++ 必备）
序列化 / 反序列化（Schema 兼容核心）
多线程、无锁数据结构（极致性能）
