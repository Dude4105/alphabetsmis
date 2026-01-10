// SMIS - Student Management Information System
// Main JavaScript file with all interactive features

class SMIS {
    constructor() {
        this.init();
    }

    init() {
        this.setupEventListeners();
        this.initAnimations();
        this.initParticleBackground();
        this.initScrollReveal();
        this.initTestimonialSlider();
        this.initCounterAnimations();
        this.initTypedText();
    }

    setupEventListeners() {
        // Modal controls
        const loginBtn = document.getElementById('loginBtn');
        const registerBtn = document.getElementById('registerBtn');

        // Modals
        const loginModal = document.getElementById('loginModal');
        const closeModal = document.getElementById('closeModal');

        const RegisterModal = document.getElementById('RegisterModal');
        const closeRegisterModal = document.getElementById('closeRegisterModal');

        

        if (loginBtn) {
            loginBtn.addEventListener('click', () => this.showModal(loginModal));
        }

        if (registerBtn) {
            registerBtn.addEventListener('click', () => this.showModal(RegisterModal));
        }

        if (closeModal) {
            closeModal.addEventListener('click', () => this.hideModal(loginModal));
            
        }
        if (closeRegisterModal) {
            closeRegisterModal.addEventListener('click', () => this.hideModal(RegisterModal));
        }

        // Close modal on outside click
        if (loginModal) {
            loginModal.addEventListener('click', (e) => {
                if (e.target === loginModal) {
                    this.hideModal(loginModal);
                }
            });
        }
        if (RegisterModal) {
            RegisterModal.addEventListener('click', (e) => {
                if (e.target === RegisterModal) {
                    this.hideModal(RegisterModal);
                }
            });
        }   

        // Portal access buttons
        document.querySelectorAll('.portal-card button').forEach(button => {
            button.addEventListener('click', (e) => {
                const card = e.target.closest('.portal-card');
                const portalType = card.querySelector('h3').textContent;
                this.navigateToPortal(portalType);
            });
        });

        // Modal portal selection
        document.querySelectorAll('#loginModal button').forEach(button => {
            if (button.textContent.includes('Student Portal')) {
                button.addEventListener('click', () => this.navigateToPortal('Student Portal'));
            } else if (button.textContent.includes('Teacher Portal')) {
                button.addEventListener('click', () => this.navigateToPortal('Teacher Portal'));
            } else if (button.textContent.includes('Admin Portal')) {
                button.addEventListener('click', () => this.navigateToPortal('Admin Portal'));
            }
        });

        // Smooth scrolling for navigation
        document.querySelectorAll('a[href^="#"]').forEach(anchor => {
            anchor.addEventListener('click', (e) => {
                e.preventDefault();
                const target = document.querySelector(anchor.getAttribute('href'));
                if (target) {
                    target.scrollIntoView({
                        behavior: 'smooth',
                        block: 'start'
                    });
                }
            });
        });

        // Mobile menu toggle (if needed)
        this.initMobileMenu();
    }

    showModal(modal) {
        if (modal) {
            modal.classList.remove('hidden');
            setTimeout(() => {
                modal.querySelector('.bg-white').style.transform = 'scale(1)';
            }, 10);
        }
    }

    hideModal(modal) {
        if (modal) {
            modal.querySelector('.bg-white').style.transform = 'scale(0.95)';
            setTimeout(() => {
                modal.classList.add('hidden');
            }, 200);
        }
    }

    navigateToPortal(portalType) {
        let targetPage = '';
        
        switch(portalType) {
            case 'Student Portal':
                targetPage = 'student-portal.html';
                break;
            case 'Teacher Portal':
                targetPage = 'teacher-portal.html';
                break;
            case 'Admin Portal':
                targetPage = 'admin-portal.html';
                break;
            default:
                targetPage = 'index.html';
        }

        // Animate transition
        this.animatePageTransition(() => {
            window.location.href = targetPage;
        });
    }

    animatePageTransition(callback) {
        // Create overlay
        const overlay = document.createElement('div');
        overlay.style.cssText = `
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: linear-gradient(135deg, #1e3a5f 0%, #4a90a4 100%);
            z-index: 9999;
            display: flex;
            align-items: center;
            justify-content: center;
            opacity: 0;
            transition: opacity 0.3s ease;
        `;

        overlay.innerHTML = `
            <div style="color: white; text-align: center;">
                <div style="width: 60px; height: 60px; border: 4px solid rgba(255,255,255,0.3); border-top: 4px solid white; border-radius: 50%; animation: spin 1s linear infinite; margin: 0 auto 1rem;"></div>
                <p style="font-size: 1.2rem; font-weight: 500;">Loading Portal...</p>
            </div>
        `;

        document.body.appendChild(overlay);

        // Add spinner animation
        const style = document.createElement('style');
        style.textContent = `
            @keyframes spin {
                0% { transform: rotate(0deg); }
                100% { transform: rotate(360deg); }
            }
        `;
        document.head.appendChild(style);

        // Animate in
        setTimeout(() => {
            overlay.style.opacity = '1';
        }, 10);

        // Execute callback after animation
        setTimeout(() => {
            callback();
        }, 500);
    }

    initAnimations() {
        // Animate feature cards on hover
        document.querySelectorAll('.card-hover').forEach(card => {
            card.addEventListener('mouseenter', () => {
                anime({
                    targets: card,
                    scale: 1.02,
                    duration: 300,
                    easing: 'easeOutQuad'
                });
            });

            card.addEventListener('mouseleave', () => {
                anime({
                    targets: card,
                    scale: 1,
                    duration: 300,
                    easing: 'easeOutQuad'
                });
            });
        });

        // Animate portal cards
        document.querySelectorAll('.portal-card').forEach((card, index) => {
            card.addEventListener('mouseenter', () => {
                anime({
                    targets: card,
                    translateY: -10,
                    scale: 1.02,
                    duration: 400,
                    easing: 'easeOutElastic(1, .8)'
                });
            });

            card.addEventListener('mouseleave', () => {
                anime({
                    targets: card,
                    translateY: 0,
                    scale: 1,
                    duration: 400,
                    easing: 'easeOutElastic(1, .8)'
                });
            });
        });

        // Animate feature icons
        document.querySelectorAll('.feature-icon').forEach(icon => {
            icon.addEventListener('mouseenter', () => {
                anime({
                    targets: icon,
                    scale: 1.1,
                    rotate: '5deg',
                    duration: 300,
                    easing: 'easeOutBack'
                });
            });

            icon.addEventListener('mouseleave', () => {
                anime({
                    targets: icon,
                    scale: 1,
                    rotate: '0deg',
                    duration: 300,
                    easing: 'easeOutBack'
                });
            });
        });
    }

    initParticleBackground() {
        const canvas = document.getElementById('particleCanvas');
        if (!canvas) return;

        const ctx = canvas.getContext('2d');
        let particles = [];
        let animationId;

        // Resize canvas
        const resizeCanvas = () => {
            canvas.width = window.innerWidth;
            canvas.height = window.innerHeight;
        };

        resizeCanvas();
        window.addEventListener('resize', resizeCanvas);

        // Particle class
        class Particle {
            constructor() {
                this.x = Math.random() * canvas.width;
                this.y = Math.random() * canvas.height;
                this.vx = (Math.random() - 0.5) * 0.5;
                this.vy = (Math.random() - 0.5) * 0.5;
                this.size = Math.random() * 2 + 1;
                this.opacity = Math.random() * 0.3 + 0.1;
            }

            update() {
                this.x += this.vx;
                this.y += this.vy;

                if (this.x < 0 || this.x > canvas.width) this.vx *= -1;
                if (this.y < 0 || this.y > canvas.height) this.vy *= -1;
            }

            draw() {
                ctx.beginPath();
                ctx.arc(this.x, this.y, this.size, 0, Math.PI * 2);
                ctx.fillStyle = `rgba(255, 255, 255, ${this.opacity})`;
                ctx.fill();
            }
        }

        // Create particles
        for (let i = 0; i < 50; i++) {
            particles.push(new Particle());
        }

        // Animate particles
        const animate = () => {
            ctx.clearRect(0, 0, canvas.width, canvas.height);

            particles.forEach(particle => {
                particle.update();
                particle.draw();
            });

            // Draw connections
            particles.forEach((particle, i) => {
                particles.slice(i + 1).forEach(otherParticle => {
                    const dx = particle.x - otherParticle.x;
                    const dy = particle.y - otherParticle.y;
                    const distance = Math.sqrt(dx * dx + dy * dy);

                    if (distance < 100) {
                        ctx.beginPath();
                        ctx.moveTo(particle.x, particle.y);
                        ctx.lineTo(otherParticle.x, otherParticle.y);
                        ctx.strokeStyle = `rgba(255, 255, 255, ${0.1 * (1 - distance / 100)})`;
                        ctx.lineWidth = 1;
                        ctx.stroke();
                    }
                });
            });

            animationId = requestAnimationFrame(animate);
        };

        animate();
    }

    initScrollReveal() {
        const observerOptions = {
            threshold: 0.1,
            rootMargin: '0px 0px -50px 0px'
        };

        const observer = new IntersectionObserver((entries) => {
            entries.forEach(entry => {
                if (entry.isIntersecting) {
                    entry.target.classList.add('revealed');
                    
                    // Stagger animation for multiple elements
                    const siblings = Array.from(entry.target.parentNode.children);
                    const index = siblings.indexOf(entry.target);
                    
                    anime({
                        targets: entry.target,
                        opacity: [0.9, 1],
                        translateY: [20, 0],
                        duration: 600,
                        delay: index * 100,
                        easing: 'easeOutQuad'
                    });
                }
            });
        }, observerOptions);

        document.querySelectorAll('.scroll-reveal').forEach(el => {
            observer.observe(el);
        });
    }

    initTestimonialSlider() {
        const testimonialSlider = document.getElementById('testimonial-slider');
        if (!testimonialSlider) return;

        new Splide(testimonialSlider, {
            type: 'loop',
            perPage: 1,
            perMove: 1,
            gap: '2rem',
            autoplay: true,
            interval: 5000,
            pauseOnHover: true,
            arrows: false,
            pagination: true,
            breakpoints: {
                768: {
                    perPage: 1,
                }
            }
        }).mount();
    }

    initCounterAnimations() {
        const counters = document.querySelectorAll('.stats-counter');
        
        const animateCounter = (counter) => {
            const target = parseInt(counter.getAttribute('data-target'));
            const duration = 2000;
            const increment = target / (duration / 16);
            let current = 0;

            const updateCounter = () => {
                current += increment;
                if (current < target) {
                    counter.textContent = Math.floor(current).toLocaleString();
                    requestAnimationFrame(updateCounter);
                } else {
                    counter.textContent = target.toLocaleString();
                }
            };

            updateCounter();
        };

        const counterObserver = new IntersectionObserver((entries) => {
            entries.forEach(entry => {
                if (entry.isIntersecting) {
                    animateCounter(entry.target);
                    counterObserver.unobserve(entry.target);
                }
            });
        }, { threshold: 0.5 });

        counters.forEach(counter => {
            counterObserver.observe(counter);
        });
    }

    initTypedText() {
        const typedElement = document.getElementById('typed-text');
        if (!typedElement) return;

        new Typed(typedElement, {
            strings: [
                'Transform Your Institution',
                'Empower Your Students',
                'Streamline Your Operations',
                'Enhance Communication'
            ],
            typeSpeed: 80,
            backSpeed: 50,
            backDelay: 2000,
            loop: true,
            showCursor: true,
            cursorChar: '|',
            autoInsertCss: true
        });
    }

    initMobileMenu() {
        // Mobile menu functionality can be added here
        const mobileMenuBtn = document.getElementById('mobileMenuBtn');
        const mobileMenu = document.getElementById('mobileMenu');

        if (mobileMenuBtn && mobileMenu) {
            mobileMenuBtn.addEventListener('click', () => {
                mobileMenu.classList.toggle('hidden');
            });
        }
    }

    // Utility functions
    showNotification(message, type = 'info') {
        const notification = document.createElement('div');
        notification.className = `fixed top-4 right-4 z-50 p-4 rounded-lg shadow-lg max-w-sm transform translate-x-full transition-transform duration-300`;
        
        const colors = {
            info: 'bg-blue-500 text-white',
            success: 'bg-green-500 text-white',
            warning: 'bg-yellow-500 text-black',
            error: 'bg-red-500 text-white'
        };

        notification.className += ` ${colors[type]}`;
        notification.textContent = message;

        document.body.appendChild(notification);

        // Animate in
        setTimeout(() => {
            notification.style.transform = 'translateX(0)';
        }, 10);

        // Auto remove
        setTimeout(() => {
            notification.style.transform = 'translateX(100%)';
            setTimeout(() => {
                document.body.removeChild(notification);
            }, 300);
        }, 3000);
    }

    // Simulate API calls
    async simulateApiCall(endpoint, data = null, delay = 1000) {
        return new Promise((resolve) => {
            setTimeout(() => {
                resolve({
                    success: true,
                    data: data || { message: 'Operation completed successfully' },
                    timestamp: new Date().toISOString()
                });
            }, delay);
        });
    }

    // Local storage management
    saveToStorage(key, data) {
        try {
            localStorage.setItem(key, JSON.stringify(data));
            return true;
        } catch (error) {
            console.error('Storage error:', error);
            return false;
        }
    }

    getFromStorage(key) {
        try {
            const data = localStorage.getItem(key);
            return data ? JSON.parse(data) : null;
        } catch (error) {
            console.error('Storage error:', error);
            return null;
        }
    }

    // Form validation
    validateForm(formData) {
        const errors = [];
        
        for (const [key, value] of formData.entries()) {
            if (!value || value.trim() === '') {
                errors.push(`${key} is required`);
            }
        }

        return {
            isValid: errors.length === 0,
            errors
        };
    }

    // Data formatting
    formatDate(date) {
        return new Intl.DateTimeFormat('en-US', {
            year: 'numeric',
            month: 'long',
            day: 'numeric'
        }).format(new Date(date));
    }

    formatCurrency(amount) {
        return new Intl.NumberFormat('en-US', {
            style: 'currency',
            currency: 'USD'
        }).format(amount);
    }

    formatGrade(grade) {
        if (grade >= 90) return 'A';
        if (grade >= 80) return 'B';
        if (grade >= 70) return 'C';
        if (grade >= 60) return 'D';
        return 'F';
    }
}

// Initialize the application when DOM is loaded
document.addEventListener('DOMContentLoaded', () => {
    window.smis = new SMIS();
    
    // Add some sample data to localStorage for demonstration
    const sampleData = {
        user: {
            id: 1,
            name: 'John Doe',
            email: 'john@smis.edu',
            type: 'student'
        },
        preferences: {
            theme: 'light',
            language: 'en'
        }
    };
    
    if (!window.smis.getFromStorage('smis_user')) {
        window.smis.saveToStorage('smis_user', sampleData);
    }
});

// Export for use in other files
if (typeof module !== 'undefined' && module.exports) {
    module.exports = SMIS;
}