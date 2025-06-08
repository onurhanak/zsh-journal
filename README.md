# zsh-journal

A simple Zsh plugin that lets you attach notes to shell commands you have run. Handy for remembering what a oneliner was actually doing when you look back at it later.

## What it does

You run a command like this:

```bash
$ ffmpeg -i input.mov -vf scale=1280:-2 output.mp4
```

Then right after:

```bash
$ note "Resize video to 720p width, preserve aspect ratio"
```
Now that command and your note are saved. You can list everything you've saved with:

```bash
$ notes

[1] ffmpeg -i input.mov -vf scale=1280:-2 output.mp4
→ Resize video to 720p width, preserve aspect ratio
```

That’s it.

## Installation

### With Oh-my-zsh

Clone into Oh My Zsh's custom plugin directory:

```sh
git clone https://github.com/onurhanak/zsh-journal ~/.oh-my-zsh/custom/plugins/zsh-journal
```
Then add it to your plugins:

```bash
plugins=(git zsh-journal)
source ~/.zshrc
```

### With Antidote

Add the plugin to your .zsh_plugins.txt file:

```bash 
$ echo onurhanak/zsh-journal >> .zsh_plugins.txt
```

Rebuild and reload:

```bash
$ antidote bundle < ~/.zsh_plugins.txt > ~/.zsh_plugins.zsh
$ source ~/.zsh_plugins.zsh
```

### Manual

Clone the repo somewhere:

```bash
$ git clone https://github.com/onurhanak/zsh-journal ~/.zsh-journal
```

Source it in your .zshrc:

```bash
source ~/.zsh-journal/zsh-journal.plugin.zsh
```

Restart your terminal or run `source ~/.zshrc` and you're good to go.

## Usage

- `$ note "your description"`  
  Saves a note for the last command you ran.

- `$ notes`  
  Lists all saved command + note pairs.

If you try to note a command you have already saved before, it will ask if you want to overwrite the previous note.

## Where it stores data

By default, it saves everything to:

```bash
~/.zsh-journal.txt
```
You can change that by setting an environment variable in your `.zshrc`:

```bash
export ZSH_JOURNAL_FILE="/path/to/.my_custom_journal_file.txt"
```

## Gotchas

- You need to run `note` immediately after the command you want to save.

## Why did I make this?

Because there is no way I'll remember all the different `rsync`, `ffmpeg` etc. flags.


