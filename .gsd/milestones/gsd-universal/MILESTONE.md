---
milestone: gsd-universal
status: PLANNED
created_at: 2026-01-20
goal: Transform GSD into the first truly IDE-agnostic framework for AI development
---

# Milestone: GSD Universal

## Vision Statement

**Make GSD the universal standard for AI-assisted development, working seamlessly across ALL AI IDEs without modification.**

Transform GSD from "GSD for Kiro" to "GSD Universal" - a pure protocol that works identically in Kiro, Claude Code, Cursor, Windsurf, Antigravity, Codex, and any future AI IDE.

## The Problem

Currently, GSD has IDE-specific dependencies:
- Kiro's `getDiagnostics` for syntax checking
- Kiro's `invokeSubAgent` for parallel operations  
- Kiro-specific hooks and skills
- IDE-specific validation patterns

This limits adoption and creates vendor lock-in.

## The Solution

Create **GSD Universal Protocol** - a pure methodology that:
- Uses only common capabilities available in ALL AI IDEs
- Defines conventions instead of code dependencies
- Provides IDE-specific adapters without changing core
- Maintains 100% backward compatibility

## Success Vision

**By completion:**
- Any developer can use GSD in their preferred AI IDE
- GSD becomes the de facto standard for AI development methodology
- Zero vendor lock-in - switch IDEs without changing workflow
- Community adoption across all AI IDE ecosystems

## Must-Haves

### Core Protocol
- [ ] IDE-agnostic validation system (no getDiagnostics dependency)
- [ ] Universal subagent pattern (works without invokeSubAgent)
- [ ] Generic file structure (no .kiro/ dependencies)
- [ ] Cross-IDE workflow compatibility

### Universal Adapters
- [ ] Kiro adapter (maintains current functionality)
- [ ] Claude Code adapter
- [ ] Cursor/Windsurf adapter  
- [ ] Generic IDE adapter (fallback)

### Ralph Loop Universal
- [ ] Pure protocol-based Ralph (no CLI dependencies)
- [ ] Works natively in any AI IDE
- [ ] Self-executing within IDE context
- [ ] Universal prompt templates

### Documentation & Adoption
- [ ] GSD Universal specification
- [ ] Migration guide from IDE-specific to universal
- [ ] Community adoption toolkit
- [ ] Multi-IDE examples and tutorials

## Nice-to-Haves

- [ ] GSD Universal CLI for non-IDE environments
- [ ] Browser-based GSD interface
- [ ] Integration with popular code editors (VS Code, etc.)
- [ ] GSD Universal marketplace/registry
- [ ] Community plugin ecosystem

## Phases

### Phase 1: Core Protocol Abstraction
**Objective**: Extract IDE-agnostic core from current GSD

**Key Deliverables:**
- Universal validation protocol (replaces getDiagnostics)
- Generic subagent pattern (replaces invokeSubAgent)
- IDE-agnostic file structure
- Universal workflow definitions

### Phase 2: Adapter System
**Objective**: Create IDE-specific adapters that implement universal protocol

**Key Deliverables:**
- Kiro adapter (backward compatibility)
- Claude Code adapter
- Generic IDE adapter
- Adapter interface specification

### Phase 3: Ralph Universal
**Objective**: Transform Ralph Loop into pure protocol

**Key Deliverables:**
- Protocol-based Ralph (no external CLI)
- Self-executing within IDE context
- Universal prompt templates
- Cross-IDE compatibility

### Phase 4: Documentation & Migration
**Objective**: Enable community adoption across all IDEs

**Key Deliverables:**
- GSD Universal specification
- Migration guides for each IDE
- Community adoption toolkit
- Multi-IDE examples

### Phase 5: Community & Ecosystem
**Objective**: Establish GSD Universal as the standard

**Key Deliverables:**
- Community governance model
- Plugin/extension ecosystem
- Integration partnerships
- Adoption metrics and feedback

## Timeline

- **Phase 1**: 1 week (Core Protocol Abstraction)
- **Phase 2**: 1 week (Adapter System)
- **Phase 3**: 1 week (Ralph Universal)
- **Phase 4**: 1 week (Documentation & Migration)
- **Phase 5**: 2 weeks (Community & Ecosystem)

**Total**: ~6 weeks (Target: 2026-03-15)

## Success Metrics

### Technical Metrics
- GSD works identically in 5+ different AI IDEs
- Zero IDE-specific code in core GSD protocol
- 100% backward compatibility with existing projects
- <5 minute setup time in any new IDE

### Adoption Metrics
- Community adoption in 3+ different IDE ecosystems
- 10+ community contributions/adaptations
- Documentation translated to 3+ languages
- 95% user satisfaction across different IDEs

### Impact Metrics
- Becomes referenced standard for AI development methodology
- Reduces vendor lock-in for AI development teams
- Enables seamless IDE switching without workflow disruption
- Establishes GSD as platform-agnostic solution

## Dependencies

### Technical
- Complete understanding of common capabilities across AI IDEs
- Abstraction layer design for IDE-specific features
- Backward compatibility testing framework
- Multi-IDE testing environment

### Community
- Engagement with different IDE communities
- Documentation and tutorial creation
- Migration support for existing users
- Feedback collection and iteration

## Risks and Mitigations

### Technical Risks
- **Risk**: Some IDE-specific features can't be abstracted
- **Mitigation**: Create graceful degradation patterns and optional enhancements

- **Risk**: Performance loss from abstraction layer
- **Mitigation**: Optimize adapters and provide direct IDE integration where beneficial

### Adoption Risks
- **Risk**: Community resistance to change
- **Mitigation**: Maintain 100% backward compatibility and provide clear migration paths

- **Risk**: IDE vendors don't support standardization
- **Mitigation**: Focus on user value and community adoption to drive vendor support

## Revolutionary Impact

This milestone positions GSD to become:
- **The jQuery of AI development** - works everywhere, same API
- **The first truly portable AI methodology** - switch IDEs without changing workflow  
- **The community standard** - adopted across all AI IDE ecosystems
- **Future-proof foundation** - works with IDEs that don't exist yet

**This is our chance to create the universal standard for AI-assisted development.**