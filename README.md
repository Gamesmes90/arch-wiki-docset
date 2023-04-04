# arch-wiki-docset
Script to generate pages from Arch Wiki in docset format (tested with [zeal](https://github.com/zealdocs/zeal/))

**Note**: Building may take a long time.

Check [Installation](#manual-installation) for manual instructions.

## Contents
- [Dependencies](#dependencies)
- [Running](#running)
- [Usage](#usage)
- [Updating](#updating)
- [Extras](#extras)

## Dependencies
- git
- [dashing](https://github.com/technosophos/dashing) ([aur link](https://aur.archlinux.org/packages/dashing))
- arch-wiki-docs (and its dependencies)
    - python
    - python-simplemediawiki
    - python-lxml
    - python-cssselect
    - python-requests


## Running
Set run permissions
```bash
chmod +x arch-wiki-docset.sh
```
or run with ```bash``` command


## Usage

Download build and install with
```bash
./arch-wiki-docset.sh -d -b -i
```
or
```bash
./arch-wiki-docset.sh --download --build --install
```
this can be used to update the docset as well

### Commands
#### Download wiki
```bash
./arch-wiki-docset.sh -d
```
or
```bash
./arch-wiki-docset.sh --download
```

#### Build docset
```bash
./arch-wiki-docset.sh -b
```
or
```bash
./arch-wiki-docset.sh --build
```

#### Remove build folders
```bash
./arch-wiki-docset.sh -c
```
or
```bash
./arch-wiki-docset.sh --clean
```

#### Install docset
```bash
./arch-wiki-docset.sh -i
```
or
```bash
./arch-wiki-docset.sh --install
```

#### Uninstall docset
```bash
./arch-wiki-docset.sh -u
```
or
```bash
./arch-wiki-docset.sh --uninstall
```

#### Check for new files in wiki
```bash
./arch-wiki-docset.sh -c
```
or
```bash
./arch-wiki-docset.sh --checkFolder
```
Note: The wiki has to be redownloaded to check if there are new files

#### Redownload arch-wiki-docs
```bash
./arch-wiki-docset.sh -r
```
or
```bash
./arch-wiki-docset.sh --redownload
```

#### Help
```bash
./arch-wiki-docset.sh -h
```
or
```bash
./arch-wiki-docset.sh --help
```