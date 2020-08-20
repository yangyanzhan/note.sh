#!/usr/bin/env bash

# Note.sh is a text-based note keeping software completely written in shell script created by Yang Yanzhan.
# I"m interested in all kinds of algorithmic problems. If you want to learn more about me, you can visit my [Youtube Channel](https://www.youtube.com/channel/UCDkz-__gl3frqLexukpG0DA?view_as=subscriber), [Twitter Account](https://twitter.com/YangYanzhan) or [GitHub Repo](https://github.com/yangyanzhan/code-camp)
# Also, Note.sh project is hosted on my [GitHub Repo](https://github.com/yangyanzhan/note.sh). If you like this project, don"t forget visit my GitHub Repo, star it and then follow me.

params=""

action=""
arg1=""
arg2=""
arg3=""
arg4=""
arg5=""

arg_tag=""
arg_title_flag=0

while (( "$#" )); do
    case "$1" in
        --title)
            arg_title_flag=1
            shift
            ;;
        --tag)
            if [ -n "$2" ] && [ ${2:0:1} != "-" ]; then
                arg_tag=$2
                shift 2
            else
                echo "${red}Error: Argument for $1 is missing${nocolor}" >&2
                exit 1
            fi
            ;;
        -*|--*=)
            echo -e "${red}Error: Unsupported Option $1${nocolor}" >&2
            exit 1
            ;;
        *)
            params="$params $1"
            if [[ $action == "" ]]; then
                action=$1
            elif [[ $arg1 == "" ]]; then
                arg1=$1
            elif [[ $arg2 == "" ]]; then
                arg2=$1
            elif [[ $arg3 == "" ]]; then
                arg3=$1
            elif [[ $arg4 == "" ]]; then
                arg4=$1
            elif [[ $arg5 == "" ]]; then
                arg5=$1
            fi
            shift
            ;;
    esac
done

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

install() {
    echo "placeholder for installation"
}

inc_no() {
    max_no=$(( $max_no + 1 ))
    echo $max_no > "${note_dir}/${info_filename}"
}

new() {
    echo -e "${yellow}creating new note #${max_no} ...${nocolor}"
    title=$arg1
    title_path="${note_dir}/${title_sub_dir}/${max_no}"
    if [[ $title == "" ]]; then
        vi $title_path
    else
        echo $title > $title_path
    fi
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
    no=$1
    title_path="${note_dir}/${title_sub_dir}/${no}"
    if [ ! -e $title_path ]; then
        echo -e "${red}#${no} does not exist${nocolor}"
        return
    fi
    if [[ $arg_title_flag == 1 ]]; then
        title_path="${note_dir}/${title_sub_dir}/${no}"
        vi $title_path
    else
        content_path="${note_dir}/${content_sub_dir}/${no}"
        vi $content_path
    fi
}

tag() {
    no=$1
    tag=$2
    title_path="${note_dir}/${title_sub_dir}/${no}"
    if [ ! -e $title_path ]; then
        echo -e "${red}#${no} does not exist${nocolor}"
        return
    fi
    tag_path="${note_dir}/${tag_sub_dir}/${no}"
    echo $tag > $tag_path
}

attach() {
    echo "placeholder for attach action"
}

main() {
    setup
    if [[ $action == "install" ]]; then
        install
    elif [[ $action == "l" ]]; then
        list
    elif [[ $action == "ls" ]]; then
        list
    elif [[ $action == "list" ]]; then
        list
    elif [[ $action == "n" ]]; then
        new
    elif [[ $action == "new" ]]; then
        new
    elif [[ $action == "v" ]]; then
        view $arg1
    elif [[ $action == "view" ]]; then
        view $arg1
    elif [[ $action == "e" ]]; then
        edit $arg1
    elif [[ $action == "edit" ]]; then
        edit $arg1
    elif [[ $action == "t" ]]; then
        tag $arg1 $arg2
    elif [[ $action == "tag" ]]; then
        tag $arg1 $arg2
    elif [[ $action == "a" ]]; then
        attach
    elif [[ $action == "attach" ]]; then
        attach
    fi
}

main
