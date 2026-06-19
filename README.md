# Personal Utility Scripts

A collection of personal shell scripts and utilities to speed up daily workflows.

---

## Tools

### `klog` — Quick Kubernetes Pod Log Viewer

Quickly tail logs from a Kubernetes pod by providing just a fragment of its name. If multiple pods match, an interactive selector (via `fzf`) lets you pick the right one.

#### Usage

```bash
klog <pod-name-fragment>       # view logs
klog -f <pod-name-fragment>    # follow (stream) logs
```

#### What it does

1. Searches for all pods in the **current namespace and context** whose name contains `<pod-name-fragment>`.
2. If **no pod** is found, prints an error and exits.
3. If **exactly one** pod matches, runs `kubectl logs [-f] <pod>` directly.
4. If **multiple pods** match, opens an interactive `fzf` selector so you can pick the right one with the arrow keys and Enter.

#### Prerequisites

| Dependency | Purpose |
|---|---|
| `kubectl` | Interact with the Kubernetes cluster |
| [`fzf`](https://github.com/junegunn/fzf) | Interactive fuzzy pod selector when multiple pods match |
| [`kubectx` / `kubens`](https://github.com/ahmetb/kubectx) | Switch context and namespace before invoking `klog` |

#### Setup

Add the following alias to your `~/.bash_aliases` (or `~/.bashrc`):

```bash
alias klog='~/dev/scripts/klog.sh'
```

Make sure the script is executable:

```bash
chmod +x ~/dev/scripts/klog.sh
```

#### Notes

- `klog` operates on the **current** `kubectl` context and namespace. It intentionally does not accept `-n <namespace>` or `--context` flags — switch context/namespace beforehand with `kubectx` / `kubens` to keep the interface as simple as possible.