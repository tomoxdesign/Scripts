This is the proposed structure for the UTILITY repository, organizing scripts by platform and purpose.


Scripts/                 
├─ README.md             
├─ windows/              
│  ├─ network/           
│  │  ├─ ping_sweep.ps1
│  │  └─ port_scan.ps1
│  └─ database/          
│     ├─ delete_rows_mysql.ps1
│     └─ backup_db.ps1
├─ linux/                
│  ├─ network/           
│  │  ├─ ping_sweep.sh
│  │  └─ port_scan.sh
│  └─ database/          
│     ├─ delete_rows_mysql.sh
│     └─ backup_db.sh
