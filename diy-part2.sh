#!/bin/bash
#
# Copyright (c) 2019-2020 P3TERX <https://p3terx.com>
#
# This is free software, licensed under the MIT License.
# See /LICENSE for more information.
#
# https://github.com/P3TERX/Actions-OpenWrt
# File name: diy-part2.sh
# Description: OpenWrt DIY script part 2 (After Update feeds)
#
# Modify default IP
sed -i 's/192.168.1.1/192.168.10.1/g' package/base-files/files/bin/config_generate

# Add luci-app-passwall
git clone --depth=1 https://github.com/xiaorouji/openwrt-passwall package/openwrt-passwall

## replace luci-theme-argon
rm -rf package/lean/luci-theme-argon
git clone -b 18.06 https://github.com/jerrykuku/luci-theme-argon.git package/luci-theme-argon
git clone --depth=1 https://github.com/jerrykuku/luci-app-argon-config package/luci-app-argon-config

## overclock 1000Mhz--0x312 1100Mhz--0x362 1200Mhz--0x3B2
pushd target/linux/ramips/patches-5.4
sed -i '68s/89/98/' 102-mt7621-fix-cpu-clk-add-clkdev.patch
sed -i 'N;156 a +\t\tif ((pll & 0x7f0) == 0x2b0) {\n+\t\t\tvolatile u32 i;\n+\n+\t\t\tpr_info("CPU Clock: 880MHz, start overclocking\\n");\n+\t\t\tpll &= ~0x7ff;\n+\t\t\tpll |= 0x3B2;\n+\t\t\trt_memc_w32(pll, MEMC_REG_CPU_PLL);\n+\t\t\tfor (i = 0; i < 1000; i++);\n+\t\t}' 102-mt7621-fix-cpu-clk-add-clkdev.patch
popd
