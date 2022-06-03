#!/bin/bash

srcdir="docset_build"
scriptdir="arch-wiki-docs"
clear_arg="0"
zeal_arg="0"
skip="0"
docset_folder="arch-wiki.docset"

clean () { # Removes building directory and script directory
  rm -R -f $srcdir
  rm -R -f $scriptdir
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

downloadWiki () {
  if [ ! -d "$scriptdir" ]; then # Download script if it's not here
    git clone https://github.com/lahwaacz/arch-wiki-docs.git
  fi

  cd arch-wiki-docs
  git checkout 216a2170262f5b1ee4af3ac9b565fd3be2752df9 # Stable commit
  # Download the arch wiki
  LANG=en_US.UTF-8 python \
    arch-wiki-docs.py \
    --output-directory "../$srcdir/arch-wiki/html" \
    --clean \
    --safe-filenames
}

while [[ $# -gt 0 ]]; do
  case $1 in
    -cf|--checkFolder)
      shift
      checkWiki # Check for new files

      exit 0
      ;;
    -u|--update) # Update html files
      shift
      if [ ! -d "$srcdir" ]; then # Check if srcdir is missing
        echo "Error: docset_build directory missing!"
        exit 1
      fi
      
      cd $srcdir

      cp -R arch-wiki $docset_folder/Contents/Resources/Documents

      exit 0
      ;;
    -w|--wiki) # Update downloaded wiki
      shift
      if [ ! -d "$srcdir" ]; then # Check if srcdir is missing
        echo "Error: docset_build directory missing!"
        exit 1
      fi

      downloadWiki # Download the wiki

      cd ..
      checkWiki # Check for new files

      exit 0
      ;;
    -f|--folder)
      shift
      mkdir $srcdir # create docset_build folder
      exit 0
      ;;
    -z|--zeal)
      zeal_arg=$1 # install into zeal
      skip=$2 # skip building
      shift
      shift
      ;;
    -cr|--clear)
      clear_arg=$1 # remove folders after building
      shift
      ;;
    -c|--clean) # remove folders
      shift
      clean
      exit 0
      ;;
    -*|--*)
      echo "Unknown option $1"
      exit 1
      ;;
  esac
done

mkdir -p "$srcdir/arch-wiki/html" # Create building directory structure

cp meta.json $srcdir # Copy the json file
mv $srcdir/meta.json $srcdir/dashing.json

downloadWiki # Download the wiki

cd ../docset_build

if [ $skip != "skip" ]; then # skip building if -z/--zeal option has skip argument
  dashing build arch-wiki
fi

cp ../icon.png $docset_folder
cp ../icon@2x.png $docset_folder
mv dashing.json $docset_folder/meta.json

if [ $clear_arg = "-cr" ] || [ $clear_arg = "-clear" ]; then # clear if -cr/--clear option is detected
  mv $docset_folder ../
  cd ..
  clean
fi

if [ $? -eq 0 ]; then
    echo "Docset generated!"
else
    echo "Error, Return Value: $?"
    exit 1
fi

if [ $zeal_arg = "-z" ] || [ $zeal_arg = "-zeal" ]; then # install into zeal if -z/--zeal option is detected
  cp -R $docset_folder ~/.local/share/Zeal/Zeal/docsets/
  echo "Docset Installed!"
fi