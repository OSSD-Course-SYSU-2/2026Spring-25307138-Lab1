import { AbilityConstant, UIAbility, Want } from '@kit.AbilityKit';
import { window } from '@kit.ArkUI';

export default class EntryAbility extends UIAbility {

  // 1. 当应用第一次被拉起时触发
  onCreate(want: Want, launchParam: AbilityConstant.LaunchParam): void {
    this.handleIncomingWant(want);
  }

  // 2. 当应用已经在后台运行，再次收到流转数据时触发
  onNewWant(want: Want, launchParam: AbilityConstant.LaunchParam): void {
    this.handleIncomingWant(want);
  }

  // 🌟 核心：专门负责拆包裹并把数据塞进大厅柜子（AppStorage）
  private handleIncomingWant(want: Want) {
    if (want.parameters && want.parameters['musicName']) {
      let incomingMusic = want.parameters['musicName'] as string;

      // 🔑 啪！把收到的歌名存入全局中心
      // 这时前端页面的 @StorageLink('sharedButtonText') 就会像通了电一样瞬间刷新！
      AppStorage.setOrCreate('sharedButtonText', incomingMusic);
    }
  }

  onWindowStageCreate(windowStage: window.WindowStage): void {
    // 确保加载的是你的主页
    windowStage.loadContent('pages/Index', (err) => {
      if (err.code) {
        return;
      }
    });
  }

  onWindowStageDestroy(): void {}
  onForeground(): void {}
  onBackground(): void {}
  onDestroy(): void {}
}