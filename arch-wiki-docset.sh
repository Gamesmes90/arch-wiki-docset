#!/bin/bash

srcdir="docset_build"
scriptdir="arch-wiki-docs"
docset_folder="arch-wiki.docset"
docset_location=$(cat ~/.config/Zeal/Zeal.conf | grep path= | sed 's/path=//g')

help () {
  echo "Usage: arch-wiki-docset [options]

    -d, --download [langs]      Download the wiki with specified languages (blank defaults to english) 
    -i, --install               Install docset
    -u, --uninstall             Uninstall docset
    -c, --clean                 Remove docset_build folder
    -b, --build                 Build docset
    -c, --checkFolder           Check for new files
    -r, --redownload            Redownload arch-wiki-docs
    -h, --help                  Show this help message
    "
  echo "Examples:

    arch-wiki-docset -d -b -i
    Downloads the wiki, builds the docset, and installs it (en only), can be used to update the docset
        
    arch-wiki-docset -d en es -b -i
    Downloads the wiki, builds the docset, and installs it (en and es), can be used to update the docset"
}

install () {
  cd docset_build
  cp -R $docset_folder $docset_location
  if [ $? -eq 0 ]; then
    echo "Docset Installed!"
  else
    echo "Error, Return Value: $?"
    exit 1
  fi
}

build () {
  cp ./meta.json $srcdir/dashing.json
  cd docset_build
  dashing build arch-wiki
  cp ../icon.png $docset_folder
  cp ../icon@2x.png $docset_folder
  mv dashing.json $docset_folder/meta.json
  if [ $? -eq 0 ]; then
      echo "Docset generated!"
  else
      echo "Error, Return Value: $?"
      exit 1
  fi
  cd ../
}

uninstall () {
  rm -R -f $docset_location/$docset_folder
  if [ $? -eq 0 ]; then
    echo "Docset Uninstalled!"
  else
    echo "Error, Return Value: $?"
    exit 1
  fi
}

clean () { # Removes building directory and script directory
  rm -R -f $srcdir
  rm file_num.txt
}

checkWiki () { # Checks for new files
  if [ ! -d "$srcdir" ]; then # Check if srcdir is missing
    echo "Error: docset_build directory missing!"
    exit 1
  fi
  
  if [ ! -f "file_num.txt" ]; then # make file_num.txt if it doesn't exist
    find docset_build/arch-wiki/html | wc -l >> file_num.txt
  fi

  # Get text file and current numbers
  files=$(find docset_build/arch-wiki/html | wc -l)
  txt_files=$(cat file_num.txt)
  
  echo "Number of files (last check): $txt_files" # Print last check

  if [ "$files" -gt "$txt_files" ]; then # Check if anything has changed
    echo "There are new files"
    find docset_build/arch-wiki/html | wc -l > file_num.txt
    echo "Number of files: $files"
  elif [ "$files" -lt "$txt_files" ]; then
    echo "Some files were removed"
    find docset_build/arch-wiki/html | wc -l > file_num.txt
    echo "Number of files: $files"
  else
    echo "No changes detected"
  fi
}

redownload () {
  rm -R -f $scriptdir
  git clone https://github.com/gamesmes90/arch-wiki-docs.git
}

downloadWiki () {
  if [ ! -d "$scriptdir" ]; then # Download script if it's not here
    git clone https://github.com/gamesmes90/arch-wiki-docs.git
  fi
  cd $srcdir
  cd arch-wiki

  if [ -z "$@" ]
  then
    python ../../arch-wiki-docs/arch-wiki-docs.py --output-directory ./html --safe-filenames --langs en
  else
    python ../../arch-wiki-docs/arch-wiki-docs.py --output-directory ./html --safe-filenames --langs $@
  fi
  # Download the arch wiki
  cd ../../
}

var=$@
if [ -z "$var" ]
then  
  help
  exit 0
fi

mkdir -p "$srcdir/arch-wiki/html" # Create building directory structure

while [[ $# -gt 0 ]]; do
  case $1 in
    -c|--checkFolder)
      shift
      checkWiki # Check for new files
      ;;
    -u|--uninstall) # uninstall docset
      uninstall
      shift
      ;;
    -c|--clean) # remove folders
      shift
      clean
      ;;
    -b|--build) # build only
      build
      shift
      ;;
    -d|--download) # download the wiki with specified languages (blank defaults to english)
      shift
      downloadWiki ${@%%-*} 
      ;;
    -i|--install) # install docset
      install
      shift
      ;;
    -r|--redownload) # redownload arch-wiki-docs
      redownload
      shift
      ;;
    -h|--help)
      help
      exit 0
      ;;
    -*|--*)
      echo "Unknown option $1"
      exit 1
      ;;
  esac
done