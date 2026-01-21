# GSD Consolidated Validation Script
# Universal validation that works in any environment with any AI assistant

param(
    [switch]$All,
    [switch]$Code,
    [switch]$Workflows,
    [switch]$Skills,
    [switch]$Templates,
    [switch]$DryRun,
    [switch]$Help
)

# Colors for output (with fallback for environments without color support)
$Red = if ($Host.UI.SupportsVirtualTerminal) { "`e[31m" } else { "" }
$Green = if ($Host.UI.SupportsVirtualTerminal) { "`e[32m" } else { "" }
$Yellow = if ($Host.UI.SupportsVirtualTerminal) { "`e[33m" } else { "" }
$Blue = if ($Host.UI.SupportsVirtualTerminal) { "`e[34m" } else { "" }
$Reset = if ($Host.UI.SupportsVirtualTerminal) { "`e[0m" } else { "" }

# Global error counter
$script:TotalErrors = 0

function Show-Help {
    Write-Host "GSD Validation Script"
    Write-Host ""
    Write-Host "Usage: .\validate.ps1 [OPTIONS]"
    Write-Host ""
    Write-Host "Options:"
    Write-Host "  -All           Validate everything"
    Write-Host "  -Code          Validate code (JS, Python, etc.)"
    Write-Host "  -Workflows     Validate GSD workflows"
    Write-Host "  -Skills        Validate GSD skills"
    Write-Host "  -Templates     Validate GSD templates"
    Write-Host "  -DryRun        Show what would be validated without running"
    Write-Host "  -Help          Show this help"
    Write-Host ""
    Write-Host "Examples:"
    Write-Host "  .\validate.ps1 -All                    # Validate everything"
    Write-Host "  .\validate.ps1 -Code -Workflows        # Validate code and workflows only"
    Write-Host "  .\validate.ps1 -DryRun -All            # Show what would be validated"
}

function Test-Code {
    Write-Host "${Blue}=== Code Validation ===${Reset}"
    
    if ($DryRun) {
        Write-Host "Would validate: JavaScript, TypeScript, Python, Markdown, Shell scripts"
        return
    }
    
    $codeErrors = 0
    
    # Tool availability detection
    $hasNode = Get-Command node -ErrorAction SilentlyContinue
    $hasPython = Get-Command python -ErrorAction SilentlyContinue
    $hasEslint = $false
    $hasPylint = Get-Command pylint -ErrorAction SilentlyContinue
    
    try {
        $null = npx eslint --version 2>$null
        if ($LASTEXITCODE -eq 0) { $hasEslint = $true }
    } catch { }
    
    # JavaScript/TypeScript validation
    $jsFiles = Get-ChildItem -Recurse -Include *.js,*.jsx,*.ts,*.tsx | Where-Object { $_.FullName -notmatch "node_modules" } | Select-Object -First 20
    if ($jsFiles) {
        Write-Host "Validating JavaScript/TypeScript files..."
        if ($hasEslint) {
            try {
                npx eslint . --ext .js,.jsx,.ts,.tsx --ignore-path .gitignore 2>$null
                if ($LASTEXITCODE -eq 0) {
                    Write-Host "${Green}✓${Reset} ESLint validation passed"
                } else {
                    Write-Host "${Red}✗${Reset} ESLint validation failed"
                    $codeErrors++
                }
            } catch {
                Write-Host "${Red}✗${Reset} ESLint validation failed"
                $codeErrors++
            }
        } elseif ($hasNode) {
            Write-Host "ESLint not available, using basic Node.js syntax check..."
            foreach ($file in $jsFiles) {
                try {
                    node -c $file.FullName 2>$null
                    if ($LASTEXITCODE -eq 0) {
                        Write-Host "${Green}✓${Reset} $($file.Name)"
                    } else {
                        Write-Host "${Red}✗${Reset} $($file.Name) - syntax error"
                        $codeErrors++
                    }
                } catch {
                    Write-Host "${Red}✗${Reset} $($file.Name) - syntax error"
                    $codeErrors++
                }
            }
        } else {
            Write-Host "${Yellow}⚠${Reset} No JavaScript validation tools available"
        }
    }
    
    # Python validation
    $pyFiles = Get-ChildItem -Recurse -Include *.py | Where-Object { $_.FullName -notmatch "__pycache__" } | Select-Object -First 20
    if ($pyFiles) {
        Write-Host "Validating Python files..."
        if ($hasPylint) {
            try {
                $pyFilePaths = $pyFiles | ForEach-Object { $_.FullName }
                pylint @pyFilePaths 2>$null
                if ($LASTEXITCODE -eq 0) {
                    Write-Host "${Green}✓${Reset} PyLint validation passed"
                } else {
                    Write-Host "${Red}✗${Reset} PyLint validation failed"
                    $codeErrors++
                }
            } catch {
                Write-Host "${Red}✗${Reset} PyLint validation failed"
                $codeErrors++
            }
        } elseif ($hasPython) {
            Write-Host "PyLint not available, using basic Python syntax check..."
            foreach ($file in $pyFiles) {
                try {
                    python -m py_compile $file.FullName 2>$null
                    if ($LASTEXITCODE -eq 0) {
                        Write-Host "${Green}✓${Reset} $($file.Name)"
                    } else {
                        Write-Host "${Red}✗${Reset} $($file.Name) - syntax error"
                        $codeErrors++
                    }
                } catch {
                    Write-Host "${Red}✗${Reset} $($file.Name) - syntax error"
                    $codeErrors++
                }
            }
        } else {
            Write-Host "${Yellow}⚠${Reset} No Python validation tools available"
        }
    }
    
    # PowerShell script validation
    $ps1Files = Get-ChildItem -Recurse -Include *.ps1 | Select-Object -First 10
    if ($ps1Files) {
        Write-Host "Validating PowerShell scripts..."
        foreach ($file in $ps1Files) {
            try {
                $null = [System.Management.Automation.PSParser]::Tokenize((Get-Content $file.FullName -Raw), [ref]$null)
                Write-Host "${Green}✓${Reset} $($file.Name)"
            } catch {
                Write-Host "${Red}✗${Reset} $($file.Name) - syntax error"
                $codeErrors++
            }
        }
    }
    
    $script:TotalErrors += $codeErrors
    Write-Host ""
}
function Test-Workflows {
    Write-Host "${Blue}=== Workflow Validation ===${Reset}"
    
    if ($DryRun) {
        Write-Host "Would validate: .gsd/workflows/*.md files"
        return
    }
    
    $workflowErrors = 0
    $workflowsChecked = 0
    
    if (-not (Test-Path ".gsd/workflows")) {
        Write-Host "${Yellow}⚠${Reset} No .gsd/workflows directory found"
        return
    }
    
    $workflowFiles = Get-ChildItem ".gsd/workflows/*.md"
    foreach ($file in $workflowFiles) {
        $workflowsChecked++
        $filename = $file.Name
        $hasErrors = $false
        
        # Check for frontmatter
        $firstLine = Get-Content $file.FullName -First 1
        if ($firstLine -notmatch "^---") {
            Write-Host "${Red}✗${Reset} $filename`: Missing frontmatter"
            $workflowErrors++
            $hasErrors = $true
        }
        
        # Check for description
        $content = Get-Content $file.FullName -Raw
        if ($content -notmatch "description:") {
            Write-Host "${Red}✗${Reset} $filename`: Missing description in frontmatter"
            $workflowErrors++
            $hasErrors = $true
        }
        
        if (-not $hasErrors) {
            Write-Host "${Green}✓${Reset} $filename"
        }
    }
    
    Write-Host "Workflows checked: $workflowsChecked, Errors: $workflowErrors"
    $script:TotalErrors += $workflowErrors
    Write-Host ""
}

function Test-Skills {
    Write-Host "${Blue}=== Skills Validation ===${Reset}"
    
    if ($DryRun) {
        Write-Host "Would validate: .agent/skills/*/SKILL.md files"
        return
    }
    
    $skillErrors = 0
    $skillsChecked = 0
    
    if (-not (Test-Path ".agent/skills")) {
        Write-Host "${Yellow}⚠${Reset} No .agent/skills directory found"
        return
    }
    
    $skillDirs = Get-ChildItem ".agent/skills" -Directory
    foreach ($skillDir in $skillDirs) {
        $skillsChecked++
        $skillName = $skillDir.Name
        $skillFile = Join-Path $skillDir.FullName "SKILL.md"
        $hasErrors = $false
        
        # Check SKILL.md exists
        if (-not (Test-Path $skillFile)) {
            Write-Host "${Red}✗${Reset} $skillName`: Missing SKILL.md"
            $skillErrors++
            continue
        }
        
        # Check for frontmatter
        $firstLine = Get-Content $skillFile -First 1
        if ($firstLine -notmatch "^---") {
            Write-Host "${Red}✗${Reset} $skillName`: Missing frontmatter"
            $skillErrors++
            $hasErrors = $true
        }
        
        if (-not $hasErrors) {
            Write-Host "${Green}✓${Reset} $skillName"
        }
    }
    
    Write-Host "Skills checked: $skillsChecked, Errors: $skillErrors"
    $script:TotalErrors += $skillErrors
    Write-Host ""
}

function Test-Templates {
    Write-Host "${Blue}=== Templates Validation ===${Reset}"
    
    if ($DryRun) {
        Write-Host "Would validate: .gsd/templates/*.md files"
        return
    }
    
    $templateErrors = 0
    $templatesChecked = 0
    
    if (-not (Test-Path ".gsd/templates")) {
        Write-Host "${Yellow}⚠${Reset} No .gsd/templates directory found"
        return
    }
    
    $templateFiles = Get-ChildItem ".gsd/templates/*.md"
    foreach ($file in $templateFiles) {
        $templatesChecked++
        $filename = $file.Name
        $hasErrors = $false
        
        # Check for title (# heading)
        $firstLine = Get-Content $file.FullName -First 1
        if ($firstLine -notmatch "^# ") {
            Write-Host "${Red}✗${Reset} $filename`: Missing title (# heading)"
            $templateErrors++
            $hasErrors = $true
        }
        
        if (-not $hasErrors) {
            Write-Host "${Green}✓${Reset} $filename"
        }
    }
    
    Write-Host "Templates checked: $templatesChecked, Errors: $templateErrors"
    $script:TotalErrors += $templateErrors
    Write-Host ""
}

# Main execution
if ($Help) {
    Show-Help
    exit 0
}

# If -All is specified, enable all validations
if ($All) {
    $Code = $true
    $Workflows = $true
    $Skills = $true
    $Templates = $true
}

# If no specific validation requested, default to -All
if (-not ($Code -or $Workflows -or $Skills -or $Templates)) {
    $All = $true
    $Code = $true
    $Workflows = $true
    $Skills = $true
    $Templates = $true
}

Write-Host "${Blue}=== GSD Consolidated Validation ===${Reset}"
Write-Host "Environment: $($PSVersionTable.OS)"
Write-Host "PowerShell: $($PSVersionTable.PSVersion)"
Write-Host "Working Directory: $(Get-Location)"

if ($DryRun) {
    Write-Host "${Blue}=== DRY RUN MODE ===${Reset}"
}

Write-Host ""

if ($Code) { Test-Code }
if ($Workflows) { Test-Workflows }
if ($Skills) { Test-Skills }
if ($Templates) { Test-Templates }

# Summary
Write-Host "${Blue}=== Validation Summary ===${Reset}"
if ($DryRun) {
    Write-Host "${Blue}ℹ${Reset} Dry run completed - no actual validation performed"
} elseif ($script:TotalErrors -eq 0) {
    Write-Host "${Green}✓${Reset} All validations passed"
} else {
    Write-Host "${Red}✗${Reset} Validation failed with $($script:TotalErrors) error(s)"
}

exit $script:TotalErrors