
set -e -o pipefail

SB_PATCHDIR=${CWD}/patches

# patch -p0 -E --backup --verbose -i ${SB_PATCHDIR}/${NAME}.patch
patch -p1 -E --backup -z .libguess --verbose -i ${SB_PATCHDIR}/${NAME}-0.2.9-libguess.patch

set +e +o pipefail
