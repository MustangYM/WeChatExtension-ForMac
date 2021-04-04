
<p align="center">
<img src="https://gitee.com/MustangYM/we-chat-extension-source/raw/master/Pictures/face1.png" width="1000px"/>
</p>

![platform](https://img.shields.io/badge/platform-macos-lightgrey.svg)  [![release](https://img.shields.io/badge/release-v2.8.2-brightgreen.svg)](https://github.com/MustangYM/WeChatExtension-ForMac/releases)  ![support](https://img.shields.io/badge/support-wechat%202.6.1-blue.svg) 
- 支持[企业微信](https://github.com/MustangYM/WeChatICU-ForMac)，由此进。
- 如果你希望更简约，这里提供了[简版小助手](https://github.com/MustangYM/WeChatSeptet-ForMac)，安装方式与WeChatExtension的手动安装方式一样。
- Most users of this project are Chinese, so there is `NO ENGLISH WIKI`.

## ⚠️警告⚠️
- [全国最大制售微信外挂软件案宣判！主犯获刑10年](https://tech.ifeng.com/c/85A5xn6wYpo)。
- 有不少三方盗版网站在`售卖甚`至通过`改编`此项目开源代码进行`非法获利`，这已经超出我本人所能控制范围，这并非我的初衷，此项目是免费开源，请各三方网站停止售卖此MIT协议项目。

| 警告网站 | 非法获利形式 |
| --- | --- |
| [Mac69](https://www.mac69.com/mac/5587.html) | 非法售卖300积分VIP免费/次 |
| [Mac金币](https://www.macjb.com/mac/3628.html) | 非法售卖300积分/次 |
| [CSDN](https://download.csdn.net/download/weixin_42142062/15043017) | 非法售卖28积分/次 |
| [米铺网](http://www.mipuo.com/37672.html) | 会员形式下载盈利/次 |
| [imacapp](https://www.imacapp.net/4055.html) | 非法售卖50积分 |
| [xuanziyuan](https://mac.xuanziyuan.com/421401.html) | 非法售卖3.5积分/次 |
| [淘宝店铺MacRuoRuo](https://item.taobao.com/item.htm?spm=a230r.7195193.1997079397.11.10941121totpfD&id=618366544551&abbucket=13) | 非法售卖15元/次 |
| [macv.com](https://www.macv.com/mac/2356.html) | 非法售卖300积分/次 |
| 欢迎大家踊跃举报，抵制！ | ... |


## 声明以及常见问题
- 暂未适配macOS11，不处理macOS11相关bug，`2021-02-08`后安装插件后`无法启动`可能是[签名问题](https://github.com/MustangYM/WeChatExtension-ForMac/issues/816)导致的!
- 到目前为止，并未发现因使用本插件会导致封号。
- Issues注意事项[Wiki](https://github.com/MustangYM/WeChatExtension-ForMac/wiki/Issues%E6%B3%A8%E6%84%8F%E4%BA%8B%E9%A1%B9)。

## 最新支持版本
- [下载最新版微信](https://dldir1.qq.com/weixin/mac/WeChatMac_Beta.dmg)。
- 皮肤最低支持macOS 10.14。

## 小助手相关介绍
- [Toptips视频介绍(゜-゜)つロ 干杯~](https://www.bilibili.com/video/BV1Xi4y1b72c?from=search&seid=863944292302073615)(基于2.5版本的小助手介绍，现在的小助手更完善)。
- 经过两年的不间断的维护已成长为最受欢迎的`Objective-C`项目之一，请放心使用。
  - [中文榜](https://github.com/kon9chunkit/GitHub-Chinese-Top-Charts#Objective-C)。（娱乐数据，仅供参考）
  - [OC总榜](https://github-trending.com/repo/Objective-C)。（娱乐数据，仅供参考）
<p align="left">
<img src="https://starchart.cc/MustangYM/WeChatExtension-ForMac.svg" width="800px"/>
</p>

## 迷离/黑夜/深邃/少女 皮肤模式
- 少量细节没有做适配，`主题模式-关闭皮肤`可以`关掉`这个功能。
- 群聊中每个发言人的`昵称颜色`都会有所区别。
- 在皮肤模式下，未读消息头像会轻微可爱`摇动`，未读数超过`99条`的会话有`彩蛋`。
- 如果你的迷离模式`未生效`，打开`系统偏好设置` -> `辅助功能` -> `显示`，不要勾选`减少透明度`或`提供对比度`。
<p align="center">
<img src="https://gitee.com/MustangYM/we-chat-extension-source/raw/master/Pictures/theme_compoment.png" width="1500px"/>
</p>

- 模式切换
<p align="center">
<img src="https://gitee.com/MustangYM/we-chat-extension-source/raw/master/Pictures/change_theme.png" width="300px"/>
</p>

## 僵尸粉检测
<del>- 通过建立一个微信群，将被检测对象拉入群中，拉失败的就是非好友。</del>
<del>- 只要你自己不在群里发消息，这个群理论上是不算存在的，别人也就无从发现。</del>
<del>- 检测完，一旦你自己退出群聊或者删除群，此群就算解散了，所以不会留下痕迹。</del>

## 手机端也能收到被撤回的消息
- 如果Mac拦截到A发送来的消息，手机也会同步收到的这条已经拦截的消息(自己发送给自己)。目前只支持同步文字消息与图片消息。
- 可以对同步的消息进行勾选，以免群消息打扰。
<p align="center">
<img src="https://gitee.com/MustangYM/we-chat-extension-source/raw/master/Pictures/revokeMessage.png" width="1500px"/>
</p>

## 消息转发
- Mac可实现多开，出门在外手机却不能，怎样在同一台手机上实现多个微信号消息的监听？
- iPhone上可安装自签的微信包，实现多开，但是Bundle Id的改变导致APNS消息推送异常，无法收到消息推送？
- 目前只能转发文字消息。选择`转发所有好友消息`时，只转发单聊消息，不转发群聊消息。
<p align="center">
<img src="https://gitee.com/MustangYM/we-chat-extension-source/raw/master/Pictures/fowardMessage.png" width="1500px"/>
</p>

## 免认证登录与多开
- 可以`同时`登录`多个`微信号。
<p align="center">
<img src="https://gitee.com/MustangYM/we-chat-extension-source/raw/master/Pictures/launch.png" width="800px"/>
</p>

## 同时支持自定义回复和AI自动撩妹
- 腾讯AI人工智能自动回复，能理解上下文语义。**大量临床试验和大家反馈，腾讯这个AI接口回复不够完善，慎用。**
- 自定义自动回复。

<p align="center">
<img src="https://gitee.com/MustangYM/we-chat-extension-source/raw/master/Pictures/Snipaste_2019-12-23_11-41-20.png" width="800px"/>
</p>

## 显示小程序详情
- 即便Mac微信现在可以`打开`小程序，暂时还`不支持`游戏小程序，所以`保留`了此功能。
<p align="center">
<img src="https://gitee.com/MustangYM/we-chat-extension-source/raw/master/Pictures/WX20191220-2004071%402x.png" width="800px"/>
</p>

## Alfred
- 确保你电脑中有安装Alfred，双击此文件进行安装。
<p align="center">
<img src="https://gitee.com/MustangYM/we-chat-extension-source/raw/master/Pictures/WX20191217-1036331%402x.png" width="800px"/>
</p>

- 依次点击 `小助手` -> `开启Alfred功能`
- 打开你的Alfred搜索框，输入 `wx `(wx后面接一个空格)，即可开启Alfred控制微信之旅

## 退群监控
- 退群提醒，同一人在同一群里的退出提醒7天内不再重复提示。
<p align="center">
<img src="https://gitee.com/MustangYM/we-chat-extension-source/raw/master/Pictures/WX20191227-200134%402x.png" width="800px"/>
</p>

## 群员监控
- 微信版本`>=2.4.2（15650）`才支持此功能。
- 群员监控Window中，鼠标右键单击左侧`Session`列表某行出现`拒收消息`，可以在Mac上完全拒收此群消息，避免打扰。
- 右侧列表是依次是`昵称`、相关`发言时间与条数`、`违规言论`、`拼多多砍一刀`。
- 此功能暂时属于`实验性质`。
<p align="center">
<img src="https://gitee.com/MustangYM/we-chat-extension-source/raw/master/Pictures/ZGMP.png" width="800px"/>
</p>

## 怎么安装?

### 安装方式一：普通安装(clone最新版本并安装)
```
sudo rm -r -f WeChatExtension-ForMac && git clone --depth=1 https://github.com/MustangYM/WeChatExtension-ForMac && cd WeChatExtension-ForMac/WeChatExtension/Rely && ./Install.sh && cd ~
```

### 安装方式二：懒癌版安装

<p align="left">
<img src="https://avatars1.githubusercontent.com/u/5035625?s=400&v=4" width="100px"/>
</p>

感谢 [lmk123](https://github.com/lmk123)为此项目开发的懒癌安装 [Oh My WeChat](https://github.com/lmk123/oh-my-wechat)

打开`应用程序-实用工具-Terminal(终端)`，执行下面的命令安装 [Oh My WeChat](https://github.com/lmk123/oh-my-wechat)：（Oh My WeChat只需安一次，以后就只需执行 `omw`或`omw -n`即可）

```sh
curl -o- -L https://omw.limingkai.cn/install.sh | bash -s
```
Oh My WeChat一键命令
```
omw
```
跳过检查更新的步骤，优先使用下载过的安装包安装小助手。
```
omw -n
```
omw 会从 [GitHub 仓库](https://github.com/MustangYM/WeChatExtension-ForMac)检查更新及下载安装包，但由于网络不稳定，下载可能会失败，但你还可以使用 `omw load` 命令安装小助手。

安装完成后会自动安装微信插件，可以访问 [Oh My WeChat 的项目主页](https://github.com/lmk123/oh-my-wechat#oh-my-wechat)查看更多用法。

### 安装方式三：手动安装
- 3.1.确保你的Mac上已经安装了微信App。

- 3.2.下载本项目到你的电脑里， 并双击打开。
<p align="center">
<img src="https://gitee.com/MustangYM/we-chat-extension-source/raw/master/Pictures/install1.png" width="1500px"/>
</p>

- 3.3.依次打开文件夹`WeChatExtension/Rely/Install.sh`。

- 3.4.将`Install.sh`拖入终端工具中按`回车`执行安装。
<p align="center">
<img src="https://gitee.com/MustangYM/we-chat-extension-source/raw/master/Pictures/install2.png" width="1500px"/>
</p>

- 3.5.`重启`微信，安装完成。

## 怎么卸载?
### 卸载方式一：自动卸载（推荐）
```
bash <(curl -sL https://git.io/JUO6r)
```
### 卸载方式二：手动卸载
  -  将Uninstall.sh拖到终端工具中，回车执行即可。
<p align="center">
<img src="https://gitee.com/MustangYM/we-chat-extension-source/raw/master/Pictures/uninstall.png" width="1500px"/>
</p>

### 卸载方式三：使用 Oh My Wechat 卸载
如果你安装了 [Oh My WeChat](https://github.com/lmk123/oh-my-wechat#oh-my-wechat)，那么运行下面的命令即可：
```bash
omw un
```



## 更新日志
```
2021-01-15 适配微信v2.6.1(16837)，群员监控可查看具体违规言论，修复2.6以上多选BUG。
2020-12-24 适配微信2.6.0（16787），新增pkg安装包安装模式。
2020-10-31 修复清除空会话失效，优化置底、公众号浏览，新增一键卸载小助手，新增关闭皮肤选项，新增群员监控、拒收群消息。
2020-09-20 系统低于macOS10.14不再支持皮肤，修复2.4.2 (15650)选取联系人Crash，优化UI细节。
2020-09-16 适配微信2.4.2(15650)Beta 148，修复微信会话列表为空，新增通讯录管理皮肤适配，小程序成为独立模块，多开与小程序终于完美兼容，喜极而泣！
2020-08-28 重构退群监控，会话列表选中高亮，修复部分低版本微信Crash。
2020-08-13 聊天输入框/表情选择/收藏界面图标优化，修复联系人列表/详情页面若干BUG。
2020-07-27 修复免认证登录后, 主页面一片空白。修复部分机器会话标题显示不全。适配10.13低版本系统聊天框底部图标不显示。
2020-07-21 新增“迷离模式”主题。
2020-07-13 消息自动转发，移除退群监控，界面优化。
2020-06-30 修复内存泄露导致的越用越卡顿，修复打字卡顿。
2020-06-11 下架僵尸粉检测功能，修复聊天记录不完整BUG。
2020-06-03 检测僵尸粉。
2020-05-07 新增深邃模式，退群监控性能优化，修复搜索界面BUG，修复消息引用BUG。
2020-04-26 崩溃拦截，修复收藏中笔记显示BUG，适配2.4.0.149群语音或视频显示，修复公众列表右键点击BUG，茱萸粉皮肤。
2020-04-16 修复小程序、Word、Excel不显示。
2020-04-13 2.5.4版本在2.3.26微信上启动会闪退，已经修复。
2020-04-10 修复免认证登录后左下角"小手机"不显示，远程控制/自动回复/关于界面适配黑暗模式。
2020-03-31 会话列表抖动，联系人列表优化，群成员列表优化。
2020-03-25 视频播放界面遮罩修复，聊天界面按钮优化，屏蔽消息提示优化，文件选择界面优化，消息记录界面优化。粉色模式下TouchBar问题修复，置底和多选修复。
2020-03-19 表情，聊天记录，群聊创建输入框，登录页，弹窗等等页面适配黑暗模式。
2020-03-17 黑夜模式。
2020-02-25 兼容微信2.4.0，修复小程序不能打开BUG，并兼容微信多开。
2019-12-27 退群提醒。
2019-12-23 发布2.3.0版本，新增显示小程序信息，转账金额。
2019-12-22 还原老版自动回复，优化AI自动回复界面。
2019-12-20 显示小程序消息详情。
2019-12-17 修复Alfred聊天记录为空问题。
2019-12-10 适配2.3.29微信客户端，消息撤回逻辑问题得以修复。
2019-12-04 适配OSX10.14.6，修复翻译问题，增加AI自动聊天。
2019-11-16 将安装包从17.7MB瘦身到2.6MB，没有"科学上网"的同学大大加快安装更新速度，提升人民幸福感。
2019-11-14 修复多选会话后批量删除闪退。
2019-11-01 修复Alfred头像不显示问题。
2019-10-28 优化英文系统下的文案。
2019-08-07 修复联系人信息获取接口改变导致自动回复和Alfred的大面积闪退，sorry。新增自动下载聊天高清图功能。
2019-07-26 适配2.3.26版本，修复闪退，屏蔽更新。
2019-07-10 修复清除空会话闪退。
2019-06-28 修复消息筛选Bug，群聊撤回同步到手机显示真实联系人昵称。
2019-06-25 适配OSX 10.9。
2019-06-25 消息防撤回同步到手机，增加筛选功能，可以只同步群聊或单聊。
2019-06-19 详细安装方法。
2019-06-05 修复会话多选闪退，点击公众号类型消息闪退。
2019-05-28 支持系统浏览器打开网页。
2019-05-14 如果Mac拦截到A发送来的消息，手机也会同步收到的这条已经拦截的消息，小助手一键更新。
2019-05-10 目前更新还很不方便，稍后会加入更加方便的一键更新。
2019-05-10 现在在最新版的微信中的多开和消息撤回是可以用的，如果不能用，请检查小助手的版本。

```

## TO DO
- BigSur引用消息或许会Crash（未复现）。

## Contributors

This project exists thanks to all the people who contribute。
<a href="https://github.com/MustangYM/WeChatExtension-ForMac/graphs/contributors"><img src="https://opencollective.com/mustangym666/contributors.svg?width=890&button=false" /></a>

## 感谢捐赠者 Thank you to all our backers! 🙏 [[Become a backer](https://opencollective.com/mustangym666#backer)]
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
  
</td></tr></table>

<table><tr>
 
   <td align="center">
  <a href="https://github.com/imjonat"><img src="https://avatars0.githubusercontent.com/u/42567368?s=400&v=4" width="100px;" alt="imjonat"/>
  <br></br><sub><b>imjonat</b></sub>
  
   <td align="center">
  <a href="https://github.com/reinstallsys"><img src="https://avatars3.githubusercontent.com/u/5747138?s=400&v=4" width="100px;" alt="reinstallsys"/>
  <br></br><sub><b>reinstallsys</b></sub>
  
   <td align="center">
  <a href="https://github.com/snowdreams1006"><img src="https://avatars1.githubusercontent.com/u/23238267?s=400&v=4" width="100px;" alt="snowdreams1006"/>
  <br></br><sub><b>snowdreams1006</b></sub>
 
   <td align="center">
    <a href="https://github.com/lvsijian8"><img src="https://avatars0.githubusercontent.com/u/19362089?s=400&v=4" width="100px;" alt="lvsijian8"/>
  <br></br><sub><b>lvsijian8</b></sub>    
 
   <td align="center">
  <a href="https://github.com/TheColdVoid"><img src="https://avatars2.githubusercontent.com/u/10008227?s=400&v=4" width="100px;" alt="TheColdVoid"/>
  <br></br><sub><b>TheColdVoid</b></sub>   
 
</td></tr></table>

 <table><tr>
 
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
  
 </td></tr></table>
 
  <table><tr>
 
  <td align="center">
  <a href="https://github.com/greatpie"><img src="https://avatars2.githubusercontent.com/u/8511143?s=400&u=813b0bbae8b04034e37b8d45298c5e004de515bf&v=4" width="100px;" alt="greatpie"/>
  <br></br><sub><b>greatpie</b></sub>
 
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
 
  </td></tr></table>
  
  
  <table><tr>
 
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
 
   <td align="center">
  <a href="https://github.com/AhQi7"><img src="https://avatars0.githubusercontent.com/u/46393078?s=400&v=4" width="100px;" alt="AhQi7"/>
  <br></br><sub><b>AhQi7</b></sub>
 
  </td></tr></table>

  <table><tr>
 
   <td align="center">
  <a href="https://github.com/caoxinjava001"><img src="https://avatars3.githubusercontent.com/u/4892867?s=400&u=0ad501d30873d872971e8c4cd941f6e40c5f02ea&v=4" width="100px;" alt="caoxinjava001"/>
  <br></br><sub><b>caoxinjava001</b></sub>
 
   <td align="center">
  <a href="https://github.com/Whatsmine"><img src="https://avatars2.githubusercontent.com/u/39985040?s=400&v=4" width="100px;" alt="Whatsmine"/>
  <br></br><sub><b>Whatsmine</b></sub>
 
   <td align="center">
  <a href="https://github.com/orangeclassmate"><img src="https://avatars0.githubusercontent.com/u/34773757?s=400&u=9c4b3457256daded0326ba87b3ef129b0f69ee17&v=4" width="100px;" alt="orangeclassmate"/>
  <br></br><sub><b>orangeclassmate</b></sub>
 
 
   <td align="center">
  <a href="https://github.com/yorfir"><img src="https://avatars1.githubusercontent.com/u/7101507?s=400&u=11080c0830a870dcab91948149445565bc187da9&v=4" width="100px;" alt="yorfir"/>
  <br></br><sub><b>yorfir</b></sub>
 
   <td align="center">
  <a href="https://github.com/isyntop"><img src="https://avatars1.githubusercontent.com/u/20900723?s=400&u=a1e6d392f55a5d5b180535277b1020bf17f7e217&v=4" width="100px;" alt="isyntop"/>
  <br></br><sub><b>isyntop</b></sub>
 
  </td></tr></table> 
   <table><tr>
 
   <td align="center">
  <a href="https://github.com/baymax-c"><img src="https://avatars2.githubusercontent.com/u/62831888?s=400&v=4" width="100px;" alt="baymax-c"/>
  <br></br><sub><b>baymax-c</b></sub>
 
   <td align="center">
  <a href="https://github.com/cnlinjie"><img src="https://avatars1.githubusercontent.com/u/3601638?s=400&u=fa07b0ab31f248e87687ad587ba7af0f23f8ffc7&v=4" width="100px;" alt="cnlinjie"/>
  <br></br><sub><b>cnlinjie</b></sub>
 
   <td align="center">
  <a href="https://github.com/befuture"><img src="https://avatars2.githubusercontent.com/u/2246922?s=400&v=4" width="100px;" alt="befuture"/>
  <br></br><sub><b>befuture</b></sub>
 
  <td align="center">
  <a href="https://github.com/crbee"><img src="https://avatars2.githubusercontent.com/u/18109072?s=400&v=4" width="100px;" alt="crbee"/>
  <br></br><sub><b>crbee</b></sub>
 
   <td align="center">
  <a href="https://github.com/elrond-g"><img src="https://avatars2.githubusercontent.com/u/6926269?s=400&v=4" width="100px;" alt="elrond-g"/>
  <br></br><sub><b>elrond-g</b></sub>
 
  </td></tr></table>


  </td></tr></table> 
   <table><tr>
 
   <td align="center">
  <a href="https://github.com/feicun2"><img src="https://avatars1.githubusercontent.com/u/18099292?s=400&v=4" width="100px;" alt="feicun2"/>
  <br></br><sub><b>feicun2</b></sub>
 
   <td align="center">
  <a href="https://github.com/linvaux"><img src="https://avatars2.githubusercontent.com/u/33976489?s=400&u=27f32d8834a2f087c045115a30a9a7561e06fbac&v=4" width="100px;" alt="linvaux"/>
  <br></br><sub><b>linvaux</b></sub>
 
   <td align="center">
  <a href="https://github.com/blackux"><img src="https://avatars0.githubusercontent.com/u/29528771?s=400&u=c84394df6e33d6238d4222425ff32da093e4b44b&v=4" width="100px;" alt="blackux"/>
  <br></br><sub><b>blackux</b></sub>
 
   <td align="center">
  <a href="https://github.com/Qwenjin"><img src="https://avatars1.githubusercontent.com/u/15087970?s=400&u=2007a686733e6620b5dc93c8bb9153060be1cb9e&v=4" width="100px;" alt="Qwenjin"/>
  <br></br><sub><b>Qwenjin</b></sub>
 
   <td align="center">
  <a href="https://github.com/mritd"><img src="https://avatars1.githubusercontent.com/u/13043245?s=400&u=d8a792673e23bb2fad29cdde25a45a60dda2db96&v=4" width="100px;" alt="mritd"/>
  <br></br><sub><b>mritd</b></sub>
 
  </td></tr></table>
  
  
   </td></tr></table> 
   <table><tr>
 
   <td align="center">
  <a href="https://github.com/hsing0527"><img src="https://avatars0.githubusercontent.com/u/57891696?s=400&u=994b194f51551cfa5f4cd4282462ec8d6c258455&v=4" width="100px;" alt="hsing0527"/>
  <br></br><sub><b>hsing0527</b></sub>
 
   <td align="center">
  <a href="https://github.com/rodren-lion"><img src="https://avatars0.githubusercontent.com/u/60810175?s=400&v=4" width="100px;" alt="rodren-lion"/>
  <br></br><sub><b>rodren-lion</b></sub>
 
   <td align="center">
  <a href="https://github.com/aleecy"><img src="https://avatars0.githubusercontent.com/u/15871392?s=400&u=14ae820927d89cc2158501f8e37ec8b6c11abbd6&v=4" width="100px;" alt="aleecy"/>
  <br></br><sub><b>aleecy</b></sub>
 
 
   <td align="center">
  <a href="https://github.com/eyaeya"><img src="https://avatars2.githubusercontent.com/u/5821137?s=400&u=800fceb32aa9e06c3c5a9ab4ae03c8134fe17ce9&v=4" width="100px;" alt="eyaeya"/>
  <br></br><sub><b>eyaeya</b></sub>
 
   <td align="center">
  <a href="https://github.com/qierkang"><img src="https://avatars1.githubusercontent.com/u/17940151?s=400&u=ccdfdd11ec900348811f8eefed8f16d80a801daa&v=4" width="100px;" alt="qierkang"/>
  <br></br><sub><b>qierkang</b></sub>
 
  </td></tr></table>
  
   </td></tr></table> 
   <table><tr>
 
   <td align="center">
  <a href="https://github.com/MrPlusZhao"><img src="https://avatars0.githubusercontent.com/u/12454104?s=400&u=5ee35a4f3fdc25ada91a0921220171cb40fe458a&v=4" width="100px;" alt="MrPlusZhao"/>
  <br></br><sub><b>MrPlusZhao</b></sub>
 
   <td align="center">
  <a href="https://github.com/onekb"><img src="https://avatars2.githubusercontent.com/u/16450084?s=400&u=0c1b4e4a48e29316be699adb10c2a5c294dccd76&v=4" width="100px;" alt="onekb"/>
  <br></br><sub><b>onekb</b></sub>
 
   <td align="center">
  <a href="https://github.com/pictureye"><img src="https://avatars1.githubusercontent.com/u/13998802?s=400&u=436fbdc6406b51ab87f4f6738b68b877755b0e7c&v=4" width="100px;" alt="pictureye"/>
  <br></br><sub><b>pictureye</b></sub>
 
   <td align="center">
  <a href="https://github.com/uncleYiba"><img src="https://avatars1.githubusercontent.com/u/26616828?s=400&u=344142a2a1b519c4d52545f3e733d04fd88df069&v=4" width="100px;" alt="uncleYiba"/>
  <br></br><sub><b>uncleYiba</b></sub>
 
   <td align="center">
  <a href="https://github.com/xvalerian"><img src="https://avatars2.githubusercontent.com/u/43782518?s=400&v=4" width="100px;" alt="xvalerian"/>
  <br></br><sub><b>xvalerian</b></sub>
 
   </td></tr></table>
   
   </td></tr></table> 
   <table><tr>
   
   <td align="center">
  <a href="https://github.com/SatanZS"><img src="https://avatars0.githubusercontent.com/u/8230677?s=400&u=0a628322a190b1c1c87f033290ea32568ea33342&v=4" width="100px;" alt="SatanZS"/>
  <br></br><sub><b>SatanZS</b></sub>
  
   <td align="center">
  <a href="https://github.com/huiyi0521"><img src="https://avatars1.githubusercontent.com/u/25707915?s=400&v=4" width="100px;" alt="huiyi0521"/>
  <br></br><sub><b>huiyi0521</b></sub>
  
   <td align="center">
  <a href="https://github.com/findyou"><img src="https://avatars3.githubusercontent.com/u/6084594?s=400&u=859774b13ae172e04894150094211ed2239cfec9&v=4" width="100px;" alt="findyou"/>
  <br></br><sub><b>findyou</b></sub>
 
   </td></tr></table>
  
   </td></tr></table>

<a href="https://opencollective.com/mustangym666#backers" target="_blank"><img src="https://opencollective.com/mustangym666/backers.svg?width=890"></a>

## 交流
- QQ①群：`741941325`(满)。
- QQ②群：`905526964`(满)。
- QQ③群：`220655053`。
- 皮肤的颜色搭配采纳了大量朋友的反馈和建议，最终并未能统一意见，那就干脆做`两套`吧，所以才会出现`黑夜`和`深邃`两款如此相近的`暗色调主题`，所以颜色上不再接受pr。
- 封面图的`骷髅`与`乌鸦`元素来自于`史泰龙`的电影`《The Expendables》`（敢死队）海报。
- 插件中的`图标`、本页所有`Logo`、预览图均出自本人`蹩脚`的[Photoshop](https://www.adobe.com/products/photoshop.html)设计。
- 如果小助手使你的生活更美好，可以`请我喝杯咖啡`。

<img src="https://gitee.com/MustangYM/we-chat-extension-source/raw/master/Pictures/aliPayCode.png" height="250" hspace="50"/>&nbsp;&nbsp;&nbsp;<img src="https://gitee.com/MustangYM/we-chat-extension-source/raw/master/Pictures/WeChatPayCode.png" height="250" hspace="50"  />

## Special Thanks
- [WeChatPlugin-MacOS](https://github.com/TKkk-iOSer/WeChatPlugin-MacOS)
- [insert_dylib](https://github.com/Tyilo/insert_dylib)
- [fishhook](https://github.com/facebook/fishhook)
- [Alfred](https://www.alfredapp.com/)
- [GCDWebServer](https://github.com/swisspol/GCDWebServer)
- [TCBlobDownload](https://github.com/thibaultcha/TCBlobDownload)
- [ANYMethodLog](https://github.com/qhd/ANYMethodLog)

## License
<a href="LICENSE"><img src="https://img.shields.io/github/license/fstudio/clangbuilder.svg"></a>
<a href="https://996.icu"><img src="https://img.shields.io/badge/link-996.icu-red.svg"></a>

本项目遵循`MIT license`，方便交流与学习，包括但不限于本项目的衍生品都禁止在损害WeChat官方利益情况下进行盈利。如果您发现本项目有侵犯您的知识产权，请与我取得联系，我会及时修改或删除。

