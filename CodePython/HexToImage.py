from PIL import Image

def hex_to_image(hex_path, output_image_path, width, height):
    try:
        with open(hex_path, 'r') as f:
            hex_lines = f.readlines()
        pixels = [int(line.strip(), 16) for line in hex_lines if line.strip() != ""] 
        expected_pixels = width * height
        if len(pixels) != expected_pixels:
            print(f"⚠️ Cảnh báo: File hex có {len(pixels)} pixel, nhưng ảnh cần {expected_pixels} pixel.")
            print("Ảnh đầu ra có thể bị méo hoặc thiếu hụt.")
        img = Image.new('L', (width, height))
        img.putdata(pixels)
        img.save(output_image_path)
        print(f" Đã phục hồi và lưu ảnh tại: {output_image_path}")
    except FileNotFoundError:
        print(f" Không tìm thấy file {hex_path}. Hãy kiểm tra lại đường dẫn!")
    except Exception as e:
        print(f" Đã xảy ra lỗi hệ thống: {e}")
hex_input = r"D:\HK2-2025\HDL\LAB2\output_hex.hex"      # File hex bạn muốn đọc
image_output = r"D:\HK2-2025\HDL\LAB2\output_image.jpg"   # Tên ảnh bạn muốn lưu ra
# Nhập đúng kích thước ảnh gốc của bạn
W = 430
H = 554
# Chạy hàm
hex_to_image(hex_input, image_output, W, H)
