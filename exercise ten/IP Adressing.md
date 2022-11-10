# EXERCISE TEN.

## Question
Given **193.16.20.35/29** provide the followings: <br> 1. Network IP <br> 2. Number of hosts <br> 3. Range of IP adresses, and <br> 4. Broadcast IP

_You are required to submit all your answers as a markdown file in the folder for this exercise_


## Answer
Given IP **193.16.20.35/29** <br><br> Adress: 193.16.20.35 = 11000001.00010000.00010100.00100011 <br><br>Netmask: 255.255.255.248 = 29 (1111111.1111111.11111111.11111000) <br><br> Wildcard: 0.0.0.7 = 00000000.00000000.00000000.00000111 <br><br> Network: 193.16.20.32/29  (11000001.00010000.00010100.00100000) <br><br> Broadcast: 193.16.20.39  (11000001.00010000.00010100.00100111)<br><br>HostMin: 193.16.20.33 (11000001.00010000.00010100.00100001)<br><br>HostMax: 193.16.20.38 (11000001.00010000.00010100.00100110)<br><br>


From the above computations, the :<br>
* Network IP is **_193.16.20.32_** <br> 
* Number of hosts is **_6_** <br>
* Range of IP adressses is **_193.16.20.33_** to **_193.16.20.38_** <br>
* Broadcast IP is **_193.16.20.39_**