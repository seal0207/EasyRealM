# EasyRealM 一键脚本 小白必备
Realm2 脚本已写好。请自测

v2.0.0 已支持WS WSS TLS

v1.0.7 在@Soniccube 大佬的反馈下，修复realm.service服务导致的断流。

v1.0.6 添加 https://github.com/Soniccube 大佬的修复断流版，目前测下来配置不超过十个同时并发运行，还算稳定。

V1.0.5 增加RealM重启功能，因RealM自身问题,发现RealM 5-8小时会暴毙一次。

V1.0.4 添加国内下载点，添加几个小功能

V1.0.3 增加配置备份、恢复、删除功能

V1.0.2 减少了几处等待时间，修复停止RealM选项

v1.0.1 增加更新脚本功能

v1.0.0 RealM一键脚本问世

增加更新脚本功能，之前写完没测试整体功能单独测试的功能是正常的，导致删除规则中断。


#注意
发现存在规则配置错误一条全部都不生效这个问题。

请仔细添加不要搞错了！

基于RealM转发工具制作的一键脚本，测试环境debian9，其他没试过。

通过测试RealM针对个人用户效果不错，目前转发端口数量多了后会出问题。

![image](https://mxpic.ml/2022/07/14/20220714_c521a336bf1af.png)
## 使用方法
一键脚本：
`wget -N --no-check-certificate https://git.io/realm.sh && chmod +x realm.sh && ./realm.sh`
### 啰嗦一句
1.脚本已取消加密。里头每个功能都注释的很清楚，不存在任何安全问题，请放心使用。添加规则为拼凑的逻辑很烂有大佬愿意指导可以协助修改！~

2.因才接触shell三天，因为写的太烂之前不好意思给大家看选择加密，刚上路不想因为代码写的垃圾被喷打击自信心~

3.软件具体效果以及出现问题啥的请反馈作者 * [issue~](https://github.com/zhboner/realm/issues)

4.软件安装及配置文件路径/etc/realm

5.后续作者更新使用规则不保证继续更新，因为我也是小白！

### RealM作者：
https://zhb.me/realm 

https://github.com/zhboner/realm
