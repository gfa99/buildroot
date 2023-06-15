#!/usr/bin/env bash

rsync_rootfs_to_sysroot() {
echo "----------- Sync: opt -----------"
rsync -av --progress  ${rootfs}/opt               ${sysroot} --delete
sync
echo "----------- Sync: lib -----------"
rsync -av --progress  ${rootfs}/lib               ${sysroot} --delete
rsync -av --progress  ${rootfs}/lib64             ${sysroot} --delete
sync
echo "----------- Sync: usr -----------"
# rsync -av --progress  ${rootfs}/usr               ${sysroot} --delete
rsync -av --progress  ${rootfs}/usr/lib           ${sysroot}/usr       --delete
rsync -av --progress  ${rootfs}/usr/lib64         ${sysroot}/usr       --delete
rsync -av --progress  ${rootfs}/usr/include       ${sysroot}/usr       --delete
rsync -av --progress  ${rootfs}/usr/local/lib     ${sysroot}/usr/local --delete
rsync -av --progress  ${rootfs}/usr/local/lib64   ${sysroot}/usr/local --delete
rsync -av --progress  ${rootfs}/usr/local/include ${sysroot}/usr/local --delete
sync
echo "----------- Sync: etc -----------"
rsync -av --progress  ${rootfs}/etc --exclude="shadow" ${sysroot}      --delete 
sync
}

rsync_libc_to_sysroot() {
echo "----------- Sync: libc -----------"
    rsync -av --progress  ${toolchain_libcdir}/lib/*         ${sysroot}/lib
    rsync -av --progress  ${toolchain_libcdir}/usr/lib/*     ${sysroot}/usr/lib
    rsync -av --progress  ${toolchain_libcdir}/usr/include/* ${sysroot}/usr/include

case ${toolchain_arch} in
  *64) 
    rsync -av --progress  ${toolchain_libcdir}/lib64/*       ${sysroot}/lib64
    rsync -av --progress  ${toolchain_libcdir}/usr/lib64/*   ${sysroot}/usr/lib64
  ;;
  *) 
    rsync -av --progress  ${toolchain_libcdir}/lib32/*       ${sysroot}/lib32
    rsync -av --progress  ${toolchain_libcdir}/usr/lib32/*   ${sysroot}/usr/lib32
  ;;
esac
sync
}

main() {
  rootfs=tmpimg
  if [ -d "$1" ]; then
    rootfs="$1"
  fi

  sysroot=sysroot
  if [ -d $(dirname $2) ]; then
    sysroot="$2"
  fi

  toolchain_prefix=$3
  toolchain_insdir=$4
  toolchain_arch=`echo $toolchain_prefix | cut -d - -f 1`
  toolchain_libcdir=$toolchain_insdir/$toolchain_prefix/libc

  fix_links=$(dirname $(realpath "$0"))/sysroot-relativelinks.py
  fix_cmakes=$(dirname $(realpath "$0"))/fix_cmakes_for_cross.py

  mkdir -p ${sysroot}

  rsync_rootfs_to_sysroot
  rsync_libc_to_sysroot

  [ $? != 0 ] && printf "\e[33mfailed take sysroot from rootfs\n\e[0m" && exit 1
  printf "\e[33mfinished taking sysroot from rootfs\n\e[0m"
  notify-send "finished taking sysroot from rootfs" >/dev/null 2>&1

  printf "\e[33mPlease wait to fix sysroot-relativelinks...\n\e[0m"
  python ${fix_links} ${sysroot}

  #echo "Please wait to fix sysroot cmakes ..."
  #python ${fix_cmakes} ${sysroot}

  printf "\e[33msysroot is readly, Enjoy!\n\e[0m"
  notify-send "sysroot is readly, Enjoy!" >/dev/null 2>&1
}

main $@
