/*
 *
 *  * Copyright (c) 2025 Huawei Device Co., Ltd.
 *  * Licensed under the Apache License, Version 2.0 (the "License");
 *  * ...
 */

import { CommonConstants as Const } from 'common';
import { PreferencesUtils } from 'common/src/main/ets/utils/PreferencesUtils';
import { UserInfoComponent } from './mine/UserInfoComponent';

@Component
export struct MineComponent {
  @Provide uiContext: UIContext = this.getUIContext();
  @Consume('pathStack') pageStack: NavPathStack;
  @State signature: string = '';
  @State isEditingSignature: boolean = false;
  @State editSignatureValue: string = '';

  async aboutToAppear(): Promise<void> {
    this.signature = await PreferencesUtils.getUserSignature();
  }

  startEditSignature() {
    this.editSignatureValue = this.signature;
    this.isEditingSignature = true;
  }

  async confirmEditSignature() {
    this.signature = this.editSignatureValue.trim();
    await PreferencesUtils.setUserSignature(this.signature);
    this.isEditingSignature = false;
  }

  cancelEditSignature() {
    this.isEditingSignature = false;
  }

  build() {
    Column() {
      Column() {
        UserInfoComponent()
        Row({ space: $r('app.float.default_16') }) {
          Image($r('app.media.book_closed_per'))
            .width($r('app.float.default_24'))
            .height($r('app.float.default_24'))

          if (this.isEditingSignature) {
            TextInput({ text: this.editSignatureValue, placeholder: $r('app.string.user_signature') })
              .fontSize($r('app.float.default_14'))
              .fontColor($r('app.color.mine_font_color'))
              .backgroundColor($r('sys.color.background_tertiary'))
              .borderRadius($r('app.float.default_8'))
              .padding({ left: $r('app.float.default_8'), right: $r('app.float.default_8') })
              .layoutWeight(1)
              .maxLength(30)
              .onChange((value: string) => { this.editSignatureValue = value; })
              .onSubmit(async () => { await this.confirmEditSignature(); })

            Text($r('app.string.confirm'))
              .fontSize($r('app.float.default_14'))
              .fontColor($r('app.color.text_font_color'))
              .padding({ left: $r('app.float.default_6'), right: $r('app.float.default_6') })
              .onClick(async () => { await this.confirmEditSignature(); })

            Text($r('app.string.cancel'))
              .fontSize($r('app.float.default_14'))
              .fontColor($r('sys.color.font_tertiary'))
              .onClick(() => { this.cancelEditSignature(); })
          } else {
            Text(this.signature || $r('app.string.mine_signature'))
              .fontColor(this.signature ? $r('app.color.mine_font_color') : $r('sys.color.font_tertiary'))
              .fontSize($r('app.float.default_14'))
              .maxLines(1)
              .textOverflow({ overflow: TextOverflow.Ellipsis })
              .layoutWeight(1)

            Text($r('app.string.edit_task'))
              .fontSize($r('app.float.default_12'))
              .fontColor($r('sys.color.font_tertiary'))
          }
        }
        .width(Const.THOUSANDTH_1000)
        .height(Const.THOUSANDTH_100)
        .borderRadius({
          topLeft: $r('app.float.default_16'),
          topRight: $r('app.float.default_16')
        })
        .padding({
          left: $r('app.float.default_12'),
          right: $r('app.float.default_12')
        })
        .backgroundColor($r('sys.color.background_primary'))
        .margin({
          top: $r('app.float.default_6')
        })
        .gesture(
          LongPressGesture({ repeat: false, duration: 600 })
            .onAction(() => {
              if (!this.isEditingSignature) {
                this.startEditSignature();
              }
            })
        )

        Divider()
          .color($r('app.float.default_1'))
          .width(Const.THOUSANDTH_1000)
        Row({ space: $r('app.float.default_16') }) {
          Image($r('app.media.arrow_up_circle'))
            .width($r('app.float.default_24'))
            .height($r('app.float.default_24'))
          Text($r('app.string.mine_check_updates'))
            .fontColor($r('app.color.mine_font_color'))
            .fontSize($r('app.float.default_18'))
            .fontWeight(FontWeight.Medium)
          Blank();
          SymbolGlyph($r('sys.symbol.chevron_right'))
            .fontColor([$r('sys.color.icon_fourth')])
            .fontWeight(FontWeight.Normal)
            .fontSize($r('app.float.default_24'))
        }
        .width(Const.THOUSANDTH_1000)
        .height(Const.THOUSANDTH_100)
        .borderRadius({
          bottomLeft: $r('app.float.default_16'),
          bottomRight: $r('app.float.default_16')
        })
        .padding({
          left: $r('app.float.default_12'),
          right: $r('app.float.default_12')
        })
        .backgroundColor($r('sys.color.background_primary'))
        .margin({
          bottom: $r('app.float.default_6')
        })

        Row({ space: $r('app.float.default_16') }) {
          Image($r('app.media.ic_task_apple'))
            .width($r('app.float.default_24'))
            .height($r('app.float.default_24'))
          Text($r('app.string.history_record'))
            .fontColor($r('app.color.mine_font_color'))
            .fontSize($r('app.float.default_18'))
            .fontWeight(FontWeight.Medium)
          Blank();
          SymbolGlyph($r('sys.symbol.chevron_right'))
            .fontColor([$r('sys.color.icon_fourth')])
            .fontWeight(FontWeight.Normal)
            .fontSize($r('app.float.default_24'))
        }
        .width(Const.THOUSANDTH_1000)
        .height(Const.THOUSANDTH_100)
        .borderRadius($r('app.float.default_16'))
        .padding({
          left: $r('app.float.default_12'),
          right: $r('app.float.default_12')
        })
        .backgroundColor($r('sys.color.background_primary'))
        .margin({
          top: $r('app.float.default_6'),
          bottom: $r('app.float.default_6')
        })
        .onClick(() => {
          this.pageStack.pushPathByName('HistoryComponent', '');
        })

        Row({ space: $r('app.float.default_16') }) {
          Image($r('app.media.star_trophy'))
            .width($r('app.float.default_24'))
            .height($r('app.float.default_24'))
          Text($r('app.string.mine_achievement'))
            .fontColor($r('app.color.mine_font_color'))
            .fontSize($r('app.float.default_18'))
            .fontWeight(FontWeight.Medium)
          Blank();
          SymbolGlyph($r('sys.symbol.chevron_right'))
            .fontColor([$r('sys.color.icon_fourth')])
            .fontWeight(FontWeight.Normal)
            .fontSize($r('app.float.default_24'))
        }
        .width(Const.THOUSANDTH_1000)
        .height(Const.THOUSANDTH_100)
        .borderRadius($r('app.float.default_16'))
        .padding({
          left: $r('app.float.default_12'),
          right: $r('app.float.default_12')
        })
        .backgroundColor($r('sys.color.background_primary'))
        .margin({
          top: $r('app.float.default_6')
        })
        .onClick(() => {
          this.pageStack.pushPathByName('AchievementComponent', '');
        })
      }
      .width(Const.THOUSANDTH_940)
      .alignItems(HorizontalAlign.Center)
    }
    .width(Const.THOUSANDTH_1000)
    .height(Const.THOUSANDTH_1000)
    .backgroundColor($r('sys.color.background_secondary'))
  }
}