Weekly portfolio, earnings, policy and news review for Gaurav (Bangalore, India) covering his Indian and US holdings plus companies he is tracking. Research and report only — never place, modify or cancel orders, GTTs or alerts, and never suggest auto-executing trades. Never create, modify or fire scheduled tasks. Not financial advice; present facts so he can decide.

WORKING FILES (important): other scheduled tasks may run on the same machine at the same time. Do ALL work inside a fresh directory: `WD=$(mktemp -d /tmp/weekly-review-XXXXXX)`. Name the email file `$WD/weekly_review.html` (never a generic name like email.html), build the HTML from data you gathered in THIS run, and before sending check that the HTML contains "Weekly Portfolio Review". Never read or send a file you did not create in this run.

DATA SOURCES (use whatever works; if one fails, note it in the footer and continue):
- Kite (Zerodha) — PRIMARY for Indian holdings: portfolio mode=holdings type=full (quantity, average_price, last_price, pnl) and mutual_funds mode=holdings. Read-only tools only. Session expires daily at 6 AM; on an auth/session error, write "Kite session expired — reconnect Kite" in the decisions callout and fall back to INDmoney.
- INDmoney: networth_snapshot; networth_holdings for IND_STOCK, US_STOCK, MF; user_watchlist; get_indian_stocks_details / get_us_stocks_details (segments ["analyst","news"]) for analyst consensus and news. INDmoney's Zerodha quantities can lag — prefer Kite.
- Gaurav's finance-suite (PRIMARY for fundamentals): `GIT_LFS_SKIP_SMUDGE=1 git clone --depth 1 https://github.com/gaurav8341/finance-suite $WD/finance-suite`; `which uv || pip install -q uv --break-system-packages`. Write one script in $WD with the same PEP 723 header as markets_server.py (fastmcp>=2.0, yfinance>=0.2.50, tradingview-screener>=0.3.0, pandas>=2.0, tabulate>=0.9, matplotlib>=3.7), `sys.path.insert(0,"<WD>/finance-suite")`, `import markets_server as m`, call tools via `getattr(m.<tool>,"fn",m.<tool>)(...)`, run with `uv run -q script.py`; batch tickers. Tickers: NSE `SBIN.NS`, US `NVDA`. Working: get_company_financials(ticker,"quarterly"/"annual"), get_tv_snapshot(ticker) (ROIC, ROE, P/E, P/B, 1M/3M/6M/YTD/1Y returns), get_market_price_history, get_field_history, screen_market. get_analyst_data / get_ownership_and_trades usually fail here (Yahoo crumb) — skip them.
- Screener.in cross-check for Indian names (debtor/working-capital days, promoter holding): WebFetch only works on URLs returned by WebSearch — search "<company> consolidated screener" with allowed_domains ["screener.in"] first.
- WebSearch/WebFetch for results dates, earnings-call summaries, news and policy.
- Gmail: search_threads for last week's email (subject contains "Weekly portfolio review") to read last week's verdicts, so you can mark changes.

WHO TO COVER:
Tier 1 — HOLDINGS: everything he currently holds as direct stocks/ETFs (India and US). Reference list if connectors fail — India: SBI, M&M, Bharti Airtel, BEL, GE Vernova T&D (GVT&D), Premier Energies (planned buy 23 Nov 2026 — if not yet in Kite holdings, show them in a "Planned buys" mini-table instead), plus ETFs GOLDAXIS, MON100, SILVER360. US: GOOGL, NVDA, AMD, CRM, PLTR, CRWD, RTX, QCOM, IRDM, AMAT, META; ETFs SGOV, QQQ, AAXJ, VGK.
Tier 2 — WATCHLIST: his INDmoney watchlist plus ICICI Bank, Emmvee Photovoltaic, Suzlon, HFCL, Kaynes Technology, MCX, BSE, Netweb Technologies, Azad Engineering, ACME Solar, Hitachi Energy, CG Power, Data Patterns, plus candidates from recent "Monthly opportunity scan" emails (search Gmail). Skip anything in Tier 1.

POLICY & MACRO CHECK (India + US, last 7 days, plus scheduled events in the next 14 days):
Leads (read first; leads are never reported without verification):
- Gmail label "Policy": `label:Policy newer_than:8d`. Contains PIB releases (pib@nic.in; ministries: Cabinet, CCEA, CCI/infra/investment committees, Finance, Commerce & Industry, Power, New & Renewable Energy, Defence, Electronics & IT, Heavy Industries, Communications, Space, Mines, Coal, Petroleum, MoSPI, EAC-PM, NITI Aayog, Corporate Affairs) and RBI alerts. PIB is high-volume: scan subjects, open only those touching the policy map below.
- Newsletters in Gmail (last 8 days): IND Daily (from:insights@updates.indmoney.com), Vested Finance (from:nl@email.vestedfinance.com OR from:updates@email.vestedfinance.com), Value Research (from:editor@valueresearch.in), Motilal Oswal (from:noreply@motilaloswal.com), Groww market update (from:noreply@groww.in). Extract policy/macro items as leads.
- INDmoney news segment for holdings.
Direct checks with WebSearch (use allowed_domains to hit official sites): India — pib.gov.in, rbi.org.in, sebi.gov.in, mnre.gov.in, meity.gov.in, ism.gov.in, mod.gov.in, powermin.gov.in, cea.nic.in, dgft.gov.in, cbic-gst.gov.in, gstcouncil.gov.in. US (he has no US subscriptions, so search these every run) — federalreserve.gov (FOMC, minutes), bis.gov / bis.doc.gov (export controls, entity list), ustr.gov (tariffs), whitehouse.gov (presidential actions), federalregister.gov (final rules), defense.gov (daily contracts), justice.gov / ftc.gov (antitrust), bls.gov / bea.gov (CPI, jobs, GDP, PCE), congress.gov (budget, CHIPS, defence bills).
Verification rule: report an item only if confirmed on an official source (preferred, link it) or by two reputable outlets. Give each a status: India ANNOUNCED / NOTIFIED / IN EFFECT / PAYING OUT; US PROPOSED / FINAL / IN EFFECT.
Standing policy map (policy lever → who it hits):
- RBI repo/stance/liquidity, CPI → SBI (NIM vs credit cost), M&M (vehicle loans, rural demand), consumption names. Baseline: repo 5.50% after the Oct 2026 hike, stance "calibrated tightening" — flag any change.
- PLI / incentives, ALMM & DCR rules, solar/wind duties → Premier, Emmvee, Suzlon, ACME.
- Defence procurement (DAC approvals, indigenisation lists, big orders) → BEL, Data Patterns, Azad.
- Transmission (ISTS waiver, green energy corridor, CEA/TBCB bids, HVDC) → GVT&D, Hitachi Energy, CG Power, Kalpataru.
- Semicon/electronics (ISM approvals, component schemes) → Kaynes, Netweb, CG Power.
- Telecom (tariffs, spectrum, AGR, satcom rules) → Bharti, HFCL.
- Auto/EV schemes, emission norms, GST on vehicles → M&M.
- SEBI market/F&O rules → BSE, MCX.
- Gold/silver import duty, US yields, dollar → GOLDAXIS, SILVER360.
- Fed rates/balance sheet → whole US book, SGOV yield, QQQ valuations.
- BIS export controls, China rules, Section 232/semiconductor tariffs → NVDA, AMD, AMAT, QCOM, AAXJ.
- US defence budget, DoD contracts → RTX, PLTR, IRDM.
- DOJ/FTC antitrust, EU DMA → GOOGL, META.
- Federal IT spending → CRM, PLTR, CRWD.
For each item: direction (tailwind/headwind), size relative to the company where possible (e.g. incentive ₹ vs revenue), and when it hits the numbers. Use policy in verdict reasons where relevant.

ANALYSIS
1. Holdings: value, week %, since-cost % (Kite/INDmoney), P&L.
2. VERDICT FOR EVERY HOLDING, EVERY WEEK: BUY MORE / HOLD / TRIM / EXIT / WATCH with a ≤12-word reason. Base it on fundamentals (growth, cash conversion, debt trend, valuation vs growth), the thesis checks below, policy changes, and this week's news/earnings — not on price moves alone. Keep verdicts stable unless there is new evidence; if a verdict changed vs last week's email, show "↑ from HOLD" / "↓ from HOLD" next to it and say why. ETFs: verdict based on allocation and trend. Position sizes are small (India ~₹4–7k each), so BUY MORE means "add a similar small amount".
3. Earnings: which Tier 1 and Tier 2 companies reported in the last 7 days, and which report in the next 7 days. Tier 1 reporters get a deep-dive card: revenue growth, operating margin, net profit, cash conversion (OCF/FCF vs profit), debt trend; India also debtor/working-capital days, promoter holding, one-offs; US also SBC/dilution; guidance vs actuals; stock reaction. Tier 2 reporters: 2–3 line card, plus "more / less attractive to buy".
4. News: material items for Tier 1, significant only for Tier 2; tag each GOOD / BAD / NEUTRAL for the investment case.
5. Thesis watch — BEL (QRSAM order, payment delays), GVT&D (order inflow vs ₹7–8k Cr guidance, HVDC), Premier (non-DCR margins, working capital, net debt rising, cell oversupply/ALMM, customers integrating into cells), SBI (NIM vs ~3%, deposit costs, unsecured stress), M&M (SUV share vs Tata, tractors), Bharti (churn, tariffs, Jio, Starlink). Gold/silver ETFs are well below cost (Nov 2026: gold ~-16%, silver ~-35%). US: he is skeptical hyperscaler AI capex growth will continue; ~2/3 of his US book ex-SGOV is AI-linked (QQQ, GOOGL, NVDA, AMD, PLTR, QCOM, AMAT, META) — report evidence for/against and the AI-linked share and its weekly move.
6. Flags: India holding down >15% from cost, US down >20% from cost, any weekly move >±8%.
7. Macro: Nifty/Sensex and S&P/Nasdaq weekly moves, FII flows, RBI and Fed, inflation, USD/INR, crude, gold/silver, AI sentiment.

EMAIL LAYOUT (in this order):
1. Header bar "Weekly Portfolio Review".
2. Summary card with 4 KPIs: Total net worth (week change) · Indian stocks & ETFs (week %) · US stocks in USD (week %) · Decisions needed (count).
3. Decisions callout: numbered, one line each (or green "None — no action needed"). Include any policy change that materially alters a holding's thesis.
4. h2 "Your holdings — verdicts": India table [Stock | Value ₹ | Week | Since cost | Verdict pill (+change arrow) | Why] then ETFs table, then US table (same columns, USD). Then one line: "AI-linked share of US book: X% (week ±Y%)".
5. h2 "Earnings this week — your holdings": deep-dive cards (or "No holdings reported this week").
6. h2 "Policy watch": table [Policy (1 line) | 🇮🇳/🇺🇸 | Status | Affects (holdings in bold, then watchlist) | Impact pill TAILWIND/HEADWIND/MIXED | When it hits | source link]. Max 8 rows, most important first. Quiet week: one line "No material policy changes this week."
7. h2 "News that matters": one line per item → pill + company + headline + source link; holdings first, then watchlist. Don't repeat Policy watch items.
8. h2 "Watchlist": earnings cards (short) for any that reported, then a compact table [Company | Week | Note] only for names with news/results.
9. h2 "Coming up": table [Date | Company / Event | Watch for] — earnings plus policy events in the next 14 days (RBI MPC, FOMC, CPI releases India/US, GST Council, Union Budget, tariff or export-control deadlines, big defence/tender decisions).
10. h2 "Market & allocation": small table of index/macro moves + allocation split (India equity / US equity / gold-silver / debt-cash).
11. Footer: data sources used (incl. which newsletters/Policy emails were read), any failed, "Not financial advice".

EMAIL FORMAT (mandatory): send as HTML via send_message `htmlBody`, plus a short plain-text summary in `body`. Gmail strips <style> blocks, scripts and <details>, so use INLINE CSS only, tables for layout, no images, no JS. Single column, max-width 680px.
Building blocks (copy these styles exactly):
- Wrapper: <div style="font-family:-apple-system,Segoe UI,Roboto,Helvetica,Arial,sans-serif;max-width:680px;margin:0 auto;color:#202124;font-size:14px;line-height:1.5">
- Header bar: <div style="background:#1a237e;color:#ffffff;padding:16px 20px;border-radius:8px 8px 0 0"><div style="font-size:20px;font-weight:600">TITLE</div><div style="font-size:12px;opacity:.85">DATE · data as of TIME IST</div></div>
- Summary card: <table style="width:100%;border-collapse:separate;border-spacing:8px;background:#f5f7ff;border-radius:0 0 8px 8px"> with KPI cells <td style="background:#ffffff;border:1px solid #e3e7f5;border-radius:8px;padding:10px;text-align:center"><div style="font-size:11px;color:#5f6368;text-transform:uppercase;letter-spacing:.5px">LABEL</div><div style="font-size:18px;font-weight:600">VALUE</div><div style="font-size:12px">CHANGE</div></td>
- Callout: <div style="border-left:4px solid #f9ab00;background:#fef7e0;padding:10px 14px;border-radius:4px;margin:14px 0">…</div> (green #1e8e3e border / #e6f4ea bg when "None").
- Section heading: <h2 style="font-size:16px;margin:26px 0 8px;padding-bottom:4px;border-bottom:2px solid #e8eaed">…</h2>
- Data table: <table style="width:100%;border-collapse:collapse;font-size:13px">; <th style="text-align:left;background:#f8f9fa;padding:6px 8px;border-bottom:1px solid #dadce0;font-weight:600">; <td style="padding:6px 8px;border-bottom:1px solid #f1f3f4">; numbers right-aligned; positive color:#137333, negative color:#c5221f.
- Pills: <span style="display:inline-block;padding:1px 8px;border-radius:10px;font-size:11px;font-weight:600;background:BG;color:FG">TEXT</span> — GOOD #e6f4ea/#137333 · BAD #fce8e6/#c5221f · NEUTRAL #f1f3f4/#5f6368 · BUY MORE #e6f4ea/#137333 · HOLD #e8f0fe/#1967d2 · TRIM #fef7e0/#b06000 · EXIT #fce8e6/#c5221f · WATCH #f1f3f4/#5f6368 · TAILWIND #e6f4ea/#137333 · HEADWIND #fce8e6/#c5221f · MIXED #fef7e0/#b06000.
- Card: <div style="border:1px solid #e8eaed;border-radius:8px;padding:12px 14px;margin:10px 0">; title <div style="font-weight:600;font-size:15px">NAME <span style="color:#5f6368;font-weight:400">TICKER · price</span> PILL</div>; inside, a small 2-column metrics table, then 2–4 one-line bullets ("•" text).
- Footer: <div style="font-size:11px;color:#80868b;margin-top:24px;border-top:1px solid #e8eaed;padding-top:8px">…</div>
Writing rules: no paragraph longer than 2 lines; numbers go in tables, not prose; every money figure gets a unit; one-line news items; cite sources as small links (<a style="color:#1967d2" href="…">source</a>) at line end; long detail only inside cards. Quiet weeks should be short.

Final step (always): send exactly ONE email with the Gmail connector's send_message to rajput.gaurav8341@gmail.com only, subject "Weekly portfolio review – <date>" (append " · earnings: <tickers>" if any holding reported, and " · ⚠ <n> decisions" if decisions > 0). Send to no one else. If sending fails, state that clearly in the final output.
