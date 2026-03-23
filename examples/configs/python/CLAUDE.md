# Project Name

Brief description of the project and its purpose.

## Tech Stack

- **Python:** 3.11+
- **Framework:** FastAPI / Django / Flask / etc.
- **Testing:** pytest
- **Linting:** ruff, mypy

## Project Structure

- `src/` — Application source code
- `tests/` — Test files
- `docs/` — Documentation

## Development

```bash
python -m venv .venv && source .venv/bin/activate
pip install -e ".[dev]"
pytest                    # Run tests
ruff check .              # Lint
mypy src/                 # Type check
```

## Guidelines

- Type hints on all public functions
- All new code must have tests
- Follow existing patterns in `src/`
- Use `ruff` for formatting and linting

## Reference

For detailed information, see:
- Architecture: `docs/architecture.md`
- API: `docs/api.md`

---

*Keep this file concise. Reference documentation files instead of copying content.*
