//===============================================================================
//  毕业答辩幻灯片 Typst 模板
//  基于 Thesis-Slides、nudtKeynote、北航软院等优秀 Beamer 模板学习整合
//  适配本硕博毕业答辩，支持中英文双语
//===============================================================================

//-----------------------------------------------------------------------------
//  全局样式配置
//-----------------------------------------------------------------------------
#let accent-blue = rgb("#2C3E50")
#let accent-teal = rgb("#1ABC9C")
#let accent-light = rgb("#3498DB")
#let text-dark = rgb("#2C3E50")
#let text-gray = rgb("#7F8C8D")
#let bg-white = rgb("#FFFFFF")
#let bg-light = rgb("#F8F9FA")
#let bg-blue-light = rgb("#EBF5FB")

#let main-font = ("Source Han Sans SC", "Microsoft YaHei", "SimHei", "Arial", sans-serif)
#let math-font = ("Times New Roman", "STIX Two Math", serif)
#let code-font = ("JetBrains Mono", "Fira Code", "Consolas", monospace)

//-----------------------------------------------------------------------------
//  幻灯片尺寸：16:9 标准答辩比例
//-----------------------------------------------------------------------------
#let slide-width = 12cm
#let slide-height = 6.75cm

//-----------------------------------------------------------------------------
//  工具函数
//-----------------------------------------------------------------------------
#let make-title-slide(
  school-name: "XX 大学",
  department: "XX 学院",
  title: "毕业论文题目",
  subtitle: "—— 副标题（可选）",
  author: "答辩人姓名",
  student-id: "XXXXXXXXXX",
  supervisor: "指导教师",
  supervisor-title: "教授",
  date: "2026 年 X 月",
) = {
  // 封面页
  v(0.8cm)
  align(center)[
    #image("assets/university-logo.png", width: 2.5cm)
    #v(0.3cm)
    #text(accent-blue, 14pt, weight: "bold", font: main-font)[
      #school-name #h(1em) #department
    ]
  ]

  v(0.6cm)
  align(center)[
    #box(
      fill: accent-blue,
      inset: (x: 0.4cm, y: 0.15cm),
      radius: 3pt
    )[
      #text(white, 16pt, weight: "bold", font: main-font)[毕 业 论 文 答 辩]
    ]
  ]

  v(0.5cm)
  align(center)[
    #text(text-dark, 20pt, weight: "bold", font: main-font)[#title]
    if subtitle != "" [
      #v(0.2cm)
      #text(text-gray, 14pt, font: main-font)[#subtitle]
    ]
  ]

  v(0.8cm)
  align(center)[
    #table(
      columns: (auto, auto),
      inset: (x: 0.3cm, y: 0.12cm),
      stroke: none,
      align: (col, row) => (
        if col == 0 { right } else { left }
      ),
      [
        #text(text-dark, 12pt, font: main-font)[答辩人：],
        #text(text-dark, 12pt, font: main-font)[#author],
        #text(text-dark, 12pt, font: main-font)[学号：],
        #text(text-dark, 12pt, font: main-font)[#student-id],
        #text(text-dark, 12pt, font: main-font)[指导教师：],
        #text(text-dark, 12pt, font: main-font)[#supervisor #h(0.3em) #supervisor-title],
      ]
    )
  ]

  v(0.5cm)
  align(center)[
    #text(text-gray, 11pt, font: main-font)[#date]
  ]
}

#let make-section-slide(
  section-num: "01",
  section-title: "研究背景",
  section-subtitle: "Research Background",
) = {
  // 章节过渡页
  v(1.5cm)
  align(center)[
    #text(accent-teal, 48pt, weight: "bold", font: main-font)[#section-num]
  ]
  v(0.3cm)
  align(center)[
    #text(accent-blue, 28pt, weight: "bold", font: main-font)[#section-title]
  ]
  v(0.2cm)
  align(center)[
    #text(text-gray, 14pt, font: main-font)[#section-subtitle]
  ]
  v(1cm)
  align(center)[
    #line(length: 4cm, stroke: (color: accent-teal, thickness: 2pt))
  ]
}

#let make-content-slide(
  title: "页面标题",
  content: (),
  footer: none,
) = {
  // 普通内容页
  v(0.3cm)
  align(left)[
    #box(
      fill: accent-blue,
      inset: (x: 0.15cm, y: 0.08cm),
      radius: 2pt
    )[
      #text(white, 16pt, weight: "bold", font: main-font)[#title]
    ]
  ]

  v(0.25cm)

  for item in content {
    if type(item) == "component" {
      item
    } else if type(item) == "array" {
      for subitem in item {
        subitem
      }
    }
  }

  if footer != none {
    v(0.3cm)
    align(right)[
      #text(text-gray, 9pt, font: main-font)[#footer]
    ]
  }
}

#let bullet-item(
  text: "",
  level: 1,
  marker-color: accent-teal,
) = {
  let marker = if level == 1 { "●" } else { "○" }
  let indent = if level == 1 { 0em } else { 0.8em }

  align(
    left,
    horizon,
    gap: 0.5em,
    box(
      baseline: 0.15em,
      width: 0.6em,
      align(center, text(marker-color, 10pt, font: main-font)[#marker])
    ),
    text(text-dark, 11pt, font: main-font)[#text]
  )
  v(0.12cm)
}

#let numbered-item(
  num: "1",
  text: "",
  color: accent-blue,
) = {
  align(
    left,
    horizon,
    gap: 0.5em,
    box(
      fill: color,
      inset: (x: 0.2em, y: 0.05em),
      radius: 2pt,
      width: 0.7em,
      align(center, text(white, 9pt, weight: "bold", font: main-font)[#num])
    ),
    text(text-dark, 11pt, font: main-font)[#text]
  )
  v(0.12cm)
}

#let highlight-box(
  text: "",
  bg-color: bg-blue-light,
  border-color: accent-light,
) = {
  box(
    fill: bg-color,
    inset: (x: 0.3cm, y: 0.15cm),
    radius: 3pt,
    stroke: (left: (color: border-color, thickness: 3pt))
  )[
    #text(text-dark, 10.5pt, font: main-font)[#text]
  ]
}

#let code-block(
  code: "",
  language: "python",
) = {
  box(
    fill: rgb("#F5F5F5"),
    inset: (x: 0.25cm, y: 0.15cm),
    radius: 3pt,
    stroke: (color: rgb("#E0E0E0"), thickness: 0.5pt)
  )[
    #text(rgb("#2C2C2C"), 9pt, font: code-font)[
      #raw(code, lang: language)
    ]
  ]
}

#let two-column-layout(
  left-content: (),
  right-content: (),
  ratio: (1, 1),
) = {
  grid(
    columns: (ratio.at(0)fr, ratio.at(1)fr),
    column-gutter: 0.4cm,
    row-gutter: 0cm,
    ..left-content,
    ..right-content,
  )
}

#let image-with-caption(
  img-path: "",
  caption: "",
  width: 6cm,
) = {
  align(center)[
    #image(img-path, width: width)
    #v(0.1cm)
    #text(text-gray, 9pt, font: main-font)[#caption]
  ]
}

//-----------------------------------------------------------------------------
//  文档开始
//-----------------------------------------------------------------------------
#set page(
  paper: ("16cm", "9cm"),
  margin: (x: 0.8cm, y: 0.5cm),
  background: none,
)

#show: make-title-slide(
  school-name: "南京大学",
  department: "计算机科学与技术系",
  title: "基于深度学习的图像分割算法研究",
  subtitle: "—— 以医学影像为例",
  author: "张三",
  student-id: "2024101234",
  supervisor: "李四",
  supervisor-title: "教授",
  date: "2026 年 5 月",
)

//-----------------------------------------------------------------------------

// 目录页
#pagebreak()
#v(0.3cm)
#align(center)[
  #box(
    fill: accent-blue,
    inset: (x: 0.4cm, y: 0.12cm),
    radius: 3pt
  )[
    #text(white, 16pt, weight: "bold", font: main-font)[目 录]
  ]
]
#v(0.4cm)

#let toc-items = (
  ("01", "研究背景与意义", "Research Background"),
  ("02", "国内外研究现状", "Literature Review"),
  ("03", "研究目标与内容", "Research Objectives"),
  ("04", "研究方法与技术路线", "Methodology"),
  ("05", "实验结果与分析", "Results & Analysis"),
  ("06", "创新点与贡献", "Contributions"),
  ("07", "结论与展望", "Conclusion"),
)

#for item in toc-items [
  #align(
    left,
    horizon,
    gap: 0.5cm,
    box(
      baseline: 0.15em,
      width: 0.9cm,
      align(center, text(accent-teal, 14pt, weight: "bold", font: main-font)[#item.at(0)])
    ),
    text(accent-blue, 13pt, weight: "medium", font: main-font)[#item.at(1)  ],
    text(text-gray, 10pt, font: main-font)[#item.at(2)],
  )
  #v(0.35cm)
]

//-----------------------------------------------------------------------------

// 第一章：研究背景与意义
#pagebreak()
#make-section-slide(
  section-num: "01",
  section-title: "研究背景与意义",
  section-subtitle: "Research Background & Significance",
)

// 1.1 研究背景
#pagebreak()
#make-content-slide(
  title: "1.1 研究背景",
  footer: [研究背景与意义],
  content: (
    bullet-item(text: "医学影像诊断是临床疾病筛查与诊断的重要依据", level: 1),
    bullet-item(text: "深度学习技术的快速发展为医学影像分析带来了新的机遇", level: 1),
    bullet-item(text: "传统图像分割方法依赖人工特征提取，难以处理复杂场景", level: 1),
    v(0.2cm),
    highlight-box(
      text: [研究问题：如何利用深度学习技术提高医学影像分割的精度与效率？]
    ),
  )
)

// 1.2 研究意义
#pagebreak()
#make-content-slide(
  title: "1.2 研究意义",
  footer: [研究背景与意义],
  content: (
    (
      two-column-layout(
        left-content: (
          align(center)[
            #box(
              fill: accent-blue,
              width: 4.5cm,
              inset: 0.15cm,
              radius: 3pt
            )[
              #text(white, 12pt, weight: "bold", font: main-font)[理论意义]
            ]
            #v(0.15cm)
            #bullet-item(text: "丰富深度学习在医学影像领域的理论研究", level: 1),
            #bullet-item(text: "为多模态医学影像融合提供新思路", level: 1),
            #bullet-item(text: "推动图像分割理论的发展与完善", level: 1),
          ]
        ),
        right-content: (
          align(center)[
            #box(
              fill: accent-teal,
              width: 4.5cm,
              inset: 0.15cm,
              radius: 3pt
            )[
              #text(white, 12pt, weight: "bold", font: main-font)[实践意义]
            ]
            #v(0.15cm)
            #bullet-item(text: "提高医学影像诊断的准确性与效率", level: 1),
            #bullet-item(text: "辅助医生进行疾病筛查与定位", level: 1),
            #bullet-item(text: "降低医疗成本，提升基层医疗服务水平", level: 1),
          ]
        ),
        ratio: (1, 1),
      )
    ),
  )
)

//-----------------------------------------------------------------------------

// 第二章：国内外研究现状
#pagebreak()
#make-section-slide(
  section-num: "02",
  section-title: "国内外研究现状",
  section-subtitle: "Literature Review",
)

// 2.1 传统图像分割方法
#pagebreak()
#make-content-slide(
  title: "2.1 传统图像分割方法",
  footer: [国内外研究现状],
  content: (
    bullet-item(text: "基于阈值的分割：Otsu 方法、最大熵方法", level: 1),
    bullet-item(text: "基于区域的分割：分水岭算法、区域生长法", level: 1),
    bullet-item(text: "基于边缘的分割：Canny 算子、Sobel 算子", level: 1),
    bullet-item(text: "基于图论的分割：Graph Cut、Grab Cut", level: 1),
    v(0.2cm),
    highlight-box(
      text: [存在问题：依赖人工设计特征，难以适应复杂多变的医学影像场景]
    ),
  )
)

// 2.2 深度学习图像分割
#pagebreak()
#make-content-slide(
  title: "2.2 深度学习图像分割方法",
  footer: [国内外研究现状],
  content: (
    bullet-item(text: "FCN（Fully Convolutional Network）：首次实现端到端像素级分类", level: 1),
    bullet-item(text: "U-Net：采用编码器-解码器结构，广泛应用于医学影像", level: 1),
    bullet-item(text: "DeepLab 系列：空洞卷积 + 条件随机场（CRF）", level: 1),
    bullet-item(text: "Mask R-CNN：实例分割 + 目标检测框架", level: 1),
    v(0.2cm),
    image-with-caption(
      img-path: "assets/unet-structure.png",
      caption: [U-Net 网络结构示意图],
      width: 8cm
    ),
  )
)

//-----------------------------------------------------------------------------

// 第三章：研究目标与内容
#pagebreak()
#make-section-slide(
  section-num: "03",
  section-title: "研究目标与内容",
  section-subtitle: "Research Objectives & Contents",
)

// 3.1 研究目标
#pagebreak()
#make-content-slide(
  title: "3.1 研究目标",
  footer: [研究目标与内容],
  content: (
    numbered-item(num: "1", text: "设计轻量级高精度的医学影像分割网络，兼顾推理速度与分割精度"),
    numbered-item(num: "2", text: "提出多尺度特征融合模块，增强模型对不同尺度目标的感知能力"),
    numbered-item(num: "3", text: "构建半监督学习框架，利用少量标注数据实现高效模型训练"),
    numbered-item(num: "4", text: "开发医学影像分割原型系统，验证方法在实际场景中的有效性"),
  )
)

// 3.2 研究内容
#pagebreak()
#make-content-slide(
  title: "3.2 主要研究内容",
  footer: [研究目标与内容],
  content: (
    highlight-box(
      text: [
        #text(accent-blue, 11pt, weight: "bold")[研究内容一：] 轻量化网络设计
      ]
    ),
    v(0.1cm),
    bullet-item(text: "基于深度可分离卷积与注意力机制构建轻量级骨干网络", level: 2),
    v(0.15cm),
    highlight-box(
      text: [
        #text(accent-blue, 11pt, weight: "bold")[研究内容二：] 多尺度特征融合
      ]
    ),
    v(0.1cm),
    bullet-item(text: "设计金字塔池化模块与跨层级特征融合策略", level: 2),
    v(0.15cm),
    highlight-box(
      text: [
        #text(accent-blue, 11pt, weight: "bold")[研究内容三：] 半监督学习框架
      ]
    ),
    v(0.1cm),
    bullet-item(text: "利用未标注数据辅助训练，提升模型泛化能力", level: 2),
  )
)

//-----------------------------------------------------------------------------

// 第四章：研究方法与技术路线
#pagebreak()
#make-section-slide(
  section-num: "04",
  section-title: "研究方法与技术路线",
  section-subtitle: "Methodology & Technical Route",
)

// 4.1 整体技术框架
#pagebreak()
#make-content-slide(
  title: "4.1 整体技术框架",
  footer: [研究方法与技术路线],
  content: (
    image-with-caption(
      img-path: "assets/framework.png",
      caption: [整体研究技术路线图],
      width: 10cm
    ),
  )
)

// 4.2 核心算法
#pagebreak()
#make-content-slide(
  title: "4.2 核心算法：轻量化分割网络",
  footer: [研究方法与技术路线],
  content: (
    two-column-layout(
      left-content: (
        align(center)[
          #text(accent-blue, 11pt, weight: "bold", font: main-font)[网络架构]
        ],
        v(0.15cm),
        code-block(
          code: [
            class LightUNet(nn.Module):
                def __init__(self):
                    self.enc = Encoder()
                    self.dec = Decoder()
                    self.attention = CBAM()

                def forward(self, x):
                    f = self.enc(x)
                    f = self.attention(f)
                    return self.dec(f)
          ],
          language: "python"
        ),
      ),
      right-content: (
        align(center)[
          #text(accent-blue, 11pt, weight: "bold", font: main-font)[损失函数]
        ],
        v(0.15cm),
        code-block(
          code: [
            L = L_dice + λ * L_ce
                  + β * L_attention

            L_dice = 1 - 2|G∩P|/|G|+|P|
          ],
          language: "python"
        ),
      ),
      ratio: (1, 1),
    ),
  )
)

// 4.3 实验数据
#pagebreak()
#make-content-slide(
  title: "4.3 实验数据集",
  footer: [研究方法与技术路线],
  content: (
    align(center)[
      #table(
        columns: (2cm, 2.5cm, 2cm, 2cm, 2cm),
        align: center + horizon,
        stroke: (color: rgb("#E0E0E0"), thickness: 0.5pt),
        table.header[
          #text(accent-blue, 10pt, weight: "bold")[数据集]
          #text(accent-blue, 10pt, weight: "bold")[模态]
          #text(accent-blue, 10pt, weight: "bold")[图像数]
          #text(accent-blue, 10pt, weight: "bold")[训练集]
          #text(accent-blue, 10pt, weight: "bold")[测试集]
        ],
        [ISIC 2018], [皮肤镜], [2594], [2000], [594],
        [LiTS 2017], [CT], [131], [100], [31],
        [ACDC], [MRI], [200], [160], [40],
      )
    ],
    v(0.3cm),
    highlight-box(
      text: [数据增强：随机旋转、翻转、弹性形变、色彩抖动，扩充训练样本 3 倍]
    ),
  )
)

//-----------------------------------------------------------------------------

// 第五章：实验结果与分析
#pagebreak()
#make-section-slide(
  section-num: "05",
  section-title: "实验结果与分析",
  section-subtitle: "Results & Analysis",
)

// 5.1 分割性能对比
#pagebreak()
#make-content-slide(
  title: "5.1 分割性能对比",
  footer: [实验结果与分析],
  content: (
    align(center)[
      #table(
        columns: (2.5cm, 2cm, 2cm, 2cm, 2cm),
        align: center + horizon,
        stroke: (color: rgb("#E0E0E0"), thickness: 0.5pt),
        table.header[
          #text(accent-blue, 10pt, weight: "bold")[方法]
          #text(accent-blue, 10pt, weight: "bold")[Dice ↑]
          #text(accent-blue, 10pt, weight: "bold")[IoU ↑]
          #text(accent-blue, 10pt, weight: "bold")[Prec. ↑]
          #text(accent-blue, 10pt, weight: "bold")[Param. ↓]
        ],
        [U-Net], [0.873], [0.782], [0.891], [31.2M],
        [DeepLabv3+], [0.891], [0.812], [0.903], [54.7M],
        [HRNet], [0.896], [0.823], [0.908], [63.8M],
        [#text(accent-teal, weight: "bold")[ Ours ]], [#text(accent-teal, weight: "bold")[0.921]], [#text(accent-teal, weight: "bold")[0.854]], [#text(accent-teal, weight: "bold")[0.932]], [#text(accent-teal, weight: "bold")[8.6M]],
      )
    ],
    v(0.3cm),
    highlight-box(
      text: [与最优基线方法相比，本文方法 Dice 提升 2.5pp，参数减少 85%]
    ),
  )
)

// 5.2 可视化结果
#pagebreak()
#make-content-slide(
  title: "5.2 分割结果可视化对比",
  footer: [实验结果与分析],
  content: (
    two-column-layout(
      left-content: (
        image-with-caption(
          img-path: "assets/result1.png",
          caption: [U-Net 方法（Dice=0.873）],
          width: 5cm
        ),
        image-with-caption(
          img-path: "assets/result2.png",
          caption: [DeepLabv3+（Dice=0.891）],
          width: 5cm
        ),
      ),
      right-content: (
        image-with-caption(
          img-path: "assets/result3.png",
          caption: [HRNet（Dice=0.896）],
          width: 5cm
        ),
        image-with-caption(
          img-path: "assets/result4.png",
          caption: [本文方法（Dice=0.921）],
          width: 5cm
        ),
      ),
      ratio: (1, 1),
    ),
  )
)

//-----------------------------------------------------------------------------

// 第六章：创新点与贡献
#pagebreak()
#make-section-slide(
  section-num: "06",
  section-title: "创新点与贡献",
  section-subtitle: "Contributions & Innovations",
)

// 6.1 主要创新点
#pagebreak()
#make-content-slide(
  title: "6.1 主要创新点",
  footer: [创新点与贡献],
  content: (
    numbered-item(
      num: "1",
      text: [轻量化网络设计：提出基于深度可分离卷积与通道注意力融合的轻量级分割网络，在保持高精度的同时大幅降低参数量],
      color: accent-blue
    ),
    numbered-item(
      num: "2",
      text: [多尺度特征融合：设计金字塔池化模块与跨层级特征融合策略，有效提升模型对多尺度目标的感知能力],
      color: accent-teal
    ),
    numbered-item(
      num: "3",
      text: [半监督学习框架：构建基于对比学习的半监督分割框架，充分利用未标注数据提升模型泛化性能],
      color: accent-light
    ),
  )
)

//-----------------------------------------------------------------------------

// 第七章：结论与展望
#pagebreak()
#make-section-slide(
  section-num: "07",
  section-title: "结论与展望",
  section-subtitle: "Conclusion & Future Work",
)

// 7.1 研究总结
#pagebreak()
#make-content-slide(
  title: "7.1 研究总结",
  footer: [结论与展望],
  content: (
    bullet-item(text: "针对医学影像分割任务，提出轻量化高精度分割网络 LightUNet", level: 1),
    bullet-item(text: "设计多尺度特征融合模块，显著提升分割精度", level: 1),
    bullet-item(text: "构建半监督学习框架，降低对标注数据的依赖", level: 1),
    bullet-item(text: "在 ISIC、LiTS、ACDC 三个数据集上验证方法有效性", level: 1),
    v(0.3cm),
    align(center)[
      #box(
        fill: accent-blue,
        width: 9cm,
        inset: 0.2cm,
        radius: 3pt
      )[
        #text(white, 12pt, font: main-font)[实验表明：本文方法在 Dice、IoU 等指标上优于现有方法，同时参数量减少 85%]
      ]
    ],
  )
)

// 7.2 未来展望
#pagebreak()
#make-content-slide(
  title: "7.2 未来研究方向",
  footer: [结论与展望],
  content: (
    bullet-item(text: "探索 Transformer 架构在医学影像分割中的应用", level: 1),
    bullet-item(text: "研究 3D 医学影像的端到端分割方法", level: 1),
    bullet-item(text: "结合联邦学习实现多中心医疗数据的隐私保护训练", level: 1),
    bullet-item(text: "扩展方法到更多临床应用场景（如手术导航、疗效评估）", level: 1),
    v(0.3cm),
    highlight-box(
      text: [研究展望：将轻量化思想与最新 Transformer 架构结合，进一步提升模型的实用性与泛化能力]
    ),
  )
)

//-----------------------------------------------------------------------------

// 参考文献
#pagebreak()
#v(0.3cm)
#align(center)[
  #box(
    fill: accent-blue,
    inset: (x: 0.4cm, y: 0.12cm),
    radius: 3pt
  )[
    #text(white, 16pt, weight: "bold", font: main-font)[参考文献]
  ]
]
#v(0.4cm)

#let refs = (
  "[1] Ronneberger O, Fischer P, Brox T. U-Net: Convolutional Networks for Biomedical Image Segmentation[C]. MICCAI, 2015: 234-241.",
  "[2] Chen L C, Papandreou G, Schroff F, et al. Rethinking Atrous Convolution for Semantic Image Segmentation[J]. arXiv, 2017.",
  "[3] He K, Gkioxari G, Dollar P, et al. Mask R-CNN[J]. IEEE TPAMI, 2020, 42(2): 386-397.",
  "[4] Li X, Sun X, Dong J, et al. Lightweight Medical Image Segmentation Network with Attention Mechanism[J]. IEEE TMI, 2024.",
)

#for ref in refs [
  #text(text-dark, 9pt, font: main-font)[#ref]
  #v(0.15cm)
]

//-----------------------------------------------------------------------------

// 致谢
#pagebreak()
#v(1.5cm)
align(center)[
  #text(accent-blue, 32pt, weight: "bold", font: main-font)[致 谢]
]
#v(0.5cm)
align(center)[
  #text(text-gray, 14pt, font: main-font)[Thank You for Your Attention]
]
#v(1cm)
align(center)[
  #line(length: 5cm, stroke: (color: accent-teal, thickness: 2pt))
]
#v(1cm)

#align(center)[
  #text(text-dark, 12pt, font: main-font)[感谢各位评审老师的宝贵意见与建议]
]
#v(0.3cm)
#align(center)[
  #text(text-dark, 12pt, font: main-font)[感谢指导教师 #h(0.3em) 李四 #h(0.3em) 教授的悉心指导]
]
#v(0.3cm)
#align(center)[
  #text(text-dark, 12pt, font: main-font)[感谢实验室同门的支持与帮助]
]
#v(0.3cm)
#align(center)[
  #text(text-dark, 12pt, font: main-font)[感谢家人的理解与鼓励]
]

//-----------------------------------------------------------------------------

// Q&A
#pagebreak()
#v(2cm)
align(center)[
  #box(
    fill: accent-blue,
    width: 6cm,
    inset: 0.3cm,
    radius: 5pt
  )[
    #text(white, 28pt, weight: "bold", font: main-font)[问答环节]
  ]
]
#v(0.5cm)
align(center)[
  #text(text-gray, 16pt, font: main-font)[Questions & Answers]
]
#v(1.5cm)
align(center)[
  #text(accent-teal, 18pt, weight: "bold", font: main-font)[敬请各位老师批评指正]
]

//===============================================================================
//  模板说明：
//  本模板基于 Typst 编写，适用于高校毕业答辩幻灯片制作
//  配色方案：主色 #2C3E50（深蓝），强调色 #1ABC9C（青绿）
//  字体：中文使用思源黑体/微软雅黑，英文使用 Arial/Times New Roman
//  使用方法：
//    1. 替换封面信息（学校、姓名、题目等）
//    2. 根据实际内容修改各章节文字与图片
//    3. 补充参考文献与致谢内容
//    4. 使用 typst compile 命令编译生成 PDF
//===============================================================================