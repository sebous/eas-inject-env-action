# sebous/eas-inject-env-action

[![Tests](https://github.com/sebous/eas-inject-env-action/actions/workflows/tests.yml/badge.svg)](https://github.com/sebous/eas-inject-env-action/actions/workflows/tests.yml)

GitHub Action for injecting environment variables or secrets into eas.json file before running `eas submit` command.

## Inputs

### Required

- **eas_env**: environment in eas.json file found under the `build` property. Example `production`
- **eas_json_path**: path to eas.json file. Example `./eas.json`
- **env_vars**: An (optionally) multi-line string containing environment variable definitions in the form `NAME=value`.

## Examples

### Single value

```yml
- uses: sebous/eas-inject-env-action
  with:
    eas_env: production
    eas_json_path: ./eas.json
    env_vars: API_KEY=123 
```

### Multiple values

```yml
- uses: sebous/eas-inject-env-action
  with:
    eas_env: staging
    eas_json_path: ./eas.json
    env_vars: |- 
      API_KEY=${{ env.API_KEY }}
      ENV=production
      SECRET=${{ secrets.SECRET }} 
```
