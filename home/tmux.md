# tmux Shortcuts

Prefix key used in this configuration:

```
Ctrl + a
```

Most tmux commands start with **Prefix → Key**.

Example:
`Ctrl + a` then `c` means **press Ctrl+a, release, then press c**.

---

# Session Shortcuts

| Shortcut   | What it does                                             |
| ---------- | -------------------------------------------------------- |
| `Ctrl+a C` | Create a new tmux session                                |
| `Ctrl+a s` | Open session tree to browse sessions, windows, and panes |
| `Ctrl+a d` | Detach from the current session                          |

---

# Window Shortcuts

| Shortcut   | What it does                                 |
| ---------- | -------------------------------------------- |
| `Ctrl+a c` | Create a new window in the current directory |
| `Ctrl+a n` | Move to the next window                      |
| `Ctrl+a p` | Move to the previous window                  |
| `Ctrl+a w` | Show a list of windows                       |

---

# Pane Creation

| Shortcut    | What it does                                     |
| ----------- | ------------------------------------------------ |
| `Ctrl+a "`  | Split pane vertically (top/bottom)               |
| `Ctrl+a %`  | Split pane horizontally (left/right)             |
| `Ctrl+a -`  | Split pane vertically (top/bottom, easier key)   |
| `Ctrl+a \|` | Split pane horizontally (left/right, easier key) |

---

# Pane Navigation

| Shortcut   | What it does                  |
| ---------- | ----------------------------- |
| `Ctrl+a h` | Move to the pane on the left  |
| `Ctrl+a j` | Move to the pane below        |
| `Ctrl+a k` | Move to the pane above        |
| `Ctrl+a l` | Move to the pane on the right |

---

# Smart Navigation (tmux + Neovim)

These work **without using the prefix key**.

| Shortcut | What it does                          |
| -------- | ------------------------------------- |
| `Ctrl+h` | Move to the left pane or Neovim split |
| `Ctrl+j` | Move to the pane below                |
| `Ctrl+k` | Move to the pane above                |
| `Ctrl+l` | Move to the pane on the right         |

These work across **tmux panes and Neovim splits seamlessly**.

---

# Pane Resizing

| Shortcut   | What it does             |
| ---------- | ------------------------ |
| `Ctrl+a H` | Resize pane to the left  |
| `Ctrl+a J` | Resize pane downward     |
| `Ctrl+a K` | Resize pane upward       |
| `Ctrl+a L` | Resize pane to the right |

Each press resizes the pane by **5 cells**.

---

# Copy Mode (Vi style)

Enter copy mode:

```
Ctrl+a [
```

Then use these keys:

| Shortcut | What it does                              |
| -------- | ----------------------------------------- |
| `v`      | Start selecting text                      |
| `Ctrl+v` | Start rectangular selection               |
| `y`      | Copy the selected text and exit copy mode |

The copied text goes to your **system clipboard**.

---

# Configuration

| Shortcut   | What it does                  |
| ---------- | ----------------------------- |
| `Ctrl+a r` | Reload the tmux configuration |

---

# Useful tmux Commands Outside tmux

Start tmux:

```
tmux
```

Attach to an existing session:

```
tmux attach
```

List sessions:

```
tmux ls
```

Kill a session:

```
tmux kill-session -t SESSION_NAME
```

---

# Quick Example Workflow

Create a new window:

```
Ctrl+a c
```

Split the window:

```
Ctrl+a |
Ctrl+a -
```

Move between panes:

```
Ctrl+h
Ctrl+j
Ctrl+k
Ctrl+l
```

Copy text:

```
Ctrl+a [
v
select text
y
```

Detach:

```
Ctrl+a d
```
