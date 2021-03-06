
set -e -o pipefail

SB_PATCHDIR=${CWD}/patches

unset PATCH_VERBOSE_OPT
[ "${PATCH_VERBOSE}" = "YES" ] && PATCH_VERBOSE_OPT="--verbose"
[ "${PATCH_SVERBOSE}" = "YES" ] && set -o xtrace

PATCHCOM="patch -p1 -s --backup ${PATCH_VERBOSE_OPT}"

ApplyPatch() {
  local patch=$1
  shift
  if [ ! -f ${SB_PATCHDIR}/${patch} ]; then
    exit 1
  fi
  echo "Applying ${patch}"
  case "${patch}" in
  *.bz2) bzcat "${SB_PATCHDIR}/${patch}" | ${PATCHCOM} ${1+"$@"} ;;
  *.gz) zcat "${SB_PATCHDIR}/${patch}" | ${PATCHCOM} ${1+"$@"} ;;
  *) ${PATCHCOM} ${1+"$@"} -i "${SB_PATCHDIR}/${patch}" ;;
  esac
}

# Use old-style locale directories rather than a single (and strangely
# formatted) /usr/lib/locale/locale-archive file:
ApplyPatch glibc.locale.no-archive.diff.gz
# The is_IS locale is causing a strange error about the "echn" command
# not existing.  This patch reverts is_IS to the version shipped in
# glibc-2.5:
ApplyPatch is_IS.diff.gz
# Fix NIS netgroups:
ApplyPatch glibc.nis-netgroups.diff.gz
# Support ru_RU.CP1251 locale:
ApplyPatch glibc.ru_RU.CP1251.diff.gz
# http://sources.redhat.com/bugzilla/show_bug.cgi?id=411
# http://sourceware.org/ml/libc-alpha/2009-07/msg00072.html
ApplyPatch glibc-__i686.patch

if [ "${SB_BOOTSTRP}" = "YES" ] ;then
  # Multilib - Disable check for forced unwind (Patch from eglibc) since we
  # do not have a multilib glibc yet to link to;
  ApplyPatch glibc.pthread-disable-forced-unwind-check.diff
fi

### Gentoo
( SB_PATCHDIR=patches

  ApplyPatch 00_all_0001-disable-ldconfig-during-install.patch
  ApplyPatch 00_all_0002-workaround-crash-when-handling-signals-in-static-PIE.patch
  ApplyPatch 00_all_0003-make-fortify-logic-checks-less-angry.patch
  ApplyPatch 00_all_0004-Fix-localedef-segfault-when-run-under-exec-shield-Pa.patch
  ApplyPatch 00_all_0005-reload-etc-resolv.conf-when-it-has-changed.patch
  ApplyPatch 00_all_0009-gentoo-support-running-tests-under-sandbox.patch
  ApplyPatch 00_all_0010-gentoo-disable-building-in-timezone-subdir.patch
  
)

## Fedora
ApplyPatch glibc-fedora-nptl-linklibc.patch
ApplyPatch glibc-fedora-i386-tls-direct-seg-refs.patch
ApplyPatch glibc-fedora-gai-canonical.patch
ApplyPatch glibc-fedora-pt_chown.patch
ApplyPatch glibc-fedora-elf-rh737223.patch
ApplyPatch glibc-fedora-elf-ORIGIN.patch
ApplyPatch glibc-fedora-elf-init-hidden_undef.patch

ApplyPatch glibc-rh911307.patch
ApplyPatch glibc-rh952799.patch

ApplyPatch glibc-rh757881.patch
# Upstream BZ 9954
ApplyPatch glibc-rh739743.patch
# Upstream BZ 13818
ApplyPatch glibc-rh800224.patch
# Upstream BZ 14247
ApplyPatch glibc-rh827510.patch
# Upstream BZ 13028
ApplyPatch glibc-rh841787.patch
# Upstream BZ 14185
ApplyPatch glibc-rh819430.patch
#Upstream BZ 14547
ApplyPatch glibc-strcoll-cve.patch

## Mandriva
ApplyPatch glibc-2.11.1-localedef-archive-follow-symlinks.patch 
ApplyPatch glibc-2.9-ldd-non-exec.patch.gz
ApplyPatch glibc-2.15-nss-upgrade.patch
ApplyPatch glibc-2.4.90-compat-EUR-currencies.patch.gz
ApplyPatch glibc-2.9-nscd-no-host-cache.patch.gz
ApplyPatch glibc-2.3.2-tcsetattr-kernel-bug-workaround.patch.gz
ApplyPatch glibc-2.10.1-biarch-cpp-defines.patch.gz
ApplyPatch glibc-2.6-nice_fix.patch
ApplyPatch glibc-2.8-ENOTTY-fr-translation.patch.gz
ApplyPatch glibc-2.3.5-biarch-utils.patch.gz
ApplyPatch glibc-2.16-multiarch.patch
ApplyPatch glibc-2.3.6-pt_BR-i18nfixes.patch.gz

## master
ApplyPatch 0001-Fix-cbrtl-for-ldbl-96.patch
ApplyPatch glibc-2.18-readdir_r-CVE-2013-4237.patch

## From Arch
ApplyPatch glibc-2.18-strstr-hackfix.patch

set +e +o pipefail
