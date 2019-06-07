#! /bin/bash

ERROR_PATH="$HOME/lab1_err"
ERROR_MSG="Something went wrong. Check your input."

list_r_users() {
	dir=$1;
        if [[(! -d "$dir")]]
                then
                        echo "$dir is not a directory"
                else
                        rights=`ls -l | grep $dir | awk '{print $1}'`;
                        owner=`ls -l | grep $dir | awk '{print $3}'`;
                        group=`ls -l | grep $dir | awk '{print $4}'`;  
                        if [[(${rights:1:1} = r)]]
                        then
                                echo $owner;
                        fi
                        if [[(${rights:4:1} = r)]]
                        then
                                for user in `getent passwd`
                                do
                                        username=`echo $user | awk -F: '{print $1}'`
                                        usergroup=`groups $username 2>$ERROR_PATH | grep -w $group`
                                        if [[ -n $usergroup && -z `echo $username | grep -w $owner` ]]
                                        then
                                                echo $username
                                        fi
                                done
                        fi
                        if [[(${rights:7:1} = r)]]
                        then
                                for user in `getent passwd | tr ' ' '_'`
                                do
                                        username=`echo $user | awk -F: '{print $1}'`
                                        usergroup=`groups $username | grep -w $group`
                                        if [[ -z $usergroup && -z `echo $username | grep -w $owner` ]]
                                        then
                                                echo $username
                                        fi
                                done
                        fi
        fi
        return;
}

list_w_users() {
	dir=$1;
        if [[(! -d "$dir")]]
                then
                        echo "$dir is not a directory">$2
                else
                        rights=`ls -l | grep $dir | awk '{print $1}'`;
                        owner=`ls -l | grep $dir | awk '{print $3}'`;
                        group=`ls -l | grep $dir | awk '{print $4}'`;  
                        if [[(${rights:2:1} = w)]]
                        then
                                echo $owner;
                        fi
                        if [[(${rights:5:1} = w)]]
                        then
                                for user in `getent passwd`
                                do
                                        username=`echo $user | awk -F: '{print $1}'`
                                        usergroup=`groups $username 2>>$ERROR_PATH | grep -w $group`
                                        if [[ -n $usergroup && -z `echo $username | grep -w $owner` ]]
                                        then
                                                echo $username
                                        fi
                                done
                        fi
                        if [[(${rights:8:1} = w)]]
                        then
                                for user in `getent passwd | tr ' ' '_'`
                                do
                                        username=`echo $user | awk -F: '{print $1}'`
                                        usergroup=`groups $username 2>>$ERROR_PATH | grep -w $group`
                                        if [[ -z $usergroup && -z `echo $username | grep -w $owner` ]]
                                        then
                                                echo $username
                                        fi
                                done
                        fi
        fi
        return;
}

while true
do
	echo -e	"Вариант #11 \n\t1) Напечатать имя текущего каталога."
	echo -e	"\t2) Сменить текущий каталог"
	echo -e	"\t3) Напечатать содержимое текущего каталога"
	echo -e	"\t4) Создать символьную ссылку на файл"
	echo -e	"\t5) Выполнить введенную команду"
	echo -e	"\t6) Выйти из программы"
	echo -e	"\t7) Вывести пользователей с доступом к текущему каталогу"
	echo -e	"Введите номер действия:"
	read number
	echo

	case "$number" in
		1)
		echo -n "Текущий каталог: "
		pwd 2>>"$ERROR_PATH" || echo $ERROR_MSG 1>$2
		;;
		
		2)
		echo 'Введите путь к нужному каталогу:'
		read path
		cd "$path" 2>>"$ERROR_PATH" || echo $ERROR_MSG 1>$2
		;;

		3)
		echo "Содержимое текущего каталога:"
		ls 2>>"$ERROR_PATH" || echo $ERROR_MSG 1>$2
		;;

		4)
		echo 'Введите путь к файлу, для которого нужно создать ссылку:'
		read name
		echo 'Введите имя ссылки:'
		read link_name
		ln -s "$name" "$link_name" 2>>"$ERROR_PATH" || echo $ERROR_MSG 1>&2
		;;
	
		5)
		echo 'Введите команду:'
		read command_name
		eval $command_name
		#echo $($command_name 2>>"$ERROR_PATH" || echo $ERROR_MSG 1>&2)
		;;

		6)
		exit 0
		;;

		7)
		echo 'Введите имя каталога:'
		read dir
		echo -e "\nПользователи, которые имеют права на чтение:"
		list_r_users $dir
		echo -e "\nПользователи, которые имеют права на запись:"
		list_w_users $dir
		;;
	esac
	echo

done

