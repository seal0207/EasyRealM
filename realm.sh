#!/bin/bash
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH
clear

sh_ver="1.0.2"
Green_font_prefix="\033[32m" && Red_font_prefix="\033[31m" && Green_background_prefix="\033[42;37m" && Red_background_prefix="\033[41;37m" && Font_color_suffix="\033[0m"
Info="${Green_font_prefix}[信息]${Font_color_suffix}"
Error="${Red_font_prefix}[错误]${Font_color_suffix}"
Tip="${Green_font_prefix}[注意]${Font_color_suffix}"
realm_conf_path="/etc/realm/config.json"
raw_conf_path="/etc/realm/rawconf"
#检测是否安装RealM
check_status(){
    if test -a /etc/realm/realm -a /etc/systemd/system/realm.service -a /etc/realm/config.json;then
        echo "------------------------------"
        echo -e "--------${Green_font_prefix} RealM已安装~ ${Font_color_suffix}--------"
        echo "------------------------------"
    else
        echo "------------------------------"
        echo -e "--------${Red_font_prefix}RealM未安装！${Font_color_suffix}---------"
        echo "------------------------------"
    fi
}

#安装RealM
Install_RealM(){
mkdir /etc/realm
wget -N --no-check-certificate https://github.com/zhboner/realm/releases/download/v1.2.0/realm && chmod +x realm && mv realm /etc/realm
echo '
{
    "listening_addresses": ["0.0.0.0"],
    "listening_ports": [""],
    "remote_addresses": [""],
    "remote_ports": [""]
} ' > /etc/realm/config.json
chmod +x /etc/realm/config.json
echo '
[Unit]
Description=realm
After=network-online.target
Wants=network-online.target systemd-networkd-wait-online.service

[Service]
Type=simple
User=root
Restart=on-failure
RestartSec=5s
DynamicUser=true
ExecStart=/etc/realm/realm -c /etc/realm/config.json

[Install]
WantedBy=multi-user.target' > /etc/systemd/system/realm.service
systemctl enable --now realm
    echo "------------------------------"
    if test -a /etc/realm/realm -a /etc/systemd/system/realm.service -a /etc/realm/config.json;then
        echo -e "-------${Green_font_prefix} RealM安装成功! ${Font_color_suffix}-------"
        echo "------------------------------"
    else
        echo -e "-------${Red_font_prefix}RealM没有安装成功，请检查你的网络环境！${Font_color_suffix}-------"
        echo "------------------------------"
        `rm -rf "$(pwd)"/realm`
        `rm -rf "$(pwd)"/realm.service`
        `rm -rf "$(pwd)"/config.json`
    fi
sleep 3s
start_menu
}

#卸载RealM
Uninstall_RealM(){
    sleep 2s
    `rm -rf /etc/realm`
    `rm -rf /etc/systemd/system/realm.service`
    echo "------------------------------"
    echo -e "-------${Green_font_prefix} RealM卸载成功! ${Font_color_suffix}-------"
    echo "------------------------------"
    sleep 3s
    start_menu
}
#启动RealM
Start_RealM(){
    `systemctl start realm`
    echo "------------------------------"
    echo -e "-------${Green_font_prefix} RealM启动成功! ${Font_color_suffix}-------"
    echo "------------------------------"
    sleep 3s
    start_menu
}

#停止RealM
Stop_RealM(){
    `systemctl stop realm`
    echo "------------------------------"
    echo -e "-------${Green_font_prefix} RealM停止成功! ${Font_color_suffix}-------"
    echo "------------------------------"
    sleep 3s
    start_menu
}

#重启RealM
Restart_RealM(){
    `systemctl restart realm`
    echo "------------------------------"
    echo -e "-------${Green_font_prefix} RealM重动成功! ${Font_color_suffix}-------"
    echo "------------------------------"
    sleep 3s
    start_menu
}

#设置本地监听端口
Set_listening_ports(){
read -e -p " 请输入本地端口[1-65535] (支持端口段如1-100,数量需同转发端口相同):" listening_ports
[[ -z "${listening_ports}" ]] && echo "取消..." && exit 1
}

#设置转发地址
Set_remote_addresses(){
read -e -p " 请输入需转发的地址/IP :" remote_addresses
[[ -z "${remote_addresses}" ]] && echo "取消..." && exit 1
}

#设置转发端口
Set_remote_ports(){
read -e -p " 请输入远程端口[1-65535] (支持端口段如1-100，数量需同监听端口相同):" remote_ports
[[ -z "${remote_ports}" ]] && echo "取消..." && exit 1
}

#配置转发
start_conf(){
echo "{
    \"listening_addresses\": [\"0.0.0.0\"],
    \"listening_ports\": [" > $realm_conf_path
}

localport_conf(){
    count_line=$(awk 'END{print NR}' $raw_conf_path)
    for((i=1;i<=$count_line;i++))
    do
        trans_conf=$(sed -n "${i}p" $raw_conf_path)
        eachconf_retrieve
        echo "\"$listening_ports\",">> $realm_conf_path
    done
           sed -i '$s/.$//'   $realm_conf_path 
}

addresses_conf(){
echo "],
    \"remote_addresses\": [" >> $realm_conf_path
    count_line=$(awk 'END{print NR}' $raw_conf_path)
    for((i=1;i<=$count_line;i++))
    do
        trans_conf=$(sed -n "${i}p" $raw_conf_path)
        eachconf_retrieve
        echo "\"$remote_addresses\"," >> $realm_conf_path
    done
            sed -i '$s/.$//'   $realm_conf_path
}

remoteport_conf(){
echo "],
    \"remote_ports\": [" >> $realm_conf_path
    count_line=$(awk 'END{print NR}' $raw_conf_path)
    for((i=1;i<=$count_line;i++))
    do
        trans_conf=$(sed -n "${i}p" $raw_conf_path)
        eachconf_retrieve
        echo "\"$remote_ports\"," >> $realm_conf_path      
    done
            sed -i '$s/.$//'   $realm_conf_path
}

end(){
echo "]
}" >> $realm_conf_path
    `systemctl restart realm`
}

#写入查询配置
Write_rawconf(){
    echo $listening_ports"/"$remote_addresses"#"$remote_ports >> $raw_conf_path
}


#添加设置
Set_Config(){
Set_listening_ports
Set_remote_addresses
Set_remote_ports
	echo && echo -e "—————————————————————————————————————————————
	请检查RealM转发规则配置是否有误 !\n
	本 地 监 听 端 口    : ${Green_font_prefix}${listening_ports}${Font_color_suffix}
	欲 转 发 的 地址/IP  : ${Green_font_prefix}${remote_addresses}${Font_color_suffix}
	欲 转 发 的 端 口    : ${Green_font_prefix}${remote_ports}${Font_color_suffix}

—————————————————————————————————————————————\n"
	read -e -p "请按任意键继续，如有配置错误请使用 Ctrl+C 退出。" var
Write_rawconf
start_conf
localport_conf
addresses_conf
remoteport_conf
end
}

#赋值
eachconf_retrieve()
{
    a=${trans_conf}
    b=${a#*/}
    listening_ports=${trans_conf%/*}
    remote_addresses=${b%#*}
    remote_ports=${trans_conf#*#}
}

#添加RealM转发规则
Add_RealM(){
Set_Config
echo -e "--------${Green_font_prefix} 规则添加成功! ${Font_color_suffix}--------"
read -p "输入任意键按回车返回主菜单"
start_menu
}

#查看规则
Check_RealM(){
    echo -e "                      RealM 配置                        "
    echo -e "--------------------------------------------------------"
    echo -e "序号|本地端口\t|转发地址:转发端口"
    echo -e "--------------------------------------------------------"

    count_line=$(awk 'END{print NR}' $raw_conf_path)
    for((i=1;i<=$count_line;i++))
    do
        trans_conf=$(sed -n "${i}p" $raw_conf_path)
        eachconf_retrieve
        echo -e " $i  |$listening_ports\t|$remote_addresses:$remote_ports"
        echo -e "--------------------------------------------------------"
    done
read -p "输入任意键按回车返回主菜单"
start_menu
}
#删除RealM转发规则
Delete_RealM(){
    echo -e "                      RealM 配置                        "
    echo -e "--------------------------------------------------------"
    echo -e "序号|本地端口\t|转发地址:转发端口"
    echo -e "--------------------------------------------------------"

    count_line=$(awk 'END{print NR}' $raw_conf_path)
    for((i=1;i<=$count_line;i++))
    do
        trans_conf=$(sed -n "${i}p" $raw_conf_path)
        eachconf_retrieve
        echo -e " $i  |$listening_ports\t|$remote_addresses:$remote_ports"
        echo -e "--------------------------------------------------------"
    done
read -p "请输入你要删除的配置编号：" numdelete
sed -i "${numdelete}d" $raw_conf_path
rm -rf /etc/realm/config.json
start_conf
localport_conf
addresses_conf
remoteport_conf
end
`systemctl restart realm`
echo -e "------------------${Red_font_prefix}配置已删除,服务已重启${Font_color_suffix}-----------------"
sleep 2s
clear
echo -e "----------------------${Green_font_prefix}当前配置如下${Font_color_suffix}----------------------"
echo -e "--------------------------------------------------------"
Check_RealM
read -p "输入任意键按回车返回主菜单"
start_menu
}


#更新脚本
Update_Shell(){
	echo -e "当前版本为 [ ${sh_ver} ]，开始检测最新版本..."
	sh_new_ver=$(wget --no-check-certificate -qO- "https://raw.githubusercontent.com/seal0207/EasyRealM/main/realm.sh"|grep 'sh_ver="'|awk -F "=" '{print $NF}'|sed 's/\"//g'|head -1)
	[[ -z ${sh_new_ver} ]] && echo -e "${Error} 检测最新版本失败 !" && start_menu
	if [[ ${sh_new_ver} != ${sh_ver} ]]; then
		echo -e "发现新版本[ ${sh_new_ver} ]，是否更新？[Y/n]"
		read -p "(默认: y):" yn
		[[ -z "${yn}" ]] && yn="y"
		if [[ ${yn} == [Yy] ]]; then
			wget -N --no-check-certificate https://raw.githubusercontent.com/seal0207/EasyRealM/main/realm.sh && chmod +x realm.sh
			echo -e "脚本已更新为最新版本[ ${sh_new_ver} ] !"
		else
			echo && echo "	已取消..." && echo
		fi
	else
		echo -e "当前已是最新版本[ ${sh_new_ver} ] !"
		sleep 3s
	fi
}

#主菜单
start_menu(){
clear
echo
echo "#############################################################"
echo "#                 RealM 一键脚本  By :Seal0207              #"
echo "#############################################################"
echo -e "公告：$(curl -L -s --connect-timeout 3 https://raw.githubusercontent.com/seal0207/EasyRealM/main/notice)"
echo -e "
 当前版本 ${Red_font_prefix}[v${sh_ver}]${Font_color_suffix}
 ${Green_font_prefix}1.${Font_color_suffix} 安装 RealM
 ${Green_font_prefix}2.${Font_color_suffix} 卸载 RealM
————————————
 ${Green_font_prefix}3.${Font_color_suffix} 启动 RealM
 ${Green_font_prefix}4.${Font_color_suffix} 停止 RealM
 ${Green_font_prefix}5.${Font_color_suffix} 重启 RealM
————————————
 ${Green_font_prefix}6.${Font_color_suffix} 添加 RealM 转发规则
 ${Green_font_prefix}7.${Font_color_suffix} 查看 RealM 转发规则
 ${Green_font_prefix}8.${Font_color_suffix} 删除 RealM 转发规则
 ${Green_font_prefix}9.${Font_color_suffix} 退出脚本
 ${Green_font_prefix}0.${Font_color_suffix} 更新脚本"
 check_status

read -p " 请输入数字后[0-9] 按回车键:" num
case "$num" in
	1)
	Install_RealM
	;;
	2)
	Uninstall_RealM
	;;
	3)
	Start_RealM
	;;
	4)
	Stop_RealM
	;;
	5)
	Restart_RealM
	;;
	6)
	Add_RealM
	;;
	7)
	Check_RealM
	;;
	8)
	Delete_RealM
	;;
	9)
	exit 1
	;;
	0)
	Update_Shell
	;;
	*)	
	clear
	echo -e "${Error}:请输入正确数字 [1-6] 按回车键"
	sleep 2s
	start_menu
	;;
esac
}
start_menu
