# !/bin/bash

if [ -z "${HOME+x}" ] ; then echo "Var \$HOME must be set." ; exit 1 ; fi

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

# $1 Config path $CONFIG_PATH
# $2 File path $FILE
create_link () {
  [[ -f "$1" ]] && rm "$1"
  ln -s "$2" "$1"
  echo "$2 -> $1"
}

# Link all rc files
find "${SCRIPT_DIR}" -iname "*rc" | while read FILE; do 
  create_link "${HOME}/.$( basename $FILE )" "${FILE}"
done

# Link all in config folder
for DIR in ${SCRIPT_DIR}/config/* ; do
  BASENAME="${HOME}/.config/$( basename $DIR )"
  [[ -f "${DIR}" ]] && create_link "${BASENAME}" "${DIR}" && continue
  [[ -d "${DIR}" ]] || continue
  [[ -d "${BASENAME}" ]] || mkdir "${BASENAME}"
  for FILE in ${DIR}/* ; do
    create_link "${BASENAME}/$( basename ${FILE} )" "${FILE}"
  done
done
