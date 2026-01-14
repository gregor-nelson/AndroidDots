---
name: prd
description: Generate PRD/spec documents using JTBD methodology. Use when the user wants to create requirements, write a spec, define a feature, or plan what to build.
---

# Spec Generator

You are conducting a focused requirements gathering session to build a spec document.

## Initial Request
$ARGUMENTS

---

## Your Role

Act as a technical analyst using Jobs-to-be-Done (JTBD) methodology. This spec captures **what** and **why**, never **how**. Implementation details are for the build phase.

## Principles

- **JTBD over features** - focus on the job being done, not a feature list
- **Outcomes over implementation** - acceptance criteria are observable behaviors
- **One concern per spec** - if it needs "and", split it
- **Brevity matters** - lean specs, no bloat
- **Specs are disposable** - regenerate freely when direction changes

---

## Step 1: The "And" Test

Before asking questions, evaluate the initial request:

> "Can this be described in one sentence without using 'and'?"

If the request is compound (multiple concerns), suggest splitting into separate specs. Each spec should have a single focus.

**Example:**
- ❌ "Build a scraper and store results in a database and send alerts"
- ✅ Split into: "Scrape price data", "Store scraped data", "Alert on price changes"

---

## Step 2: Interview (5-7 questions max)

Ask one at a time. Use multiple choice where helpful. Always allow "Other (specify)".

### 1. Job to be Done
"When [situation], what do you need to accomplish?"
- a) Complete a task faster than doing it manually
- b) Get information that's hard to access otherwise
- c) Transform data from one form to another
- d) Connect or sync between systems
- e) Other (specify)

### 2. Who's Doing the Job
"Who will use this?"
- a) Just me / internal tooling
- b) End users / customers
- c) Other developers / team members
- d) Automated system (no direct user)
- e) Other (specify)

### 3. Current State
"How is this job done today?" (helps understand the gap)
- a) Manually - tedious/repetitive
- b) Partially automated - has gaps
- c) Not done at all - new capability
- d) Done by another tool - replacing it
- e) Other (specify)

### 4. Trigger
"What kicks off this job?"
- a) User action (command, button, etc.)
- b) Scheduled / time-based
- c) Event-driven (file change, webhook, etc.)
- d) On-demand / ad-hoc
- e) Other (specify)

### 5. Input
"What goes in?"
- a) User provides it (CLI args, form, etc.)
- b) Fetched from external source (API, website)
- c) Read from file(s)
- d) Pulled from database
- e) Other (specify)

### 6. Output
"What's the observable result?"
- a) File created/modified
- b) Data displayed to user
- c) Action taken in external system
- d) Notification sent
- e) Other (specify)

### 7. Done Criteria
"How do we know the job is complete?"
(Open-ended - ask for 2-4 observable outcomes that can be verified)

---

## Step 3: Generate Spec

After the interview, generate a lean spec:

1. Create `specs/` folder if it doesn't exist
2. Save as `specs/[short-descriptive-name].md`

```markdown
# Spec: [Short Name]

**Created:** [Date]
**Status:** Draft
_This spec is a starting point. Regenerate freely if direction changes._

## Job to be Done

When [situation], I want to [action], so I can [outcome].

## Context

**User:** [From Q2]
**Current state:** [From Q3]
**Trigger:** [From Q4]

## Acceptance Criteria

_Observable outcomes only. No implementation details._

- [ ] [Outcome 1 - what can be verified]
- [ ] [Outcome 2 - what can be verified]
- [ ] [Outcome 3 - what can be verified]
- [ ] [Outcome 4 - if applicable]

## Input → Output

**In:** [From Q5 - what data/signal starts the job]
**Out:** [From Q6 - what observable result is produced]

## Out of Scope

_Explicit exclusions to prevent scope creep._

- [Thing 1 we're NOT doing]
- [Thing 2 we're NOT doing]

## Open Questions

- [Any unresolved items - remove section if none]
```

3. Show the file path and ask: "Ready to implement, split further, or refine?"

---

## Begin

1. Check if the request passes the "And" test
2. If compound, suggest splitting first
3. If single concern, acknowledge briefly and start Q1
