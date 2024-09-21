# dex2oat-optimizer
![DE8135AACFAA2E9DF86E36C9EE57A19E](https://github.com/user-attachments/assets/0948d962-0763-4909-99ff-afa3275fa9f6)

ART 优化，加速应用启动，提升系统性能

ART optimization, accelerating application startup and improving system performance

根据获取到的Android版本号，执行不同的优化命令

安卓版本13或以下：使用 pm compile 命令进行编译优化

安卓版本14或以上：使用 pm compile 进行全编译优化，并使用 pm art 命令进行Dex优化和清理
