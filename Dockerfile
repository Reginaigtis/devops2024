# Указываем базовый образ для Nginx
FROM nginx:latest

# Автор образа
MAINTAINER regigtism@gmail.com

# Установка PostgreSQL из официального образа
RUN apt-get update && apt-get install -y postgresql

# Копируем конфигурационные файлы nginx
COPY nginx.conf C:/Users/regin

# Создание рабочей директории для Nginx
WORKDIR /usr/share/nginx/html

# Переменные среды для PostgreSQL
ENV POSTGRES_USER=$(POSTGRES_USER)
ENV POSTGRES_PASSWORD=$(POSTGRES_PASSWORD)

# Добавление файлов в веб-проект (замените index.html на ваш проект)
ADD index.html /usr/share/nginx/html/index.html

# Создание точки монтирования для данных PostgreSQL
VOLUME /var/lib/postgresql/data

# Открываем порт 80 для веб-сервера nginx
EXPOSE 80

# Открываем порт 5432 для PostgreSQL
EXPOSE 5432

USER root

# Запускаем nginx при старте контейнера
CMD ["nginx", "-g", "daemon off;"]
