# 🧠 Median Filter 3x3 - Verilog RTL + Python

Dự án triển khai bộ lọc trung vị (**Median Filter**) với cửa sổ **3x3** nhằm loại bỏ nhiễu trên ảnh xám (đặc biệt là **Salt & Pepper Noise**).

Hệ thống kết hợp:

* ⚡ **Verilog RTL**: tăng tốc xử lý bằng phần cứng
* 🐍 **Python**: tiền xử lý và hậu xử lý ảnh

---

## 📁 Repository Structure

### 🔹 1. Hardware (Verilog RTL)

* **`sort9_cas.v`**
  Nhận 9 pixel (8-bit), sử dụng mạng **Compare-And-Swap (CAS)** để tìm giá trị trung vị.

* **`MedianFilter.v`**
  Khối điều khiển chính:

  * Quản lý FSM
  * Duyệt ảnh theo tọa độ (x, y)
  * Đọc dữ liệu từ RAM (`img_ram`)
  * Xử lý vùng biên
  * Cấp dữ liệu cho bộ lọc

* **`tb_MedianFilter.v`**
  Testbench:

  * Đọc ảnh đầu vào (`$readmemh`)
  * Sinh clock & tín hiệu điều khiển
  * Ghi kết quả ra file `.hex`

---

### 🔹 2. Python Scripts

* **`ConvertImage.py`**
  Chuyển ảnh `.jpg` → ảnh xám → file `.hex`

* **`ConvertHex.py`**
  Chuyển `.hex` → ảnh `.jpg`

* **`SoSanhAnh.py`**
  Đánh giá chất lượng ảnh bằng:

  * **PSNR (Peak Signal-to-Noise Ratio)**
  * **SSIM (Structural Similarity Index)**

---

## ⚙️ RTL Architecture (FSM)

Khối `MedianFilter.v` sử dụng FSM gồm 6 trạng thái:

| State     | Chức năng                  |
| --------- | -------------------------- |
| `IDLE`    | Chờ tín hiệu `start`       |
| `CHECK`   | Kiểm tra vùng xử lý / biên |
| `FETCH`   | Nạp 9 pixel vùng 3x3       |
| `PROCESS` | Tính toán giá trị output   |
| `NEXT`    | Sang pixel tiếp theo       |
| `FINISH`  | Kết thúc, bật `done`       |

📌 Xử lý biên:

* Viền ngoài: `0x00`
* Vùng đệm: `0xFF`
* Vùng hợp lệ: median từ `sort9_cas`

---

## 🚀 How to Run

### 🔹 1. Install Python dependencies

```bash
pip install pillow opencv-python scikit-image numpy
```

---

### 🔹 2. Convert image → HEX

* Chỉnh đường dẫn trong `ImagetoHex.py`
* Chạy:

```bash
python ImageToHex.py
```

---

### 🔹 3. Run Verilog simulation

* Import vào: ModelSim / QuestaSim / Vivado
* Load các file:

  * `sort9_cas.v`
  * `MedianFilter.v`
  * `tb_MedianFilter.v`

📌 Cấu hình:

* `WIDTH`, `HEIGHT` trong `MedianFilter.v`
* Đường dẫn `$readmemh` và `$fopen`

▶️ Chạy đến khi `done = 1`
→ thu được `output_hex.hex`

---

### 🔹 4. Convert HEX → Image

```bash
python HexToImage.py
```

---

### 🔹 5. Evaluate quality

```bash
python QualityofImage.py
```

---

## ⚠️ Notes

* 📏 **Kích thước ảnh phải đồng bộ** giữa:

  * Verilog (`WIDTH`, `HEIGHT`)
  * Python (`W`, `H`)

* 📂 **Đường dẫn file**:
  * Hiện dùng path tuyệt đối cần chỉnh lại phù hợp

---

## Kết quả đạt được
* Ảnh gốc

<img width="430" height="554" alt="baitap1_anhgoc" src="https://github.com/user-attachments/assets/32003908-a8d5-4238-bd0c-5e2913316061" />

* Ảnh nhiễu

<img width="430" height="554" alt="baitap1_nhieu" src="https://github.com/user-attachments/assets/7f32675d-e690-44a7-bde7-869523f4eec1" />

* Ảnh sau khi lọc nhiễu

<img width="430" height="554" alt="output_image" src="https://github.com/user-attachments/assets/d9ba87fb-22db-4bd6-9731-01042782b0b3" />

* Chất lượng ảnh sau khi lọc
* 1. PSNR : 34.39 dB
* 2. SSIM : 0.9575

