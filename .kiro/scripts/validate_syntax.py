#!/usr/bin/env python3
"""
Syntax Validation Hook

Validates code syntax after file edits, creating the "auto-correction loop".
This is a PostToolUse hook that runs after Write/Edit operations.
"""

import sys
import os
import subprocess
import json as json_module

# Add utils to path
sys.path.insert(0, os.path.join(os.path.dirname(__file__), 'utils'))

from hook_input import read_hook_input, get_file_path


def validate_python(file_path):
    """Validate Python syntax using py_compile."""
    try:
        result = subprocess.run(
            [sys.executable, "-m", "py_compile", file_path],
            capture_output=True,
            text=True,
            timeout=5
        )
        if result.returncode != 0:
            return False, result.stderr
        return True, None
    except subprocess.TimeoutExpired:
        return False, "Validation timeout"
    except Exception as e:
        return None, f"Validator error: {e}"


def validate_json(file_path):
    """Validate JSON syntax."""
    try:
        with open(file_path, 'r', encoding='utf-8') as f:
            json_module.load(f)
        return True, None
    except json_module.JSONDecodeError as e:
        return False, f"Line {e.lineno}: {e.msg}"
    except Exception as e:
        return None, f"Validator error: {e}"


def validate_markdown(file_path):
    """Basic Markdown structure check."""
    try:
        with open(file_path, 'r', encoding='utf-8') as f:
            content = f.read()
        
        # Basic checks
        if not content.strip():
            return False, "File is empty"
        
        # Check for common issues
        lines = content.split('\n')
        for i, line in enumerate(lines, 1):
            # Check for unclosed code blocks
            if line.strip().startswith('```'):
                # Count code block markers
                count = content.count('```')
                if count % 2 != 0:
                    return False, f"Unclosed code block (found {count} markers)"
        
        return True, None
    except Exception as e:
        return None, f"Validator error: {e}"


def get_validator(file_path):
    """Get appropriate validator based on file extension."""
    ext = os.path.splitext(file_path)[1].lower()
    
    validators = {
        '.py': validate_python,
        '.json': validate_json,
        '.md': validate_markdown,
        '.markdown': validate_markdown,
    }
    
    return validators.get(ext)


def main():
    """Validate syntax of edited file."""
    
    # Read hook input
    hook_data = read_hook_input()
    file_path = get_file_path(hook_data)
    
    if not file_path:
        sys.exit(0)  # No file path, nothing to validate
    
    # Check if file exists
    if not os.path.exists(file_path):
        sys.exit(0)  # File doesn't exist yet, skip validation
    
    # Get validator for this file type
    validator = get_validator(file_path)
    
    if not validator:
        # No validator for this file type, skip
        sys.exit(0)
    
    # Run validation
    is_valid, error_msg = validator(file_path)
    
    if is_valid is None:
        # Validator not available or error running it
        print(f"Warning: {error_msg}", file=sys.stderr)
        sys.exit(0)  # Don't block on validator errors
    
    if not is_valid:
        # Validation failed - block and report error
        error_output = f"""Syntax Error in {os.path.basename(file_path)}:
{error_msg}

Fix the syntax error and try again."""
        
        print(error_output, file=sys.stderr)
        sys.exit(2)  # Exit code 2 blocks and feeds error to Claude
    
    # Validation passed
    sys.exit(0)


if __name__ == "__main__":
    main()
