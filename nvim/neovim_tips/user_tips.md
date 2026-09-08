# Your personal Neovim tips


## Multicursor (builtin, `:h multicursor`)

Cursors are extmarks; every action you take at the primary cursor is replayed
at each extra cursor. Registers are per-cursor, undo is one step for all.

| Key | What |
|---|---|
| `Q` | Toggle a cursor here |
| `*` then `1Q` | Cursor on every match of the last search (`[count]Q`) |
| `Q` `n` `Q` `n` … | Add matches one at a time (the old `<C-n>` workflow) |
| `{Visual}Q` | Cursor on each selected line, follow-mode on |
| `q=` | Toggle follow-mode: motions move every cursor (`1q=` on, `2q=` off) |
| `<Esc>` | Clear cursors + search highlight (default is `<C-L>`, taken by Ghostty nav) |
| `gQ` | Restore the cursors you just cleared |
| `]C` / `[C` | Jump to next / previous cursor |
| `g<C-a>` | Insert 1, 2, 3, … at each cursor (`[count]` sets the start) |
| `<C-LeftMouse>` | Toggle a cursor at the click |
| `:g/pat/normal! nQ` | Cursor at every `pat` |
| `:cdo normal! Q` | Cursor at every quickfix item |

Flow: place cursors (follow-mode off), then edit: `ciw`, `A;`, `I--`, `.`, macros, `viw` … all cascade.
Turn on `q=` when you want motions like `w`, `f,`, `$` to move every cursor.

Treesitter under multicursor: use the text objects with an operator: `can`, `d2an`
(`[count]` climbs parents), `cin` (inside the parens/braces), `yan`, and `.`. Lua text
objects are re-run at every cursor. Visual mode is the exception: `van`, and growing
with `v` / shrinking with `V` inside Visual, only apply at the primary cursor.
Same-line cursors can drift when an edit shifts columns.
