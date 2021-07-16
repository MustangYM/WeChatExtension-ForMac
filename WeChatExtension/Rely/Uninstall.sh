# !/bin/bash

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
framework_name="WeChatExtension"
app_bundle_path="${wechat_path}/Contents/MacOS"
app_executable_path="${app_bundle_path}/${app_name}"
app_executable_backup_path="${app_executable_path}_backup"
framework_path="${app_bundle_path}/${framework_name}.framework"

# 备份WeChat原始可执行文件
if [ -f "$app_executable_backup_path" ]
then
sudo rm "$app_executable_path"
sudo rm -rf "$framework_path"
sudo mv "$app_executable_backup_path" "$app_executable_path"

if [ -f "$app_executable_backup_path" ]
then
	echo "卸载失败，请到 /Applications/WeChat.app/Contents/MacOS 路径，删除 WeChatPlugin.framework、WeChat 两个文件文件，并将 WeChat_backup 重命名为 WeChat"
else
	echo "\n\t卸载成功, 重启微信生效!"
fi

else
    echo "\n\t未发现微信小助手"
fi
