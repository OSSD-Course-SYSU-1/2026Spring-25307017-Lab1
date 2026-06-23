/*
 *
 *  * Copyright (c) 2025 Huawei Device Co., Ltd.
 *  * Licensed under the Apache License, Version 2.0 (the "License");
 *  * ...
 */

import { HomeStore } from '../../viewmodel/HomeStore';
import { CommonConstants as Const, DayInfo } from 'common';
import { PreferencesUtils } from 'common/src/main/ets/utils/PreferencesUtils';
import { WeekCalendarComponent } from './WeekCalendarComponent';
import { photoAccessHelper } from '@kit.MediaLibraryKit';
import { BusinessError } from '@kit.BasicServicesKit';

@Component
export struct HomeTopComponent {
  @Consume @Watch('onDataChange') homeStore: HomeStore;
  @State dayInfo: DayInfo = new DayInfo('', 0, 0);
  @State customBgUri: string = '';
  @StorageLink('currentBreakpoint') currentBreakpoint: string = Const.BREAKPOINT_SM;

  onDataChange() {
    this.dayInfo = this.homeStore.weekList[this.homeStore.selectedDay];
  }

  async aboutToAppear(): Promise<void> {
    this.onDataChange();
    this.customBgUri = await PreferencesUtils.getHomeBgUri();
  }

  async selectPhoto() {
    try {
      const photoPicker = new photoAccessHelper.PhotoViewPicker();
      const result = await photoPicker.select({
        MIMEType: photoAccessHelper.PhotoViewMIMETypes.IMAGE_TYPE,
        maxSelectNumber: 1
      });
      if (result.photoUris.length > 0) {
        this.customBgUri = result.photoUris[0];
        await PreferencesUtils.setHomeBgUri(this.customBgUri);
      }
    } catch (err) {
      const error = err as BusinessError;
      console.error(`Photo picker error: ${error.code}, ${error.message}`);
    }
  }

  build() {
    Stack() {
      Image(this.customBgUri || $r('app.media.ic_home_bg'))
        .width(Const.THOUSANDTH_1000)
        .height(Const.THOUSANDTH_1000)
        .objectFit(ImageFit.Cover)
        .draggable(false)

      Column() {
        Text($r('app.string.target_progress'))
          .fontFamily(Const.HARMONY_HEI_TI_MEDIUM)
          .fontWeight(FontWeight.Regular)
          .fontColor($r(`sys.color.font_secondary`))
          .fontSize($r('app.float.default_16'))
          .width(Const.THOUSANDTH_1000)
          .padding({ left: $r('app.float.default_24') })

        Row() {
          Text(`${this.dayInfo.calculatePercentage()}`)
            .fontFamily(Const.HARMONY_HEI_TI_BOLD)
            .fontWeight(FontWeight.Bold)
            .fontColor($r(`sys.color.font_primary`))
            .fontSize($r('app.float.default_72'))

          Text(Const.PERCENT)
            .fontFamily(Const.HARMONY_HEI_TI_MEDIUM)
            .fontWeight(FontWeight.Regular)
            .fontColor($r(`sys.color.font_primary`))
            .fontSize($r('app.float.default_40'))
            .width(Const.THOUSANDTH_1000)
            .margin({
              top: $r('app.float.default_12'),
              left: $r('app.float.default_8')
            })
        }
        .width(Const.THOUSANDTH_1000)
        .padding({ left: $r('app.float.default_24') })

        WeekCalendarComponent()
      }
      .width(Const.THOUSANDTH_1000)
      .height(Const.THOUSANDTH_1000)
      .justifyContent(FlexAlign.End)
    }
    .height(this.currentBreakpoint === Const.BREAKPOINT_SM ? Const.THOUSANDTH_500 : 300)
    .gesture(
      LongPressGesture({ repeat: false, duration: 800 })
        .onAction(async () => {
          await this.selectPhoto();
        })
    )
  }
}