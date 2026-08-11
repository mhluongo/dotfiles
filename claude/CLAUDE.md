# Prose style guide

Apply these rules to all documentation, comments, commit messages, and any other written prose.

## Formatting
* **No unnecessary title case.** Use sentence case for headings, list items, and labels. Reserve title case for proper nouns and the first word of a sentence.
* **Few emojis** unless explicitly requested.
* **Use ASCII diagrams** (boxes, arrows, trees) whenever a diagram would aid understanding — prefer them over prose descriptions of structure or flow.
* Use `*` for markdown lists rather than `-`

## Tone
* Prefer plain, direct language. Avoid filler phrases ("In order to", "It is worth noting that", "Please note").
* Keep sentences short. One idea per sentence.

# Git policy
* NEVER run `git rebase`, `git commit --amend`, or any other destructive git operation unless explicitly requested by the user
* NEVER run `git push` or open a pull request unless explicitly requested by the user
* NEVER include details about a Claude session in a commit message or PR unless explicitly requested by the users
* NEVER refer to counter-factual or alternative git histories in a commit message. For example, "fix the bug introduced by an old rebase" refers to git history that doesn't exist, and should be avoided
* ALWAYS prefer commiting changes directly over staging changes with `git add` or `git rm`.
* ALWAYS commit frequently. Small, logical commits, with a max of 50 characters for the subject and 72 per line for the body.
* Use `git status` and `git log` often to better understand context

# Plan files
* Plans are often symlinked from projects in `<repo>/plans/`
* Most plan directories are symlinks, and are synchronized separately from source control
* Plan files like ALL-CAPS.md are often scratchpads, rather than concrete plans
