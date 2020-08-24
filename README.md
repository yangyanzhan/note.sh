# note.sh
A Text-Based Note Keeping Software Completely Written in Shell Script.

# create new note with a title

action:

```bash
n new "the best thing about shell"
```

output:

```bash
creating new note #1 ...
done
```

# edit note title

action:

```bash
# 1 is the serial number for this note, you can get the sn of a note after creating it.
n edit 1 --title
```
