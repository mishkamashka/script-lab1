#! /bin/bash

ERROR_PATH="$PWD/error"
ERROR_MSG="Error! Something went wrong"

while true
do
	echo -e	"Вариант #11 \n\t1) Напечатать имя текущего каталога."
	echo -e	"\t2) Сменить текущий каталог"
	echo -e	"\t3) Напечатать содержимое текущего каталога"
	echo -e	"\t4) Создать символьную ссылку на файл"
	echo -e	"\t5) Выполнить введенную команду"
	echo -e	"\t6) Выйти из программы"
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
		read file_name
		echo 'Введите имя ссылки:'
		read link_name
		ln -s "$file_name" "$link_name" 2>>"$ERROR_PATH" || echo $ERROR_MSG 1>&2
		;;
	
		5)
		echo 'Введите команду'
		read command_name
		echo $($command_name 2>>"$ERROR_PATH" || echo $ERROR_MSG 1>&2)
		;;

		6)
		exit 0
	esac
	echo

done

