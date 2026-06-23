/*
 *
 *  * Copyright (c) 2025 Huawei Device Co., Ltd.
 *  * Licensed under the Apache License, Version 2.0 (the "License");
 *  * ...
 */

import { CommonConstants as Const, DayInfo, DayTaskInfo, taskBaseInfoList, TaskInfo } from 'common';
import DayInfoApi from 'common/src/main/ets/database/tables/DayInfoApi';
import DayTaskInfoApi from 'common/src/main/ets/database/tables/DayTaskInfoApi';
import TaskInfoApi from 'common/src/main/ets/database/tables/TaskInfoApi';

interface DayHistoryItem {
  date: string;
  targetTaskNum: number;
  finTaskNum: number;
  tasks: DayTaskInfo[];
}

@Builder
export function historyBuilder() {
  HistoryComponent();
}

@Component
export struct HistoryComponent {
  @Consume('pathStack') pageStack: NavPathStack;
  @State historyList: DayHistoryItem[] = [];
  @State taskNameMap: Map<number, string> = new Map();
  @State flag: boolean = false;

  async aboutToAppear(): Promise<void> {
    const taskInfos = await TaskInfoApi.queryAllTaskInfo();
    for (let info of taskInfos) {
      this.taskNameMap.set(info.taskId, info.customName || '');
    }
    const dayInfoList = await DayInfoApi.query('SELECT * FROM dayInfo ORDER BY date DESC');
    for (let day of dayInfoList) {
      const tasks = await DayTaskInfoApi.queryDayTaskInfo(day.date);
      this.historyList.push({
        date: day.date,
        targetTaskNum: day.targetTaskNum,
        finTaskNum: day.finTaskNum,
        tasks: tasks
      });
    }
    this.flag = true;
  }

  getTaskName(taskId: number): ResourceStr {
    const customName = this.taskNameMap.get(taskId);
    if (customName && customName.trim().length > 0) {
      return customName;
    }
    return taskBaseInfoList[taskId].name;
  }

  getTaskResult(item: DayTaskInfo): string {
    const baseInfo = taskBaseInfoList[item.taskId];
    if (item.isDone) {
      if (item.finishTime) {
        return item.finishTime;
      }
      if (baseInfo.unit === '') {
        return item.finValue;
      }
      return `${item.finValue}/${item.targetValue}${baseInfo.unit}`;
    }
    if (baseInfo.unit === '') {
      return `${item.finValue || '--'}`;
    }
    return `${item.finValue || '0'}/${item.targetValue}${baseInfo.unit}`;
  }

  build() {
    NavDestination() {
      if (this.flag) {
        Column() {
          Row() {
            Image($r('app.media.ach_back'))
              .height($r('app.float.default_40'))
              .width($r('app.float.default_40'))
              .margin({ right: $r('app.float.default_8') })
              .onClick(() => { this.pageStack.pop(); })
            Text($r('app.string.history_record'))
              .fontFamily($r(Const.HARMONY_HEI_TI_MEDIUM))
              .fontWeight(FontWeight.Bold)
              .fontColor($r('sys.color.font_primary'))
              .fontSize($r('app.float.default_20'))
              .width(Const.THOUSANDTH_1000)
              .height($r('app.float.default_56'))
          }
          .margin({ left: $r('app.float.default_12'), right: $r('app.float.default_12') })

          if (this.historyList.length === 0) {
            Column() {
              Text($r('app.string.no_history'))
                .fontSize($r('app.float.default_16'))
                .fontColor($r('sys.color.font_secondary'))
                .margin({ top: $r('app.float.default_100') })
            }
            .width(Const.THOUSANDTH_1000)
          } else {
            List() {
              ForEach(this.historyList, (day: DayHistoryItem, index: number) => {
                ListItem() {
                  this.dayCardBuilder(day)
                }
              }, (day: DayHistoryItem) => day.date)
            }
            .width(Const.THOUSANDTH_1000)
            .layoutWeight(1)
          }
        }
        .width(Const.THOUSANDTH_1000)
        .height(Const.THOUSANDTH_1000)
        .backgroundColor($r('sys.color.background_secondary'))
        .padding({ left: $r('app.float.default_10'), right: $r('app.float.default_10') })
      }
    }
    .size({ width: Const.THOUSANDTH_1000, height: Const.THOUSANDTH_1000 })
    .backgroundColor($r('sys.color.background_secondary'))
    .hideTitleBar(true)
    .padding({ top: $r('app.float.default_40') })
  }

  @Builder
  dayCardBuilder(day: DayHistoryItem) {
    Column() {
      Row() {
        Text(day.date)
          .fontWeight(FontWeight.Medium)
          .fontSize($r('app.float.default_16'))
          .fontColor($r('sys.color.font_primary'))

        Blank()

        Text(`${day.finTaskNum}/${day.targetTaskNum} `)
          .fontSize($r('app.float.default_14'))
          .fontColor($r('sys.color.font_primary'))

        Text($r('app.string.was_done'))
          .fontSize($r('app.float.default_12'))
          .fontColor($r('sys.color.font_tertiary'))
      }
      .width(Const.THOUSANDTH_940)
      .padding({ top: $r('app.float.default_12'), bottom: $r('app.float.default_4') })

      Progress({
        value: day.targetTaskNum > 0 ? day.finTaskNum : 0,
        total: day.targetTaskNum > 0 ? day.targetTaskNum : 1,
        type: ProgressType.Linear
      })
        .width(Const.THOUSANDTH_940)
        .height($r('app.float.default_4'))
        .color($r('app.color.text_font_color'))
        .backgroundColor($r('sys.color.background_tertiary'))
        .margin({ bottom: $r('app.float.default_8') })

      ForEach(day.tasks, (item: DayTaskInfo, taskIndex: number) => {
        Row() {
          Image(taskBaseInfoList[item.taskId].icon)
            .width($r('app.float.default_20'))
            .height($r('app.float.default_20'))
            .objectFit(ImageFit.Contain)
            .margin({ right: $r('app.float.default_8') })

          Text(this.getTaskName(item.taskId))
            .fontSize($r('app.float.default_14'))
            .fontColor($r('sys.color.font_primary'))
            .layoutWeight(1)

          Text(this.getTaskResult(item))
            .fontSize($r('app.float.default_14'))
            .fontColor(item.isDone ? $r('app.color.text_font_color') : $r('sys.color.font_tertiary'))
        }
        .width(Const.THOUSANDTH_940)
        .padding({
          top: $r('app.float.default_6'),
          bottom: $r('app.float.default_6'),
          left: $r('app.float.default_4'),
          right: $r('app.float.default_4')
        })
      }, (item: DayTaskInfo, taskIndex: number) => `${taskIndex}`)
    }
    .width(Const.THOUSANDTH_940)
    .borderRadius($r('app.float.default_12'))
    .backgroundColor($r('sys.color.background_primary'))
    .padding({
      left: $r('app.float.default_12'),
      right: $r('app.float.default_12'),
      bottom: $r('app.float.default_8')
    })
    .margin({
      top: $r('app.float.default_6'),
      bottom: $r('app.float.default_6')
    })
  }
}