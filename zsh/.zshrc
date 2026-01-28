# Auto-start tmux (robust version)
_start_tmux() {
    # Bail out early if tmux isn't installed
    command -v tmux &>/dev/null || return 1

    # Already in tmux/screen
    [ -n "$TMUX" ] && return 1
    [[ "$TERM" =~ (screen|tmux) ]] && return 1

    # Non-interactive shell (scripts, scp, rsync, etc.)
    [[ $- != *i* ]] && return 1
    [ ! -t 0 ] && return 1

    # Editor/IDE embedded terminals
    [ -n "$EMACS" ] && return 1
    [ -n "$VIM" ] && return 1
    [ -n "$INSIDE_EMACS" ] && return 1
    [ "$TERM_PROGRAM" = "vscode" ] && return 1
    [ "$TERMINAL_EMULATOR" = "JetBrains-JediTerm" ] && return 1

    # CI/CD and automation environments
    [ -n "$CI" ] && return 1
    [ -n "$GITHUB_ACTIONS" ] && return 1
    [ -n "$GITLAB_CI" ] && return 1
    [ -n "$JENKINS_HOME" ] && return 1
    [ -n "$ANSIBLE_HOME" ] && return 1
    [ -n "$PUPPET_HOME" ] && return 1

    # Remote sessions where tmux may be unwanted
    [ -n "$SSH_CONNECTION" ] && [ -z "$TERMUX_VERSION" ] && return 1
    [ -n "$MOSH" ] && return 1

    # Containers/chroots (optional - remove if you want tmux in containers)
    [ -f /.dockerenv ] && return 1
    [ -n "$container" ] && return 1

    # Dumb terminals / serial consoles
    [ "$TERM" = "dumb" ] && return 1
    [ "$TERM" = "linux" ] && return 1

    # Nested shell depth check (subshells shouldn't start tmux)
    [ "${SHLVL:-1}" -gt 1 ] && return 1

    # Manual bypass: `NO_TMUX=1 termux` or touch ~/.no_tmux
    [ -n "$NO_TMUX" ] && return 1
    [ -f "$HOME/.no_tmux" ] && return 1

    # Ensure tmux server is healthy (handles corrupt state)
    if ! tmux list-sessions &>/dev/null; then
        # Server not running or crashed - try starting fresh
        tmux kill-server &>/dev/null
    fi

    return 0
}

if _start_tmux; then
    unset -f _start_tmux
    exec tmux new-session -A -s main
fi
unset -f _start_tmux

export EDITOR=nvim
autoload -U colors && colors
PS1="%B%{$fg[red]%}[%{$fg[yellow]%}%n%{$fg[green]%}@%{$fg[blue]%}%M %{$fg[magenta]%}%~%{$fg[red]%}]%{$reset_color%}$%b "

# History configuration
HISTSIZE=1000000
SAVEHIST=1000000
HISTFILE=~/.zsh_history

setopt SHARE_HISTORY             # Share history between sessions (includes immediate write)
setopt EXTENDED_HISTORY          # Record timestamp with each command
setopt HIST_REDUCE_BLANKS        # Remove extra whitespace

autoload -Uz compinit
zstyle ':completion:*' menu select
zmodload zsh/complist
# Only regenerate compinit cache once per day for performance
if [[ -n ~/.zcompdump(#qN.mh+24) ]]; then
    compinit
else
    compinit -C
fi
_comp_options+=(globdots)		# Include hidden files.

alias ls='logo-ls'
alias la='logo-ls -A'
alias ll='logo-ls -al'
alias mot_server='ssh -C debian@57.128.170.234'
alias dev_server='ssh -C debian@51.178.139.7'
alias tmux_reload='tmux source-file ~/.config/tmux/tmux.conf'

# vi mode
bindkey -v
export KEYTIMEOUT=1

# Use vim keys in tab complete menu:
bindkey -M menuselect 'h' vi-backward-char
bindkey -M menuselect 'k' vi-up-line-or-history
bindkey -M menuselect 'l' vi-forward-char
bindkey -M menuselect 'j' vi-down-line-or-history
bindkey -v '^?' backward-delete-char

# Change cursor shape for different vi modes.
function zle-keymap-select {
  if [[ ${KEYMAP} == vicmd ]] ||
     [[ $1 = 'block' ]]; then
    echo -ne '\e[1 q'
  elif [[ ${KEYMAP} == main ]] ||
       [[ ${KEYMAP} == viins ]] ||
       [[ ${KEYMAP} = '' ]] ||
       [[ $1 = 'beam' ]]; then
    echo -ne '\e[5 q'
  fi
}
zle -N zle-keymap-select
zle-line-init() {
    zle -K viins # initiate `vi insert` as keymap (can be removed if `bindkey -V` has been set elsewhere)
    echo -ne "\e[5 q"
}
zle -N zle-line-init
echo -ne '\e[5 q' # Use beam shape cursor on startup.
autoload -Uz add-zsh-hook
_reset_cursor() { echo -ne '\e[5 q' }
add-zsh-hook preexec _reset_cursor

# Edit line in vim with ctrl-e:
autoload edit-command-line; zle -N edit-command-line
bindkey '^e' edit-command-line


source /data/data/com.termux/files/home/.local/bin/zsh-autosuggestions/zsh-autosuggestions.zsh
source /data/data/com.termux/files/home/.local/bin/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
