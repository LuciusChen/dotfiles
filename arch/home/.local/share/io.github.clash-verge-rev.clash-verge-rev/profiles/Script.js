// Define main function (script entry)
// https://github.com/clash-verge-rev/clash-verge-rev/issues/1437#issuecomment-2395050752

// 国内 DNS 服务器
const domesticNameservers = [
  "https://dns.alidns.com/dns-query", // 阿里云公共 DNS
  "https://doh.pub/dns-query", // 腾讯 DNSPod
  "https://doh.360.cn/dns-query" // 360 安全 DNS
];
// 国外 DNS 服务器
const foreignNameservers = [
  "https://1.1.1.1/dns-query", // Cloudflare(主)
  "https://1.0.0.1/dns-query", // Cloudflare(备)
  "https://208.67.222.222/dns-query", // OpenDNS(主)
  "https://208.67.220.220/dns-query", // OpenDNS(备)
  "https://194.242.2.2/dns-query", // Mullvad(主)
  "https://194.242.2.3/dns-query" // Mullvad(备)
];
// DNS 配置
const dnsConfig = {
  "enable": true,
  "listen": "0.0.0.0:1053",
  "ipv6": true,
  "use-system-hosts": false,
  "cache-algorithm": "arc",
  "enhanced-mode": "fake-ip",
  "fake-ip-range": "198.18.0.1/16",
  "fake-ip-filter": [
    // 本地主机/设备
    "+.lan",
    "+.local",
    // Windows 网络出现小地球图标
    "+.msftconnecttest.com",
    "+.msftncsi.com",
    // QQ 快速登录检测失败
    "localhost.ptlogin2.qq.com",
    "localhost.sec.qq.com",
    // 微信快速登录检测失败
    "localhost.work.weixin.qq.com"
  ],
  "default-nameserver": ["223.5.5.5", "119.29.29.29", "1.1.1.1", "8.8.8.8"],
  "nameserver": [...domesticNameservers, ...foreignNameservers],
  "proxy-server-nameserver": [...domesticNameservers, ...foreignNameservers],
  "nameserver-policy": {
    "geosite:private,cn,geolocation-cn": domesticNameservers,
    "geosite:google,youtube,telegram,gfw,geolocation-!cn": foreignNameservers,
  }
};


// 前置规则
const prependRules = [
  // lan ip
  "IP-CIDR,172.172.0.0/32,DIRECT,no-resolve",
  "IP-CIDR,192.168.0.0/32,DIRECT,no-resolve",
  "IP-CIDR,192.192.0.0/32,DIRECT,no-resolve",
  "IP-CIDR,127.0.0.0/32,DIRECT,no-resolve",
  // DOMIAN-KEYWORD
  "DOMAIN-KEYWORD,xxx,DIRECT",
  // DOMAIN-SUFFIX
  "DOMAIN-SUFFIX,mastodon.social,BosLife",
  "DOMAIN-SUFFIX,ycombinator.com,BosLife",
  "DOMAIN-SUFFIX,deepl.com,BosLife",
  "DOMAIN-SUFFIX,andinfinity.eu,BosLife",
  "DOMAIN-SUFFIX,openrouter.ai,BosLife",
];

function main(config) {
  config["dns"] = dnsConfig;
  config.rules = prependRules.concat(config.rules);
  return config;
}
