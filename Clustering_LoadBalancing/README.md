# Кластеризация и балансировка нагрузки - Капитонов Артем Александрович





---

### Задание 1

Запустите два simple python сервера на своей виртуальной машине на разных портах  
Установите и настройте HAProxy, воспользуйтесь материалами к лекции по ссылке  
Настройте балансировку Round-robin на 4 уровне.  
На проверку направьте конфигурационный файл haproxy, скриншоты, где видно перенаправление запросов на разные серверы при обращении к HAProxy.  
Ответ:  
![Скриншот1](https://github.com/Artem-K16git/Homeworks/blob/main/Clustering_LoadBalancing/imgs_fs/RoundrobinTCP.png)  
Конфиг-файл:  https://github.com/Artem-K16git/Homeworks/blob/main/Clustering_LoadBalancing/imgs_fs/Lesson1_haproxy.cfg  


---

### Задание 2

Запустите три simple python сервера на своей виртуальной машине на разных портах  
Настройте балансировку Weighted Round Robin на 7 уровне, чтобы первый сервер имел вес 2, второй - 3, а третий - 4  
HAproxy должен балансировать только тот http-трафик, который адресован домену example.local  
На проверку направьте конфигурационный файл haproxy, скриншоты, где видно перенаправление запросов на разные серверы при обращении к HAProxy c использованием домена example.local и без него.   
Ответ:  
![Screenshot2](https://github.com/Artem-K16git/Homeworks/blob/main/Clustering_LoadBalancing/imgs_fs/WRR_7L.png)  
Конфиг-файл: https://github.com/Artem-K16git/Homeworks/blob/main/Clustering_LoadBalancing/imgs_fs/Lesson2_haproxy.cfg

---


### Задание 4

Запустите 4 simple python сервера на разных портах.  
Первые два сервера будут выдавать страницу index.html вашего сайта example1.local (в файле index.html напишите example1.local)  
Вторые два сервера будут выдавать страницу index.html вашего сайта example2.local (в файле index.html напишите example2.local)  
Настройте два бэкенда HAProxy
Настройте фронтенд HAProxy так, чтобы в зависимости от запрашиваемого сайта example1.local или example2.local запросы перенаправлялись на разные бэкенды HAProxy  
На проверку направьте конфигурационный файл HAProxy, скриншоты, демонстрирующие запросы к разным фронтендам и ответам от разных бэкендов.  
Ответ:  
Python-серверы запущены по порядку(на скриншоте), слева направо 1,2,3,4.  
![L4_1](https://github.com/Artem-K16git/Homeworks/blob/main/Clustering_LoadBalancing/imgs_fs/L4_3.png)

Ссылка на конф-файл:  
[L4_haproxy.cfg](https://github.com/Artem-K16git/Homeworks/blob/main/Clustering_LoadBalancing/imgs_fs/L4_haproxy.cfg)

```
Поле для вставки кода...
....
....
....
....
```

`При необходимости прикрепитe сюда скриншоты
![Название скриншота](ссылка на скриншот)`
