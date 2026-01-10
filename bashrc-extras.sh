# create worktree with shared Claude config (or cd to existing one)
claude-tree() {
  local branch="${1:-$(git branch --show-current)-wt}"
  local main_repo="$(git rev-parse --show-toplevel)"
  local repo_name="$(basename "$main_repo")"
  local dir="../${repo_name}-${branch}"

  if [[ -f "$main_repo/.nvmrc" ]]; then
    (cd "$main_repo" && nvm use)
  fi

  if [[ -d "$dir" ]]; then
    printf '\033]0;claude-tree: %s\007' "$branch"
    cd "$dir" && claude
    return
  fi

  git worktree add "$dir" -b "$branch" 2>/dev/null || git worktree add "$dir" "$branch"

  if [[ -d "$main_repo/.claude" ]]; then
    ln -sfn "$main_repo/.claude" "$dir/.claude"
  fi

  printf '\033]0;claude-tree: %s\007' "$branch"
  cd "$dir" && DISABLE_AUTO_TITLE=true claude
}

# remove worktree by branch name (-f to force)
claude-tree-rm() {
  local force=""
  if [[ "$1" == "-f" ]]; then
    force="--force"
    shift
  fi
  local branch="$1"
  local main_repo="$(git rev-parse --show-toplevel)"
  local repo_name="$(basename "$main_repo")"
  local dir="../${repo_name}-${branch}"

  git worktree remove $force "$dir"
}

# completions
_claude_tree_completions() {
  local branches
  branches=$(git branch -a 2>/dev/null | sed 's/^[* ]*//' | sed 's|remotes/origin/||' | sort -u)
  COMPREPLY=($(compgen -W "$branches" -- "${COMP_WORDS[COMP_CWORD]}"))
}

_claude_tree_rm_completions() {
  local cur="${COMP_WORDS[COMP_CWORD]}"
  local worktree_branches
  worktree_branches=$(git worktree list 2>/dev/null | tail -n +2 | sed 's/.*\[\(.*\)\]/\1/')
  COMPREPLY=($(compgen -W "-f $worktree_branches" -- "$cur"))
}

complete -F _claude_tree_completions claude-tree
complete -F _claude_tree_rm_completions claude-tree-rm
