# Система мониторинга Zabbix - Капитонов Артем Александрович





---

### Задание 1

1. 
wget https://repo.zabbix.com/zabbix/7.2/release/debian/pool/main/z/zabbix-release/zabbix-release_latest_7.2+debian12_all.deb
dpkg -i zabbix-release_latest_7.2+debian12_all.deb
apt update

apt install zabbix-server-pgsql zabbix-frontend-php php8.2-pgsql zabbix-apache-conf zabbix-sql-scripts zabbix-agent

sudo -u postgres createuser --pwprompt zabbix
sudo -u postgres createdb -O zabbix zabbix 

nano /etc/zabbix/zabbix_server.conf
DBPassword=password 

systemctl restart zabbix-server zabbix-agent apache2
systemctl enable zabbix-server zabbix-agent apache2

2.
Скриншоты:
![Скриншот1](https://github.com/Artem-K16git/Homeworks/blob/main/img/Auth_zabbix1.png)
![Скриншот2](https://github.com/Artem-K16git/Homeworks/blob/main/img/Auth_zabbix2.png)

---

### Задание 2

1. ![1](https://github.com/Artem-K16git/Homeworks/blob/main/img/Conf_hosts.png)
2. ![2](https://github.com/Artem-K16git/Homeworks/blob/main/img/zabbix_agent_logs1.png)
   ![3](https://github.com/Artem-K16git/Homeworks/blob/main/img/zabbix_agent_logs2.png)
3. ![4](https://github.com/Artem-K16git/Homeworks/blob/main/img/zabbix_agent_logs3.png)
4.  
wget https://repo.zabbix.com/zabbix/7.2/release/ubuntu/pool/main/z/zabbix-release/zabbix-release_latest_7.2+ubuntu24.04_all.deb
dpkg -i zabbix-release_latest_7.2+ubuntu24.04_all.deb
apt update

apt install zabbix-agent

systemctl restart zabbix-agent
systemctl enable zabbix-agent  


---

### Задание 3

1. ![1](https://github.com/Artem-K16git/Homeworks/blob/main/img/Win110_free_space.png)



Задание 4

`Приведите ответ в свободной форме........`

1. `Заполните здесь этапы выполнения, если требуется ....`
2. `Заполните здесь этапы выполнения, если требуется ....`
3. `Заполните здесь этапы выполнения, если требуется ....`
4. `Заполните здесь этапы выполнения, если требуется ....`
5. `Заполните здесь этапы выполнения, если требуется ....`
6. 

```
Поле для вставки кода...
....
....
....
....
```

`При необходимости прикрепитe сюда скриншоты
![Название скриншота](ссылка на скриншот)`
