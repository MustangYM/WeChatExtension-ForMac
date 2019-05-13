#!/usr/bin/env bash

omw_str="omw"
bin_dir="/usr/local/bin"
soft_link_file="${bin_dir}/${omw_str}"
omw_work_dir="${HOME}/.oh_my_wechat"
omw_bin_file="${omw_work_dir}/${omw_str}"

# 请求 bin 目录的写入权限
if [[ ! -w ${bin_dir} ]]; then
echo "为了安装 Oh My WeChat，请输入密码 ："
sudo chown $(whoami) ${bin_dir}
fi

# 创建工作目录
if [[ ! -e ${omw_work_dir} ]]; then
mkdir ${omw_work_dir}
fi

echo "开始下载 Oh My WeChat..."
# 从 GitHub 上下载脚本
curl --retry 2 -o ${omw_bin_file} https://raw.githubusercontent.com/MustangYM/WeChatExtension-ForMac/master/WeChatExtension/Rely/OnLineUpdate/onLineUpdate.sh
# 本地开发时直接将文件复制过去
#cp ./main.sh ${omw_bin_file}

if [[ 0 -eq $? ]]; then
# 给 omw 添加执行权限
chmod 755 ${omw_bin_file}
# 创建一个到 /usr/local/bin/omw 的软链
ln -sf ${omw_bin_file} ${soft_link_file}
echo "成功安装 Oh My Wechat！即将安装微信小助手……"
${omw_bin_file} -n
else
echo "下载 Oh My WeChat 时失败，请稍后重试。"
exit 1
fi
