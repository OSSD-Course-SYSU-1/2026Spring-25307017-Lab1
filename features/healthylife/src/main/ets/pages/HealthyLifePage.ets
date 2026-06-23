/*
 *
 *  * Copyright (c) 2025 Huawei Device Co., Ltd.
 *  * Licensed under the Apache License, Version 2.0 (the "License");
 *  * ...
 */

import { HomeComponent } from '../views/HomeComponent';
import { MineComponent } from '../views/MineComponent';
import { NavList, TabId } from '../model/NavItemModel';
import { CommonConstants as Const, convertDate2Str } from 'common';
import DayInfoApi from 'common/src/main/ets/database/tables/DayInfoApi';
import { AchievementStore, initAchievementStore } from '../viewmodel/AchievementStore';
import { HomeStore } from '../viewmodel/HomeStore';
import { display } from '@kit.ArkUI';
import { common } from '@kit.AbilityKit';

@Component
export struct HealthyLifePage {
  @State currentIndex: number = 0;
  @Provide achievementStore: AchievementStore = new AchievementStore(0, 0, false);
  @Provide('pathStack') pageStack: NavPathStack = new NavPathStack();
  @Provide homeStore: HomeStore = new HomeStore([], -1, '', []);
  @StorageLink('currentBreakpoint') currentBreakpoint: string = Const.BREAKPOINT_SM;
  private context = this.getUIContext()?.getHostContext() as common.UIAbilityContext;
  private windowClass = this.context.windowStage.getMainWindowSync();

  async aboutToAppear(): Promise<void> {
    try {
      await this.windowClass.setWindowLayoutFullScreen(true);
      await this.windowClass.setWindowSystemBarProperties({
        statusBarColor: '#00000000',
        statusBarContentColor: '#FF000000'
      })
    } catch (error) {
      console.error(`an error occurred: ${error}`);
    }

    this.updateBreakpoint();

    this.windowClass.on('windowSizeChange', () => {
      this.updateBreakpoint();
    });

    await DayInfoApi.initDayInfo(convertDate2Str(new Date()));
    this.achievementStore = await initAchievementStore();
  }

  updateBreakpoint(): void {
    try {
      const rect = this.windowClass.getWindowProperties().windowRect;
      const density = display.getDefaultDisplaySync().densityPixels;
      const widthVp = rect.width / density;
      if (widthVp >= 840) {
        AppStorage.setOrCreate('currentBreakpoint', Const.BREAKPOINT_LG);
      } else if (widthVp >= 600) {
        AppStorage.setOrCreate('currentBreakpoint', Const.BREAKPOINT_MD);
      } else {
        AppStorage.setOrCreate('currentBreakpoint', Const.BREAKPOINT_SM);
      }
    } catch (err) {
      AppStorage.setOrCreate('currentBreakpoint', Const.BREAKPOINT_SM);
    }
  }

  build() {
    Navigation(this.pageStack) {
      Tabs({ barPosition: BarPosition.End }) {
        TabContent() {
          HomeComponent()
        }
        .tabBar(this.tabBuilder(TabId.HOME))

        TabContent() {
          MineComponent()
        }
        .tabBar(this.tabBuilder(TabId.MINE))
      }
      .backgroundColor($r('sys.color.background_secondary'))
      .scrollable(false)
      .width(Const.THOUSANDTH_1000)
      .height(Const.THOUSANDTH_1000)
      .barWidth(Const.THOUSANDTH_940)
      .vertical(false)
      .padding({
        bottom: $r('app.float.default_20')
      })
      .divider({
        strokeWidth: 1,
        color: $r('sys.color.background_tertiary')
      })
      .onChange((index) => {
        this.currentIndex = index;
      })
    }
    .mode(NavigationMode.Stack)
  }

  @Builder
  tabBuilder(index: number) {
    Column() {
      Image(index === this.currentIndex ? NavList[index].icon_selected : NavList[index].icon)
        .width($r('app.float.default_24'))
        .height($r('app.float.default_24'))
        .objectFit(ImageFit.Contain);

      Text(NavList[index].text)
        .fontSize($r('app.float.default_10'))
        .fontWeight(FontWeight.Regular)
        .fontColor(this.currentIndex === index ? $r('app.color.text_font_color') : $r('sys.color.font_tertiary'))
        .margin({
          top: $r('app.float.default_4')
        })
    }
    .justifyContent(FlexAlign.Center)
    .width(Const.THOUSANDTH_1000)
    .height(Const.THOUSANDTH_1000)
  }
}