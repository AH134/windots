export PATH=$HOME/.local/bin:$HOME/bin:/usr/local/bin:$HOME/.cargo/bin:$PATH
export GOPATH=$HOME/go
export PATH=$PATH:$GOPATH/bin

export HISTFILE=$HOME/.zsh_history
export HISTSIZE=10000
export SAVEHIST=10000
setopt SHARE_HISTORY
setopt HIST_IGNORE_DUPS

alias ls='eza --icons --group-directories-first'
alias la='eza -la --icons --group-directories-first'
alias ll='eza -l --icons --group-directories-first'
alias tree='eza --tree'
alias vi='nvim'
alias vim='nvim'

export NVM_DIR="$HOME/.nvm"
load_nvm() {
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
    [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
}
nvm()  { unset -f nvm;  load_nvm; nvm "$@"; }
node() { unset -f node; load_nvm; node "$@"; }
npm()  { unset -f npm;  load_nvm; npm "$@"; }
npx()  { unset -f npx;  load_nvm; npx "$@"; }

eval "$(starship init zsh)"
eval "$(zoxide init zsh --cmd cd)"

autoload -Uz compinit && compinit
source /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh
