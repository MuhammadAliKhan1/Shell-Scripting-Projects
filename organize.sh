#!/bin/bash

# ===============================================
# Project 2: Secure File Organizer & Permission Manager
# ===============================================

# --- CONFIGURATION ---
SOURCE_DIR="source_files"
DEST_DIR="organized_files"
# The optional group to set ownership to
TARGET_GROUP="$1"

# Define Permission Policy (Octal Notation)
DIR_PERMS=750     # rwxr-x--- (Owner: rwx, Group: r-x, Other: ---)
DOC_PERMS=640     # rw-r----- (Owner: rw-, Group: r--, Other: ---)
SCRIPT_PERMS=750  # rwxr-x--- (Owner: rwx, Group: r-x, Other: ---)
LOG_PERMS=600     # rw------- (Owner: rw-, Group: ---, Other: ---)

# Set the current user as the owner variable
CURRENT_OWNER=$(whoami)

echo "Starting secure file organization..."
echo "Source: $SOURCE_DIR, Destination: $DEST_DIR"

# Check if the source directory exists
if [ ! -d "$SOURCE_DIR" ]; then
    echo "Error: Source directory '$SOURCE_DIR' does not exist."
    exit 1
fi

# Ensure the destination base directory exists and set its secure permissions
mkdir -p "$DEST_DIR"
chmod "$DIR_PERMS" "$DEST_DIR"

# Optional: Set group ownership on the base destination directory
if [ -n "$TARGET_GROUP" ]; then
    chown "$CURRENT_OWNER":"$TARGET_GROUP" "$DEST_DIR"
    echo "Base destination group set to: $TARGET_GROUP"
fi

# Loop through all files in the source directory
# The -maxdepth 1 ensures we only look at the top level of source_files
find "$SOURCE_DIR" -maxdepth 1 -type f | while read file; do
    # Get the filename (basename) and extension
    filename=$(basename "$file")
    extension="${filename##*.}"

    # Default values
    folder_name=""
    file_perms=""

    # 3. Use a case statement to determine destination folder and permissions
    case "$extension" in
        # --- IMAGES ---
        jpg|jpeg|png|gif)
            folder_name="images"
            file_perms="$DOC_PERMS"
            ;;

        # --- DOCUMENTS ---
        txt|md)
            folder_name="documents"
            file_perms="$DOC_PERMS"
            ;;

        # --- EXECUTABLE SCRIPTS ---
        sh)
            folder_name="scripts"
            file_perms="$SCRIPT_PERMS"
            ;;

        # --- PRIVATE LOGS ---
        log)
            folder_name="logs"
            file_perms="$LOG_PERMS"
            ;;

        # --- OTHERS ---
        *)
            folder_name="other"
            file_perms="$DOC_PERMS" # Default secure permission for unknown files
            ;;
    esac

    # Define the final destination path
    DEST_FOLDER="$DEST_DIR/$folder_name"

    # --- Directory Creation and Permission Setting ---
    if [ ! -d "$DEST_FOLDER" ]; then
        # 4. Create the subdirectory if it doesn't exist
        mkdir -p "$DEST_FOLDER"

        # Apply the secure directory permission policy (750)
        chmod "$DIR_PERMS" "$DEST_FOLDER"
        echo "Created directory '$DEST_FOLDER' with permissions $DIR_PERMS."

        # Optional: Set group ownership on the newly created directory
        if [ -n "$TARGET_GROUP" ]; then
            chown "$CURRENT_OWNER":"$TARGET_GROUP" "$DEST_FOLDER"
        fi
    fi

    # --- File Movement and Permission Setting ---

    # 5. Move the file
    mv "$file" "$DEST_FOLDER/"
    NEW_FILE_PATH="$DEST_FOLDER/$filename"
    echo "  -> Moved '$filename' to '$DEST_FOLDER/'"

    # Apply the secure file permission policy
    chmod "$file_perms" "$NEW_FILE_PATH"
    echo "  -> Set permissions on '$filename' to $file_perms."

    # Optional: Set group ownership on the moved file
    if [ -n "$TARGET_GROUP" ]; then
        chown "$CURRENT_OWNER":"$TARGET_GROUP" "$NEW_FILE_PATH"
        echo "  -> Set group ownership on '$filename' to $TARGET_GROUP."
    fi

done

echo "--- Organization and Security Policy Application Complete. ---"