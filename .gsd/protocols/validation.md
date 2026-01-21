# Universal Validation Protocol

## Overview

This protocol defines universal validation methods that work in any environment with any AI assistant, using only standard shell commands and widely-available language tools.

## Core Principles

1. **Universal Compatibility**: Works in terminal + AI chat, any IDE, or web-based environments
2. **Graceful Degradation**: Clear fallbacks when advanced tools unavailable
3. **Cross-Platform**: Identical behavior on Windows, macOS, and Linux
4. **No Dependencies**: Zero reliance on IDE-specific features

## Language-Specific Validation

### JavaScript/TypeScript
**Primary**: Use standard linters
```bash
# JavaScript
npx eslint . --ext .js,.jsx
node -c file.js  # Syntax check fallback

# TypeScript  
npx tsc --noEmit
npx eslint . --ext .ts,.tsx
```

**Fallback**: Manual syntax verification
- Check for balanced braces, brackets, parentheses
- Verify semicolons and commas
- Confirm import/export syntax

### Python
**Primary**: Use standard linters
```bash
python -m py_compile file.py  # Syntax check
pylint *.py                   # Style and errors
flake8 *.py                   # Style guide enforcement
```

**Fallback**: Manual syntax verification
- Check indentation consistency
- Verify colon placement after if/for/def/class
- Confirm parentheses matching

### Markdown
**Primary**: Use standard tools
```bash
markdownlint *.md
# Or basic validation
find . -name "*.md" -exec echo "Checking {}" \;
```

**Fallback**: Manual verification
- Check link syntax [text](url)
- Verify header hierarchy (# ## ###)
- Confirm code block formatting

### Shell Scripts
**Primary**: Use built-in validation
```bash
# Bash
bash -n script.sh

# PowerShell
powershell -NoProfile -Command "& { . ./script.ps1; exit 0 }"
```

**Fallback**: Manual verification
- Check shebang line (#!/bin/bash)
- Verify variable syntax ($VAR vs ${VAR})
- Confirm command substitution syntax

## Cross-Platform Implementation

### Bash Implementation
```bash
#!/bin/bash
validate_universal() {
    local exit_code=0
    
    # Detect available tools
    command -v eslint >/dev/null 2>&1 && HAS_ESLINT=1
    command -v pylint >/dev/null 2>&1 && HAS_PYLINT=1
    command -v tsc >/dev/null 2>&1 && HAS_TSC=1
    
    # JavaScript/TypeScript validation
    if find . -name "*.js" -o -name "*.ts" | grep -q .; then
        if [[ $HAS_ESLINT ]]; then
            echo "Running ESLint..."
            npx eslint . --ext .js,.jsx,.ts,.tsx || exit_code=1
        else
            echo "ESLint not available, using basic syntax check..."
            find . -name "*.js" -exec node -c {} \; || exit_code=1
        fi
    fi
    
    # Python validation
    if find . -name "*.py" | grep -q .; then
        if [[ $HAS_PYLINT ]]; then
            echo "Running PyLint..."
            pylint *.py || exit_code=1
        else
            echo "PyLint not available, using basic syntax check..."
            find . -name "*.py" -exec python -m py_compile {} \; || exit_code=1
        fi
    fi
    
    return $exit_code
}
```

### PowerShell Implementation
```powershell
function Validate-Universal {
    $exitCode = 0
    
    # Detect available tools
    $hasEslint = Get-Command eslint -ErrorAction SilentlyContinue
    $hasPylint = Get-Command pylint -ErrorAction SilentlyContinue
    $hasTsc = Get-Command tsc -ErrorAction SilentlyContinue
    
    # JavaScript/TypeScript validation
    $jsFiles = Get-ChildItem -Recurse -Include *.js,*.ts,*.jsx,*.tsx
    if ($jsFiles) {
        if ($hasEslint) {
            Write-Host "Running ESLint..."
            npx eslint . --ext .js,.jsx,.ts,.tsx
            if ($LASTEXITCODE -ne 0) { $exitCode = 1 }
        } else {
            Write-Host "ESLint not available, using basic syntax check..."
            foreach ($file in $jsFiles) {
                node -c $file.FullName
                if ($LASTEXITCODE -ne 0) { $exitCode = 1 }
            }
        }
    }
    
    # Python validation
    $pyFiles = Get-ChildItem -Recurse -Include *.py
    if ($pyFiles) {
        if ($hasPylint) {
            Write-Host "Running PyLint..."
            pylint *.py
            if ($LASTEXITCODE -ne 0) { $exitCode = 1 }
        } else {
            Write-Host "PyLint not available, using basic syntax check..."
            foreach ($file in $pyFiles) {
                python -m py_compile $file.FullName
                if ($LASTEXITCODE -ne 0) { $exitCode = 1 }
            }
        }
    }
    
    return $exitCode
}
```

## Environment Detection

### Tool Availability Check
```bash
# Bash
check_tools() {
    echo "=== Tool Availability ==="
    command -v node >/dev/null 2>&1 && echo "✓ Node.js available" || echo "✗ Node.js not found"
    command -v python >/dev/null 2>&1 && echo "✓ Python available" || echo "✗ Python not found"
    command -v eslint >/dev/null 2>&1 && echo "✓ ESLint available" || echo "✗ ESLint not found"
    command -v pylint >/dev/null 2>&1 && echo "✓ PyLint available" || echo "✗ PyLint not found"
    echo "========================="
}
```

```powershell
# PowerShell
function Test-Tools {
    Write-Host "=== Tool Availability ==="
    if (Get-Command node -ErrorAction SilentlyContinue) { Write-Host "✓ Node.js available" } else { Write-Host "✗ Node.js not found" }
    if (Get-Command python -ErrorAction SilentlyContinue) { Write-Host "✓ Python available" } else { Write-Host "✗ Python not found" }
    if (Get-Command eslint -ErrorAction SilentlyContinue) { Write-Host "✓ ESLint available" } else { Write-Host "✗ ESLint not found" }
    if (Get-Command pylint -ErrorAction SilentlyContinue) { Write-Host "✓ PyLint available" } else { Write-Host "✗ PyLint not found" }
    Write-Host "========================="
}
```

## Manual Verification Fallbacks

When no automated tools are available, use these manual verification steps:

### General File Validation
1. **Encoding**: Ensure files are UTF-8 with LF line endings
2. **Structure**: Check file organization matches expected patterns
3. **Naming**: Verify file names follow project conventions

### Code Quality Checks
1. **Syntax**: Read through code for obvious syntax errors
2. **Consistency**: Check indentation and formatting consistency
3. **Logic**: Verify basic logic flow and error handling

### Documentation Validation
1. **Links**: Test all links work and point to correct resources
2. **Format**: Check markdown syntax and structure
3. **Content**: Verify information is accurate and up-to-date

## Integration with GSD Workflows

### In Execute Workflow
```markdown
## Validation Step
1. Run universal validation: `./scripts/validate-universal.sh`
2. If validation fails: Fix issues before proceeding
3. If tools unavailable: Use manual verification checklist
4. Document validation method used in commit message
```

### In Verify Workflow
```markdown
## Verification Requirements
- [ ] Universal validation passes (or manual verification complete)
- [ ] Cross-platform compatibility confirmed
- [ ] No IDE-specific dependencies introduced
- [ ] Clear error messages when tools unavailable
```

## Error Handling

### When Tools Unavailable
```
⚠ Advanced validation tools not available
📋 Using manual verification checklist
✓ Basic syntax validation complete
💡 Install eslint/pylint for enhanced validation
```

### When Validation Fails
```
❌ Validation failed: 3 issues found
📁 Files with issues: src/main.js, docs/README.md
🔧 Fix issues and re-run validation
📖 See manual verification guide if tools unavailable
```

## Success Criteria

This protocol succeeds when:
- Works identically in any environment (terminal, IDE, web)
- Provides clear feedback with or without advanced tools
- Maintains cross-platform compatibility
- Requires zero IDE-specific features
- Enables confident code quality validation anywhere