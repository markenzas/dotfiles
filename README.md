# My dotfiles

This directory contains the dotfiles for the systems that I use

## Requirements

### git

Debian
```
apt install git
```

```
apt install stow
```

## Installation

First, check out the dotfiles repo in your `$HOME` directory using git

```
$ git clone git@github.com:Maarkas/dotfiles.git
$ cd dotfiles
```

then use GNU Stow to create the symlinks

```
$ stow .
```
