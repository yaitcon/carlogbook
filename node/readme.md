-- node js installation   

yum upgrade
yum install nodejs rpm
npm cache clean -f
npm update npm -g
npm audit fix
npm audit fix --force
npm i --package-lock-only
npm audit fix --force
npm update npm -g
npm fund
npm install -g n


mkdir carlogbook
npm install bluelinky
npm update
npm fund
npm audit
npm install oracledb
npm install pm2 -g

-- starte node im background und garantiere startup bei einem system reboot (pm2)
pm2 start carcommunication.js
pm2 save

oracle vorrausetzung für zugang
yum install oracle-instantclient-release-el7
yum install oracle-instantclient-basic
yum install oracle-instantclient-sqlplus
yum install oracle-instantclient-tools
export PATH=/usr/lib/oracle/21/client64/bin:$PATH

oracle db export + sqlplus
damit die OCI Linux instance überhaupt zur Oracle Cloud DB  kommt
muss man das wallet auf der linux instance vom OCI runterladen auf den Linux server entpacken und verlinken
dann sollte sqplus und eigentlich auch expdp gehen

ging leider nicht .. mit job doesnt exists abgebrochen:
expdp admin@kiadb tables=ENIRO  dumpfile=test.dmp  encryption_pwd_prompt=yes logfile=export.log  directory=data_pump_dir  EXCLUDE=statistics,index
