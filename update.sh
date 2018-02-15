#!/bin/sh
SCRIPTPATH="$( cd "$(dirname "$0")" ; pwd -P )"
cd "${SCRIPTPATH}"
git submodule sync
git submodule update --init
METAS="$( ls | grep meta- | tr '\n' ' ' | sed 's/ $//g' )"
cd ..
# Regenerate bblayers.conf so we can add our own
rm -f build/conf/bblayers.conf
make init update
# Remove existing meta-dream from bblayers.conf
sed -i "s# $(pwd)/meta-dream##g" build/conf/bblayers.conf
for i in ${METAS}
do
	sed -E -i "s%^(BBLAYERS =.*)(\"$)%\1 ${SCRIPTPATH}/${i}\"%g" build/conf/bblayers.conf
done
sed -E -i "s%^(BBLAYERS =.*)(\"$)%\1 ${SCRIPTPATH}\"%g" build/conf/bblayers.conf