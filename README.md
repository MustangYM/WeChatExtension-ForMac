
<p align="center">
<img src="https://github.com/MustangYM/WeChatExtensionSources/blob/master/Pictures/face.png" width="1000px"/>
</p>

![platform](https://img.shields.io/badge/platform-macos-lightgrey.svg)  [![release](https://img.shields.io/badge/release-v2.5.3-brightgreen.svg)](https://github.com/MustangYM/WeChatExtension-ForMac/releases)  ![support](https://img.shields.io/badge/support-wechat%202.4.0-blue.svg)

支持[企业微信](https://github.com/MustangYM/WeChatICU-ForMac),由此进.

## 声明
- 适用于Mac版的WeChat拓展功能. 1.7.5代码来自于WeChatPlugin, 对[TK](https://github.com/TKkk-iOSer)在此表示感谢!

## 最新支持版本
-  mac版微信2.4.0

## 黑夜/少女 模式
- 众多软件都适配了黑夜模式, 等了这么久Mac微信官方还是没做适配. 所以做了这个玩票功能
- 少量细节没有做适配, 不影响正常使用, 如果你是强迫症加完美主义, `主题模式-黑夜模式-再次点击`可以`关掉`这个功能
- 在黑夜模式中你可以打开`群成员彩色`, 群聊中每个发言人的昵称颜色都会有所区别
<p align="center">
<img src="https://github.com/MustangYM/WeChatExtensionSources/blob/master/Pictures/darkMode.png" width="800px"/>
</p>

- 少女粉模式
<p align="center">
<img src="https://github.com/MustangYM/WeChatExtensionSources/blob/master/Pictures/pinkMode.png" width="800px"/>
</p>

- 模式切换
<p align="center">
<img src="https://github.com/MustangYM/WeChatExtensionSources/blob/master/Pictures/changeMode.png" width="300px"/>
</p>

## 消息防撤回
<p align="center">
<img src="https://github.com/MustangYM/WeChatExtensionSources/blob/master/Pictures/revoke.gif" width="800px"/>
</p>

## 手机端也能收到被撤回的消息
- 如果Mac拦截到A发送来的消息, 手机也会同步收到的这条已经拦截的消息(自己发送给自己). 目前只支持同步文字消息与图片消息, 其他类型也可以做, 但意义不大.
<p align="center">
<img src="https://github.com/MustangYM/WeChatExtensionSources/blob/master/Pictures/revokeAsync.jpg" width="800px"/>
</p>

- 可以对同步的消息进行筛选, 以免群消息打扰
<p align="center">
<img src="https://github.com/MustangYM/WeChatExtensionSources/blob/master/Pictures/WX20190625-111206%402x.png" width="600px"/>
</p>

## 免认证登录与多开
<p align="center">
<img src="https://github.com/MustangYM/WeChatExtensionSources/blob/master/Pictures/launch.gif" width="800px"/>
</p>

## 同时支持自定义回复和AI自动撩妹
- 腾讯AI人工智能(ZZ)自动回复, 能理解上下文语义. 经过大量临床试验和大家反馈, 腾讯这个AI接口回复十分智障, 慎用.
- 自定义自动回复

<p align="center">
<img src="https://github.com/MustangYM/WeChatExtensionSources/blob/master/Pictures/Snipaste_2019-12-23_11-41-20.png" width="800px"/>
</p>

## 显示小程序详情
<p align="center">
<img src="https://github.com/MustangYM/WeChatExtensionSources/blob/master/Pictures/WX20191220-2004071%402x.png" width="800px"/>
</p>

## Alfred
- 确保你电脑中有安装Alfred, 双击此文件进行安装.
<p align="center">
<img src="https://github.com/MustangYM/WeChatExtensionSources/blob/master/Pictures/WX20191217-1036331%402x.png" width="800px"/>
</p>

## 退群监控
- 退群提醒, 同一人在同一群里的退出提醒7天内不再重复提示.
<p align="center">
<img src="https://github.com/MustangYM/WeChatExtensionSources/blob/master/Pictures/WX20191227-200134%402x.png" width="800px"/>
</p>

## 微信多开兼容小程序
<p align="center">
<img src="https://github.com/MustangYM/WeChatExtensionSources/blob/master/Pictures/MiniProgram.png" width="800px"/>
</p>



## 怎么安装?
### 1.普通安装(clone最新版本并安装)
```
sudo rm -r -f WeChatExtension-ForMac && git clone --depth=1 https://github.com/MustangYM/WeChatExtension-ForMac && cd WeChatExtension-ForMac/WeChatExtension/Rely && ./Install.sh
```

### 2.懒癌版安装

<p align="left">
<img src="https://avatars1.githubusercontent.com/u/5035625?s=400&v=4" width="100px"/>
</p>

感谢 [lmk123](https://github.com/lmk123)为此项目开发的懒癌安装 [Oh My WeChat](https://github.com/lmk123/oh-my-wechat)

打开`应用程序-实用工具-Terminal(终端)`，执行下面的命令安装 [Oh My WeChat](https://github.com/lmk123/oh-my-wechat)：

```sh
curl -o- -L https://raw.githubusercontent.com/lmk123/oh-my-wechat/master/install.sh | bash -s
```

安装完成后会自动安装微信插件，可以访问 [Oh My WeChat 的项目主页](https://github.com/lmk123/oh-my-wechat#oh-my-wechat)查看更多用法。


### 3.手动安装

- 3.1. 确保你的Mac上已经安装了微信App.

- 3.2. 下载本项目到你的电脑里, 并双击打开.
<p align="center">
<img src="https://github.com/MustangYM/WeChatExtensionSources/blob/master/Pictures/WX20190619-112238.png" width="800px"/>
</p>

- 3.3. 依次打开文件夹
<p align="center">
<img src="https://github.com/MustangYM/WeChatExtensionSources/blob/master/Pictures/WX20190619-113413%402x.png" width="800px"/>
</p>

- 3.4. 打开你电脑中的终端工具
<p align="center">
<img src="https://github.com/MustangYM/WeChatExtensionSources/blob/master/Pictures/WX20190619-113911%402x.png" width="800px"/>
</p>
 
- 3.5. 在Rely/Install.sh执行这个安装脚本
<p align="center">
<img src="https://github.com/MustangYM/WeChatExtensionSources/blob/master/Pictures/QQ20190425-155120%402x.png" width="800px"/>
</p>

- 3.6. 重启微信, 安装完成.

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

## 更新日志
```
2020-03-31 会话列表抖动, 联系人列表优化, 群成员列表优化
2020-03-25 视频播放界面遮罩修复, 聊天界面按钮优化, 屏蔽消息提示优化, 文件选择界面优化, 消息记录界面优化, 粉色模式下TouchBar问题修复, 置底和多选修复
2020-03-19 表情,聊天记录,群聊创建输入框,登录页,弹窗等等页面适配黑暗模式
2020-03-17 黑夜模式
2020-02-25 兼容微信2.4.0, 修复小程序不能打开BUG, 并兼容微信多开
2019-12-27 退群提醒
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

<table><tr>
 
   <td align="center">
    <a href="https://github.com/lvsijian8"><img src="https://avatars0.githubusercontent.com/u/19362089?s=400&v=4" width="100px;" alt="lvsijian8"/>
  <br></br><sub><b>lvsijian8</b></sub>    
 
   <td align="center">
  <a href="https://github.com/TheColdVoid"><img src="https://avatars2.githubusercontent.com/u/10008227?s=400&v=4" width="100px;" alt="TheColdVoid"/>
  <br></br><sub><b>TheColdVoid</b></sub>   
 
   <td align="center">
  <a href="https://github.com/Yaidea"><img src="https://avatars2.githubusercontent.com/u/61902523?s=400&v=4" width="100px;" alt="Yaidea"/>
  <br></br><sub><b>Yaidea</b></sub> 
 
   <td align="center">
  <a href="https://github.com/zybook"><img src="https://avatars2.githubusercontent.com/u/5904979?s=400&v=4" width="100px;" alt="zybook"/>
  <br></br><sub><b>zybook</b></sub>
 
   <td align="center">
  <a href="https://github.com/hydrahailnuaa"><img src="https://avatars2.githubusercontent.com/u/8326343?s=400&v=4" width="100px;" alt="hydrahailnuaa"/>
  <br></br><sub><b>hydrahailnuaa</b></sub>
 
   <td align="center">
  <a href="https://github.com/DaBo0219"><img src="https://avatars2.githubusercontent.com/u/62327176?s=400&v=4" width="100px;" alt="DaBo0219"/>
  <br></br><sub><b>DaBo0219</b></sub>
 
   <td align="center">
  <a href="https://github.com/wujunze"><img src="https://avatars1.githubusercontent.com/u/12997869?s=400&u=455e0f09c1e11fc0df7594d7dfbba88be92c4244&v=4" width="100px;" alt="wujunze"/>
  <br></br><sub><b>wujunze</b></sub>
 
   <td align="center">
  <a href="https://github.com/greatpie"><img src="https://avatars2.githubusercontent.com/u/8511143?s=400&u=813b0bbae8b04034e37b8d45298c5e004de515bf&v=4" width="100px;" alt="greatpie"/>
  <br></br><sub><b>greatpie</b></sub>
 
</td></tr></table>

 <table><tr>
 
   <td align="center">
  <a href="https://github.com/snakejordan"><img src="https://avatars0.githubusercontent.com/u/3376284?s=400&v=4" width="100px" alt="snakejordan"/>
  <br></br><sub><b>snakejordan</b></sub>
 
   <td align="center">
  <a href="https://github.com/lzf971107"><img src="https://avatars2.githubusercontent.com/u/37407114?s=400&u=6c9f6eeb4a8b90814ff6ef1a28cdaa20b47d80ec&v=4" width="100px" alt="lzf971107"/>
  <br></br><sub><b>lzf971107</b></sub>
 
   <td align="center">
  <a href="https://github.com/augusl"><img src="https://avatars1.githubusercontent.com/u/25142251?s=400&v=4" width="100px" alt="augusl"/>
  <br></br><sub><b>augusl</b></sub>
 
   <td align="center">
  <a href="https://github.com/watership"><img src="https://avatars0.githubusercontent.com/u/2470422?s=400&u=b682f8bbbe6931a9e109bbe3f63c6f87fbed7d60&v=4" width="100px" alt="watership"/>
  <br></br><sub><b>watership</b></sub>
 
   <td align="center">
  <a href="https://github.com/Artemis-13"><img src="https://avatars2.githubusercontent.com/u/61645537?s=400&u=cbbb168e60b1d1ace572cd4bcf9712f054a1497c&v=4" width="100px" alt="Artemis-13"/>
  <br></br><sub><b>Artemis-13</b></sub>
 
   <td align="center">
  <a href="https://github.com/yuanaichi"><img src="https://avatars2.githubusercontent.com/u/7549002?s=400&u=6771f9fbd349486f6aaff4a34da057fb426034d8&v=4" width="100px" alt="yuanaichi"/>
  <br></br><sub><b>yuanaichi</b></sub>
  
   <td align="center">
  <a href="https://github.com/JJ7539"><img src="https://avatars0.githubusercontent.com/u/11268054?s=400&u=c0c2c99164982cefb00b9677dd17848420bec734&v=4" width="100px" alt="JJ7539"/>
  <br></br><sub><b>JJ7539</b></sub>
 
   <td align="center">
  <a href="https://github.com/coolmilkTea"><img src="https://avatars2.githubusercontent.com/u/48348904?s=400&u=4fd777edf333f39a6a3fe7917a159aad6c98b200&v=4" width="100px;" alt="coolmilkTea"/>
  <br></br><sub><b>coolmilkTea</b></sub>
  
 </td></tr></table>
 
  <table><tr>
 
   <td align="center">
  <a href="https://github.com/AhQi7"><img src="https://avatars0.githubusercontent.com/u/46393078?s=400&v=4" width="100px;" alt="AhQi7"/>
  <br></br><sub><b>AhQi7</b></sub>
 
   <td align="center">
  <a href="https://github.com/caoxinjava001"><img src="https://avatars3.githubusercontent.com/u/4892867?s=400&u=0ad501d30873d872971e8c4cd941f6e40c5f02ea&v=4" width="100px;" alt="caoxinjava001"/>
  <br></br><sub><b>caoxinjava001</b></sub>
 
   <td align="center">
  <a href="https://github.com/Whatsmine"><img src="https://avatars2.githubusercontent.com/u/39985040?s=400&v=4" width="100px;" alt="Whatsmine"/>
  <br></br><sub><b>Whatsmine</b></sub>
 
  </td></tr></table>

## Backers

Thank you to all our backers! 🙏 [[Become a backer](https://opencollective.com/mustangym666#backer)]

<a href="https://opencollective.com/mustangym666#backers" target="_blank"><img src="https://opencollective.com/mustangym666/backers.svg?width=890"></a>

## 交流与支持
<p align="left">
<img src="https://github.com/MustangYM/WeChatExtensionSources/blob/master/Pictures/aliPay.png" width="200px"/>
</p>


QQ群 741941325

