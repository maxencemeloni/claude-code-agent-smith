# Pull Request

## Summary

<!-- 1-3 sentences describing the change and why -->

## Type of Change

- [ ] Bug fix (patch version bump)
- [ ] New feature (minor version bump)
- [ ] Breaking change (major version bump)
- [ ] Documentation only
- [ ] Internal refactor (no user-facing change)

## Related Issues

<!-- e.g. Closes #42, Refs #7 -->

## Changes

<!-- Bulleted list of concrete changes -->

-
-

## Command Parity Check

Agent Smith ships commands in two places. Confirm both are consistent (or flag an intentional divergence):

- [ ] `commands/` (plugin, user-facing) updated
- [ ] `.claude/commands/` (dev, local testing) updated
- [ ] Divergence is intentional and documented in `CLAUDE.md` → *Dev vs Plugin Command Parity*
- [ ] N/A (change does not touch command files)

## Documentation Updates

- [ ] `README.md` updated (if user-facing)
- [ ] `IMPROVEMENTS.md` changelog entry added
- [ ] Wiki pages updated (separate repo)
- [ ] `AGENT_SMITH.md` updated (if pillar definitions or scope changed)
- [ ] N/A

## Version Bump

- [ ] `VERSION` updated
- [ ] `.claude-plugin/plugin.json` version field updated
- [ ] `.claude-plugin/marketplace.json` version updated
- [ ] README version badge updated
- [ ] N/A (not a release PR)

## Testing

<!-- How did you verify the change? -->

- [ ] Ran `claude plugin validate .` — passes
- [ ] Tested affected command against a sample project
- [ ] Verified report format still matches the documented structure
- [ ] N/A — documentation-only change

## Scope Alignment

- [ ] Change respects the *honesty over hype* principle (no claims about capabilities we cannot actually measure)
- [ ] Change stays within the documented analysis scope (no references to Claude Code's internal system prompt, tool schemas, or runtime behavior)

## Screenshots / Report Excerpts

<!-- Optional. Paste relevant report output, diff highlights, or screenshots -->

## Additional Notes

<!-- Anything reviewers should know -->
