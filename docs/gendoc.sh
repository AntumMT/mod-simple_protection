#!/bin/bash

PARAM=$1

SCRIPT="$(basename $(readlink -f $0))"

if [ "${PARAM}" == "help" ]; then
	echo -e "\nUsage:"
	echo -e "\t${SCRIPT} [option]"
	echo -e "\nOptions:"
	echo -e "\thelp:\tShow this help information."
	echo -e "\tclean:\tOnly clean old files. Don't generate new docs."
	exit 0
fi

DOCS="$(dirname $(readlink -f $0))"
ROOT="$(dirname ${DOCS})"
CONFIG="${DOCS}/config.ld"
TARGET="${DOCS}/api"

cd "${ROOT}"

# Clean old files
echo -e "\nCleaning old files ..."
rm -rf "${TARGET}.html" "${DOCS}/scripts" "${DOCS}/source" "${DOCS}/modules" "${DOCS}/topics" "${DOCS}/ldoc.css" "${DOCS}/data"

if [ "${PARAM}" != "clean" ]; then
	# Create new files
	echo -e "\nGenerating new documentation ..."
	ldoc -c "${CONFIG}"

	RET=$?

	if [ "${RET}" -ne "0" ]; then
		echo -e "\nAn error occurred! Could not generate HTML documentation."
		exit ${RET}
	fi

	echo -e "\nMaking some final adjustments ..."

	if [ -f "${TARGET}.html" ]; then
		# Put "prefix:name_" settings in angled brackets (<>)
		sed -i -e 's|>prefix:name|>\&lt;prefix\&gt;:\&lt;name\&gt;|' "${TARGET}.html"
	fi
fi

echo -e "Done!"
