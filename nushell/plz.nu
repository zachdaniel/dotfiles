# plz nushell integration.  Generate + source once, e.g.:
#   plz init nu | save -f ($nu.default-config-dir | path join plz.nu)
#   # then add to config.nu:   source plz.nu
$env.config.hooks.pre_execution = (
  $env.config.hooks.pre_execution? | default [] | append {||
    # stored as a record so it is NOT exported to child processes (no leak
    # into nested scripts); still readable by the `plz` command below.
    $env.PLZ = { cmd: (commandline) }
  }
)

# Resolve the engine option list from the captured command line. Reads only
# $env.PLZ (never $in), so it can run without disturbing the piped input.
# Errors if the pipeline is ambiguous (two identical plz calls, different
# neighbors).
def __plz_opts [...rest] {
  mut opts = ["--shell" "nu"]
  let cmdline = ($env.PLZ?.cmd? | default "")
  if ($cmdline | is-not-empty) {
    $opts = ($opts | append ["--pipeline" $cmdline])
    let toks = (
      ast $cmdline --flatten --json | from json
      | uniq-by span
      | each {|x| if $x.shape == "shape_pipe" { "|" } else { $x.content } }
    )
    let out = ($toks | str join "\n" | ^plz __locate ...$rest | split row "\n")
    let s = ($out | get 0? | default "")
    let f = ($out | get 1? | default "")
    let t = ($out | get 2? | default "")
    if $s == "ambiguous" {
      error make {msg: "plz: ambiguous pipeline — two identical 'plz' calls with different neighbors. Vary one prompt to disambiguate."}
    }
    if ($f | is-not-empty) { $opts = ($opts | append ["--piped-from" $f]) }
    if ($t | is-not-empty) { $opts = ($opts | append ["--piped-to" $t]) }
  }
  $opts
}

def --wrapped plz [...rest] {
  # Inspect the input type without consuming/collecting $in (describe
  # --no-collect is non-destructive). NOTE: after that, $in only survives if used
  # at the TOP LEVEL — using it inside an `if` branch yields null. So we select a
  # transform CLOSURE with the `if` (no $in in the branch) and pipe $in through
  # it exactly once, at top level. Structured nushell data (table/record/list)
  # becomes JSON so the model gets named fields instead of an ASCII-art table;
  # plain text / byte streams pass through untouched and keep streaming.
  let ty = ($in | describe --no-collect)
  let structured = (($ty | str starts-with "table") or ($ty | str starts-with "record") or ($ty | str starts-with "list"))
  let opts = (__plz_opts ...$rest)

  # Find the downstream command (if any) so we can decide whether to emit a
  # nushell value or plain text. We render structured output (JSON -> value)
  # when plz is LAST, or when it feeds a native nushell command (where/select/
  # sort-by/...). We keep TEXT when it feeds an external (jq/grep) or another plz.
  let ti = ($opts | enumerate | where item == "--piped-to" | get index.0? | default (-1))
  let downstream = (if $ti >= 0 { $opts | get ($ti + 1) } else { "" })
  let dw = ($downstream | str trim | split row " " | get 0? | default "")
  let dtype = (if ($dw | is-empty) { "" } else { (try { which $dw | get type | first } catch { "external" }) })
  let render = (($downstream | is-empty) or ($dtype in ["keyword" "built-in"]))

  let extra = (
    (if $structured { ["--stdin-json" "--input-shape" $ty] } else { [] })
    | append (if $render { ["--render-json"] } else { [] })
  )
  # in-closure: structured input -> JSON. out-closure: when rendering, parse the
  # JSON output into a real nushell value (table) so the user / next nushell
  # command gets structured data; fall back to raw text if it isn't JSON.
  $in
  | do (if $structured { {|| to json -r } } else { {|| $in } })
  | ^plz ...$opts ...$extra ...$rest
  | do (if $render { {|| let o = $in; try { $o | from json } catch { try { $o | from json --objects } catch { $o } } } } else { {|| $in } })
}
