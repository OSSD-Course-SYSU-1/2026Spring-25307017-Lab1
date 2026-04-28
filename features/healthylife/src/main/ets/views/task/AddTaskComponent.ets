/*
 *
 *  * Copyright (c) 2025 Huawei Device Co., Ltd.
 *  * Licensed under the Apache License, Version 2.0 (the "License");
 *  * you may not use this file except in compliance with the License.
 *  * You may obtain a copy of the License at
 *  *
 *  *     http://www.apache.org/licenses/LICENSE-2.0
 *  *
 *  * Unless required by applicable law or agreed to in writing, software
 *  * distributed under the License is distributed on an "AS IS" BASIS,
 *  * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 *  * See the License for the specific language governing permissions and
 *  * limitations under the License.
 *
 */

import TaskInfoApi from 'common/src/main/ets/database/tables/TaskInfoApi';
import { CommonConstants as Const, taskBaseInfoList, TaskInfo } from 'common';

@Builder
export function addTaskBuilder(_name: string, _param: ESObject) {
  AddTaskComponent();
}

@Component
export struct AddTaskComponent {
  @Consume('pathStack') pageStack: NavPathStack;
  @State taskList: TaskInfo[] = [];
  @State flag: boolean = false;
  @State customTaskName: string = '';
  @State showCustomDialog: boolean = false;

  async aboutToAppear(): Promise<void> {
    this.taskList = await TaskInfoApi.queryAllTaskInfo();
    this.flag = true;
  }

  build() {
    NavDestination() {
      if (this.flag) {
        Column({
          space: $r('app.float.default_12')
        }) {
          // 自定义任务按钮
          this.customTaskBuilder()
          
          ForEach(this.taskList, (item: TaskInfo, index: number) => {
            this.taskInfoBuilder(item, index)
          }, (item: TaskInfo, index: number) => index + JSON.stringify(item))
        }
        .width(Const.THOUSANDTH_940)
        .justifyContent(FlexAlign.Center)
        .margin($r('app.float.default_8'))
      }
    }
    .size({
      width: Const.THOUSANDTH_1000,
      height: Const.THOUSANDTH_1000
    })
    .backgroundColor($r('sys.color.background_secondary'))
    .title($r('app.string.add_task'))
    .padding({
      top: $r('app.float.default_40'),
      left:$r('app.float.default_6'),
      right:$r('app.float.default_6')
    })
  }

  @Builder
  customTaskBuilder() {
    Row() {
      Image($r('app.media.ic_home_add'))
        .width($r('app.float.default_24'))
        .height($r('app.float.default_24'))
        .objectFit(ImageFit.Contain)
        .margin({
          right: $r('app.float.default_8')
        })

      Text($r('app.string.custom_task'))
        .fontColor($r(`sys.color.font_primary`))
        .fontSize($r('app.float.default_18'))

      Blank();

      SymbolGlyph($r('sys.symbol.chevron_right'))
        .fontColor([$r('sys.color.icon_secondary')])
        .fontWeight(FontWeight.Normal)
        .fontSize($r('app.float.default_28'))
    }
    .width(Const.THOUSANDTH_1000)
    .height(Const.THOUSANDTH_80)
    .borderRadius($r('app.float.default_16'))
    .padding({
      left: $r('app.float.default_12'),
      right: $r('app.float.default_12')
    })
    .backgroundColor($r('sys.color.background_primary'))
    .onClick(() => {
      this.showCustomDialog = true;
    })
    .bindSheet($$this.showCustomDialog, this.customTaskSheetBuilder(), {
      height: 280,
      backgroundColor: $r('sys.color.background_primary'),
      dragBar: false
    })
  }

  @Builder
  customTaskSheetBuilder() {
    Column() {
      Text($r('app.string.add_custom_task'))
        .fontSize($r('app.float.default_20'))
        .fontWeight(FontWeight.Bold)
        .margin({ top: 24, bottom: 20 })

      TextInput({ placeholder: $r('app.string.input_task_name') })
        .width('90%')
        .height(48)
        .fontSize(16)
        .onChange((value: string) => {
          this.customTaskName = value;
        })

      Row() {
        Button($r('app.string.cancel'))
          .width('40%')
          .height(40)
          .backgroundColor($r('sys.color.background_secondary'))
          .fontColor($r('sys.color.font_primary'))
          .onClick(() => {
            this.showCustomDialog = false;
            this.customTaskName = '';
          })

        Button($r('app.string.confirm'))
          .width('40%')
          .height(40)
          .onClick(async () => {
            if (this.customTaskName.trim() === '') {
              return;
            }
            // 创建自定义任务
            let customTaskId = this.taskList.length;
            let newTask = new TaskInfo(
              customTaskId,
              false,
              '',
              '',
              false,
              false,
              '',
              '',
              '',
              -1,
              this.customTaskName.trim()
            );
            await TaskInfoApi.insert(newTask);
            this.taskList = await TaskInfoApi.queryAllTaskInfo();
            this.showCustomDialog = false;
            this.customTaskName = '';
          })
      }
      .width('100%')
      .justifyContent(FlexAlign.SpaceEvenly)
      .margin({ top: 24 })
    }
    .width('100%')
    .padding({ left: 20, right: 20 })
  }

  @Builder
  taskInfoBuilder(item: TaskInfo, _index: number) {
    Row() {
      if (item.customName && item.taskId >= taskBaseInfoList.length) {
        // 自定义任务
        Image($r('app.media.ic_home_add'))
          .width($r('app.float.default_24'))
          .height($r('app.float.default_24'))
          .objectFit(ImageFit.Contain)
          .margin({
            right: $r('app.float.default_8')
          })

        Text(item.customName)
          .fontColor($r(`sys.color.font_primary`))
          .fontSize($r('app.float.default_18'))
      } else {
        // 预设任务
        Image(taskBaseInfoList[item.taskId].icon)
          .width($r('app.float.default_24'))
          .height($r('app.float.default_24'))
          .objectFit(ImageFit.Contain)
          .margin({
            right: $r('app.float.default_8')
          })

        Text(taskBaseInfoList[item.taskId].name)
          .fontColor($r(`sys.color.font_primary`))
          .fontSize($r('app.float.default_18'))
      }

      Blank();

      Text($r('app.string.task_opened'))
        .fontColor($r(`sys.color.font_primary`))
        .fontSize($r('app.float.default_16'))
        .margin({
          right: $r('app.float.default_8')
        })
        .visibility(item.isOpen ? Visibility.Visible : Visibility.Hidden)

      SymbolGlyph($r('sys.symbol.chevron_right'))
        .fontColor([$r('sys.color.icon_secondary')])
        .fontWeight(FontWeight.Normal)
        .fontSize($r('app.float.default_28'))
    }
    .width(Const.THOUSANDTH_1000)
    .height(Const.THOUSANDTH_80)
    .borderRadius($r('app.float.default_16'))
    .padding({
      left: $r('app.float.default_12'),
      right: $r('app.float.default_12')
    })
    .backgroundColor($r('sys.color.background_primary'))
    .onClick(() => {
      this.pageStack.pushPath({ name: 'EditTaskComponent', param: item });
    })
  }
}