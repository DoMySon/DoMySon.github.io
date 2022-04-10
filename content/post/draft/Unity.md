零GC

1. 避免开装箱

2. 避免创建临时对象

加载

LoadAdd < Load One by One

卸载

1. 分代回收

2. 缓存策略

3. 内存 Monitor

压缩

1. 首选LZ4 

2. 自定义可使用 GZip

UI

对于动画组件和粒子特效的UI 使用 Layer和移出屏幕外 隐藏


EventCenter

1. pull/push 、 Send/Recv 、 Sub/Pub

2. 拓展为链式调用


ECS