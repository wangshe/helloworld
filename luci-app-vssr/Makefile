include $(TOPDIR)/rules.mk

PKG_NAME:=luci-app-vssr

PKG_CONFIG_DEPENDS:= \
	CONFIG_PACKAGE_$(PKG_NAME)_INCLUDE_ShadowsocksR_Libev_Server \
	
LUCI_TITLE:=A New SS/SSR/Xray/Trojan LuCI interface
LUCI_PKGARCH:=all
LUCI_DEPENDS:=+ipset +ip-full +iptables-mod-tproxy +dnsmasq-full +coreutils +coreutils-base64 +bash +pdnsd-alt +wget-ssl +lua +luasocket +lua-maxminddb +lua-cjson \
	+shadowsocksr-libev-ssr-local +shadowsocksr-libev-ssr-redir +shadowsocksr-libev-ssr-check \
	+PACKAGE_$(PKG_NAME)_INCLUDE_ShadowsocksR_Libev_Server:shadowsocksr-libev-ssr-server

define Package/$(PKG_NAME)/config
config PACKAGE_$(PKG_NAME)_INCLUDE_ShadowsocksR_Libev_Server
	bool "Include ShadowsocksR Libev Server"
	default y if i386||x86_64||arm||aarch64
endef

define Package/$(PKG_NAME)/conffiles
/etc/vssr/
/etc/config/vssr
endef

include $(TOPDIR)/feeds/luci/luci.mk

# call BuildPackage - OpenWrt buildroot signature
