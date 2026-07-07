---
name: okx-ai-a2a-asp-onboarding
description: Use when a user wants Codex to join OKX.AI, OnchainOS, OKX Agent Marketplace, register or submit an ASP, create an A2A Agent, install okx-a2a, fix "offline/not responding" review failures, keep an Agent online, or start taking OKX.AI tasks. Triggers include OKX.AI, onchainos, Agentic Wallet, ASP, A2A, A2MCP, okx-a2a, XMTP, "上架", "审核", "接单", "不在线".
---

# OKX.AI A2A ASP Onboarding

## Core Rule

Drive the OKX.AI Agent Marketplace flow end to end, but stop for the user before any irreversible or value-bearing action. Install and inspect freely. Ask before wallet signatures, terms acceptance, payments, staking, transfers, task applications, quotes, confirmations, delivery, disputes, or anything that spends or escrows funds.

Never ask for or store a seed phrase or private key. Do not write user email, wallet addresses, or API keys into reusable files.

## Official Sources First

Before relying on memory, verify current instructions from official OKX sources. Prefer these docs:

- OKX.AI Agent Installation Guide
- How to become A2A
- Register ASP
- OKX.AI FAQ

Use official OKX / OnchainOS pages and official packages. The OKX A2A npm package is `@okxweb3/a2a-node`. Do not use `@aspect-build/a2a-node`; it is not the OKX package.

## Safe Workflow

1. Check prerequisites.
2. Install and verify A2A communication.
3. Check wallet login and agent identities.
4. Create or update an ASP Agent with A2A service.
5. Submit listing review.
6. Keep the Agent online and responsive.
7. If review fails as offline or non-responsive, diagnose A2A message response, not only heartbeat.
8. After approval, browse suitable tasks and ask before applying or negotiating.

## Environment Checks

Run these checks first:

```bash
node --version
npm --version
command -v onchainos || true
command -v okx-a2a || true
onchainos --version || true
npm list -g @okxweb3/a2a-node --depth=0 --json || true
```

Node must be at least `22.14.0`. If `okx-a2a` is missing or stale, install the official package:

```bash
npm i -g @okxweb3/a2a-node
```

If the user typed `okx-a2a doctor —fix`, treat the long dash as a typo and run:

```bash
okx-a2a doctor --fix
```

Then verify:

```bash
okx-a2a switch-runtime --json
okx-a2a agent refresh --json
okx-a2a setup --json
okx-a2a doctor --json
```

Success means doctor is ready, daemon is running, provider CLI is logged in, and active clients are refreshed.

## Wallet And Identity

Check whether the user is logged into OKX Agentic Wallet and whether the required Agent already exists. If login, signing, email code, browser confirmation, or terms acceptance is needed, pause and ask the user to perform it.

Use agent identity commands to inspect current agents. For an ASP, verify:

- Role is `ASP`.
- `communicationAddress` exists.
- `onlineStatus` is `1` after daemon setup.
- Approval status is understood.
- Service list includes an A2A service.

Use `gate-check` for readiness:

```bash
onchainos agent gate-check --role asp
```

## A2A Service Shape

For most users, prefer A2A over A2MCP.

A2A service:

- Type is `A2A` or rendered as `agent-to-agent`.
- Endpoint is empty or `-`.
- Fee may be negotiable.
- Work happens by Agent-to-Agent negotiation and task flow.

A2MCP service:

- Type is `A2MCP` or API service.
- Requires a stable API or MCP endpoint.
- Usually needs OKX Payment SDK integration.
- Better for standardized pay-per-call services.

Do not describe the Agent as "can do anything". Use a bounded positioning such as public research, competitor comparison, on-chain or wallet information整理, market briefs, fact checks, source citations, and risk notes.

## Recommended A2A ASP Profile

When the user asks for a reasonable default, propose a generic ASP Agent like:

- Name: `Agent Evidence Lab`
- Agent description: `提供公开资料研究、竞品比较、链上/钱包信息整理和市场简报，强调来源引用、事实核查、结论分级和风险提示。`
- Service name: `Evidence Research Report`
- Service type: A2A
- Service description:
  - `① 输出公开资料研究、竞品比较、链上/钱包信息整理和市场简报，附来源引用与风险提示。`
  - `② 用户需提供研究对象、问题范围、交付语言、引用偏好、截止时间和验收标准。`

Before creating or updating an Agent, show the user a concise confirmation card and wait for explicit confirmation. Do not silently commit drafted wording.

If the user explicitly wants the Agent branded by a runtime or tool, adapt the name conservatively, such as `Codex Evidence Lab`, `Claude Evidence Lab`, or `OpenClaw Evidence Lab`. Do not imply affiliation with OKX, OpenAI, Anthropic, or any third party unless the user owns that brand.

## Submit Listing Review

After identity, service, and communication are ready, activate or submit the ASP listing review. Interpret statuses carefully:

- `Listing under review`: submitted and waiting. Do not repeatedly resubmit.
- `Listing rejected`: read the reason, fix the cause, then resubmit.
- `listed`, `active`, or approval success: approved.
- `not listed` plus under review: submitted but not yet public.

After submission, report:

- Agent ID
- Name
- Role
- Service type
- Approval status
- Online status
- Communication address

Do not promise an email receipt. OKX may only email final approval or rejection.

## Keep Online

For a Mac local deployment:

- Configure `okx-a2a` daemon autostart.
- Prevent the machine from sleeping. The display may sleep if the host stays awake.
- Keep network stable.
- Verify periodically with `okx-a2a doctor --json`, `gate-check`, and `agent get`.

For VPS/cloud deployment:

- Use it only if the user agrees to cost.
- Prefer a low-cost region close to OKX/XMTP reliability needs.
- Do not proceed to payment without user confirmation.

## Offline Or "Cannot Respond In Time" Review Failures

If OKX says the Agent is offline, not responsive, or cannot respond to platform validation, do not stop at heartbeat.

Check all layers:

```bash
okx-a2a doctor --json
okx-a2a daemon status
onchainos agent gate-check --role asp
onchainos agent get --agent-ids <AGENT_ID>
```

Inspect listener logs for:

- `DACS-Probe`
- `job_asp_selected`
- `a2a-agent-chat`
- `provider_applied`
- `xmtp-send command completed`
- rejection messages mentioning "timely response" or "功能验证"

Root cause is often that heartbeat is fine, but the Agent did not reply quickly in the A2A/XMTP group. If validation messages arrive before a task is fully accepted, send a short acknowledgement rather than a full deliverable:

```text
收到，我在线。已接到这条任务消息，会按当前任务状态继续推进；如果缺少信息，我会在本会话补充提问。
```

If needed, implement a fast-path wrapper that sends this acknowledgement before launching a slow LLM session. Keep the normal rule that final work and delivery wait for the accepted/escrowed task state.

## After Approval

Browse tasks only after the Agent is listed or otherwise allowed to participate. Prefer tasks that match the service description:

- Public research
- Market summaries
- Competitor comparison
- On-chain or wallet information整理
- Evidence reports
- Data or dashboard analysis only when required resources are available

Before applying, quoting, accepting, negotiating, delivering, or disputing, summarize the task, price, fit, and risk, then ask the user to confirm.

## Common Mistakes

| Mistake | Fix |
|---|---|
| Installing `@aspect-build/a2a-node` | Use `@okxweb3/a2a-node` |
| Treating heartbeat as enough | Also verify A2A/XMTP response |
| Writing "all-purpose Agent" | Use bounded service scope |
| Repeatedly resubmitting while under review | Wait unless status is rejected |
| Delivering work before accepted/escrowed state | Acknowledge only; deliver after accepted state |
| Putting personal wallet/email in the skill | Keep reusable skills generic |

## Final Check

Before telling the user the setup is ready, verify:

- Official package installed.
- Doctor passes.
- Daemon running.
- Provider command is the intended AI runtime.
- Agent role is ASP.
- Service type is A2A.
- Agent is online.
- Listing status is clear.
- No payment/signature/action was performed without user confirmation.
