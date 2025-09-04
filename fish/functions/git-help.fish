function git-help --description "Show git workflow commands"
    echo (set_color cyan)"=== Git Workflow Commands ==="(set_color normal)
    echo ""
    echo (set_color yellow)"Navigation:"(set_color normal)
    echo "  gst          - Git status"
    echo "  gbdiff       - Show files changed vs release branch"
    echo "  ghunks       - Show all hunks with staging status"
    echo ""
    echo (set_color yellow)"Staging:"(set_color normal)
    echo "  ga <file>    - Stage specific file"
    echo "  gaa          - Stage all changes"
    echo "  gap          - Stage interactively (patch mode)"
    echo "  gsi          - Stage with fzf (interactive)"
    echo "  grh          - Unstage all (reset HEAD)"
    echo ""
    echo (set_color yellow)"Diffs:"(set_color normal)
    echo "  gd           - Show unstaged changes"
    echo "  gdc/gds      - Show staged changes"
    echo "  gdst         - Show diff statistics"
    echo ""
    echo (set_color yellow)"Committing:"(set_color normal)
    echo "  gqc          - Quick commit (interactive)"
    echo "  gqc <msg>    - Quick commit with message"
    echo "  gc           - Git commit"
    echo "  gcm <msg>    - Git commit with message"
    echo "  gca          - Git commit all tracked files"
    echo ""
    echo (set_color yellow)"Branches:"(set_color normal)
    echo "  gco <branch> - Switch to branch"
    echo "  gcb <name>   - Create and switch to new branch"
    echo "  gb           - List branches"
    echo "  gba          - List all branches (including remote)"
    echo ""
    echo (set_color yellow)"History:"(set_color normal)
    echo "  gl           - Git log"
    echo "  glg          - Git log with graph"
    echo "  glf <file>   - Git log follow file"
    echo "  gbl          - Git blame"
    echo ""
    echo (set_color yellow)"Remote:"(set_color normal)
    echo "  gf           - Fetch from remote"
    echo "  gpl          - Pull from remote"
    echo "  gp           - Push to remote"
    echo ""
    echo (set_color yellow)"Nvim Integration:"(set_color normal)
    echo "  <leader>gd   - Files changed vs release branch (picker)"
    echo "  <leader>gD   - Files changed vs custom branch (picker)"
    echo "  <leader>gh   - Hunks picker (stage/unstage/reset)"
    echo "  <leader>gC   - Commit from nvim"
    echo "  <leader>gl   - LazyGit"
    echo "  [h / ]h      - Navigate hunks"
    echo "  ghs/ghu/ghr  - Stage/Unstage/Reset hunk"
    echo ""
    echo (set_color green)"Type 'lz' or '<leader>gl' in nvim for full LazyGit UI"(set_color normal)
end