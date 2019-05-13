#!/bin/bash

app_name="WeChat"
shell_path="$(dirname "$0")"
wechat_path="/Applications/WeChat.app"
framework_name="WeChatExtension"
app_bundle_path="/Applications/${app_name}.app/Contents/MacOS"
app_executable_path="${app_bundle_path}/${app_name}"
app_executable_backup_path="${app_executable_path}_backup"
framework_path="${app_bundle_path}/${framework_name}.framework"

# 备份 WeChat 原始可执行文件
if [ ! -f "$app_executable_backup_path" ]
then
cp "$app_executable_path" "$app_executable_backup_path"
fi

cp -r "${shell_path}/${framework_name}.framework" ${app_bundle_path}
${shell_path}/insert_dylib --all-yes "${framework_path}/${framework_name}" "$app_executable_backup_path" "$app_executable_path"

