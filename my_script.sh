#!/bin/bash

# Функция для записи лога
log() {
    local log_file="script_log.txt"
    echo "$(date '+%Y-%m-%d %H:%M:%S') $1" | tee -a "$log_file"
}
# Проверка наличия ключа '-d' и определение корневого каталога
if [[ "$1" == "-d" ]]; then
    root_dir="$2"
    log "Указан корневой каталог: $root_dir"
else
    read -p "Введите путь до корневого каталога: " root_dir
    log "Корневой каталог: $root_dir"
fi

users=$(getent passwd | cut -d: -f1)

## Создание директории для каждого пользователя
for user in $users; do
    if id "$user" >/dev/null 2>&1; then
        user_dir="$root_dir/$user"
        mkdir -p -m 755 "$user_dir" && chown "$user" "$user_dir"
        log "Создана директория для пользователя $user: $user_dir"
        permissions=$(ls -ld "$user_dir")
        log "Права доступа для директории: $permissions"
    fi
done

log "Скрипт выполнен"
