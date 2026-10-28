---
name: "scc-test-plan"
description: "Build a 7- or 30-day SCC plan as a deliberate test: spread patterns, never repeat hook_type × content_format back to back, aim intents, write each entry's text."
metadata:
  version: "1.0.0"
---

# SCC Test Plan: scripts + intents → a varied posting plan

Begin your first reply in each run with `scc-test-plan v1.0.0` on its own line, so the user can see which version of this skill ran.

Use this when the user wants a week or a month planned ("plan next week", "build a 30-day calendar", "fill the plan"). SCC plans have no dates; Schedule decides those. The output is a plan whose days hold entries (a script plus an intent), each with its text written.

## 1. Inputs (free reads)

- `campaigns_get`: posting rhythm if known, pillars, learned_hints.
- `compose_get_scripts` (campaign_id, groups: true): the scripts available, and the favorites grouped by hook_type × content_format with median scores.
- `analyze_get_patterns` (campaign_id): the pattern behind each script, and its strength.
- `plan_get` (campaign_id): existing plans. Reuse a plan if the user means "this plan".

If there are fewer than 2 scripts, stop and suggest **scc-write** first. If there are no intents, suggest **scc-ideas**, or create intents now with that skill's method.

## 2. Size

- Days: 7 by default, 30 if asked.
- Posts per day: from the user, or 1.
- Total entries = days × posts per day.

## 3. Allocate: test deliberately

Treat the plan as an experiment over shapes. Each script has a shape key, **hook_type × content_format**, plus its medium.

1. **Weight by evidence.** Give each script a share proportional to its pattern's strength: median_score relative to base, scaled down for patterns built from only 2 posts. The strongest pattern gets the most slots but no more than 40%. Every kept pattern gets at least 2 slots in a week, so there is something to compare.
2. **Spread.** Never put the same shape key on two days in a row. Vary the medium (image, carousel, video) across the week where the scripts allow it.
3. **Pillar balance.** Across the plan, every pillar appears; no pillar takes more than 40%.
4. **Pair intents to scripts.** Aim each entry at an intent that fits its script's pattern: the intent's subject must be able to fill the pattern's required beats. Never use the same intent twice in one week.
5. **Hold one control.** In a 7-day plan, repeat the strongest script once with a different intent. That lets you separate the effect of the shape from the effect of the topic.

Write the allocation down for yourself as a table first: day · script (shape key, medium) · intent · pillar.

## 4. Build it in SCC

1. Create the plan with `plan_save` (campaign_id, name, days, brief, instructions), or edit an existing one.
   - **brief**: what holds for the whole batch (goal action, period, campaign voice), 2–3 sentences.
   - **instructions**: for the writer on every entry: banned phrases, voice, "copy mechanism, never wording".
   - SCC's own framing is available: `plan_propose_prompt` (step brief), answered yourself, then `plan_save`.
2. Intents: if new ones are needed, use `plan_save_intents` (add) or `copy` from another plan.
3. Entries: for each row, `plan_save` with `add_entry` (slot_id, script_id, intent_id). Get the slot ids from `plan_get`. Or call `plan_propose_prompt` (step board), answer it with your allocation, and save it that way.
4. Check the result with `plan_get` against your table.

## 5. Write each entry

For each entry not yet made, call `plan_text_prompt` (plan_id, entry_id), write the take to its schema and save it with `plan_save_takes`. Writing rules:
- the intent's subject, inside the script's shape;
- the hook first: draft 5, keep 1;
- no banned phrases, no invented figures, nothing that sounds AI-written;
- the CTA asks for the campaign's goal action.

## 6. Report

The plan table (day · shape key · medium · intent · pillar), the allocation logic in 2 lines (which pattern got most and why, which entry is the control), and what was written. Images (`plan_image`) and sending to Schedule (`plan_send_to_schedule`) only when the user asks; name the image cost first.

## Rules

- One idea per entry; one subject per post.
- Never copy wording from source posts.
- Virality score is the only measure of a pattern's strength; never raw views.