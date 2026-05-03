# Rust 示例

## 各类 print 示例

### println! / print!

```rust
fn main() {
    println!("普通输出");
    println!("格式化输出: {}", "value");
    println!("多参数: {} + {} = {}", 1, 2, 3);
    println!("位置参数: {0} {1} {0}", "A", "B");
    println!("命名参数: {name} = {value}", name = "count", value = 42);

    print!("不换行输出 ");
    println!("这里换行");

    println!("小数: {:.2}", 3.14159);
    println!("进制: {:b} {:o} {:x}", 10, 10, 10);
    println!("宽度: {:>5}", 42);
    println!("填充: {:0>5}", 42);
}
```

### eprintln! / eprint!

```rust
fn main() {
    eprintln!("错误输出到 stderr");
    eprint!("错误不换行 ");
    eprintln!("继续");
}
```

### format!

```rust
fn main() {
    let s = format!("拼接: {} {}", "Hello", "World");
    println!("{}", s);

    let hex = format!("{:x}", 255);
    println!("Hex: {}", hex);
}
```

### dbg!

```rust
fn main() {
    let x = 5;
    dbg!(x);
    dbg!(x * 2 + 1);

    let mut vec = vec![1, 2, 3];
    dbg!(&vec);
    vec.push(4);
    dbg!(&vec);
}
```

---

## cargo 使用

### 基础命令

```bash
cargo new my_project      # 创建新项目
cargo init                 # 初始化当前目录为项目
cargo build                # 编译项目
cargo run                  # 编译并运行
cargo test                 # 运行测试
cargo bench                # 运行基准测试
cargo check                # 检查代码（不生成二进制）
cargo update               # 更新依赖
```

### 依赖管理

```bash
cargo add serde           # 添加依赖
cargo add serde --dev     # 添加开发依赖
cargo add serde --build    # 添加构建依赖
cargo tree                # 查看依赖树
cargo tree --inverse serde # 查看谁依赖了 serde
```

### 项目配置

```toml
[package]
name = "my_project"
version = "0.1.0"
edition = "2021"

[dependencies]
serde = "1.0"
serde_json = "1.0"
tokio = { version = "1", features = ["full"] }

[profile.release]
opt-level = 3
lto = true
```

### 工作区

```toml
[workspace]
members = [
    "crate-a",
    "crate-b",
]

[workspace.dependencies]
shared = "1.0"
```

```bash
cargo build --workspace      # 构建整个工作区
cargo build -p crate-a       # 构建指定包
cargo test -p crate-a        # 测试指定包
```

### 其他常用命令

```bash
cargo doc --open             # 生成文档并打开
cargo fmt                    # 格式化代码
cargo clippy                 # 运行 linter
cargo fix                    # 自动修复
cargo publish                # 发布到 crates.io
cargo search <name>          # 搜索 crates
cargo info <name>            # 查看 crate 信息
```

---

## crate 使用

### 标准库常用 crate

```rust
// std::collections
use std::collections::{HashMap, HashSet, VecDeque};

fn main() {
    let mut map = HashMap::new();
    map.insert("key", 42);
    println!("{:?}", map.get("key"));

    let set = HashSet::from([1, 2, 3, 2, 1]);
    println!("{:?}", set);

    let mut deque = VecDeque::new();
    deque.push_front(1);
    deque.push_back(2);
    println!("{:?}", deque.pop_front());
}

// std::fs
use std::fs;
use std::io::{self, Read};

fn read_file(path: &str) -> io::Result<String> {
    let mut content = String::new();
    fs::File::open(path)?.read_to_string(&mut content)?;
    Ok(content)
}

fn write_file(path: &str, content: &str) -> io::Result<()> {
    fs::write(path, content)
}

// std::thread
use std::thread;
use std::time::Duration;

fn main() {
    let handle = thread::spawn(|| {
        for i in 1..=5 {
            println!("线程: {}", i);
            thread::sleep(Duration::from_millis(100));
        }
    });
    handle.join().unwrap();
}

// std::sync::Arc
use std::sync::Arc;
use std::thread;

fn main() {
    let data = Arc::new(vec![1, 2, 3]);
    let data_clone = Arc::clone(&data);

    thread::spawn(move || {
        println!("线程访问: {:?}", data_clone);
    }).join().unwrap();

    println!("主线程: {:?}", data);
}
```

### 常用第三方 crate

```rust
// serde - 序列化
use serde::{Serialize, Deserialize};

#[derive(Serialize, Deserialize, Debug)]
struct Person {
    name: String,
    age: u32,
}

// thiserror - 错误处理
use thiserror::Error;

#[derive(Error, Debug)]
enum MyError {
    #[error("IO error: {0}")]
    Io(#[from] std::io::Error),

    #[error("解析错误: {0}")]
    Parse(String),
}

// anyhow - 任意错误
use anyhow::Result;

fn main() -> Result<()> {
    anyhow::ensure!(true, "条件不满足");
    Ok(())
}

// clap - 命令行参数
use clap::Parser;

#[derive(Parser, Debug)]
#[command(name = "myapp")]
struct Args {
    #[arg(short, long)]
    name: String,
}

// tokio - 异步运行时
#[tokio::main]
async fn main() {
    let handle = tokio::spawn(async {
        42
    });
    let result = handle.await.unwrap();
    println!("异步结果: {}", result);
}
```

### 发布自己的 crate

```rust
// src/lib.rs
pub mod utils;

pub fn public_function() {
    utils::private_helper();
}

// src/utils.rs
fn private_helper() {
    println!("内部函数");
}
```

```toml
# 发布配置
[package]
name = "my_crate"
version = "0.1.0"
license = "MIT"
repository = "https://github.com/username/my_crate"
description = "一个简短的描述"
authors = ["Your Name <you@example.com>"]
categories = ["utility"]
keywords = ["utils", "helper"]

[lib]
name = "my_crate"
path = "src/lib.rs"
```

```bash
cargo login                   # 登录 crates.io
cargo package                 # 打包
cargo publish                 # 发布
```

### 常用 crates.io 搜索关键词

| 场景 | 推荐 crate |
|------|-----------|
| Web 服务 | axum, actix-web, rocket |
| 异步运行时 | tokio, async-std |
| 命令行 | clap, structopt, inquire |
| 错误处理 | anyhow, thiserror, color-eyre |
| 序列化 | serde, rkyv, postcard |
| 数据库 | sqlx, diesel, sea-orm |
| 日志 | tracing, log, env_logger |
| 配置 | config, figment |
| 测试 | tokio-test, proptest, fuzzy-matcher |
