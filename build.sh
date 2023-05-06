#!/bin/bash

# Bash Color
green='\033[01;32m'
red='\033[01;31m'
blink_red='\033[05;31m'
restore='\033[0m'

clear

# Resources
THREAD="-j$(grep -c ^processor /proc/cpuinfo)"
KERNEL="Image"
DTBIMAGE="dtb.img"

# Defconfigs
STARDEFCONFIG="exynos9810-starlte_defconfig"
STAR2DEFCONFIG="exynos9810-star2lte_defconfig"
CROWNDEFCONFIG="exynos9810-crownlte_defconfig"

STARAOSPDEFCONFIG="exynos9810-starlte_defconfig"
STAR2AOSPDEFCONFIG="exynos9810-star2lte_defconfig"
CROWNAOSPDEFCONFIG="exynos9810-crownlte_defconfig"

# Build dirs
KERNEL_DIR="$HOME/kernel/kernel_samsung_exynos9810"
RESOURCE_DIR="$KERNEL_DIR/.."
KERNELFLASHER_DIR="$HOME/kernel/Kernel_Flasher"
TOOLCHAIN_DIR="$HOME/kernel/tc/"

# Kernel Details
BASE_MARU_VER="MARU.ONEUI.UNI"
BASE_AOSP_MARU_VER="MARU.AOSP.UNI"
VER=".SE.003"
MARU_VER="$BASE_MARU_VER$VER"
MARU_AOSP_VER="$BASE_AOSP_MARU_VER$VER"
STAR_VER="S9."
STAR2_VER="S9+."
CROWN_VER="N9."

# Vars
export ARCH=arm64
export SUBARCH=arm64
export KBUILD_BUILD_USER=maru
export KBUILD_BUILD_HOST=kernelbuildmachine


# Image dirs
ZIP_MOVE="/home/MARU/Android/Kernel/Zip"
ZIMAGE_DIR="$KERNEL_DIR/out/arch/arm64/boot"

# Functions
function clean_all {
		cd $KERNEL_DIR
		echo
		make clean && make mrproper
        	rm -rf out/
}

function make_star_kernel {
		echo
        export LOCALVERSION=-`echo $STAR_VER$MARU_VER`
        make O=out ARCH=arm64 $STARDEFCONFIG

        PATH="$HOME/kernel/tc/clang/bin:$HOME/kernel/tc/aarch64-linux-android-4.9/bin:${PATH}" \
        make -j$(nproc --all) O=out \
                      ARCH=arm64 \
                      CC=clang \
                      CLANG_TRIPLE=aarch64-linux-gnu- \
                      CROSS_COMPILE=aarch64-linux-android-

		cp -vr $ZIMAGE_DIR/$KERNEL $KERNELFLASHER_DIR/Kernel/G960/zImage
        cp -vr $ZIMAGE_DIR/$DTBIMAGE $KERNELFLASHER_DIR/Kernel/G960/dtb.img
}

function make_star_aosp_kernel {
		echo
        export LOCALVERSION=-`echo $STAR_VER$MARU_AOSP_VER`
        make O=out ARCH=arm64 $STARAOSPDEFCONFIG

        PATH="$HOME/kernel/tc/clang/bin:$HOME/kernel/tc/aarch64-linux-android-4.9/bin:${PATH}" \
        make -j$(nproc --all) O=out \
                      ARCH=arm64 \
                      CC=clang \
                      CLANG_TRIPLE=aarch64-linux-gnu- \
                      CROSS_COMPILE=aarch64-linux-android-

		cp -vr $ZIMAGE_DIR/$KERNEL $KERNELFLASHER_DIR/Kernel/G960/zImage
        cp -vr $ZIMAGE_DIR/$DTBIMAGE $KERNELFLASHER_DIR/Kernel/G960/dtb.img
}

function make_star2_kernel {
		echo
        export LOCALVERSION=-`echo $STAR2_VER$MARU_VER`
        make O=out ARCH=arm64 $STAR2DEFCONFIG

        PATH="$HOME/kernel/tc/clang10/bin:$HOME/kernel/tc/aarch64-linux-android-4.9/bin:${PATH}" \
        make -j$(nproc --all) O=out \
                      ARCH=arm64 \
                      CC=clang \
                      CLANG_TRIPLE=aarch64-linux-gnu- \
                      CROSS_COMPILE=aarch64-linux-android-

		cp -vr $ZIMAGE_DIR/$KERNEL $KERNELFLASHER_DIR/Kernel/G965/zImage
        cp -vr $ZIMAGE_DIR/$DTBIMAGE $KERNELFLASHER_DIR/Kernel/G965/dtb.img
}

function make_star2_aosp_kernel {
		echo
        export LOCALVERSION=-`echo $STAR2_VER$MARU_AOSP_VER`
        make O=out ARCH=arm64 $STAR2AOSPDEFCONFIG

        PATH="$HOME/kernel/tc/clang/bin:$HOME/kernel/tc/aarch64-linux-android-4.9/bin:${PATH}" \
        make -j$(nproc --all) O=out \
                      ARCH=arm64 \
                      CC=clang \
                      CLANG_TRIPLE=aarch64-linux-gnu- \
                      CROSS_COMPILE=aarch64-linux-android-

		cp -vr $ZIMAGE_DIR/$KERNEL $KERNELFLASHER_DIR/Kernel/G965/zImage
        cp -vr $ZIMAGE_DIR/$DTBIMAGE $KERNELFLASHER_DIR/Kernel/G965/dtb.img
}

function make_crown_kernel {
		echo
        export LOCALVERSION=-`echo $CROWN_VER$MARU_VER`
        make O=out ARCH=arm64 $CROWNDEFCONFIG

        PATH="$HOME/kernel/tc/clang/bin:$HOME/kernel/tc/aarch64-linux-android-4.9/bin:${PATH}" \
        make -j$(nproc --all) O=out \
                      ARCH=arm64 \
                      CC=clang \
                      CLANG_TRIPLE=aarch64-linux-gnu- \
                      CROSS_COMPILE=aarch64-linux-android-

		cp -vr $ZIMAGE_DIR/$KERNEL $KERNELFLASHER_DIR/Kernel/N960/zImage
        cp -vr $ZIMAGE_DIR/$DTBIMAGE $KERNELFLASHER_DIR/Kernel/N960/dtb.img
}

function make_crown_aosp_kernel {
		echo
        export LOCALVERSION=-`echo $CROWN_VER$MARU_AOSP_VER`
        make O=out ARCH=arm64 $CROWNAOSPDEFCONFIG

        PATH="$HOME/kernel/tc/clang/bin:$HOME/kernel/tc/aarch64-linux-android-4.9/bin:${PATH}" \
        make -j$(nproc --all) O=out \
                      ARCH=arm64 \
                      CC=clang \
                      CLANG_TRIPLE=aarch64-linux-gnu- \
                      CROSS_COMPILE=aarch64-linux-android-

		cp -vr $ZIMAGE_DIR/$KERNEL $KERNELFLASHER_DIR/Kernel/N960/zImage
        cp -vr $ZIMAGE_DIR/$DTBIMAGE $KERNELFLASHER_DIR/Kernel/N960/dtb.img
}

function make_zip {
		cd $KERNELFLASHER_DIR
		zip -r9 `echo $MARU_VER`.zip *
		mv  `echo $MARU_VER`.zip $ZIP_MOVE
		cd $KERNEL_DIR
}

function make_aosp_zip {
		cd $KERNELFLASHER_DIR
		zip -r9 `echo $MARU_AOSP_VER`.zip *
		mv  `echo $MARU_AOSP_VER`.zip $ZIP_MOVE
		cd $KERNEL_DIR
}
DATE_START=$(date +"%s")

echo -e "${green}"
echo "MARU Kernel Creation Script:"
echo

echo "---------------"
echo "Kernel Version:"
echo "---------------"

echo -e "${red}"; echo -e "${blink_red}"; echo "$MARU_VER"; echo -e "${restore}";

echo -e "${green}"
echo "-----------------"
echo "Making MARU Kernel:"
echo "-----------------"
echo -e "${restore}"

while read -p "Do you want to clean stuffs (y/n)? " cchoice
do
case "$cchoice" in
	y|Y )
		clean_all
		echo
		echo "All Cleaned now."
		break
		;;
	n|N )
		break
		;;
	* )
		echo
		echo "Invalid try again!"
		echo
		;;
esac
done

echo

while read -p "Do you want to build G965 kernel (y/n)? " dchoice
do
case "$dchoice" in
	y|Y)
		make_star2_kernel
		break
		;;
	n|N )
		break
		;;
	* )
		echo
		echo "Invalid try again!"
		echo
		;;
esac
done

echo

while read -p "Do you want to clean stuffs (y/n)? " cchoice
do
case "$cchoice" in
	y|Y )
		clean_all
		echo
		echo "All Cleaned now."
		break
		;;
	n|N )
		break
		;;
	* )
		echo
		echo "Invalid try again!"
		echo
		;;
esac
done

echo

while read -p "Do you want to build G960 kernel (y/n)? " dchoice
do
case "$dchoice" in
	y|Y)
		make_star_kernel
		break
		;;
	n|N )
		break
		;;
	* )
		echo
		echo "Invalid try again!"
		echo
		;;
esac
done

echo

while read -p "Do you want to clean stuffs (y/n)? " cchoice
do
case "$cchoice" in
	y|Y )
		clean_all
		echo
		echo "All Cleaned now."
		break
		;;
	n|N )
		break
		;;
	* )
		echo
		echo "Invalid try again!"
		echo
		;;
esac
done

echo

while read -p "Do you want to build N960 kernel (y/n)? " dchoice
do
case "$dchoice" in
	y|Y)
		make_crown_kernel
		break
		;;
	n|N )
		break
		;;
	* )
		echo
		echo "Invalid try again!"
		echo
		;;
esac
done

echo

while read -p "Do you want to zip kernel (y/n)? " dchoice
do
case "$dchoice" in
	y|Y)
		make_zip
		break
		;;
	n|N )
		break
		;;
	* )
		echo
		echo "Invalid try again!"
		echo
		;;
esac
done

echo

while read -p "Do you want to clean stuffs (y/n)? " cchoice
do
case "$cchoice" in
	y|Y )
		clean_all
		echo
		echo "All Cleaned now."
		break
		;;
	n|N )
		break
		;;
	* )
		echo
		echo "Invalid try again!"
		echo
		;;
esac
done

echo

while read -p "Do you want to build AOSP G965 kernel (y/n)? " dchoice
do
case "$dchoice" in
	y|Y)
		make_star2_aosp_kernel
		break
		;;
	n|N )
		break
		;;
	* )
		echo
		echo "Invalid try again!"
		echo
		;;
esac
done

echo

while read -p "Do you want to clean stuffs (y/n)? " cchoice
do
case "$cchoice" in
	y|Y )
		clean_all
		echo
		echo "All Cleaned now."
		break
		;;
	n|N )
		break
		;;
	* )
		echo
		echo "Invalid try again!"
		echo
		;;
esac
done

echo

while read -p "Do you want to build AOSP G960 kernel (y/n)? " dchoice
do
case "$dchoice" in
	y|Y)
		make_star_aosp_kernel
		break
		;;
	n|N )
		break
		;;
	* )
		echo
		echo "Invalid try again!"
		echo
		;;
esac
done

echo

while read -p "Do you want to clean stuffs (y/n)? " cchoice
do
case "$cchoice" in
	y|Y )
		clean_all
		echo
		echo "All Cleaned now."
		break
		;;
	n|N )
		break
		;;
	* )
		echo
		echo "Invalid try again!"
		echo
		;;
esac
done

echo

while read -p "Do you want to build AOSP N960 kernel (y/n)? " dchoice
do
case "$dchoice" in
	y|Y)
		make_crown_aosp_kernel
		break
		;;
	n|N )
		break
		;;
	* )
		echo
		echo "Invalid try again!"
		echo
		;;
esac
done

echo

while read -p "Do you want to zip kernel (y/n)? " dchoice
do
case "$dchoice" in
	y|Y)
		make_aosp_zip
		break
		;;
	n|N )
		break
		;;
	* )
		echo
		echo "Invalid try again!"
		echo
		;;
esac
done

echo -e "${green}"
echo "-------------------"
echo "Build Completed in:"
echo "-------------------"
echo -e "${restore}"

DATE_END=$(date +"%s")
DIFF=$(($DATE_END - $DATE_START))
echo "Time: $(($DIFF / 60)) minute(s) and $(($DIFF % 60)) seconds."
echo

