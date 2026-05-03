Data-Serialization-Format

JSON5/JSONC
```jsonc
{
  // 单行注释
  "name": "app",
  "version": "1.0.0",          // 尾随逗号合法
  "flags": 0x1F,               // 十六进制数（JSON5）
  'author': 'json5',            // 单引号字符串（JSON5）
  features: ['a', 'b',],       // 未引用键 + 尾随逗号（JSON5）
  "desc": "line1\
line2",                      // 多行字符串（JSON5）
  "arr": [1, 2, 3],
  "obj": {"key": "value"},
  bool: true,                  // 未引用布尔值（JSON5）
  empty: null
}
/* 多行
   注释 */
```
- JSON: 严格，双引号键/值，无注释，无尾随逗号
- JSON5: 单/双引号键，注释，尾随逗号，十六进制/二进制数，多行字符串
- JSONC: 仅添加 `//` `/* */` 注释，不支持单引号/未引用键

EDN
```edn
; 注释以分号开头
nil                                    ; 空值
true  false                            ; 布尔值
"string"                               ; 双引号字符串
\g \newline \space \tab               ; 字符（\uNNNN）
:keyword :namespace/name              ; 关键字（以:开头）
symbol namespace/symbol                ; 符号（标识符）
(1 2 "three")                         ; 列表（有序）
[1 2 "three"]                         ; 向量（随机访问）
#{"a" :b 3}                           ; 集合（唯一元素）
{:k "v" :a 1}                         ; 映射（键值对，可嵌套）
#inst "1985-04-12T23:20:50.52Z"      ; 时间戳
#uuid "f81d4fae-7dec-11d0-a765-00a0c91e6bf6"
#MyApp/MenuItem {:name "eggs" :rating 10}  ; 扩展标签
#_ :discarded                          ; 丢弃标记（跳过元素）
```
- 元素由空白/逗号分隔，`{ } ( ) [ ]` 可紧邻
- `#` 开头为保留字符：`#{`集合 `#_`丢弃 `#tag`扩展

TOML
```toml
# 注释
title = "TOML Example"

[owner]                              ; 表（节）
name = "Tom Preston-Werner"
dob = 1979-05-27T07:32:00-08:00

[database]
enabled = true
ports = [8000, 8001, 8002]           ; 数组
data = [["delta", "phi"], [3.14]]    ; 嵌套数组
temp_targets = {cpu = 79.5, case = 72.0}  ; 内联表

[[servers]]                          ; 表数组
[servers.alpha]
ip = "10.0.0.1"
role = "frontend"

[servers.beta]
ip = "10.0.0.2"
role = "backend"

# 字符串
str1 = "I'm a string"
str2 = "Line1\nLine2"
path = 'C:\path\to\file'            ; 字面量字符串（无转义）
regex = '<\i\c*\s*>'
multi = '''
原始字符串
保留空白'''
```
- 键=值对，`[table]` 定义表，`[[array]]` 表数组
- 四种字符串：基本/多行基本/字面量/多行字面量
- 支持整数/浮点/十六进制/八进制/二进制，`inf` `nan`

YAML/YML
```yaml
# 基本键值对
name: John Doe
age: 30
bool: true           # 或 yes/on  false/no/off
num: 3.14
nothing: null        # 或 ~

# 缩进表示层级（空格，禁用Tab）
parent:
  child: value
  nested:
    deep: true

# 列表（- 列表项）
fruits:
  - Apple
  - Banana
  - Orange

# 内联列表/映射
colors: [red, green, blue]
point: {x: 1, y: 2}

# 多行字符串
desc: |
  保留换行
  第二行
summary: >
  折叠为
  单行空格

# 锚点与别名
defaults: &defaults
  timeout: 10
  retries: 3
service:
  <<: *defaults
  port: 8080

# 标签（显式类型）
date: !!timestamp 2023-10-01
```

XML
```xml
<?xml version="1.0" encoding="UTF-8"?>
<!-- XML声明与注释 -->
<root>
  <person id="1">
    <name>张三</name>
    <age>30</age>
    <married/>                    <!-- 空元素，可自闭合 -->
  </person>

  <!-- CDATA: 原始字符数据，不解析标记 -->
  <script><![CDATA[
    function test() {
      return a < b && c > d;
    }
  ]]></script>

  <!-- 实体引用 -->
  <info>Tom &amp; Jerry &lt;3&gt;</info>

  <!-- 属性 -->
  <product id="p1" category="electronics">
    <name price="199.99">鼠标</name>
  </product>

  <!-- 命名空间 -->
  <web:html xmlns:web="http://www.w3.org/1999/xhtml">
    <web:body>Hello</web:body>
  </web:html>

  <!-- 处理指令 -->
  <?xml-stylesheet type="text/xsl" href="style.xsl"?>
</root>
```
- 声明: `<?xml version="1.0" encoding="UTF-8"?>`
- 元素: `<tag></tag>` 或 `<tag/>`，属性 `key="value"`
- 注释: `<!-- -->`，不能嵌套，不能在声明前
- CDATA: `<![CDATA[ ]]>` 原始字符，不解析 `<>&`
- 实体: `&lt;` `&gt;` `&amp;` `&quot;` `&apos;`
- 命名空间: `xmlns:prefix="uri"`

TSV/CSV

ini

MessagePack

Protobuf

Parquet



## translator tools

CAT

OmegaT

memoQ xml

poedit .po

potext

SDL trados

YiCAT

Memsource Cloud



DocTranslator

DocuTranslator
