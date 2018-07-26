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
rm -rf "${TARGET}.html" "${DOCS}/scripts" "${DOCS}/source" "${DOCS}/modules" "${DOCS}/topics" "${DOCS}/ldoc.css"

if [ "${PARAM}" != "clean" ]; then
	# Create new files
	echo -e "\nGenerating new documentation ..."
	ldoc -c "${CONFIG}" -d "${DOCS}" "${TARGET}.ldoc"

	echo -e "\nMaking some final adjustments ..."

	if [ -f "${TARGET}.html" ]; then
		# Put "prefix:name_" settings in angled brackets (<>)
		sed -i -e 's|>prefix:name|>\&lt;prefix\&gt;:\&lt;name\&gt;|' "${TARGET}.html"
	fi

	# Rename section "Source" to "Category"
	for F in $(find "${DOCS}" -type f -name "*.html"); do
		sed -i -e 's|<h2>Source</h2>|<h2>Category</h2>|' "${F}"
	done

	for F in $(find "${DOCS}/source" -type f -name "*.html"); do
		sed -i -e 's|<h1>File |<h1>Category |' "${F}"
	done
fi

echo -e "Done!"
