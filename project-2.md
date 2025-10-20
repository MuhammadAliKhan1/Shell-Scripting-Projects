# Project 2: Secure File Organizer & Permission Manager

The goal of this project is to create a script that organizes files from a single directory into categorized subdirectories and applies strict, secure file permissions to each file and directory based on its type. This is a common task for managing user uploads, data processing, or simply keeping a system tidy and secure.

This project will challenge you to think about file security and the principle of least privilege.

## Learning Objectives

-   Deepen your understanding of the Linux file permission model (read, write, execute).
-   Master the use of the `chmod` command with both octal (e.g., `755`) and symbolic (e.g., `u+x`) notation.
-   Understand and use the `chown` command to manage file ownership.
-   Apply logical conditions in shell scripts (e.g., `case` statements) to make decisions based on file types.
-   Continue to practice safe and organized scripting by working in a test environment.

## Project Instructions

#### **Part 1: Setting Up The Project and Test Environment**

1.  **Create a New GitHub Repository:**
    *   Create a new public repository on GitHub named `secure-file-manager`.
    *   Initialize it with a `README.md` file.
2.  **Clone the Repository:**
    *   Clone your new repository to your local machine and navigate into the directory.
3.  **Create a Safe Test Environment:**
    *   **Crucial:** We will not work with system files. Create a safe "sandbox" to test your script.
    *   Inside your git repository, run the following commands to set up the environment:
        ```bash
        # Create a source directory for our messy files
        mkdir source_files

        # Create some dummy files of different types inside it
        touch source_files/family_photo.jpg
        touch source_files/vacation.png
        echo "My secret project notes" > source_files/project_notes.txt
        echo "A public announcement" > source_files/announcement.md
        echo "#!/bin/bash\n\necho 'Hello World'" > source_files/my_script.sh
        echo "This is an error log" > source_files/app.log

        # Make the script executable to start with
        chmod +x source_files/my_script.sh

        # This will be the destination for our organized files
        mkdir organized_files
        ```
    *   You now have a `source_files` directory with a mix of files to work with.

---

#### **Part 2: The Basic Organizer Script**

First, you'll create a script that simply sorts the files into the correct subdirectories based on their extension.

**Step 1: Create a New Branch**

*   Create and switch to a new branch for this feature:
    ```bash
    git checkout -b feature/file-organizer
    ```

**Step 2: Create the `organize.sh` Script**

*   Create a new file named `organize.sh`.
*   This script should:
    1.  **Define source and destination directories** as variables at the top of the script.
    2.  **Loop through all files** in the `source_files` directory.
    3.  **Use a `case` statement** to check the file's extension (e.g., `.jpg`, `.png`, `.txt`, `.sh`).
    4.  **Move the file** to a corresponding subdirectory inside `organized_files` (e.g., `images`, `documents`, `scripts`).
    5.  **Create the subdirectory if it doesn't exist.** Before moving a file, check if its destination directory (e.g., `organized_files/images`) exists. If not, create it with `mkdir -p`.

**Step 3: Commit, Push, and Merge**

*   Add your `organize.sh` script to git, commit it with a clear message, push your branch to GitHub, and merge the pull request.

---

#### **Part 3: Applying Secure Permissions**

Now for the most important part. You will modify your script to apply a pre-defined "permission policy" to every file and directory it handles. This ensures that different types of files have appropriate security levels.

**Step 1: Create a New "Permissions" Branch**

*   Make sure you are on the `main` branch and it's up to date, then create a new branch:
    ```bash
    git checkout main
    git pull origin main
    git checkout -b feature/permission-manager
    ```

**Step 2: Define and Implement a Permission Policy**

*   Modify your `organize.sh` script. After a file is moved or a directory is created, you will immediately set its permissions using `chmod`.

*   **Your Permission Policy:**
    *   **Directories** (e.g., `images`, `documents`, `scripts`): Should have permissions of `750` (`rwxr-x---`).
        *   **Why?** The **owner** needs full control. The **group** needs to enter (`x`) and list files (`r`), but not create new files. **Others** have no access.
    *   **Documents & Images** (`.txt`, `.md`, `.jpg`, `.png`): Should have permissions of `640` (`rw-r-----`).
        *   **Why?** The **owner** can read and write. The **group** can only read them. They are not executable. **Others** have no access.
    *   **Scripts** (`.sh`): Should have permissions of `750` (`rwxr-x---`).
        *   **Why?** The **owner** must be able to execute (`x`) the script. The **group** can read and execute it but cannot modify it.
    *   **Private Logs** (`.log`): Should have permissions of `600` (`rw-------`).
        *   **Why?** Logs can contain sensitive data. Only the **owner** should be able to read or write to them.

*   **Implementation:**
    *   In your `case` statement, after moving a file, add a `chmod` command to apply the policy.
    *   When you create a new directory, immediately run `chmod 750` on it.

**Step 3 (Optional Bonus): Manage File Ownership**

*   Modify your script to accept an optional argument: a group name.
    ```bash
    ./organize.sh developers
    ```*   If this argument is provided, after setting permissions, use the `chown` command to change the group ownership of every file and directory to the group name provided.
    *   Example: `chown $USER:new_group /path/to/file`
*   This simulates organizing files for a specific team, which is a very common administrative task.

**Step 4: Commit, Push, and Merge**

*   Add your final changes, commit them with a message explaining the new permission policies, push the branch, and merge your pull request.

#### **Final Delivery**

Once your script correctly organizes files *and* applies the security policies, send me the link to your GitHub repository for review.