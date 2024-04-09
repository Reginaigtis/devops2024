#!/bin/bash

# Функция для записи лога
log() {
    local log_file="script_log.txt"
    echo "$(date '+%Y-%m-%d %H:%M:%S') $1" | tee -a "$log_file"
}

## Проверка наличия ключа '-d'
if [[ "$1" == "-d" ]]; then
    root_dir="$2"
    log "Указан корневой каталог: $root_dir"
else
    read -p "Введите путь до корневого каталога: " root_dir
    log "Корневой каталог: $root_dir"
fi

users=$(powershell -Command "Get-LocalUser | Select-Object -ExpandProperty Name")
groups=$(powershell -Command "Get-LocalGroup | Select-Object -ExpandProperty Name")

users=$(echo "$users" | tr -d '\r')
groups=$(echo "$groups" | tr -d '\r')

# Создание директории для каждого пользователя
for user in $users; do
    if id "$user" >/dev/null 2>&1; then
        user_dir="$root_dir/$user"
        mkdir -p "$user_dir" && chmod 755 "$user_dir" && chown "$user" "$user_dir"
        log "Создана директория для пользователя $user: $user_dir"
    else
        log "Ошибка: Пользователь $user не существует в системе."
    fi
done

log "Скрипт выполнен"
