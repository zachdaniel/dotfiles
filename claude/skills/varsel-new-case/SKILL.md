---
name: varsel-new-case
description: Open a new draft CVE case in Varsel from a GitHub advisory or a pasted vulnerability report. Use when filing a new vulnerability with the Varsel MCP.
---

<!--
SPDX-FileCopyrightText: 2026 Erlang Ecosystem Foundation

SPDX-License-Identifier: Apache-2.0
-->

# New Varsel Case

File a new vulnerability as a draft case in Varsel using the `varsel` MCP tools. This assumes the
Varsel MCP server is already installed and authenticated (`/mcp`); see
<https://cna.erlef.org/api-access#mcp>. If the `mcp__varsel__*` tools are unavailable, stop and have
the user connect it first.

## Cases, facts, and proposals

The unit of work is a **case**. You describe the vulnerability as **facts** (commit SHAs, package
channels, references, credits, weaknesses, impacts) and Varsel **derives** the affected version
ranges from the commit SHAs and **renders** the CNA record. You do not write version ranges,
`cpeApplicability`, `programFiles` prefixes, or any CVE JSON by hand: state the facts, let the
server compute the record.

Every change to an opened case is a **proposal**. There is one typed `mcp__varsel__propose_*` tool
per thing you can change; pick the tool that names it:

`propose_title`, `propose_description`, `propose_discovery`, `propose_configurations`,
`propose_workarounds`, `propose_cvss`, `propose_weakness`, `propose_impact`, `propose_reference`,
`propose_credit`, `propose_affected_package` / `propose_otp_affected_package` /
`propose_elixir_affected_package` / `propose_gleam_affected_package`, `propose_package_channel`,
`propose_version_event`, `propose_delete`.

Each takes `case_id`, `reasoning`, and the typed fields for that one change. `propose_package_channel`
and `propose_version_event` (addressing the package by `target_id`) are only for extending a package
that has **already been accepted**, never for the initial insert.

**A human accepts or declines your proposals in the UI, out of band.** This can happen at any time
while you work, and you get no notification, so never assume a proposal is still open just because
you did not accept it. To see the true state use `list_case_proposals`, which returns proposals in
**all** states (open, accepted, declined). `list_open_case_proposals` shows only the still-open
ones, so an empty result there means "nothing left to accept", not "nothing was ever proposed".
Listings carry the proposed value rather than the author's reasoning; read that on a single
proposal with `get_case_proposal`.

You author proposals; you never self-approve them.

---

Work through the steps in order. Where a step says to check in, wait for the user in an interactive
session; when running autonomously, record the decision, continue, and surface it in the final
summary.

## Step 0 - Inputs

Accept either input, and never assume a GitHub advisory exists:

- **A pasted report.** Free-form text from a researcher. This is the common case. Use it directly.
- **A GHSA link or advisory URL.** Fetch it with `gh api /repos/<owner>/<repo>/security-advisories/<ghsa-id>`.

If the user pastes a report, still check whether a matching advisory exists on the repo
(`gh api /repos/<owner>/<repo>/security-advisories`) and match on the summary text. Reports and
advisories are frequently the same issue arriving by two routes, and the advisory carries the
credits and the vendor's own version range. Note its `state`: a `draft` advisory has no publicly
resolvable URL and usually still says `patched: TODO`, both of which block publishing later.

Advisory comments are not exposed by the API. If a GHSA is involved, ask the user to check the
advisory page for comments carrying a CVE number or handling instructions.

**Do not take the report's framing as final.** Reporters and advisory authors are often unfamiliar
with CVE conventions, so the scope, the severity, and the affected range often need correcting even
when the underlying finding is sound.

### Trusted or untrusted reports

**Always ask the user whether the report is "trusted" or "untrusted", before doing anything else, 
and never infer it.** The answer decides whether you reproduce the vulnerability, which is the 
single largest fork in this workflow.

Ask once, offering **trusted as the default**, because the vast majority of reports reaching this
workflow originate from the CNA itself and are already verified. Running autonomously with no
answer available, treat the report as trusted and say so in the final summary.

- **Trusted.** The bug and the fix have already been verified by a human, typically ours. Take the
  reported mechanism, the PoC, and the fix as given. **Do not reproduce anything.** No `Mix.install`
  harnesses, no running payloads, no proving the exploit.
- **Untrusted.** An external report nobody here has reproduced yet. **You must run and verify the
  PoC script before filing**, per Step 1.

Record which it was in a single clause of `internal_notes`, and for untrusted reports name the
outcome of your reproduction.

### Pull prior cases for this repository, before anything else

**Do this before any git archaeology, classification, or scoring.** It is the single largest time
saver in this workflow, and skipping it means re-deriving work that is already sitting in review.

**Search by repository, not by package name.** Establish the upstream repository URL first: a GHSA
carries it, and for a hex package it is in `meta.links` from
`curl -s https://hex.pm/api/packages/<package>`. That URL is the identifier cases are actually
keyed on.

Then filter `list_cases` on `affects_repo`, which matches against the repositories of the case's
affected packages:

```json
{"affects_repo": {"input": {"repo_url": "https://github.com/rrrene/html_sanitize_ex"}, "eq": true}}
```

**This filter takes the nested form above, not the flat `{"field", "operator", "value"}` shape**,
because the repository travels in `input` and the flat form has nowhere to put it. It nests inside
an `{"and": [...]}` group fine.

Fall back to `{"field": "description_md", "operator": "ilike", "value": "%<package>%"}` only when
you cannot establish a repository URL. That is a prose match, so it misses any case whose
description does not happen to name the package.

`list_cves_by_purl` and `search_cves` cover published records.

**Read the returned case rows before calling anything else.** They include full `internal_notes`,
which usually already carry the introducing commit, the first affected release, the release commit
inventory, and the CVSS shape. That is most of what you came for.

Only if you still need the affected-package payload shape or exact credit spellings, follow up with
`list_case_proposals` filtered to just those targets:
`{"field": "target", "operator": "in", "value": ["affected_package", "credit"]}`

Vulnerabilities in one library arrive in batches, especially when a single release fixes several
issues at once, so a sibling case very often already carries:

- the exact vendor, product, `repo_url`, CPE, and channel shape, ready to copy
- the reference set and its tagging
- a description whose length and depth is the target to match

Reuse all of it. Derive from scratch only what genuinely differs, and name the sibling you took a
value from in your proposal reasoning. **If a sibling establishes the introducing commit for the
same construct, Step 2 becomes a confirmation rather than an investigation.**

## Step 1 - Understand the report

### Trusted reports: do not reproduce

**The user verifies the bug and the fix independently. Do not reproduce either.** No `Mix.install`
harnesses, no running payloads, no proving the exploit. Take the reported mechanism, its PoC, and
the fix as given and spend the effort on what only the record needs.

This bans demonstrating the vulnerability, not examining the code. You still read the source, and
you still clone the repository for the git archaeology in Step 2.

The one exception is testing a candidate workaround, which is encouraged even here; see the
workarounds section under Optional fields.

### Untrusted reports: run the PoC first

**Nobody here has reproduced this yet, so you must, before any of the work below.** A report that
does not reproduce must not become a case.

Build a self-contained harness rather than touching the user's project. For Elixir, a single
`Mix.install/2` script pinned to a **vulnerable** version is the whole setup:

```elixir
Mix.install([{:the_package, "== <vulnerable-version>"}])
# minimal call path from the report, printing the observed result
```

Work in the scratchpad directory, never in the project tree.

- **Run it against a vulnerable version and confirm the reported behaviour actually occurs.** The
  report's own expected output is the thing you are checking, not the thing you assume.
- **Then run the same script against the fixed version** and confirm the behaviour is gone. That
  second run is what proves the fix boundary is where the report claims, and it is the half people
  skip.
- If the report ships no PoC, write the minimal one its mechanism implies, and say in the summary
  that the PoC is yours rather than the reporter's.
- Keep the harness minimal. It exists to answer one question, not to explore the library.

**If it does not reproduce, stop.** Do not open a case, do not propose anything, and report to the
user what you ran and what you observed instead. This applies to environmental failures too: a
harness you could not get running is an unreproduced report, so hand it back rather than filing on
the assumption that it would have worked. The user decides what happens next.

Once it reproduces, treat the finding as established and continue exactly as for a trusted report.

### Both

Read the vulnerable function and the fix commit closely enough to describe both accurately, then
settle these:

- **Scope.** One case is one vulnerability. If the report or the fix commits bundle several 
  distinct issues, split them and tell the user which ones need their own cases.
- **Reachability.** Which public entry points reach the vulnerable code. If only some do, that is a
  `configurations` entry and usually `AT:P` in the CVSS vector.
- **Impact ceiling.** Separate what the report demonstrates from what it speculates. Record the
  demonstrated impact and raise the gap with the user rather than inheriting the stronger claim.
  Overstating impact is worse than a low severity.
- **What the fix actually changed.** If the patch is narrower than the report, that shapes
  `solutions_md` and is worth flagging to the user.

**A trusted case reaching this workflow has already been through several rounds of human review, so
its validity as a CVE is settled. Do not re-litigate it, and do not stop to check in here.** For an
untrusted report, the reproduction above is what settles it, and once it reproduces the same rule
applies: carry on rather than checking in again. Note the
scope and impact calls in one line of `internal_notes`, only where they changed something, and
carry on to Step 2. Surface a finding mid-flight only
if something is genuinely wrong, such as the report bundling two distinct vulnerabilities.

## Step 2 - Version boundaries

**The introducing commit must be verified, never taken on trust, trusted report or not.** The bug
and the fix are settled by Step 1 either way, so this boundary is yours to establish, and neither
the reporter nor the advisory is authoritative about it.

**Stop as soon as the boundary is settled.** A pickaxe search (`git log -S`) on the vulnerable
construct plus one `git tag --contains` normally settles it outright. Once it is settled, do not
sweep every release tag to confirm what you already know. That work is confirmatory and buys
nothing.

Avoid shell loops over tags. Run the two or three commands you actually need individually. Loops
here tend to fail silently, on a bad pattern or on a sandboxed write, and debugging them costs far
more than the answer is worth.

- Use the `find-intro-commit` skill. Never guess the SHA, and never lift it from the advisory.
- Confirm by reading that commit that the vulnerable construct is genuinely present in it. A commit
  that merely touches the file is not the introducing commit.
- Where the vulnerable code and its reachability arrived in separate commits, say which is which.
  The boundary is the commit that makes the vulnerability real, and if they landed in different
  releases that difference belongs in the version-event `note`.
- For the fix, identify the commit at which the vulnerability is actually closed, which is not
  always the first commit that mentions it. A follow-up that corrects a case-sensitivity slip or an
  incomplete pattern is the real boundary, so read the later commits in the same release before
  settling on one. Also, a fix might be backported to other branches or tags and might result in different 
  SHAs. In that cse, multiple fix commits need to be provided.
- Always use real commit SHAs, never tag SHAs. Use full 40-character SHAs.

## Step 3 - CVSS

Use the `cvss` skill to produce a CVSS v4.0 vector. Present the vector, score, and severity,
discuss exploitability conditions and any Supplemental metrics, and call out any single metric that
swings the score materially so the user can weigh in. Check in per the rule at the top of this
skill.

The score lands as its own proposal in Step 6, not as an `open_case` field:

```
mcp__varsel__propose_cvss(input: {
  case_id: <id>, value: "CVSS:4.0/AV:.../...",
  reasoning: "..."
})
```

`cvss_v4` drives the derived score and severity bucket, and both are computed at render time, so
you pass the vector string only.

## Step 4 - CWE and CAPEC

Use the skills `find-cwe` and `find-capec` to find the CWE and CAPEC classificiations. Don't carry over
the classifications from sibling cases but run the skills independently.

You can use `search_weaknesses` and `search_attack_patterns` to find matching classifier. Bare words
are ANDed, `OR` widens (`length OR quantity OR mismatch`), `"quoted words"` must be adjacent
(`"path traversal"` skips a record that merely says "a traversal of the path"), and `-word` excludes
(`traversal -relative`). Keep `limit` at 5 or below to reduce the number of results.

**Decide the family once, then pick both IDs inside it.** The CWE and the CAPEC must agree. If a
lookup hands you a CAPEC from a family you already rejected for the CWE, that disagreement is the
finding: settle the family first, then re-pick both. Do not paper over it by keeping both.

Do not inherit a classification the evidence does not support, from a sibling case or from anywhere
else. If precedent says CWE-79 and the report does not actually show script execution, pick the
accurate CWE and note the rejected alternative in a single clause of the proposal reasoning. An
accurate CWE that disagrees with a sibling is the right answer.

## Step 5 - Open or locate the case

**A case may already exist.** An inbound vulnerability report accepted into a case, or a case the
user points you at, is already there and must not be duplicated. Find it with `list_cases`
(filtered as in Step 0), read it with `get_case`, and read its proposals with
`list_case_proposals` in **all** states, so you see what has already been accepted rather than only
what is still open. Then skip to Step 6 and propose only what is missing or wrong.

Otherwise call `open_case` but only use the `propose_*` fields, never the fields directly. Every change
to the case needs to be a proposal, never a direct update.

`open_case` also accepts `cvss_v4`, but **do not seed the score here.** Scoring is a judgement a
reviewer weighs on its own, so it lands as its own `propose_cvss` in Step 6 where the reasoning
travels with it.

Everything is markdown. Varsel renders the plain-text and HTML variants itself, so never
hand-write `supportingMedia` blocks.

`internal_notes` never reaches the record. It exists so a reviewer can check the work that is not
visible anywhere else.

**Keep it very short. A handful of lines, and often fewer.** Write only what a reviewer cannot
reconstruct from the case itself:

- the sibling case you reused a value from, named
- anything the user flagged from their own verification

Nothing else. **Do not restate the vulnerability, the fix, the reasoning already carried by a
proposal, or your investigation narrative.** If a note repeats something a reviewer can read in
`description_md`, in a proposal `reasoning`, or in the affected package, cut it. A dead end you
ruled out is worth one clause at most, and usually nothing.

**Write the notes with the `propose_internal_notes` call.** `internal_notes` can only be set here.

### Put the people on the case

As soon as you have the `case_id`, give the people who own this vulnerability access to the case
with `grant_case_access(id: <case-id>, input: {strategy, username})`, one call per person. It is
not a proposal: the server checks the handle at its provider, assigns the person when they already
have an account here, and otherwise leaves an invite that becomes access on their first sign-in.
This notifies the person in-app and by email, per their own notification settings, but the email
carries no case details, only a link, so the advisory thread is still where they hear about the
case.

Grant access to all of:

- **The advisory's collaborators** (`strategy: "github"`): `collaborating_users[].login` from the
  advisory you fetched in Step 0, and the `user.login` of each credit on it.
- **The repository owner** (`strategy: "github"`): `owner.login` from
  `gh api /repos/<owner>/<repo>` when `owner.type` is `User`. An organization is not an account
  anyone can sign in as, so skip it; its people are reached through the advisory collaborators
  and the package owners.
- **The hex.pm package owners** (`strategy: "hex"`): `owners[].username` from the
  `https://hex.pm/api/packages/<package>` response you fetched in Step 0, for each affected hex
  package.

`get_case` shows who is already there, as `assignments` (accounts) and `invites` (handles
waiting), so a repeated run or an existing case adds only the people still missing. Granting the
same handle twice is refused, which is harmless. A handle the provider does not know is refused
too; do not retry it with a guessed spelling, report it to the user instead. Never remove anyone:
taking people off a case is a human's decision in the UI.

## Step 6 - Propose the structured parts

Everything else is a proposal that a human reviewer accepts. Give each a short `reasoning`: what
you chose, and the one fact that decided it.

- The affected package, in one call with its channels and version events. Choose the tool by
  repository, not by language. See below.
- `propose_cvss` with the vector from Step 3.
- `propose_weakness` (CWE), `propose_impact` (CAPEC).
- `propose_credit` per person.
- `propose_reference` for the vendor advisory. That is normally the *only* reference you propose;
  see the references note in the mechanics section below.

**`open_case` must complete first**, because every proposal needs its `case_id`. After that the
proposals above are independent of each other, so issue them in **one parallel block** rather than
one at a time.

Do not accept your own proposals. Review is the point.

### Keep `reasoning` to one to three sentences

Proposal reasoning is the largest single cost in this workflow, outweighing every tool round trip
combined. **One paragraph, one to three sentences, with no exceptions.** This applies equally to
affected packages, references, weaknesses, impacts, credits, and everything else.

- Say what you chose and the fact that decided it. That is the whole job.
- Name at most **one** runner-up, in a clause, and only if a reviewer might plausibly have picked
  it. "CWE-79 rejected: no script execution through the documented entry point." Never a ladder of
  candidates with a paragraph each.
- No abstraction-level commentary, no restating the description or the report, no listing options
  nobody would have chosen.
- If a justification genuinely needs more room, it is a finding rather than a reasoning. Put it in
  a `create_case_comment` and leave the reasoning at its one-sentence conclusion. Do not spill it
  into `internal_notes`, which is held to the same brevity.

### Choosing the affected-package tool

**The presets are scoped to one specific upstream repository each, and each hardwires version
derivation to that repository.** Pick the wrong one and your commit SHAs will not exist in the repo
it resolves against, so the version range silently degrades to raw SHAs instead of a real range.

- `propose_otp_affected_package`: only for applications shipped inside Erlang/OTP itself
  (`erlang/otp`), such as `ssh` or `public_key`. Emits `pkg:otp/<application>` channels.
- `propose_elixir_affected_package`: only for applications shipped inside the Elixir language
  distribution (`elixir-lang/elixir`), such as `mix`, `ex_unit`, `logger`, or `eex`. **It is not
  for Elixir packages in general.**
- `propose_gleam_affected_package`: only for the Gleam compiler itself (`gleam-lang/gleam`).
- `propose_affected_package`: **everything else, which is the large majority of cases.** Every
  third-party hex package, every standalone library, anything with its own repository. When in
  doubt, this is the right one.

A hex package such as `plug`, `phoenix`, or `html_sanitize_ex` takes the **generic**
`propose_affected_package`, even though it is written in Elixir and its modules use Elixir atom
notation. Writing `'Elixir.Foo':bar/1` in `programRoutines` says nothing about which preset applies.
The question is only ever "which repository do these commit SHAs live in".

### The preset call

The presets prefill vendor, product, `repo_url`, and CPE, and create the channels plus one
version-boundary fact per commit:

```
mcp__varsel__propose_otp_affected_package(input: {
  case_id: <id>,
  applications: ["ssh"],              // otp/elixir: one channel per app; gleam omits this field
  introduced_commit: "<intro-SHA>",
  fixed_commits: ["<fix-SHA>", ...],  // one per maintained release line; omit if unpatched
  program_files: [
    {"path": "lib/ssh/src/ssh_sftpd.erl",
     "modules": ["ssh_sftpd"],
     "routines": ["ssh_sftpd:handle_op/4"]}
  ],
  reasoning: "..."
})
```

**Paths are repository-root-relative.** Each rendered channel scopes its files, modules, and
routines to its own subpath automatically, so do not write per-application prefixes yourself.

`propose_otp_affected_package` and `propose_elixir_affected_package` create one `pkg:otp/<application>`
channel per listed application. `propose_gleam_affected_package` takes no `applications` and gets
its `sid` plus OCI channels.

**When vulnerable code moved between OTP applications** over time, additionally propose
channel-scoped explicit `version_event`s bounding the former application's channel. The preset
cannot infer historical moves.

### The generic call

Propose the whole product in **one** `propose_affected_package` call, with its channels and
boundary facts nested inline, so a single acceptance creates all of it:

```
mcp__varsel__propose_affected_package(input: {
  case_id: <id>,
  vendor: "...", product: "...", repo_url: "...",
  channels: [
    {kind: "package", purl_type: "hex", name: "<name>", namespace: null, qualifiers: {},
     subpath: null, version_type: null, tag_prefix: null, tag_suffixes: []}
  ],
  version_events: [
    {event: "introduced", commit_sha: "<intro-SHA>", note: "..."},
    {event: "fixed", commit_sha: "<fix-SHA>", note: "..."}   // omit if unpatched
  ],
  reasoning: "..."
})
```

### Packaging edge cases

- **npm mirror.** Some Elixir libraries (Phoenix and friends) ship a companion npm package. If the
  vulnerable file actually ships in the npm tarball (`npm pack --dry-run` to confirm; paths often
  differ), add a `pkg:npm/<name>` channel with its own program-file paths. If the issue only
  touches Elixir or Erlang source, skip it.
- **Extraction packages.** If code in package A was extracted into package B, model them as two
  affected packages. A's fix boundary is the extraction point; B carries the real fix commit.
- **Unpatched.** Omit `fixed_commits` or the `fixed` boundary entirely. Varsel renders the
  open-ended range. Do not propose a patch reference at all. Varsel derrives it.

### Correcting an accepted proposal

Accepted rows are not immutable. If something turns out wrong after it has been accepted, use
`propose_delete` with that row's `target` and `target_id` to remove it, then propose the correct
version. Do not try to paper over a wrong affected package by adding a second one alongside it.

## Step 7 - Refresh derivation, then validate

**First check whether this step can tell you anything yet.** Derivation runs only over *accepted*
affected packages, so while your affected-package proposal is still open there is no version data
to compute and the preview cannot show a range. If nothing has been accepted, stop here, hand the
case to the reviewer, and come back to this step afterwards. Rendering a preview before review is
always a wasted call.

Once the affected package has been accepted:

**Run `refresh_case_derivation` first.** The preview reads a cached derivation and does not
recompute it, so a preview taken without refreshing shows stale or empty version data. Refresh
after any affected-package change is accepted, every time. Pass `refresh: true` when the package
repository may have changed since the last derivation (a fix shows as unreleased but the tag
should exist by now): it refetches the repository state before deriving.

Then run `render_case_preview` and `validate_case`, and read three separate signals.

**1. The derived version range.** Confirm it is actually a version range, such as
`from 0.3.1 before 1.5.3`. If you see raw commit SHAs where version numbers belong, or an empty
range, the derivation resolved against the wrong repository. Check the rendered `vendor` and
`packageURL` too: a vendor you never supplied, or a purl pointing at a repository you never named,
is the same symptom. The cause is almost always the wrong affected-package tool, so go back to
Step 6.

**2. The preview's `blockers` array.** This is a distinct signal from validation errors, and it is
where problems like "the introducing commit is in no release tag" surface. Never skip it.

**3. `validate_case` errors.** These are hard validation errors that need to be fixed before 
the case can be published.

An error is expected only while the proposal that would satisfy it is still sitting unaccepted.
`E006 (no affected product)` is expected with the affected-package proposal open, and is a genuine
problem once that proposal has been accepted. Check proposal states with `list_case_proposals`
before dismissing anything. "A fresh case validates as invalid" is not licence to skim the
affected-product and reference errors, which are the two most likely to be real.

## Step 8 - Verify

Run the `verify` skill on the case. Fix anything it finds as further proposals and re-verify until
it comes back clean.

## Done

Hand off with the case ready for review: the proposals are authored, the derived ranges check out,
and verification passes. **CVE ID assignment, proposal acceptance, and publishing all happen in the
UI, by a human.** Never assign an ID, never accept your own proposals, and never publish.

---

## Writing style

House style, applied to every field. **These rules are self-contained. Do not invoke another skill
to write case text.**

- **Never use em dashes.** Use parentheses, commas, or restructure the sentence.
- Write for a security-oriented audience, not an end-user advisory.
- Prose, not bullet lists, in `description_md`.
- Inline code with backticks for paths, functions, and identifiers. **Never use fenced code blocks
  anywhere.** Describe the relevant code in prose, naming the file and the function.
- Do not mention sibling CVE IDs. Name the vulnerability class instead ("integer overflow",
  "path traversal").
- Do not list affected versions in the description. Varsel appends
  "This issue affects x: from A before B." and writing it yourself publishes it twice.
- Use `TODO` for any value not yet known, in URLs and in prose alike, as in "from 0.1.0 before
  TODO". Do not paraphrase it as "the latest release at time of filing" or similar.
- Never write "no fix available". Cases are only published once a fix exists.
- Omit filler. If a sentence would not change what a reader does, cut it.

### Structuring `description_md`

**This is a report, not a blog post. Be short.**

Descriptions run long by default. Every one written so far has been at least twice the length it
needed to be. Assume yours is too: write it, then cut it in half before proposing it.

**Target 100 to 150 words. Hard ceiling 250.** Past that you are explaining rather than reporting.

**Two paragraphs maximum. Often one.**

**Open with the standard CVE summary sentence.** This is the house convention, used by roughly 90%
of this CNA's records, and it matches the `Auto Generate` template in Vulnogram, the CVE Program's
reference authoring tool:

`[PROBLEMTYPE] in [COMPONENT] in [VENDOR] [PRODUCT] allows [ATTACKER] to [IMPACT] via [VECTOR]`

Drop the placeholders that do not apply rather than padding them out, and leave the version range
out because Varsel appends it. One sentence, for example: "Improper Neutralization of Special
Elements in Output Used by a Downstream Component ('Injection') vulnerability in rrrene
html_sanitize_ex allows Content Spoofing."

**Paragraph one, two to four sentences:** that summary sentence, then what the flaw actually is and
who can trigger it. No bullet points. For many cases this is the entire description, and that is a
good outcome, not a thin one.

**Paragraph two is optional**, and only earns its place if it carries something paragraph one
cannot. Pick whichever of these matters more for this issue. You do not get both as separate
paragraphs:

- **Mechanism**, when the flaw is not already obvious. Name the file and the function, say what
  the code does wrong, stop.
- **Scope limits**, when you ruled out a more severe reading. This is what stops a reader assuming
  XSS when the record says injection, and it justifies the CWE and CAPEC.

If both genuinely matter, compress them into that one paragraph. **There is no third paragraph.**
If you have written one, cut it. Do not relocate it to `internal_notes`, which is not the overflow
bin for text the description could not justify.

Cut in this order:

- Any sentence that restates the lead in different words.
- **The program-files restatement.** Never write a paragraph beginning "This vulnerability is
  associated with program files ... and program routines ...". Those fields are already in the
  record and the sentence gives a reader nothing to act on. Roughly a quarter of older records
  carry it; it is not the pattern to copy. This does **not** apply to the opening summary sentence
  above, which is the house convention and is expected.
- Any explanation of why the fix works. That is not the description's job.
- Any background a security reader already has: what CSS is, what a sanitizer does, what XSS means.
- Hedges and intensifiers: "critically", "importantly", "it is worth noting", "essentially".
- Any sentence a reader could skip without losing something they would act on.

Prefer short sentences. One clause where two would do.

Keep the CVSS score, the severity, and any explanation of metric choices out entirely. Those live
in structured fields, and metric reasoning belongs in the `propose_cvss` `reasoning`.

### Optional fields: workarounds, configurations, solutions

**All three are optional, and omitting them is the default.** Fill one in only when there is
something a user can apply **immediately, without upgrading**, to mitigate the exploit.

**Upgrading to the patched version does not count** and must not be written into any of these
fields. The fixed version is already carried by the affected-package version events, so repeating
it here adds nothing.

- **`workarounds_md`**: a real mitigation available without upgrading, such as disabling the
  affected feature, avoiding the vulnerable API, or a configuration change that closes the hole.
  Never "apply the patch", never "upgrade to X".
- **`configurations_md`**: only when the vulnerability requires specific deployment conditions to
  be reachable. Omit when the issue is unconditional.
- **`solutions_md`**: only when a remediation exists beyond upgrading. Omit it when upgrading is
  the whole answer, which is the usual case.

An empty field is the correct and common outcome. Do not fill one in for completeness, and never
write "There are no workarounds."

**Verifying a candidate workaround is encouraged, on trusted and untrusted cases alike.** This is
the one exception to the no-reproduce rule for trusted reports: a workaround you publish is advice
users act on, so a mitigation you never tested is worse than an omitted field.

Adapt the PoC into a small `Mix.install/2` script in the scratchpad, run it with the workaround
applied against a **vulnerable** version, and confirm the exploit no longer succeeds. Run it once
without the workaround in the same script too, so you know the harness would have caught the
exploit at all. If the mitigation does not hold, do not propose it, and say in the summary which
candidate you ruled out and how.

### Credits

Credit roles are the CVE schema's, by their definitions: `finder` identified the vulnerability,
`reporter` reported it to the vendor or the CNA, `analyst` validated it or its severity,
`coordinator` facilitated the coordinated response, `remediation_developer` prepared the fix,
`remediation_reviewer` reviewed it, `remediation_verifier` tested it, plus `tool`, `sponsor`, and
`other`. Analyst and coordinator are distinct roles; never fold one into the other. Assign every
role that applies per person: a GHSA carries at most one role per credit, the CVE record has no
such limit, and several roles per person is the common case. Do not skip `pending` credits.

**`name` is the full real name only.** No handle, no affiliation, spelled with its correct
diacritics. An affiliation goes in the separate `organization` field, never appended to the name,
because Varsel renders `name / organization` itself and writing it into `name` publishes it twice.
Fall back to the handle alone only if the real name is genuinely unknown. Look names up with
`gh api /users/<login>` rather than guessing from the username. Known overrides:

- `IngelaAndin` to `Ingela Anderton Andin`
- `u3s` to `Jakub Witczak`
- `maennchen` to `name: "Jonatan Männchen"`, plus `organization: "EEF"` when acting in his EEF
  capacity, which is the usual case for `analyst` and `coordinator` credits on EEF-handled
  advisories

Check precedent before inventing a variant. Use `search_cves` or `list_all_cves` to see how a
person has been credited before.

---

## Varsel mechanics worth knowing

These are the things that will otherwise cost a round trip.

**`propose_affected_package` channel keys are all required**, even when empty. Pass `qualifiers`
as `{}` and `tag_suffixes` as `[]` rather than `null`, and include `namespace`, `subpath`,
`version_type`, and `tag_prefix` explicitly as `null` when unused. A hex package channel is
`{"kind": "package", "purl_type": "hex", "name": "<pkg>", "namespace": null, "qualifiers": {}, "subpath": null, "version_type": null, "tag_prefix": null, "tag_suffixes": []}`.

**`purl_type` is any purl type**, not a fixed list — `hex`, `npm`, `oci`, `otp`, `cargo`, `gem`,
whatever the ecosystem publishes as. The well-known ones fill in their registry URL and version
type on their own, so leave `version_type` null unless the channel genuinely disagrees with its
ecosystem (the OTP release channel is `pkg:sid` versioned `otp`, for instance).

**A service is a `kind: "service"` channel on the same package**, not a purl type and not a
second affected product: pass the `domain` it answers on (e.g. `hex.pm`) and none of the purl
fields. A published record renders the service as its own date-versioned `affected[]` entry, but
that entry is still this package — same vendor/product/CPE/program files — beside the
git-versioned repository entry. Do not model the deployment as a separate product to get the
second entry.

A service channel is versioned by date, through version events scoped to it: after the package
(and so the channel) is accepted, `propose_version_event` with `package_channel_id` set to the
service channel, `version` set to the date, and no commit SHA. The inline events below cannot
carry the scope, since the channel has no id until the package proposal is accepted.

**Do not add the repository channel.** It is derived from the package's `repo_url` when the
package is created (`pkg:github/...`, or `pkg:generic` for a forge with no purl type of its own).
Only add a forge channel for something like a second host.

**Inline version events are package-global.** Pass `introduced` and `fixed` with full commit SHAs
and a `note` explaining each boundary. A service channel's date boundaries are not among them
(see above). If different channels genuinely need different versions beyond that, stop and
involve a human rather than forcing it.

**Non-ASCII names need no special handling, and this question recurs.** Pass the real characters:
store `Männchen` and `Föhring`, never a hand-escaped form.

A backslash-u JSON escape and the literal character denote the identical string, so there is no
difference to preserve. Published record files look escaped only because the record formatter emits
the ASCII-safe form at render time, one layer below the value you store.

If you are asked to escape an umlaut, the answer is that the escaping already happens, at render
time. Storing the escape sequence as literal text would put a real backslash into the published
record, which is the actual failure mode this rule exists to prevent.

**Module and routine notation** is Erlang throughout. Elixir modules take the atom prefix,
`'Elixir.HtmlSanitizeEx.Scrubber.CSS'`, and routines are `module:function/arity`, so
`'Elixir.HtmlSanitizeEx.Scrubber.CSS':scrub/1`. Pure Erlang modules are lowercase. This notation is
required for every Erlang and Elixir package and says nothing about which affected-package tool to
use, so do not read an `'Elixir.*'` prefix as a signal to reach for the Elixir preset.

**List the routines that are vulnerable**, plus the entry point callers actually invoke if the
vulnerable function is internal. Skip bookkeeping the fix commit incidentally touched, such as
changelog and version bumps.

**Cross-language reachability.** When the bug is behind a language boundary (Rust NIF, C BIF, port
driver), list both sides: the implementing function and the Erlang or Elixir function callers
reach it through.

**`propose_cvss` takes the vector string.** Score and severity are derived at render time.

**Every list tool is capped, and says nothing about it.** A call with no `limit` returns the first
**25** rows, and an explicit `limit` is silently capped at 250. A short result is therefore not
evidence that you have seen everything. To learn the real total, re-run the same call with
`result_type: "count"`, which ignores the cap.

**So filter rather than page.** Always pass a `filter` to `list_cases`, `list_cves`, and
`list_all_cves`: the first 25 of everything is rarely the 25 you want. For `list_cases`,
`affects_repo` is the narrowest filter available; see Step 0.

**Varsel supplies most references itself.** Do not propose the patch commit: the renderer builds it
from `repo_url` plus the fix version event. Do not propose the `cna.erlef.org` or `osv.dev` links
either; those are added when the CVE ID is assigned in the UI. In practice you propose the vendor
advisory (`["vendor-advisory", "related"]`) and, on OTP cases, the version-scheme doc
(`["x_version-scheme"]`). That is the whole list. The renderer orders the rendered set itself:
vendor advisory first, then patch-tagged, then the rest.

**To remove a child row**, use `propose_delete` with its `target` (for example `"reference"`) and
`target_id`.

**`internal_notes` is set with `propose_internal_notes`, and should be a handful of lines at most.**
Keep them to the boundary SHAs, the sibling you reused, and what the user verified, and use
`create_case_comment` for anything longer that comes up later.

**`render_case_preview` and `validate_case` return the preview or the verdict alone**, not the case
body, so checking one costs only what it reports.

---

## Related skills

- `cvss` for scoring
- `find-cwe`, `find-capec`, `find-intro-commit` for the lookups
- `verify` for the final check in Step 8

Those five are the only skills this workflow uses. Everything needed to write the case text is in
the Writing style section above, so do not reach for a summarizing or write-up skill to author
`description_md` or any other field.
