
set -e -o pipefail

SB_PATCHDIR=${CWD}/patches

# patch -p0 -E --backup --verbose -i ${SB_PATCHDIR}/${NAME}.patch
patch -p1 -E --backup --verbose -i ${SB_PATCHDIR}/${NAME}-20020927-rh.patch
patch -p1 -E --backup --verbose -i ${SB_PATCHDIR}/${NAME}-20020124-countermeasures.patch
patch -p1 -E --backup --verbose -i ${SB_PATCHDIR}/${NAME}-20020927-ping-subint.patch
patch -p1 -E --backup --verbose -i ${SB_PATCHDIR}/${NAME}-ifenslave.patch
patch -p1 -E --backup -z .idn --verbose -i ${SB_PATCHDIR}/${NAME}-20121112-idn.patch
patch -p1 -E --backup --verbose -i ${SB_PATCHDIR}/${NAME}-20070202-ia64_align.patch
patch -p1 -E --backup --verbose -i ${SB_PATCHDIR}/${NAME}-20071127-corr_type.patch
patch -p1 -E --backup --verbose -i ${SB_PATCHDIR}/${NAME}-20100418-convtoint.patch
patch -p1 -E --backup --verbose -i ${SB_PATCHDIR}/${NAME}-20101006-eth.patch
patch -p1 -E --backup --verbose -i ${SB_PATCHDIR}/${NAME}-s20121112-idn-free.patch
patch -p1 -E --backup --verbose -i ${SB_PATCHDIR}/${NAME}-ping_radix_point.patch

set +e +o pipefail
