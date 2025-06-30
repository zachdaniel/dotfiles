# BUG FIX WORKFLOW

**THIS IS A MANDATORY WORKFLOW - ALL STEPS MUST BE COMPLETED IN ORDER**

## PHASE 1: UNDERSTANDING THE BUG (MANDATORY)

### Step 1.1: Initial Investigation
**REQUIRED ACTIONS**:
- Get exact error message/behavior description
- Identify affected module/function using grep/glob
- Use `package_docs_search` to understand intended behavior
- Check existing usage rules via `get_usage_rules` MCP tool or CLAUDE.md links
- Verify if bug violates any existing package usage rules
- Check if this is an Ash-specific issue
- Search for similar issues in codebase history

### Step 1.2: Root Cause Analysis
**YOU MUST**:
1. Read the failing code and surrounding context
2. Trace the execution path
3. Identify ALL places this bug might manifest
4. Determine if it's a symptom of a larger issue
5. Check for related bugs that might be hidden
6. Consider whether the bug may in fact be user error, or should be fixed by using the tool differently.

### Step 1.3: Reproduce the Bug
**MANDATORY - NO EXCEPTIONS**:
1. Write a failing test that demonstrates the bug
2. Ensure test fails for the RIGHT reason
3. Verify test will pass once bug is fixed
4. Place test in appropriate test file
5. Run test and capture output

**TEST TEMPLATE**:
```elixir
test "descriptive name of what should work" do
  # ArrangeGuilds.Sites.Organization |> Ash.Query.load([:users]) |> Ash.read!()
  [setup code]
  
  # Act 
  [code that triggers bug]
  
  # Assert
  [assertion that currently fails]
end
```

## PHASE 2: PLANNING & APPROVAL (MANDATORY)

### Step 2.1: Create Fix Plan Document
**CREATE FILE**: `<project_root>/notes/fixes/<number>-<issue-description>.md` (inside the project directory)

**REQUIRED STRUCTURE**:
```markdown
# Fix: <Issue Description>

## Bug Summary
[1-2 sentences describing the bug and its impact]

## Root Cause
[Technical explanation of why this bug occurs]

## Existing Usage Rules Violations
[List any existing usage rules that were violated leading to this bug]

## Reproduction Test
```elixir
[paste the failing test here]
```

## Test Output
```
[paste test failure output]
```

## Proposed Solution
[Detailed explanation of the fix approach]

## Changes Required
1. File: [path] - [what changes]
2. File: [path] - [what changes]

## Potential Side Effects
- Side effect 1: [description]
- Side effect 2: [description]

## Regression Prevention
[How we ensure this doesn't break again]

## Questions for Zach
1. [Any clarifications needed]
```

### Step 2.2: Approval Checkpoint
**YOU MUST STOP HERE**:
1. Present the fix plan with failing test
2. Ask: "I've reproduced the bug with a test. Should I proceed with this fix approach?"
3. WAIT for explicit approval
4. Do NOT implement without approval

## PHASE 3: IMPLEMENTATION

### Step 3.1: Set Up Tracking
**REQUIRED**:
1. Use TodoWrite to track fix tasks
2. Add `## Implementation Log` section to fix document
3. Document each change as you make it

### Step 3.2: Apply Fix
**MANDATORY SEQUENCE**:
1. Make MINIMAL changes to fix the bug
2. Do NOT refactor unrelated code
3. Follow existing code patterns exactly
4. Use Ash patterns if touching Ash code
5. Add comments ONLY if fixing complex logic

### Step 3.3: Verification
**REQUIRED CHECKS**:
1. Run the reproduction test - MUST pass
2. Run full test suite - NO new failures
3. Compile - NO new warnings
4. Check for performance impact
5. Verify no security issues introduced

### Step 3.4: Extended Testing
**YOU MUST**:
1. Test edge cases around the fix
2. Test related functionality
3. Verify the fix handles all identified manifestations
4. Run any integration tests

## PHASE 4: DOCUMENTATION & REVIEW

### Step 4.1: Update Fix Document
**ADD SECTIONS**:
```markdown
## Final Implementation
[What was actually changed]

## Test Results
- Reproduction test: [PASSING/FAILING]
- Full test suite: [X passed, Y failed]
- New tests added: [list them]

## Verification Checklist
- [ ] Bug is fixed
- [ ] No regressions introduced  
- [ ] Tests cover the fix
- [ ] Code follows patterns
```

### Step 4.2: Final Review
**PRESENT TO USER**:
1. Show the passing test
2. Summarize what was fixed
3. List any concerns
4. Ask: "Fix implemented and tested. Ready to finalize?"

## PHASE 5: COMPLETION

### Step 5.1: Cleanup
**IF APPROVED**:
1. Ensure all tests are passing
2. Remove any debug code
3. Update fix document with final status
4. Mark all todos as complete

### Step 5.2: Prevention Follow-up
**CONSIDER**:
1. Should similar code be checked?
2. Is there a pattern to prevent this bug class?
3. Should documentation be updated?
4. Note any follow-up tasks needed

# CRITICAL REMINDERS

- **TEST FIRST** - No fix without failing test
- **MINIMAL CHANGES** - Fix only what's broken
- **NO COMMITS** - Unless explicitly told to commit
- **VERIFY EVERYTHING** - All tests must pass
- **ASH PATTERNS** - Use Ash ways for Ash code
- **WAIT FOR APPROVAL** - At every checkpoint
