# My Homework

## DESCRIPTION
基于Meteor与MaterializeCSS的简单的作业发布作业提交网站（SPA）。

## ENVIRONMENT

* Linux 运行环境
* Meteor Latest Version

## HOW TO BUILD&RUN

```bash
$ cd 13331131
$ meteor run
```
## ADDITION

* 时间比较仓促，部分功能未完善。
* 已完成作业发布，提交，注册，登录，文件上传下载等基本功能。
* 未完成较为细的东西，如表单验证、判重等等。
* 与之前的众多框架相比，Meteor将开发者的工作再次降低到新的高度，开发效率是其他框架不能比的。首先Meteor本身就是用于开发SPA的框架，另外第三方的包使得开发更加方便，例如`iron:router`这个包利用HistoryAPI解决了SPA中的URL问题。第二是Meteor自动加载模块，也就不需要像BrowserifyJS或者RequireJS中那样加载了(require)，当然也会带来一些小问题，例如假设项目目录下有一个用于保存上传文件的文件夹，一旦用户上传了JS文件，就会被自动加载，因此会发生危险。（应该有方法避免）。最后是简化了前后端交互，不同以往的前端写代码发请求到后台请求数据，再操作数据库，在Meteor中，前端甚至可以直接操作数据库，短短的几行代码就解决了以往大段代码解决的问题。