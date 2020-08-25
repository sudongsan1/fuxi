#!/usr/bin/env sh
if test -e extra.txt
then `rm -rf extra.txt`
fi

fileA=$1
fileB=$2
md5A="${fileA}.md5"
md5B="${fileB}.md5"

if test -e $md5A
then `rm -rf $md5A`
fi

if test -e $md5B
then `rm -rf $md5B`
fi

linesA=`cat $fileA | wc -l`
linesB=`cat $fileB | wc -l`
#行数相同
if [ $linesA == $linesB ]
then
  #GenMd5 -g $fileA
  #GenMd5 -g $fileB
  #md5B="${fileB}.md5"
  diff $md5A $md5B
  if [ $? != 0 ]
  then
    echo "行数相同，文件内容不同"
  else
    echo "行数相同，文件内容相同"
  fi
#fileA比fileB行数多 
elif [ $linesA -gt $linesB ]
then
  nums=`expr $linesA - $linesB`
  echo "${fileA}文件比${fileB}文件多${nums}行"
  echo "删除${fileA}的倒数${nums}行"
  int=1
  while(( $int<=$nums ))
  do
    tail $fileA -n 1 >> extra.txt
    sed -i '$d' ${fileA}
    #tac ${fileA}|sed '$d'|tac >newfile
    let "int++"
  done
 # GenMd5 -g $fileA
 # GenMd5 -g $fileB
  #md5B="${fileB}.md5"
  diff $md5A $md5B
  if [ $? != 0 ]
  then
    echo "行数不同，文件内容不同"
  else
    echo "行数不同，文件内容相同"
  fi
#fileA比fileB行数少
elif [ $linesA -lt $linesB ]
then
  nums=`expr $linesB - $linesA`
  echo "${fileB}文件比${fileA}文件多${nums}行"
  echo "删除${fileB}的倒数${nums}行"
  int=1
  while(( $int<=$nums ))
  do
    tail $fileB -n 1 >> extra.txt
    sed -i '$d' ${fileB}
    #tac ${fileA}|sed '$d'|tac >newfile
    let "int++"
  done
 # GenMd5 -g $fileA
 # GenMd5 -g $fileB
  #md5B="${fileB}.md5"
  diff $md5A $md5B
  if [ $? != 0 ]
  then
    echo "行数不同，文件内容不同"
  else
    echo "行数不同，文件内容相同"
  fi
fi
