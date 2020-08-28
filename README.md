# note.sh
A Text-Based Note Keeping Software Completely Written in Shell Script.

# installation

* Clone this repo to any directory as you like and then make an alias to note.sh as command n.
* For example, I've cloned this repo to my home directory, so after cloning, I should make an alias like this:
```bash
alias n="${HOME}/note.sh/note.sh"
```
* And then, append this alias declaration to the end of your ~/.bashrc or ~/.zshrc file.
* Finally, to make your alias working, don't forget to restart your shell or source your rc file.
* Now you can enjoy note.sh as the command n.

# create new note with a title

action:

```bash
# add, new and create are equivalent
n add "the best thing about shell"
n new "the best thing about shell"
n create "the best thing about shell"
```

output:

```bash
# 1 is the serial number (sn) for this note, you can use this sn to further edit this note.
# Every time you create a new note, note.sh will assign a unique sn for this note.
# Don't panic if you forget this sn, you can always get this sn by using the list action.
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

# add or modify tags for a note

action:

```bash
# you can use comma to seperate several tags
# this will add tag "shell" to the #1 note
# it will replace the old tags if the #1 note has been tagged before
n tag 1 shell
```

# view note title, tag and content

action:

```bash
# the actual output is colored
# unlike "ls", the view action will show the full content of the note
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
# note that ls and list are equivalent
n ls
# and ls or list will only show the first 100 characters of the note
# to view the full note, you can use --verbose option
n ls --verbose
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

# list all the notes with contents (i.e. list "done" notes)

action:

```bash
n ls --done
```

# list all the notes without contents (i.e. list "undone" notes)

action:

```bash
n ls --undone
```

# make alias to list action

action:

```bash
# Sometimes, you may want to make a alias to a list action so that you can view your notes more quickly.
# For this purpose, note.sh suggests using n1-n9 alias to represent note.sh shortcut.
# For example, if you want to quickly list all the notes in the shell tag, then you can add the following alias declaration to your ~/.bashrc or ~/.zshrc .
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

# delete a note

action:

```bash
n remove 1
```

output:

```bash
removing note #1...
done
```

# clear (delete) all the notes

action:

```bash
# Be careful, this will delete all your notes.
n clear
```

# help

action:

```bash
n help
```

# RoadMap

- [x] Basic Note Creation
- [x] Basic Tag Management
- [x] Basic Listing
- [x] Basic Deletion Functionality
- [ ] Tree Structure within Notes
- [ ] Export & Import
- [ ] Auto Sync (Use Github Repo as Note Remote Storage)
- [ ] Note Representation Template & Customization
- [ ] Image Attachment
- [ ] Audio Attachment
- [ ] Video Attachment
- [ ] Auto VI Plugin Installation to Enhance Editor Experience
- [ ] MarkDown Format for Note Content (Including MarkDown Rendering)
- [ ] NCurses Rendering

---

**Hi, I'm Yanzhan, the creator of note.sh. I'm interested in all kinds of algorithmic problems. Also, I'm fascinated with the C++, Raku language and shell scripting. If you want to learn more about programming problems, C++, Raku and shell scripting, please visit my [Youtube Channel :video_camera:](https://www.youtube.com/channel/UCDkz-__gl3frqLexukpG0DA?view_as=subscriber), [Twitter Account :iphone:](https://twitter.com/YangYanzhan) or [GitHub Repo :memo:](https://github.com/yangyanzhan/code-camp).**
