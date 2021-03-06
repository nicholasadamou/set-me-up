# `set-me-up`

![preview](preview.png)

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
- [🙇🏻 Credits](#credits)
- [👨🏼‍⚖️ Liability](#liability)
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
understand [what it does](.dotfiles/modules/install.sh). Seriously, **DON'T**!)

```bash
bash <(curl -s -L https://raw.githubusercontent.com/nicholasadamou/set-me-up/master/.dotfiles/modules/install.sh)
```

You can change the `smu` home directory by setting an environment variable called `SMU_HOME_DIR`. Please keep the variable declared or else the `smu` scripts are unable to pickup the sources.

### Running `set-me-up`

[![xkcd: Automation](http://imgs.xkcd.com/comics/automation.png)](http://xkcd.com/1319/)

1.  Use the `smu` script (which you will find inside the `smu` home directory) to run the base module. Check out the [base module documentation](#base) for more insights.

        smu -p -m base

    ⚠️ Please note that after running the base module, moving the source folder is not recommended due to the usage of symlinks.

2.  Afterwards, provision your machine with [further modules](#available-modules) via the `smu` script. Repeat the `-m` switch to specify more then one module.

        smu -p -m app_store -m casks -m php --no-base

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

[Create your own `rcm` tag](#creating-a-custom-tag) and then duplicate the directory structure and files you would like to modify. `rcm` will combine all files from the given tags in the order you define. For example, when you would like to modify the `brewfile` of the app_store module, the path should look like this: `.dotfiles/tag-my/modules/app_store/brewfile`.

Use the `smu --lsrc` command to show how `rcm` would manage your dotfiles and to verify your setup.

- You can add new dotfiles and modules to your tag. `rcm` symlinks all files if finds.
- File contents are not merged between tags, your file simply has a higher precedence and will be used instead.

Use `smu --rcup` command to symlink the dotfiles using [`rcup`](http://thoughtbot.github.io/rcm/rcup.1.html) contained within [`.dotfiles`](.dotfiles) using [`.rcrc`](.dotfiles/rcrc).

Additionally, you can use `smu --rcdn` command to remove files listed within [`.rcrc`](.dotfiles/rcrc) that were symlinked via `rcup` from [`.dotfiles`](.dotfiles).

##### Creating a custom tag

1.  Create a new `rcm` tag, by creating a new folder prefixed `tag-` inside the [`.dotfiles`](.dotfiles) directory: `.dotfiles/tag-my`
2.  Add your tag to the [`.rcrc`](.dotfiles/rcrc) configuration file in front of the currently defined tags. Resulting in `TAGS="my smu"`

### Wait! I am confused 😕

[Go to the blueprint repo](https://github.com/nicholasadamou/set-me-up-blueprint#how-to-use). Fork it. Apply your changes using the techniques from above. Use the installer inside your forked repo to obtain everything. Provision your machine through the `smu` script.

For more on using the `smu` script, simply run `smu --help`.

## A closer look 🤓

### Available modules

#### [base](.dotfiles/base)

The base module is the only module that is required to run at least once on your system to ensure the minimum required constraints for `set-me-up` to work.

It will install `brew` and `rcm`. Afterwords `rcup` will be executed to `symlink` the dotfiles from the `.dotfiles/tag-smu` folder into your home directory.

It will also create the [local settings](#local-settings) files such as `~/.bash.local` or `~/.fish.local` if they haven't already been created. These files are used vastly throughout the `smu` provisioning process in order to install and configure other tools, such as [basher](#basher) or [pyenv](#python) for python version management.

This is the only module that is not over-writable via `rcm` tag management because it is always sourced from the `smu` installation directory.

You can use `smu --lsrc` command to show which files will be symlink'ed to your home directory.

The last task that the base module executes is upgrading the outdated `bash` version using `brew`.

This module also configures an upgraded version of `bash`, version 5.

Configures `fish` with sane `fish` options and provides you with a list of useful plugins managed via [Fisherman](https://fisherman.github.io) and [Oh-My-Fish](https://github.com/oh-my-fish/oh-my-fish).

Some of the installed plugins are:

- fzf
- fnm
- z
- fzy
- bass
- ... and more.

**⚠️ Note**: _Take a look at the [fishfile](.dotfiles/tag-smu/config/fish/fishfile) for a full overview._

For more on what the base module does, please consult [`base.sh`](.dotfiles/base/base.sh).

#### [create_boot_disk](.dotfiles/modules/create_boot_disk)

This module will allow you to create a MacOS Catalina boot disk for installing MacOS Catalina.

For more on what the create_boot_disk module does, please consult [`create_boot_disk.sh`](.dotfiles/modules/create_boot_disk/create_boot_disk.sh).

#### [macosupdate](.dotfiles/modules/macosupdate)

Runs the Mac OS updater via the command-line.

Should your system require a system restart due to an `macosupdate` caused update, re-run the `smu` script after rebooting. The update module should be satisfied by the previous run and result in no action.

#### [brew](.dotfiles/modules/brew)

This module will install 'brew', the package manager for Mac OS.

For more on what the brew module does, please consult [`brew.sh`](.dotfiles/modules/brew/brew.sh).

#### [app_store](.dotfiles/modules/app_store)

The app store module installs all Mac OS App Store applications via `mas`.

For more on what the app store module does, please consult the [brewfile](.dotfiles/modules/app_store/brewfile) to get an overview.

#### [casks](.dotfiles/modules/casks)

Installs a multitude of `brew` casks. Check the [brewfile](.dotfiles/modules/casks/brewfile) to get an overview.

#### [formulae](.dotfiles/modules/formulae)

Installs a multitude of `brew` formulae. Check the [brewfile](.dotfiles/modules/formulae/brewfile) to get an overview.

#### [preferences](.dotfiles/modules/preferences)

Sets a bunch of Mac OS settings. The file is based on [`.macos`](https://github.com/mathiasbynens/dotfiles/blob/master/.macos).

⚠️ **Note**: _The `.macos` script **has** been heavily modified from the version provided by [Mathias Bynens](https://github.com/mathiasbynens)._
**It is highly recommended to work with a copy that is adapted to your needs!**

#### [go](.dotfiles/modules/go)

Installs [goenv](https://github.com/syndbg/goenv) for version management and [dep](https://github.com/golang/dep) for package management. `go` is installed and defined as the global version via `goenv`.

When the terminal module is used, the `go` installation will work-out-of-the-box because the required `goenv` code is already in place.

#### [java](.dotfiles/modules/java)

Installs [sdkman](http://sdkman.io/) to manage all java related packages. `java8`and `java10` are installed via `sdkman`. **java8** will be defined as the global version.

#### [php](.dotfiles/modules/php)

Installs `PHP5`, `PHP7` and [composer](https://getcomposer.org/) for package management via `brew`. `PHP7` will be defined as the global version.

#### [python](.dotfiles/modules/python)

Installs [pyenv](https://github.com/pyenv/pyenv) for version management and [pipenv](https://github.com/pypa/pipenv) for package management. `python2` and `python3` are installed using `pipenv`. `python3` will be defined as the global version.

When the terminal module is used, the `python` installation will work-out-of-the-box because the required `pyenv` code is already in place.

#### [ruby](.dotfiles/modules/ruby)

Installs [rbenv](https://github.com/rbenv/rbenv) for version management and [bundler](http://bundler.io/) for package management. `ruby` is installed and defined as the global version via `rbenv`.

When the terminal module is used, the `ruby` installation will work out-of-the-box because the required `rbenv` code is already in place.

#### [rust](.dotfiles/modules/rust)

I primarily install the Rust toolchain because I like to use the `cargo` package manager. I then can gain access to an easy install of [`topgrade`](https://github.com/r-darwish/topgrade) which simply _upgrades all the things_ on your Linux or Mac OS system.

#### [web](.dotfiles/modules/web)

Installs [n](https://github.com/tj/n) for version management, `npm` comes with node for package management. The latest `node` and `npm` versions are installed using `n`.

It also installs a set of globally installed `npm` packages. For a complete list of packages installed please see [`web.sh`](.dotfiles/modules/web/web.sh#120).

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

## Credits

- [omares/set-me-up](https://github.com/omares/set-me-up) for the initial platform that [nicholasadamou/set-me-up](https://github.com/nicholasadamou/set-me-up) was built on.
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
