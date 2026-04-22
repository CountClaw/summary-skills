# Summary Skills

一个围绕“总结各类内容”构建的中文方法论文档库，同时提供可直接给 Codex 使用的 `summarize-anything` skill。

这个仓库解决两件事：

1. 把常见总结方法整理成可查阅、可对比的中文文档。
2. 把这些方法进一步压缩成一个可执行的通用 skill，让模型在不同输入下自动选法并输出结构化总结。

## 仓库包含什么

- `18` 个国内外经典总结/复盘/学习方法文档
- `1` 个综合方法：`PRISM` 棱镜总结法
- `1` 个可复用 skill：`summarize-anything`

适用内容包括：

- 文章、报告、会议记录、访谈整理
- 书籍、课程、知识卡片、学习笔记
- 项目复盘、周报月报、年终总结
- 个人反思、事件回顾、故事剧情总结

## 快速入口

- 方法总览：[docs/方法总览对比.md](./docs/方法总览对比.md)
- 综合框架：[docs/棱镜总结法PRISM.md](./docs/棱镜总结法PRISM.md)
- Skill 主文件：[summarize-anything/SKILL.md](./summarize-anything/SKILL.md)
- 方法映射：[summarize-anything/references/method-map.md](./summarize-anything/references/method-map.md)
- 输出模板：[summarize-anything/references/output-templates.md](./summarize-anything/references/output-templates.md)

## 仓库结构

```text
summary-skills/
├─ install.ps1
├─ install.sh
├─ uninstall.ps1
├─ uninstall.sh
├─ docs/
│  ├─ 国内/
│  ├─ 国外/
│  ├─ 方法总览对比.md
│  └─ 棱镜总结法PRISM.md
└─ summarize-anything/
   ├─ SKILL.md
   ├─ agents/openai.yaml
   └─ references/
      ├─ method-map.md
      ├─ output-templates.md
      └─ source-index.md
```

## summarize-anything 是什么

`summarize-anything` 是一个面向“总结任务”的通用 skill。它不会把所有方法都堆上去，而是先判断输入类型、输出目标和读者，再自动选择更合适的方法，例如：

- 信息提取：`5W1H`、`SAAC`
- 一句话压缩：`GIST`
- 故事剧情：`SWBST`
- 经历和成果表达：`STAR`
- 周报和轻量复盘：`KPT`、`3-2-1`
- 项目复盘：`AAR`、`PRISM-FACT`
- 深度反思：`Gibbs`
- 学习沉淀：`渐进式总结`、`费曼技巧`

默认情况下，如果用户没有指定方法，它会使用 `PRISM` 作为兜底总框架。

## 如何使用

### 1. 作为方法论文档库使用

从 [docs/方法总览对比.md](./docs/方法总览对比.md) 开始，根据场景查找适合的方法，再进入对应文档细读。

推荐顺序：

1. 先看总览，理解不同方法的适用场景、复杂度和时间成本。
2. 再看单篇方法文档，获取具体结构和模板。
3. 最后看 [docs/棱镜总结法PRISM.md](./docs/棱镜总结法PRISM.md)，理解如何把多种方法融合成统一流程。

### 2. 作为 Codex skill 使用

现在仓库已经支持一键安装到 Codex 的标准 skill 目录。

安装脚本默认会扫描并安装仓库内所有顶层 skill 目录；当前仓库会安装 `summarize-anything`。

Windows PowerShell：

```powershell
powershell -ExecutionPolicy Bypass -File .\install.ps1
```

macOS / Linux：

```bash
bash ./install.sh
```

默认安装位置：

- 如果设置了 `CODEX_HOME`，安装到 `$CODEX_HOME/skills`
- 否则安装到 `~/.codex/skills`

可选参数：

- `-Skill summarize-anything` 或 `--skill summarize-anything`：只安装单个 skill
- `-TargetRoot <path>` 或 `--target-root <path>`：安装到自定义目录
- `-Mode link` 或 `--mode link`：使用符号链接，便于开发时实时同步

说明：

- `link` 模式在 Windows 上可能需要开发者模式或更高权限；失败时改用默认的 `copy` 模式即可。

卸载命令：

```powershell
powershell -ExecutionPolicy Bypass -File .\uninstall.ps1
```

```bash
bash ./uninstall.sh
```

如果你的环境支持显式引用本地 skill，可以直接在任务中使用：

```text
Use $summarize-anything at ./summarize-anything 帮我把这份会议记录整理成纪要和行动项。
```

也可以让模型参考 skill 中的映射与模板手动执行：

- 选法参考：[summarize-anything/references/method-map.md](./summarize-anything/references/method-map.md)
- 模板参考：[summarize-anything/references/output-templates.md](./summarize-anything/references/output-templates.md)

## 示例请求

```text
帮我把这篇文章总结成一句话和 5 个要点。
```

```text
帮我把这段项目记录整理成复盘，给出问题、根因和下一步行动。
```

```text
读完这本书后，帮我做一份可归档的读书笔记，并给出一句话金句。
```

```text
把这段电影剧情按故事线讲清楚，不要写成影评。
```

## 设计原则

- 中文优先：文档、术语、模板均以中文表达为主。
- 场景驱动：先判断任务，再选择方法，而不是反过来。
- 结构化输出：尽量产出可复用、可归档、可行动的总结。
- 渐进式复用：文档用于学习方法，skill 用于把方法落成执行策略。

## 维护建议

新增或修改方法论时，建议同步更新以下文件：

- [docs/方法总览对比.md](./docs/方法总览对比.md)
- [summarize-anything/references/method-map.md](./summarize-anything/references/method-map.md)
- [summarize-anything/references/source-index.md](./summarize-anything/references/source-index.md)

如果新增的方法会影响默认选法或输出结构，也应同步调整 [summarize-anything/SKILL.md](./summarize-anything/SKILL.md)。
