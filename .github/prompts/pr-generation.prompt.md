---
description: 'Automated PR workflow: creates branch, commits with proper message, pushes, opens PR, merges, cleans up. Follows project commit and PR rules.'
model: GPT-5 mini
---

# PR Command Automation Prompt

Execute the following workflow using GitHub's MCP:

1. Create a new branch with a simple, descriptive name related to the uncommitted changes and check it out.
2. Add all changed files.
3. Commit the changes, following the commit message rules:
   - Start with a summary title
   - Use a bulleted list of changes (with emojis)
   - Reference file names and specific modifications
4. Push the branch to the remote repository.
5. Create a Pull Request (PR) with that branch.
6. Fetch the PR (diff, changed files, checks, and review comments) and run a deterministic gate before continuing:
   - Security checks: verify no secrets in changes, no new high/critical dependency vulnerabilities, and no obvious auth/authorization/input-validation regressions in modified code.
   - Acceptance checks: confirm every requirement from the linked issue/PR description is mapped to a code change or test result.
   - Contribution checks: confirm commit/PR format, required labels/template fields, and required CI checks all pass.
   - If any check fails, stop automation, post a REQUEST_CHANGES review with file-level findings, and do not merge.
   - If all checks pass, proceed and report a concise “gate passed” summary.
7. Show the PR URL and current status summary: gate result (passed/failed), required CI checks state, merge readiness, and any blocking items (if present).

This workflow ensures consistent, clear, and traceable contributions.
Don't ask for GitHub repo (owner/repo) or branch name; just generate them based on the changes and project context.
