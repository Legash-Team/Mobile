/**
 * Lightweight Zero-Dependency Mock Server for Legash Mobile Testing
 * Run with: node tool/mock_server.js
 */
const http = require('http');

const PORT = 3000;

const mockDonor = {
  id: 'donor-mock-1',
  name: 'Abebe Kebede',
  phone: '+251911223344',
  shortId: 'LG-849201',
  bloodType: 'A+',
  gender: 'male',
  dob: '1995-05-14T00:00:00.000Z',
  weightKg: 74,
  heightCm: 178,
  fin: '098765432109',
  healthNotes: 'Regular donor, no recent medical conditions.',
};

const mockEvents = [
  {
    id: 'evt-1',
    title: 'National Blood Donation Drive',
    description: 'Join us at Meskel Square to support regional hospitals in need of emergency blood units.',
    location: 'Meskel Square, Addis Ababa',
    date: new Date(Date.now() + 86400000 * 3).toISOString(),
    mediaType: 'video',
    mediaUrl: 'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4',
    postedBy: {
      type: 'admin',
      name: 'Red Cross Ethiopia',
    },
  },
  {
    id: 'evt-2',
    title: 'Hospital Urgent Reserve Campaign',
    description: 'Tikur Anbessa Hospital requires immediate O- and A+ blood donations for pediatric surgery.',
    location: 'Black Lion Hospital, Addis Ababa',
    date: new Date(Date.now() + 86400000 * 7).toISOString(),
    mediaType: 'image',
    mediaUrl: 'https://images.unsplash.com/photo-1615461066841-6116e61058f4?w=800',
    postedBy: {
      type: 'hospital',
      name: 'Tikur Anbessa Specialized Hospital',
    },
  },
];

const mockFeed = [
  {
    id: 'post-1',
    title: 'Thank You Donors!',
    body: 'Over 250 units collected this past weekend across regional donation centers.',
    imageUrl: 'https://images.unsplash.com/photo-1579154204601-01588f351e67?w=800',
    createdAt: new Date().toISOString(),
    postedBy: {
      type: 'admin',
      name: 'National Blood Bank Service',
    },
  },
  {
    id: 'post-2',
    title: 'Blood Compatibility Guide',
    body: 'Did you know O- is the universal donor for red blood cells? Read how matching works.',
    createdAt: new Date(Date.now() - 86400000).toISOString(),
    postedBy: {
      type: 'admin',
      name: 'Legash Health Team',
    },
  },
];

const server = http.createServer((req, res) => {
  // CORS headers
  res.setHeader('Access-Control-Allow-Origin', '*');
  res.setHeader('Access-Control-Allow-Methods', 'GET, POST, PUT, DELETE, OPTIONS');
  res.setHeader('Access-Control-Allow-Headers', 'Content-Type, Authorization, Accept');
  res.setHeader('Content-Type', 'application/json');

  if (req.method === 'OPTIONS') {
    res.writeHead(204);
    res.end();
    return;
  }

  const url = new URL(req.url, `http://${req.headers.host}`);
  const pathname = url.pathname;

  let body = '';
  req.on('data', chunk => {
    body += chunk;
  });

  req.on('end', () => {
    console.log(`[${req.method}] ${pathname}`);

    // Auth / Unlock
    if (pathname === '/api/donor/unlock' && req.method === 'POST') {
      res.writeHead(200);
      res.end(JSON.stringify({
        success: true,
        token: 'mock-jwt-token-12345',
        donor: mockDonor,
      }));
      return;
    }

    // Register
    if (pathname === '/api/donor/register' && req.method === 'POST') {
      res.writeHead(200);
      res.end(JSON.stringify({
        success: true,
        message: 'OTP sent successfully',
      }));
      return;
    }

    // Verify OTP
    if (pathname === '/api/donor/verify-otp' && req.method === 'POST') {
      res.writeHead(200);
      res.end(JSON.stringify({
        success: true,
        message: 'OTP verified successfully',
      }));
      return;
    }

    // Set PIN
    if (pathname === '/api/donor/set-pin' && req.method === 'POST') {
      res.writeHead(200);
      res.end(JSON.stringify({
        success: true,
        token: 'mock-jwt-token-12345',
        donor: mockDonor,
      }));
      return;
    }

    // Profile GET
    if (pathname === '/api/donor/profile' && req.method === 'GET') {
      res.writeHead(200);
      res.end(JSON.stringify({
        success: true,
        profile: mockDonor,
      }));
      return;
    }

    // Profile UPDATE
    if (pathname === '/api/donor/profile' && req.method === 'PUT') {
      try {
        const updates = JSON.parse(body || '{}');
        Object.assign(mockDonor, updates);
      } catch (_) {}
      res.writeHead(200);
      res.end(JSON.stringify({
        success: true,
        profile: mockDonor,
      }));
      return;
    }

    // Change PIN
    if (pathname === '/api/donor/change-pin' && req.method === 'POST') {
      res.writeHead(200);
      res.end(JSON.stringify({
        success: true,
        message: 'PIN changed successfully',
      }));
      return;
    }

    // Events
    if (pathname === '/api/donor/events' || pathname === '/api/events') {
      res.writeHead(200);
      res.end(JSON.stringify({
        success: true,
        events: mockEvents,
      }));
      return;
    }

    // Feed
    if (pathname === '/api/donor/feed' || pathname === '/api/feed') {
      res.writeHead(200);
      res.end(JSON.stringify({
        success: true,
        posts: mockFeed,
      }));
      return;
    }

    // Notifications / Blood requests
    if (pathname.includes('/requests') || pathname.includes('/notifications')) {
      res.writeHead(200);
      res.end(JSON.stringify({
        success: true,
        requests: [],
        notifications: [],
      }));
      return;
    }

    // Default fallback
    res.writeHead(200);
    res.end(JSON.stringify({
      success: true,
      message: 'Mock response',
    }));
  });
});

server.listen(PORT, '0.0.0.0', () => {
  console.log(`\nLegash Mock API Server is running!`);
  console.log(`- Local URL:   http://localhost:${PORT}`);
  console.log(`- Android URL: http://10.0.2.2:${PORT}`);
  console.log(`Press Ctrl+C to stop.\n`);
});
