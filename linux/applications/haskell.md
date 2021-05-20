# Setting up your Haskell development environment[¶](https://www.vacationlabs.com/haskell/environment-setup.html#setting-up-your-haskell-development-environment "Permalink to this headline")

## Pre-requisities[¶](https://www.vacationlabs.com/haskell/environment-setup.html#pre-requisities "Permalink to this headline")

Use Linux or Mac. Do not waste time with Haskell on Windows - you may be able to make some progress initially, but you **will** run into weird errors later while bulding certain packages, or while building binaries. **You have been warned.**

Make sure you have a **lot of RAM and an SSD.** Serious Haskell projects (not textbook problems) are memory-guzzlers during development & compilation. Plus, if you’re like me, you will have 50 browser tabs open, as well. So, it won’t be long before your system starts swapping, which is why it’s better to have an SSD along with a lot of RAM. For serious Haskell development, we recommend **at least 10 GB of RAM** and **at least 256 GB SSD.** For text-book practice, you can probably get away with 4GB of RAM and an HDD.

Attention

**Call for contribution**

* Screen-recording of installing Stack & Spacemacs + Intero along with the first GHCi session
* Screen-recording of installing Stack & VSCode + HIE along with the first GHCi session

## Installing Haskell[¶](https://www.vacationlabs.com/haskell/environment-setup.html#installing-haskell "Permalink to this headline")

There are currently **four** ways to install Haskell! Yes, I know that’s crazy. Here’s what they are:

* Via your OS’ native package manager, i.e. `apt-get`, or `homebrew`, or `yum`
* Via a [minimal installer](https://www.haskell.org/downloads#minimal) or the [Haskell Platform](https://www.haskell.org/downloads#platform)
* Via [Stack](https://haskell-lang.org/get-started) _(recommended)_
* Via Nix/NixOS

Important

Recommendation

Out of the four methods listed above, only Stack is recommended for maintaining your sanity. So, head over to [Stack’s Get Started](https://haskell-lang.org/get-started) page and follow **only the first step, titled “Download Haskell Stack”** for your OS. The other steps given on that page are covered in greater detail below.

## Quick primer on Stack[¶](https://www.vacationlabs.com/haskell/environment-setup.html#quick-primer-on-stack "Permalink to this headline")

`stack` solves the following problems:

* Having different versions of the Haskell compiler (i.e. `ghc`) available on your machine without messing things up, and using the right `ghc` version for your project.
* Taking care of which Haskell libraries are known to compile/build with which version of `ghc`.
* Taking care of the dependency graph of libraries, so that all the libraries that your project depends on, compile successfully without you having to manually specify the version of each library. Basically `stack` saves you from the _dependency hell_ problem.

In a sense stack is similar to the following tools from other ecosystems, which attempt to solve some, or all, of the same problems (but they may have solved them in a different manner):

* `rvm` and `bundler` from the Ruby world
* `virtualenv` from the Python world
* `gvm` from the Go world
* `nvm` or `yarn` from the NodeJS world

## Installing an editor[¶](https://www.vacationlabs.com/haskell/environment-setup.html#installing-an-editor "Permalink to this headline")

If you are used to tools like Eclipse/IntelliJ from the Java world, or Visual Studio from the Microsoft world, you are in for a rude shock when it comes to IDEs in Haskell. Firstly, there is no industrial-grade **\[I\]ntegrated** \[D\]evelopment \[E\]nvironment for Haskell - so you can stop looking for it. Secondly, as of Dec 2017, various Haskell editor _plugins_, don’t work as well as they should. But, don’t worry - all is not lost - you won’t have to resort to writing Haskell in `ed` or `nano`. There is stuff available - just lower your expectations.

Here are two options that are known to work well:

* [Spacemacs](http://spacemacs.org/) with [intero](https://commercialhaskell.github.io/intero/) \- If you are comfortable with the Emacs editor, this should be your preferred choice.
* [VS Code](https://code.visualstudio.com/) with [HIE: Haskell IDE Engine](https://github.com/haskell/haskell-ide-engine/#installation) \- If you are comfortable with editors like Sublime, Atom, or VSCode itself, this should be your preferred choice. **Please follow the instructions at** [Installing VSCode & HIE](https://www.vacationlabs.com/haskell/environment-setup.html#hie-installation)

### Installing VSCode & HIE[¶](https://www.vacationlabs.com/haskell/environment-setup.html#installing-vscode-hie "Permalink to this headline")

Note

If you choose to use VSCode + HIE here are the installation instructions. You may skip this sub-section if you plan on using any other editor. Please comment/annotate if these instructions do not work for you.

* Install the VSCode editor by downloading it from [here](https://code.visualstudio.com/)
    
* Install the `hie` binary (command-line tool) using the following steps (the last step `stack install` is going to take a lot of time - be patient).
    
    $ git clone https://github.com/haskell/haskell-ide-engine
    $ cd haskell-ide-engine
    $ stack install
    
* Ensure that the `hie` binary (command-line tool) has installed successfully by going through the following steps. **Ensure** that you see output similar to what is shown above after you run the `hie` command. You can exit it by pressing `Ctr+c`
    
    $ cd ~
    $ hie
    
    2017-12-14 10:44:42.963071 \[ThreadId 4\] \- Setting home directory:/Users/saurabhnanda
    2017-12-14 10:44:42.964856 \[ThreadId 4\] \- run entered for HIE Version 0.1.0.0, Git revision ab3cb3e62605625128769d8553646cc4f01db6d1 (1129 commits) x86_64
    2017-12-14 10:44:42.966338 \[ThreadId 4\] \- Current directory:/Users/saurabhnanda
    
* Open the VSCode editor and go the the “Extensions” tab, also known as the “plugin marketplace” =&gt; search for the `haskell language server` plugin (the correct plugin is the one authored by `Alan Zimmerman`) =\&gt; Click the `install` button.
    
    ![_images/hie-installation.png](https://www.vacationlabs.com/haskell/_images/hie-installation.png)
* Restart your editor.
    
* Note down the `resolver` that HIE is using (instructions given below):
    
    Warning
    
    **For HIE & VSCode users**
    
    Next, open the `haskell-ide-engine` directory (the one which you cloned above) and open the `stack.yaml` file. There may be multiple files like `stack-8.2.1.yml` or `stack-8.2.2.yaml`. Ignore those extra files. You need the `stack.yaml` file. Note down the resolver (very first line of this file). You will need to use this in the next section. [\[1\]](https://www.vacationlabs.com/haskell/environment-setup.html#hiefootnote) For example, on my machine, following are the contents of `stack.yaml` and the resolver is `lts-9.14`. **It may be different on your machine!**
    
    resolver: lts-9.14
    packages:
    - .
    - hie-apply-refact
    - hie-base
    - hie-build-plugin
    - hie-eg-plugin-async
    - hie-example-plugin2
    #
    \# and more lines will follow
    #
    

## Get used to GHCi before you start[¶](https://www.vacationlabs.com/haskell/environment-setup.html#get-used-to-ghci-before-you-start "Permalink to this headline")

GHCi is the interactive coding environment for Haskell (also known as a REPL). You will be spending a lot of time in it. It comes wth a [complete user-manual](https://downloads.haskell.org/~ghc/latest/docs/html/users_guide/ghci.html) that you can refer to when you need to do more advanced stuff, but, for now, here’s some basic stuff that you’ll need to know.

**Setup your first throw-away project:**

Warning

**For VSCode & HIE users**

In the command given below, make sure you use the correct LTS version as mentioned in [hieWarning](https://www.vacationlabs.com/haskell/environment-setup.html#hiewarning)

$ stack new --resolver=lts-9.14 first-project
$ cd first-project
$ stack setup

The last command `stack setup` may take forever, becuase it will probably download the GHC compiler and a bunch of core/base libraries. Also, it’s going to take a shitload of disk-space (about 2GB+). Keep some covfefe (or beer) handy.

**Create a new file called Throwaway.hs in your project:**

Open `first-project/src/Throwaway.hs` and make sure it has the following contents:

module Throwaway where

addNumbers :: Int
addNumbers = 1 + 2

Important

Please take care of the case. In Haskell, modules are named with **CamelCase**. The name of the module and the name of the file sould be the same, for example, in this case the module is called `Throwaway` and the file is called `Throwaway.hs`

**Now, fire-up GHCi:**

$ stack ghci

Main Lib&gt; :l Throwaway
Main&gt; addNumbers
3

**Now, make some changes to Throwaway.hs, WITHOUT EXITING GHCi:**

Note

Do **not** exit GHCi

module Throwaway where

addNumbers :: Int
addNumbers = 10 + 20

**Next, reload these changes in GHCI:**

Main&gt; :r
Main&gt; addNumbers
30

That’s the most basic development workflow to follow:

* **Always** start `ghci` with `stack ghci` from within your project directory. This will ensure that the correct version of the compiler is used and that your GHCi is aware of the files in your project and the packages that your project depends on.
* Load a file in GHCi via `:l`
* Run a function
* Change something in the function
* Reload the file via `:r` (There is a difference in the behaviour of `:l` and `:r` that you may read about, if you are interested.)
* Re-run the function

## Make sure you are reading the correct docs[¶](https://www.vacationlabs.com/haskell/environment-setup.html#make-sure-you-are-reading-the-correct-docs "Permalink to this headline")

You will find yourself referring to API documentation very often. However, **do not** search for the package names on Google and start reading docs from there. You will end-up in a world of pain without even realising it. Google doesn’t know which version of the package you’re using, and from a first-hand experience, things change _a lot_ between versions.

So, here’s what you should do:

* Check which LTS/resolver you are on – it’ll be the very first setting in your project’s `stack.yaml` file.
* Go to the [Stackage homepage](https://www.stackage.org/) and find the listing page for your LTS/resolver. For example, here’s the listing for [lts-9.17](https://www.stackage.org/lts-9.17)
* Search for documentation and packages **only from this page**

## Hackage vs Stackage & Cabal vs Stack[¶](https://www.vacationlabs.com/haskell/environment-setup.html#hackage-vs-stackage-cabal-vs-stack "Permalink to this headline")

Strangely, Haskell has two widely used package repositories. Here is how they are conceptually different and why both exist:

* [Hackage](http://hackage.haskell.org/) is the original package repository. This is where authors upload their packages to share them with the world.
* [Stackage](https://www.stackage.org/) pulls _specific versions_ of _specific packages_ from Hackage and divides them into “sets” known as “snapshots”. Each snapshot contains only a single version of any package with a guarantee that all the packages in a given snapshot will successfully build when included in a project. That is, you will not get a dependency hell when your project depends on 5 packages from the same Stackage snapshot. (If you go to a snapshot/LTS’ listing page you can verify that there is only one version of each package listed there. On the other hand, if you check the same package on Hackage, you will see all versions of the package listed there).
* Hackage has way more packages than Stackage, because, not every author adds their package to the Stackage snapshot. This is probably because, every time a new LTS/snapshot is released, package-authors have to do some extra work to maintain the “no dependeny-hell guaranteee”. However, most popular/important packages have already been added to Stackage, so you won’t be missing any packages till you start doing advanced Haskell stuff.
* The command-line tool called `cabal` does not know about Stackage and pulls packages directly from Hackage. Also, cabal+Hackage do not give this “no dependency-hell guarantee” that stack+Stackage works very hard to maintain.
* The command-line tool called `stack` pulls packages from Stackage, _by default_. Having said that, it _can_ pull packages from Hackage if a particular package is not available in its snapshot (but this requires a few extra lines of config).

Finally, lot of cabal/Hackage lovers hate stack/Stackage and vice-versa. If you are in the mood for some gossip you can search the interwebs and read some flamewars. One hopes, that at some point in the future, the best parts of stack/Stackage and cabal/Hackage can be merged to build a unified, kickass build-tool. Till that day comes, **just use Stack.**

<table class="docutils footnote" frame="void" id="hiefootnote" rules="none"><colgroup><col class="label"><col></colgroup><tbody valign="top"><tr><td class="label"><a class="fn-backref" href="https://www.vacationlabs.com/haskell/environment-setup.html#id1">[1]</a></td><td>Strictly speaking, your project and HIE need to be using the same version of <strong>GHC</strong>, not <em>necessarily</em> the same <hypothesis-highlight class="hypothesis-highlight">LTS</hypothesis-highlight>. However, for newbies, <hypothesis-highlight class="hypothesis-highlight">we recommend simply using the same LTS because it is simpler and is guaranteed to work</hypothesis-highlight>.</td></tr></tbody></table>