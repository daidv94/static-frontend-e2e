# Get changed directories

This action gets all changed directories in a PR an cteate outputs which can be used as matrix input.

## Usage

```yaml
- uses: actions/checkout@v3
  with:
    fetch-depth: 0

- name: Get all changed dirs
  uses: ./github/actions/get-changed-dirs
  with:
    # Paths patterns to detect changes (using `glob` partern matching).
    paths: |
      services/**
```
