# GENERAL TASK WORKFLOW

## PHASE 1: TASK ANALYSIS (MANDATORY)

### Step 1.1: Understand the Request
**YOU MUST**:
1. Parse what exactly is being asked
2. Identify if this is a feature (use feature.md) or fix (use fix.md)
3. If neither, continue with this workflow
4. Break down into specific, measurable subtasks
5. Identify what success looks like

### Step 1.2: Research Requirements
**REQUIRED RESEARCH - USE ALL AVAILABLE TOOLS**:
- Follow RESEARCH PROTOCOL
- Check existing code patterns with grep/glob
- Verify Ash-specific requirements
- Look for similar implementations
- Review any applicable existing usage rules for packages involved
- Understand the full context

### Step 1.3: Create Task Plan
**YOU MUST**:
1. Use TodoWrite to create specific subtasks
2. Order tasks by dependency
3. Include verification steps
4. Add "Ask Zach for confirmation" as final task

**EXAMPLE TODO STRUCTURE**:
```
1. Research [specific thing] in docs
2. Check existing [pattern] in codebase  
3. Implement [specific change]
4. Test/verify [specific behavior]
5. Ask Zach for confirmation
```

## PHASE 2: EXECUTION

### Step 2.1: Follow the Plan
**FOR EACH TODO ITEM**:
1. Mark as "in_progress" when starting
2. Execute the specific task
3. Verify it worked as expected
4. Document any issues or discoveries
5. Mark as "completed" when done
6. Report status before moving to next

### Step 2.2: Implementation Rules
**ALWAYS**:
- Check for generators before writing code
- Use `project_eval` to test code snippets
- Follow existing patterns exactly
- Use Ash concepts, not Ecto
- Compile after changes
- Run relevant tests

### Step 2.3: Continuous Verification
**AFTER EACH CHANGE**:
1. Check compilation status
2. Look for warnings/errors
3. Test the specific functionality
4. Ensure no regressions
5. Update user on progress

## PHASE 3: COMPLETION

### Step 3.1: Final Verification
**REQUIRED CHECKS**:
- All todos completed
- Code compiles cleanly
- Tests pass (if applicable)
- Functionality works as requested
- No security issues introduced

### Step 3.2: Summary Report
**PRESENT TO USER**:
```
Task completed. Here's what was done:
1. [Specific thing 1]
2. [Specific thing 2]
3. [etc.]

[Any issues or notes]

Should I make any adjustments?
```

## SPECIAL TASK TYPES

### Code Exploration Tasks
**WHEN ASKED TO EXPLAIN/EXPLORE CODE**:
1. Use grep/glob to find relevant files
2. Read files systematically
3. Use `project_eval` to explore runtime behavior
4. Explain findings clearly
5. Reference specific files and line numbers

### Refactoring Tasks  
**WHEN ASKED TO REFACTOR**:
1. Understand current implementation fully
2. Research best practices in docs
3. Create incremental refactoring plan
4. Test after each change
5. Ensure behavior unchanged

### Documentation Tasks
**WHEN ASKED TO DOCUMENT**:
1. Only create docs if EXPLICITLY requested
2. Follow existing documentation patterns
3. Focus on "why" not just "what"
4. Include examples where helpful
5. Keep concise and clear

### Performance Tasks
**WHEN ASKED TO OPTIMIZE**:
1. Measure current performance first
2. Identify specific bottlenecks
3. Research Ash-specific optimizations
4. Apply minimal changes
5. Measure improvement

## CRITICAL RULES FOR ALL TASKS

1. **NO ASSUMPTIONS** - Research everything
2. **NO COMMITS** - Unless told "commit this"
3. **ASH FIRST** - Always use Ash patterns
4. **TEST EVERYTHING** - Verify all changes work
5. **ASK WHEN UNSURE** - Better to clarify than guess
6. **REPORT PROGRESS** - Keep user informed
7. **MINIMAL CHANGES** - Don't over-engineer

## WHEN TO ESCALATE

**STOP AND ASK FOR HELP IF**:
- Task seems to require breaking the rules
- You're unsure about security implications  
- The approach might affect system stability
- You need to modify critical system files
- The task specification is ambiguous
