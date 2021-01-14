#!/bin/bash

app_name="WeChat"
shell_path="$(dirname "$0")"
wechat_path="/Applications/WeChat.app"
framework_name="WeChatExtension"
app_bundle_path="/Applications/${app_name}.app/Contents/MacOS"
app_executable_path="${app_bundle_path}/${app_name}"
app_executable_backup_path="${app_executable_path}_backup"
framework_path="${app_bundle_path}/${framework_name}.framework"

# 对 WeChat 赋予权限
if [ ! -w "$wechat_path" ]
then
echo -e "\n\n为了将小助手写入微信, 请输入密码 ： "
sudo chown -R $(whoami) "$wechat_path"
fi
# 极少部分机器会出现签名异常情况，先执行卸载流程
if [ -f "$app_executable_backup_path" ]
then
sudo rm "$app_executable_path"
sudo rm -rf "$framework_path"
sudo mv "$app_executable_backup_path" "$app_executable_path"

if [ ! -f "$app_executable_backup_path" ]
then
    echo "\n\t卸载旧小助手成功,安装新版中..."
fi
#未发现小助手
fi

#安装流程
# 备份 WeChat 原始可执行文件
if [ ! -f "$app_executable_backup_path" ]
then
cp "$app_executable_path" "$app_executable_backup_path"
fi

cp -r "${shell_path}/${framework_name}.framework" ${app_bundle_path}
${shell_path}/insert_dylib --all-yes "${framework_path}/${framework_name}" "$app_executable_backup_path" "$app_executable_path"

