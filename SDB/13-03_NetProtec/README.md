# Защита сети - Капитонов Артем Александрович  



### Подготовка к выполнению заданий 

Подготовка защищаемой системы:  
установите Suricata,  
установите Fail2Ban.  
Подготовка системы злоумышленника: установите nmap и thc-hydra либо скачайте и установите Kali linux.  
Обе системы должны находится в одной подсети.  

---  
### Задание 1
Проведите разведку системы и определите, какие сетевые службы запущены на защищаемой системе:  
- sudo nmap -sA < ip-адрес >  
- sudo nmap -sT < ip-адрес >  
- sudo nmap -sS < ip-адрес >  
- sudo nmap -sV < ip-адрес >  
По желанию можете поэкспериментировать с опциями: https://nmap.org/man/ru/man-briefoptions.html.  
В качестве ответа пришлите события, которые попали в логи Suricata и Fail2Ban, прокомментируйте результат.
#### Ответ:  
При стандартных правилах Suricata сканирование -sA(видимо потому что данный тип сканирования не "стучится" в порты) не фиксируется,
 а -sT,-sS,-sV фиксируются.  
 ##### nmap -sA и -sT:  
 ![nmap_sA_sT](https://github.com/Artem-K16git/Homeworks/blob/main/SDB/images/nmap_sA_sT.png)  
##### tail -sT:  
 ![tail_sT](https://github.com/Artem-K16git/Homeworks/blob/main/SDB/images/tail_sT.png)
 ##### nmap -sS и -sV  
 ![nmap_sS_sV](https://github.com/Artem-K16git/Homeworks/blob/main/SDB/images/nmap_sS_sV.png)  
 ##### tail -sS:
 ![L1_2](https://github.com/Artem-K16git/Homeworks/blob/main/SDB/images/tail_sS.png)
 ##### tail -sV:
 ![](https://github.com/Artem-K16git/Homeworks/blob/main/SDB/images/tail_sV.png)
 


---

### Задание 2.   
Проведите атаку на подбор пароля для службы SSH:

hydra -L users.txt -P pass.txt < ip-адрес > ssh

Настройка hydra:
- создайте два файла: users.txt и pass.txt;
- в каждой строчке первого файла должны быть имена пользователей, второго — пароли. В нашем случае это могут быть случайные строки, но ради эксперимента можете добавить имя и пароль существующего пользователя.
Дополнительная информация по hydra: https://kali.tools/?p=1847.

Включение защиты SSH для Fail2Ban:
открыть файл /etc/fail2ban/jail.conf,
найти секцию ssh,
установить enabled в true.  
Дополнительная информация по Fail2Ban:https://putty.org.ru/articles/fail2ban-ssh.html.

В качестве ответа пришлите события, которые попали в логи Suricata и Fail2Ban, прокомментируйте результат.    
#### Ответ:
Добавил в файл, в начало списка, существующие логин и пароли.  
В результате, hydra нашла валидную связку:
 ![L2_1](https://github.com/Artem-K16git/Homeworks/blob/main/SDB/images/gydra_ssh2.png)
 В логах ОС перебор логина и пароля:
 ##### cat /var/log/auth.log
 ![L2_1](https://github.com/Artem-K16git/Homeworks/blob/main/SDB/images/auth_log.png)  
 Тут хост с Кали ловит бан:
 ##### tail -f /var/log/fail2ban.log
  ![L2_1](https://github.com/Artem-K16git/Homeworks/blob/main/SDB/images/f2b_ssh_2.png)



 ---




