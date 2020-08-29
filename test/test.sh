#!/usr/bin/env bash

# colors
nocolor="\033[0m"
red="\033[0;31m"
orange="\033[0;33m"

curr_dir=$(pwd)
alias n="${curr_dir}/note.sh"

test() {
    echo "${orange}* ${red}setup test env${nocolor}"
    n clear
    echo ""

    echo "${orange}* ${red}test action new${nocolor}"
    n new "the best thing about shell"
    n new "yanzhan blog"
    echo ""

    echo "${orange}* ${red}test action tag${nocolor}"
    n tag 1 shell,tutorial
    n tag 2 tutorial
    echo ""

    echo "${orange}* ${red}test action view${nocolor}"
    n view 1
    echo ""

    echo "${orange}* ${red}test action list${nocolor}"
    n ls --verbose
    echo ""

    echo "${orange}* ${red}test action list to list all tags${nocolor}"
    n ls tag
    echo ""

    echo "${orange}* ${red}test action list with tag filter${nocolor}"
    n ls --tag shell
    echo ""

    echo "${orange}* ${red}test action list for done notes${nocolor}"
    n ls --done
    echo ""

    echo "${orange}* ${red}test action list to list all aliases${nocolor}"
    n ls alias
    echo ""

    echo "${orange}* ${red}test action search${nocolor}"
    n search Shell
    echo ""

    echo "${orange}* ${red}test action search with case sensitivity${nocolor}"
    n search Shell --case
    echo ""

    echo "${orange}* ${red}test action search with verbose mode${nocolor}"
    n search shell --verbose
    echo ""

    echo "${orange}* ${red}test action search with tag filter${nocolor}"
    n search shell --tag undefined
    echo ""

    echo "${orange}* ${red}test action delete${nocolor}"
    n remove 2
    n ls
    echo ""

    echo "clear test env"
    n clear
}

last_root_dir=$NOTE_ROOT_DIR
test_dir=$(dirname $BASH_SOURCE)
cd $test_dir > /dev/null
test_dir=$(pwd)
cd - > /dev/null
export NOTE_ROOT_DIR=$test_dir
test
export NOTE_ROOT_DIR=$last_root_dir

