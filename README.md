# `set-me-up`

`set-me-up` aims to simplify the dull setup and maintenance of Mac OS development environments.
It does so by automating the process through a collection of dotfiles and shell scripts [bundled into modules](#available-modules).

Instead of enforcing a certain setup it tries to act as a solid template that is highly customizable to your needs.

## Table of Contents

- [🔧 Usage](#usage)
  - [💎 Use the blueprint](#use-the-blueprint)
  - [💰 Obtaining `set-me-up`](#obtaining-set-me-up)
  - [🏃 Running `set-me-up`](#running-set-me-up)
  - [🚚 Customize `set-me-up`](#customize-set-me-up)
    - [🎣 Using hooks](#using-hooks)
    - [✏️ Using `rcm`](#using-rcm)
      - [✨ Creating a custom tag](#creating-a-custom-tag)
  - [Wait! I am confused 😕](#wait-i-am-confused-)
- [A Closer Look 🤓](#a-closer-look)
  - [📦 Available modules](#available-modules)
  - [🚀 Other components](#other-components)
  - [🌐 Local Settings](#local-settings)
    - [🐠 `~/.fish.local`](#fishlocal)
    - [🐚 `~/.bash.local`](#bashlocal)
    - [🔁 `~/.gitconfig.local`](#gitconfiglocal)
- [🙇🏻 Credits](#credits)
- [🔃 Contributions](#contributions)
- [📄 License](#license)

## Usage

No matter how you obtain `smu`, as a sane developer you should take a look at the provided modules and dotfiles to verify that no shenanigans are happening.

### Use the blueprint

The recommended way to obtain `set-me-up` is by forking the [blueprint setup](https://github.com/nicholasadamou/set-me-up-blueprint), which is its own lean repo that comes pre-configured with a [tag](#using-rcm) and module.

You might wonder why not work directly with this repo? Having a remote and external repo for your dotfiles and `set-me-up` customizations has a few advantages:

- It is loosely coupled, making your life way easier. The only connection between your repo and `set-me-up` is through the installer.
- You can easily walk away from using `set-me-up` but can keep your precious dotfiles and shell scripts.
- It is easier to make your setup private because there are no direct ties to the blueprint or `set-me-up` repo.
- Your commit history and file list will stay clean.
- The referenced `set-me-up` version is fixated in the installer, ensuring that your setup will work even when the master advances. Advancing to the next version is easy by bumping the version in the installer.
- Its fancy, at least I think so 😉.

### Obtaining `set-me-up`

Either use your blueprint or the default installer to obtain `set-me-up` . This will put all files into `~/set-me-up` , the default `smu` home directory. In case you decided against using your own blueprint, you can run the following command in your console.

(⚠️ **DO NOT** run the `install` snippet if you don't fully
understand [what it does](.dotfiles/tag-smu/modules/install.sh). Seriously, **DON'T**!)

```bash
bash <(curl --progress-bar -L https://raw.githubusercontent.com/nicholasadamou/set-me-up/master/.dotfiles/tag-smu/modules/install.sh) --git
```

⚠️ Please note that the installer has **three** different arguments:

1. **`--curl`** - When this is passed, it will obtain the `smu` blueprint via `curl`.

2. **`--git`** - When this is passed, it will obtain the `smu` blueprint via `git`.

3. **`--detect`** - When this is passed, it will _detect_ if the `smu` blueprint was either obtained using `git` or `curl`. If it wasn't obtained using `git` it will use `curl` or visa-versa.

You can change the `smu` home directory by setting an environment variable called `SMU_HOME_DIR`. Please keep the variable declared or else the `smu` scripts are unable to pickup the sources.

### Running `set-me-up`

[![xkcd: Automation](http://imgs.xkcd.com/comics/automation.png)](http://xkcd.com/1319/)

1.  Use the `smu` script (which you will find inside the `smu` home directory) to run the base module. Check out the [base module documentation](#base) for more insights.

        smu -p -m base

    ⚠️ Please note that after running the base module, moving the source folder is not recommended due to the usage of symlinks.

2.  Afterwards, provision your machine with [further modules](#available-modules) via the `smu` script. Repeat the `-m` switch to specify more then one module.

        smu -p -m essentials -m terminal -m php

    As a general rule of thumb, only pick the modules you need, running all modules can take quite some time.
    Fear not, all modules can be installed when you need it.

### Customize `set-me-up`

#### Using hooks

To customize the setup to your needs `set-me-up` provides two hook points: Before and after sourcing the module script.

Before hooks enable you to perform special preparations or apply definitions that can influence the module. All `smu` base variables are defined to check if an existing declaration already exists, giving you the possibility to come up with your own values.

Polishing module setups or using module functionality can be done with after hooks. A bit of inspiration: By calling git commands in an after hook file you could replace the git username and email placeholders or install further extensions.

To use hooks provide a `before.sh` or `after.sh` inside the module directory. Use `rcm` tags to provide the hook files.

#### Using `rcm`

Through the power of [rcm tags](http://thoughtbot.github.io/rcm/rcup.1.html) `set-me-up` can favor your version of a file when you provide one. This mitigates the need to tinker directly with `set-me-up` source files.

[Create your own `rcm` tag](#creating-a-custom-tag) and then duplicate the directory structure and files you would like to adapt. `rcm` will combine all files from the given tags in the order you define. For example, when you would like to modify the `brewfile` of the essentials module, the path should look like this: `.dotfiles/tag-my/modules/essentials/brewfile`.

Use the `smu --lsrc` command to show how `rcm` would manage your dotfiles and to verify your setup.

- You can add new dotfiles and modules to your tag. `rcm` symlinks all files if finds.
- File contents are not merged between tags, your file simply has a higher precedence and will be used instead.

##### Creating a custom tag

1.  Create a new `rcm` tag, by creating a new folder prefixed `tag-` inside the [`.dotfiles`](.dotfiles) directory: `.dotfiles/tag-my`
2.  Add your tag to the [`.rcrc`](.dotfiles/rcrc) configuration file in front of the currently defined tags. Resulting in `TAGS="my smu"`

### Wait! I am confused 😕

[Go to the blueprint repo](https://github.com/nicholasadamou/set-me-up-blueprint#how-to-use). Fork it. Apply your changes using the techniques from above. Use the installer inside your forked repo to obtain everything. Provision your machine through the `smu` script.

## A closer look 🤓

### Available modules

#### [base](.dotfiles/base)

The base module is the only module that is required to run at least once on your system to ensure the minimum required constraints for `set-me-up` to work.

It will install `brew` and then `rcm`. Afterwards `rcup` will be executed to `symlink` the dotfiles from the `.dotfiles/tag-smu` folder into your home directory.

This is the only module that is not over-writable via `rcm` tag management because it is always sourced from the `smu` installation directory.

You can use `smu --lsrc` command to show which files will be symlink'ed to your home directory.

#### [editor](.dotfiles/tag-smu/modules/editor)

The editor module comes with [neovim](https://neovim.io/) and [vim](https://www.vim.org/), although `neovim` is considered to be used over `vim`.

For tasks you don't want to solve in `vi` you can use [Intellij IDEA](https://www.jetbrains.com/idea/), [PyCharm](), [WebStorm](), [Android Studio](), or [Visual Studio Code](https://code.visualstudio.com/). The Visual Studio Code configuration comes with a few [useful plugins](.dotfiles/tag-smu/modules/editor/vscode).

[Macdown](https://macdown.uranusjr.com/) for Markdown editing, [p4merge](https://www.perforce.com/products/helix-core-apps/merge-diff-tool-p4merge) for merging/diffing and [diff-so-fancy](https://github.com/so-fancy/diff-so-fancy) as default git difftool are also part of the editor module.

Apart from theme and fonts, all editors come pre-configured (e.g. [VSCode](.dotfiles/tag-smu/modules/editor/vscode)). To synchronize your Intellij configuration I recommend using the official [Settings Sync plugin](https://www.jetbrains.com/help/idea/sharing-your-ide-settings.html#IDE_settings_sync)

#### [essentials](.dotfiles/tag-smu/modules/essentials)

Installs a multitude of `brew` packages, casks and Mac App Store applications. Check the [brewfile](.dotfiles/tag-smu/modules/essentials/brewfile) to get an overview.

#### [go](.dotfiles/tag-smu/modules/go)

Installs [goenv](https://github.com/syndbg/goenv) for version management and [dep](https://github.com/golang/dep) for package management. `go` is installed and defined as the global version via `goenv`.

When the terminal module is used, the `go` installation will work-out-of-the-box because the required `goenv` code is already in place.

#### [java](.dotfiles/tag-smu/modules/java)

Installs [sdkman](http://sdkman.io/) to manage all java related packages. `java8`and `java10` are installed via `sdkman`. **java8** will be defined as the global version. Android Studio is installed via `brew` cask.

#### [preferences](.dotfiles/tag-smu/modules/perferences)

Sets a bunch of Mac OS settings. The file is based on [`.macos`](https://github.com/mathiasbynens/dotfiles/blob/master/.macos).

⚠️ **Note**: _The `.macos` script **has** been heavily modified from the version provided by [Mathias Bynens](https://github.com/mathiasbynens)._
**It is highly recommended to work with a copy that is adapted to your needs!**

#### [macosupdate](.dotfiles/tag-smu/modules/macosupdate)

Runs the Mac OS updater via the command-line.

Should your system require a system restart due to an `macosupdate` caused update, re-run the `smu` script after rebooting. The update module should be satisfied by the previous run and result in no action.

#### [php](.dotfiles/tag-smu/modules/php)

Installs `PHP5`, `PHP7` and [composer](https://getcomposer.org/) for package management via `brew`. `PHP7` will be defined as the global version.

#### [python](.dotfiles/tag-smu/modules/python)

Installs [pyenv](https://github.com/pyenv/pyenv) for version management and [pipenv](https://github.com/pypa/pipenv) for package management. `python2` and `python3` are installed using `pipenv`. `python3` will be defined as the global version.

When the terminal module is used, the `python` installation will work-out-of-the-box because the required `pyenv` code is already in place.

#### [ruby](.dotfiles/tag-smu/modules/ruby)

Installs [rbenv](https://github.com/rbenv/rbenv) for version management and [bundler](http://bundler.io/) for package management. `ruby` is installed and defined as the global version via `rbenv`.

When the terminal module is used, the `ruby` installation will work out-of-the-box because the required `rbenv` code is already in place.

#### [Rust](.dotfiles/tag-smu/modules/rust)

I primarily install the Rust toolchain because I like to use the `cargo` package manager. I then can gain access to an easy install of [`topgrade`](https://github.com/r-darwish/topgrade) which simply _upgrades all the things_ on your Linux or Mac OS system.

#### [terminal](.dotfiles/tag-smu/modules/terminal)

Configures `fish` with sane `fish` options and provides you with a list of useful plugins managed via [Fisherman](https://fisherman.github.io) and [Oh-My-Fish](https://github.com/oh-my-fish/oh-my-fish).

Some of the installed plugins are:

- fzf
- fnm
- z
- fzy
- bass
- ... and more.

**⚠️ Note**: _Take a look at the [terminal file](.dotfiles/tag-smu/modules/terminal/terminal.sh) and [fishfile](.dotfiles/tag-smu/config/fish/fishfile) for a full overview._

#### [web](.dotfiles/tag-smu/modules/web)

Installs [n](https://github.com/tj/n) for version management, `npm` comes with node for package management. The latest `node` and `npm` versions are installed using `n`.

### Other components

#### [The smu script](smu)

The `smu` script is wrapped with auto-generated [argbash.io](https://argbash.io/) code. It aims to make the use of `set-me-up` as pleasant as possible.
It runs the given modules by sourcing the appropriate scripts and ensuring a few constraints: a) always run the base module and b) prioritize the Mac OS updater script over all other modules.

### How does it work?

> Hamid: What's that?

> Rambo: It's blue light.

> Hamid: What does it do?

> Rambo: It turns blue.

**TL;DR;** It symlinks all dotfiles and stupidly runs shell scripts.

`smu` symlinks all dotfiles from the `.dotfiles` folder, which includes the modules, to your home directory. With the power of [rcm](https://github.com/thoughtbot/rcm), `.dotfiles/tag-smu/gitconfig` becomes `~/.gitconfig`. Using bash scripting the installation of `brew` is ensured. All this is covered by the base module and provides an opinionated base setup on which `smu` operates.

Depending on the module, further applications will be installed by "automating" their installation through other bash scripts.
In most cases `set-me-up` delegates the legwork to tools that are meant to be used for the job (e.g. installing `zplugin` for zsh plugin management).

Nothing describes the actual functionality better than the code. It is recommended to check the appropriate module script to gain insights as to what it exactly does.

`set-me-up` is a plain collection of bash scripts and tools that you probably already worked with, therefore understanding what is happening will be easy 😄.

### Local Settings

The `dotfiles` can be easily extended to suit additional local
requirements by using the following files:

#### `~/.bash.local`

The `~/.bash.local` file it will be automatically sourced after
all the other [`bash` related files](.dotfiles/tag-smu), thus, allowing
its content to add to or overwrite the existing aliases, settings,
PATH, etc.

Here is a very simple example of a `~/.bash.local` file:

```bash
# Set local aliases.

alias starwars="telnet towel.blinkenlights.nl"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Set PATH additions.

export $PATH="$HOME/dotfiles/src/symlinks/.local/bin:$PATH"
```

#### `~/.fish.local`

The `~/.fish.local` file it will be automatically sourced after
all the other [`fish` related files](.dotfiles/tag-smu/config/fish), thus, allowing
its content to add to or overwrite the existing aliases, settings,
PATH, etc.

Here is a very simple example of a `~/.fish.local` file:

```fish
# Set local aliases.

alias starwars "telnet towel.blinkenlights.nl"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Set PATH additions.

set -gx PATH $PATH "$HOME/dotfiles/src/symlinks/.local/bin"
```

#### `~/.gitconfig.local`

The `~/.gitconfig.local` file it will be automatically included
after the configurations from `~/.gitconfig`, thus, allowing its
content to overwrite or add to the existing `git` configurations.

**Note:** Use `~/.gitconfig.local` to store sensitive information
such as the `git` user credentials, e.g.:

```bash
[commit]

    # Sign commits using GPG.
    # https://help.github.com/articles/signing-commits-using-gpg/

    gpgsign = true


[user]

    name = Nicholas Adamou
    email = nicholasadamou@example.com
    signingkey = XXXXXXXX
```

## Credits

- [donnemartin/dev-setup](https://github.com/donnemartin/dev-setup)
- [mathiasbynens](https://github.com/mathiasbynens/dotfiles) for his popular [macOS script](https://github.com/mathiasbynens/dotfiles/blob/master/.macos).
- [argbash.io](https://argbash.io/) enabling library free and sane argument parsing.
- [brew](https://brew.sh/) and [brew bundle](https://github.com/Homebrew/homebrew-bundle) for the awesome package management.
- [thoughtbot rcm](https://github.com/thoughtbot/rcm) for easy dotfile management.
- All of the authors of the installed applications via `set-me-up` , I am in no way connected to any of them.

Should I miss your name on the credits list please let me know :heart:

## Liability

The creator of this repo is _not responsible_ if your machine ends up in a state you are not happy with.

## Contributions

Yes please! This is a GitHub repo. I encourage anyone to contribute. 😃

## License

The code is available under the [MIT license](LICENSE.txt).
