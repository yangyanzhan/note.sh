#!/usr/bin/env bash

# Note.sh is a text-based note keeping software completely written in shell script created by Yang Yanzhan.
# I"m interested in all kinds of algorithmic problems. If you want to learn more about me, you can visit my [Youtube Channel](https://www.youtube.com/channel/UCDkz-__gl3frqLexukpG0DA?view_as=subscriber), [Twitter Account](https://twitter.com/YangYanzhan) or [GitHub Repo](https://github.com/yangyanzhan/code-camp)
# Also, Note.sh project is hosted on my [GitHub Repo](https://github.com/yangyanzhan/note.sh). If you like this project, don"t forget visit my GitHub Repo, star it and then follow me.

action=$1
arg1=$2
arg2=$3
arg3=$4
arg4=$5
arg5=$6

setup() {
    # setup global variables
    # project root directory
    root_dir=$(dirname $BASH_SOURCE)
    # note storage directory
    note_dir="${root_dir}/.note"
    # meta info
    info_filename="info"
    # directory where title resides
    title_sub_dir="title"
    # directory where content resides
    content_sub_dir="content"
    # directory where tag resides
    tag_sub_dir="tag"
    # directory where image resides
    image_sub_dir="image"
    # colors
    nocolor="\033[0m"
    red="\033[0;31m"
    green="\033[0;32m"
    orange="\033[0;33m"
    blue="\033[0;34m"
    purple="\033[0;35m"
    cyan="\033[0;36m"
    lightgray="\033[0;37m"
    darkgray="\033[1;30m"
    lightred="\033[1;31m"
    lightgreen="\033[1;32m"
    yellow="\033[1;33m"
    lightblue="\033[1;34m"
    lightpurple="\033[1;35m"
    lightcyan="\033[1;36m"
    white="\033[1;37m"
    # check project environment and setup
    if [ ! -e $note_dir ]; then
        echo -e "${yellow}creating note storage directory...${nocolor}"
        mkdir -p "${note_dir}/${title_sub_dir}"
        mkdir -p "${note_dir}/${content_sub_dir}"
        mkdir -p "${note_dir}/${tag_sub_dir}"
        mkdir -p "${note_dir}/${image_sub_dir}"
        echo 1 > "${note_dir}/${info_filename}"
        echo -e "${green}done${nocolor}"
    fi
    max_no=$(cat "${note_dir}/${info_filename}")
}

inc_no() {
    max_no=$(( $max_no + 1 ))
    echo $max_no > "${note_dir}/${info_filename}"
}

new() {
    echo -e "${yellow}creating new note #${max_no} ...${nocolor}"
    title=$arg1
    echo $title > "${note_dir}/${title_sub_dir}/${max_no}"
    inc_no
    echo -e "${green}done${nocolor}"
}

view() {
    no=$1
    title=""
    title_path="${note_dir}/${title_sub_dir}/${no}"
    if [ ! -e $title_path ]; then
        echo -e "${red}#${no} does not exist${nocolor}"
        return
    fi
    echo -e "${yellow}#${no}${nocolor}"
    title=$(cat "${title_path}")
    echo -e "${green}title:${nocolor}"
    echo -e "${nocolor}${title}${nocolor}"
    content="empty"
    content_path="${note_dir}/${content_sub_dir}/${no}"
    echo -e "${green}content:${nocolor}"
    if [ -e $content_path ]; then
        content=$(cat $content_path)
        echo -e "${nocolor}${content}${nocolor}"
    else
        echo -e "${red}${content}${nocolor}"
    fi
}

list() {
    nos=$(ls "${note_dir}/${title_sub_dir}")
    for no in $nos
    do
        view $no
    done
}

edit() {
    echo "editing"
}

main() {
    setup
    if [[ $action == "ls" ]]; then
        list
    elif [[ $action == "list" ]]; then
        list
    elif [[ $action == "new" ]]; then
        new
    elif [[ $action == "view" ]]; then
        view $arg1
    elif [[ $action == "edit" ]]; then
        edit
    fi
}

main
