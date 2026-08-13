# Path to your Oh My Zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time Oh My Zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="robbyrussell"


DEFAULT_USER=ex
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=#757575'
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=60'

HYPHEN_INSENSITIVE="true"
zstyle ':omz:update' mode reminder  # just remind me to update when it's time

export EDITOR="nvim"
export VISUAL="nvim"
DISABLE_UNTRACKED_FILES_DIRTY="true"

plugins=(git colored-man-pages zsh-autosuggestions zsh-syntax-highlighting enhancd)

source $ZSH/oh-my-zsh.sh


# User configuration
export LANG=en_US.UTF-8

. "$HOME/.cargo/env"

# Set personal aliases
alias tmux="tmux -u"
alias cd-="cd -"
alias cd..="cd .."
alias cat="bat"
alias ccat="/bin/cat"
alias ls="eza"

alias ga="git add ."
alias gc="git commit -m"
alias gp="git push"

alias s='sudo -E env "PATH=$PATH"'


if [[ `uname -a` == *"Darwin"* ]]; then
    export PATH=$PATH:/opt/homebrew/bin
    export PATH=$PATH:/Users/ex/Library/Python/3.9/bin
    export PATH=$PATH:/Users/ex/Downloads/platform-tools
    export PATH=$PATH:"/Applications/Racket v9.0/bin"
    export PATH=$PATH:/opt/nvim/bin
    export PATH=$PATH:~/go/bin
    export PATH=$PATH:/Applications/DevEco-Studio.app/Contents/sdk/default/openharmony/toolchains
    export PATH=$PATH:/opt/homebrew/opt/binutils/bin
    export PATH=$PATH:"/Users/ex/.local/share/solana/install/active_release/bin:"
    alias clip="tr -d '\n' | pbcopy"
else
    alias clip="xclip -selection c"
fi


# CTFing
alias pwnstart="docker "
alias pi="pwninit --template-path /opt/pwn_temp.py"
alias check='checksec'

# Shortcuts 
alias p='ipython'
alias t='tmux'
alias g='gdb'
alias c='clear'
alias V='sudoedit'
alias v='nvim'
alias e="emacsclient -c -a 'emacs'"
alias s="kitten ssh"


autoload -Uz edit-command-line
# VIM KEYBINDS BITCH
bindkey -v
bindkey '^F' autosuggest-accept
bindkey '^[.' insert-last-word
bindkey '^r'  fzf_history_search

bindkey '^k' up-line-or-history
bindkey '^j' down-line-or-history
bindkey -M vicmd 'k' up-line-or-history
bindkey -M vicmd 'j' down-line-or-history

bindkey -M vicmd '^e' edit-command-line

bindkey -M vicmd '^r' fzf_history_search

# Set up fzf key bindings and fuzzy completion
source <(fzf --zsh)
export FZF_DEFAULT_OPTS="$FZF_DEFAULT_OPTS"\
" --color=bg+:#073642,bg:#002b36,spinner:#2aa198,hl:#268bd2"\
" --color=fg:#839496,header:#268bd2,info:#2aa198,pointer:#268bd2"\
" --color=marker:#2aa198,fg+:#eee8d5,prompt:#268bd2,hl+:#268bd2"\


. ~/.asdf/plugins/java/set-java-home.zsh
export PATH="${ASDF_DATA_DIR:-$HOME/.asdf}/shims:$PATH"


. "$HOME/.local/bin/env"
# Disable zsh slow printing
pasteinit() {
  OLD_SELF_INSERT=${${(s.:.)widgets[self-insert]}[2,3]}
  zle -N self-insert url-quote-magic # I wonder if you'd need `.url-quote-magic`?
}

zstyle :bracketed-paste-magic paste-init pasteinit
zstyle :bracketed-paste-magic paste-finish pastefinish

# export ANTHROPIC_AUTH_TOKEN=13d1599a7dc9abcff8a87ac3c8c1797cf693891ec2b894b7e6ea8c10352f30b2
# export OPENAI_API_KEY=13d1599a7dc9abcff8a87ac3c8c1797cf693891ec2b894b7e6ea8c10352f30b2
# export OPENAI_BASE_URL=http://192.168.130.7:6001/v1
# export POLYCULE_TOKEN=13d1599a7dc9abcff8a87ac3c8c1797cf693891ec2b894b7e6ea8c10352f30b2
# export POLYCULE_HOST=192.168.130.7
# export POLYCULE_PORT=6001
# export POLYCULE_BASE_URL=http://192.168.130.7:6001
# export ANTHROPIC_BASE_URL=http://192.168.130.7:6001
