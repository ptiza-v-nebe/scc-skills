# SCC skills

Seven workflow skills for Smart Content Companion (SCC), in the open
[Agent Skills](https://agentskills.io) format, so the same `SKILL.md` files
work in Claude, ChatGPT, Grok, Codex, Cursor and others.

| Skill | Use it for |
|---|---|
| [scc-launch](skills/scc-launch/SKILL.md) | one brief → a full campaign: setup, research, ideas, scripts, 7-day plan |
| [scc-setup](skills/scc-setup/SKILL.md) | a messy brief → campaign profile and brand |
| [scc-research](skills/scc-research/SKILL.md) | Virlo searches → favorites → patterns |
| [scc-ideas](skills/scc-ideas/SKILL.md) | patterns → ranked post intents |
| [scc-write](skills/scc-write/SKILL.md) | pattern + intent → script → post text |
| [scc-test-plan](skills/scc-test-plan/SKILL.md) | scripts + intents → a 7- or 30-day plan built as a test |
| [scc-learn](skills/scc-learn/SKILL.md) | published results → conclusions → campaign learnings |

They call the tools of the SCC MCP server, which has to be connected in the
agent that runs them.

## Install

The quickest way: give any agent this repo's URL and say *"install the
skills from this repo"*. [AGENTS.md](AGENTS.md) tells it how.

By hand:

| Where | Install | Updates |
|---|---|---|
| Claude Code | `/plugin marketplace add ptiza-v-nebe/scc-skills`, then `/plugin install scc@scc-skills` | automatic once auto-update is on for the marketplace (`/plugin` → Marketplaces) |
| Codex, Cursor, Grok Build and other coding agents | `npx skills add ptiza-v-nebe/scc-skills --skill '*' -g` | `npx skills update -g` (put it in cron for hands-off) |
| claude.ai, Claude Desktop, ChatGPT, Grok web | upload zips from the [latest release](https://github.com/ptiza-v-nebe/scc-skills/releases/latest) | re-upload the changed skill; the apps don't sync with GitHub |

## Versions

Every skill has its own version, because skills change independently. It
sits in two places in each `SKILL.md`, which must agree:

- `metadata.version` in the frontmatter: the version tools read;
- the line under the title that tells the agent to begin its first reply
  with `<name> v<version>`: the version the user sees, in any app, so they
  can tell which copy ran (for example a stale upload in ChatGPT).

Bump it on every change to that skill: patch (`1.0.1`) for wording, minor
(`1.1.0`) for changed behaviour, major (`2.0.0`) when it needs different
SCC tools or breaks how users run it. Leave the other skills alone.

`scripts/check-versions.sh` checks both places agree and that every
changed skill was bumped. It runs in the release workflow, and before each
commit once you turn on the hook in your clone:

```
git config core.hooksPath .githooks
```

Use the hook: Claude Code users get a pushed change straight away, so a
CI failure after the push comes too late to stop an unbumped change. Each
release's notes list the bumped skills and the version of every skill.

## Changing a skill

Edit `skills/<name>/SKILL.md`, bump its version (see above) and push to
`main`. That is all:

- Claude Code picks the change up by commit, because `plugin.json` sets no
  `version`. If you ever add one, every change must bump it or nobody gets
  the update.
- `npx skills update` pulls straight from the repo.
- The `release` workflow rebuilds the zips into a new release, so the
  `releases/latest/download/<name>.zip` links always serve the newest copy.

`scripts/build-zips.sh` builds the same zips locally into `dist/`.
