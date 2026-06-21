import cv2
import numpy as np
from skimage.metrics import peak_signal_noise_ratio as compute_psnr
from skimage.metrics import structural_similarity as compute_ssim
file_anh_goc = r"D:\HK2-2025\HDL\LAB2\baitap1_anhgoc.jpg" 
file_anh_ket_qua = r"D:\HK2-2025\HDL\LAB2\output_image.jpg" 

img_original = cv2.imread(file_anh_goc, cv2.IMREAD_GRAYSCALE)
img_reconstructed = cv2.imread(file_anh_ket_qua, cv2.IMREAD_GRAYSCALE)

if img_original is None:
    print(f"Lỗi: Không tìm thấy file {file_anh_goc}")
elif img_reconstructed is None:
    print(f"Lỗi: Không tìm thấy file {file_anh_ket_qua}")
else:
    if img_original.shape != img_reconstructed.shape:
        print("Lỗi: Kích thước hai ảnh không khớp nhau. Hãy kiểm tra lại!")
        print(f"Kích thước ảnh gốc: {img_original.shape}")
        print(f"Kích thước ảnh kết quả: {img_reconstructed.shape}")
    else:
        psnr_value = compute_psnr(img_original, img_reconstructed, data_range=255)

        ssim_value = compute_ssim(img_original, img_reconstructed, data_range=255)
        print("-" * 30)
        print("-" * 30)
        print(f"1. PSNR : {psnr_value:.2f} dB")
        print(f"2. SSIM : {ssim_value:.4f}")
        print("-" * 30)
