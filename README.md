# mikbotam-server

script ini adalah tool untuk mempermudah dalam membuat webserver yang akan digunakan oleh aplikasi mikbotam

Script ini hanya untuk OS ubuntu 16.04

Script ini bisa di jalan kan di rasberry pi + ubuntu server

nginx + php-fpm + mysql

## Step 
```
git clone https://github.com/doko89/mikbotam-server.git
cd mikbotam-server
bash run.sh
```
selanjutnya kalian bisa setup router + bot telegram melalui webui mikbotam 

setelah proses setup diatas sudah selesai, untuk mengaktifkan bot telegram silahkan masuk menggunakan ssh ke server
kemudian jalankan

```
systemctl restart supervisor
```
