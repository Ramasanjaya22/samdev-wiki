#!/bin/bash
# Auto-Fix DNS for agents.footygraph.com
# Run when DNS_PROBE_POSSIBLE error occurs

echo "=== DNS Auto-Fix Script ==="

# Method 1: Flush DNS cache (Linux)
echo "[1] Flushing DNS cache..."
if command -v systemd-resolve &>/dev/null; then
    sudo systemd-resolve --flush-caches 2>/dev/null && echo "  ✓ systemd-resolved cache cleared"
fi

if [ -f /etc/resolv.conf ]; then
    echo "  Current DNS servers:"
    grep "nameserver" /etc/resolv.conf 2>/dev/null | head -3
fi

# Method 2: Verify DNS resolution
echo ""
echo "[2] Checking DNS resolution..."
if nslookup agents.footygraph.com 8.8.8.8 &>/dev/null; then
    echo "  ✓ DNS resolves to Cloudflare IPs"
    nslookup agents.footygraph.com 8.8.8.8 | grep "Address" | head -3
else
    echo "  ✗ DNS resolution failed"
fi

# Method 3: Check HTTP response
echo ""
echo "[3] Testing HTTPS endpoint..."
if curl -s -o /dev/null -w "%{http_code}" --connect-timeout 5 https://agents.footygraph.com 2>/dev/null; then
    echo "  ✓ HTTPS endpoint responding"
else
    echo "  ? Could not verify HTTPS (may be DNS cache)"
fi

# Method 4: Direct IP test
echo ""
echo "[4] Testing direct service access..."
if curl -s -o /dev/null -w "%{http_code}" http://localhost:8000 2>/dev/null | grep -q "200"; then
    echo "  ✓ Local service on port 8000 working"
    echo "  Access via: http://$(hostname -I | awk '{print $1}'):8000"
fi

# Method 5: Check tunnel
echo ""
echo "[5] Checking cloudflared tunnel..."
if pgrep -f "cloudflared.*36ec9009" &>/dev/null; then
    echo "  ✓ Tunnel process running"
else
    echo "  ✗ Tunnel not running, restarting..."
    cloudflared tunnel run 36ec9009-af53-4f7f-ac31-8377d9581f42 &
fi

echo ""
echo "=== Summary ==="
echo "If DNS_PROBE_POSSIBLE persists:"
echo "  1. Clear browser DNS cache"
echo "  2. Try incognito/private window"
echo "  3. Use: https://$(hostname -I | awk '{print $1}'):8000"
echo "  4. Wait 5-10 mins for DNS propagation"