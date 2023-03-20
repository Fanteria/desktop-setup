# !/bin/bash

if [ -z "${HOME+x}" ] ; then echo "Var \$HOME must be set." ; exit 1 ; fi

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

# $1 source folder for links
# $2 destination folder to create links
link_recursively () {
  for DIR in `ls "$1"` ; do
    FULL_PATH="${1}/$DIR"
    NEW_PATH="${2}/$DIR"
    if [[ -f "$FULL_PATH" ]] ; then
      [[ -f "$NEW_PATH" ]] && rm "$NEW_PATH"
      ln -s "$FULL_PATH" "$NEW_PATH"
      echo "$FULL_PATH -> $NEW_PATH"
    elif [[ -d "$FULL_PATH" ]] ; then 
      [[ -d "$NEW_PATH" ]] || mkdir "$NEW_PATH"
      links_in_dir "$FULL_PATH" "$NEW_PATH"
    fi
  done
}

# Link all rc files
find "${SCRIPT_DIR}" -iname "*rc" | while read FILE; do 
  create_link "${HOME}/.$( basename $FILE )" "${FILE}"
done

link_recursively "${SCRIPT_DIR}/config" "${HOME}/.config"
