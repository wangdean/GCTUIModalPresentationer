# GCTUIModalPresentationViewController

![GCTUIModalPresentationViewController.gif](https://github.com/GCTec/GCTUIModalPresentationViewController/blob/master/IMG_0399.TRIM%203.gif)

基于 `UIViewControllerTransitioningDelegate` 实现的快速配置模态控制器的动画实现方案。
copy于https://github.com/GCTec/GCTUIModalPresentationViewController，防止作者删除了此库。感谢作者



## 功能
- 支持 13 种 `presentAnimation` 动画配置。
- 支持 13 种 `dismissAnimation` 动画配置。
- 支持 5 种背景样式设置。
- 支持背景点击后视图是否 `dismiss` 的配置。
- 支持 `UITextField`、`UITextView` 键盘同步模态显示。



## 安装

#### 支持手动导入。
直接导入工程中 `GCTUIModalPresentationViewController` 文件，继承即可使用。

#### 支持 `Cocoapods` 导入

```ruby
pod 'GCTUIModalPresentationer
```



## 使用

1、创建 `ViewControlle` 继承自 `GCTUIModalPresentationViewController`。
2、在自定义的 `ViewController` 中创建自定义视图（绘制UI：可使用 `XIB`、`Frame` ），保证自定义视图为最终正常显示的位置。
3、在视图显示之前，设置控制器的observerView、背景样式、显示、消失的动画。
4、显示控制器时，正常显示调用：
```objective-c
// 此处的 `animated` 必须为 YES
[self presentViewController:demoPresentViewController animated:YES completion:nil];
```
5、控制器的 `dismiss`，依然是正常方式调用：
```objective-c
// 此处的 `animated` 同样必须为 YES
[self dismissViewControllerAnimated:YES completion:nil];
```



## 参数

##### observerView

`observerView` 为真正动画的视图。如果没有配置 `observerView`，则默认配置为控制器的视图 `View`。
`observerView`  可以配置为 `UITextField`、`UITextView`。配置为这两类类型时，设置的 `presentAnimation` 和 `dismissAnimation` 将会失去作用。视图动画会与键盘同步模态显示，且保证键盘不会遮挡。

#### backViewType

`backViewType` 设置视图背景样式。自定义控制器的背景颜色将不会起作用。
 目前支持样式：

| 序号 | 类型                                   | 描述           |
| ---- | -------------------------------------- | -------------- |
| 0    | GCTUIModalPresentBackViewTypeClear     | 透明           |
| 1    | GCTUIModalPresentBackViewTypeDark      | 黑色半透明效果 |
| 2    | GCTUIModalPresentBackViewTypeWhite     | 白色半透明效果 |
| 3    | GCTUIModalPresentBackViewTypeBlurDark  | 黑色磨砂效果   |
| 4    | GCTUIModalPresentBackViewTypeBlurWhite | 白色磨砂效果   |

具体，可参照demo。

#### presentAnimation 和 dismissAnimation

模态显示和模态消失动画设置。
控件实现依据 `UIViewControllerTransitioningDelegate`，故而要想设置的动画可以成功执行，需要在调用视图模态显示和模态消失的方法时，设置 `animated` 参数为 `YES`。否则，视图显示和消失的过程将没有动画效果。当然，直接设置为 `GCTUIModalPresentAnimationNone` 和 `GCTUIModalDismissAnimationNone`  一样没有动画效果。
具体可参照demo。



## 反馈

lshxin89@126.com

