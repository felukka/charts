# Felukka Helm Charts

Helm chart repository for Felukka workloads.

- Chart repository URL: https://charts.felukka.org
- Source charts location: `charts/`

## Repository Structure

- `charts/<chart-name>/`: individual chart source
- `.github/workflows/`: CI validation and pull request checks

## Working with a Chart

From the repository root:

```bash
helm lint charts/<chart-name>
helm install <release-name> charts/<chart-name> --dry-run --debug
```

Example for `koptan`:

```bash
helm lint charts/koptan
helm install test-release charts/koptan --dry-run --debug
```

## Pull Request Conventions

- Change only one chart per pull request.
- PR title must start with `[<chart-name>] ` (example: `[koptan] bump image tag`).
