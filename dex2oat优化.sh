#!/system/bin/sh
thread_num=200
(echo "\n  按下音量按钮\n   音量 + : 执行编译\n   音量 - : 清除所有编译\n";
while true;
do input="$(timeout 0.1 getevent -l|grep -Eo 'VOLUMEUP|VOLUMEDOWN'|head -n1)";
if [ "$input" = "VOLUMEUP" ];then 
echo "   已选定 : 执行编译\n";
get_android_version() {
    getprop ro.build.version.release
}
if ! command -v resetprop > /dev/null 2>&1; then
    if [ -f /data/adb/ksu/bin/resetprop ]; then
        alias resetprop=/data/adb/ksu/bin/resetprop
    elif [ -f /data/adb/ap/bin/resetprop ]; then
        alias resetprop=/data/adb/ap/bin/resetprop
    else
        alias resetprop=setprop
    fi
    export resetprop
fi
sync
properties="dalvik.vm.minidebuginfo false
dalvik.vm.dex2oat-minidebuginfo false
dalvik.vm.check-dex-sum false
dalvik.vm.checkjni false
dalvik.vm.verify-bytecode false
dalvik.gc.type generational_cc
dalvik.vm.usejit false
dalvik.vm.dex2oat-swap true
dalvik.vm.dex2oat-resolve-startup-strings true
dalvik.vm.systemservercompilerfilter speed-profile
dalvik.vm.systemuicompilerfilter speed-profile
dalvik.vm.usap_pool_enabled true"

echo "$properties" | while IFS= read -r prop; do
    resetprop $prop || echo "设置属性失败: $prop"
done
echo "[*] 优化主提升应用程序"
ANDROID_VERSION=$(get_android_version)
if [ "$(printf '%s\n' "$ANDROID_VERSION" "13" | sort -V | head -n1)" = "$ANDROID_VERSION" ]; then
    echo "[*] 安卓版本为13或以下运行命令"
	{
	pm compile -m speed-profile -a
    pm compile -m speed-profile --secondary-dex -a
    pm compile --compile-layouts -a
	} &
	while [ $(jobs | wc -l) -ge $thread_num ]; do
    sleep 1
    done
	wait
elif [ "$(printf '%s\n' "$ANDROID_VERSION" "14" | sort -V | head -n1)" = "14" ]; then
	echo "[*] 安卓版本为14或以上运行命令"
	{
	pm art dexopt-packages -r bg-dexopt
    pm compile -m speed-profile --full -a
    pm art cleanup
	} &
	while [ $(jobs | wc -l) -ge $thread_num ]; do
    sleep 1
    done
	wait
else
	echo "[*] 安卓版本无法运行优化"
fi
break;
elif [ "$input" = "VOLUMEDOWN" ];then 
echo "   已选定 : 清除所有编译\n";
cmd package compile --reset -a
break;
fi;
done;)2>/dev/null
	