# hw8-homework-in-meteor

老师or学生？
系统默认用户名 admin 为老师，其余均为学生。
老师进入系统可以查看所有同学的作业提交情况。
页面中有三个文本框，分别是输入分数，deadLine，已经作业要求。
评分的方法
 username|score
例如 学生 aaaa，分数是99
 aaaa|99
提交是使用的是回车。

学生进入系统，只会看到自己的作业提交情况，并且可以提交作业。
作业保存在服务器的home文件夹的upload中。

老师和学生进入页面都能看到deadline和requirements