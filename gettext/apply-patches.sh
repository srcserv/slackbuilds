
set -e -o pipefail

SB_PATCHDIR=${CWD}/patches

patch -p0 -E --backup -z .rpathfix --verbose -i ${SB_PATCHDIR}/gettext-0.18-rpathFix.patch

set +e +o pipefail
