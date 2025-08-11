# Mobile Debugging Guide

## Quick Setup for Samsung Wireless Debugging

### 1. Find Your Computer's IP Address
Run the `find_ip.bat` file or manually run:
```bash
ipconfig
```
Look for an IP address like `192.168.1.100` or `192.168.0.101`

### 2. Update Flutter App
In `lib/core/services/api_service.dart`, change the `baseUrl` to your computer's IP:
```dart
static const String baseUrl = 'http://YOUR_COMPUTER_IP:5000/api';
```

### 3. Start Backend Server
Make sure your backend is running:
```bash
cd backend
npm start
```

### 4. Test Connection
- Both your computer and mobile should be on the same WiFi network
- Try accessing `http://YOUR_COMPUTER_IP:5000/api/pets` in your mobile browser
- If it works, the Flutter app should also work

### 5. Common Issues & Solutions

**Issue: Connection refused**
- Check if backend is running on port 5000
- Check if firewall is blocking port 5000
- Try `netstat -an | findstr 5000` to see if port is listening

**Issue: Can't find IP address**
- Make sure both devices are on same WiFi network
- Try `ipconfig /all` for more detailed network info

**Issue: Mobile can't connect**
- Temporarily disable Windows Firewall
- Check if antivirus is blocking connections
- Try using mobile hotspot from your phone

### 6. Alternative: Use ngrok (if above doesn't work)
```bash
# Install ngrok
npm install -g ngrok

# Start your backend
cd backend && npm start

# In another terminal, create tunnel
ngrok http 5000

# Use the ngrok URL in your Flutter app
# Example: https://abc123.ngrok.io/api
```

### 7. Test the Connection
The Flutter app will show connection status in the console. Look for:
- ✅ Connection test successful
- ❌ Connection test failed

If you see connection failures, check the IP address and network setup. 