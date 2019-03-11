### calico

`calico依赖etcd在不同主机间共享和交换信息，存储calico网络状态。calico网络中每个主机都要运行calico组件，提供容器interface管理，动态路由，动态ACL,报告状态等功能`

```
curl -L https://github.com/projectcalico/calicoctl/releases/download/v3.1.5/calicoctl > /usr/local/bin/calicoctl
```