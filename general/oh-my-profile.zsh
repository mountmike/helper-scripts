export ZSH="${HOME}/.oh-my-zsh"
export ZSH_THEME="agnoster"
plugins=(
  git
  zsh-autosuggestions
  zsh-syntax-highlighting
)

source "$ZSH/oh-my-zsh.sh"

ZSH_THEME="agnoster" # see https://github.com/ohmyzsh/ohmyzsh/wiki/Themes#agnoster

alias c='clear'
alias reload='source ~/.zshrc'