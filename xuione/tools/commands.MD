Certainly! Here's a cleaned-up version of the instructions in Markdown format:

```markdown
# XUI.ONE Panel Management

## Panel Control Commands

-  **Stop XUI.ONE Panel:**
  ```bash
  /home/xui/service stop
  ```

-  **Start XUI.ONE Panel:**
  ```bash
  /home/xui/service start
  ```

-  **Refresh Database:**
  ```bash
  /home/xui/status
  ```

-  **List of Tools:**
  ```bash
  /home/xui/tools
  ```

-  **Create Rescue "Access Code":**
  ```bash
  /home/xui/tools rescue
  ```

-  **Create Rescue "Admin User":**
  ```bash
  /home/xui/tools user
  ```

-  **Reauthorize Loadbalancers on MySQL:**
  ```bash
  /home/xui/tools mysql
  ```

-  **Restore a Blank Database:**
  ```bash
  /home/xui/tools database
  ```

-  **Clear Migration Database:**
  ```bash
  /home/xui/tools migration
  ```

-  **Flush All Blocked IPs:**
  ```bash
  /home/xui/tools flush
  ```

-  **Regenerate Ports from MySQL:**
  ```bash
  /home/xui/tools ports
  ```

-  **Regenerate Access Code from MySQL:**
  ```bash
  /home/xui/tools access
  ```

## Backup & Restore

-  **Quick Generate Complete Backup:**
  ```bash
  mysqldump -u root xui > xuiLT-backup.sql
  ```

-  **Restore Selected Backup to XUI Database:**
  ```bash
  mysql -u root xui < path/to/backup/file.sql
  ```

## Migration Process

1. First, restore SQL file to migration database with the following command:
   ```bash
   mysql xui_migrate < /root/old-db.sql
   ```

2. Start the migration process for XUI database via the panel or manually:
   - **On Shell:**
     ```bash
     /home/xui/bin/php/bin/php /home/xui/includes/cli/migrate.php
     ```

   - **On Browser:**  
     Visit: `http://host.com:port/accesscode/setup`

3. If something goes wrong, restore a blank XUI database and restart the process:
   ```bash
   mysql xui < /home/xui/bin/install/database.sql
   ```

## Admin User Reset

-  **Reset Admin User and Password to `admin:admin`:**
  ```bash
  mysql
  ```
  ```sql
  USE `xui`;
  REPLACE INTO `users`(`id`, `username`, `password`, `member_group_id`, `status`, `owner_id`, `date_registered`) VALUES(1, 'admin', '$6$rounds=20000$xui$eQfRsD2gsIUhoY5RnnYN82qiB5VeZTcHICQrFxXpa98J2R1454b6lzVHVjiJ.NP0gi0X3K7NXVgxeR1VhVhg61', 1, 1, 0, UNIX_TIMESTAMP());
  ```

## License Error Fix

-  **Check License Status:**
  ```bash
  /home/xui/status
  ```

## Removal of Old Panels

To remove old panels and ensure a clean installation for XUI:

### Uninstall Xtream UI (Xtream Codes):

1. Stop and remove MySQL:
   ```bash
   sudo systemctl stop mysql.service
   sudo apt purge mysql-server mysql-client mysql-common mysql-server-core-* mysql-client-core-* -y
   sudo rm -rf /etc/mysql /var/lib/mysql /var/log/mysql
   sudo apt autoremove -y
   sudo apt autoclean -y
   ```

2. Remove Xtream UI components:
   ```bash
   sudo pkill -u xtreamcodes
   sudo kill $(ps aux | grep '[p]hp' | awk '{print $2}')
   sudo kill $(ps aux | grep '[n]ginx' | awk '{print $2}')
   sudo chattr -i /home/xtreamcodes/iptv_xtream_codes/GeoLite2.mmdb
   sudo rm -rf /home/xtreamcodes/iptv_xtream_codes/tmp/*
   sudo rm -rf /home/xtreamcodes/iptv_xtream_codes/streams/*
   sudo umount -f /home/xtreamcodes/iptv_xtream_codes/streams
   sudo umount -f /home/xtreamcodes/iptv_xtream_codes/tmp
   sudo sed -i '/xtreamcodes/d' /etc/fstab
   sudo sed -i '/xtreamcodes/d' /etc/crontab
   sudo sed -i '/xtreamcodes/d' /etc/sudoers
   sudo deluser xtreamcodes
   sudo groupdel xtreamcodes
   sudo chown root:root -R /home/xtreamcodes
   sudo chmod -R 0644 /home/xtreamcodes
   sudo rm /var/lib/dpkg/lock-frontend /var/cache/apt/archives/lock /var/lib/dpkg/lock
   sudo apt-get remove libcurl3 -y
   ```

### Remove StreamCreed Panel:

1. Stop and purge MariaDB:
   ```bash
   sudo systemctl stop mariadb.service
   sudo apt-get purge mariadb-server -y
   sudo rm -rf /etc/mysql /var/lib/mysql /var/log/mysql
   sudo apt autoremove -y
   sudo apt autoclean -y
   ```

2. Remove all related content:
   ```bash
   sudo pkill -u streamcreed
   sudo kill $(ps aux | grep '[p]hp' | awk '{print $2}')
   sudo kill $(ps aux | grep '[n]ginx' | awk '{print $2}')
   sudo rm -rf /home/streamcreed/tmp/*
   sudo rm -rf /home/streamcreed/streams/*
   sudo umount -f /home/streamcreed/streams
   sudo umount -f /home/streamcreed/tmp
   sudo sed -i '/streamcreed/d' /etc/fstab
   sudo sed -i '/streamcreed/d' /etc/crontab
   sudo sed -i '/streamcreed/d' /etc/sudoers
   sudo deluser streamcreed
   sudo groupdel streamcreed
   sudo chown root:root -R /home/streamcreed
   sudo chmod -R 0644 /home/streamcreed
   ```


---

For more details, check the article: [Installing XUI.ONE](https://lofertech.com/install-xui-one/)
