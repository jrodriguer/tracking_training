description: 'Automated PR workflow: commits local changes and updates PR progress with report_progress.'
model: GPT-5 mini
---

# PR Command Automation Prompt

Execute the following workflow using GitHub's MCP:

1. Confirm there are local changes and gather validation evidence for them.
2. Prepare a concise commit message that summarizes the change.
3. Use `report_progress` to:
   - stage and commit all local changes
   - push updates to the current PR branch
   - update the PR description with a markdown checklist showing progress and
     remaining work (for example, `- [x] done` and `- [ ] pending`)
4. Keep the PR open for human review. Do **not** merge, close, or delete branches.
5. Return a concise summary with what was committed and what remains pending.

This workflow ensures consistent, clear, and traceable contributions.
Don't ask for GitHub repo (owner/repo) or branch name; use the current repository and active PR branch context.
