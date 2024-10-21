# Save this script as move_files.sh
#!/bin/bash

# Usage: ./move_files.sh "file1.txt,file2.txt" "/path/to/destination" "yes"

# Check if the correct number of arguments is provided

# Assign input parameters to variables
SOURCEFILE=$1
DEST=$2
OVERWRITE=$3
VM2='10.0.1.6'
USRNAME='manu'
# Convert the comma-separated source files into an array
IFS=',' read -r -a name_array <<< "$SOURCEFILE"

# Iterate over the array of source files
for name in "${name_array[@]}"; do
    echo "Processing file: $name"
    
    # Ensure the file exists before proceeding
    if [ ! -f "/tmp/$name" ]; then
        echo "File /tmp/$name does not exist, skipping."
        continue
    fi
    sudo scp /tmp/$name $USRNAME@$VM2:/tmp
    # Set permissions and ownership
    sudo chmod 755 "/tmp/$name"
    sudo chown root:root "/tmp/$name"

    # Move file based on overwrite condition
    if [ "$OVERWRITE" = "yes" ]; then
        echo "Overwriting: $name"
        sudo mv -f "/tmp/$name" "$DEST"
    else
        echo "Not overwriting: $name"
        sudo mv -n "/tmp/$name" "$DEST"
    fi
done
echo "in VM2"
ssh $USRNAME@$VM2 >> EOF
for name in "${name_array[@]}"; do
    echo "Processing file: $name"
    
    # Ensure the file exists before proceeding
    if [ ! -f "/tmp/$name" ]; then
        echo "File /tmp/$name does not exist, skipping."
        continue
    fi
    # Set permissions and ownership
    sudo chmod 755 "/tmp/$name"
    sudo chown root:root "/tmp/$name"

    # Move file based on overwrite condition
    if [ "$OVERWRITE" = "yes" ]; then
        echo "Overwriting: $name"
        sudo mv -f "/tmp/$name" "$DEST"
    else
        echo "Not overwriting: $name"
        sudo mv -n "/tmp/$name" "$DEST"
    fi
done
echo "Script completed."
