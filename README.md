# JModelica
JModelica is a software platform based on the Modelica modeling language for modeling, simulating, optimizing and analyzing complex dynamic systems.
This Repository is forked from JModelica/JModelica and make some changes to make it run.

# JModelica修改版
这个版本是基于JModelica/Jmodelica仓库修改，使她能够运行起来，修改了不少文件，升级了三方库，增加了Linux 安装步骤脚本，Windows编译步骤脚本，以及编译器工作优化步骤说明与解释。

## 1.优化器方法论
- 别名消除
- 形式转换
- - 非因果转因果
- - 矩阵下三角变换
- 分支预测
  
高斯赛德尔迭代，雅克比矩阵Jacobian， 撕裂变量，迭代变量，牛顿迭代，撕裂代数环方程组

### 1.2 项目环境变量注意事项
1. EnvironmentUtils 104 lines
SUNDIALS_HOME : D:\Program_Files\JModelica.org-2.14\install\ThirdParty\Sundials
JMODELICA_HOME : D:\Program_Files\JModelica.org-2.14\install
2. GccCompileDelegator 111 lines| 75 lines
MINGW_HOME : D:\Program_Files\JModelica.org-2.14\MinGW

3. MinGW需要安装组件
mingw32-base\mingw32-binutils\mingw32-gcc\mingw32-gcc-g++\mingw-gdb

## 2.Jmodelica编译方法
- 参考安装文档：https://gitlab.com/christiankral/install_jmodelica/blob/master/install_jmodelica.sh
- 项目地址：https://github.com/JModelica/JModelica.git
### 主要安装步骤
``` bash
../configure --prefix=/home/mjy/work2/JModelica --with-ipopt=/home/mjy/work2/Ipopt
make
make install
```
### 异常修复
1. 手动创建JModelica/ThirdParty/SuperLU/superlu_mt_3.1/lib 目录
2. 修改ThirdParty/CasADi/CasAdi/swig/typemaphelpers.i文件中的 PySetParent方法调用的形参，将 obj0 修改为 swig_obj[0]
3. 修改get_version.sh， 删除其他内容，修改为 echo "2.14"

### 语法修复
1. check报错-修改OptimicaFrontEnd/src/parser/Optimica.flex文件280行constraint/optimization删除
2. PackMaterial 报错-Animation属于动画可视化部分，暂时删除equation
3. Error in flattened model: Index reduction failed: There were unmatched equations and/or variables left after index reduction.The system is structurally singular. The following variable(s) could not be matched to any equation:
可能是protected引起的， 由于ModelicaService里面新增了一些属性

### 优化器目前依然存在的问题
1. 指数削减过程问题，部分变量未处理成功报错
2. MWorks标准库与OpenModelica标准库不一致，导致基于MWorks开发的模型在标准库下编译有问题
3. 优化器本身功能缺陷
 -错误有可能发生在平坦化、优化、生成c代码、打包
 -执行顺序问题，constant常量执行顺序异常导致报错
### 优化器优化步骤
符号方程排序和规范化在
以下步骤：
-DAE系统由DAE方程与代数和作为未知数处理的导数被匹配以获得配对在方程和变量之间。离散与连续代数在这方面，变量被同等对待。
-如果找到了完美匹配，即如果没有不匹配的对于方程或变量，应用BLT算法进行计算对应于方程组的斯特伦分量序列。
-计算匹配并将DAE转换为BLT形式后，DAE初始化系统分析如下：
-将微分变量添加到未知变量集中系统变量。
-将前置变量添加到系统
-初始方程被添加到方程组中系统这包括由具有将相应的固定属性设置为true。
-分析When子句：如果When子句由初始（）运算符（无论这意味着什么…），when子句不包括，否则加上方程式pre（x）=x，其中x是在when子句中求解的变量。
-将匹配算法应用于更新后的图形。注意将DAE匹配的结果用作起点非常重要要点：使用这种方法，导数和代数将保持不变如果可能的话进行匹配，如果需要，添加额外的方程式，用于区分变量。如果有的话如果方程不匹配，转换序列终止。如果有是不匹配的变量，后添加额外的初始方程为了得到一个平衡的系统。对于连续变量，添加了x=x.start等方程，而对于离散变量添加了pre（x）=x.start等等式。
-最后，将BLT算法应用于生成的完美图像与DAE初始化系统匹配。
enableIfEquationElimination
消除不必要的if方程；如果一项测试可以确定评估为假或真if或else分支块中的函数可以分别被丢弃或内联。
<p>
取决于在标量化后调用时的MakeReinitedVarsState。
genInitArrayStatements
为未知函数数组生成数组初始化语句。
scalarize
对平面模型中的所有变量和方程进行标度化
MakeReinitedVarsStates
将应用了reinit（）的变量标记为状态的转换（通过设置stateSelect=always）。

### 升级日志
1. ModelicaStandardTable升级到2020/12/22更新版本
2. Assimulo3.0 -> 3.2
3. sundials2.7 -> 6.0
4. JFlex1.4.3 -> 1.8.2
