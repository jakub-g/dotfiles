#!/bin/bash

alias timer='node -e "i=0;setInterval(()=>console.log(++i),1e3)"'
todo() {
    echo "- [$(date '+%a %d.%m %Hh%M')] $*" >> ~/todo.txt
}
alias todos='cat ~/todo.txt'
alias todo-clean='echo "" > ~/todo.txt'
doin() {
    if [ "$#" == "0" ]; then
        doins
        return
    fi
    echo "- [$(date '+%a %d.%m %Hh%M')] $*" >> ~/doin.txt
}
alias doing='doin'
alias doins='cat ~/doin.txt'
alias doinls='doins'
alias doin-clean='echo "" > ~/doin.txt'

# Usage: gzlen file.html
gzlen() {
    gzip -kc7 "$1" | wc -c
}

# Usage: brlen9 file.html
brlen9() {
    brotli --in "$1" --out temp.br --force --quality 9 && wc -c temp.br
}
# Usage: brlen11 file.html
brlen11() {
    brotli --in "$1" --out temp.br --force --quality 11 && wc -c temp.br
}