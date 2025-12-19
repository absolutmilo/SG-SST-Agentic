# Repository Guidelines

## Project Structure & Module Organization
- `backend/` holds the FastAPI app, `agents/`, `orchestrator/`, `prompts/`, `rag/`, and config in `config.toml`; `uploads/` and `logs/` store run artifacts.
- `frontend/` is a Vue 3 + Vite app; main code lives in `src/` with routing, stores, and views.
- `tests/` contains backend integration tests (pytest). `documents/`, `BD/`, and `vector/` hold reference assets and embeddings; keep them out of version control unless needed.

## Build, Test, and Development Commands
- One-step dev: run `./start-dev.ps1` (starts backend on 8000 and frontend on 5173); stop with `./stop-dev.ps1`.
- Backend setup: `cd backend && python -m venv .venv && .\.venv\Scripts\activate && pip install -r requirements.txt`.
- Backend dev server: `cd backend && .\.venv\Scripts\activate && uvicorn api.main:app --reload`.
- Frontend: `cd frontend && npm install && npm run dev` for local, `npm run build` for production, `npm run lint` / `npm run format` for style checks.
- Container option: `docker-compose up` to bring up services defined in `docker-compose.yml`.

## Coding Style & Naming Conventions
- Python: type-hint functions, keep modules and variables snake_case, and align Pydantic models with DB schema names. Prefer small, single-purpose functions and keep agent tool names descriptive.
- JavaScript/Vue: follow ESLint + Prettier via `npm run lint`/`npm run format`; use PascalCase for components and camelCase for state/actions. Keep composables in `src/composables/` and shared UI in `src/components/`.
- Config: copy `.env.agentic.example` to `.env` and never commit secrets; mirror settings in `backend/config.toml`.

## Testing Guidelines
- Backend: run `python -m pytest tests` from the repo root (ensures env vars are loaded); add new tests under `tests/` mirroring module paths. Name files `test_*.py` and use fixtures instead of hitting live SQL when possible.
- Frontend: no automated suite is configured yet; add vitest before contributing UI-heavy changes, and include snapshots or screen recordings for visual updates.

## Commit & Pull Request Guidelines
- Commits: short, imperative subjects (max ~72 chars), e.g., "Add risk agent SQL tool". Group related backend/frontend changes together when they touch the same feature.
- PRs: include what changed, why, how to test, and affected endpoints/UI; link backlog items. Add screenshots or GIFs for UI changes and note any config or migration steps.
- Checklist: tests passing, lint/format run, .env/.venv artifacts excluded, and documentation updated when behavior or APIs change.

## Security & Configuration Tips
- Keep OpenAI keys, DB credentials, and JWT secrets in local `.env` only. Do not log sensitive payloads; prefer redacted logs in `backend/logs/`.
- Validate inputs at API boundaries (FastAPI dependencies) before invoking agents or tools, and prefer least-privilege DB roles for new queries.
