# Installing the SCC skills (instructions for an AI agent)

You were pointed at this repository to install its skills. There are seven,
each a folder under `skills/` holding one `SKILL.md` (Agent Skills format):
scc-launch, scc-setup, scc-research, scc-ideas, scc-write, scc-test-plan,
scc-learn. They drive the tools of the SCC (Smart Content Companion) MCP
server; without that server connected they can be read but not run.

Pick the first route that matches where you run. Install the way that
keeps updating, as described for that route; don't copy the files by hand
when a route below can track this repo.

## Claude Code

Run these, or ask the user to type them as slash commands:

```
claude plugin marketplace add ptiza-v-nebe/scc-skills
claude plugin install scc@scc-skills
```

Then tell the user to turn on auto-update once: `/plugin` → Marketplaces →
`scc-skills` → Enable auto-update. Third-party marketplaces start with it
off. Once it is on, every push to this repo reaches them at the next start;
without it, `claude plugin marketplace update scc-skills` pulls changes.

## Codex, Cursor, Gemini CLI, Grok Build, OpenCode and other coding agents

```
npx -y skills add ptiza-v-nebe/scc-skills --skill '*' -g -y
```

Add `-a <agent>` to target one agent. Updates come from
`npx -y skills update -g -y`. Offer the user a daily scheduled job (cron,
launchd or Task Scheduler) that runs it, because nothing else will.

## ChatGPT, Grok web app, claude.ai and Claude Desktop

These apps keep their own copy of each uploaded skill and do not sync with
GitHub. You usually cannot upload for the user, so give them these links
and the path for their app:

- The whole plugin, all seven skills: `https://github.com/ptiza-v-nebe/scc-skills/releases/latest/download/scc-skills.zip`
- One zip per skill: `https://github.com/ptiza-v-nebe/scc-skills/releases/latest/download/<skill-name>.zip`

| App | Where to upload |
|---|---|
| ChatGPT | Plugins → New plugin → `scc-skills.zip` (one upload for all seven). Where Plugins is missing: Skills → upload each skill's zip; workspaces may need an admin to allow uploads |
| claude.ai / Claude Desktop | Settings → Capabilities → Skills → upload, one zip per skill |
| Grok web app | Skills → upload a `.zip` or the `SKILL.md` |

Tell the user that after a change to this repo they must upload again,
replacing the old plugin or skill. The release list at
`https://github.com/ptiza-v-nebe/scc-skills/releases` shows when one is due.

## After installing

Report which skills you installed with their versions (`metadata.version`
in each `SKILL.md`), where, and how they will update. If
the SCC MCP server isn't connected, say so: the skills call its tools.
