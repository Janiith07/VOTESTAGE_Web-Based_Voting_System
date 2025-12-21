// JavaScript code to test notification display
// Copy and paste this into your browser console (F12) while on the contestant dashboard

console.log('🧪 Testing notification display...');

// Test 1: Check if notification elements exist
const notificationContent = document.getElementById('notificationContent');
const notificationDropdown = document.getElementById('notificationDropdown');
const notificationBadge = document.getElementById('notificationBadge');

console.log('📋 Element check:');
console.log('- notificationContent:', notificationContent);
console.log('- notificationDropdown:', notificationDropdown);
console.log('- notificationBadge:', notificationBadge);

// Test 2: Check current badge count
if (notificationBadge) {
    console.log('📊 Current badge count:', notificationBadge.textContent);
    console.log('📊 Badge display style:', notificationBadge.style.display);
}

// Test 3: Check dropdown state
if (notificationDropdown) {
    console.log('📂 Dropdown classes:', notificationDropdown.className);
    console.log('📂 Dropdown display:', notificationDropdown.style.display);
}

// Test 4: Check current content
if (notificationContent) {
    console.log('📄 Current content HTML:', notificationContent.innerHTML);
}

// Test 5: Force load notifications
console.log('🔄 Forcing notification load...');
loadNotifications();

// Test 6: Create test notifications manually
function createTestNotification() {
    const testNotifications = [
        {
            id: 1,
            recipientId: 'P001',
            senderId: 'P002',
            message: 'Judge P002 gave you a golden vote! 🏆',
            type: 'GOLDEN_VOTE',
            createdAt: new Date().toISOString(),
            isRead: false
        },
        {
            id: 2,
            recipientId: 'P001',
            senderId: 'P003',
            message: 'Judge P003 voted for your performance! ⭐',
            type: 'REGULAR_VOTE',
            createdAt: new Date(Date.now() - 300000).toISOString(),
            isRead: true
        }
    ];
    
    console.log('🧪 Creating test notifications:', testNotifications);
    displayNotifications(testNotifications);
}

// Test 7: Test AJAX endpoint directly
function testAjaxEndpoint() {
    console.log('🌐 Testing AJAX endpoint...');
    
    fetch('/VoteStage/notifications?action=getAll')
        .then(response => {
            console.log('📡 Response status:', response.status);
            console.log('📡 Response headers:', [...response.headers.entries()]);
            return response.text(); // Get as text first to see raw response
        })
        .then(text => {
            console.log('📄 Raw response:', text);
            try {
                const data = JSON.parse(text);
                console.log('📊 Parsed data:', data);
                console.log('📊 Data type:', typeof data);
                console.log('📊 Data length:', data ? data.length : 'null');
            } catch (e) {
                console.error('❌ JSON parse error:', e);
            }
        })
        .catch(error => {
            console.error('❌ Fetch error:', error);
        });
}

// Run all tests
console.log('🚀 Running all tests...');
console.log('1. Element check completed above');
console.log('2. Run createTestNotification() to test display');
console.log('3. Run testAjaxEndpoint() to test server response');

// Auto-run AJAX test
testAjaxEndpoint();

console.log('✅ Test setup complete!');
