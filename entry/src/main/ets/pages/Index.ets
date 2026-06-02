import { common, Want } from '@kit.AbilityKit';
import { ringtone } from '@kit.RingtoneKit';
import { BusinessError } from '@kit.BasicServicesKit';
import { deviceInfo } from '@kit.BasicServicesKit';

@Entry
@Component
struct Index {
  @StorageLink('sharedButtonText') buttonText: string = '';
  @State clipStart: number = 15;
  @State clipEnd: number = 45;

  private isWatch: boolean = deviceInfo.deviceType === 'wearable';
  private prefixUri: string = '/data/user/0/com.example.uiextension/files';
  private context = this.getUIContext().getHostContext() as common.UIAbilityContext;

  // 🌟【就是这里！】它和上面的变量、底下的 build() 都是并列的
  // 在手表端 UI 找到这一段并修改：


  build() {
    Column() {
      if (this.isWatch) {
        // ==================== ⌚ 智能手表端 UI ====================
        Scroll() {
          Column() {
            // 在手表端 UI 找到这一段并修改：
            Text('⌚')
              .fontSize(40)
              .margin({ top: 15, bottom: 5 })
              .onClick(() => {
                // 🌟 只有当你手动点击手表图标时，才模拟“手机推过来了”
                this.buttonText = 'test.mp3';
                this.getUIContext().getPromptAction().showToast({ message: '模拟：收到手机流转信号' });
              })
            Text('分布式铃声同步中心')
              .fontSize(13)
              .fontWeight(FontWeight.Bold)
              .fontColor('#FFFFFF')
              .margin({ bottom: 6 })

            Text(this.buttonText ? `已接收当前铃声:\n${this.buttonText}` : '等待手机/平板推送...')
              .fontSize(11)
              .fontColor('#CCCCCC')
              .textAlign(TextAlign.Center)
              .margin({ bottom: 12 })

            if (this.buttonText) {
              Button('🔔 一键设置')
                .onClick(() => { this.setRingtoneAction(); })
                .width('85%')
                .fontSize(12)
                .backgroundColor('#007DFF')
            }
          }
          .width('100%')
          .padding({ left: 10, right: 10, top: 10, bottom: 20 })
        }
        .scrollBar(BarState.Off)
        .width('100%')
        .height('100%')
        .backgroundColor('#000000')

      } else {
        // ==================== 📱 手机 / 平板端 UI ====================
        Column() {
          TextInput({ placeholder: '请输入文件名（如 test.mp3）', text: this.buttonText })
            .onChange(value => this.buttonText = value)
            .width('90%')
            .margin({ top: 24 })

          // 音频裁剪工作台
          Column() {
            Text('🎵 铃声裁剪工作台')
              .fontSize(16)
              .fontWeight(FontWeight.Bold)
              .alignSelf(ItemAlign.Start)
              .margin({ bottom: 12 })

            Row() {
              Text(`起点: 00:${this.clipStart < 10 ? '0' + this.clipStart : this.clipStart}`)
                .fontSize(14)
                .fontColor('#333333')
              Blank()
              Text(`终点: 00:${this.clipEnd < 10 ? '0' + this.clipEnd : this.clipEnd}`)
                .fontSize(14)
                .fontColor('#333333')
            }
            .width('100%')

            Slider({ value: this.clipStart, min: 0, max: 30, style: SliderStyle.InSet })
              .blockColor('#007DFF')
              .trackColor('#E5E5E5')
              .selectedColor('#007DFF')
              .width('100%')
              .onChange((value: number) => { this.clipStart = Math.floor(value); })

            Slider({ value: this.clipEnd, min: 30, max: 60, style: SliderStyle.InSet })
              .blockColor('#FF5E5E')
              .trackColor('#E5E5E5')
              .selectedColor('#FF5E5E')
              .width('100%')
              .onChange((value: number) => { this.clipEnd = Math.floor(value); })

            Text(`已截取黄金片段：共 ${this.clipEnd - this.clipStart} 秒`)
              .fontSize(12)
              .fontColor('#007DFF')
              .fontWeight(FontWeight.Bold)
              .alignSelf(ItemAlign.End)
              .margin({ top: 10 })
          }
          .width('90%')
          .backgroundColor('#FFFFFF')
          .borderRadius(16)
          .padding(16)
          .margin({ top: 20 })

          // 操作按钮组
          Button('✅ 生成示例音频')
            .onClick(() => {
              this.getUIContext().getPromptAction().showToast({
                message: `已成功裁剪并创建 test.mp3\n(时长: ${this.clipEnd - this.clipStart}秒)`,
                duration: 2500
              });
              this.buttonText = 'test.mp3';
            })
            .width('90%')
            .margin({ top: 20 })

          Button('🔊 试听裁剪片段')
            .onClick(() => {
              if (!this.buttonText) {
                this.getUIContext().getPromptAction().showToast({ message: '请先生成示例音频', duration: 2000 });
                return;
              }
              this.getUIContext().getPromptAction().showToast({
                message: `🔊 正在试听：从第 ${this.clipStart} 秒到 ${this.clipEnd} 秒的黄金铃声片段...`,
                duration: 3000
              });
            })
            .width('90%')
            .margin({ top: 12 })

          Button('🔮 流转：推送到我的华为手表')
            .onClick(() => { this.startDistributedFlow(); })
            .width('90%')
            .backgroundColor('#47CC47')
            .margin({ top: 12 })

          Button('🔔 设置为本地系统铃声')
            .onClick(() => { this.setRingtoneAction(); })
            .width('90%')
            .margin({ top: 12 })
        }
        .width('100%')
        .height('100%')
        .justifyContent(FlexAlign.Start)
        .backgroundColor($r('sys.color.ohos_id_color_sub_background'))
      }
    }
    .width('100%')
    .height('100%')
  }

  // 🔮 触发分布式流转逻辑
  private startDistributedFlow() {
    if (!this.buttonText) {
      this.getUIContext().getPromptAction().showToast({ message: '没有裁剪好的音频可供流转', duration: 2000 });
      return;
    }

    let targetWant: Want = {
      bundleName: 'com.example.uiextension',
      abilityName: 'EntryAbility',
      deviceId: '',
      parameters: {
        'musicName': this.buttonText,
        'startTime': this.clipStart,
        'endTime': this.clipEnd
      }
    };

    this.getUIContext().getPromptAction().showToast({
      message: `🚀 分布式通道已建立！正在投递包裹...\n[${this.buttonText}] 时长:${this.clipEnd - this.clipStart}s`,
      duration: 3000
    });

    this.context.startAbility(targetWant)
      .then(() => {
        console.info('Distributed flow started successfully.');
      })
      .catch((err: BusinessError) => {
        console.error(`Distributed flow failed. Code: ${err.code}, Message: ${err.message}`);
      });
  }

  // 公共铃声设置逻辑
  private setRingtoneAction() {
    if (!this.buttonText) {
      this.getUIContext().getPromptAction().showToast({ message: '无可用音频文件', duration: 2000 });
      return;
    }
    const path = this.prefixUri + '/' + this.buttonText;
    ringtone.startRingtoneSetting(this.context, path, this.buttonText)
      .then(() => {
        this.getUIContext().getPromptAction().showToast({ message: '已进入铃声设置界面', duration: 2000 });
      })
      .catch((e: BusinessError) => {
        if (e.code === ringtone.RingtoneErrors.ERROR_FILE_NOT_FOUND) {
          this.getUIContext().getPromptAction().showToast({ message: `文件未找到，请检查路径`, duration: 3000 });
        } else {
          this.getUIContext().getPromptAction().showToast({ message: `错误：${e.message}`, duration: 2000 });
        }
      });
  }
}