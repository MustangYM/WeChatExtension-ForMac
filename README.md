
<p align="center">
<img src="https://github.com/MustangYM/WeChatExtension-ForMac/blob/master/WeChatExtension/Rely/Pictures/face.png" width="1000px"/>
</p>

## 声明
> 适用于Mac版的WeChat拓展功能, 由于之前大家常用的WeChatPlugin在默认分支切换成remove删库了, 坊间猜测原因, 众说纷纭, 我们不去深究了.
本着开源的精神, 我决定继续维护这个项目, 对[tk](https://github.com/TKkk-iOSer)在此表示感谢!

## 最新支持版本
>  mac版微信2.3.25

## 手机端也能收到被撤回的消息
1. > 如果Mac拦截到A发送来的消息, 手机也会同步收到的这条已经拦截的消息(自己发送给自己). 目前只支持同步文字消息与图片消息, 其他类型也可以做, 但意义不大.
<p align="center">
<img src="https://github.com/MustangYM/WeChatExtension-ForMac/blob/master/WeChatExtension/Rely/Pictures/revokeAsync.jpg" width="800px"/>
</p>

2. > 可以对同步的消息进行筛选, 以免群消息打扰
<p align="center">
<img src="https://github.com/MustangYM/WeChatExtension-ForMac/blob/master/WeChatExtension/Rely/Pictures/WX20190625-111206%402x.png" width="600px"/>
</p>

## 免认证登录与多开
<p align="center">
<img src="https://github.com/MustangYM/WeChatExtension-ForMac/blob/master/WeChatExtension/Rely/Pictures/launch.gif" width="800px"/>
</p>

## 消息防撤回
<p align="center">
<img src="https://github.com/MustangYM/WeChatExtension-ForMac/blob/master/WeChatExtension/Rely/Pictures/revoke.gif" width="800px"/>
</p>

## 安装方法
1. > 确保你的Mac上已经安装了微信App.

2. > 下载本项目到你的电脑里, 并双击打开.
<p align="center">
<img src="https://github.com/MustangYM/WeChatExtension-ForMac/blob/master/WeChatExtension/Rely/Pictures/WX20190619-112238.png" width="800px"/>
</p>

3. > 依次打开文件夹
<p align="center">
<img src="https://github.com/MustangYM/WeChatExtension-ForMac/blob/master/WeChatExtension/Rely/Pictures/WX20190619-113413%402x.png" width="800px"/>
</p>

4. > 打开你电脑中的终端工具
<p align="center">
<img src="https://github.com/MustangYM/WeChatExtension-ForMac/blob/master/WeChatExtension/Rely/Pictures/WX20190619-113911%402x.png" width="800px"/>
</p>

2. > 在Rely/Install.sh执行这个安装脚本
<p align="center">
<img src="https://github.com/MustangYM/WeChatExtension-ForMac/blob/master/WeChatExtension/Rely/Pictures/QQ20190425-155120%402x.png" width="800px"/>
</p>

3. > 重启微信, 安装完成.

## 怎么卸载?
1. > 在Rely文件夹中找到Uninstall.sh
2. > 拖到终端工具中, 回车执行即可
<p align="center">
<img src="https://github.com/MustangYM/WeChatExtension-ForMac/blob/master/WeChatExtension/Rely/Pictures/WX20190625-102808%402x.png" width="800px"/>
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
  
</td></tr></table>

## 更新日志
```
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

## 维护不易, 可以请我喝咖啡
>捐赠的朋友请在支付宝留言留下你的GitHub，如果你愿意，我会把你的头像和昵称列在“捐赠墙”上。

<p align="center">
<img src="https://github.com/MustangYM/WeChatExtension-ForMac/blob/master/WeChatExtension/Rely/Pictures/WX20190625-152059%402x.png" width="300px"/>
</p>
