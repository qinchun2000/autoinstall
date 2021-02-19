set global validate_password_policy=0;
set global validate_password_length=1;
ALTER USER 'root'@'localhost' IDENTIFIED BY '111111'; 
use mysql;
update user set user.Host='%' where user.User='root';
flush privileges;
