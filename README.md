# ETH Wuhan 2026 项目调研与设计

围绕汉客松 S1 & ETH Wuhan 2026 的 GCC 公共物品赛道与 BOT Chain 赛道，整理 AdventureX 区块链项目案例、项目介绍、选题设计及已有工作对照。

**当前阶段：调研与方案设计。此仓库尚未包含可运行的参赛应用、智能合约或主网部署。**

## 内容

| 文件 | 用途 |
| --- | --- |
| [AdventureX-区块链项目清单.html](AdventureX-区块链项目清单.html) | 第一轮区块链相关候选清单 |
| [AdventureX-区块链强相关项目介绍与分析.html](AdventureX-区块链强相关项目介绍与分析.html) | 29 个重点案例：26 个核心强相关项目和 3 个补充关联项目 |
| [docs/项目设计与已有工作审查.md](docs/项目设计与已有工作审查.md) | 修订后的参赛方案、竞品依据及范围 |
| [docs/研究方向全记录.md](docs/研究方向全记录.md) | 四个初版方案、模板映射、修订及撤下原因 |
| [docs/ETH与赛事赛道.md](docs/ETH与赛事赛道.md) | Ethereum/ETH 的区别、设计理念、两个赛道的要求及原始截图 |
| [docs/参考资料索引.md](docs/参考资料索引.md) | AdventureX、GitHub、协议与竞品资料入口 |
| [docs/assets](docs/assets) | 参赛者提供的两份赛道规则截图 |
| [projects-data.json](projects-data.json) | 候选项目结构化资料 |
| [strong-projects-profiles.json](strong-projects-profiles.json) | 重点项目结构化介绍 |
| [project-detail-revisions.json](project-detail-revisions.json) | 项目详情修订资料 |
| [build-profiles-report.ps1](build-profiles-report.ps1) | 生成重点案例 HTML 报告的 PowerShell 脚本 |

## 阅读与生成

下载仓库后，用浏览器打开两个 HTML 文件即可阅读，无需安装依赖。重点案例报告支持搜索与筛选。

使用 PowerShell 7，在仓库目录运行：

```powershell
pwsh -File ./build-profiles-report.ps1
```

脚本会根据结构化资料重新生成重点案例报告，并更新合并后的项目介绍 JSON。

## 当前选题建议

- **GCC 首选：Agent 决策故障归因。** 区分服务违约、跨服务数据不兼容和调用方错误，提供可重放的公共失败记录。
- **GCC 备选：链上结论质检员。** 审查链上异动解释的证据、反例与缺口，公开可复算案例。
- **BOT 首选：合算——先证明值得拼，再共同付款。** 检查算力任务的兼容性和净收益，再执行多买家的资金清算与退款。
- 原“任务保”方案因与已有 Agent 托管协议及 BOT Chain 项目高度重合，撤下原版推荐。

## 资料边界

整理日期：2026-10-06。项目功能、测试及部署情况主要依据项目方公开描述，未独立审计代码或核验全部交易。竞争研究不构成全球原创性证明。

赛道判断依据参赛者提供的规则截图；提交和部署要求须以赛事完整规则及主办方最新通知为准。报告中的分析和建议与项目方原始描述应分别理解。

原始网页缓存、浏览器会话参数及本地凭据不纳入仓库。第三方内容的权利属于原作者；本仓库不对第三方素材授予再许可。
