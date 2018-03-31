#!/bin/bash
sudo
if [ $? -ne 0 ]
then
echo y | apt-get install -y sudo
fi
sudo git --version
if [ $? -ne 0 ]
	then
	sudo apt-get update
	echo y | sudo apt-get install git
	echo "请输入用户名："
	read name
	echo "请输入邮箱："
	read email
	git config --global user.name $name
	git config --global user.email $email
	ssh-keygen -C $email -t rsa -P '' -f ~/.ssh/id_rsa
	rsa_pub=`cat ~/.ssh/id_rsa.pub`
	echo $rsa_pub
	echo "请把上面的密文粘贴到github去"
fi

path="./auto_commit"
file="./auto_commit/time.txt"
if [ ! -x $path ]
then
	mkdir $path
fi
if [ ! -f $file ]
then
	touch $file
fi
cd ./auto_commit
if [ ! -f "./.git" ]
	then
	git init
fi
git pull origin master
date=`date`
cat << EOF > time.txt
$date
EOF
if [ ! -f "./config.json" ]
	then
	touch ./config.json
	echo "请输入github的项目名，如xxx/xxx.git："
	read git
	echo yes | git remote add origin git@github.com:$git
	echo "请输入用户名："
	read name
	echo "请输入邮箱："
	read email
	git config user.name $name
	git config user.email $email
fi
git add .
git commit -m "$date"
git push origin master
