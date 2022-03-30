#!/bin/bash

export ANT_HOME=/c/apache-ant-1.10.12/
export PATH=$ANT_HOME/bin:$PATH
export JAVA_HOME=/C:/Program Files/Java/jdk1.8.0_231
#升级pacman
#32位安装依赖包
pacman -S mingw-w64-i686-toolchain mingw-w64-i686-cmake binutils diffutils git grep make patch pkg-config mingw32/mingw-w64-i686-liblas python-pip mingw-w64-i686-python-numpy mingw-w64-i686-cython mingw-w64-i686-lapack
#64位安装依赖包
pacman -S mingw-w64-x86_64-toolchain mingw-w64-x86_64-lapack mingw-w64-x86_64-metis binutils diffutils git grep make patch pkg-config msys/diffutils

# 修复 get_version
cat > get_version.sh<<EOF
#!/bin/bash
echo "2.14"
EOF

# install Ipopt-ASL
git clone https://github.com/coin-or-tools/ThirdParty-ASL.git
cd ThirdParty-ASL
./get.ASL
./configure
make
make install
cd ../
# install Ipopt-Mumps
git clone https://github.com/coin-or-tools/ThirdParty-Mumps.git
cd ThirdParty-Mumps
./get.Mumps
./configure --with-lapack-lflags="-L/C:/msys64/mingw32/lib -llapack -lblas"
make
make install
cd ../
# install Ipopt
# Fixme 使用的是 Ipopt-stable-3.14.zip文件
git clone https://github.com/coin-or/Ipopt.git
cd Ipopt
mkdir build && cd build
../configure --prefix=/home/Administrator/install/ipopt
make
make install
cd ../../

git clone https://github.com/JModelica/JModelica.git
cd JModelica
# 修复缺陷
#sed -i 's/coin\//coin-or\//g' ../configure
# 修复ipopt 版本差异 coin => coin-or
patch -p0 configure configure.patch
# 修复tar复制目录在windows目录问题, Assimulo python执行setup 增加编译参数-fallow-argument-mismatch, 注释掉build-compiler
patch -p0 Makefile.in Makefile.in.patch

mkdir build && cd build && mkdir -p superlu_build/lib
../configure --prefix=/home/hubei/install/jmodelica --with-ipopt=/home/Administrator/install/ipopt
make
make install


