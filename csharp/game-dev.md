# C# Game Dev

## Unity

Unity 是以 C# 为主要脚本语言的引擎，脚本继承 =MonoBehaviour=，挂载到 GameObject 上运行。

### 创建与挂载脚本

1. Project 窗口 → Create → C# Script → 命名（类名必须与文件名一致）
2. 将脚本拖到 Hierarchy 中的 GameObject，或在 Inspector 点击 Add Component

### 脚本结构

```csharp
using UnityEngine;
using System.Collections;

public class MoveObject : MonoBehaviour
{
    public float speed = 10.0f;  // public 变量可在 Inspector 面板编辑

    void Start()
    {
        // 第一帧之前调用，适合初始化
        Debug.Log("Game started!");
    }

    void Update()
    {
        // 每帧调用，处理输入、移动等
        transform.Translate(Vector3.forward * speed * Time.deltaTime);
    }

    void OnDestroy()
    {
        // 对象销毁时调用
    }
}
```

生命周期：=Start()= → =Update()= 每帧 → =OnDestroy()=

### 常用组件访问

```csharp
public class Example : MonoBehaviour
{
    public Rigidbody rb;

    void Start()
    {
        // 获取挂载在同一对象上的组件
        rb = GetComponent<Rigidbody>();

        // 查找其他对象
        GameObject player = GameObject.Find("Player");
        Transform target = player.transform;

        // 发送消息（不推荐，性能差）
        gameObject.SendMessage("TakeDamage", 10f);
    }

    void Update()
    {
        // 输入检测
        if (Input.GetKeyDown(KeyCode.Space))
        {
            Debug.Log("Space pressed!");
        }

        // 获取鼠标位置
        float mouseX = Input.GetAxis("Mouse X");
    }
}
```

### 物理与碰撞

```csharp
public class PlayerController : MonoBehaviour
{
    public float jumpForce = 5f;
    private Rigidbody rb;

    void Start() => rb = GetComponent<Rigidbody>();

    void Update()
    {
        // 跳跃（仅在地面检测）
        if (Input.GetButtonDown("Jump"))
        {
            rb.AddForce(Vector3.up * jumpForce, ForceMode.Impulse);
        }
    }

    // 碰撞检测
    void OnCollisionEnter(Collision collision)
    {
        Debug.Log($"Collided with: {collision.gameObject.name}");
    }

    // 触发器检测
    void OnTriggerEnter(Collider other)
    {
        if (other.CompareTag("Coin"))
        {
            Destroy(other.gameObject);
        }
    }
}
```

### 协程

```csharp
public class CoroutineExample : MonoBehaviour
{
    IEnumerator Start()
    {
        Debug.Log("Start waiting...");
        yield return new WaitForSeconds(2f);
        Debug.Log("2 seconds passed!");
        yield return null;  // 等待下一帧
    }
}
```

### Prefab 实例化与资源加载

```csharp
public class Spawner : MonoBehaviour
{
    public GameObject prefab;

    void Start()
    {
        // 同步实例化
        GameObject obj = Instantiate(prefab, transform.position, Quaternion.identity);

        // 异步加载场景
        StartCoroutine(LoadSceneAsync("Scene2"));
    }

    IEnumerator LoadSceneAsync(string sceneName)
    {
        AsyncOperation op = UnityEngine.SceneManagement.SceneManager
            .LoadSceneAsync(sceneName);
        yield return op;
        Debug.Log("Scene loaded!");
    }
}
```

### 常用命名空间

| 命名空间 | 用途 |
|---------|------|
| =UnityEngine= | 核心：GameObject, Transform, Input, Time |
| =UnityEngine.SceneManagement= | 场景切换 |
| =UnityEngine.UI= | UI 系统 |
| =UnityEngine.Audio= | 音频 |

---

## Unreal Engine

Unreal Engine 原生使用 C++ 和 Blueprint，C# 需通过第三方插件 =UnrealSharp=（.NET 8）使用。

### 官方方式：C++ 与 Blueprint 协同

Unreal 中 C++ 用于高性能底层逻辑，Blueprint 用于可视化逻辑。

#### C++ Actor 类定义

```cpp
// MyActor.h
#pragma once
#include "CoreMinimal.h"
#include "GameFramework/Actor.h"
#include "MyActor.generated.h"

UCLASS()
class MYGAME_API AMyActor : public AActor
{
    GENERATED_BODY()

public:
    UPROPERTY(EditAnywhere, BlueprintReadWrite, Category = "My Actor")
    float Health = 100.f;

    UFUNCTION(BlueprintCallable, Category = "My Actor")
    void TakeDamage(float Damage);

    virtual void BeginPlay() override;
    virtual void Tick(float DeltaTime) override;
};
```

```cpp
// MyActor.cpp
#include "MyActor.h"

void AMyActor::TakeDamage(float Damage)
{
    Health -= Damage;
    if (Health <= 0.f)
    {
        Destroy();
    }
}

void AMyActor::BeginPlay()
{
    Super::BeginPlay();
    UE_LOG(LogTemp, Warning, TEXT("Actor spawned: %s"), *GetName());
}

void AMyActor::Tick(float DeltaTime)
{
    Super::Tick(DeltaTime);
    // 每帧逻辑
}
```

#### Blueprint 调用 C++

- =UPROPERTY= 标记的成员自动在 Blueprint 中可见
- =UFUNCTION(BlueprintCallable)= 标记的函数可在 Blueprint 中调用
- =UCLASS(Blueprintable)= 使 C++ 类可被 Blueprint 继承

### 生命周期对比（Unity vs UE）

| Unity | Unreal (Actor) | 说明 |
|-------|----------------|------|
| =Start()= | =BeginPlay()= | 首次帧更新前 |
| =Update()= | =Tick()= | 每帧调用 |
| =OnDestroy()= | =EndPlay()= | 销毁时 |
| =OnCollisionEnter()= | =OnActorHit()= | 碰撞时 |

### UnrealSharp：C# 原生支持（UE5）

UnrealSharp 是第三方插件，为 Unreal Engine 5 提供 .NET 8 C# 支持。

#### 安装

1. 从 [UnrealSharp GitHub](https://github.com/UnrealSharp/UnrealSharp) 下载插件
2. 复制到项目 =Plugins= 目录
3. 重新生成 VS 项目文件

#### C# 类示例

```csharp
using UnrealSharp;
using UnrealSharp.Attributes;
using UnrealSharp.GameFramework;

[Blueprintable, BlueprintType]
public class MySharpActor : Actor
{
    [BlueprintReadWrite]
    public float Health { get; set; } = 100f;

    [BlueprintCallable]
    public void TakeDamage(float damage)
    {
        Health -= damage;
        if (Health <= 0f) Destroy();
    }

    public override void BeginPlay()
    {
        base.BeginPlay();
        UnrealSharp.Utils.Log($"Actor initialized: {Name}");
    }

    public override void Tick(float deltaTime)
    {
        base.Tick(deltaTime);
    }
}
```

#### 功能

- .NET 8 Runtime，热重载（无需重启引擎）
- 自动绑定 UE API（UPROPERTY/UFUNCTION 自动生成 C# 接口）
- 支持 NuGet 包
- 平台：Windows/macOS（iOS/Android 规划中）

### 性能建议

- 频繁调用的逻辑用 C++/C#，低频逻辑用 Blueprint
- Blueprint 底层是虚拟机字节码，C++ 是直接机器码
- 大规模数据处理、物理模拟、多线程 → C++

---

## Godot

Godot 4.x 原生支持 C#（需 .NET SDK），通过 .NET 6.0 集成。脚本继承 Godot 类，挂载到节点。

### 环境配置

1. 安装 [.NET SDK](https://dotnet.microsoft.com/download)（64-bit）
2. 下载 Godot 4.x .NET 版本
3. Editor → Editor Settings → DotNet → 外部编辑器（VS Code / Rider / VS2022）
4. Project → Project Settings → DotNet → 启用 .NET

### 创建 C# 脚本

右键节点 → Attach Script → 选择 C# → 创建。文件名必须与类名一致。

### 脚本结构

```csharp
using Godot;

public partial class MyNode : Node
{
    [Export]
    private float speed = 200f;

    public override void _Ready()
    {
        // 节点进入场景树时调用（相当于 Unity Start）
        GD.Print("Node ready!");
    }

    public override void _Process(double delta)
    {
        // 每帧调用（delta 为秒）
        GD.Print($"Delta: {delta}");
    }

    public override void _PhysicsProcess(double delta)
    {
        // 物理处理（固定时间步）
    }
}
```

### 节点与场景

```csharp
using Godot;

public partial class SceneLoader : Node
{
    public override void _Ready()
    {
        // 加载场景
        var scene = ResourceLoader.Load<PackedScene>("res://Scenes/Enemy.tscn");
        var instance = scene.Instantiate<Node2D>();
        instance.Position = new Vector2(100, 100);
        AddChild(instance);

        // 获取子节点
        var label = GetNode<Label>("%UILabel");
        var timer = GetNode<Timer>("Timer");
    }
}
```

### 输入处理

```csharp
using Godot;

public partial class Player : CharacterBody2D
{
    private float speed = 200f;

    public override void _PhysicsProcess(double delta)
    {
        Vector2 velocity = Vector2.Zero;

        // 动作映射（Project Settings → Input Map）
        if (Input.IsActionPressed("ui_right")) velocity.X += 1;
        if (Input.IsActionPressed("ui_left"))  velocity.X -= 1;
        if (Input.IsActionPressed("ui_up"))    velocity.Y -= 1;
        if (Input.IsActionPressed("ui_down")) velocity.Y += 1;

        Velocity = velocity.Normalized() * speed;
        MoveAndSlide();  // 相当于 Unity Rigidbody.MovePosition
    }

    public override void _Input(InputEvent @event)
    {
        // 物理过程外的输入
        if (Input.IsActionJustPressed("ui_accept"))
        {
            GD.Print("Jump!");
        }
    }
}
```

### 信号系统

```csharp
using Godot;

public partial class TimerController : Node
{
    private Timer _timer;

    public override void _Ready()
    {
        _timer = GetNode<Timer>("Timer");
        _timer.Timeout += OnTimerTimeout;
    }

    private void OnTimerTimeout()
    {
        GD.Print("Timer fired!");
    }

    // 发射信号
    [Signal]
    public delegate void HealthDepletedEventHandler();

    private void DealDamage(float damage)
    {
        EmitSignal(SignalName.HealthDepleted);
    }
}
```

### Godot C# 与 GDScript 主要差异

| GDScript | C# | 说明 |
|-----------|----|------|
| =_ready()= | =_Ready()= | 方法首字母大写 |
| =_process(delta)= | =_Process(double delta)= | delta 是 double |
| =_physics_process(delta)= | =_PhysicsProcess(double delta)= | |
| =export= | =[Export]= | 属性标记 |
| =onready= | =GetNode<T>()= | 显式获取节点 |
| =signal= | =[Signal]= | 信号声明 |
| =queue_free()= | =QueueFree()= | 销毁自身 |

### 信号连接（编辑器 vs 代码）

```csharp
// 代码中连接
_timer.Timeout += OnTimerTimeout;

// 带参数
_timer.Timeout += (sender) => GD.Print("Timed out!");
```

### 导出属性

```csharp
using Godot;

public partial class ExportExample : Node
{
    [Export]
    public int Level { get; set; } = 1;

    [ExportGroup("Combat")]
    [Export]
    private float damage = 10f;

    [ExportRange(0, 100)]
    public float Health { get; set; } = 100f;
}
```

### Godot 4.x 当前限制

- Android / iOS / Web 平台暂不支持 C# 导出（使用 Godot 3.x）
- C# API 与 GDScript 不完全对称（GDScript 更完整）
- 需要 .NET SDK 单独安装

---

## 引擎对比

| 维度 | Unity | Unreal Engine | Godot |
|------|-------|---------------|-------|
| C# 地位 | 主要语言 | 需 UnrealSharp 插件 | 原生支持（4.x） |
| 语言 | C# | C++ / Blueprint | GDScript / C# / GDNative |
| 学习曲线 | 平缓 | 陡峭 | 平缓 |
| 脚本基类 | =MonoBehaviour= | =AActor= / =UObject= | 继承 =Node= |
| 生命周期 | Start/Update | BeginPlay/Tick | _Ready/_Process |
| 渲染管线 | 内置 | Nanite / Lumen | 内置（Forward+） |
| 适用规模 | 轻中量级 | 3A / 影视 | 轻中量级 / 独立游戏 |
| 开源 | 否 | 部分开源 | 完整开源 |
| 平台支持 | 全平台 | PC/主机为主 | 全平台（4.x C# 有限） |

## 参考资源

- Unity 文档：https://docs.unity3d.com/cn/2022.3/manual/index.html
- Unreal 文档：https://dev.epicgames.com/documentation/en-US/unreal-engine
- UnrealSharp：https://unrealsharp.github.io/
- Godot C#：https://docs.godotengine.org/en/stable/tutorials/scripting/c_sharp/index.html
