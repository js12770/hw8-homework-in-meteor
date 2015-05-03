- 关于deadline
    - deadline前
        - Teacher可以修改作业的title, details, deadline, 不能修改作业
        - Student可以提交作业
    - deadline后
        - Teacher不可以修改作业信息, 可以批改作业
        - Student不能提交作业

- 不支持后退按钮

- 不支持Cookie Session, 页面刷新需要重新登录

- 安全策略
    - 客户端提供表单验证和身份检测
    - 服务端做同样检测但对于非法请求直接拒绝, 不提供任何信息(认为是恶意请求)
