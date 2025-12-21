document.addEventListener('DOMContentLoaded', function() {
    // Get DOM elements
    const profileForm = document.getElementById('profile-form');
    const cancelBtn = document.getElementById('cancel-btn');
    const deleteBtn = document.getElementById('delete-btn');
    const modal = document.getElementById('delete-modal');
    const closeModal = document.querySelector('.close');
    const modalCancel = document.getElementById('modal-cancel');
    const modalConfirm = document.getElementById('modal-confirm');

    // Form submission handler
    profileForm.addEventListener('submit', function(e) {
        e.preventDefault();

        // Get form values
        const email = document.getElementById('email').value;
        const username = document.getElementById('username').value;
        const password = document.getElementById('password').value;

        // In a real application, you would send this data to the server
        console.log('Updated profile:', { email, username, password });

        // Show success message (in a real app, you might use a toast notification)
        alert('Profile updated successfully!');
    });

    // Cancel button handler
    cancelBtn.addEventListener('click', function() {
        // Reset form to original values
        document.getElementById('email').value = 'johndoe@example.com';
        document.getElementById('username').value = 'JohnDoe';
        document.getElementById('password').value = '********';
    });

    // Delete button handler - open modal
    deleteBtn.addEventListener('click', function() {
        modal.style.display = 'block';
    });

    // Close modal handlers
    closeModal.addEventListener('click', function() {
        modal.style.display = 'none';
    });

    modalCancel.addEventListener('click', function() {
        modal.style.display = 'none';
    });

    // Confirm account deletion
    modalConfirm.addEventListener('click', function() {
        // In a real application, you would send a request to the server to delete the account
        alert('Your account has been deleted successfully.');
        modal.style.display = 'none';

        // Redirect to homepage (simulated)
        setTimeout(function() {
            alert('Redirecting to homepage...');
        }, 1000);
    });

    // Close modal if clicked outside
    window.addEventListener('click', function(e) {
        if (e.target === modal) {
            modal.style.display = 'none';
        }
    });

    // Add some interactive effects to glass cards
    const glassCards = document.querySelectorAll('.glass');
    glassCards.forEach(card => {
        card.addEventListener('mousemove', function(e) {
            const rect = this.getBoundingClientRect();
            const x = e.clientX - rect.left;
            const y = e.clientY - rect.top;

            this.style.setProperty('--mouse-x', `${x}px`);
            this.style.setProperty('--mouse-y', `${y}px`);
        });
    });
});