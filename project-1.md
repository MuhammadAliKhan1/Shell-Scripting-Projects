# Linux Service and Log Management Automation

The goal of this project is to build a set of shell scripts that automate the monitoring of system services and the management of log files on a Linux server. This project will help you learn how to interact with `systemd`, parse log files, and automate system reporting.

## Learning Objectives

-   Gain experience with `systemctl` for managing system services.
-   Learn how to parse and extract information from system log files.
-   Automate the process of log rotation and archival.
-   Practice creating summary reports and automating system administration tasks.
-   Continue to use Git and GitHub for version control.

## Project Instructions

#### **Part 1: Setting Up Your New Project**

1.  **Create a New GitHub Repository:**
    *   Create a new public repository on GitHub named `linux-admin-toolkit`.
    *   Initialize it with this `README.md` file.
2.  **Clone the Repository:**
    *   Clone the repository to your local machine:
        ```bash
        git clone <your-repository-url>
        ```
    *   Navigate into the project directory:
        ```bash
        cd linux-admin-toolkit
        ```

---

#### **Part 2: Service Status Checker**

Your first task is to create a script that checks the status of critical services on your machine and reports if any of them are not running. System administrators rely on such scripts to ensure that key applications (like web servers or databases) are always available.

**Step 1: Create a New Branch**

*   Create and switch to a new branch for this feature:
    ```bash
    git checkout -b feature/service-checker
    ```

**Step 2: Create the Service Status Script**

*   Create a file named `service_checker.sh`.
*   **What Services to Monitor?**
    A typical Linux server runs several critical services. Your script should monitor a few of these. We will define them in a list (an array) in your script.

    Here are some common and important services. **You may not have all of them**, so pick at least three that are on your system.
    *   `sshd` (or `ssh`): The OpenSSH server that allows you to log in remotely. **This is essential.**
    *   `cron` (or `crond`): The daemon that runs scheduled jobs (like backups or updates). **This is also essential.**
    *   `nginx` or `apache2`: Popular web servers. If you have a web server running, you must monitor it.
    *   `ufw` or `firewalld`: Firewall services that protect your system.

    ***Pro-Tip:*** You can find all active services on your system by running `systemctl list-units --type=service`.

*   **Script Requirements:**
    1.  **Define Your Service List:** At the top of your script, create a Bash array with the names of the services you want to check.
        ```bash
        # Example list
        services_to_check=("sshd" "cron" "nginx")
        ```
    2.  **Loop and Check:** Loop through each service in the array. Inside the loop, use `systemctl is-active --quiet "$service"` to check its status.
    3.  **Generate a Report:**
        *   If the command's exit code is not `0`, it means the service is inactive. Print a clear warning message to the console: `WARNING: The '$service' service is not running!`.
        *   If all the services in your list are running, the script should finish by printing a success message: `All critical services are active.`.
    4.  **(Optional Bonus):** If a service is down, try to restart it automatically using `sudo systemctl restart "$service"` and then report whether the restart was successful.

**Step 3: Commit, Push, and Create a Pull Request**

*   Add, commit, and push your changes. Then, merge your pull request on GitHub.
    ```bash
    git add service_checker.sh
    git commit -m "feat: Create a script to check critical service status"
    git push -u origin feature/service-checker
    ```

---

#### **Part 3: Log File Archiver & Rotator**

Log files can grow very large, consuming valuable disk space. This script will automate the process of finding large log files, compressing them for storage, and clearing the original file.

**Step 0: Create a Safe Test Environment**

**Do not run this script directly in `/var/log` at first!** It's easy to make a mistake. Instead, let's create a safe "sandbox" for you to test your script.

1.  Create a project directory and a directory for test logs:
    ```bash
    mkdir -p ~/log_project/test_logs
    mkdir -p ~/log_project/archives
    cd ~/log_project/test_logs
    ```
2.  Create a few fake log files of different sizes to test with:
    ```bash
    # Create a small log file
    echo "This is a small log file." > app_debug.log

    # Create a large log file (5MB)
    head -c 5M /dev/urandom > system_errors.log

    # Create another large log file (10MB) and set its modification time to 8 days ago
    head -c 10M /dev/urandom > access.log
    touch -d "8 days ago" access.log
    ```
    Now you have a safe environment (`~/log_project/test_logs`) to test your script against.

**Step 1: Get the Latest `main` and Create a New Branch**

*   Switch back to `main`, pull the latest changes, and create a new branch:
    ```bash
    git checkout main
    git pull origin main
    git checkout -b feature/log-rotator
    ```

**Step 2: Create the Log Rotation Script**

*   Inside your `linux-admin-toolkit` git repository, create a file named `log_rotator.sh`.

*   **What Log Files to Manage?**
    For this project, your script will target the test directory you created. The script should be configurable so the path can be easily changed later to a real path like `/var/log/`.
    *   **Real-world examples of logs include:**
        *   `/var/log/syslog`: General system activity logs.
        *   `/var/log/nginx/access.log`: Web server access logs.
        *   `/var/log/auth.log`: User login and authentication logs.

*   **Script Requirements:**
    1.  **Define Variables:** At the top of your script, define variables for the target log directory and the archive directory.
        ```bash
        TARGET_DIR="~/log_project/test_logs"
        ARCHIVE_DIR="~/log_project/archives"
        ```
    2.  **Create Archive Directory:** Check if the `$ARCHIVE_DIR` exists. If not, create it.
    3.  **Find Large Files:** Use the `find` command to locate files in `$TARGET_DIR` that meet certain criteria:
        *   Are larger than a specific size (e.g., `+2M` for >2MB).
        *   Are regular files (`-type f`).
        *   (Optional) Were modified more than 7 days ago (`-mtime +7`).
    4.  **Loop and Archive:** Loop through the list of files you found. For each file:
        *   Compress it into a `.tar.gz` archive and place it in `$ARCHIVE_DIR`. The archive name should include the original filename and the current date, like `system_errors.log_2025-10-20.tar.gz`.
        *   After the file is successfully archived, clear the contents of the original log file. **Do not delete it.** The command `> /path/to/logfile.log` is perfect for this.
    5.  **Log Your Actions:** Print a message to the console for each file that is archived, e.g., `Archived and cleared: system_errors.log`.

**Step 3: Commit, Push, and Merge**

*   Follow the standard Git workflow to save your changes and merge them on GitHub.

---

#### **Final Delivery**

Once both scripts are complete and merged into your `main` branch, send me the link to your GitHub repository for review.