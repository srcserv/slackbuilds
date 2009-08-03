  
SB_PATCHDIR=${CWD}/patches

# The wonderful extended version of the font so generously
# opened up for free modification and distribution by one
# for the previously proprietary font founderies, and that
# Stepan Roh did such a marvelous job on getting the ball
# rolling with should clearly (IMHO) be the default font:
zcat ${SB_PATCHDIR}/fontconfig.dejavu.diff.gz | patch -p1 --verbose || exit 1

# Hardcode the default font search path rather than having
# fontconfig figure it out (and possibly follow symlinks, or
# index ugly bitmapped fonts):
zcat ${SB_PATCHDIR}/fontconfig.font.dir.list.diff.gz | patch -p0 --verbose --backup --suffix=.orig || exit 1
