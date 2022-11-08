#!/bin/sh


#if [[ $1 ]]; then
#cd `$1`
#else
#
#fi

#cd到shell所在路径
#echo `basename $0`
cd `dirname $0`

#判断Podfile是否存在
if [[ ! -f "Podfile" ]]; then
echo "Podfile文件不存在，请检查路径！！！"
fi

count=0
pod_install(){
    echo "pod install begin..."
    result=`pod install`
    if [[ $result =~ "Error installing" ]]; then
    ((count++))
#    echo ">>>>\n $result"
    echo "第 $count 次pod install失败，继续重试中…… \n<<<<<"
    pod_install
    else
    echo ">>>>\n $result \n<<<<<"
    fi
}
pod_install

