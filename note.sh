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
arg_verbose_flag=0
arg_shorten_length=100
arg_done_flag=0
arg_undone_flag=0
arg_case_flag=0

my_split_comma() {
    str=$1
    if [[ $str == "" ]]; then
        local line
        read -r line
        str=$line
    fi
    IFS=','
    read -ra arr <<< "$str"
    for item in "${arr[@]}"; do
        echo "$item"
    done
    IFS=' '
}

center() {
    text="$1"
    factor="$2"
    columns=$(tput cols)
    printf ' %.0s' $(seq 1 $(($columns / $factor)))
    printf "${text}\n"
}

divider() {
    columns=$(tput cols)
    line=$(printf '=%.0s' $(seq 1 $columns))
    echo -e "${lightcyan}${line}${nocolor}"
}

while (( "$#" )); do
    case "$1" in
        --title)
            arg_title_flag=1
            shift
            ;;
        --verbose)
            arg_verbose_flag=1
            shift
            ;;
        --done)
            arg_done_flag=1
            shift
            ;;
        --undone)
            arg_undone_flag=1
            shift
            ;;
        --case)
            arg_case_flag=1
            shift
            ;;
        --tag)
            if [ -n "$2" ] && [ ${2:0:1} != "-" ]; then
                arg_tag=$2
                arg_tags=$(my_split_comma $arg_tag)
                shift 2
            else
                echo "${lightred}Error: Argument for $1 is missing${nocolor}" >&2
                exit 1
            fi
            ;;
        -*|--*=)
            echo -e "${lightred}Error: Unsupported Option $1${nocolor}" >&2
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

setup_autocompletion() {
    echo "manually add _n to zsh fpath"
}

setup() {
    # setup global variables
    # project root directory
    root_dir=$HOME
    if [[ $NOTE_ROOT_DIR != "" ]]; then
        root_dir=$NOTE_ROOT_DIR
    fi
    remote_repo=""
    if [[ $NOTE_REMOTE_REPO != "" ]]; then
	    remote_repo=$NOTE_REMOTE_REPO
    fi
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
    setup_workspace
    # setup_autocompletion
}

calc_valid_no() {
    valid_no=$(find "${note_dir}" -name "*" -type f | grep -v "git" | grep -E '[0-9]+' | xargs -I % sh -c 'basename %' | sort -n | tail -n 1)
    echo $(($valid_no + 1))
}

check_tag() {
    no=$1
    tag_path="${note_dir}/${tag_sub_dir}/${no}"
    tags=""
    if [[ -e $tag_path ]]; then
        tags=$(cat $tag_path)
    fi
    if [[ $arg_tag == "" ]]; then
        echo 1
    else
        has_tag=false
        for tag in $arg_tags
        do
            has_tag=$(echo $tags | grep $tag)
            if [[ $has_tag ]]; then
                break
            fi
        done
        if [[ $has_tag ]]; then
            echo 1
        else
            echo 0
        fi
    fi
}

setup_workspace() {
    if [ ! -e $note_dir ]; then
        if [[ $remote_repo != "" ]]; then
            cd $root_dir && git clone $remote_repo ".note" && cd -
        else
            echo -e "${lightcyan}creating empty note storage directory...${nocolor}"
            mkdir -p "${note_dir}/${title_sub_dir}"
            mkdir -p "${note_dir}/${content_sub_dir}"
            mkdir -p "${note_dir}/${tag_sub_dir}"
            mkdir -p "${note_dir}/${image_sub_dir}"
            echo 1 > "${note_dir}/${info_filename}"
            echo -e "${lightgreen}done${nocolor}"
        fi
    fi
    max_no=$(cat "${note_dir}/${info_filename}")
    valid_no=$(calc_valid_no)
    if [[ $valid_no != $max_no ]]; then
        max_no=$valid_no
        echo "$max_no" > "${note_dir}/${info_filename}"
    fi
}

install() {
    echo "placeholder for installation"
}

inc_no() {
    max_no=$(( $max_no + 1 ))
    echo $max_no > "${note_dir}/${info_filename}"
}

new() {
    echo -e "${lightcyan}creating new note #${max_no} ...${nocolor}"
    title=$arg1
    title_path="${note_dir}/${title_sub_dir}/${max_no}"
    if [[ $title == "" ]]; then
        vi $title_path
    else
        echo $title > $title_path
    fi
    inc_no
    echo -e "${lightgreen}done${nocolor}"
}

view() {
    no=$1
    mode=$2
    # output correct no which could be used directly in the info file
    if [[ $no == "no" ]]; then
        valid_no=$(calc_valid_no)
        echo $valid_no
    else
        title=""
        title_path="${note_dir}/${title_sub_dir}/${no}"
        if [ ! -e $title_path ]; then
            echo -e "${lightred}#${no} does not exist${nocolor}"
            return
        fi
        title=$(cat "${title_path}" | awk '{$1=$1};1')
        title_caption="${lightcyan}#${no}:${nocolor}${lightgreen}${title}${nocolor}"
        title_caption=$(center "$title_caption" 3)
        echo -e "${title_caption}"
        tag=""
        tag_path="${note_dir}/${tag_sub_dir}/${no}"
        if [ -e $tag_path ]; then
            tag=$(cat $tag_path)
        fi
        if [[ $tag != "" ]]; then
            tag_caption="${lightblue}tag:${tag}${nocolor}"
            tag_caption=$(center "$tag_caption" 2)
            echo -e "${tag_caption}"
        fi
        content="empty"
        content_path="${note_dir}/${content_sub_dir}/${no}"
        if [ -e $content_path ]; then
            content=$(cat $content_path)
            if [[ $arg_verbose_flag == 0 && $mode != "verbose" ]]; then
                new_content="${content:0:$arg_shorten_length}"
                if [[ $content != $new_content ]]; then
                    new_content="${new_content}..."
                fi
                content=$new_content
            fi
            echo -e "${nocolor}${content}${nocolor}"
        else
            echo -e "${lightred}${content}${nocolor}"
        fi
        divider
    fi
}

list() {
    mode=$1
    if [[ $mode == "" ]]; then
        nos=$(ls "${note_dir}/${title_sub_dir}" | grep -E '[0-9]+' | sort -n)
        for no in $nos
        do
            if [[ $arg_done_flag == 1 ]]; then
                content_path="${note_dir}/${content_sub_dir}/${no}"
                if [ ! -e $content_path ]; then
                    continue
                fi
                content=$(cat $content_path)
                if [[ $content == "" ]]; then
                    continue
                fi
            fi
            if [[ $arg_undone_flag == 1 ]]; then
                content_path="${note_dir}/${content_sub_dir}/${no}"
                if [ -e $content_path ]; then
                    content=$(cat $content_path)
                    if [[ $content != "" ]]; then
                        continue
                    fi
                fi
            fi
            tag_valid=$(check_tag $no)
            if [[ $tag_valid == 1 ]]; then
                view $no
            fi
        done
    elif [[ $mode == "tag" || $mode == "tags" ]]; then
        echo -e "${lightred}tags:"
        find "${note_dir}/tag" -name "*" -type f | grep -E '[0-9]+' | xargs -I % sh -c "cat %" | tr '\n' ',' |  my_split_comma | sort | uniq | xargs -I % sh -c "echo \"${lightgreen}%${nocolor}\""
    elif [[ $mode == "alias" || $mode == "aliases" ]]; then
        echo -e "${lightred}available aliases:${nocolor}"
        cat "$HOME/.zshrc" | grep "alias n1=" | xargs -I % sh -c "echo \"${lightgreen}%${nocolor}\""
        cat "$HOME/.zshrc" | grep "alias n2=" | xargs -I % sh -c "echo \"${lightgreen}%${nocolor}\""
        cat "$HOME/.zshrc" | grep "alias n3=" | xargs -I % sh -c "echo \"${lightgreen}%${nocolor}\""
        cat "$HOME/.zshrc" | grep "alias n4=" | xargs -I % sh -c "echo \"${lightgreen}%${nocolor}\""
        cat "$HOME/.zshrc" | grep "alias n5=" | xargs -I % sh -c "echo \"${lightgreen}%${nocolor}\""
        cat "$HOME/.zshrc" | grep "alias n6=" | xargs -I % sh -c "echo \"${lightgreen}%${nocolor}\""
        cat "$HOME/.zshrc" | grep "alias n7=" | xargs -I % sh -c "echo \"${lightgreen}%${nocolor}\""
        cat "$HOME/.zshrc" | grep "alias n8=" | xargs -I % sh -c "echo \"${lightgreen}%${nocolor}\""
        cat "$HOME/.zshrc" | grep "alias n9=" | xargs -I % sh -c "echo \"${lightgreen}%${nocolor}\""
        echo -e "${darkgray}We suggest using aliases from n1 to n9.${nocolor}"
    fi
}

search() {
    query="$1"
    if [[ $arg_case_flag == 0 ]]; then
        nos=$(grep -i "${query}" -R "${note_dir}" | grep -E -o "[0-9]+" | sort | uniq)
    else
        nos=$(grep "${query}" -R "${note_dir}" | grep -E -o "[0-9]+" | sort | uniq)
    fi
    if [[ -n $nos ]]; then
        tmp_nos=()
        for no in "${nos[@]}"; do
            tag_valid=$(check_tag $no)
            if [[ $tag_valid == 1 ]]; then
                tmp_nos+=($no)
            fi
        done
        nos=$tmp_nos
    fi
    if [[ -n $nos ]]; then
        echo -e "${lightgreen}the following notes contain query: ${lightpurple}${query}${nocolor}"
        for no in "${nos[@]}"; do
            echo -e "${lightpurple}#${no}${nocolor}"
            if [[ $arg_verbose_flag == 1 ]]; then
                if [[ $arg_case_flag == 0 ]]; then
                    view $no | grep --color=always -i "$query"
                else
                    view $no | grep --color=always "$query"
                fi
            fi
        done
    else
        echo -e "${lightred}no notes contain query: ${lightpurple}${query}${nocolor}"
    fi
}

edit() {
    no=$1
    title_path="${note_dir}/${title_sub_dir}/${no}"
    if [ ! -e $title_path ]; then
        echo -e "${lightred}#${no} does not exist${nocolor}"
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
        echo -e "${lightred}#${no} does not exist${nocolor}"
        return
    fi
    tag_path="${note_dir}/${tag_sub_dir}/${no}"
    echo $tag > $tag_path
}

attach() {
    echo "placeholder for attach action"
}

remove() {
    no=$1
    echo -e "${lightred}removing note #${no}...${nocolor}"
    title_path="${note_dir}/${title_sub_dir}/${no}"
    if [ -e $title_path ]; then
        rm $title_path
    fi
    content_path="${note_dir}/${content_sub_dir}/${no}"
    if [ -e $content_path ]; then
        rm $content_path
    fi
    tag_path="${note_dir}/${tag_sub_dir}/${no}"
    if [ -e $tag_path ]; then
        rm $tag_path
    fi
    image_path="${note_dir}/${image_sub_dir}/${no}"
    if [ -e $image_path ]; then
        rm $image_path
    fi
    echo -e "${lightgreen}done${nocolor}"
}

my_clear() {
    echo -e "${lightred}cleaning old note storage directory...${nocolor}"
    rm -rf $note_dir
    echo -e "${lightgreen}done${nocolor}"
    setup_workspace
}

my_export() {
    echo -e "${lightred}export action is deprecated !! use sync instead${nocolor}"
    echo "the manual export command is 'zip -r notes.zip ${note_dir}'"
}

my_import() {
    notes_zip=$1
    echo -e "${lightred}import action is deprecated !! use sync instead${nocolor}"
    echo "the manual import command is 'unzip -o notes.zip -d ${notes_zip}'"
}

my_help() {
    echo -e "${lightred}actions:"
    echo -e "${lightgreen}n ls ${lightpurple}# list all the notes"
    echo -e "${lightgreen}n list ${lightpurple}# list all the notes"
    echo -e "${lightgreen}n list --tag shell ${lightpurple}# list all the notes in a specific tag"
    echo -e "${lightgreen}n list tag ${lightpurple}# list all the tags"
    echo -e "${lightgreen}n list alias ${lightpurple}# list alias related to note.sh"
    echo -e "${lightgreen}n view 1 ${lightpurple}# view note title, tag and content"
    echo -e "${lightgreen}n view no ${lightpurple}# view the smallest available sn"
    echo -e "${lightgreen}n tag 1 'test' ${lightpurple}# add or edit note tag"
    echo -e "${lightgreen}n edit 1 ${lightpurple}# edit note content"
    echo -e "${lightgreen}n edit 1 --title ${lightpurple}# edit note title"
    echo -e "${lightgreen}n add 'the best thing about shell' ${lightpurple}# create new note with a title"
    echo -e "${lightgreen}n new 'the best thing about shell' ${lightpurple}# create new note with a title"
    echo -e "${lightgreen}n create 'the best thing about shell' ${lightpurple}# create new note with a title"
    echo -e "${darkgray}For more help info, please visit Yanzhan's GitHub Repo: https://github.com/yangyanzhan/note.sh"
}

error() {
    msg="${lightred}$1${nocolor}"
    echo -e $msg
}

main() {
    setup
    if [[ $action == "install" ]]; then
        install
    elif [[ $action == "ls" ]]; then
        list $arg1
    elif [[ $action == "list" ]]; then
        list $arg1
    elif [[ $action == "search" ]]; then
        search $arg1
    elif [[ $action == "add" ]]; then
        new
    elif [[ $action == "new" ]]; then
        new
    elif [[ $action == "create" ]]; then
        new
    elif [[ $action == "view" ]]; then
        view $arg1 "verbose"
    elif [[ $action == "edit" ]]; then
        edit $arg1
    elif [[ $action == "tag" ]]; then
        tag $arg1 $arg2
    elif [[ $action == "attach" ]]; then
        attach
    elif [[ $action == "rm" ]]; then
        remove $arg1
    elif [[ $action == "remove" ]]; then
        remove $arg1
    elif [[ $action == "del" ]]; then
        remove $arg1
    elif [[ $action == "delete" ]]; then
        remove $arg1
    elif [[ $action == "clear" ]]; then
        my_clear
    elif [[ $action == "reset" ]]; then
        my_clear
    elif [[ $action == "export" ]]; then
        my_export
    elif [[ $action == "import" ]]; then
        my_import $arg1
    elif [[ $action == "help" ]]; then
        my_help
    else
        error "unrecognized action!"
        error "you can view available actions by using 'n help'."
        my_help
    fi
}

main
