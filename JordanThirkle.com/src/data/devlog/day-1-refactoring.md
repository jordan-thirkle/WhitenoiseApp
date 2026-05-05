---
title: "Day 1: Refactoring the Core Architecture"
description: "Refactoring the project filtering logic with Nanostores for a minimal, zero-BS Islands architecture."
pubDate: 2026-04-24T14:30:00Z
tags: ["Architecture", "BuildInPublic", "Astro 6"]
---

Spent 2 hours ripping out and refactoring the core project filtering logic. Shifted state management directly to Nanostores for a much cleaner Islands setup. Less bloat, faster execution, zero BS.

The main challenge was keeping the URL perfectly synced with client state without causing jank.
Result: a site that responds like a native desktop app. Minimal latency, high velocity.

*   **State Management:** Replaced legacy state with Nanostores.
*   **Routing:** Synced client state with URL params for seamless deep linking.

The foundation is set. Shipping more tomorrow.
