# 云平台一键启停脚本

### 说明
部署单元 | 应用系统 | 执行用户名 | 正常处理方式 | 异常处理方式 | 超时时间间(s) | $1 | $2 | 文件名
---------|----------|------------|--------------|--------------|---------------|----|-----|--------
BTFL3_AP | 金融应用服务 | blockchain | 继续执行 |    | 100 | start/stop/status | fft/xyz/plugin/factor | [BTFL3_AP_SERVICE.sh]
BTFN1_AP | 队列 | blockchain | 继续执行 |    | 100 | start/stop |                       | [BTFN1_AP_SERVICE.sh]
BTFN2_AP | 排序 | blockchain | 继续执行 |    | 100 | start/stop |                       | [BTFN2_AP_SERVICE.sh]
BTFN3_AP | 对等 | blockchain | 继续执行 |    | 100 | start/stop |                       | [BTFN3_AP_SERVICE.sh]
BTFN4_AP | 仲裁 | blockchain | 继续执行 |    | 100 | start/stop |                       | [BTFN4_AP_SERVICE.sh]
BTFN5_AP | Mongo-shard1 | blockchain | 继续执行 |    | 100 | start/stop |                       | [BTFN5_AP_SERVICE.sh]
BTFN6_AP | Mongo-config | blockchain | 继续执行 |    | 100 | start/stop |                       | [BTFN6_AP_SERVICE.sh]
BTFN7_AP | Mongo-router | blockchain | 继续执行 |    | 100 | start/stop |                       | [BTFN7_AP_SERVICE.sh]
BTFN8_AP | Mongo-shard2 | blockchain | 继续执行 |    | 100 | start/stop |                       | [BTFN8_AP_SERVICE.sh]
BTFN9_AP | Mongo-shard3 | blockchain | 继续执行 |    | 100 | start/stop |                       | [BTFN9_AP_SERVICE.sh]
BTFO1_AP | API | blockchain | 继续执行 |    | 100 | start/stop |  | [BTFO1_AP_SERVICE.sh]
BTFO2_AP | 保险箱 | blockchain | 继续执行 |    | 100 | start/stop/status | hbcc_cloud/hbcc_agent/hbcc_processers | [BTFO2_AP_SERVICE.sh]
BTFO3_AP | 链块加速 | blockchain | 继续执行 |    | 100 | start/stop |  | [BTFO3_AP_SERVICE.sh]
BTFO4_AP | 缓存 | blockchain | 继续执行 |    | 100 | start/stop |  | [BTFO4_AP_SERVICE.sh]
BTFO5_AP | MQ | blockchain | 继续执行 |    | 100 | start/stop/status |  | [BTFO5_AP_SERVICE.sh]
BTFWB_AP | 金融应用前置 | blockchain | 继续执行 |    | 100 | start/stop |  | [BTFWB_AP_SERVICE.sh]
BTFX1_WB | 外网HAPROXY | haproxy | 继续执行 |    | 100 | start/stop |  | [BTFX1_WB_SERVICE.sh]
BTFX2_WB | 内网HAPROXY | haproxy | 继续执行 |    | 100 | start/stop |  | [BTFX2_WB_SERVICE.sh]

[BTFL3_AP_SERVICE.sh]: BTFL3_AP_SERVICE.sh
[BTFN1_AP_SERVICE.sh]: BTFN1_AP_SERVICE.sh
[BTFN2_AP_SERVICE.sh]: BTFN2_AP_SERVICE.sh
[BTFN3_AP_SERVICE.sh]: BTFN3_AP_SERVICE.sh
[BTFN4_AP_SERVICE.sh]: BTFN4_AP_SERVICE.sh
[BTFN5_AP_SERVICE.sh]: BTFN5_AP_SERVICE.sh
[BTFN6_AP_SERVICE.sh]: BTFN6_AP_SERVICE.sh
[BTFN7_AP_SERVICE.sh]: BTFN7_AP_SERVICE.sh
[BTFN8_AP_SERVICE.sh]: BTFN8_AP_SERVICE.sh
[BTFN9_AP_SERVICE.sh]: BTFN9_AP_SERVICE.sh
[BTFO1_AP_SERVICE.sh]: BTFO1_AP_SERVICE.sh
[BTFO2_AP_SERVICE.sh]: BTFO2_AP_SERVICE.sh
[BTFO3_AP_SERVICE.sh]: BTFO3_AP_SERVICE.sh
[BTFO4_AP_SERVICE.sh]: BTFO4_AP_SERVICE.sh
[BTFO5_AP_SERVICE.sh]: BTFO5_AP_SERVICE.sh
[BTFWB_AP_SERVICE.sh]: BTFWB_AP_SERVICE.sh
[BTFX1_WB_SERVICE.sh]: BTFX1_WB_SERVICE.sh
[BTFX2_WB_SERVICE.sh]: BTFX2_WB_SERVICE.sh
