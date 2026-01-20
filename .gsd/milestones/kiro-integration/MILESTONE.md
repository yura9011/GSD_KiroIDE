---
name: kiro-integration
version: v2.0
status: planning
created: 2026-01-20T00:00:00Z
target_date: 2026-02-15
---

# Milestone: Kiro Integration

## Vision

Modernizar el framework GSD para aprovechar las capacidades nativas de Kiro IDE, transformándolo de un sistema basado en comandos simples a un framework inteligente con auto-validación, gestión de contexto avanzada, y herramientas ejecutables. Este milestone integra Hooks, Skills, Subagents y Slash Commands para crear un sistema de desarrollo más robusto y eficiente.

## Must-Haves

Non-negotiable deliverables for this milestone:

- [ ] Sistema de Hooks para auto-validación (PostToolUse) en fase /execute
- [ ] Skills ejecutables que reemplacen templates estáticos
- [ ] Subagentes para operaciones que consumen mucho contexto (/map, /research-phase)
- [ ] Hooks PreToolUse para enforcement de Planning Lock
- [ ] Documentación actualizada con ejemplos de Kiro
- [ ] Scripts de validación embebidos en Skills
- [ ] Migración de comandos GSD a formato Kiro-compatible

## Nice-to-Haves

If time permits:

- [ ] Paralelización de verificaciones usando subagentes
- [ ] Hooks de notificación para eventos importantes
- [ ] Skills visuales (generación de diagramas de arquitectura)
- [ ] Integración con MCP para herramientas externas
- [ ] Dashboard interactivo de progreso del proyecto

## Phases

| Phase | Name | Status | Objective |
|-------|------|--------|-----------|
| 1 | Hooks Foundation | ⬜ Not Started | Implementar sistema de hooks para auto-validación y enforcement de reglas |
| 2 | Skills Migration | ⬜ Not Started | Convertir templates a Skills ejecutables con scripts embebidos |
| 3 | Subagent Integration | ⬜ Not Started | Implementar subagentes para operaciones de alto contexto |
| 4 | Command Modernization | ⬜ Not Started | Actualizar comandos GSD a formato Slash Commands de Kiro |
| 5 | Documentation & Testing | ⬜ Not Started | Documentar nuevas capacidades y validar integración completa |

## Success Criteria

How we know milestone is complete:

- [ ] Hooks de validación funcionan automáticamente en /execute
- [ ] Planning Lock se enforza mediante hooks PreToolUse
- [ ] /map y /research-phase usan subagentes con context:fork
- [ ] Al menos 5 Skills con scripts ejecutables funcionando
- [ ] Todos los comandos GSD funcionan en Kiro
- [ ] Documentación completa con ejemplos prácticos
- [ ] Tests de integración pasando
- [ ] Zero errores de sintaxis en código generado (gracias a hooks)

## Architecture Decisions

Key technical decisions for this milestone:

| Decision | Choice | Rationale |
|----------|--------|-----------|
| Hook Storage | `.kiro/hooks/` en proyecto | Portabilidad y versionado con git |
| Skills Location | `.kiro/skills/` para proyecto, `~/.kiro/skills/` para usuario | Separación entre skills compartidos y personales |
| Subagent Scope | Project-level en `.kiro/agents/` | Compartir configuraciones con el equipo |
| Validation Scripts | Python para validaciones complejas | Multiplataforma y fácil de mantener |
| Template Migration | Mantener templates como referencia | Transición gradual sin romper workflows existentes |

## Risks

| Risk | Likelihood | Impact | Mitigation |
|------|------------|--------|------------|
| Curva de aprendizaje de nuevas features | High | Medium | Documentación exhaustiva con ejemplos prácticos |
| Incompatibilidad con versiones anteriores | Medium | High | Mantener comandos legacy funcionando en paralelo |
| Hooks mal configurados causan bloqueos | Medium | High | Validación de configuración en startup + modo debug |
| Subagentes consumen demasiado contexto | Low | Medium | Límites de tokens y auto-compaction configurables |
| Scripts de validación fallan en Windows | Medium | Medium | Testing cross-platform y scripts PowerShell alternativos |

## Progress Log

| Date | Event | Notes |
|------|-------|-------|
| 2026-01-20 | Milestone created | Research completo en carpeta resarch/ |
