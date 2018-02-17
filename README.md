Rigit
==================================================

[![Gem](https://img.shields.io/gem/v/rigit.svg?style=flat-square)](https://rubygems.org/gems/rigit)
[![Build](https://img.shields.io/travis/DannyBen/rigit.svg?style=flat-square)](https://travis-ci.org/DannyBen/rigit)
[![Maintainability](https://img.shields.io/codeclimate/maintainability/DannyBen/rigit.svg?style=flat-square)](https://codeclimate.com/github/DannyBen/rigit)
[![Issues](https://img.shields.io/codeclimate/issues/github/DannyBen/rigit.svg?style=flat-square)](https://codeclimate.com/github/DannyBen/rigit)

---

![Rigit](rigit-header.png)

Build project templates easily, and without the need to write code.

---

Table of Contents
--------------------------------------------------

* [Installation](#installation)
* [Key Features](#key-features)
* [Usage](#usage)
* [Quick Start](#quick-start)
* [Installing Rigs](#installing-rigs)
* [Using Rigs (Scaffolding)](#using-rigs-scaffolding)
    * [Non-Interactive Execution](#non-interactive-execution)
* [Creating Rigs](#creating-rigs)
    * [Directory Structure](#directory-structure)
    * [Config File](#config-file)


Installation
--------------------------------------------------

```
$ gem install rigit
```

Key Features
--------------------------------------------------

Rigit was designed to allow the rapid building of reusable project templates.
In Rigit, we call these templates "rigs".

- No coding required.
- Conventions-based folder structure.
- A minimalistic configuration file to allow specifying needed parameters.
- String replacement in file names and file contents.
- Install rigs from any remote git repository.

Usage
--------------------------------------------------

```
$ rig
Usage:
  rig build RIG [PARAMS...]
  rig install RIG REPO
  rig update RIG
  rig (-h|--help|--version)
```


Quick Start
--------------------------------------------------

After installing Rigit, you can follow these steps to quickly understand how
it works, and how you can create your own rigs.

First, create an empty folder:

    $ mkdir myapp
    $ cd muapp

Install your first rig. You can use this [example rig][example-rig].

    $ rig install example https://github.com/DannyBen/example-rig.git

Now that your rig is installed (in `~/.rigs`), you can use it.

    $ rig build example

Input all the answers, and you are done. Your project has been rigged.


Installing Rigs
--------------------------------------------------

Rigs are installed in `~/.rigs` by default. You can change the installation
directory by setting the `RIG_HOME` environment variable to your desired 
path.

To install a rig, simply use the `rig install` command, and supply a name 
(which will be the name of the rig in your local system) and a git URL (use 
the same url as you would use in "git clone").

    $ rig install example https://github.com/DannyBen/example-rig.git


Using Rigs (Scaffolding)
--------------------------------------------------

After you have one or more installed rigs, you can use them to create a new
project. Note that rigit works in the *current* directory, and will not 
create the project root directory for you.

    $ mkdir myapp
    $ cd myapp
    $ rig build example

Most rigs will have parameters, you will be prompted to input them as needed.

### Non-Interactive Execution

You can also provide some (or all) of the parameters in the command line, 
if you need to avoid interactivity.

    $ rig build example name=myapp spec=y console=irb license=MIT

To learn about the parameters of a rig:

    $ rig info example (TODO: NOT IMPLEMENTED)


Creating Rigs
--------------------------------------------------

### Directory Structure

Soon

### Config File

Soon


---

[example-rig]: https://github.com/DannyBen/example-rig