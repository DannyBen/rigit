Rigit
==================================================

[![Gem](https://img.shields.io/gem/v/rigit.svg?style=flat-square)](https://rubygems.org/gems/rigit)
[![Build](https://img.shields.io/travis/DannyBen/rigit.svg?style=flat-square)](https://travis-ci.org/DannyBen/rigit)
[![Maintainability](https://img.shields.io/codeclimate/maintainability/DannyBen/rigit.svg?style=flat-square)](https://codeclimate.com/github/DannyBen/rigit)
[![Issues](https://img.shields.io/codeclimate/issues/github/DannyBen/rigit.svg?style=flat-square)](https://codeclimate.com/github/DannyBen/rigit)

---

Build project templates easily, and without the need to write code.

![Rigit](rigit-header.png)

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
    * [Dynamic Tokens](#dynamic-tokens)
    * [Config File](#config-file)
        * [Example Config](#example-config)
        * [Showing messages before/after scaffolding](#showing-messages-beforeafter-scaffolding)
        * [Executing commands before/after scaffolding](#executing-commands-beforeafter-scaffolding)
        * [Scaffolding parameters](#scaffolding-parameters)


Installation
--------------------------------------------------

    $ gem install rigit



Key Features
--------------------------------------------------

Rigit was designed to allow the rapid building of reusable project templates.
In Rigit, we call these templates "rigs".

- No coding required.
- Conventions-based [folder structure](#directory-structure).
- A minimalistic [configuration file](#config-file) to allow specifying 
  needed parameters.
- [String replacement](#dynamic-tokens) in file names and file contents.
- [Install rigs](#installing-rigs) from any remote git repository.



Usage
--------------------------------------------------

```
$ rig
Usage:
  rig new NAME
  rig build RIG [--force] [PARAMS...]
  rig install RIG REPO
  rig uninstall RIG
  rig update RIG
  rig info RIG
  rig list [SUBFOLDER]
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

    $ rig build example name=myapp spec=yes console=irb license=MIT

To learn about the parameters of a rig:

    $ rig info example



Creating Rigs
--------------------------------------------------

> **Tip**: Take a look at the [example rig][example-rig] while reading 
> this section.

Rigit's main design goal was to allow rapid and easy creation of new 
templates. There is no coding involved in creating a rig, and instead we 
are using folders with specific names, to allow for a sort of "additive" 
project building.

The steps in creating a rig are:

1. Start in a new, empty folder.
2. Create a folder named `base`. Put all the files and folders of your 
   project inside.
3. Rename files and folders, and files as needed to include dynamic tokens.
4. If you want to add some of the files only in specific cases (for example
   only include a license file if the user wants to), you move the files to
   a folder with s special `parameter=value` folder.
5. Create a config file to specify the needed parameters.

In order to quickly get started with creating a new rig, you can also run 
`rig new your_new_rig_name`. This will create the initial folder structure
and an initial `config.yml` for you to build on.


### Directory Structure

There are two types of folders in a rig template.

1. Base folder (`base`) - files and folders here will be copied always
2. Conditional folders (`parameter=value`) - contents in these folders will
   only be copied if the user answerd `value` to the question `parameter`.

A typical rig folder looks like this:

    myrig
    |-- base
    |   |-- files
    |   `-- and-folders
    |-- param=y
    |   |-- files
    |   `-- and-folders
    |-- param=n
    `-- config.yml


### Dynamic Tokens

You can use variable replacements (tokens) in file names, folder names and in
file contents.

Each token that you use, must also be declared in the config file.

Tokens are specified using this syntax: 

    %{name}


### Config File

Place a `config.yml` file at the root of your rig template. A config file
is optional for rigs that do not have any variables.


#### Example Config

The below config file example contains all the available options:

```yaml
# Optional messages to show before/after scaffolding
intro: A sample generator
outro: Something to say after scaffolding is done

# Optional commands to execute before/after scaffolding
before:
  "Create empty .env file": "touch .env"

after:
  "Install Dependencies": "bundle install"
  "Initialize git repo": "git init"

# Parameters to collect on scaffolding
params:
  name:
    prompt: "Name your project:"
    type: text
    default: project

  spec: 
    prompt: Include RSpec files?
    type: yesno
    default: yes

  console:
    prompt: "Select console:"
    type: select
    list: [irb, pry]
```

#### Showing messages before/after scaffolding

Use the `intro` and `outro` options to show short message that will be
displayed before or after building. Both are optional.

The message is displayed using the [Colsole][colsole] gem, so
you can use [color markers][colsole-colors]

Example:

```yaml
intro: Welcome to my blue !txtblu!rig!txtrst!`
outro: Installation completed successfully
```

#### Executing commands before/after scaffolding

Use the `before` and `after` options to specify one or more commands to
run before or after building. Each command has a label and an action, and 
both support parameter interpolation (`%{param_name}`), so you can use 
the input the user provided in your commands.

Example:

```
before:
  "Create empty .env file": "touch .env"

after:
  "Install Dependencies": "bundle install"
  "Initialize git repo": "git init"
  "Run setup script": "myscript %{name}"
```

#### Scaffolding parameters

The `params` option contains a list of parameters required by the rig.

Each definition in the `params` key should start with the name of the 
variable (`name`, `spec` and `console` in the above example), and contain 
the below specifications:

| Key       | Purpose                                                  |
|-----------|----------------------------------------------------------|
| `prompt`  | The text to display when asking for user input           |
| `type`    | The variable tyoe. Can be `yesno`, `text` or `select`    |
| `default` | The default value. When using `yesno`, use `yes` or `no` |
| `list`    | An array of allowed options (only used in `select` type) |

Example:

```yaml
params:
  name:
    prompt: "Name your project:"
    type: text
    default: project
```

---

[example-rig]: https://github.com/DannyBen/example-rig
[colsole-colors]: https://github.com/dannyben/colsole#color-codes
[colsole]: https://github.com/dannyben/colsole

