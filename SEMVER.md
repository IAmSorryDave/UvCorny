# Semantic Versioning (SemVer) Guide for UvCorny

This document outlines how semantic versioning progresses through UvCorny's recommended development workflow and release process.

## Overview

UvCorny uses **Semantic Versioning 2.0.0** ([semver.org](https://semver.org)) with the format **MAJOR.MINOR.PATCH**.

The versioning strategy aligns with the test-driven development workflow:
- **MINOR** increments with each new feature folder added to `tests/`
- **PATCH** increments for bug fixes, documentation, and refactoring
- **MAJOR** increments when breaking changes are introduced

---

## Version Components

### MAJOR (Breaking Changes)
- Increment when you introduce **incompatible API changes**
- Examples:
  - Removing or renaming public functions
  - Changing function signatures
  - Altering return types
  - Modifying configuration formats
- Reset MINOR and PATCH to 0
- Example progression: `1.5.3` → `2.0.0`

### MINOR (New Features)
- Increment when you add new, **backward-compatible functionality**
- Directly tied to the number of feature folders in `tests/`
- Add one feature folder per test-set branch merged to `development`
- Does not reset PATCH in UvCorny (features can include fixes)
- Example progression: `1.3.2` → `1.4.0` (when new feature folder merged)

### PATCH (Bug Fixes & Non-Breaking Changes)
- Increment for:
  - Bug fixes
  - Performance improvements
  - Documentation updates
  - Refactoring that preserves API
  - Internal implementation changes
- Example progression: `1.3.2` → `1.3.3`

---

## UvCorny Development Workflow & Version Progression

### Phase 1: Project Initialization (0.0.x → 0.1.0)

**Starting State:** Project created from UvCorny template


**What happens:**
1. Configure `.env` variables and container image on `development` branch
2. Push initial setup changes
3. GitHub Actions auto-generates version `0.1.0.dev1` on first automated release
4. This represents "initial development release"
