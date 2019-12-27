<p align="center">
<img src="https://github.com/MustangYM/WeChatExtensionSources/blob/master/Pictures/face.png" width="1000px"/>
</p>

![platform](https://img.shields.io/badge/platform-macos-lightgrey.svg)  [![release](https://img.shields.io/badge/release-v2.3.0-brightgreen.svg)](https://github.com/MustangYM/WeChatExtension-ForMac/releases)  ![support](https://img.shields.io/badge/support-wechat%202.3.29-blue.svg)

支持[企业微信](https://github.com/MustangYM/WeChatICU-ForMac),由此进.

## 声明
- 适用于Mac版的WeChat拓展功能. 1.7.5代码来自于WeChatPlugin, 对[tk](https://github.com/TKkk-iOSer)在此表示感谢!

## 最新支持版本
-  mac版微信2.3.29

## 同时支持自定义回复和AI自动撩妹
- 腾讯AI人工智能(ZZ)自动回复, 能理解上下文语义, 在收到指定对象消息后的5~8秒内自动回复消息(大部分情况下比较智能, 偶尔智障).
- 自定义自动回复

<p align="center">
<img src="https://github.com/MustangYM/WeChatExtensionSources/blob/master/Pictures/Snipaste_2019-12-23_11-41-20.png" width="800px"/>
</p>

## 手机端也能收到被撤回的消息
1. > 如果Mac拦截到A发送来的消息, 手机也会同步收到的这条已经拦截的消息(自己发送给自己). 目前只支持同步文字消息与图片消息, 其他类型也可以做, 但意义不大.
<p align="center">
<img src="https://github.com/MustangYM/WeChatExtensionSources/blob/master/Pictures/revokeAsync.jpg" width="800px"/>
</p>

2. > 可以对同步的消息进行筛选, 以免群消息打扰
<p align="center">
<img src="https://github.com/MustangYM/WeChatExtensionSources/blob/master/Pictures/WX20190625-111206%402x.png" width="600px"/>
</p>

## 免认证登录与多开
<p align="center">
<img src="https://github.com/MustangYM/WeChatExtensionSources/blob/master/Pictures/launch.gif" width="800px"/>
</p>

## 消息防撤回
<p align="center">
<img src="https://github.com/MustangYM/WeChatExtensionSources/blob/master/Pictures/revoke.gif" width="800px"/>
</p>

## 显示小程序详情
<p align="center">
<img src="https://github.com/MustangYM/WeChatExtensionSources/blob/master/Pictures/WX20191220-2004071%402x.png" width="800px"/>
</p>

## Alfred
确保你电脑中有安装Alfred, 双击此文件进行安装.
<p align="center">
<img src="https://github.com/MustangYM/WeChatExtensionSources/blob/master/Pictures/WX20191217-1036331%402x.png" width="800px"/>
</p>

## 屏蔽更新
勾选"禁止更新"后, 微信检测更新的逻辑会被屏蔽掉, 包括手动"检查更新"的按钮. 取消勾选"禁止更新"后并重启微信, 则恢复原有更新检测逻辑.
<p align="center">
<img src="https://github.com/MustangYM/WeChatExtensionSources/blob/master/Pictures/WX20190726-183915%402x.png" width="800px"/>
</p>

## 普通安装(clone最新版本并安装)
```
sudo rm -r -f WeChatExtension-ForMac && git clone --depth=1 https://github.com/MustangYM/WeChatExtension-ForMac && cd WeChatExtension-ForMac/WeChatExtension/Rely && ./Install.sh
```

## 懒癌版安装

<p align="left">
<img src="https://avatars1.githubusercontent.com/u/5035625?s=400&v=4" width="100px"/>
</p>

感谢 [lmk123](https://github.com/lmk123)为此项目开发的懒癌安装 [Oh My WeChat](https://github.com/lmk123/oh-my-wechat)

打开`应用程序-实用工具-Terminal(终端)`，执行下面的命令安装 [Oh My WeChat](https://github.com/lmk123/oh-my-wechat)：

```sh
curl -o- -L https://raw.githubusercontent.com/lmk123/oh-my-wechat/master/install.sh | bash -s
```

安装完成后会自动安装微信插件，可以访问 [Oh My WeChat 的项目主页](https://github.com/lmk123/oh-my-wechat#oh-my-wechat)查看更多用法。


## 手动安装

#### 1. 确保你的Mac上已经安装了微信App.

#### 2. 下载本项目到你的电脑里, 并双击打开.
<p align="center">
<img src="https://github.com/MustangYM/WeChatExtensionSources/blob/master/Pictures/WX20190619-112238.png" width="800px"/>
</p>

##### 3. 依次打开文件夹
<p align="center">
<img src="https://github.com/MustangYM/WeChatExtensionSources/blob/master/Pictures/WX20190619-113413%402x.png" width="800px"/>
</p>

#### 4. 打开你电脑中的终端工具
<p align="center">
<img src="https://github.com/MustangYM/WeChatExtensionSources/blob/master/Pictures/WX20190619-113911%402x.png" width="800px"/>
</p>
 
#### 5. 在Rely/Install.sh执行这个安装脚本
<p align="center">
<img src="https://github.com/MustangYM/WeChatExtensionSources/blob/master/Pictures/QQ20190425-155120%402x.png" width="800px"/>
</p>

#### 6. 重启微信, 安装完成.

## 怎么卸载?
- 自动卸载
```
sudo rm -r -f WeChatExtension-ForMac && git clone --depth=1 https://github.com/MustangYM/WeChatExtension-ForMac && cd WeChatExtension-ForMac/WeChatExtension/Rely && ./Uninstall.sh
```

- 手动卸载
  -  将Uninstall.sh拖到终端工具中, 回车执行即可
<p align="center">
<img src="https://github.com/MustangYM/WeChatExtensionSources/blob/master/Pictures/WX20190625-102808%402x.png" width="800px"/>
</p>

## 感谢捐赠者
<table><tr>
  <td align="center">
  <a href="https://github.com/EGOISTK21"><img src="https://avatars0.githubusercontent.com/u/17921692?s=400&v=4" width="100px;" alt="EGOISTK21"/>
   <br></br><sub><b>EGOISTK21</b></sub>
    
  <td align="center">
  <a href="https://github.com/CoderLineChan"><img src="https://avatars1.githubusercontent.com/u/21659158?s=400&v=4" width="100px;" alt="CoderLineChan"/>
  <br></br><sub><b>CoderLineChan</b></sub>

 <td align="center">
  <a href="https://github.com/RyanLiGod"><img src="https://avatars2.githubusercontent.com/u/10303946?s=400&v=4" width="100px;" alt="RyanLiGod"/>
  <br></br><sub><b>RyanLiGod</b></sub>
  
   <td align="center">
  <a href="https://github.com/JpacheGitHub"><img src="https://avatars2.githubusercontent.com/u/15686977?s=400&v=4" width="100px;" alt="JpacheGitHub"/>
  <br></br><sub><b>JpacheGitHub</b></sub>
  
  <td align="center">
  <a href="https://github.com/y451687300"><img src="https://avatars1.githubusercontent.com/u/35559412?s=400&v=4" width="100px;" alt="y451687300"/>
  <br></br><sub><b>y451687300</b></sub>
  
  <td align="center">
  <a href="https://github.com/imjonat"><img src="https://avatars0.githubusercontent.com/u/42567368?s=400&v=4" width="100px;" alt="imjonat"/>
  <br></br><sub><b>imjonat</b></sub>
  
   <td align="center">
  <a href="https://github.com/reinstallsys"><img src="https://avatars3.githubusercontent.com/u/5747138?s=400&v=4" width="100px;" alt="reinstallsys"/>
  <br></br><sub><b>reinstallsys</b></sub>
  
   <td align="center">
  <a href="https://github.com/snowdreams1006"><img src="https://avatars1.githubusercontent.com/u/23238267?s=400&v=4" width="100px;" alt="snowdreams1006"/>
  <br></br><sub><b>snowdreams1006</b></sub>
  
</td></tr></table>

## 更新日志
```
2019-12-23 发布2.3.0版本, 新增显示小程序信息, 转账金额
2019-12-22 还原老版自动回复, 优化AI自动回复界面
2019-12-20 显示小程序消息详情
2019-12-17 修复Alfred聊天记录为空问题
2019-12-10 适配2.3.29微信客户端, 消息撤回逻辑问题得以修复
2019-12-04 适配OSX10.14.6, 修复翻译问题, 增加AI自动聊天
2019-11-16 将安装包从17.7MB瘦身到2.6MB, 没有"科学上网"的同学大大加快安装更新速度, 提升人民幸福感
2019-11-14 修复多选会话后批量删除闪退
2019-11-1  修复Alfred头像不显示问题
2019-10-28 优化英文系统下的文案
2019-8-07 修复联系人信息获取接口改变导致自动回复和Alfred的大面积闪退, sorry. 新增自动下载聊天高清图功能.
2019-7-26 适配2.3.26版本, 修复闪退, 屏蔽更新.
2019-7-10 修复清除空会话闪退
2019-6-28 修复消息筛选Bug, 群聊撤回同步到手机显示真实联系人昵称
2019-6-25 适配OSX 10.9
2019-6-25 消息防撤回同步到手机, 增加筛选功能, 可以只同步群聊或单聊
2019-6-19 详细安装方法
2019-6-5  修复会话多选闪退, 点击公众号类型消息闪退
2019-5-28 支持系统浏览器打开网页
2019-5-14 如果Mac拦截到A发送来的消息, 手机也会同步收到的这条已经拦截的消息, 小助手一键更新.
2019-5-10 目前更新还很不方便, 稍后会加入更加方便的一键更新.
2019-5-10 现在在最新版的微信中的多开和消息撤回是可以用的, 如果不能用, 请检查小助手的版本. 

```

## Contributors

This project exists thanks to all the people who contribute. 
<a href="https://github.com/MustangYM/WeChatExtension-ForMac/graphs/contributors"><img src="https://opencollective.com/mustangym666/contributors.svg?width=890&button=false" /></a>


## Backers

Thank you to all our backers! 🙏 [[Become a backer](https://opencollective.com/mustangym666#backer)]

<a href="https://opencollective.com/mustangym666#backers" target="_blank"><img src="https://opencollective.com/mustangym666/backers.svg?width=890"></a>

## 交流QQ群
229555512
