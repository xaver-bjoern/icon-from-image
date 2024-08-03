#!/bin/zsh

# Function to check if the required tools are installed
check_dependencies() {
  if ! command -v convert &>/dev/null; then
    echo "ImageMagick is not installed. Please install it using 'brew install imagemagick'."
    exit 1
  fi

  if ! command -v iconutil &>/dev/null; then
    echo "iconutil is not installed. Please install it using 'xcode-select --install'."
    exit 1
  fi
}

# Function to rename the existing iconset directory if it exists
rename_existing_iconset() {
  local iconset_dir=$1
  if [[ -d $iconset_dir ]]; then
    local timestamp=$(date +%Y%m%d%H%M%S)
    mv $iconset_dir "${iconset_dir}_${timestamp}"
    echo "Existing iconset directory renamed to ${iconset_dir}_${timestamp}"
  fi
}

# Check dependencies
check_dependencies

# Prompt for the input file
echo "Enter the path to the input PNG or JPG file:"
read input_file

# Check if the file exists
if [[ ! -f $input_file ]]; then
  echo "File not found!"
  exit 1
fi

# Prompt for the output file name
echo "Enter the desired output ICNS file name (default: icon.icns):"
read output_file

# Use default name if no name is provided
if [[ -z $output_file ]]; then
  output_file="icon.icns"
fi

# Define the iconset directory
iconset_dir="icon.iconset"

# Rename existing iconset directory if it exists
rename_existing_iconset $iconset_dir

# Create a new iconset directory
mkdir -p $iconset_dir

# Generate the necessary icon sizes
convert $input_file -resize 16x16 $iconset_dir/icon_16x16.png
convert $input_file -resize 32x32 $iconset_dir/icon_16x16@2x.png
convert $input_file -resize 32x32 $iconset_dir/icon_32x32.png
convert $input_file -resize 64x64 $iconset_dir/icon_32x32@2x.png
convert $input_file -resize 128x128 $iconset_dir/icon_128x128.png
convert $input_file -resize 256x256 $iconset_dir/icon_128x128@2x.png
convert $input_file -resize 256x256 $iconset_dir/icon_256x256.png
convert $input_file -resize 512x512 $iconset_dir/icon_256x256@2x.png
convert $input_file -resize 512x512 $iconset_dir/icon_512x512.png
convert $input_file -resize 1024x1024 $iconset_dir/icon_512x512@2x.png

# Convert the iconset to ICNS
iconutil -c icns $iconset_dir -o $output_file

# Cleanup
rm -r $iconset_dir

echo "ICNS file created: $output_file"
