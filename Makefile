LLVM_VERSION=		14
LLVM_CONFIG=		/usr/local/bin/llvm-config${LLVM_VERSION}
WRKSRC=			${.CURDIR}/crystal
BUILD_FLAGS=		LLVM_CONFIG=${LLVM_CONFIG} FLAGS="--release --no-debug --progress"
BOOTSTRAP_ARCH!=	uname -p
BOOTSTRAP_VERSION!=	git -C ${WRKSRC} describe
BOOTSTRAP_NAME=		crystal-${BOOTSTRAP_VERSION}-${BOOTSTRAP_ARCH}-llvm${LLVM_VERSION}.tar.xz

all: bootstrap

bootstrap:
	( cd ${WRKSRC} && \
		[ -e ./src/lib_c/aarch64-freebsd ] || ln -s x86_64-freebsd ./src/lib_c/aarch64-freebsd && \
		gmake ${BUILD_FLAGS} clean crystal && \
		tar cJvf ${.CURDIR}/${BOOTSTRAP_NAME} ./.build )

clean:
	( cd ${WRKSRC} && gmake clean && rm -f ./src/lib_c/aarch64-freebsd )
	rm -f ${.CURDIR}/${BOOTSTRAP_NAME}
