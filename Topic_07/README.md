# Topic 07 Storage: Storage services & Amazon S3

## Cloud Storage Overview

* Block storage = directly attached FS (NTFS, etc), low latency, DBs
    * AWS EBS
* File storage = traditional Network FS (SMB, NFS, etc)
    * Amazon EFS
    * Amazon FSx 
* Object storage = cloud native apps, not DBs
    * Amazon S3
    * Amazon S3 Glacier

s3://videos-69118/Katzenvideo3.mp4
https://videos-69118.s3.eu-central-1.amazonaws.com/Katzenvideo3.mp4

aws s3 cp s3://videos-69118/Katzenvideo3.mp4 /mnt/c/git/ICA/Katzenvideo.mp4