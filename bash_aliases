# This is the alias file for bash shell startup

alias cls='clear'
alias ll='ls -l'
alias la='ls -A'
alias lla='ls -lA'
alias cd.='cd ../'
alias cd..='cd ../../'
alias cd...='cd ../../../'
alias cd....='cd ../../../../'
alias cd.....='cd ../../../../../'

alias cp='cp -v'

alias mv='mv -v'

OS=`uname -s`
if [ ${OS} = "Linux" ]; then
alias pbcopy='xsel --clipboard --input'
alias pbpaste='xsel --clipboard --output'
fi
