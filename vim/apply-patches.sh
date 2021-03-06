
set -e -o pipefail

SB_PATCHDIR=${CWD}/patches

# patch -p0 -E --backup --verbose -i ${SB_PATCHDIR}/${NAME}.patch
if [ "${SB_SYNUP}" = "YES" ] && [ ! -r ${SB_PATCHDIR}/updates/vim-runtime-syntax-${SYNUPVER}.patch.gz ] ;then
  rm -rf runtime/syntax.orig
  cp -a runtime/syntax runtime/syntax.orig
  echo "Fetching vim syntax updates from ftp.nluug.nl..."
  rsync -avzcP ftp.nluug.nl::Vim/runtime/syntax/ runtime/syntax/
  diff -u -r --new-file runtime/syntax.orig runtime/syntax | gzip -9c \
    > ${SB_PATCHDIR}/updates/vim-runtime-syntax-${SYNUPVER}.patch.gz || :
  rm -rf runtime/syntax
  mv runtime/syntax.orig runtime/syntax
fi

zcat ${SB_PATCHDIR}/vim-7.0-fixkeys.patch.gz | patch -p1 --verbose
zcat ${SB_PATCHDIR}/vim-6.2-specsyntax.patch.gz | patch -p1 --verbose
patch -p1 -E --verbose -i ${SB_PATCHDIR}/vim-7.4-crv.patch
if [ "${SB_HUNSPELL}" = "YES" ] ;then
  zcat ${SB_PATCHDIR}/vim-7.0-hunspell.patch.gz | patch -p1 --verbose
fi

# For patch .780
mv runtime/doc/eval.txt runtime/doc/eval.txt.orig
iconv -f iso-8859-1 -t utf-8 runtime/doc/eval.txt.orig -o runtime/doc/eval.txt

if [ "${PATCHLEVEL}" -gt 0 ] ;then
mkdir -p patches
cp ${SB_PATCHDIR}/updates/${SVER}.* patches/

patch -p0 -E --verbose -i  ${SB_PATCHDIR}/vim-fix-p859.patch

( SB_PATCHDIR=patches
  for i in $( seq -w ${PATCHLEVEL} ) $( seq 1000 ${OVERPATCHLEVEL} ) ; do
    patch -p0 --backup --verbose -i ${SB_PATCHDIR}/${SVER}.${i}
  done
)
fi
sed -i \
  -e '/nl \\/d' \
  -e '/nl.mo \\/d' \
  -e '/nl.ck \\/d' \
  src/po/Makefile || exit 1

if [ "${SB_SYNUP}" = "YES" ] ;then
  zcat ${SB_PATCHDIR}/updates/vim-runtime-syntax-${SYNUPVER}.patch.gz | patch -p0 --verbose
fi

patch -p1 -E --verbose -i ${SB_PATCHDIR}/vim-7.4-syntax.patch
zcat ${SB_PATCHDIR}/vim-7.1-nowarnings.patch.gz | patch -p1 --verbose
zcat ${SB_PATCHDIR}/vim-6.1-rh3.patch.gz | patch -p1 --verbose
zcat ${SB_PATCHDIR}/vim-7.0-rclocation.patch.gz | patch -p1 --verbose
zcat ${SB_PATCHDIR}/vim-6.4-checkhl.patch.gz | patch -p1 --verbose
patch -p1 -E --verbose -i ${SB_PATCHDIR}/vim-7.3-fstabsyntax.patch
zcat ${SB_PATCHDIR}/vim-7.0-warning.patch.gz | patch -p1 --verbose
zcat ${SB_PATCHDIR}/vim-7.0-syncolor.patch.gz | patch -p1 --verbose
zcat ${SB_PATCHDIR}/vim-7.0-specedit.patch.gz | patch -p1 --verbose
patch -p1 -E --verbose -i ${SB_PATCHDIR}/vim72-rh514717.patch

patch -p0 -E --verbose -i ${SB_PATCHDIR}/vim-vimrc.patch

set +e +o pipefail
