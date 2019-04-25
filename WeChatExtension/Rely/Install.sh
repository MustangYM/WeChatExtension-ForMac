#!/bin/bash

wechat_path="/Applications/WeChat.app"

if [ ! -d "$wechat_path" ]
then
wechat_path="/Applications/微信.app"
if [ ! -d "$wechat_path" ]
then
echo -e "\n\n应用程序文件夹中未发现微信，请检查微信是否有重命名或者移动路径位置"
exit
fi
fi

app_name="WeChat"
shell_path="$(dirname "$0")"
framework_name="WeChatPlugin"
app_bundle_path="${wechat_path}/Contents/MacOS"
app_executable_path="${app_bundle_path}/${app_name}"
app_executable_backup_path="${app_executable_path}_backup"
framework_path="${app_bundle_path}/${framework_name}.framework"


# 对 WeChat 赋予权限
if [ ! -w "$wechat_path" ]
then
echo -e "\n\n为了将小助手写入微信, 请输入密码 ： "
sudo chown -R $(whoami) "$wechat_path"
fi

# 判断是否已经存在备份文件 或者 是否强制覆盖安装
if [ ! -f "$app_executable_backup_path" ] || [ -n "$1" -a "$1" = "--force" ]
then
# 备份 WeChat 原始可执行文件
cp "$app_executable_path" "$app_executable_backup_path"
result="y"
else
read -t 150 -p "已安装微信小助手，是否覆盖？[y/n]:" result
fi

if [[ "$result" == 'y' ]]; then
    cp -r "${shell_path}/Products/Debug/${framework_name}.framework" ${app_bundle_path}
    ${shell_path}/insert_dylib --all-yes "${framework_path}/${framework_name}" "$app_executable_backup_path" "$app_executable_path"
    ${shell_path}/UpdateRemoteControlCommandsPlist.py
fi
