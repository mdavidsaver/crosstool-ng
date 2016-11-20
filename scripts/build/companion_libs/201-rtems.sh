# Build script for rtems

do_rtems_get() { :; }
do_rtems_extract() { :; }
do_rtems_for_build() { :; }
do_rtems_for_host() { :; }
do_rtems_for_target() { :; }

if [ -n "${CT_RTEMS_KERNEL_VERSION}" ]; then

do_rtems_get() {
    # check for mis-configuration early
    [ -z "${CT_RTEMS_BSPS}" ] && CT_Abort "Must select at least one BSP when building RTEMS kernel"

    # eg. https://ftp.rtems.org/pub/rtems/releases/4.10/4.10.2/rtems-4.10.2.tar.bz2
    CT_GetFile "rtems-${CT_RTEMS_KERNEL_VERSION}" \
               "https://ftp.rtems.org/pub/rtems/releases/4.10/${CT_RTEMS_KERNEL_VERSION}/" \
               "https://ftp.rtems.org/pub/rtems/releases/4.11/${CT_RTEMS_KERNEL_VERSION}/" \
               "https://ftp.rtems.org/pub/rtems/releases/4.12/${CT_RTEMS_KERNEL_VERSION}/"
}

do_rtems_extract() {
    CT_Extract "rtems-${CT_RTEMS_KERNEL_VERSION}"
    CT_Patch "rtems" "${CT_RTEMS_KERNEL_VERSION}"
}

do_rtems_for_target() {
    local -a opts

    CT_DoStep INFO "Installing RTEMS kernel libs for target"
    CT_mkdir_pushd "${CT_BUILD_DIR}/build-rtems-target-${CT_TARGET}"

    opts=("--enable-rdbg")
          
    [ "${CT_CC_LANG_CXX}" = "y" ] && opts+=("--enable-cxx") || opts+=("--disable-cxx")

    # RTEMS requires that BUILD=HOST a la. GCC
    CT_DoLog EXTRA "Configuring RTEMS Kernel"
    CT_DoExecLog CFG                                                    \
    "${CT_SRC_DIR}/rtems-${CT_RTEMS_KERNEL_VERSION}/configure"          \
        --target=${CT_TARGET}                                           \
        --build=${CT_BUILD}                                             \
        --host=${CT_BUILD}                                              \
        --prefix="${CT_PREFIX_DIR}"                                     \
        --enable-rtemsbsp="${CT_RTEMS_BSPS}"                            \
        "${opts[@]}"

    CT_DoLog EXTRA "Building RTEMS Kernel"
    CT_DoExecLog ALL ${make} ${JOBSFLAGS}
    CT_DoLog EXTRA "Installing RTEMS Kernel"
    CT_DoExecLog ALL ${make} install

    CT_Popd
    CT_EndStep
}

fi # end -n ${CT_RTEMS_KERNEL_VERSION}
