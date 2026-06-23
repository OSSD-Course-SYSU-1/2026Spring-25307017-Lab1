/*
 *
 *  * Copyright (c) 2025 Huawei Device Co., Ltd.
 *  * Licensed under the Apache License, Version 2.0 (the "License");
 *  * ...
 */

import { CommonConstants as Const } from 'common';
import { PreferencesUtils } from 'common/src/main/ets/utils/PreferencesUtils';
import { photoAccessHelper } from '@kit.MediaLibraryKit';
import { BusinessError } from '@kit.BasicServicesKit';

@Reusable
@Component
export struct UserInfoComponent {
  @State avatarUri: string = '';
  @State displayName: string = '';
  @State isEditingName: boolean = false;
  @State editNameValue: string = '';

  async aboutToAppear(): Promise<void> {
    this.avatarUri = await PreferencesUtils.getAvatarUri();
    const savedName = await PreferencesUtils.getUserDisplayName();
    this.displayName = savedName || '';
  }

  async selectAvatar() {
    try {
      const photoPicker = new photoAccessHelper.PhotoViewPicker();
      const result = await photoPicker.select({
        MIMEType: photoAccessHelper.PhotoViewMIMETypes.IMAGE_TYPE,
        maxSelectNumber: 1
      });
      if (result.photoUris.length > 0) {
        this.avatarUri = result.photoUris[0];
        await PreferencesUtils.setAvatarUri(this.avatarUri);
      }
    } catch (err) {
      const error = err as BusinessError;
      console.error(`Avatar picker error: ${error.code}, ${error.message}`);
    }
  }

  startEditName() {
    this.editNameValue = this.displayName || '';
    this.isEditingName = true;
  }

  async confirmEditName() {
    this.displayName = this.editNameValue.trim();
    await PreferencesUtils.setUserDisplayName(this.displayName);
    this.isEditingName = false;
  }

  cancelEditName() {
    this.isEditingName = false;
  }

  build() {
    Column() {
      Row({ space: $r('app.float.default_12') }) {
        Image(this.avatarUri || $r('app.media.person_crop_circle'))
          .width($r('app.float.default_48'))
          .height($r('app.float.default_48'))
          .borderRadius($r('app.float.default_24'))
          .objectFit(ImageFit.Cover)
          .draggable(false)
          .priorityGesture(
            LongPressGesture({ repeat: false, duration: 600 })
              .onAction(async () => {
                await this.selectAvatar();
              })
          )

        if (this.isEditingName) {
          TextInput({ text: this.editNameValue, placeholder: $r('app.string.user_name') })
            .fontSize($r('app.float.default_18'))
            .fontColor($r('app.color.mine_font_color'))
            .fontWeight(FontWeight.Medium)
            .backgroundColor($r('sys.color.background_tertiary'))
            .borderRadius($r('app.float.default_8'))
            .padding({
              left: $r('app.float.default_8'),
              right: $r('app.float.default_8')
            })
            .layoutWeight(1)
            .maxLength(12)
            .onChange((value: string) => {
              this.editNameValue = value;
            })
            .onSubmit(async () => {
              await this.confirmEditName();
            })

          Text($r('app.string.confirm'))
            .fontSize($r('app.float.default_14'))
            .fontColor($r('app.color.text_font_color'))
            .padding({
              left: $r('app.float.default_8'),
              right: $r('app.float.default_8')
            })
            .onClick(async () => {
              await this.confirmEditName();
            })

          Text($r('app.string.cancel'))
            .fontSize($r('app.float.default_14'))
            .fontColor($r('sys.color.font_tertiary'))
            .onClick(() => {
              this.cancelEditName();
            })
        } else {
          Text(this.displayName || $r('app.string.user_name'))
            .fontColor($r('app.color.mine_font_color'))
            .fontSize($r('app.float.default_18'))
            .fontWeight(FontWeight.Medium)
            .gesture(
              LongPressGesture({ repeat: false, duration: 800 })
                .onAction(() => {
                  this.startEditName();
                })
            )
        }
      }
      .width(Const.THOUSANDTH_940)
      .height(Const.THOUSANDTH_130)
      .borderRadius($r('app.float.default_16'))
      .padding({
        left: $r('app.float.default_12'),
        right: $r('app.float.default_12')
      })
      .backgroundColor($r('sys.color.background_primary'))
      .margin({
        bottom: $r('app.float.default_6')
      })
    }
  }
}