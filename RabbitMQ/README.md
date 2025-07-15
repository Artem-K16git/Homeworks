# Очереди RAbbitMQ - Капитонов Артем Александрович





---

### Задание 1. Установка RabbitMQ  
Используя Vagrant или VirtualBox, создайте виртуальную машину и установите RabbitMQ. Добавьте management plug-in и зайдите в веб-интерфейс.  
Итогом выполнения домашнего задания будет приложенный скриншот веб-интерфейса RabbitMQ.  
#### Ответ: 
![L1](https://github.com/Artem-K16git/Homeworks/blob/main/RabbitMQ/images/L1.png) 

 

---

### Задание 2.Отправка и получение сообщений  
Используя приложенные скрипты, проведите тестовую отправку и получение сообщения. Для отправки сообщений необходимо запустить скрипт producer.py.  
Для работы скриптов вам необходимо установить Python версии 3 и библиотеку Pika. Также в скриптах нужно указать IP-адрес машины, на которой запущен RabbitMQ, заменив localhost на нужный IP.  
Зайдите в веб-интерфейс, найдите очередь под названием hello и сделайте скриншот. После чего запустите второй скрипт consumer.py и сделайте скриншот результата выполнения скрипта  
В качестве решения домашнего задания приложите оба скриншота, сделанных на этапе выполнения.  
Для закрепления материала можете попробовать модифицировать скрипты, чтобы поменять название очереди и отправляемое сообщение.    
#### Ответ:  
![L2_1](https://github.com/Artem-K16git/Homeworks/blob/main/RabbitMQ/images/L2_1.png)   
![L2_2](https://github.com/Artem-K16git/Homeworks/blob/main/RabbitMQ/images/L2_2.png)  

---


### Задание 3.Подготовка HA кластера  
Используя Vagrant или VirtualBox, создайте вторую виртуальную машину и установите RabbitMQ. Добавьте в файл hosts название и IP-адрес каждой машины, чтобы машины могли видеть друг друга по имени.  
Затем объедините две машины в кластер и создайте политику ha-all на все очереди.  
В качестве решения домашнего задания приложите скриншоты из веб-интерфейса с информацией о доступных нодах в кластере и включённой политикой.  
Также приложите вывод команды с двух нод:  
$ rabbitmqctl cluster_status  
Для закрепления материала снова запустите скрипт producer.py и приложите скриншот выполнения команды на каждой из нод:  
$ rabbitmqadmin get queue='hello'  
После чего попробуйте отключить одну из нод, желательно ту, к которой подключались из скрипта, затем поправьте параметры подключения в скрипте consumer.py на вторую ноду и запустите его.  
Приложите скриншот результата работы второго скрипта.  
#### Ответ:  

![LL3_rabbitmq1](https://github.com/Artem-K16git/Homeworks/blob/main/RabbitMQ/images/L3_rabbitmq1.png)
![L3_rabbitmq3](https://github.com/Artem-K16git/Homeworks/blob/main/RabbitMQ/images/L3_rabbitmq3.png)
![L3_exchanges](https://github.com/Artem-K16git/Homeworks/blob/main/RabbitMQ/images/L3_exchanges.png)  

Выполнение команды 
```rabbitmqadmin get queue='hello'```
![L3_get_queue](https://github.com/Artem-K16git/Homeworks/blob/main/RabbitMQ/images/L3_get_queue.png)  
Выключил 2-ю ноду(172.20.0.4), на которые отправлял сообщения продюсер:  
![L3_2shutdown](https://github.com/Artem-K16git/Homeworks/blob/main/RabbitMQ/images/L3_2shutdown.png)  
Консюмер продолжает получать сообщения от продюсера, несмотря на то, что адресат продюсера выключен:  
![L3_end](https://github.com/Artem-K16git/Homeworks/blob/main/RabbitMQ/images/L3_end.png)



---  


