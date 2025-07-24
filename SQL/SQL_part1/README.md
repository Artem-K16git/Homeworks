# Работа с данными (DDL/DML) - Капитонов Артем Александрович





---

### Задание 1.   
1.1. Поднимите чистый инстанс MySQL версии 8.0+. Можно использовать локальный сервер или контейнер Docker.
1.2. Создайте учётную запись sys_temp.  
1.3. Выполните запрос на получение списка пользователей в базе данных. (скриншот)  
1.4. Дайте все права для пользователя sys_temp.  
1.5. Выполните запрос на получение списка прав для пользователя sys_temp. (скриншот)  
1.6. Переподключитесь к базе данных от имени sys_temp.  
Для смены типа аутентификации с sha2 используйте запрос:  
ALTER USER 'sys_test'@'localhost' IDENTIFIED WITH mysql_native_password BY 'password';  
1.6. По ссылке https://downloads.mysql.com/docs/sakila-db.zip скачайте дамп базы данных.   
1.8. При работе в IDE сформируйте ER-диаграмму получившейся базы данных. При работе в командной строке используйте команду для получения всех таблиц базы данных. (скриншот)  
Результатом работы должны быть скриншоты обозначенных заданий, а также простыня со всеми запросами.  
#### Ответ: 
![L1_1](https://github.com/Artem-K16git/Homeworks/blob/main/SQL/DDL_DML/images/L1_1.png)  

![L1_2](https://github.com/Artem-K16git/Homeworks/blob/main/SQL/DDL_DML/images/L1_2.png)  

![L1_3](https://github.com/Artem-K16git/Homeworks/blob/main/SQL/DDL_DML/images/L1_3.png)  

Код запросов:  
```
CREATE USER 'sys_temp'@'%' IDENTIFIED BY '12345'
SELECT user,host FROM mysql.user
GRANT ALL PRIVILEGES ON *.* TO 'sys_temp'@'%'
SHOW GRANTS FOR 'sys_temp'@'%';
```  


 

---

### Задание 2.   
Составьте таблицу, используя любой текстовый редактор или Excel, в которой должно быть два столбца: в первом должны быть названия таблиц восстановленной базы, во втором названия первичных ключей этих таблиц.
#### Ответ:  
![L2_1](https://github.com/Artem-K16git/Homeworks/blob/main/SQL/DDL_DML/images/L2_1.png)   
![L2_2](https://github.com/Artem-K16git/Homeworks/blob/main/SQL/DDL_DML/images/L2_2.png)  

---


### Задание 3*    
3.1. Уберите у пользователя sys_temp права на внесение, изменение и удаление данных из базы sakila.  
3.2. Выполните запрос на получение списка прав для пользователя sys_temp. (скриншот)  
Результатом работы должны быть скриншоты обозначенных заданий, а также простыня со всеми запросами.  
#### Ответ:  
![L3](https://github.com/Artem-K16git/Homeworks/blob/main/SQL/DDL_DML/images/L3.png) 

Код запросов:  
```
REVOKE ALL PRIVILEGES ON *.* FROM 'sys_temp'@'%'
FLUSH PRIVILEGES;
GRANT ALL PRIVILEGES ON sakila.* TO 'sys_temp'@'%'
FLUSH PRIVILEGES;
REVOKE INSERT,UPDATE,DELETE ON sakila.* FROM 'sys_temp'@'%';
FLUSH PRIVILEGES;
SHOW GRANTS FOR 'sys_temp'@'%';
```

---  


