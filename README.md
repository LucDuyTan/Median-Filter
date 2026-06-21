# 🖼️ Median Filter Hardware Acceleration (Verilog & Python)

Dự án này triển khai bộ lọc trung vị (**Median Filter**) kích thước cửa sổ 3x3 nhằm loại bỏ nhiễu (như nhiễu muối tiêu - Salt & Pepper) trên ảnh xám. Hệ thống kết hợp giữa phần cứng **Verilog RTL** (để tăng tốc phần cứng thuật toán) và các script **Python** (để tiền xử lý và hậu xử lý hình ảnh).

---

## 📁 Cấu Trúc Kho Lưu Trữ (Repository Structure)

Dự án được chia làm 2 thành phần chính:

### 1. Khối Phần Cứng (Verilog RTL)
* [cite_start]**`sort9_cas.v`**: Nhận vào 9 điểm ảnh độc lập có kích thước 8-bit[cite: 2]. [cite_start]Sử dụng hàm so sánh đổi chỗ `cas` (Compare-And-Swap) [cite: 3] [cite_start]để tìm giá trị trung vị (`median`) thông qua mạng lưới sắp xếp tối ưu[cite: 5, 15].
* [cite_start]**`MedianFilter.v`**: Khối điều khiển chính tích hợp máy trạng thái (FSM) [cite: 21] [cite_start]để quản lý việc duyệt qua tọa độ hình ảnh $(x, y)$ [cite: 25, 48, 50][cite_start], đọc dữ liệu từ RAM giả lập `img_ram` [cite: 42][cite_start], quản lý vùng đệm biên [cite: 28, 44, 45] và cấp dữ liệu vào bộ lọc[cite: 22].
* [cite_start]**`tb_MedianFilter.v`**: Testbench mô phỏng hệ thống [cite: 53][cite_start], tự động nạp file ảnh hex đầu vào thông qua `$readmemh` [cite: 55][cite_start], cấp xung clock [cite: 55][cite_start], kích hoạt tín hiệu và ghi kết quả xử lý ra file hex đầu ra[cite: 56, 60].

### 2. Khối Hỗ Trợ (Python Scripts)
* **`ConvertImage.py`**: Đọc ảnh thô (`.jpg`), chuyển đổi thành định dạng ảnh xám (Grayscale) và xuất ra file văn bản hệ cơ số 16 (`.hex`) từng dòng để nạp vào bộ nhớ RAM của mô phỏng Verilog.
* **`ConvertHex.py`**: Đọc file kết quả dạng Hex (`.hex`) sau khi mô phỏng RTL, chuyển đổi ngược lại thành lưới điểm ảnh và lưu thành file ảnh dạng `.jpg`.
* **`SoSanhAnh.py`**: Thực hiện tính toán và so sánh hai chỉ số đánh giá chất lượng ảnh là **PSNR (Peak Signal-to-Noise Ratio)** và **SSIM (Structural Similarity Index)** giữa ảnh kết quả đã lọc với ảnh gốc ban đầu.

---

## ⚙️ Nguyên Lý Hoạt Động Của Khối RTL

[cite_start]Khối `MedianFilter.v` sử dụng một Máy trạng thái gồm 6 trạng thái điều khiển tuần tự[cite: 21]:
1. [cite_start]**`IDLE`**: Chờ tín hiệu khởi động `start` để bắt đầu tiến trình quét ảnh[cite: 27].
2. [cite_start]**`CHECK`**: Kiểm tra xem tọa độ hiện tại $(x, y)$ có nằm trong vùng xử lý lõi hay thuộc vùng biên (`BORDER`)[cite: 28].
3. [cite_start]**`FETCH`**: Thực hiện tính toán địa chỉ `addr` [cite: 41] [cite_start]và lần lượt nạp tuần tự 9 điểm ảnh trong cửa sổ ô lưới 3x3 quanh điểm hiện tại vào mảng lưu trữ `win`[cite: 30, 42]. [cite_start]Xử lý bão hòa biên nếu tọa độ vượt quá giới hạn[cite: 39, 41].
4. [cite_start]**`PROCESS`**: Gán đầu ra dữ liệu `pixel_out`[cite: 17]. Nếu điểm ảnh nằm ở viền ngoài cùng sẽ được gán bằng `8'h00` [cite: 44], thuộc vùng đệm biên gán bằng `8'hFF` [cite: 45], các vùng còn lại sẽ lấy giá trị trung vị từ khối `sort9_cas`[cite: 46].
5. [cite_start]**`NEXT`**: Di chuyển sang pixel tiếp theo theo hàng và cột[cite: 48, 50]. [cite_start]Nếu duyệt hết ảnh sẽ chuyển sang trạng thái kết thúc[cite: 50].
6. [cite_start]**`FINISH`**: Bật cờ thông báo `done` hoàn thành xử lý ảnh và quay về trạng thái chờ[cite: 51, 52].

---

## 🚀 Hướng Dẫn Chạy Hệ Thống

Để tiến hành thực hiện toàn bộ quy trình lọc ảnh từ ảnh thô ban đầu, bạn làm theo các bước dưới đây:

### Bước 1: Cài đặt thư viện Python hỗ trợ
Mở Terminal và cài đặt các gói phụ thuộc cần thiết cho việc xử lý ảnh:
```bash
pip install pillow opencv-python scikit-image numpy
