# !/bin/bash

if [ -z "${HOME+x}" ] ; then echo "Var \$HOME must be set." ; exit 1 ; fi

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

create_link () {
  [[ -f "$1" ]] && rm "$1"
    ln -s "$2" "$1"
    echo "$1 -> $2"
}

link_recursively () {
  for DIR in `ls "$1"` ; do
    FULL_PATH="${1}/$DIR"
    NEW_PATH="${2}/$DIR"
    if [[ -f "$FULL_PATH" ]] ; then
      create_link "$NEW_PATH" "$FULL_PATH"
    elif [[ -d "$FULL_PATH" ]] ; then 
      [[ -d "$NEW_PATH" ]] || mkdir "$NEW_PATH"
      link_recursively "$FULL_PATH" "$NEW_PATH"
    fi
  done
}

# Link all rc files
find "${SCRIPT_DIR}" -maxdepth 1 -type f \
    ! -name "init_script.sh" \
    ! -name "LICENSE" \
    ! -name "README.md" \
    | while read FILE; do 
  create_link "${HOME}/.$( basename $FILE )" "${FILE}"
done

link_recursively "${SCRIPT_DIR}/config" "${HOME}/.config"
link_recursively "${SCRIPT_DIR}/cgdb" "${HOME}/.cgdb"
