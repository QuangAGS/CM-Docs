# AMEND-MFO-2026-03-AUTOMATED-SCORING

**Phiên bản:** 2.1 (Multi-Source Scoring Integrated)

**Ngày:** 2026-11-25

**Trạng thái:** TÀI LIỆU TIỀN TRẠM (CHỐT CHO PHASE 2)

**Mã tài liệu:** AMEND-MFO-2026-03

**Tài liệu quy chiếu:**

* AMEND-MFO-2026-02-ENTITY-RESOLUTION (v2.2)

* PLAN-MFO-2026-IMPLEMENTATION (v2.2)

* TFD-CORE-APPROVAL-1.0.0

## MFO-AS-00. Mục đích & Nguyên tắc (Phase 2)

Đặc tả thuật toán **Automated Duplicate Scoring Engine**. Mục tiêu phát hiện và đưa ra **gợi ý trùng lặp (Advisory Suggestion)** cho EU khi xây cây, kết hợp khai thác dữ liệu từ Kiến trúc Đời đa nguồn.

**Nguyên tắc vận hành (Tuân thủ TFD-001):**

1. **Chỉ gợi ý (P-02):** Engine chỉ đóng vai trò radar.

2. **Ngưỡng hành động:**

   * Điểm $\ge$ **75**: Cảnh báo đỏ.

   * **60** $\le$ Điểm < 75: Cảnh báo vàng.

   * Điểm < 60: An toàn.

   * *Giới hạn hiển thị:* Tối đa 5 kết quả.

## MFO-AS-10. Bộ trọng số Đa chiều (Multi-dimensional Matrix)

Trục C được giữ mức trần **45đ** (cơ chế Overdrive cho mạng lưới quan hệ) và Trục D bổ sung tín hiệu tương quan Datum Offset đa nguồn. Việc nâng trần Trục C lên 45đ và tổng điểm danh nghĩa lên **110đ** là thay đổi có chủ đích để tăng độ nhạy nhận diện trùng thực thể khi thiếu dữ liệu ngày tháng, trong khi điểm đầu ra cuối cùng vẫn được kẹp chặt ở mức tối đa **100đ** ($\text{Score}_{\text{final}} = \min(100, \text{Score}_{\text{axis\_A}} + \text{Score}_{\text{axis\_B}} + \text{Score}_{\text{axis\_C}} + \text{Score}_{\text{axis\_D}})$):

| Trục thông tin | Trọng số | Diễn giải | 
| ----- | ----- | ----- | 
| **A. Danh xưng** | Tối đa 25đ | Tên người Việt dễ trùng lặp. | 
| **B. Sự kiện Lịch pháp** | Tối đa 25đ | So khớp Sinh/Mất/Giỗ Âm lịch. | 
| **C. Mạng lưới Quan hệ** | **Tối đa 45đ** | **Tín hiệu mạnh nhất** (chủ đích giữ 45đ). Overdrive kích hoạt Cảnh báo đỏ khi trùng từ 2 ID trực hệ. | 
| **D. Không gian & Đời (Offset)** | Tối đa 15đ | Khớp Địa điểm / Chi phái / **Khớp Datum Offset Đa nguồn**. | 

*(Tổng danh nghĩa 110đ, giới hạn trần output 100đ).*

## MFO-AS-20. Chi tiết Thuật toán Chấm điểm

### Trục A: Danh xưng (Tối đa 25đ)

* **A1.** Trùng Tên Húy / Tự / Thụy: +25đ.

* **A2.** Trùng chính xác Họ và Tên chính: +15đ.

* **A3.** Trùng Tên chính, khác/khuyết Họ đệm: +10đ.

* **A4.** Sai số chính tả (Levenshtein $\le$ 2): +5đ.

### Trục B: Lịch pháp (Tối đa 25đ)

* **B1.** Trùng chính xác Ngày/Tháng/Năm: +25đ.

* **B2.** Trùng chính xác Ngày/Tháng Giỗ Âm lịch: +20đ.

* **B3.** Trùng Năm Sinh/Mất: +15đ.

* **B4.** Có Khoảng (Estimated) khớp mốc chính xác: +10đ.

* **B5.** Mâu thuẫn logic cứng: Phạt -30đ.

### Trục C: Mạng lưới Quan hệ (Tối đa 45đ)

* **C1.** Trùng ID Bản ghi (`member_id`) của Vợ/Chồng: +25đ.

* **C2.** Trùng ID Bản ghi (`member_id`) của Cha hoặc Mẹ: +25đ.

* **C3.** Trùng Tên Vợ/Chồng hoặc Cha/Mẹ: +15đ.

* **C4.** Trùng Tên người con: +5đ/con (Tối đa +15đ).

### Trục D: Không gian, Chi phái & Multi-Source (Tối đa 15đ)

* **D1.** Trùng địa điểm An táng / Mộ phần: +15đ.

* **D2.** **Tương quan Datum Offset:** Mức đời (sau khi cộng `root_generation_offset`) khớp nhau giữa 2 bản ghi từ 2 nguồn khác nhau: +10đ.

* **D3.** Trùng Quê quán / Nơi sinh: +5đ.

## MFO-AS-30. Tối ưu hóa & Bộ lọc

### 30.1 Bộ lọc Loại trừ Cứng (Exclusion)

1. Đã xóa (`deleted_at`) hoặc đã gộp (`merged_into_id`).

2. Là tọa độ đa vị trí (Multiple Occurrences) của chính cá nhân đang nhập liệu.

### 30.2 Bộ lọc thô (Pre-filtering - Elasticsearch)

Chỉ chấm điểm nếu thỏa 1 trong 3:

1. Trùng Tên (có/không họ đệm) + Cùng Giới tính.

2. Trùng Năm sinh/mất + Cùng Giới tính.

3. **Có chung ID Cha, Mẹ, hoặc Vợ/Chồng** (Đặc cách cho Khuyết danh).

### 30.3 Negative Feedback Loop

* Ghi nhận từ chối `(User_ID, Target_ID)` vào `duplicate_rejections`. Phạt -50đ cho riêng user đó ở các Draft sau.

* Admin có quyền Reset (xóa bản ghi) trên Dashboard Audit.

## MFO-AS-40. Ví dụ Tính điểm Thực tế (Trục C & Offset)

**Case 1: Khớp Offset Đa nguồn (Mới)**

* Mới nhập: "Lê Văn B" Đời 3 (Phả Chi 2, Offset = +2) $\rightarrow$ Đời 5 hệ thống.

* DB: "Lê Văn B" Đời 5 (Phả Đại tôn).

* Tính điểm: Trục A (15đ) + Trục D2 (Khớp mốc Calibrated_Gen: 10đ) = **25đ**. (Radar nhận diện nhẹ sự tương quan).

**Case 2: Nguy cơ Đỏ - Vượt trần C**

* Mới nhập: "Nguyễn Văn A" (Thiếu năm sinh), Vợ "B", Cha "C".

* DB: "Văn A", map chung ID Vợ, ID Cha.

* Tính điểm thành phần:

  * Trục A: Tên A3 = **10đ**.

  * Trục B: Trống = **0đ**.

  * Trục C: Trùng ID Cha C2 (25đ) + Trùng ID Vợ C1 (25đ) = 50đ $\rightarrow$ **Cap Trục C ở 45đ**.

  * Trục D: Trống = **0đ**.

* Tổng điểm: $\min(100, 10 + 0 + 45 + 0) = \mathbf{55\text{đ}}$ (Chưa đạt ngưỡng Cảnh báo vàng 60đ; nếu bổ sung thêm năm sinh ước chừng B4 +10đ sẽ lên **65đ - Cảnh báo vàng**).

## MFO-AS-50. Giới hạn hiện tại (Phase 2)

1. Dữ liệu Hán Nôm chưa chuẩn hóa.

2. Khuyết danh không map ID sẽ bị lọc ngay ở Pre-filtering.

3. Tầng 3 Dynamic Projection Mode cho Canvas sẽ dựa vào các thuật toán nội suy từ hệ thống này.

**Chữ ký:** [Tech Lead / Data Architect]

**Ngày hiệu lực:** 2026-11-25