# cfop

**C**loud **F**oundry **OP**erator tools

## Usage

### Enabling autocompletion and adding cfop to your path

Run `bin/cfop init` which will ask you to add some lines to your .bash_profile.
If you don't want to add that to your profile, you can copy that output and run it in your current shell.
This will enable autocompletion for cfop commands and add cfop to your path.

### Current commands

To see what commands are available, run `cfop help` or `cfop commands`.

### Will it work in my shell?

Run `cfop spec` to run all the tests!
You will have to have rspec in your path already.

## Development

cfop is based on 37signals' `sub` tool, whose documentation is available [here](https://github.com/37signals/sub).
In short, new commands require an executable file in the libexec folder (be sure to chmod this file to be executable).
By convention we are putting Ruby source code under share/{lib,spec}.
