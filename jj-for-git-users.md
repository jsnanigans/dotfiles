# Jujutsu (jj) for Git Users

A practical guide for Git users transitioning to Jujutsu, a Git-compatible VCS with automatic commits and powerful history editing.

## Key Concepts

### Fundamental Differences

| Git | Jujutsu |
|-----|---------|
| Working directory changes need staging/committing | Every change is automatically committed |
| Branches point to commits | Bookmarks point to changes |
| HEAD points to current branch/commit | @ symbol indicates working copy |
| Commits are (mostly) immutable | Changes are mutable until pushed |
| Staging area (index) | No staging - all changes auto-committed |

### Understanding Changes vs Commits

- **Change**: A mutable revision in jj (like a draft commit)
- **Commit**: An immutable revision (after pushing to git)
- Every save creates a new change automatically
- Use `jj new` to start a fresh change (like starting a new commit)

## Command Mappings

### Basic Operations

| Git Command | Jujutsu Command | Notes |
|-------------|-----------------|-------|
| `git status` | `jj status` | Shows working copy changes |
| `git log` | `jj log` | Shows change history |
| `git log --oneline` | `jj log --oneline` | Compact view |
| `git diff` | `jj diff` | Shows changes in working copy |
| `git diff --staged` | N/A | No staging in jj |
| `git show <commit>` | `jj show <change>` | Show change details |

### Creating Changes

| Git Command | Jujutsu Command | Notes |
|-------------|-----------------|-------|
| `git add <file>` | Automatic | Changes are tracked automatically |
| `git commit` | `jj commit` | Closes current change, starts new one |
| `git commit -m "msg"` | `jj commit -m "msg"` | With message |
| `git commit --amend` | `jj squash` | Combine with parent |
| Edit commit + `git add` + `git commit --amend` | Just edit files | Changes update automatically |

### Branching

| Git Command | Jujutsu Command | Notes |
|-------------|-----------------|-------|
| `git branch` | `jj bookmark list` | List bookmarks |
| `git branch <name>` | `jj bookmark create <name>` | Create bookmark |
| `git checkout <branch>` | `jj bookmark set <name>` | Move bookmark to current change |
| `git checkout -b <name>` | `jj bookmark create <name>` | Create and set bookmark |
| `git branch -d <name>` | `jj bookmark delete <name>` | Delete bookmark |
| `git merge <branch>` | `jj merge <change>` | Merge changes |

### History Navigation

| Git Command | Jujutsu Command | Notes |
|-------------|-----------------|-------|
| `git checkout <commit>` | `jj edit <change>` | Edit specific change |
| `git checkout HEAD~` | `jj edit @-` | Edit parent change |
| `git reset --hard <commit>` | `jj edit <change>` | Move to change |
| `git reset --soft HEAD~` | `jj squash` | Combine with parent |

### Rewriting History

| Git Command | Jujutsu Command | Notes |
|-------------|-----------------|-------|
| `git rebase <branch>` | `jj rebase -d <change>` | Rebase onto change |
| `git rebase -i HEAD~3` | `jj edit <change>` then edit | Edit any change directly |
| `git cherry-pick <commit>` | `jj duplicate <change>` | Copy change |
| `git revert <commit>` | `jj backout <change>` | Create inverse change |

### Remote Operations

| Git Command | Jujutsu Command | Notes |
|-------------|-----------------|-------|
| `git fetch` | `jj git fetch` | Fetch from remote |
| `git pull` | `jj git fetch` + `jj rebase` | No direct pull |
| `git push` | `jj git push` | Push to remote |
| `git push -f` | `jj git push --force` | Force push |

## Common Workflows

### Starting New Work

```bash
# Git way
git checkout main
git pull
git checkout -b feature-branch

# Jujutsu way
jj git fetch
jj new main  # Start new change on top of main
jj bookmark create feature-branch
```

### Making Changes

```bash
# Git way
edit file.txt
git add file.txt
git commit -m "Update file"

# Jujutsu way
edit file.txt
# Changes are auto-committed!
jj describe -m "Update file"  # Add/update message
```

### Updating Commit Message

```bash
# Git way
git commit --amend -m "New message"

# Jujutsu way
jj describe -m "New message"
```

### Fixing a Previous Commit

```bash
# Git way (complex)
git stash
git rebase -i HEAD~3
# mark commit as 'edit'
git stash pop
git add .
git commit --amend
git rebase --continue

# Jujutsu way (simple)
jj edit <change-id>  # Go to the change
# make your edits - automatically updated
jj new  # Continue with new work
```

### Splitting a Commit

```bash
# Git way
git rebase -i HEAD~2
# mark commit as 'edit'
git reset HEAD~
git add -p
git commit -m "First part"
git add .
git commit -m "Second part"
git rebase --continue

# Jujutsu way
jj split  # Interactive split
```

### Squashing Commits

```bash
# Git way
git rebase -i HEAD~3
# mark commits as 'squash'

# Jujutsu way
jj squash  # Squash current into parent
# or
jj squash --from X --into Y
```

### Working with Git Remotes

```bash
# Initial setup (colocated with git)
jj git init --colocate

# Daily workflow
jj git fetch  # Get latest changes
jj rebase -d main  # Rebase onto main
jj git push  # Push changes
```

## Tips and Gotchas

### Key Differences to Remember

1. **No Staging Area**: All changes are automatically tracked
2. **No HEAD**: Use `@` to refer to current working copy
3. **Change IDs**: Use short prefixes like `abc` instead of full hashes
4. **Automatic Commits**: Every file save creates a new revision
5. **Mutable History**: Edit any unpushed change freely

### Best Practices

1. **Use `jj new`** to start fresh work (like `git commit` but beforehand)
2. **Describe early**: Use `jj describe` to add messages as you work
3. **Edit freely**: Use `jj edit` to fix any change in your stack
4. **Squash often**: Use `jj squash` to keep history clean before pushing

### Common Gotchas

1. **Empty commits**: `jj` shows empty changes - use `jj abandon` to remove
2. **No pull**: Use `jj git fetch` then rebase/merge manually
3. **Bookmarks != Branches**: Bookmarks are more like Git tags that move
4. **Colocated repos**: Changes appear as git commits only after `jj git push`

### Useful Aliases

Add to your shell config:

```bash
alias j='jj'
alias js='jj status'
alias jl='jj log'
alias jd='jj diff'
alias jn='jj new'
```

## Advanced Features

### Revsets

Jujutsu has a powerful query language:

```bash
# Show changes by author
jj log -r 'author(alice)'

# Show changes in the last week
jj log -r 'committer_date(after:"1 week ago")'

# Show my changes not on main
jj log -r 'mine() ~ ::main'
```

### Workspaces

Unlike Git worktrees, jj workspaces share the same repo:

```bash
jj workspace add ../myproject-feat
cd ../myproject-feat
# Work on feature in parallel
```

### Operation Log

See and undo any operation:

```bash
jj op log  # Show operation history
jj op undo <op-id>  # Undo operation
```

## Complete Workflow Example: Building a Feature

Let's walk through building a feature with authentication, API endpoint, and tests. This shows the dramatic difference in workflow complexity.

### Scenario: Add user profile feature

You need to:
1. Add authentication middleware
2. Create profile API endpoint
3. Add tests
4. Fix a bug you discover in the auth middleware
5. Split the work into logical commits for review

### Git Workflow

```bash
# Start feature branch
git checkout main
git pull origin main
git checkout -b feature/user-profile

# Work on authentication middleware
vim src/middleware/auth.js
git add src/middleware/auth.js
git commit -m "Add authentication middleware"

# Work on profile API
vim src/api/profile.js
git add src/api/profile.js
git commit -m "Add profile API endpoint"

# Add tests
vim tests/profile.test.js
git add tests/profile.test.js
git commit -m "Add profile API tests"

# Run tests - discover auth bug!
npm test
# Tests fail due to auth middleware bug

# Need to fix the first commit - this is complex in Git
git stash  # Save current work
git rebase -i HEAD~3
# Mark first commit as 'edit'
# Git stops at first commit
vim src/middleware/auth.js  # Fix the bug
git add src/middleware/auth.js
git commit --amend
git rebase --continue
git stash pop

# Realize commits could be better organized
git rebase -i HEAD~3
# Reorder, squash, edit messages
# Complex interactive rebase process...

# Finally push
git push origin feature/user-profile
```

### Jujutsu Workflow

```bash
# Start feature work
jj git fetch
jj new main -m "Add user profile feature"
jj bookmark create feature/user-profile

# Work on authentication middleware
vim src/middleware/auth.js
# Changes auto-saved, no need to stage!
jj describe -m "Add authentication middleware"

# Start new change for API endpoint
jj new -m "Add profile API endpoint"
vim src/api/profile.js
# Changes auto-saved

# Start new change for tests
jj new -m "Add profile API tests"
vim tests/profile.test.js

# Run tests - discover auth bug!
npm test
# Tests fail due to auth middleware bug

# Fix the bug in the first change - simple in jj!
jj edit @--  # Go to auth middleware change
vim src/middleware/auth.js  # Fix the bug
# Bug automatically included in that change

# Continue where you left off
jj edit @++  # Go back to test change

# Organize commits better
jj squash --from @- --into @--  # Combine API and middleware
jj describe @- -m "Add profile API with authentication"

# Push changes
jj git push
```

### Workflow Comparison

| Aspect | Git | Jujutsu |
|--------|-----|---------|
| Starting work | 3 commands | 2 commands |
| Saving changes | `add` + `commit` each time | Automatic |
| Fixing earlier commit | Complex stash + rebase | Simple `jj edit` |
| Reorganizing commits | Interactive rebase | Direct commands |
| Mental model | "Where should I commit?" | "Just work, organize later" |

### Advanced Example: Parallel Changes

Let's say while working on the profile feature, you need to make a hotfix:

#### Git Approach
```bash
# Save profile work
git stash

# Create hotfix
git checkout main
git pull
git checkout -b hotfix/security-issue
vim src/security.js
git add src/security.js
git commit -m "Fix security issue"
git push origin hotfix/security-issue

# Go back to feature
git checkout feature/user-profile
git stash pop
# Hope there are no conflicts...
```

#### Jujutsu Approach
```bash
# Just start the hotfix - no stashing needed!
jj new main -m "Fix security issue"
vim src/security.js
jj git push --bookmark hotfix/security-issue

# Go back to feature - it's still there
jj edit feature/user-profile
# Continue working...
```

### Real-World Scenario: Code Review Feedback

Your PR gets feedback: "Split the auth middleware into separate validation and parsing functions"

#### Git Approach
```bash
# Complex interactive rebase
git checkout feature/user-profile
git rebase -i main
# Mark auth commit as 'edit'
# Make changes when rebase stops
git add -p  # Carefully stage parts
git commit --amend
git commit -m "Split out validation logic"
git rebase --continue
# Force push
git push --force origin feature/user-profile
```

#### Jujutsu Approach
```bash
# Simply edit the change that needs updating
jj edit <auth-change-id>
# Make the changes
vim src/middleware/auth.js
# Already saved!
jj split  # Interactive split into two changes
jj git push  # Push the updates
```

### The Power of jj: Experimental Changes

Want to try a different approach without losing current work?

#### Git Approach
```bash
# Create a new branch
git checkout -b feature/user-profile-experiment
# or use worktrees (more setup)
# or stash (loses context)
```

#### Jujutsu Approach
```bash
# Just create a new change!
jj new @- -m "Experimental approach"
# Try stuff out
# Don't like it?
jj abandon  # Remove it
jj edit @+  # Back to original
```

## Working with Git Worktrees & Bare Repos

### Git Worktree Setup

Traditional Git workflow with worktrees:

```bash
# Create bare repo
git clone --bare https://github.com/user/project.git project.git
cd project.git

# Add worktrees for different branches
git worktree add ../project-main main
git worktree add ../project-feature feature-branch
git worktree add ../project-hotfix

# Work in different directories
cd ../project-feature
git pull
# make changes
git add .
git commit -m "Feature work"
git push

cd ../project-hotfix
git checkout -b hotfix/urgent
# make changes
git add .
git commit -m "Urgent fix"
git push origin hotfix/urgent
```

### Jujutsu with Colocated Git

With jj, you get similar benefits without the complexity:

```bash
# Clone with jj (creates colocated .git)
jj git clone https://github.com/user/project.git project
cd project

# Work on multiple changes in parallel
jj new main -m "Feature work"
# make changes - automatically saved

# Need to work on hotfix? Just create another change
jj new main -m "Urgent hotfix"
# make hotfix changes

# Switch between them anytime
jj edit @-  # Back to feature
jj edit @+  # Back to hotfix

# Or use jj workspaces (similar to git worktrees)
jj workspace add ../project-hotfix
cd ../project-hotfix
# This is a view of the same repo!
```

### How JJ History Appears in Git

This is crucial to understand - jj creates a different history model that's mapped to Git:

#### During Development (jj log)
```
# What you see in jj:
@  mzvwutvl user@example.com 2024-03-20 19:30:00 7f8d9c3a
│  Feature: Add profile API
○  qpvuntsm user@example.com 2024-03-20 19:25:00 2b4e6a8f
│  Experimental: Try different approach
│ ○  rlvkpnrz user@example.com 2024-03-20 19:20:00 9c3f5d1b
├─╯  Hotfix: Security patch
○  kxvptpwx user@example.com 2024-03-20 19:15:00 main 4a7b2c9e
│  Previous work
```

#### What Git Sees (git log)
```bash
# During development - before jj git push
git log --oneline
# Only shows the main branch commits
4a7b2c9e Previous work

# The working directory shows jj's current change
git status
# Shows uncommitted changes (jj's automatic commits aren't in git yet)
```

#### After jj git push
```bash
# First, let's clean up and push
jj abandon qpvuntsm  # Remove experimental change
jj describe mzvwutvl -m "Add profile API with authentication"
jj bookmark create feature/profile
jj git push --bookmark feature/profile

# Now git sees:
git log --oneline --graph --all
* 7f8d9c3a (feature/profile) Add profile API with authentication
| * 9c3f5d1b (hotfix/security) Security patch
|/
* 4a7b2c9e (main) Previous work
```

### Key Differences: JJ vs Git History

| Aspect | Git | Jujutsu |
|--------|-----|---------|
| Working changes | Must be committed or stashed | Always in a change |
| History model | Linear within branch | DAG of changes |
| Commit identity | SHA never changes | Change ID stable, git SHA generated on push |
| Empty commits | Usually avoided | Normal during development |
| Parallel work | Requires branches/worktrees | Just create new changes |

### Example: How JJ Maps to Git

Let's trace a complete workflow:

```bash
# Start in jj
jj new main -m "WIP: Add user service"
echo "class UserService {}" > user_service.js

# Git status shows uncommitted changes
git status
# modified: user_service.js

# Continue in jj
jj new -m "WIP: Add tests"
echo "test('user service')" > user_service.test.js

# Git still shows uncommitted
git status
# modified: user_service.js
# modified: user_service.test.js

# Clean up in jj
jj squash  # Combine test with service
jj describe -m "Add user service with tests"

# Push to git
jj git push --bookmark feature/user-service

# NOW git sees a clean commit
git log --oneline
# 8d4f9c2a Add user service with tests
# 4a7b2c9e Previous work
```

### Working with Existing Git Worktrees

If you have existing Git worktrees, you can use jj with them:

```bash
# In existing git worktree
cd ~/project-worktrees/feature
jj git init --colocate  # Add jj to existing git repo

# Now you can use jj commands
jj log  # See current state
jj new  # Start new change
# Work normally...
jj git push  # Push through git
```

### Best Practices for Git Interop

1. **Colocated repos**: Use `jj git init --colocate` for seamless Git integration
2. **Clean history before pushing**: Use `jj squash`, `jj describe` to prepare changes
3. **Bookmark management**: Create bookmarks before pushing (`jj bookmark create`)
4. **Understanding the mapping**:
   - jj changes → Git staging area (until pushed)
   - jj bookmarks → Git branches
   - jj change IDs → Git commit SHAs (generated on push)

### Visualizing the Difference

```bash
# Git worktree workflow (multiple directories)
project.git/           # Bare repo
project-main/          # Worktree for main
  └── .git            # Link to bare repo
project-feature/       # Worktree for feature
  └── .git            # Link to bare repo
project-hotfix/        # Worktree for hotfix
  └── .git            # Link to bare repo

# Jujutsu workflow (single directory)
project/
  ├── .git            # Colocated git repo
  └── .jj             # Jujutsu metadata
      └── repo
          └── store   # All changes stored here

# Or with jj workspaces
project/              # Main workspace
  ├── .git
  └── .jj
project-hotfix/       # Additional workspace
  └── .jj             # Links to same .jj/repo/store
```

The key insight: jj manages multiple changes in one directory, while Git needs multiple directories (worktrees) for parallel work.

## Quick Reference Card

```bash
# Start work
jj new main              # Start from main
jj new                   # Start from current

# Save work
jj describe -m "msg"     # Set message
jj commit -m "msg"       # Finish change, start new

# Navigate
jj edit <change>         # Go to change
jj edit @-               # Go to parent

# Modify history
jj squash                # Into parent
jj split                 # Split current
jj rebase -d <target>    # Rebase onto

# Collaborate
jj git fetch             # Get changes
jj git push              # Share changes
```

Remember: In jj, you're always in a change, and every edit is saved. Think of it as Git with auto-commit and unlimited undo!
