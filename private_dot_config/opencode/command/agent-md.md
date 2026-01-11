---
description: Create or modify AGENTS.md file with defaults
---

Create or modify the `AGENTS.md` file for this repository or folder. Check if input specifies a specific folder, otherwise assume PWD.

## output:AGENTS.md

# General
- Keep answers succinct and information-dense.  
- Be critical of ideas; call out flawed assumptions, missing information, or unnecessary complexity.  
- Prefer simplicity and incremental changes.  
- State uncertainty explicitly when information is incomplete.  
- Work in small steps and verify each change.  

# Tech Stack
*(Populated based on repository analysis.)*  
List key languages, frameworks, tools, and architectural conventions.  
Keep it high-level and stable—avoid details that change frequently.

# Build & Test
*(Derived from repository.)*  
Describe how to build and run tests. Include only what an AI assistant must know.  
Avoid volatile or tool-version-specific details.

## Testing Guidelines
- Default to TDD.  
- Prefer in-memory tests.  
- Run build and tests before and after modifications.

### ABC Test Categories
**A – Acceptance Tests**  
Validate that the system behaves correctly and is safe to ship. Prefer fast, in-memory execution.

**B – Building Tests**  
Temporary scaffolding used during TDD, debugging, or exploration. These tests are disposable.

**C – Communication Tests**  
Validate boundaries: mappings, SQL queries, schemas, API contracts. Keep these separate to avoid polluting acceptance tests.

Label tests by external dependencies (e.g., `database`, `open-ai-api`) to make execution constraints explicit.

# Repository Overview
*(Generated from repository structure.)*  
Provide a concise description of the repo and its layout.  
Highlight directories relevant to build, test, and development processes.

# Coding Guidelines
- Prefer simplicity.  
- Use pure functions; push I/O to the boundaries.  
- Apply functional programming where practical.  
- Use stratified design: assemble complex behaviour from smaller, simpler components.
- Run `build` and `test` before and after all code/config changes.

# Git Conventions
- Detect if worktrees are used.  
- Decide whether changes should be made in a new branch or a new worktree.  

---

<!-- The LLM must populate sections marked as “derived” or “generated” based on repository analysis. -->
