# think

A skill that makes you design a new project or feature before an agent writes any of it.

The agent interviews you one question at a time and writes your answers to `docs/thinking/`. It does not design for you, and it does not implement until the record is a contract with a go you actually said.

## Install

```sh
git clone https://github.com/haroon0x/think.git
cd think
./install.sh
```

Start a new DeepSeek Harness session and type `/think <your idea>`.

`./install.sh check` validates the skill and reports install state. `./install.sh uninstall` removes only what it installed.

## What it produces

A design record at `docs/thinking/YYYY-MM-DD-<slug>.md`, with seven slots asked in this order.

| Slot | Question |
|---|---|
| Problem | What breaks today, and for whom |
| Proof | The smallest observable behavior that shows it works |
| Shape | The nouns, their fields, who owns each, what changes together |
| Invariant | The state that must never exist |
| Fence | What this explicitly does not do |
| Riskiest assumption | What must be true, and the cheapest way to falsify it |
| Tension | The decision you are least sure of, and the alternative |

An example record from a dry run is in [`demo/`](demo/design-record.example.md).

The record has two states. `Status: thinking` is not a contract. It becomes `contract` only when Problem, Proof, Shape, Invariant, and Fence are answered and you said go in words the record quotes. Implementation then has to hold to those answers. When code has to depart, the agent appends a row to `Divergence log` before writing the departing code, and you accept or reject the row.

If you say "you decide", the agent offers two options with one tradeoff line each, asks which and why, then records your pick and reason as `delegated`. It never picks for you.

## Repo side

Copy [`AGENTS.snippet.md`](AGENTS.snippet.md) into a repo's `AGENTS.md` so future agents read the record before implementing.

## Pairs with

[grasp](https://github.com/haroon0x/grasp) for the other direction, understanding code that already exists.

## License

MIT. See [LICENSE](LICENSE).
