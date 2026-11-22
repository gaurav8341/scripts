# investing-tasks

Two Claude scheduled tasks that research my Indian and US portfolio and email me a report. They are research-only: they never place, change or cancel orders, GTTs or alerts.

The prompts in [`prompts/`](prompts/) are the source of truth. Edit them here, then paste the new text into the task (or ask Claude to update the task from this file).

| Task | Prompt | Schedule (IST) | Email subject |
|---|---|---|---|
| Weekly portfolio, earnings & news review (India + US) | [`weekly-portfolio-review.md`](prompts/weekly-portfolio-review.md) | Sundays 5:36 AM — `CRON_TZ=Asia/Calcutta 36 5 * * 0` | `Weekly portfolio review – <date>` |
| Monthly opportunity scan (India + US) | [`monthly-opportunity-scan.md`](prompts/monthly-opportunity-scan.md) | 1st of the month, 10:35 AM — `CRON_TZ=Asia/Kolkata 35 10 1 * *` | `Monthly opportunity scan – <month year> · top pick: <name>` |

Task IDs: weekly `trig_01U9ygWuLBywcEAVXLGVXe3d`, monthly `trig_01WL8Rf4jxEqXifp9vAXEaDe`.

## What each one does

**Weekly review**
- Holdings from Kite (primary) and INDmoney, with a BUY MORE / HOLD / TRIM / EXIT / WATCH verdict for every holding, every week.
- Earnings deep-dives for holdings that reported; short notes for the watchlist.
- Policy watch (India + US), news tagged good/bad, upcoming earnings and policy events, macro and allocation.

**Monthly scan**
- Policy tailwinds and headwinds first, which decide where to look.
- Up to 2 India and 2 US candidates. Each gets: what the company does, a fixed financials table (absolute values plus change), valuation, SWOT, short- vs long-term risks, AI-exposure rating and a verdict.
- "Didn't make it" list, a check on losing positions (NVDA, AMD, AMAT, AAXJ), and changes to previously rejected names.

## What they need

Connectors on the task: **Kite**, **INDmoney**, **Gmail** (read + send). Both clone [`gaurav8341/finance-suite`](https://github.com/gaurav8341/finance-suite) and run its tools with `uv`.

Network allowlist (Claude Settings → Capabilities): `query1.finance.yahoo.com`, `query2.finance.yahoo.com`, `fc.yahoo.com`, `scanner.tradingview.com`.

Gmail setup they rely on:
- Label **Policy**, filled by a filter on `pib@nic.in OR rbi.org.in` (skip inbox, never spam).
- PIB email subscription for Cabinet/CCEA, Finance, Commerce & Industry, Power, MNRE, Defence, Electronics & IT, Heavy Industries, Communications, Space, Mines, Coal, Petroleum, MoSPI, EAC-PM, NITI Aayog and Corporate Affairs.
- Newsletters read as leads: IND Daily, Vested Finance, Value Research, Motilal Oswal, Groww.

No US subscriptions: each run searches the Fed, BIS, USTR, White House, Federal Register, defense.gov, DOJ/FTC, BLS/BEA and congress.gov directly.

## Known gotchas

- **Kite session expires daily at 6 AM.** The weekly run says "Kite session expired — reconnect Kite" and falls back to INDmoney.
- **Shared machine.** Runs can overlap on one machine, so each works in its own `mktemp -d` folder with a task-specific HTML filename. Using a generic `email.html` once caused the weekly run to send the monthly email.
- **Yahoo crumb endpoints fail** (`get_analyst_data`, `get_ownership_and_trades`); analyst views come from INDmoney instead.
- **Screener.in** can only be fetched via URLs returned by a web search.
