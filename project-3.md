# Project 1: Complete CI/CD Pipeline with Jenkins & Docker

## 🎯 Objective

Build an end-to-end CI/CD pipeline using Jenkins and Docker that automatically builds, tests, containerizes, and deploys an application, demonstrating your mastery of Git, Jenkins, Docker, Linux, and Shell scripting.

## 📝 Project Description

Create a fully automated CI/CD pipeline that:
- Pulls code from a Git repository
- Builds an application
- Runs automated tests
- Creates a Docker image
- Pushes the image to Docker Hub
- Deploys the application using Docker
- Sends notifications on success/failure

## 🛠️ Technologies Used

- **Version Control**: Git, GitHub
- **CI/CD**: Jenkins
- **Containerization**: Docker
- **Scripting**: Bash Shell Scripts
- **OS**: Linux

## 📋 Prerequisites

- Linux machine (Ubuntu/CentOS) or VM
- Jenkins installed and running
- Docker installed
- GitHub account
- Docker Hub account
- Basic text editor (vim/nano)

## 🎯 Deliverables

### 1. Git Repository Setup (15 points)
- [ ] Create a GitHub repository named `devops-cicd-project`
- [ ] Initialize with proper `.gitignore` file
- [ ] Create branches: `main`, `develop`
- [ ] Add a meaningful README.md
- [ ] Make at least 10 meaningful commits showing progression
- [ ] Use proper commit messages (conventional commits)

**Files to include:**
```
devops-cicd-project/
├── README.md
├── .gitignore
├── app/
│   ├── index.html
│   └── app.sh
├── scripts/
│   ├── build.sh
│   ├── test.sh
│   └── deploy.sh
├── Dockerfile
├── Jenkinsfile
└── docker-compose.yml
```

### 2. Application Code (10 points)
Create a simple web application (choose one):

**Option A: Simple Web Server**
- [ ] HTML/CSS static website
- [ ] Shell script to start a simple HTTP server
- [ ] Health check endpoint

**Option B: Bash-based Application**
- [ ] Shell script application with functions
- [ ] Configuration file handling
- [ ] Log file generation

### 3. Shell Scripts (20 points)

Create three shell scripts in the `scripts/` directory:

#### build.sh
**Purpose:** Automate the build process

**Your script should:**
- [ ] Start with proper shebang (`#!/bin/bash`)
- [ ] Use `set -euo pipefail` for error handling
- [ ] Create a log file with timestamp
- [ ] Check if required directories exist
- [ ] Validate that all application files are present
- [ ] Make necessary files executable
- [ ] Replace template variables (BUILD_NUMBER, DEPLOY_TIME)
- [ ] Log each step with timestamps
- [ ] Exit with code 0 on success, non-zero on failure

**Hints:**
- Use `[ -d "directory" ]` to check if directory exists
- Use `[ -f "file" ]` to check if file exists
- Use `sed` command to replace variables in files
- Create a `log()` function for consistent logging
- Use `date` command for timestamps

#### test.sh
**Purpose:** Run automated tests to validate the build

**Your script should:**
- [ ] Check if all required files exist
- [ ] Validate HTML syntax (check for opening/closing tags)
- [ ] Verify shell script syntax using `bash -n`
- [ ] Test that Dockerfile exists
- [ ] Check file permissions
- [ ] Log test results (pass/fail)
- [ ] Exit with appropriate code

**Hints:**
- Use `grep` to search for HTML tags
- Use `bash -n script.sh` to check syntax without running
- Create a `test_file_exists()` function
- Count passed and failed tests
- Print summary at the end

#### deploy.sh
**Purpose:** Deploy the application using Docker

**Your script should:**
- [ ] Accept IMAGE_NAME as environment variable
- [ ] Stop existing container (if running)
- [ ] Remove old container
- [ ] Pull latest image from Docker Hub
- [ ] Start new container with proper configuration
- [ ] Wait for container to be healthy
- [ ] Verify deployment was successful
- [ ] Print access URL
- [ ] Implement rollback on failure (bonus)

**Hints:**
- Use `docker stop` and `docker rm` with `|| true` to avoid errors
- Use `docker run -d` for detached mode
- Use `docker ps` to verify container is running
- Use `sleep` to wait for startup
- Store previous image tag for rollback

**Requirements for all scripts:**
- [ ] Proper shebang line (`#!/bin/bash`)
- [ ] Error handling (`set -euo pipefail`)
- [ ] Functions for reusability
- [ ] Comments explaining logic
- [ ] Logging with timestamps format: `[YYYY-MM-DD HH:MM:SS]`
- [ ] Exit codes (0 for success, non-zero for failure)
- [ ] Input validation where needed

### 4. Dockerfile (15 points)

Create a Dockerfile that containerizes your application.

**Requirements:**
- [ ] Use `alpine:latest` or `nginx:alpine` as base image
- [ ] Add LABEL for maintainer and description
- [ ] Install required packages (bash, if needed)
- [ ] Create a non-root user (appuser)
- [ ] Set WORKDIR to /app
- [ ] Copy application files to container
- [ ] Copy scripts to container
- [ ] Make scripts executable
- [ ] Change ownership to non-root user
- [ ] Switch to non-root user
- [ ] EXPOSE port 8080
- [ ] Add HEALTHCHECK instruction
- [ ] Set CMD to start your application

**Hints:**
- For Alpine: `RUN apk add --no-cache package-name`
- Create user: `RUN addgroup -S appgroup && adduser -S appuser -G appgroup`
- Copy files: `COPY source/ destination/`
- Set permissions: `RUN chmod +x /path/to/script.sh`
- Change owner: `RUN chown -R user:group /path`
- Switch user: `USER username`
- Healthcheck example: `HEALTHCHECK --interval=30s CMD command || exit 1`

**Best Practices:**
- Minimize number of layers (combine RUN commands with &&)
- Clean up package manager cache
- Use specific versions for base images in production
- Don't run as root user
- Add .dockerignore file to exclude unnecessary files

### 5. Jenkins Pipeline (25 points)

Create a `Jenkinsfile` using declarative pipeline syntax.

**Pipeline Structure:**

Your Jenkinsfile should have these sections:

**1. Pipeline Declaration**
- Start with `pipeline { }`
- Set `agent any`

**2. Environment Variables**
Define these in the `environment` block:
- [ ] DOCKER_HUB_CREDENTIALS (use credentials() function)
- [ ] IMAGE_NAME (your dockerhub username/repo)
- [ ] IMAGE_TAG (use ${BUILD_NUMBER})

**3. Stages**

Create the following stages:

**Stage 1: Checkout**
- Use `git` step or `checkout scm`
- Clone your repository

**Stage 2: Build**
- Execute `./scripts/build.sh`
- Use `sh` step to run shell commands

**Stage 3: Test**
- Execute `./scripts/test.sh`
- Ensure tests pass before continuing

**Stage 4: Docker Build**
- Build Docker image with tag
- Command: `docker build -t $IMAGE_NAME:$IMAGE_TAG .`
- Also tag as `latest`

**Stage 5: Docker Push**
- Login to Docker Hub using credentials
- Push both tags (BUILD_NUMBER and latest)
- Use `sh "echo $DOCKER_HUB_CREDENTIALS_PSW | docker login -u $DOCKER_HUB_CREDENTIALS_USR --password-stdin"`

**Stage 6: Deploy**
- Execute `./scripts/deploy.sh`
- Pass IMAGE_NAME as environment variable

**4. Post Actions**

Add `post` block with:
- [ ] `success` - Print success message
- [ ] `failure` - Print failure message  
- [ ] `always` - Logout from Docker, cleanup

**Hints:**
- Use `sh 'command'` to execute shell commands
- Access credentials with `credentials('credential-id')`
- Use `${VARIABLE}` for variable substitution
- Each stage should have `steps { }` block
- Use `echo` to print messages

**Example Stage Structure:**
```groovy
stage('Stage Name') {
    steps {
        sh 'your command here'
        echo 'Status message'
    }
}
```

**Requirements:**
- [ ] Declarative pipeline syntax (not scripted)
- [ ] All 6 stages implemented
- [ ] Environment variables defined
- [ ] Credentials properly used
- [ ] Post-build actions included
- [ ] Proper error handling (pipeline fails if any stage fails)
- [ ] Echo statements for visibility

### 6. Jenkins Configuration (10 points)
- [ ] Jenkins job created and configured
- [ ] GitHub webhook configured for auto-trigger
- [ ] Docker Hub credentials added to Jenkins
- [ ] Build triggers configured (SCM polling or webhook)
- [ ] Email/Slack notifications configured
- [ ] Build history maintained

### 7. Docker Deployment (10 points)

Create a `docker-compose.yml` file for easy deployment.

**Requirements:**

Your docker-compose file should include:
- [ ] Version: '3.8'
- [ ] Service named 'app'
- [ ] Use your Docker Hub image
- [ ] Container name: devops-app
- [ ] Port mapping: 8080:8080
- [ ] Environment variable: ENV=production
- [ ] Restart policy: unless-stopped
- [ ] Healthcheck configuration
- [ ] Volume for logs (optional)

**Healthcheck Configuration:**
- Test command to verify app is running
- Interval: 30 seconds
- Timeout: 10 seconds
- Retries: 3

**Hints:**
```yaml
version: '3.8'

services:
  service-name:
    image: your-image:tag
    container_name: container-name
    ports:
      - "host:container"
    environment:
      - KEY=value
    restart: policy
    healthcheck:
      test: ["CMD", "command"]
      interval: 30s
      timeout: 10s
      retries: 3
```

**Testing:**
- Run: `docker-compose up -d`
- Check: `docker-compose ps`
- Logs: `docker-compose logs -f`
- Stop: `docker-compose down`

### 8. Documentation (15 points)

Create comprehensive documentation including:

**README.md should contain:**
- [ ] Project overview and objectives
- [ ] Architecture diagram (can be ASCII art or image)
- [ ] Prerequisites and setup instructions
- [ ] Step-by-step deployment guide
- [ ] How to trigger the pipeline
- [ ] How to verify deployment
- [ ] Troubleshooting section
- [ ] Screenshots of:
  - Jenkins pipeline execution
  - Docker Hub repository
  - Running application
  - Git commit history

**Additional Documentation:**
- [ ] Script documentation (what each script does)
- [ ] Environment variables documentation
- [ ] API/Endpoint documentation (if applicable)
- [ ] Known issues and limitations

## 📐 Architecture Diagram

```
Developer
    ↓
[Git Push] → GitHub Repository
                ↓
            [Webhook]
                ↓
            Jenkins Server
                ↓
    ┌───────────┴───────────┐
    ↓                       ↓
[Build Stage]          [Test Stage]
    ↓                       ↓
[build.sh]             [test.sh]
    ↓                       ↓
    └───────────┬───────────┘
                ↓
        [Docker Build]
                ↓
        [Docker Push] → Docker Hub
                ↓
        [Deploy Stage]
                ↓
        [deploy.sh]
                ↓
        [Docker Container]
                ↓
        Running Application
```

## 🔨 Implementation Steps

### Step 1: Set Up Linux Environment
```bash
# Update system
sudo apt update && sudo apt upgrade -y

# Install required packages
sudo apt install -y git docker.io openjdk-11-jdk

# Start Docker
sudo systemctl start docker
sudo systemctl enable docker

# Add user to docker group
sudo usermod -aG docker $USER
```

### Step 2: Install Jenkins
```bash
# Add Jenkins repository
wget -q -O - https://pkg.jenkins.io/debian-stable/jenkins.io.key | sudo apt-key add -
sudo sh -c 'echo deb https://pkg.jenkins.io/debian-stable binary/ > /etc/apt/sources.list.d/jenkins.list'

# Install Jenkins
sudo apt update
sudo apt install -y jenkins

# Start Jenkins
sudo systemctl start jenkins
sudo systemctl enable jenkins

# Get initial admin password
sudo cat /var/lib/jenkins/secrets/initialAdminPassword
```

### Step 3: Create Application Files

You need to create the following files:

**app/index.html**
Create a simple HTML page that includes:
- [ ] HTML5 doctype
- [ ] Head section with title
- [ ] Body with heading
- [ ] Paragraph showing build number: `${BUILD_NUMBER}` (will be replaced by build script)
- [ ] Paragraph showing deploy time: `${DEPLOY_TIME}` (will be replaced by build script)
- [ ] Basic CSS styling (optional)

**app/app.sh**
Create a shell script that:
- [ ] Starts with `#!/bin/bash`
- [ ] Uses `set -e` for error handling
- [ ] Prints "Starting application..."
- [ ] Changes to /app directory
- [ ] Starts a simple HTTP server on port 8080
- [ ] Uses either `python3 -m http.server 8080` or `busybox httpd -f -p 8080 -h /app`
- [ ] Checks which command is available using `command -v`
- [ ] Exits with error if no HTTP server available

**Hint for app.sh:**
```bash
if command -v python3 &> /dev/null; then
    # use python
elif command -v busybox &> /dev/null; then
    # use busybox
else
    # print error and exit
fi
```

**scripts/build.sh**
Refer to the Shell Scripts section above for requirements.

**scripts/test.sh**
Refer to the Shell Scripts section above for requirements.

**scripts/deploy.sh**
Refer to the Shell Scripts section above for requirements.

### Step 4: Configure Jenkins

1. **Install Required Plugins:**
   - Git Plugin
   - Docker Pipeline Plugin
   - Pipeline Plugin
   - Credentials Plugin

2. **Add Credentials:**
   - Go to: Manage Jenkins → Manage Credentials
   - Add Docker Hub credentials (ID: `dockerhub-creds`)
   - Add GitHub credentials (if private repo)

3. **Create Pipeline Job:**
   - New Item → Pipeline
   - Configure SCM: Git repository URL
   - Pipeline script from SCM
   - Script Path: `Jenkinsfile`

4. **Configure Webhook:**
   - GitHub repo → Settings → Webhooks
   - Add webhook: `http://your-jenkins-url/github-webhook/`

## ✅ Evaluation Criteria

| Criteria | Points | Description |
|----------|--------|-------------|
| Git Repository | 15 | Proper structure, commits, branches |
| Application Code | 10 | Working application, clean code |
| Shell Scripts | 20 | Well-written, error handling, logging |
| Dockerfile | 15 | Optimized, best practices |
| Jenkins Pipeline | 25 | Complete, working, proper stages |
| Jenkins Config | 10 | Webhooks, credentials, triggers |
| Docker Deployment | 10 | Running, accessible, healthy |
| Documentation | 15 | Complete, clear, with screenshots |
| **Total** | **120** | Extra credit available |

**Bonus Points (20 points):**
- [ ] Add automated rollback mechanism (+5)
- [ ] Implement blue-green deployment (+5)
- [ ] Add Slack notifications (+3)
- [ ] Create monitoring dashboard (+4)
- [ ] Add security scanning (+3)

## 🧪 Testing Your Pipeline

```bash
# 1. Test scripts locally
cd devops-cicd-project
./scripts/build.sh
./scripts/test.sh

# 2. Test Docker build
docker build -t devops-app:test .
docker run -d -p 8080:8080 devops-app:test

# 3. Test application
curl http://localhost:8080

# 4. Trigger Jenkins pipeline
git add .
git commit -m "feat: trigger pipeline"
git push origin develop

# 5. Monitor Jenkins
# Check Jenkins dashboard for build progress

# 6. Verify deployment
docker ps
curl http://localhost:8080

# 7. Check logs
docker logs devops-app
```

## 🐛 Common Issues & Solutions

| Issue | Solution |
|-------|----------|
| Jenkins can't connect to Docker | Add jenkins user to docker group: `sudo usermod -aG docker jenkins` |
| Permission denied on scripts | Make scripts executable: `chmod +x scripts/*.sh` |
| Docker build fails | Check Dockerfile syntax, verify base image |
| Webhook not triggering | Check firewall, verify webhook URL, check Jenkins logs |
| Container exits immediately | Check application logs: `docker logs devops-app` |
| Port already in use | Stop conflicting service or change port mapping |

## 📚 Additional Challenges (Optional)

- [ ] Add multiple environments (dev, staging, prod)
- [ ] Implement parameterized builds
- [ ] Add code quality checks (shellcheck)
- [ ] Create backup and restore scripts
- [ ] Add performance testing
- [ ] Implement log rotation
- [ ] Add database container
- [ ] Create cleanup scripts for old images

## 📤 Submission Requirements

Create a submission document (PDF/Markdown) containing:

1. **GitHub Repository Link**
2. **Docker Hub Repository Link**
3. **Screenshots:**
   - Jenkins pipeline (all stages green)
   - Docker Hub showing pushed images
   - Running application in browser
   - Git commit history
   - Docker containers running
4. **Documentation:**
   - Setup steps you followed
   - Challenges faced and solutions
   - Time taken for completion
5. **Demo Video (Optional):**
   - 5-minute video showing:
     - Code push triggering pipeline
     - Pipeline execution
     - Successful deployment
     - Application running

## 🎓 Learning Outcomes

After completing this project, you will be able to:
- ✅ Create and manage Git repositories effectively
- ✅ Write robust shell scripts with error handling
- ✅ Build and optimize Docker images
- ✅ Create Jenkins pipelines from scratch
- ✅ Integrate multiple DevOps tools
- ✅ Automate deployment processes
- ✅ Troubleshoot CI/CD issues
- ✅ Document technical projects professionally

## 📞 Support & Questions

If you encounter issues:
1. Check the troubleshooting section
2. Review Jenkins console output
3. Check Docker logs
4. Verify all prerequisites are met
5. Document the issue for your submission

Good luck with your project! 🚀
