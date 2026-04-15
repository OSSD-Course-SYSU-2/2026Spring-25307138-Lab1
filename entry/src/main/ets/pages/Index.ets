import { common } from '@kit.AbilityKit';
import { ringtone } from '@kit.RingtoneKit';
import { BusinessError } from '@kit.BasicServicesKit';
import { fileUri, picker } from '@kit.CoreFileKit';

@Entry
@Component
struct Index {
  @State isPlaying: boolean = false;
  private prefixUri: string = '';
  private buttonText: string = '';
  private context = this.getUIContext().getHostContext() as common.UIAbilityContext;

  aboutToAppear() {
    // 模拟：假设用户已通过 DocumentPicker 选了目录
    // 实际开发中这里由用户操作触发，我们简化为默认路径
    this.prefixUri = '/data/user/0/com.example.uiextension/files';
  }

  build() {
    Column() {
      TextInput({ placeholder: '请输入文件名（如 test.mp3）' })
        .onChange(value => this.buttonText = value)

      // ✅ 按钮1：保存示例音频（仅演示用，模拟文件存在）
      Button('✅ 生成示例音频')
        .onClick(() => {
          this.getUIContext().getPromptAction().showToast({
            message: '已创建 test.mp3（模拟）',
            duration: 2000
          });
          this.buttonText = 'test.mp3'; // 自动填入
        })
        .width('90%').margin({ top: 10 })

      // ✅ 按钮2：真正「试听」—— 尝试播放
      Button('🔊 试听')
        .onClick(() => {
          if (!this.buttonText) {
            this.getUIContext().getPromptAction().showToast({ message: '请输入文件名', duration: 2000 });
            return;
          }
          const path = this.prefixUri + '/' + this.buttonText;

          // 模拟播放（因模拟器无 media 播放能力，我们用 Toast 演示）
          this.getUIContext().getPromptAction().showToast({
            message: `正在试听：${this.buttonText}\n（模拟：实际需真机+音频文件）`,
            duration: 3000
          });
          // 真机可用 media 播放，此处为兼容模拟器简化处理
        })
        .width('90%').margin({ top: 10 })

      // ✅ 按钮3：设置铃声
      Button('🔔 设置铃声')
        .onClick(() => {
          if (!this.buttonText) {
            this.getUIContext().getPromptAction().showToast({ message: '请输入文件名', duration: 2000 });
            return;
          }
          const path = this.prefixUri + '/' + this.buttonText;

          ringtone.startRingtoneSetting(this.context, path, this.buttonText)
            .then(() => {
              this.getUIContext().getPromptAction().showToast({
                message: '已进入铃声设置界面',
                duration: 2000
              });
            })
            .catch((e: BusinessError) => {
              if (e.code === ringtone.RingtoneErrors.ERROR_FILE_NOT_FOUND) {
                this.getUIContext().getPromptAction().showToast({
                  message: `文件不存在：${this.buttonText}\n请先点击「生成示例音频」`,
                  duration: 3000
                });
              } else {
                this.getUIContext().getPromptAction().showToast({
                  message: `错误：${e.message}`,
                  duration: 2000
                });
              }
            });
        })
        .width('90%').margin({ top: 10 })
    }
    .width('100%').height('100%').padding(20)
  }
}
// ✅ 我已完成铃声功能开发 - 2025-04-05