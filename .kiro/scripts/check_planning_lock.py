#!/usr/bin/env python3
"""
Planning Lock Hook

Enforces GSD's Planning Lock rule - prevents code writes during planning phase.
This is a PreToolUse hook that blocks Write/Edit operations when in planning.
"""

import sys
import os

# Add utils to path
sys.path.insert(0, os.path.join(os.path.dirname(__file__), 'utils'))

from hook_input import read_hook_input, get_tool_name
from state_reader import read_state, is_planning_phase


def main():
    """Check if operation should be blocked due to Planning Lock."""
    
    # Read hook input
    hook_data = read_hook_input()
    tool_name = get_tool_name(hook_data)
    
    # Only check Write and Edit operations
    if tool_name not in ["Write", "Edit"]:
        sys.exit(0)  # Allow other operations
    
    # Check if in planning phase
    if is_planning_phase():
        state = read_state()
        status = state.get("status", "unknown")
        
        # Block the operation
        error_msg = f"""Planning Lock: Cannot write code during planning phase.
Current status: {status}
Complete SPEC.md and run /plan first."""
        
        print(error_msg, file=sys.stderr)
        sys.exit(2)  # Exit code 2 blocks the tool and feeds error to Claude
    
    # Allow the operation
    sys.exit(0)


if __name__ == "__main__":
    main()
