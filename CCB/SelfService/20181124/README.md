# 自服务脚本
**变更日期： 2018年11月24日**

### 脚本说明

**脚本内有注释，运行前可查看脚本注释**

根据行内自服务规范，依次按步骤运行脚本

1. 版本获取
   - 根据输入参数获取版本包到目标主机`$HOME/app_temp`下，并将变更步骤所需的执行脚版本包`dist_shell`目录下的脚本和备份文件列表释放至主机`$HOME/bin/dist_shell`目录下，版本内其他内容不会进行分发。
   - 根据备份文件列表`backup.list`(如版本包中存在)自动进行备份，如无按`cfg`文件配置的分发路径进行备份
   - 输入参数规则同现有云平台自动化流程

2. [app_stop.sh]： 应用停止`通用`
   - 本步执行停止用户内应用服务
   - 可根据需要输入参数对指定应用部分进行停止；若无输入参数时，表示对用户内全部应用进行停止

3. [version_backup.sh]： 版本备份`通用`
   - 本步用于对变更内容进行提前备份，需对该用户所有涉及的变动内容进行备份，以保障能够有效进行变更回退

4. [update_before_dist.sh]： 版本发布前-执行脚本`通用`（数据库备份）
   - 本步用于在版本发布前，执行所需的变更动作
   - 一般用于必须在应用停止后，新版本发布前需进行的数据备份、配置升级等操作

5. 版本发布： 云平台提供功能，无需提供脚本
   - 本步将根据版本包对应的cfg文件，对版本内容进行分发部署
   - 无需要输入参数

6. [update_after_dist.sh]：版本发布后-执行脚本；本次修改Plugin配置
   - 本步将在版本发布后，执行用户所需的变更动作
   - 一般用于在版本发布后需要执行的变更操作，如：对分发的版本进行必要处理

7. [update_before_start.sh]： 应用启动前-执行脚本；本次变更**RabitMQ**`mirror`策略
   - 该环节将在应用启动前执行用户所需的变更动作
   - 一般用于执行在应用启动需要执行的变更操作，如清理缓存、数据库更新操作等

8. [app_start.sh]： 应用启动`通用`
   - 本步执行用户应用服务启动
   - 可根据需要输入参数对指定应用部分进行启动；若无输入参数时，表示对用户内全部应用进行启动

9. [update_after_start.sh]： 应用启动后执行；本次修改`BTFX1_WB``/etc/hosts`，为绿灯测试前置脚本，需`root`权限！
   - 本步用于在应用启动后，执行所需的变更动作
   - 一般执行未包含在启动脚本中的对外发布服务操作

10. [version_check.sh]： 版本检查`通用`
    - 本步主要进行变更后版本检查，以确认版本部署符合预期
    - 通常以检查版本号、配置文件、部署程序方式进行。

11. [greenlight.sh]： 绿灯测试`通用`
    - 本步负责在变更完成后发起绿灯测试检查，以确认应用服务正常

12. 健康检查： 标准通用操作，无需提供脚本
    - 本步执行通用应用健康检查，检查进程、监听端口是否符合历史基线
    - 无需输入参数

[app_stop.sh]: app_stop.sh
[app_start.sh]: app_start.sh
[BTFX1_WB_HOSTS.sh]: BTFX1_WB_HOSTS.sh
[greenlight.sh]: greenlight.sh
[MongoCert_Backup.sh]: MongoCert_Backup.sh
[MongoFastchain_Backup.sh]: MongoFastchain_Backup.sh
[update_before_dist.sh]: update_before_dist.sh
[update_after_dist.sh]: update_after_dist.sh
[update_before_start.sh]: update_before_start.sh
[version_backup.sh]: version_backup.sh
[version_check.sh]: version_check.sh
[update_after_start.sh]: update_after_start.sh