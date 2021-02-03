#!/bin/bash

function on_error_exit() {
    if [ $? -ne 0 ];
    then
        send_msg $@
        exit
    fi
}

function send_msg() {
    msg=""
    for p in $@
    do
        msg=$msg$p" "
    done
    echo $msg
}

function download_file() {
    filename=$1
    send_msg "downloading ${filename}"
    curl -o ${filename} ${down_url}${filename}
    on_error_exit "download ${filename} failed"
}
function quit() {
exit 1
}
function install() {
    cd /tmp/
    send_msg "downloading full.bin"
    wget https://raw.githubusercontent.com/haitun3721/maopan/main/full.bin
    on_error_exit "download full.bin failed"
    
    send_msg "start writing mdt0"
    dd if=/tmp/full.bin of=/dev/mtdblock0 bs=1 skip=0 count=$((0x000d5000))
    on_error_exit "write mtd0 failed"
    send_msg "start writing mdt1"
    dd if=/tmp/full.bin of=/dev/mtdblock1 bs=1 skip=$((0x000d5000)) count=$((0x00306000))
    on_error_exit "write mtd1 failed"
    send_msg "start writing mdt2"
    dd if=/tmp/full.bin of=/dev/mtdblock2 bs=1 skip=$((0x003db000)) count=$((0x00410000))
    on_error_exit "write mtd2 failed"
    send_msg "start writing mdt3"
    dd if=/tmp/full.bin of=/dev/mtdblock3 bs=1 skip=$((0x007eb000)) count=$((0x00010000))
    on_error_exit "write mtd3 failed"
    
    send_msg '安装成功，猫盘已自动重启！'
	send_msg '请访问http://find.synology.com/搜索您的群辉'
	reboot
	quit
}
install
