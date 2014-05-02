#!/bin/bash

todo() {
    echo "- [$(date '+%a %d.%m %Hh%M')] $*" >> ~/todo.txt
}
alias todos='cat ~/todo.txt'
alias todo-clean='echo "" > ~/todo.txt'
doin() {
    echo "- [$(date '+%a %d.%m %Hh%M')] $*" >> ~/doin.txt
}
alias doing='doin'
alias doins='cat ~/doing.txt'
alias doin-clean='echo "" > ~/doin.txt'
