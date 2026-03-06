import os

def save_files_content_to_text(output_file):
    # Get the current script's directory
    root_folder = os.path.dirname(os.path.abspath(__file__))
    
    # List of image file extensions to ignore
    image_extensions = {'.py', '.jpg', '.jpeg', '.png', '.webp'}
    
    # Open the output file in write mode
    with open(output_file, 'w', encoding='utf-8') as output:
        # Walk through the directory tree starting from the current directory
        for dirpath, _, filenames in os.walk(root_folder):
            for filename in filenames:
                file_path = os.path.join(dirpath, filename)
                
                # Skip image files based on extensions
                _, file_extension = os.path.splitext(filename)
                if file_extension.lower() in image_extensions:
                    continue  # Skip this file if it's an image
                
                # Skip directories (though filenames should not be directories)
                if os.path.isdir(file_path):
                    continue
                
                # Add separator for each file
                output.write(f"=========== {filename} ===========\n")
                
                # Open and read the content of each file
                try:
                    with open(file_path, 'r', encoding='utf-8') as file:
                        content = file.read()
                        output.write(content + "\n\n")  # Write file content with a newline between files
                except Exception as e:
                    # If an error occurs (e.g., permission issue or binary file), log it
                    output.write(f"Error reading file {file_path}: {e}\n\n")
                    
    print(f"Content saved to {output_file}")

# Usage: Save content from current folder and subfolders to a text file
output_text_file = "combined_files_content.txt"
save_files_content_to_text(output_text_file)

