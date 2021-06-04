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

`<file to match>:<relative directory to exclude>

or just

`<some directory by itself>`

Such as:

```
package.json:node_modules
requirements.txt:venv
```
## Ignore node_modules and venv from base path

```bash
./ignore.sh --base-path ~/myprojectsroot apply
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
