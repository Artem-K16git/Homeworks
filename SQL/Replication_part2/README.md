# Репликация и масштабирование. Часть 1 - Капитонов Артем Александрович





---

### Задание 1.  
Опишите основные преимущества использования масштабирования методами:
- активный master-сервер и пассивный репликационный slave-сервер;  
- master-сервер и несколько slave-серверов;  
Дайте ответ в свободной форме.  
#### Ответ: 
Активный master-сервер и репликационный slave-сервер.  
Преимущества:  
- отказоустойчивость. При выходе из строя мастера, slave-сервер может подхватить его роль.  
- горизонтальное масштабирование. Позволяет распределять нагрузку, запросы на чтение будет выполнять slave-сервер.   

Master-сервер и несколько slave-серверов  
Преимущества:  
- отказоустойчивость. Выше чем у предыдущего варианта, так как отсутствует единая точка отказа и может выдержать большее количество отказов узлов;
- повышение производительности системы на операции чтения;  
- возможность тестирования,на slave-серверах;  
- возможность распределения нагрузки по типам запросов.  


 

---

### Задание 2.   
Задание 2
Разработайте план для выполнения горизонтального и вертикального шаринга базы данных. База данных состоит из трёх таблиц:
- пользователи,  
- книги,  
- магазины (столбцы произвольно).  
Опишите принципы построения системы и их разграничение или разбивку между базами данных.  
Пришлите блоксхему, где и что будет располагаться. Опишите, в каких режимах будут работать сервера.  
#### Ответ:  
Разворачивал вручную, без docker compose, поэтому отображу часть применных комманд.  
Запуск контейнеров master и slave:
```
docker run --name mysql-master -p 3306:3306 -e MYSQL_ROOT_PASSWORD=secret -d 57c7595ac65f
docker run --name mysql-slave -p 3307:3306 -e MYSQL_ROOT_PASSWORD=secret -d 57c7595ac65f
```
Редактирование файлов my.cnf и замена их в контейнерах:
```
docker container cp 872999320a3c:/etc/my.cnf con-my.cnf
docker container cp con-my.cnf 872999320a3c:/etc/my.cnf
```
Создание подсети для контейнеров и добавление их:
```
docker network create -d bridge repl-net
docker network connect --allias mysql-slave repl-net
docker network connect --allias mysql-master repl-net
```
show_master_status:
![1](https://github.com/Artem-K16git/Homeworks/blob/main/SQL/Replication/images/show_master_status.png) 
show_slave_status\G:
![2](https://github.com/Artem-K16git/Homeworks/blob/main/SQL/Replication/images/show_slave_status_G.png) 
В DBeavere:  
![3](https://github.com/Artem-K16git/Homeworks/blob/main/SQL/Replication/images/3.png)







