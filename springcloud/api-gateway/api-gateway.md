# 分布式服务

[Roses](https://gitee.com/naan1993/roses/tree/master)

模块名称 | 说明 | 端口 | 备注
:---:|:---:|:---:|:----:
roses-api | 服务接口和model | 无 | 封装所有服务的接口，model，枚举等
roses-core | 项目骨架 | 无 | 封装框架所需的基础配置，工具类和运行机制等
roses-scanner | 资源扫描器 | 无 | 接口资源无须录入，启动即可录入系统
roses-register | 注册中心 | 8761 | eureka注册中心
roses-gateway | 网关 | 8000 | 转发，资源权限校验，请求号生成等
roses-auth | 鉴权服务 | 8001 | 提供用户，资源，权限等接口
roses-config | 配置中心服务器 | 8002 | 配置集中管理
roses-logger | 日志服务 | 8003 | 消费并存储日志
roses-monitor | 监控中心 | 9000 | 监控服务运行状况
roses-message-service | 消息服务 | 9001 | 可靠消息最终一致性（柔性事务解决方案）
roses-message-checker | 消息恢复和消息状态确认子系统 | 9002 | 可靠消息最终一致性（柔性事务解决方案）
roses-example-order | 订单服务 | 9003 | 演示如何解决分布式事务
roses-example-account | 账户服务 | 9004 | 演示如何解决分布式事务
