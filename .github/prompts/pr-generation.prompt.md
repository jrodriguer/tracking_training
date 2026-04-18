---
description: 'Automated PR workflow: prepares commits and PR updates with report_progress, following project commit and PR rules.'
model: Raptor mini (Preview) (copilot)
---

# PR Command Automation Prompt

Execute the following workflow using GitHub's MCP:

1. Confirm there are local changes and gather validation evidence for them.
2. Prepare a commit message that follows `tracking_training_flutter/docs/git.md`:
   - Start with a summary title
   - Use a bulleted list of changes (with emojis)
   - Reference file names and specific modifications
3. Use `report_progress` to:
   - stage and commit all local changes
   - push updates to the current PR branch
   - update the PR description using a markdown checklist only
4. Keep the PR open for human review. Do **not** merge, close, or delete branches.
5. Return a concise summary with what was committed and what remains pending.

This workflow ensures consistent, clear, and traceable contributions.
Don't ask for GitHub repo (owner/repo) or branch name; use the current repository and active PR branch context.
