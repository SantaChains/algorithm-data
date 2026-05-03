1. 代码重构（日常说的重构）
英文：Code Refactoring
简称直接说 Refactoring
含义：不改变程序功能，只改代码结构、命名、抽取函数、解耦、简化逻辑
特征：对外行为不变，内部代码变好看、好维护
场景：抽方法、改变量名、合并条件、拆大类
2. 架构重构
英文：Architectural Refactoring / Architecture Rework
含义：改整体分层、模块划分、微服务拆分、目录结构、依赖关系
比普通代码重构粒度大，动整体骨架
3. 完全重写 / 推倒重做
英文：Rewrite / Full Rewrite
⚠️ 注意：Rewrite ≠ Refactoring
Refactoring：增量、小步、不改功能
Rewrite：放弃旧代码，从头重新写一版，逻辑甚至功能都可以重做
中文常混叫「重构」，英文必须严格区分
4. 大规模重构 / 演进式重构
英文：Major Refactoring / Evolutionary Refactoring
介于小重构和全量重写之间
分批、渐进式改造，不一次性推倒
5. 数据库重构
英文：Database Refactoring
不改业务逻辑，只改表结构、字段、索引、约束、拆分表
保证数据向后兼容、业务不停服
