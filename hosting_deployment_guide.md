# SMIS Hosting & Deployment Guide

## Recommended Hosting Providers

### 1. **Vercel** (Recommended for Frontend)
**Best for:** Static sites, frontend deployment, excellent performance
- **Pros:** 
  - Automatic deployments from Git
  - Global CDN with edge functions
  - Excellent performance and uptime
  - Free tier available
  - Built-in analytics
- **Pricing:** Free for personal projects, $20/month for pro
- **Deployment:** Connect your Git repository and deploy automatically

### 2. **Netlify** (Alternative for Frontend)
**Best for:** Static sites, JAMstack applications
- **Pros:**
  - Continuous deployment from Git
  - Form handling and serverless functions
  - Split testing and branch previews
  - Free SSL certificates
- **Pricing:** Free tier available, $19/month for pro
- **Deployment:** Drag & drop or Git-based deployment

### 3. **Heroku** (Backend & Full Stack)
**Best for:** Node.js applications, full-stack deployment
- **Pros:**
  - Easy Node.js deployment
  - Add-on ecosystem (MySQL, Redis, etc.)
  - Simple scaling options
  - Git-based deployment
- **Pricing:** Free tier discontinued, $7/month for basic dyno
- **Deployment:** Git push to Heroku remote

### 4. **DigitalOcean** (Full Control)
**Best for:** VPS hosting, full server control
- **Pros:**
  - Full root access to server
  - One-click app deployments
  - Scalable infrastructure
  - Competitive pricing
- **Pricing:** $5/month for basic droplet
- **Deployment:** Manual server setup or use App Platform

### 5. **AWS (Amazon Web Services)** (Enterprise)
**Best for:** Enterprise applications, scalable infrastructure
- **Pros:**
  - Highly scalable and reliable
  - Comprehensive service ecosystem
  - Global infrastructure
  - Enterprise-grade security
- **Pricing:** Pay-as-you-go, free tier available for 12 months
- **Deployment:** Multiple options (EC2, Elastic Beanstalk, Amplify)

## Backend & Database Hosting

### **MySQL Database Options:**

1. **PlanetScale** (Recommended)
   - MySQL-compatible serverless database
   - Free tier: 5GB storage, 1 billion row reads/month
   - Automatic scaling and backups
   - Connection pooling included

2. **Railway** 
   - All-in-one platform with database included
   - $5/month for basic plan
   - PostgreSQL and MySQL support
   - Automatic deployments

3. **Supabase**
   - PostgreSQL-based backend-as-a-service
   - Free tier with generous limits
   - Real-time subscriptions included
   - REST API automatically generated

4. **AWS RDS**
   - Managed MySQL database service
   - Highly available and scalable
   - Automated backups and patching
   - Starts at $15/month for small instance

### **Node.js Backend Hosting:**

1. **Railway** (Recommended for simplicity)
   - Automatic deployments from Git
   - Database included
   - Environment variables management
   - $5/month starter plan

2. **Heroku**
   - Easy Node.js deployment
   - Add-on ecosystem
   - Simple scaling
   - $7/month for basic dyno

3. **DigitalOcean App Platform**
   - Modern app deployment platform
   - Automatic SSL and CDN
   - Database integration
   - $5/month for basic plan

4. **AWS Lambda + API Gateway**
   - Serverless architecture
   - Pay-per-request pricing
   - Automatic scaling
   - Free tier includes 1M requests/month

## Complete Deployment Architecture

### **Recommended Stack:**

```
Frontend (Static Site):
├── Vercel/Netlify (Free/Paid)
├── Custom domain with SSL
└── Global CDN for performance

Backend (Node.js API):
├── Railway ($5/month) or Heroku ($7/month)
├── Environment variables for secrets
└── CORS configured for frontend

Database (MySQL):
├── PlanetScale (Free tier)
├── Connection pooling
└── Automated backups

Storage (Optional):
├── AWS S3 for file uploads
├── CloudFront CDN for images
└── Presigned URLs for security
```

### **Alternative Full-Stack Solution:**

```
All-in-One Platform:
├── Railway ($5-20/month)
├── PostgreSQL/MySQL included
├── Automatic deployments
├── Environment management
└── Built-in monitoring
```

## Step-by-Step Deployment Guide

### **Option 1: Vercel + Railway (Recommended)**

#### **1. Frontend Deployment (Vercel)**

1. **Push code to GitHub**
   ```bash
   git init
   git add .
   git commit -m "Initial SMIS deployment"
   git remote add origin https://github.com/yourusername/smis-project
   git push -u origin main
   ```

2. **Connect to Vercel**
   - Go to [vercel.com](https://vercel.com)
   - Sign up with GitHub
   - Import your repository
   - Configure build settings (if needed)
   - Deploy automatically

3. **Configure Custom Domain**
   - Add your domain in Vercel dashboard
   - Update DNS records as instructed
   - SSL certificate automatically provisioned

#### **2. Backend Deployment (Railway)**

1. **Create Railway Account**
   - Go to [railway.app](https://railway.app)
   - Sign up with GitHub
   - Create new project

2. **Deploy Backend**
   - Connect your backend repository
   - Add environment variables:
     ```
     DATABASE_URL=your_planetscale_connection_string
     JWT_SECRET=your_jwt_secret
     PORT=3000
     ```
   - Deploy automatically

3. **Add Database**
   - Create PlanetScale account
   - Create new database
   - Get connection string
   - Add to Railway environment variables

#### **3. Configure CORS**

In your Node.js backend:
```javascript
app.use(cors({
  origin: ['https://your-domain.vercel.app', 'https://your-custom-domain.com'],
  credentials: true
}));
```

### **Option 2: Heroku (Traditional)**

#### **1. Install Heroku CLI**
```bash
# macOS
brew tap heroku/brew && brew install heroku

# Windows
choco install heroku-cli

# Ubuntu/Debian
sudo snap install --classic heroku
```

#### **2. Create Heroku App**
```bash
heroku create your-smis-app
heroku git:remote -a your-smis-app
```

#### **3. Add Database**
```bash
heroku addons:create cleardb:ignite
heroku config:get CLEARDB_DATABASE_URL
```

#### **4. Configure Environment**
```bash
heroku config:set JWT_SECRET=your_secret_key
heroku config:set NODE_ENV=production
```

#### **5. Deploy**
```bash
git add .
git commit -m "Deploy to Heroku"
git push heroku main
```

### **Option 3: DigitalOcean (Full Control)**

#### **1. Create Droplet**
- Ubuntu 20.04 LTS
- $10/month plan (2GB RAM)
- Add SSH keys for security

#### **2. Install Dependencies**
```bash
# Connect to server
ssh root@your-droplet-ip

# Update system
apt update && apt upgrade -y

# Install Node.js
curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
apt-get install -y nodejs

# Install MySQL
apt install mysql-server mysql-client

# Install PM2 for process management
npm install -g pm2
```

#### **3. Setup MySQL**
```bash
mysql_secure_installation
mysql -u root -p

CREATE DATABASE smis_db;
CREATE USER 'smis_user'@'localhost' IDENTIFIED BY 'strong_password';
GRANT ALL PRIVILEGES ON smis_db.* TO 'smis_user'@'localhost';
FLUSH PRIVILEGES;
```

#### **4. Deploy Application**
```bash
# Clone repository
git clone https://github.com/yourusername/smis-backend.git
cd smis-backend

# Install dependencies
npm install

# Create .env file
cp .env.example .env
nano .env  # Edit with your database credentials

# Run database migrations
npm run migrate

# Start with PM2
pm2 start app.js --name "smis-backend"
pm2 startup
pm2 save
```

#### **5. Configure Nginx**
```bash
apt install nginx

# Create config file
nano /etc/nginx/sites-available/smis
```

Add configuration:
```nginx
server {
    listen 80;
    server_name your-domain.com;

    location / {
        proxy_pass http://localhost:3000;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host $host;
        proxy_cache_bypass $http_upgrade;
    }
}
```

Enable site:
```bash
ln -s /etc/nginx/sites-available/smis /etc/nginx/sites-enabled/
nginx -t
systemctl restart nginx
```

#### **6. Setup SSL with Let's Encrypt**
```bash
apt install certbot python3-certbot-nginx
certbot --nginx -d your-domain.com
```

## Environment Configuration

### **Frontend Environment Variables:**
```env
VITE_API_URL=https://your-backend-domain.com
VITE_APP_NAME=SMIS
VITE_APP_VERSION=1.0.0
```

### **Backend Environment Variables:**
```env
NODE_ENV=production
PORT=3000
DATABASE_URL=mysql://user:password@localhost:3306/smis_db
JWT_SECRET=your_super_secret_jwt_key
CORS_ORIGIN=https://your-frontend-domain.com
SESSION_SECRET=your_session_secret
EMAIL_SERVICE=sendgrid
EMAIL_API_KEY=your_sendgrid_api_key
```

## Database Setup

### **1. Import Database Schema**
```bash
mysql -u root -p smis_db < database_schema.sql
```

### **2. Create Initial Admin User**
```sql
INSERT INTO users (username, email, password_hash, user_type, first_name, last_name, is_active, email_verified) 
VALUES ('admin', 'admin@yourdomain.com', '$2y$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LewdBPj/J9eHCOwOOa', 'admin', 'System', 'Administrator', TRUE, TRUE);
```

### **3. Configure Database Connection Pool**
```javascript
const pool = mysql.createPool({
  host: process.env.DB_HOST,
  user: process.env.DB_USER,
  password: process.env.DB_PASSWORD,
  database: process.env.DB_NAME,
  connectionLimit: 10,
  acquireTimeout: 60000,
  timeout: 60000
});
```

## Security Best Practices

### **1. Use HTTPS**
- Always use SSL certificates
- Redirect HTTP to HTTPS
- Use HSTS headers

### **2. Environment Variables**
- Never commit secrets to Git
- Use environment variables for sensitive data
- Rotate keys regularly

### **3. Database Security**
- Use strong passwords
- Limit database user permissions
- Regular backups
- Use connection pooling

### **4. Application Security**
- Input validation and sanitization
- Use prepared statements for SQL
- Implement rate limiting
- Use CSRF protection
- Keep dependencies updated

### **5. Monitoring**
- Set up error logging (Sentry, LogRocket)
- Monitor application performance
- Set up alerts for downtime
- Regular security audits

## Monitoring and Maintenance

### **1. PM2 Monitoring**
```bash
pm2 monit
pm2 logs
pm2 list
```

### **2. Server Monitoring**
```bash
# Install monitoring tools
apt install htop
apt install vnstat

# Check server resources
htop
free -h
df -h
```

### **3. Log Rotation**
```bash
# Setup log rotation
nano /etc/logrotate.d/smis
```

Add configuration:
```
/var/log/smis/*.log {
    daily
    rotate 14
    compress
    delaycompress
    missingok
    notifempty
    create 0640 www-data www-data
}
```

### **4. Backup Strategy**
```bash
# Database backup script
#!/bin/bash
DATE=$(date +%Y%m%d_%H%M%S)
mysqldump -u root -p your_password smis_db > /backup/smis_backup_$DATE.sql
gzip /backup/smis_backup_$DATE.sql
```

### **5. SSL Certificate Renewal**
```bash
# Test renewal
sudo certbot renew --dry-run

# Setup auto-renewal
sudo crontab -e
```

Add line:
```
0 12 * * * /usr/bin/certbot renew --quiet
```

## Cost Breakdown

### **Recommended Stack (Monthly):**
- **Vercel Frontend:** $0 (free tier) or $20 (pro)
- **Railway Backend:** $5-20 (depending on usage)
- **PlanetScale Database:** $0 (free tier) or $29 (pro)
- **Custom Domain:** $10-15/year
- **Total:** $5-69/month

### **Alternative Stack (Monthly):**
- **DigitalOcean Droplet:** $10-20
- **Domain + SSL:** $10-15/year
- **Email Service:** $0-10
- **Monitoring:** $0-20
- **Total:** $10-50/month

## Performance Optimization

### **1. Frontend Optimization**
- Use lazy loading for images
- Minimize JavaScript bundle size
- Enable compression (gzip/brotli)
- Use CDN for static assets
- Implement service workers

### **2. Backend Optimization**
- Enable response compression
- Use database indexing
- Implement caching (Redis)
- Optimize database queries
- Use connection pooling

### **3. Database Optimization**
- Create proper indexes
- Use query optimization
- Implement read replicas
- Regular maintenance tasks
- Monitor slow queries

## Troubleshooting

### **Common Issues:**

1. **Database Connection Failed**
   - Check database credentials
   - Verify database server is running
   - Check network connectivity
   - Review firewall settings

2. **CORS Errors**
   - Verify CORS configuration
   - Check frontend domain in backend
   - Ensure proper headers are set

3. **SSL Certificate Issues**
   - Check certificate expiration
   - Verify domain configuration
   - Test with SSL checker tools

4. **Performance Issues**
   - Monitor server resources
   - Check database query performance
   - Review application logs
   - Use profiling tools

## Support and Maintenance

### **Regular Tasks:**
- Weekly security updates
- Monthly performance review
- Quarterly backup testing
- Semi-annual security audit
- Annual infrastructure review

### **Emergency Procedures:**
- Database recovery plan
- Server failover strategy
- Communication plan for users
- Rollback procedures

## Conclusion

This SMIS platform is production-ready and can be deployed using any of the recommended hosting providers. The most cost-effective solution for starting out is **Vercel + Railway + PlanetScale**, which provides excellent performance and scalability at minimal cost.

For enterprise deployments, consider **AWS** or **DigitalOcean** for full control and compliance requirements.

Remember to:
- Start with the free tiers to test
- Monitor costs as you scale
- Implement proper security measures
- Regular backups and monitoring
- Keep all dependencies updated

The platform is designed to handle thousands of users and can scale as your institution grows.