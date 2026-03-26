# full-delivery-skill

完整交付skill / Full Delivery Skill for OpenClaw.

## What it does

This skill enforces a deliverable-first workflow:
- define deliverables and DoD first
- auto-classify the task as development / research / documentation / troubleshooting
- execute instead of only advising
- provide evidence and artifacts
- if blocked, still return partial delivery + blockers + next steps

## Portable design

This repository is designed to be portable across OpenClaw installs:
- Markdown + shell first
- no Python requirement for nightly maintenance
- bundled install/update scripts

## Included files

- `full-delivery-skill/SKILL.md`
- `full-delivery-skill/references/*.md`
- `full-delivery-skill/scripts/install.sh`
- `full-delivery-skill/scripts/nightly_update.sh`
- `full-delivery-skill/scripts/package_skill.sh`
- `full-delivery-skill.skill`

## Install

```sh
git clone https://github.com/Skytigerk/full-delivery-skill.git
cd full-delivery-skill
./full-delivery-skill/scripts/install.sh
```

The install script will:
- copy the skill to `~/.openclaw/skills/full-delivery-skill`
- package `full-delivery-skill.skill`
- install a user cron job that runs every day at 02:00

## Trigger examples

- `full delivery skill`
- `完整交付skill`
- `交付模式`
- `不要只分析`
- `给交付物`
