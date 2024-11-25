# Fix : HardDrive Error do not automount anymore

---
- UUID          : 
- Project       : 
- Tags          : fix wiki
- Scope         : private
- Start Date    : 2024-11-25 Fri 17:02:49
- End Date      : 2024-11-25 Fri 18:02:49
- Duration      : 01:00:00
- Status        : ✅
---

## 📃 Resume
- **Pb**    : HardDrive is not automount
- **Sol**   : Don't Try to Solve ntfs partition problem on linux, use windows: when plug, click on `Ask to repare`

## 🚧 Problem
Now when plugg my harddrive on Ubuntu I get:
```bash
Failed to mount "Media-center"
Error mounting /dev/sdb1/ at /media/altergnu/Media-center:
Wrong fstype, bad option, bad superblock on /dev/sdb1, missing codepage or helper program, or other error.
```

## 💡 Approaches/Ideas
### 1. Check file type (fstype)
- It's possible that the filetype is unknown by the system `blkid`: gives the type of content that a block device holds.
```bash
sudo blkid /dev/sdb1
/dev/sdb1: LABEL="Media-center" BLOCK_SIZE="512" UUID="200C5E9444CF4FB9" TYPE="ntfs" PARTUUID="44a7b6fb-01"
```

- Here we can see that our fstype is **ntfs**, now i need to know if the package to use this format are installed:
```bash
sudo apt list | grep ntfs
forensics-samples-ntfs/noble,noble 1.1.4-5 all
libfsntfs-dev/noble 20200921-2.1build1 amd64
libfsntfs-utils/noble 20200921-2.1build1 amd64
libfsntfs1t64/noble 20200921-2.1build1 amd64
libntfs-3g89t64/noble,now 1:2022.10.3-1.2ubuntu3 amd64 [installed,automatic]
ntfs-3g-dev/noble 1:2022.10.3-1.2ubuntu3 amd64
ntfs-3g/noble,now 1:2022.10.3-1.2ubuntu3 amd64 [installed]
ntfs2btrfs/noble 20240115-1 amd64
python3-libfsntfs/noble 20200921-2.1build1 amd64
scrounge-ntfs/noble 0.9-10 amd64
```
- **ntfs-3g package is installed ...to be continued...**

### 2. Check if hard drive's integrity
- It's possible that my file system is corrupt, to repare it i can try `fsck`:check and repare Linux filesystem

```bash
sudo fsck /dev/sdb1
fsck from util-linux 2.39.3
```
- *Warning: make sure that the partition isn't mount.*
- **Unplug and Replug : problem still here ...to be continued...**

### 3. Check log system
- Checking the log system for more details informations `dmesg`: show last kernel log messages.

```bash
dmesg | tail -n 3
[93650.563131] sd 6:0:0:0: [sdb] Attached SCSI disk
[93651.555264] ntfs3: sdb1: It is recommened to use chkdsk.
[93651.638355] ntfs3: sdb1: volume is dirty and "force" flag is not set!
```
- sdb1 is mark as **dirty** and ntfs3 will not mount a partition mark as dirty without the flag **-force**.

#### 3.1 ntfs3 says Dirty things...
- In my kernel log, the cmd `ntfs3` says that my volume (sdb1) is dirty:
    - last time i use it wasn't properly unmount.
    - or it can also means that i had read/write errors.
- Until I fix it, ntfs3 will not mount this volume.

#### 3.2 Fixing dirty volume... ntfsfix
- To repare basics error I can use `ntfsfix` which is part of the *ntfs-3g* package with the `-d` option:
    - `-d`, `--clear-dirty` : Clear the volume dirty flag if the volume can be fixed and mounted.
```bash
sudo ntfsfix /dev/sdb1
Mounting volume... OK
Processing of $MFT and $MFTMirr completed successfully.
Checking the alternate boot sector... OK
NTFS volume version is 3.1.
NTFS partition /dev/sdb1 was processed successfully.
```
- Mount manually the device with `mount` cmd and the option `-t` or `--targe`.
```bash
sudo mkdir /media/altergnu/Media-center && sudo mount -t ntfs3 /dev/sdb1 /media/altergnu/Media-center
```
- *DONT FORGET TO CREATE FOLDER IN MEDIA BEFORE CALLING MOUNT CMD*
- **Can access files in Media-center but when Unmount,Unplug,Replug Same Pb ...to be continued...**

### 4. Go to Windows to repare NTFS...
- When plug windows Ask to repare, click yes .... annnnnnnd it's gone! (Trow the penguin out the Windows)

## ✅ Solution
- When plug windows `Ask to repare`, click yes .... annnnnnnd it's gone! (Trow the penguin out the Windows)

## 🔗 Sources

