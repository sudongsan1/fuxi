### **初次安装git配置用户名和邮箱**

```shell
git config --global user.name "superGG1990"

git config --global user.email "superGG1990@163.com"

git config --list 查看所有配置信息

git config user.name 查看某个配置信息

git init 把某个目录变成可以让git管理到的目录（创建版本库）
```

### **git基本命令**

```shell
#把内容输入到一个文件

echo "xxxx" > xxxx 

#把工作空间的某个文件添加到cache

git add  xxxx

#把工作空间的所有内容添加到cache

git add -A

#把cache当中的某个文件提交到本地库

git commit -m "xxxx"

#all

git commit -am "xxxx"

#cache ---->work file恢复一个文件  file1 file2 恢复两个文件  .恢复所有文件

git checkout readme.txt 

#git状态查询

git status

#查看不同的地方 默认查看工作区和cache

#git diff --cached   比较cache和Repository

#git diff HEAD 工作区和最新的Resository

#git diff commit-id 工作区和制定的repository

#git diff --cached commit-id

#git diff --commit-id commit-id

git diff 

#reset 顾名思义   （HEAD~100）

git reset HEAD^

#git的日志

git log git log --pretty=oneline

#oh my pretty pretty boy i love you 

git reflog  查看历史命令

#git rm --cached file_path

git rm 

git mv

#远程仓库的克隆岛本地库

git clone

#关联远程仓库

git remote add

#推送到远程仓库

git push

#拉取远程仓库的内容

git pull

#查看当前分支 -a查看所有分支 -av 查看所有分支的信息 -avv 查看所有分支的信息和关系

git branch

#创建一个分支 基于当前分支创建分支

git branch  xxx

#基于oldType创建分支

git branch newBranch oldType

#切换分支

git checkout 分支的名字

#删除分支

git branch -d   xxx

#查看文件内容

git cat-file -p  commitid

#查看对象类型 blob commit tree

git cat-file -t commitid
```

### github

```shell
ssh-keygen -t rsa -C "email"    //public key for push

git remote add nickName gitUrl    // conn remote**

git push -u remoteBranch localBranch
```

