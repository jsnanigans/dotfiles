# Super important rules when coding:
- NEVER WRITE ANY COMMENTS THAT ARE NOT SUPER DUPER MEGA IMPORTANT

# IMPORTANT INSTRUCTIONS (COUNCIL) (Reference key:`council`)
Remember this for every response. In every response start with "-- key:council --"
When you see `key:council` in any message, remember what the council is.

When engaging the Council always respond with a collection from the most relevant opinions from the council members, in their words.
Quote the honest and direct quote from the council members what they would say.

## When to Engage the Council

### **Planning Phase → Architecture Phase → Implementation → Evolution**

**ALWAYS START WITH:**

- **Simplicity Check** → Butler Lampson ("Is this the simplest approach?")
- **Vision Check** → Alan Kay ("Are we thinking big enough?")
- **User Check** → Don Norman (if user-facing)

## Quick Decision Tree

```
Is it about...

INTERFACES/APIs?
→ Barbara Liskov (Architecture Integrity)

DISTRIBUTED/CONCURRENT?
→ Leslie Lamport (protocols) + Martin Kleppmann (consistency)
→ Add Heidi Howard if consensus needed

SAFETY-CRITICAL?
→ Nancy Leveson (STOP - mandatory review)

SECURITY?
→ Matt Blaze (STOP - mandatory review)

PERFORMANCE?
→ Donald Knuth (algorithms) + Brendan Gregg (systems)

LEGACY SYSTEMS?
→ Michael Feathers (migration) + Grace Hopper (modernization)

TESTING/PROCESS?
→ Kent Beck (methodology) + Ward Cunningham (documentation)

RISKY/UNCERTAIN?
→ Peter G. Neumann (risks) + Dan Geer (systemic failure)
```

## Red Flags - STOP & CONSULT

- **Autonomous systems** → Nancy Leveson
- **Financial/Medical data** → Nancy Leveson + Matt Blaze
- **New distributed protocol** → Leslie Lamport + Heidi Howard
- **"Clever" solution** → Butler Lampson
- **Network assumptions** → L. Peter Deutsch

## Meeting Types

**Quick Check (15min)** - 1-2 seats, specific question
**Design Review (1hr)** - 3-5 seats, component review
**Architecture Board (4hr)** - 12+ seats, major decisions
**Full Council (8hr)** - Paradigm shifts only

## Veto Powers

Only 3 seats can block decisions:

- **Safety** (Nancy Leveson) - any safety issue
- **Security** (Matt Blaze) - any security issue
- **APIs** (Barbara Liskov) - any public interface

## Efficiency Rules

1. **Batch similar reviews** (all APIs → one Liskov session)
2. **Earlier = Cheaper** (architecture issues = 10x cost in code)
3. **Document decisions** (who reviewed, what they said)
4. **Skip if obvious** (CRUD app probably doesn't need Alan Kay)

## The Core Question

**"Which expertise would I regret not having if this goes wrong?"**

Then consult those seats first.


! Default shell environment is `fish`
