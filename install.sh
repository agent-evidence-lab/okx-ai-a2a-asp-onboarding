#!/usr/bin/env bash
set -euo pipefail

skill_dir="${CODEX_HOME:-$HOME/.codex}/skills/okx-ai-a2a-asp-onboarding"
repo_url="https://github.com/agent-evidence-lab/okx-ai-a2a-asp-onboarding.git"

mkdir -p "$(dirname "$skill_dir")"

if [ -d "$skill_dir/.git" ]; then
  git -C "$skill_dir" pull --ff-only
else
  rm -rf "$skill_dir"
  git clone "$repo_url" "$skill_dir"
fi

printf 'Installed OKX AI A2A ASP onboarding skill to %s\n' "$skill_dir"
