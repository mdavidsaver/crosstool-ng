do_libbspext_get() { :; }
do_libbspext_extract() { :; }
do_libbspext_for_build() { :; }
do_libbspext_for_host() { :; }
do_libbspext_for_target() { :; }

if [ "${CT_LIBBSPEXT}" = "y" ]; then

do_libbspext_get() {
    CT_GetGit libbspext "${CT_LIBBSPEXT_VERSION}" \
      https://github.com/epicsdeb/rtems-libbspext.git
}

do_libbspext_extract() {
    CT_Extract libbspext-"${CT_LIBBSPEXT_VERSION}"
}

do_libbspext_for_target() {

    CT_DoStep INFO "Installing libbspExt for target"
    mkdir -p "${CT_BUILD_DIR}/build-libbspext-target-${CT_TARGET}"

    for arch in ${CT_RTEMS_BSPS}
    do
        CT_DoExecLog ALL ${make} -C ${CT_SRC_DIR}/libbspext-"${CT_LIBBSPEXT_VERSION}" \
            ARCH="${CT_BUILD_DIR}/build-libbspext-target-${CT_TARGET}/${arch}" \
            RTEMS_MAKEFILE_PATH="${CT_PREFIX_DIR}/${CT_TARGET}/${arch}" \
            install
    done

    CT_EndStep
}

fi # "${CT_LIBBSPEXT}" = "y"
