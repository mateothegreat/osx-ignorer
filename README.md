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

```bash

```
