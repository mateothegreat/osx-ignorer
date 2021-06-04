## Manage time machine exclusions like a boss.

This cli will allow you to easily add exclusions to time machine to
block things like `node_modules` or `venv` directories by traversing the
file system for matching patterns defined in
[ingore_paths.txt](ignore-paths.txt).

[![asciicast](https://asciinema.org/a/ntpzTxExuMLr1YDfQC3x2yyyD.png)](https://asciinema.org/a/ntpzTxExuMLr1YDfQC3x2yyyD)

## Usage

```bash
Usage: ./ignore.sh [-b base-path]

  -b, --base-path     Base directory to search under.
  -e, --exclude-path  Path to exclude.
  -f, --exclude-file  File to get base dirrectory from to then exclude.
  -d, --exclude-dir   Directory name local to --exclude-file to then exclude.

Example: ./ignore.sh --base-path ~/projects --exclude-path /some/path/venv
```

## Configuration
Define your exclusions in the ignores_paths.txt file with the pattern:

`<file to match>:<relative directory to exclude>`

or just

`<some directory by itself>`

Such as:

```
package.json:node_modules
requirements.txt:venv
```
## Ignore node_modules and venv from base path

```bash
➜  osx-timemachine-ignorer git:(main) ✗ ./ignore.sh --base-path ~/workspace/sp apply  

Finding directories matching "venv" under "/Users/yomateo/workspace/sp"..

  👉 /Users/yomateo/workspace/sp/infra/streaming-setup/venv has been excluded from Time Machine backups
  👉 /Users/yomateo/workspace/sp/infra/streaming-producer/venv has been excluded from Time Machine backups
  👉 /Users/yomateo/workspace/sp/infra/streaming-consumer/venv has been excluded from Time Machine backups

Searching for the file "package.json" under "node_modules" to ignore it's base directory..

  👉 /Users/yomateo/workspace/sp/infra/action-deploy/node_modules has been excluded from Time Machine backups
  👉 /Users/yomateo/workspace/sp/frontends/app/node_modules has been excluded from Time Machine backups
  👉 /Users/yomateo/workspace/sp/frontends/signup/node_modules has been excluded from Time Machine backups
  👉 /Users/yomateo/workspace/sp/node_modules has been excluded from Time Machine backups
  👉 /Users/yomateo/workspace/sp/services/rbac/node_modules has been excluded from Time Machine backups
  👉 /Users/yomateo/workspace/sp/services/models/node_modules has been excluded from Time Machine backups
  👉 /Users/yomateo/workspace/sp/services/cameras/node_modules has been excluded from Time Machine backups
  👉 /Users/yomateo/workspace/sp/services/models.wtf/node_modules has been excluded from Time Machine backups
  👉 /Users/yomateo/workspace/sp/services/partners/node_modules has been excluded from Time Machine backups
  👉 /Users/yomateo/workspace/sp/services/kubernetes/node_modules has been excluded from Time Machine backups
```

## List all ignores

```bash
mdfind "com_apple_backup_excludeItem = 'com.apple.backupd'"
```

## Remove all ignores
```bash
IFS=$'\n'; for FF in $(mdfind "com_apple_backup_excludeItem = 'com.apple.backupd'"); do echo "${FF}"; tmutil removeexclusion "${FF}"; done
```
## Find root node_modules
Skip nested node_modules and get the root:
