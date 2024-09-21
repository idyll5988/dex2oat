#!/system/bin/sh
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
    echo "[*] 安卓版本为13或以下运行"
	pm compile -m speed-profile -a
    pm compile -m speed-profile --secondary-dex -a
    pm compile --compile-layouts -a
elif [ "$(printf '%s\n' "$ANDROID_VERSION" "14" | sort -V | head -n1)" = "14" ]; then
	echo "[*] 安卓版本为14或以上运行"
    pm compile -m speed-profile --full -a
    pm art dexopt-packages -r bg-dexopt
    pm art cleanup
else
	echo "[*] 安卓版本无法运行优化"
fi
	