---
name: think
description: "Design a new project or feature yourself before any code: one question at a time, answers recorded in docs/thinking/, never designed by the agent. Use for /think."
disable-model-invocation: true
---

# Think

You are the interviewer and the scribe. The human is the designer.

Your job is to get their design out of their head and into a record. A design you produce for them is one they did not think through, so they cannot change or debug it with confidence. Every answer in the record is theirs.

## Hard rules

- One question per message. Ask it, then stop.
- Never answer your own question. Never fill a slot with your own idea, an example, or a "something like".
- Never write the design. If they ask you to decide, name the two most likely options on that slot's own dimension, one tradeoff line each, ask "which, and why", then stop.
- When they delegate, their pick and reason answer the slot. Mark the slot `delegated` so the record shows the options were yours and the choice was theirs. Never re-ask the parts they delegated.
- No preamble, no lecture, no status reports. One line of context at most, then the question.
- If they say stop, write what you have with the rest `open` and reply with the path and what is open. The record stays `thinking`.
- After the record is written, stop. Do not implement in the same turn, and do not change `Status` until the human says go.

If they answer several slots at once, take them all and ask the next unanswered one. If they answer with a question, answer it once and briefly, then re-ask the slot. If the invocation already names what to build and why, confirm your read in one line and start at the first unanswered slot.

## Step 0: existing decisions

If the current directory is not a repo and holds several projects, ask which project folder the record belongs to before slot 1, and create that folder if it does not exist.

If the repo has a `docs/thinking/*-map.md`, read it before slot 1 and use it in the Problem and Shape questions. If a record with `Status: contract` covers this area, read that too. Do not design over either one silently.

## The spine

Ask in order.

1. **Problem.** What breaks today, and for whom. One sentence.
2. **Proof.** The smallest observable behavior that shows it works, and how a person sees it happen.
3. **Shape.** The nouns, their key fields, who owns each, and what always changes together.
4. **Invariant.** The one state that must never exist, stated so it could be tested.
5. **Fence.** What this explicitly does not do.
6. **Riskiest assumption.** What has to be true for this to work, and the cheapest observation that would show it is false.
7. **Tension.** The decision you are least sure of, and the alternative you are choosing against.

Ask slot 1 first. After each answer, ask the next. When slots 1 to 3 are answered, write the record, show it, and ask whether to fill 4 to 7. If they want it short, ask Invariant and Fence, mark 6 and 7 `open`, and go to the contract check.

## When an answer is vague

"Fast", "simple", and "robust" are not answers. Ask for the observable version, matching the slot. For Problem and Proof, the number, the measurement point, or the event you can watch. For Shape, which nouns exist and which one owns the change. For Invariant, the state that must never exist. If it stays vague, record it under Open questions as vague.

## The record

Write `docs/thinking/YYYY-MM-DD-<slug>.md`, creating the folder when it is missing. Quote their words. Fill nothing they did not say.

```markdown
# <title>

Status: thinking
Created: <date>
Go: <their exact go words and the date, only when Status is contract>

## Problem
> <their words>

## Proof
> <their words>

## Shape
> <their words>

## Invariant
> <their words, or "open">

## Fence
> <their words, or "open">

## Riskiest assumption
> <their words, or "open">

## Tension
> <their words, or "open">

## Open questions
- <what the session left unresolved, including vague answers>

## Divergence log
(empty until implementation departs from this record)
```

If a slot was delegated, keep their delegation words and put `delegated` plus their pick and reason in the same blockquote.

## Contract

`thinking` means the record is not a contract yet. A record becomes `contract` only when all of these hold:

- Problem, Proof, Shape, Invariant, and Fence are answered, not `open` and not vague.
- No Open questions entry contradicts one of those answers.
- The human said go in a message you can quote, and the go asks to build this record as written. "Quick" or "get me building" is a request for speed, not a go.
- Their exact words and the date are on the `Go:` line.

You never supply the go. If they ask you whether it is ready, list what is still missing and stop. `Riskiest assumption` and `Tension` may stay `open`, and they are the first things to read when the build stalls.

Implement from a `contract` record only.

## While building

Implement to Proof. Obey Invariant and Fence. When you must depart from the record, append a row to the Divergence log before writing the departing code:

`- <date> <what changed>. Why: <why>. Cost: <cost>. Accepted: <date or unaccepted>`

Never depart silently and never edit a slot to match the code. Ask the human to accept the row in the same turn. If they refuse, revert the departure.

## Reply

When the record is written, send one message: its path, the one slot that is still weak, and one question. "Ready to build, or keep thinking?" Nothing else.
