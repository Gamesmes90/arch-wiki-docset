# arch-wiki-docset
Script to generate pages from Arch Wiki in docset format (tested with [zeal](https://github.com/zealdocs/zeal/))

**Note**: Building may take a long time.

You can download pre built pages from the [releases page](https://github.com/Gamesmes90/arch-wiki-docset/releases) (usually it's not up-to-date)
You can also find the ```info.plist``` file and the ```docSet.dsidx``` file there.

Check [Installation](#manual-installation) for manual instructions.

All [releases tags](https://github.com/Gamesmes90/arch-wiki-docset/releases) are in Day/Month/Year format

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
##### To build the docset run
```bash
./arch-wiki-docset.sh
```

##### Remove folders after building with
```bash
./arch-wiki-docset.sh -cr
```
or
```bash
./arch-wiki-docset.sh --clear
```

##### Remove folders with
```bash
./arch-wiki-docset.sh -c
```
or
```bash
./arch-wiki-docset.sh --clean
```

##### Installation (zeal)
```bash
./arch-wiki-docset.sh -z
```
or
```bash
./arch-wiki-docset.sh --zeal
```
You can skip building the docset by adding ```skip``` after ```-z``` or ```--zeal``` option.

##### Manual installation

Alternatively, you can manually move the folder to ```.local/share/Zeal/Zeal/docsets```.

##### Download the arch wiki only
```bash
./arch-wiki-docset.sh -w
```
or
```bash
./arch-wiki-docset.sh --wiki
```
This will download files only if they are not up-to-date, it will also check and report if there are new files.

### Updating

If there aren't any new pages on the wiki, you can try to copy the ```arch-wiki``` folder inside ```arch-wiki.docset/Contents/Resources/Documents``` to avoid rebuilding the entire docset.

You can do this with
```bash
./arch-wiki-docset.sh -u
```
or
```bash
./arch-wiki-docset.sh --update
```

Keeping track of the number of files inside the wiki folder could help finding new files.

You can do this with
```bash
./arch-wiki-docset.sh -cf
```
or
```bash
./arch-wiki-docset.sh --checkFolder
```

#### Extras
To build the arch wiki for only the languages of your choice go inside ```arch-wiki/html``` and delete the folders of the languages you don't care about. (This might save some time during building). 

Keep in mind that the download script will download all languages anyway, the current commit has a [language filter]() but it doesn't seem to be working at this time.

You can keep a copy of the ```arch-wiki``` folder found inside ```docset_build``` and delete the other directories

You can create the ```docset_build``` folder only with
```bash
./arch-wiki-docset.sh -f
```
or
```bash
./arch-wiki-docset.sh --folder
```

to then copy ```arch-wiki``` inside it when you need it

This will save you some space.

Keeping the files would make it easier to update the wiki (check [updating section](#updating)).

### Build only
To only build the wiki do
```
./arch-wiki-docset.sh -b
```
or
```
./arch-wiki-docset.sh --build
```
### Install only
To only install the docset do
```
./arch-wiki-docset.sh -i
```
or
```
./arch-wiki-docset.sh --install
```
### Language filter
arch-wiki-docs will always download all languages, so this script has a language filter. To make it work just uncomment the lines of the languages you wish to remove in [filter.cfg](./filter.cfg) and then do
```
./arch-wiki-docset.sh -l
```
or
```
./arch-wiki-docset.sh --filter
```