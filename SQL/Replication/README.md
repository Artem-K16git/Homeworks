# Репликация и масштабирование. Часть 1 - Капитонов Артем Александрович





---

### Задание 1.  
На лекции рассматривались режимы репликации master-slave, master-master, опишите их различия.  
Ответить в свободной форме.  
#### Ответ: 
Master-slave. В данном режиме есть основной сервер(мастер), на котором проиходят все изменеия данных(запись).  
И есть другие(slave), которые все данные копируют с мастер-сервера и работают только на запросы на чтение. 
При выходе мастера из строя, его место занимает один из slave-серверов и становится мастером.  
Master-master. Все сервера равнозначны и работают как на чтение , так и на запись.  


 

---

### Задание 2.   
Выполните конфигурацию master-slave репликации, примером можно пользоваться из лекции.  
Приложите скриншоты конфигурации, выполнения работы: состояния и режимы работы серверов.  
#### Ответ:  
Docker compose файл:
https://github.com/Artem-K16git/Homeworks/blob/main/SQL/Replication/docker-compose.yml  
show master status и show slave\G:  
![3.1](https://github.com/Artem-K16git/Homeworks/blob/main/SQL/Replication/images/L3_1.png)

Если вручную, без docker compose.  
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







