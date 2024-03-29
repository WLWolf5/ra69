#!/bin/bash

# 设置为schedutil调度(根据内核修改版本)
sed -i '/CONFIG_CPU_FREQ_GOV_ONDEMAND=y/a\CONFIG_CPU_FREQ_GOV_SCHEDUTIL=y' target/linux/ipq807x/config-5.10
sed -i 's/# CONFIG_CPU_FREQ_GOV_POWERSAVE is not set/CONFIG_CPU_FREQ_GOV_POWERSAVE=y/g' target/linux/ipq807x/config-5.10
sed -i 's/# CONFIG_CPU_FREQ_STAT is not set/CONFIG_CPU_FREQ_STAT=y/g' target/linux/ipq807x/config-5.10

# 添加核心温度的显示
sed -i 's|pcdata(boardinfo.system or "?")|luci.sys.exec("uname -m") or "?"|g' feeds/luci/modules/luci-mod-admin-full/luasrc/view/admin_status/index.htm
sed -i 's/or "1"%>/or "1"%> ( <%=luci.sys.exec("expr `cat \/sys\/class\/thermal\/thermal_zone0\/temp` \/ 1000") or "?"%> \&#8451; ) /g' feeds/luci/modules/luci-mod-admin-full/luasrc/view/admin_status/index.htm

#Bug修复
wget https://raw.githubusercontent.com/WLWolf5/wrtcompiler/master/patch/104-RFC-ath11k-fix-peer-addition-deletion-error-on-sta-band-migration.patch -P package/kernel/mac80211/patches/ath11k

#TCP流量优化
wget https://raw.githubusercontent.com/QiuSimons/YAOF/22.03/PATCH/backport/TCP/780-v5.17-tcp-defer-skb-freeing-after-socket-lock-is-released.patch -P target/linux/generic/backport-5.10
wget https://raw.githubusercontent.com/WLWolf5/wrtcompiler/master/patch/780-v5.17-tcp-defer-skb-freeing-after-socket-lock-is-released.patch -P target/linux/generic/backport-5.15

#内存管理机制
svn co https://github.com/QiuSimons/YAOF/trunk/PATCH/backport/MG-LRU
rm -rf MG-LRU/.svn
cp -f MG-LRU/* target/linux/generic/pending-5.10

#TCP BBRv2
cp -f tcp-bbr2/* target/linux/generic/hack-5.15
#cp -f tcp-bbr2/* target/linux/generic/hack-5.10

#Linux Ramdom Number Generator
svn co https://github.com/QiuSimons/YAOF/trunk/PATCH/LRNG
rm -rf LRNG/.svn
cp -f LRNG/* target/linux/generic/hack-5.10

# Patch arm64 型号名称
cp -f LRNG/* target/linux/generic/hack-5.10/linux/generic/hack-5.10/ https://github.com/immortalwrt/immortalwrt/raw/master/target/linux/generic/hack-5.10/312-arm64-cpuinfo-Add-model-name-in-proc-cpuinfo-for-64bit-ta.patch

#替换默认miniupnp
rm -rf feeds/packages/net/miniupnpd
svn co https://github.com/x-wrt/packages/trunk/net/miniupnpd feeds/packages/net/miniupnpd

# Openwrt扩展软件包
svn co https://github.com/kiddin9/openwrt-packages/trunk/luci-app-vlmcsd package/openwrt-packages/luci-app-vlmcsd
svn co https://github.com/kiddin9/openwrt-packages/trunk/vlmcsd package/openwrt-packages/vlmcsd
svn co https://github.com/openwrt/luci/trunk/applications/luci-app-nlbwmon package/openwrt-packages/luci-app-nlbwmon
svn co https://github.com/coolsnowwolf/packages/trunk/net/nlbwmon package/openwrt-packages/nlbwmon
svn co https://github.com/kiddin9/openwrt-packages/trunk/luci-app-fileassistant package/openwrt-packages/luci-app-fileassistant
svn co https://github.com/immortalwrt/luci/trunk/applications/luci-app-zerotier package/openwrt-packages/luci-app-zerotier
svn co https://github.com/immortalwrt/packages/trunk/net/zerotier package/openwrt-packages/zerotier
svn co https://github.com/kiddin9/openwrt-packages/trunk/fullconenat-nft package/openwrt-packages/fullconenat-nft
svn co https://github.com/coolsnowwolf/lede/trunk/package/lean/ddns-scripts_aliyun package/openwrt-packages/ddns-scripts_aliyun
svn co https://github.com/coolsnowwolf/lede/trunk/package/lean/ddns-scripts_dnspod package/openwrt-packages/ddns-scripts_dnspod
git clone https://github.com/NagaseKouichi/luci-app-dnsproxy.git package/openwrt-packages/luci-app-dnsproxy
svn co https://github.com/kiddin9/openwrt-packages/trunk/udp2raw package/openwrt-packages/udp2raw
git clone https://github.com/0xACE8/luci-app-udp2raw.git package/openwrt-packages/luci-app-udp2raw


rm -rf package/qca/nss/qca-nss-cfi
rm -rf package/qca/nss/qca-nss-crypto
svn co https://github.com/WLWolf5/wrtcompiler/trunk/patch/nss/qca-nss-crypto package/openwrt-packages/qca-nss-crypto
svn co https://github.com/WLWolf5/wrtcompiler/trunk/patch/nss/qca-nss-cfi package/openwrt-packages/qca-nss-cfi

