$ErrorActionPreference = 'Stop'
$taskRoot = $PSScriptRoot
$original = Get-Content -LiteralPath (Join-Path $taskRoot 'strong-projects-profiles.json') -Raw -Encoding UTF8 | ConvertFrom-Json
$revisions = Get-Content -LiteralPath (Join-Path $taskRoot 'project-detail-revisions.json') -Raw -Encoding UTF8 | ConvertFrom-Json
$replacementById = @{}
foreach ($profile in $revisions.profiles) { $replacementById[$profile.id] = $profile }
$merged = [System.Collections.Generic.List[object]]::new()
foreach ($profile in $original.profiles) {
    if ($replacementById.ContainsKey($profile.id)) { $merged.Add($replacementById[$profile.id]); $replacementById.Remove($profile.id) }
    else { $merged.Add($profile) }
}
foreach ($profile in $revisions.profiles) {
    if ($replacementById.ContainsKey($profile.id)) { $merged.Add($profile); $replacementById.Remove($profile.id) }
}
$report = [ordered]@{ date = $revisions.date; scope = $revisions.scope; evidenceNote = $revisions.evidenceNote; profiles = @($merged.ToArray()) }
$report | ConvertTo-Json -Depth 12 | Set-Content -LiteralPath (Join-Path $taskRoot 'strong-projects-profiles.json') -Encoding UTF8
$core = @($report.profiles | Where-Object group -eq '核心强相关')
$adjacent = @($report.profiles | Where-Object group -eq '补充关联')
if ($core.Count -ne 26 -or $adjacent.Count -ne 3) { throw 'Unexpected report scope' }
if (@($report.profiles.id | Select-Object -Unique).Count -ne 29) { throw 'Duplicate project IDs' }
function Encode([string]$value) { [System.Net.WebUtility]::HtmlEncode($value) }
$toc = [System.Text.StringBuilder]::new()
$cards = [System.Text.StringBuilder]::new()
$index = 0
foreach ($profile in @($core) + @($adjacent)) {
    $index++
    $name = Encode $profile.name
    $category = Encode $profile.category
    $group = Encode $profile.group
    $url = 'https://gallery.adventure-x.cn/projects/' + $profile.id
    $target = 'project-' + $profile.id
    $search = Encode ($profile.name + ' ' + $profile.category + ' ' + $profile.intro + ' ' + $profile.chain)
    $intro = Encode $profile.intro
    $chain = Encode $profile.chain
    $analysis = Encode $profile.analysis
    $stage = Encode $profile.stage
    $questions = Encode $profile.questions
    $basis = Encode $profile.basis
    [void]$toc.AppendLine("<li class='toc-item' data-group='$group' data-year='$($profile.year)' data-search='$search'><a href='#$target'><span class='num'>$index</span>$name</a><span class='toc-meta'>$($profile.year) · $category</span></li>")
    [void]$cards.AppendLine(@"
<article class='entry' id='$target' data-group='$group' data-year='$($profile.year)' data-search='$search'>
  <div class='entry-meta'><span>$group</span><span>$($profile.year)</span><span>$category</span></div>
  <h2><span class='num'>$index</span>$name</h2>
  <div class='intro'><h3>项目介绍 · 可直接使用</h3><p>$intro</p></div>
  <div class='columns'><section><h3>区块链具体做什么</h3><p>$chain</p></section><section><h3>价值与关键边界 · 本报告分析</h3><p>$analysis</p></section></div>
  <section class='stage'><h3>已完成、演示与规划</h3><p>$stage</p></section>
  <section><h3>进一步核实的重点</h3><p>$questions</p></section>
  <footer><a href='$url' target='_blank' rel='noopener noreferrer'>查看官方项目详情 ↗</a><span>$basis</span></footer>
</article>
"@)
}
$scope = Encode $report.scope
$evidence = Encode $report.evidenceNote
$html = @"
<!doctype html>
<html lang='zh-CN'><head><meta charset='utf-8'><meta name='viewport' content='width=device-width,initial-scale=1'>
<title>AdventureX 区块链强相关项目介绍与分析</title>
<style>
:root{--ink:#172e36;--sub:#53666d;--accent:#116c65;--line:#dce5e1;--paper:#fffefa;--tint:#eef6f2}*{box-sizing:border-box}html{scroll-behavior:smooth}body{margin:0;background:#f3f4ef;color:var(--ink);font:16px/1.85 'Microsoft YaHei','PingFang SC',sans-serif}a{color:var(--accent);text-underline-offset:4px}header{max-width:1180px;margin:45px auto 24px;padding:0 24px}.eyebrow{letter-spacing:2px;color:var(--accent);font-size:13px;font-weight:700}h1{font-size:clamp(28px,4vw,44px);line-height:1.3;margin:14px 0 18px}h2{font-size:25px;line-height:1.45;margin:14px 0 22px}h3{font-size:15px;margin:0 0 8px;color:var(--accent)}p{margin:0 0 14px}.lead{font-size:18px;max-width:950px}.facts{display:flex;gap:10px;flex-wrap:wrap;margin:22px 0}.facts span{background:var(--paper);border:1px solid var(--line);border-radius:12px;padding:8px 15px}.note{font-size:14px;color:var(--sub);border-left:3px solid var(--accent);padding:10px 16px;background:var(--tint)}.summary{max-width:1132px;margin:24px auto;background:var(--paper);padding:26px;border-radius:16px;border:1px solid var(--line)}.summary h2{font-size:21px;margin:0 0 12px}.table-scroll{overflow-x:auto}table{border-collapse:collapse;width:100%;font-size:14px}th,td{padding:12px 10px;text-align:left;border-bottom:1px solid var(--line);vertical-align:top}th{color:var(--accent);background:var(--tint)}.layout{display:grid;grid-template-columns:280px minmax(0,1fr);gap:24px;max-width:1180px;margin:24px auto 60px;padding:0 24px}aside{align-self:start;position:sticky;top:16px;background:var(--paper);border:1px solid var(--line);border-radius:14px;padding:18px;max-height:calc(100vh - 32px);overflow:auto}.controls label{font-size:13px;color:var(--sub);display:block;margin:0 0 4px}.controls input,.controls select{width:100%;padding:9px 10px;border:1px solid #becfc8;border-radius:7px;background:white;color:var(--ink);font:inherit;font-size:14px;margin:0 0 12px}.controls button{border:1px solid var(--line);background:var(--tint);color:var(--accent);padding:8px 12px;border-radius:7px;cursor:pointer;font:inherit;font-size:13px}.count{font-size:13px;color:var(--sub);margin:12px 0}.toc{padding:0;list-style:none;margin:0}.toc li{padding:10px 0;border-bottom:1px solid var(--line);line-height:1.5}.toc a{text-decoration:none;font-size:14px}.toc-meta{display:block;font-size:11px;color:var(--sub);margin-top:3px}.num{font-size:.62em;display:inline-block;vertical-align:middle;background:var(--tint);color:var(--accent);border-radius:6px;padding:2px 7px;margin-right:9px;font-weight:700}.entry{background:var(--paper);border:1px solid var(--line);border-radius:16px;padding:28px;margin-bottom:22px;scroll-margin-top:20px}.entry-meta{display:flex;gap:8px;flex-wrap:wrap;color:var(--sub);font-size:12px}.entry-meta span{border:1px solid var(--line);border-radius:20px;padding:1px 9px}.intro{border-left:3px solid var(--accent);padding-left:17px;margin-bottom:24px}.intro p{font-size:17px}.columns{display:grid;grid-template-columns:1fr 1fr;gap:25px}.stage{background:var(--tint);padding:16px 18px;border-radius:10px;margin:8px 0 20px}.stage p{margin-bottom:0}.entry footer{display:flex;flex-wrap:wrap;gap:6px 16px;border-top:1px solid var(--line);padding-top:14px;font-size:12px;color:var(--sub)}.page-foot{max-width:1132px;margin:0 auto 40px;padding:0 24px;font-size:13px;color:var(--sub)}[hidden]{display:none!important}@media(max-width:850px){.layout{display:block}.summary{margin:20px 24px}aside{position:static;max-height:none;margin-bottom:24px}.toc{max-height:220px;overflow:auto}.columns{grid-template-columns:1fr;gap:0}.entry{padding:22px}header{margin-top:28px}}@media print{body{background:white;font-size:11pt}header{margin:0;padding:0}h1{font-size:26pt}.facts span{padding:4px 10px}.summary{margin:20px 0;padding:14px;border-radius:0}.layout{display:block;padding:0;margin:0}aside{display:none}.entry,.entry[hidden]{display:block!important;border-radius:0;padding:16px;margin:16px 0;break-inside:avoid}.columns{display:block}.entry h2{font-size:17pt}.intro p{font-size:11pt}a{color:var(--ink)}.page-foot{padding:0}.stage{background:#f3f5f4}h2,h3{break-after:avoid}p{orphans:3;widows:3}}
</style></head><body>
<header><div class='eyebrow'>ADVENTUREX GALLERY · 重点项目研究</div><h1>区块链强相关项目<br>介绍与分析</h1><p class='lead'>以链上支付、清算、凭证、治理、资金约束和可核验证据为线索，解释每个项目解决什么问题，以及区块链具体承担什么职责。</p><div class='facts'><span><strong>26</strong> 个强相关项目</span><span><strong>3</strong> 个补充案例</span><span>覆盖 2025 / 2026</span><span>整理日期 2026-10-06</span></div><p>$scope</p><div class='note'>$evidence</div></header>
<section class='summary'><h2>先看哪些项目</h2><p>以下项目展示了不同的业务机制，便于快速理解。顺序不代表排名，也不代表其代码、商业效果或安全性已经验证。</p><div class='table-scroll'><table><thead><tr><th>项目</th><th>核心机制</th><th>公开状态与阅读重点</th></tr></thead><tbody>
<tr><td><a href='#project-cmrz1zd63000002l84fphwjd3'>Makebook</a></td><td>真实出价、统一清算和退款</td><td>测试网批次演示；清算与实物履约需分开。</td></tr>
<tr><td><a href='#project-cmrz7rqhg000a02jls5kjj2k9'>CarryPilot</a></td><td>AI解释、确定性风控、支付与决策回执</td><td>回测和模拟执行；真实自动交易在后续阶段。</td></tr>
<tr><td><a href='#project-cmrzr5zfn000f02l951k0xdqz'>Injenium灵枢</a></td><td>机器人技能购买和任务奖励</td><td>测试网与机器狗演示自述；跨硬件兼容仍需验证。</td></tr>
<tr><td><a href='#project-cmrzu088g000f02l508zbtq5o'>QuakeFeel</a></td><td>签名、隐私聚合、Merkle与链登记</td><td>可本地链演示；不可篡改不等于采集信息真实。</td></tr>
<tr><td><a href='#project-00c74dd1-d2de-4e1c-9f6e-457cd02b191c'>TruthLink</a></td><td>经历凭证、Agent背景核查和服务支付</td><td>详情采用XION及Virtuals ACP；发行者可信度是关键。</td></tr>
<tr><td><a href='#project-cmrzub7hb000702l4olssh4kp'>有份YouFen</a></td><td>贡献记录转为社区治理份额</td><td>Injective EVM测试网；治理份额不自动等于公司股权。</td></tr>
<tr><td><a href='#project-cmrz7trrf000102jkop4nvkm4'>xEngine差分机</a></td><td>事件分析、资金库和可挑战结果结算</td><td>MockUSDC测试网原型；实际对冲和风险定价仍需核实。</td></tr>
<tr><td><a href='#project-cmryut40z000302l5spdhi1a3'>PactLedger</a></td><td>Agent支付意图、权限检查、审批和回执</td><td>尚未完成首笔可核验测试网付款；设计与已运行能力需区分。</td></tr>
</tbody></table></div></section>
<div class='layout'><aside><div class='controls'><label for='search'>搜索项目或机制</label><input id='search' type='search' placeholder='例如：NFT、支付、机器人'><label for='group'>关联范围</label><select id='group'><option value=''>全部29个项目</option><option>核心强相关</option><option>补充关联</option></select><label for='year'>年份</label><select id='year'><option value=''>全部年份</option><option>2026</option><option>2025</option></select><button id='reset' type='button'>重置筛选</button> <button id='print' type='button'>打印 / 保存PDF</button></div><div class='count' id='count' aria-live='polite'>显示29个项目</div><ol class='toc'>$($toc.ToString())</ol></aside><main>$($cards.ToString())<p id='empty' hidden>没有匹配的项目，请调整搜索或筛选。</p></main></div>
<div class='page-foot'>来源：AdventureX Gallery各项目详情（每项附原文链接）。强相关表示项目公开内容明确赋予区块链业务职责，不代表已主网上线。此前候选清单中的技术标签和赛道关联，不自动构成已实现功能。模拟KOL芯片实验室、惊梦和EtaPanel在读取完整机制后调整为强相关；CoinCrush、broken ice与Agentrix单列补充案例。</div>
<script>
const search=document.getElementById('search'),group=document.getElementById('group'),year=document.getElementById('year');
function filter(){const q=search.value.trim().toLocaleLowerCase();let count=0;document.querySelectorAll('.entry,.toc-item').forEach(el=>{const ok=(!q||el.dataset.search.toLocaleLowerCase().includes(q))&&(!group.value||el.dataset.group===group.value)&&(!year.value||el.dataset.year===year.value);el.hidden=!ok;if(ok&&el.classList.contains('entry'))count++;});document.getElementById('count').textContent='显示'+count+'个项目';document.getElementById('empty').hidden=count!==0;}
[search,group,year].forEach(el=>el.addEventListener('input',filter));document.getElementById('reset').addEventListener('click',()=>{search.value='';group.value='';year.value='';filter();});document.getElementById('print').addEventListener('click',()=>window.print());
</script></body></html>
"@
$outputPath = Join-Path $taskRoot 'AdventureX-区块链强相关项目介绍与分析.html'
[System.IO.File]::WriteAllText($outputPath, $html, [System.Text.UTF8Encoding]::new($false))
[pscustomobject]@{ Core = $core.Count; Adjacent = $adjacent.Count; Total = $report.profiles.Count; Output = $outputPath; Bytes = (Get-Item -LiteralPath $outputPath).Length } | ConvertTo-Json -Compress
