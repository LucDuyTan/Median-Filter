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

* Chỉnh đường dẫn trong `ConvertImage.py`
* Chạy:

```bash
python ConvertImage.py
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
python ConvertHex.py
```

---

### 🔹 5. Evaluate quality

```bash
python SoSanhAnh.py
```

---

## ⚠️ Important Notes

* 📏 **Kích thước ảnh phải đồng bộ** giữa:

  * Verilog (`WIDTH`, `HEIGHT`)
  * Python (`W`, `H`)

* 📂 **Đường dẫn file**:

  * Hiện dùng path tuyệt đối
  * Cần chỉnh lại phù hợp máy của bạn

---

## 💡 Future Improvements

* Pipeline hóa toàn bộ filter
* Tối ưu latency & throughput
* Hỗ trợ ảnh RGB
* Triển khai trên FPGA thực tế

---

## 👨‍💻 Author

* Median Filter RTL Project
* Verilog + Image Processing

---
