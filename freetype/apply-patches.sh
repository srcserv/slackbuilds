  
SB_PATCHDIR=${CWD}/patches

# This breaks far too many things.  Freetype2 developers will have to get their
# punishment on someone else's distribution.
zcat ${SB_PATCHDIR}/freetype.illadvisederror.diff.gz | patch -p1 -E --backup --verbose || exit 1

# The line below enables code patented by Apple, so don't uncomment it
# unless you have a license to use the code and take all legal responsibility
# for doing so.
# Please see this web site for more details:
#   http://www.freetype.org/patents.html
if [ "${SB_BI}" = "YES" ] ; then
  zcat ${SB_PATCHDIR}/freetype.bytecode.interpreter.diff.gz | patch -p1 -E --backup --verbose || exit 1
fi

# The line below enables code patented by Microsoft, so don't uncomment it
# unless you have a license to use the code and take all legal responsibility
# for doing so.
if [ "${SB_SPR}" = "YES" ] ; then
  zcat ${SB_PATCHDIR}/freetype.subpixel.rendering.diff.gz | patch -p1 -E --backup --verbose || exit 1
fi

# Assorted fixes for 2.1.10 (thanks to Frederic Crozat)
# CVS bug fixes, mostly for embolding
zcat ${SB_PATCHDIR}/freetype-2.2.1-enable-valid.patch.gz | patch -p1 -E --backup --verbose || exit 1
zcat ${SB_PATCHDIR}/freetype-multilib.patch.gz | patch -p1 -E --backup --verbose || exit 1

# Fix crash https://bugs.freedesktop.org/show_bug.cgi?id=6841
zcat ${SB_PATCHDIR}/freetype-2.2.1-memcpy-fix.patch.gz | patch -p1 -E --backup --verbose || exit 1
