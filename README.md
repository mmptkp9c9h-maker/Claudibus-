# Claudibus

Personal configuration for Claude Code plugins.

## Installed plugins

### Banana Claude

[AgriciDaniel/banana-claude](https://github.com/AgriciDaniel/banana-claude) — brief-led image
generation, editing, review, and bounded multi-model orchestration with Google Gemini image
models.

`.claude/settings.json` registers the `banana-claude-marketplace` and enables the
`banana-claude` plugin. When you open this repository in Claude Code (2.1.199+) and trust the
folder, the marketplace and plugin are picked up automatically — no manual `/plugin` commands
needed.

Requirements:

- Python 3.11+ with `python3` on `PATH`
- A Gemini API key for a billing-enabled Google AI project

On first use, Claude Code will prompt for the plugin's `google_ai_api_key` setting (stored as a
sensitive value, never committed here). Then ask for an image:

```text
/banana-claude:banana generate an urban 16:9 GitHub hero with clean left-side copy space
```

Banana Claude plans offline first and requires explicit approval before any paid request. See
the [upstream README](https://github.com/AgriciDaniel/banana-claude#readme) and
[SECURITY.md](https://github.com/AgriciDaniel/banana-claude/blob/main/SECURITY.md) for the full
workflow, cost controls, and privacy details.
