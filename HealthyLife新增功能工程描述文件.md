v1.1.0

自定义任务功能
新增功能

自定义任务名称：编辑任务时可修改任务名称（如将"早起"改为"晨跑"），留空则使用默认名称。名称持久化到数据库，在任务列表、打卡弹窗等所有界面同步显示。
灵活时间设置：时间类任务（早起、早睡）不再限制在固定时间范围，可从 00:00 至 23:59 任意选择目标时间。
技术变更

TaskInfo 模型新增 customName 字段
taskInfo 表新增 customName 列，旧数据库自动迁移
HomeStore 新增 taskNameMap 统一管理自定义名称显示
TargetSettingDialogParams TimePicker 范围扩展为全天

v1.2.0

新增功能

任务删除：编辑任务页底部新增删除按钮，可删除不需要的任务。删除后任务从首页和添加列表消失，已打卡的当日数据同步清理。
新增功能（v1.1.0）

自定义任务名称：编辑任务时可修改任务名称，留空使用默认名称，所有界面同步显示。
灵活时间设置：时间类任务可从 00:00 至 23:59 任意选择目标时间。
技术变更

TaskInfo 模型新增 customName 字段，数据库自动迁移
HomeStore 新增 taskNameMap 统一管理自定义名称显示
PreferencesUtils 新增已删除任务 ID 存取方法
checkDefaultTask() 跳过已删除任务，不再自动补回
TargetSettingDialogParams TimePicker 范围扩展为全天

v1.3.0

完成按钮改为蓝色
移除任务开关，点击完成即添加任务到首页
完成按钮蓝色 — EditTaskComponent.ets 第 258 行 .backgroundColor() 从 $r('sys.color.button_background_color_transparent') 改为 '#3377FF'。

移除开关 — EditTaskComponent.ets：删除整个 Toggle Row（原第 192-215 行）；finishTaskEdit() 从 60 行简化为 30 行，移除打开/关闭分支，改为始终设 isOpen = true，先调 openTask() 再 update()，最后同步 DayTaskInfo 和提醒。targetValueStyle() 去掉 isOpen 参数。

v1.40

CommonConstants.ets — 新增 PICKER_RANGE_TIMES（1-20 的字符串数组）
TaskBaseModel.ets — 微笑（taskId=3）、刷牙（taskId=4）的 pickerType 从 NONE 改为 TEXT，step 从 0 改为 1，pickerRange 设为 1-20
效果：这两个任务编辑页出现下拉菜单可选 1-20 次，每次打卡累加 1，达到目标次数后标记完成。默认目标仍为 1 次。

v1.5.0

首页背景图支持长按替换：在顶部区域长按 0.8 秒可从系统相册选择图片作为自定义背景，图片 URI 持久化存储，重启后保留，未设置时使用默认背景。

v1.5.1

修复删除任务后首页仍显示的 bug（closeTask 后未同步本地 isOpen 状态导致被 update 覆盖）

v1.60~1.63

新增历史记录页（"我的"→历史记录），按日期展示每天完成的任务名称及实时打卡时间
头像支持长按从相册替换
昵称支持长按编辑
"个人资料"改为"个性签名"，支持长按编辑
任务打卡时自动记录完成时刻（finishTime），持久化到 dayTaskInfo 表

v1.7.0 — 平板适配

module.json5 新增 tablet 设备类型
新增 tablet/element/float.json 平板资源文件（字体、间距约 1.5x 缩放）
HealthyLifePage 新增 BreakpointSystem 断点检测，窗口尺寸变化自动更新
WeekCalendarComponent 滚动阈值改为根据屏幕宽度动态计算
HomeTopComponent 背景改为 Image + ImageFit.Cover，平板固定高度 300vp
MineComponent 移除嵌套 Navigation，行宽改为 100% 居中布局
各页面内容超长时显示滚动条可上下滑动

v1.80-自由流转

对于同一账号，手机端和平板端共享任务进度，历史记录和成就
