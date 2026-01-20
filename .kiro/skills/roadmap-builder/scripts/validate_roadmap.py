#!/usr/bin/env python3
"""
ROADMAP.md Validator

Validates ROADMAP.md structure and phase definitions.
"""

import sys
import os
import re

# Add skills utils to path
sys.path.insert(0, os.path.join(os.path.dirname(__file__), '..', '..', 'utils'))

from validator_base import SkillValidator


class RoadmapValidator(SkillValidator):
    """Validator for ROADMAP.md files."""
    
    def validate(self, file_path: str) -> bool:
        """
        Validate ROADMAP.md file.
        
        Args:
            file_path: Path to ROADMAP.md
            
        Returns:
            bool: True if valid, False otherwise
        """
        # Check file exists
        if not self.check_file_exists(file_path):
            self.report_error(f"File not found: {file_path}")
            return False
        
        # Read content
        try:
            with open(file_path, 'r', encoding='utf-8') as f:
                content = f.read()
        except Exception as e:
            self.report_error(f"Error reading file: {e}")
            return False
        
        # Check for milestone header
        if not re.search(r'\*\*Current Milestone\*\*:', content):
            self.report_error("Missing 'Current Milestone' header")
            self.report_error("Add: > **Current Milestone**: {name}")
            return False
        
        # Check for Must-Haves section
        if not self.check_section_exists(content, "Must-Haves"):
            self.report_error("Missing '## Must-Haves' section")
            return False
        
        # Check for Phases section
        if not self.check_section_exists(content, "Phases"):
            self.report_error("Missing '## Phases' section")
            return False
        
        # Check for at least one phase definition
        phase_pattern = r'###\s+Phase\s+\d+:'
        phases = re.findall(phase_pattern, content)
        if not phases:
            self.report_error("No phase definitions found")
            self.report_error("Expected format: ### Phase 1: {name}")
            return False
        
        # Check each phase has required fields
        phase_blocks = re.findall(
            r'###\s+Phase\s+\d+:.*?(?=###\s+Phase|\Z)',
            content,
            re.DOTALL
        )
        
        for i, phase in enumerate(phase_blocks, 1):
            if '**Status**:' not in phase:
                self.report_error(f"Phase {i} missing **Status** field")
                self.report_error(f"Add: **Status**: ⬜ Not Started")
                return False
            
            if '**Objective**:' not in phase:
                self.report_error(f"Phase {i} missing **Objective** field")
                self.report_error(f"Add: **Objective**: {description}")
                return False
        
        return True


if __name__ == "__main__":
    if len(sys.argv) < 2:
        print("Usage: validate_roadmap.py <roadmap-file>", file=sys.stderr)
        print("", file=sys.stderr)
        print("Example:", file=sys.stderr)
        print("  python validate_roadmap.py ROADMAP.md", file=sys.stderr)
        sys.exit(1)
    
    validator = RoadmapValidator()
    if validator.validate(sys.argv[1]):
        print("✓ ROADMAP.md validation passed")
        print(f"  Found {len(re.findall(r'###\\s+Phase\\s+\\d+:', open(sys.argv[1]).read()))} phases")
        print("  All required fields present")
        sys.exit(0)
    else:
        print("", file=sys.stderr)
        print("Fix the issues above and run validation again.", file=sys.stderr)
        sys.exit(1)
