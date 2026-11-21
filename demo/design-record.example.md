<!-- Dry-run output, prompts v1, 2026-11-21. Seeded human answers, not a real session.
     Kept as evidence of the record format: delegation, pick, reason, and open slots. -->

# thinkloop status

Status: thinking
Created: 2026-11-21

## Problem
> I can't tell which of my repos have thinking records or which maps are stale without opening each docs/thinking folder. I notice this at the start of a work session.

## Proof
> Running `thinkloop status` from /home/g/dev/projects prints one line per repo that has a record: repo, kind (design or map), newest file, and STALE when a map's Verified at is behind HEAD. I see it in the terminal.

## Shape
> you decide the data shape, I don't care
>
> Asked to pick between two options, chose: "scan the files each run, no cache, there are under 20 repos" — "a cache is one more thing that can be wrong"

## Invariant
> open

## Fence
> open

## Riskiest assumption
> open

## Tension
> open

## Open questions
- Shape was delegated, not stated. The only structure they gave is the mechanism (scan each run, no cache) and the reason (a cache is one more thing that can be wrong). Nouns, key fields, ownership, and what always changes together are unanswered.
- The only field list in this record is the one in Proof: repo, kind (design or map), newest file, and STALE when a map's Verified at is behind HEAD.
- One line per repo, but a repo can hold a design and a map — unresolved whether that is one line or two.
- Slots 4 to 7 left open at their request ("quick, stop at three").

## Divergence log
(empty until implementation departs from this record)
