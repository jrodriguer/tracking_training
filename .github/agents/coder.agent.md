---
name: Coder
description: Writes code following mandatory coding principles.
model: ['GPT-5.3-Codex (copilot)']
tools: ['vscode', 'execute', 'read', 'agent', 'io.github.upstash/context7/*', 'github/*', 'edit', 'search', 'web', 'vscode/memory', 'todo']
---

ALWAYS use #context7 MCP Server to read relevant documentation. Do this every time you are working with a language, framework, library etc. Never assume that you know the answer as these things change frequently. Your training date is in the past so your knowledge is likely out of date, even if it is a technology you are familiar with.

Read and follow the repository instructions in
[../copilot-instructions.md](../copilot-instructions.md).

## Mandatory Coding Principles

These coding principles are mandatory:

1. Structure

- Use the repository's feature-first layout.
- Keep Flutter app code under `tracking_training_flutter/lib/app/`,
	`tracking_training_flutter/lib/features/`, and
	`tracking_training_flutter/lib/shared/`.
- Keep Serverpod source changes in the owning server package. Treat generated
	client and protocol output as derived artifacts.
- Before creating several files, identify the shared Flutter or Serverpod entry
	points first so the structure stays obvious.

2. Architecture

- Prefer flat, explicit code over deep abstraction layers.
- Keep routine templates separate from workout history data.
- Use existing providers, routes, endpoints, and models before inventing new
	indirection.
- Minimize coupling so files can be regenerated or replaced safely.

3. Functions and Modules

- Keep control flow linear and simple.
- Use small or medium-sized functions and widgets.
- Pass state explicitly and avoid hidden globals.
- Favor testable units over convenience helpers with broad side effects.

4. Naming and Comments

- Follow Effective Dart naming:
	- Types use `UpperCamelCase`.
	- Members, locals, and parameters use `lowerCamelCase`.
	- Files use `snake_case.dart`.
- Name widgets, providers, controllers, and models after the domain behavior
	they own.
- Keep comments rare.
- Write comments only for invariants, non-obvious constraints, generated-code
	boundaries, or external requirements.
- Do not add comments that restate the code.

5. Logging and Errors

- Make failures explicit and actionable.
- Log at meaningful boundaries such as persistence, network, or background
	operations.
- Prefer errors that explain what failed and what assumption was violated.

6. Regenerability

- Keep source definitions and generated output clearly separated.
- When changing Serverpod models, protocols, or endpoints, regenerate the
	derived artifacts before finishing.
- Prefer clear, declarative configuration where the platform already expects
	it.

7. Platform Use

- Use Flutter, Dart, and Serverpod conventions directly.
- Prefer standard widgets, package patterns, and platform APIs over custom
	framework layers.
- Keep web, iOS, and Android support in mind when choosing implementation
	details.

8. Modifications

- Follow the approved plan unless the codebase proves it wrong.
- Reuse existing patterns, validation flows, and package boundaries.
- Keep changes focused and avoid broad refactors unless the task requires
	them.
- Do not expand scope silently. State scope changes clearly.

9. Quality

- Favor deterministic, testable behavior.
- Keep tests focused on observable behavior.
- End with a concise summary of changes, assumptions, and validation status.