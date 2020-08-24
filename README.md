# note.sh
A Text-Based Note Keeping Software Completely Written in Shell Script.

# create new note with a title

action:

```bash
n new "the best thing about shell"
```

output:

```bash
# 1 is the serial number (sn) for this note, you can use this sn to further edit this note. Every time you create a new note, note.sh will assign a unique sn for this note. Don't panic if you forget this sn, you can always get this sn by using the list action.
creating new note #1 ...
done
```

# edit note title

action:

```bash
# 1 is the serial number for this note, you can get the sn of a note after creating it.
n edit 1 --title
```

output:

```bash
# this action will invoke a VI editor so that you can edit the title for this note.
```

# edit note content

action:

```bash
n edit 1
```

output:

```bash
# this action will invoke a VI editor so that you can edit the content for this note.
```

# add tag to a note

action:

```bash
# you can use comma to seperate several tags
n tag 1 shell
```

# view note title, tag and content

action:

```bash
# the actual output is colored
n view 1
```

output:

```bash
                          #1:the best thing about shell
                                        tag:shell
it's ubiquitous and always available.
================================================================================
```

# list all the notes

action:

```bash
n list
# or you can use a shorter form
n ls
```

# list all the tags

action:

```bash
n ls tag
```

# list all the notes in a specific tag

action:

```bash
n ls --tag shell
```

# make alias to list action

action:

```bash
# Sometimes, you may want to make a alias to a list action so that you can view your notes more quickly. For this purpose, note.sh suggests using n1-n9 alias to represent note.sh shortcut. For example, if you want to quickly list all the notes in the shell tag, then you can add the following alias declaration to your ~/.bashrc or ~/.zshrc .
alias n1="n ls --tag shell"
```

# list alias related to note.sh

action:

```bash
# this command will output all the aliases from n1-n9
n ls alias
```

output:

```bash
alias n1="n ls --tag shell"
```

# clear (delete) all the notes

action:

```bash
# Be careful, this will delete all your notes.
n clear
```

======

**Hi, I'm Yanzhan !. I'm interested in all kinds of algorithmic problems. Also, I'm fascinated with the C++, Raku language and shell scripting. If you want to learn more about programming problems, C++, Raku and shell scripting, please visit my [Youtube Channel :video_camera:](https://www.youtube.com/channel/UCDkz-__gl3frqLexukpG0DA?view_as=subscriber), [Twitter Account :iphone:](https://twitter.com/YangYanzhan) or [GitHub Repo :memo:](https://github.com/yangyanzhan/code-camp).**
