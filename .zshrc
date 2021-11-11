# The following lines were added by compinstall

# поддержка ~… и file completion после = в аргументах
setopt MAGIC_EQUAL_SUBST

zstyle ':completion:*' completer _complete _ignored _approximate
zstyle ':completion:*' list-colors ''
zstyle ':completion:*' menu select=1
zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s
zstyle ':completion:*' rehash true
zstyle :compinstall filename '/home/bershatsky/.zshrc'

autoload -Uz compinit
compinit
# End of lines added by compinstall

autoload -Uz promptinit
promptinit

autoload -Uz edit-command-line
zle -N edit-command-line

# Move over path segments
local WORDCHARS='*?_-.[]~=&;!#$%^(){}<>'

# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=50000
SAVEHIST=50000
setopt appendhistory autocd extendedglob # new settings nomatch notify
unsetopt beep
bindkey -e
# End of lines configured by zsh-newuser-install

# Setup prompt
setprompt() {
  setopt prompt_subst

  if [[ -n "$SSH_CLIENT"  ||  -n "$SSH2_CLIENT" ]]; then
    p_host='%F{yellow}%M%f'
  else
    p_host='%F{green}%M%f'
  fi

  PS1='%F{white}%B[%b%f%F{yellow}%n%f%B@%b%F{cyan}%m%f %F{magenta}%1~%f%B]%(#.#.$)%b '
  PS2='%F{white}%B[%b%f%F{yellow}%n%f%B@%b%F{cyan}%m%f %F{magenta}%1~%f%B]%\>%b '
  PS4='%D{%H:%M:%S.%.} '

  RPROMPT=$'${vcs_info_msg_0_}'
}

setprompt

# Setup aliases
alias diff='diff -u --color=auto'
alias grep='grep --color=auto'
alias ls='ls --color=auto -h'
alias vi='/usr/bin/nvim'

# Key bindings
autoload zkbd

bindkey "${terminfo[khome]}" beginning-of-line
bindkey "${terminfo[kend]}" end-of-line
bindkey "\e[3~" delete-char  # TODO: find more appraopriate way
bindkey "${terminfo[kdch1]}" delete-char  # TODO: find more appraopriate way
bindkey "^X^E" edit-command-line

# urxvt/rxvt-unicode (and maybe others):
#bindkey "^[Od" backward-word  # Control + LeftArrow
#bindkey "^[Oc" forward-word  # Control + RightArrow
#bindkey "OC" forward-word  # Control + RightArrow
#bindkey "OD" backward-word  # Control + LeftArrow
bindkey '[1;5D' emacs-backward-word
bindkey '[1;5C' emacs-forward-word
bindkey '^[[3^' kill-word

# Set up completion
plugins=(
    man
    pip
)

autoload -U +X bashcompinit && bashcompinit
complete -o nospace -C /usr/bin/vault vault
complete -o nospace -C /usr/bin/terraform terraform

# Initialize zoxide.
eval "$(zoxide init zsh)"
