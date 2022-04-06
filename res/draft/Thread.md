# 线程的实现模型主要有3种：
    内核级线程模型、用户级线程模型和两级线程模型（也称混合型线程模型），它们之间最大的差异就在于用户线程与内核调度实体（KSE，Kernel Scheduling Entity）之间的对应关系上。而所谓的内核调度实体 KSE 就是指可以被操作系统内核调度器调度的对象实体。简单来说 KSE 就是内核级线程，是操作系统内核的最小调度单元，也就是我们写代码的时候通俗理解上的线程了。

## 用户级线程模型

    用户线程与内核线程KSE是多对一（N : 1）的映射模型，多个用户线程的一般从属于单个进程并且多线程的调度是由用户自己的线程库来完成，线程的创建、销毁以及多线程之间的协调等操作都是由用户自己的线程库来负责而无须借助系统调用来实现。一个进程中所有创建的线程都只和同一个KSE在运行时动态绑定，也就是说，操作系统只知道用户进程而对其中的线程是无感知的，内核的所有调度都是基于用户进程。许多语言实现的 协程库 基本上都属于这种方式（比如python的gevent）。由于线程调度是在用户层面完成的，也就是相较于内核调度不需要让CPU在用户态和内核态之间切换，这种实现方式相比内核级线程可以做的很轻量级，对系统资源的消耗会小很多，因此可以创建的线程数量与上下文切换所花费的代价也会小得多。但该模型有个原罪：并不能做到真正意义上的并发，假设在某个用户进程上的某个用户线程因为一个阻塞调用（比如I/O阻塞）而被CPU给中断（抢占式调度）了，那么该进程内的所有线程都被阻塞（因为单个用户进程内的线程自调度是没有CPU时钟中断的，从而没有轮转调度），整个进程被挂起。即便是多CPU的机器，也无济于事，因为在用户级线程模型下，一个CPU关联运行的是整个用户进程，进程内的子线程绑定到CPU执行是由用户进程调度的，内部线程对CPU是不可见的，此时可以理解为CPU的调度单位是用户进程。所以很多的协程库会把自己一些阻塞的操作重新封装为完全的非阻塞形式，然后在以前要阻塞的点上，主动让出自己，并通过某种方式通知或唤醒其他待执行的用户线程在该KSE上运行，从而避免了内核调度器由于KSE阻塞而做上下文切换，这样整个进程也不会被阻塞了。

## 内核级线程模型

    用户线程与内核线程KSE是一对一（1 : 1）的映射模型，也就是每一个用户线程绑定一个实际的内核线程，而线程的调度则完全交付给操作系统内核去做，应用程序对线程的创建、终止以及同步都基于内核提供的系统调用来完成，大部分编程语言的线程库(比如Java的java.lang.Thread、C++11的std::thread等等)都是对操作系统的线程（内核级线程）的一层封装，创建出来的每个线程与一个独立的KSE静态绑定，因此其调度完全由操作系统内核调度器去做。这种模型的优势和劣势同样明显：优势是实现简单，直接借助操作系统内核的线程以及调度器，所以CPU可以快速切换调度线程，于是多个线程可以同时运行，因此相较于用户级线程模型它真正做到了并行处理；但它的劣势是，由于直接借助了操作系统内核来创建、销毁和以及多个线程之间的上下文切换和调度，因此资源成本大幅上涨，且对性能影响很大。

## 两级线程模型

    两级线程模型是博采众长之后的产物，充分吸收前两种线程模型的优点且尽量规避它们的缺点。在此模型下，用户线程与内核KSE是多对多（N : M）的映射模型：首先，区别于用户级线程模型，两级线程模型中的一个进程可以与多个内核线程KSE关联，于是进程内的多个线程可以绑定不同的KSE，这点和内核级线程模型相似；其次，又区别于内核级线程模型，它的进程里的所有线程并不与KSE一一绑定，而是可以动态绑定同一个KSE， 当某个KSE因为其绑定的线程的阻塞操作被内核调度出CPU时，其关联的进程中其余用户线程可以重新与其他KSE绑定运行。所以，两级线程模型既不是用户级线程模型那种完全靠自己调度的也不是内核级线程模型完全靠操作系统调度的，而是中间态（自身调度与系统调度协同工作），因为这种模型的高度复杂性，操作系统内核开发者一般不会使用，所以更多时候是作为第三方库的形式出现，而Go语言中的runtime调度器就是采用的这种实现方案，实现了Goroutine与KSE之间的动态关联，不过Go语言的实现更加高级和优雅；该模型为何被称为两级？即用户调度器实现用户线程到KSE的『调度』，内核调度器实现KSE到CPU上的『调度』。