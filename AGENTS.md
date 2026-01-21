# AGENTS.md

## Validation Commands (Backpressure)

Run these commands before marking any task complete:

- Universal validation: `./scripts/validate-universal.sh` (Linux/Mac)
- Universal validation: `./scripts/validate-universal.ps1` (Windows)
- Legacy validation: `./scripts/validate-all.sh` or `./scripts/validate-all.ps1`
- Git status: `git status --porcelain` (should be clean after commit)

## Project Conventions

- Use markdown for all documentation
- Follow GSD framework structure and patterns
- Atomic commits with format: `feat(phase-N): description`
- All scripts must be cross-platform (bash + PowerShell)
- Keep AGENTS.md under 60 lines (operational only)
- Status updates go in IMPLEMENTATION_PLAN.md, not here

## Build/Test Commands

- Universal validation: `./scripts/validate-universal.sh` or `./scripts/validate-universal.ps1`
- Legacy validation: `./scripts/validate-all.sh` or `./scripts/validate-all.ps1`
- Test loop scripts: `./loop.sh --dry-run` or `./loop.ps1 -DryRun`
- Check file structure: `ls -la` or `Get-ChildItem`
- Verify git state: `git status`

## Ralph Loop Operations

- Build mode: `./loop.sh build` or `./loop.ps1 -Mode build`
- Plan mode: `./loop.sh plan` or `./loop.ps1 -Mode plan`
- Dry run: `./loop.sh --dry-run` or `./loop.ps1 -DryRun`
- Help: `./loop.sh --help` or `./loop.ps1 -Help`

## File Structure Requirements

- PROMPT_build.md and PROMPT_plan.md must exist
- IMPLEMENTATION_PLAN.md tracks current tasks
- specs/ directory contains static requirements
- All files use UTF-8 encoding with LF line endings

## Quality Gates

- No task marked complete without validation passing
- All changes committed atomically with descriptive messages
- Cross-platform compatibility verified
- Documentation updated when operational procedures change

## Emergency Procedures

- If loop fails repeatedly: Check IMPLEMENTATION_PLAN.md for issues
- If validation fails: Fix issues before continuing
- If git conflicts: Resolve manually, then resume loop
- If context pollution: Restart loop for fresh context