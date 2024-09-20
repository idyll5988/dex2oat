# dex2oat-optimizer
![CA67325F9DCB2765BD7B0CEBABA59796](https://github.com/user-attachments/assets/404f8de5-c836-4cc7-adbf-aeb0c79944d5)

ART 优化模块，加速应用启动，提升系统性能

An ART optimization module to accelerate app launches and improve system performance

根据获取到的Android版本号，执行不同的优化命令

安卓版本13或以下：使用 pm compile 命令进行编译优化

安卓版本14或以上：使用 pm compile 进行全编译优化，并使用 pm art 命令进行Dex优化和清理
