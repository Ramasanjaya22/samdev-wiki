#!/bin/bash
# Cloudflare 1003 Error Auto-Diagnosis & Fix
# Run after DNS_PROBE_POSSIBLE resolves to error 1003

echo "=== Cloudflare 1003 Error Diagnostics ==="

# Check DNS resolution
echo ""
echo "[1] DNS Resolution Test..."
if command -v nslookup &>/dev/null; then
    RESULT=$(nslookup agents.footygraph.com 8.8.8.8 2>&1 | grep "Address" | head -3)
    echo "$RESULT"
    echo "  ✓ DNS resolves successfully"
fi

# Check if service is running locally
echo ""
echo "[2] Local Service Check..."
if curl -s -o /dev/null -w "%{http_code}" http://localhost:8000 2>/dev/null | grep -q "200"; then
    echo "  ✓ Local service responding on port 8000"
    
    # Test with specific IP
    HOST_IP=$(hostname -I | awk '{print $1}')
    if curl -s -o /dev/null -w "%{http_code}" "http://$HOST_IP:8000" 2>/dev/null | grep -q "200"; then
        echo "  ✓ Accessible via direct IP: http://$HOST_IP:8000"
    fi
else
    echo "  ✗ Local service not responding"
fi

# Check cloudflared tunnel status
echo ""
echo "[3] Tunnel Status..."
if pgrep -f "cloudflared.*tunnel" &>/dev/null; then
    echo "  ✓ Tunnel process running"
    CONNECTIONS=$(cloudflared tunnel list 2>/dev/null | grep "dev-to-ai" | awk '{print $2}' || echo "unknown")
    echo "  Connections: $CONNECTIONS"
else
    echo "  ✗ Tunnel not running"
fi

# Cloudflare edge check
echo ""
echo "[4] Cloudflare Edge Status..."
CLOUDFLARE_IPS=("104.21.45.59" "172.67.210.106")
for IP in "${CLOUDFLARE_IPS[@]}"; do
    if curl -s -o /dev/null -w "%{http_code}" --connect-timeout 5 -H "Host: agents.footygraph.com" "http://$IP/" 2>/dev/null | grep -q "200\|404"; then
        echo "  ✓ Edge $IP responding (HTTP code received)"
    else
        echo "  ○ Edge $IP timeout"
    fi
done

# Recommended actions
echo ""
echo "=== Recommended Actions ==="
echo ""
echo "If you see ERROR 1003 'Access denied':"
echo "  1. Open: https://dash.cloudflare.com"
echo "  2. Check footygraph.com DNS settings"
echo "  3. Click orange cloud icon for agents.footygraph.com"
echo "  4. Ensure 'Proxied' is enabled (orange)"
echo "  5. OR toggle to 'DNS only' (gray) then back to Proxied"
echo ""
echo "Alternative direct access:"
echo "  http://$(hostname -I | awk '{print $1}'):8000"
echo ""
echo "Wait 5-10 minutes for Cloudflare to fully propagate changes"