#!/bin/bash

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