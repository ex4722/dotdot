export ZSH="/home/ex/.oh-my-zsh"

ZSH_THEME="agnoster"
DEFAULT_USER=ex
CASE_SENSITIVE="true"
HYPHEN_INSENSITIVE="true"
DISABLE_UPDATE_PROMPT="true"
POWERLEVEL9K_DISABLE_CONFIGURATION_WIZARD=true
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=#757575'
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=60'
ENABLE_CORRECTION="true"
DISABLE_UNTRACKED_FILES_DIRTY="true"

export UPDATE_ZSH_DAYS=10

plugins=(enhancd asdf git zsh-autosuggestions zsh-syntax-highlighting zsh-history-substring-search colored-man-pages zsh-fzf-history-search)

source $ZSH/oh-my-zsh.sh
source /home/ex/.oh-my-zsh/custom/themes/powerlevel10k/powerlevel10k.zsh-theme

export PATH=$PATH:~/.local/bin
export PATH=$PATH:~/.cargo/bin

# export LD_LIBRARY_PATH=/opt/llvm-project/build/lib:$LD_LIBRARY_PATH
export LC_ALL=en_US.UTF-8

export SUDO_EDITOR=`which nvim`
export EDITOR=`which nvim`
export VISUAL=`which nvim`

# personal aliases

alias tmux="tmux -u"
alias cd-="cd -"
alias cd..="cd .."
alias die="exit"
alias cat="bat"
alias ls="exa"

alias ga="git add ."
alias gc="git commit -m"
alias gp="git push"
alias clip="xclip -selection c"
alias pwnstart="docker "
alias pi="pwninit --template-path /opt/pwn_temp.py"
alias check='checksec'


alias p='ipython'
alias t='tmux'
alias g='gdb'
alias c='clear'
alias V='sudoedit'
alias v='nvim'
alias e="emacsclient -c -a 'emacs'"


# CTFing
alias www="list_ips && python3 -m http.server 8080"
alias tun0="ifconfig tun0 | grep 'inet ' | cut -d' ' -f10 | tr -d '\n' | xclip -sel clip"
py_tty_upgrade () {
  echo "python -c 'import pty;pty.spawn(\"/bin/bash\")'"| xclip -sel clip
}
py3_tty_upgrade () {
  echo "python3 -c 'import pty;pty.spawn(\"/bin/bash\")'"| xclip -sel clip
}
alias script_tty_upgrade="echo '/usr/bin/script -qc /bin/bash /dev/null'| xclip -sel clip"
alias tty_fix="stty raw -echo; fg; reset"
alias tty_conf="stty -a | sed 's/;//g' | head -n 1 | sed 's/.*baud /stty /g;s/line.*//g' | xclip -sel clip"
list_ips() {
  ip a show scope global | awk '/^[0-9]+:/ { sub(/:/,"",$2); iface=$2 } /^[[:space:]]*inet / { split($2, a, "/"); print "[\033[96m" iface"\033[0m] "a[1] }'
}

alias curlp="curl --proxy http://localhost:8080"

# VIM KEYBINDS BITCH
bindkey -v
bindkey '^F' autosuggest-accept
bindkey '^[.' insert-last-word
bindkey '^r'  fzf_history_search
bindkey '^k' history-substring-search-up
bindkey '^j' history-substring-search-down

bindkey -M vicmd 'k' history-substring-search-up
bindkey -M vicmd 'j' history-substring-search-down
bindkey -M vicmd '^r' fzf_history_search 


alias luamake=/opt/lua-language-server/3rd/luamake/luamake

# Disable zsh slow printing
pasteinit() {
  OLD_SELF_INSERT=${${(s.:.)widgets[self-insert]}[2,3]}
  zle -N self-insert url-quote-magic # I wonder if you'd need `.url-quote-magic`?
}

 pastefinish() {
   zle -N self-insert $OLD_SELF_INSERT
 }
 zstyle :bracketed-paste-magic paste-init pasteinit
 zstyle :bracketed-paste-magic paste-finish pastefinish



eval "$(thefuck --alias)"


if [ "$HOST" = "pop-os" ]; then
    # popos
else
    # do shit for nova
fi
# . ~/.asdf/plugins/golang/set-env.zsh
export GOPATH=$(dirname $(dirname `asdf which go` ))
# . ~/.asdf/plugins/java/set-java-home.zsh
export JAVAHOME=$(dirname $(dirname `asdf which java` ))
. "$HOME/.asdf/asdf.sh"
