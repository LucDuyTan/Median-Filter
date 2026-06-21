from PIL import Image

def image_to_hex(image_path, output_hex_path):
    try:
        img = Image.open(image_path).convert('L') 
    except Exception as e:
        print(f"Lỗi không mở được ảnh: {e}")
        return     
    width, height = img.size
    print(f"Kích thước ảnh: {width}x{height}")   
    with open(output_hex_path, 'w') as f:
        for y in range(height):
            for x in range(width):
                pixel = img.getpixel((x, y))
                f.write(f"{pixel:02x}\n")                
    print(f"Đã chuyển đổi xong! File lưu tại: {output_hex_path}")
image_input = r"D:\HK2-2025\HDL\LAB2\baitap1_nhieu.jpg" 
hex_output  = r"D:\HK2-2025\HDL\LAB2\baitap1_nhieu.hex"    
image_to_hex(image_input, hex_output)
