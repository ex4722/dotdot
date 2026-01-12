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

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
DISABLE_UNTRACKED_FILES_DIRTY="true"

plugins=(git colored-man-pages zsh-autosuggestions zsh-syntax-highlighting enhancd)

source $ZSH/oh-my-zsh.sh

# User configuration
export LANG=en_US.UTF-8

# Path Bullshit
export PATH=$PATH:/opt/homebrew/bin
export PATH=$PATH:/Users/ex/Library/Python/3.9/bin
export PATH=$PATH:/Users/ex/Downloads/platform-tools
. "$HOME/.cargo/env"

# Set personal aliases
alias tmux="tmux -u"
alias cd-="cd -"
alias cd..="cd .."
alias cat="bat"
alias ls="eza"

alias ga="git add ."
alias gc="git commit -m"
alias gp="git push"

CURRENT_HOSTNAME=$(hostname)
if [[ "$CURRENT_HOSTNAME" == "Lyra" ]]; then
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


# VIM KEYBINDS BITCH
bindkey -v
bindkey '^F' autosuggest-accept
bindkey '^[.' insert-last-word
bindkey '^r'  fzf_history_search

bindkey '^k' up-line-or-history
bindkey '^j' down-line-or-history
bindkey -M vicmd 'k' up-line-or-history
bindkey -M vicmd 'j' down-line-or-history

bindkey -M vicmd '^r' fzf_history_search

# Set up fzf key bindings and fuzzy completion
source <(fzf --zsh)
export FZF_DEFAULT_OPTS="$FZF_DEFAULT_OPTS"\
" --color=bg+:#073642,bg:#002b36,spinner:#2aa198,hl:#268bd2"\
" --color=fg:#839496,header:#268bd2,info:#2aa198,pointer:#268bd2"\
" --color=marker:#2aa198,fg+:#eee8d5,prompt:#268bd2,hl+:#268bd2"\

export PATH=$PATH:/home/ex/.spicetify
export PATH=$PATH:/opt/nvim/bin
export PATH=$PATH:/Applications/DevEco-Studio.app/Contents/sdk/default/openharmony/toolchains
export PATH="/opt/homebrew/opt/binutils/bin:$PATH"

. ~/.asdf/plugins/java/set-java-home.zsh

. "$HOME/.local/bin/env"
