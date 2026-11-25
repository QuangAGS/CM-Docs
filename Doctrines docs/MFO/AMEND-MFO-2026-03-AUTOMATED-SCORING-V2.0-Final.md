# AMEND-MFO-2026-03-AUTOMATED-SCORING

**Phiên bản:** 1.3 (Final Frozen for Phase 2)
**Ngày:** 2026-11-25
**Trạng thái:** TÀI LIỆU TIỀN TRẠM (CHỐT CHO PHASE 2)
**Mã tài liệu:** AMEND-MFO-2026-03

**Tài liệu quy chiếu:**

* AMEND-MFO-2026-02-ENTITY-RESOLUTION (v1.6 / v2.0 Final Release)

* TFD-CORE-APPROVAL-1.0.0

* FTDI-PRACTICAL-SPEC-1.0.4-Final

## MFO-AS-00. Mục đích & Nguyên tắc (Phase 2)

Tài liệu này đặc tả thuật toán **Automated Duplicate Scoring Engine**. Mục tiêu là phát hiện và đưa ra **gợi ý trùng lặp (Advisory Suggestion)** cho người dùng cuối (EU) ngay khi họ đang xây cây, nhằm giảm thiểu tối đa hồ sơ rác.

**Nguyên tắc vận hành (Tuân thủ TFD-001):**

1. **Chỉ gợi ý, không tự động gộp (P-02):** Engine chỉ đóng vai trò radar cảnh báo.

2. **Ngưỡng hành động (Action Thresholds):**
   *(Lưu ý: Ngưỡng dưới đây được thiết lập bảo thủ trong giai đoạn đầu để tránh báo động giả. Các mốc này sẽ được Data Team tự động tinh chỉnh (calibrate) dựa trên dữ liệu đo lường thực tế sau khi Go-Live).*
   * Điểm $\ge$ **75**: Cảnh báo đỏ. Yêu cầu EU xác nhận trước khi lưu (nhưng không chặn cứng).
   * **60** $\le$ Điểm < 75: Cảnh báo vàng. Hiển thị thẻ gợi ý nhẹ nhàng.
   * Điểm < 60: An toàn.
   * *Giới hạn hiển thị:* Trả về tối đa 5 kết quả có điểm cao nhất để tránh làm rối UI.

## MFO-AS-10. Bộ trọng số Đa chiều (Multi-dimensional Scoring Matrix)

Dựa trên đặc thù gia phả Việt Nam, Trục C được thiết kế cơ chế "Overdrive" (vượt trần) để gánh điểm cho các trường hợp thiếu ngày tháng:

| Trục thông tin | Trọng số | Diễn giải | 
| ----- | ----- | ----- | 
| **A. Danh xưng (Họ Tên)** | Tối đa 25đ | Trọng số giảm nhẹ vì tên người Việt dễ trùng lặp. | 
| **B. Sự kiện Lịch pháp (Ngày tháng)** | Tối đa 25đ | So khớp Sinh/Mất/Giỗ Âm lịch. | 
| **C. Mạng lưới Quan hệ** | **Tối đa 45đ** | **Tín hiệu mạnh nhất**. Tăng trần lên 45đ để kích hoạt cảnh báo Đỏ khi trùng từ 2 ID trực hệ trở lên. | 
| **D. Không gian & Chi phái** | Tối đa 15đ | Hữu ích nhưng độ phủ thực tế thấp. | 

*(Lưu ý Hệ thống: Tổng điểm danh nghĩa là 110đ, nhưng điểm output cuối cùng bị cap ở mức tối đa 100đ).*

## MFO-AS-20. Chi tiết Thuật toán Chấm điểm

### Trục A: Danh xưng (Tối đa 25đ)

* **A1. Trùng Tên Húy / Tự / Thụy:** +25đ.

* **A2. Trùng chính xác Họ và Tên chính:** +15đ.

* **A3. Trùng Tên chính, khác/khuyết Họ đệm:** +10đ.

* **A4. Sai số chính tả (Levenshtein $\le$ 2):** +5đ.
  *(Chỉ lấy điểm cao nhất, không cộng dồn vượt 25đ).*

### Trục B: Lịch pháp (Sinh/Mất/Giỗ) (Tối đa 25đ)

* **B1. Trùng chính xác Ngày/Tháng/Năm (Âm hoặc Dương):** +25đ.

* **B2. Trùng chính xác Ngày/Tháng Giỗ (Âm lịch):** +20đ.

* **B3. Trùng Năm Sinh/Mất (Biết chính xác):** +15đ.

* **B4. Một bên có mốc chính xác, một bên chỉ có Khoảng (Estimated):** +10đ.

* **B5. Mâu thuẫn logic cứng:** Phạt -30đ. *Lưu ý: Không phạt nếu một bên bị khuyết (NULL).*

### Trục C: Mạng lưới Quan hệ (Tối đa 45đ - Cấp số nhân cho Huyết thống)

* **C1. Trùng ID Bản ghi (`member_id`) của Vợ/Chồng:** +25đ.

* **C2. Trùng ID Bản ghi (`member_id`) của Cha hoặc Mẹ:** +25đ.

* **C3. Trùng Tên Vợ/Chồng hoặc Cha/Mẹ (Chưa link ID):** +15đ.

* **C4. Trùng Tên người con:** +5đ **mỗi người con trùng tên** (Tối đa +15đ cho nhóm này).
  *(Điểm cộng dồn, tối đa 45đ).*

### Trục D: Không gian & Chi phái (Tối đa 15đ)

* **D1. Trùng địa điểm An táng / Mộ phần:** +15đ.

* **D2. Cùng một phân nhánh Chi/Phái:** +10đ.

* **D3. Trùng Quê quán / Nơi sinh:** +5đ.
  *(Điểm cộng dồn tối đa 15đ).*

## MFO-AS-30. Tối ưu hóa Hiệu năng & Bộ lọc Loại trừ

### 30.1 Bộ lọc Loại trừ Cứng (Exclusion Rules)

Tuyệt đối không chấm điểm và không hiển thị gợi ý với các bản ghi thuộc diện:

1. Bản ghi đã bị xóa (`deleted_at IS NOT NULL`) hoặc đã gộp (`merged_into_id IS NOT NULL`).

2. Bản ghi đang là các tọa độ đa vị trí (Multiple Occurrences) của chính cá nhân đang được nhập liệu.

### 30.2 Bộ lọc thô (Pre-filtering - Elasticsearch)

Chỉ đưa vào chấm điểm những bản ghi thỏa 1 trong 3 điều kiện:

1. Trùng Tên Húy/Tự/Hiệu HOẶC Trùng Tên chính (bỏ họ đệm) + Cùng Giới tính.

2. Trùng chính xác Năm sinh hoặc Năm mất + Cùng Giới tính.

3. **Có chung một ID Cha, Mẹ, hoặc Vợ/Chồng.** $\rightarrow$ *Tín hiệu Đặc cách: Điều kiện 3 bỏ qua hoàn toàn yêu cầu phải có tên. Bắt trọn các bản ghi phả cổ chỉ ghi "Con ông A, vợ bà B" (Khuyết danh) nhưng có ID liên kết mạnh.*

### 30.3 Cơ chế Học từ Phản hồi (Negative Feedback Loop)

* **Phạm vi cá nhân hóa:** Ghi nhận từ chối gắn với cặp `(User_ID, Target_ID)`. Nếu User A bấm "Không phải người này", hệ thống trừ 50đ trong mọi Draft sau này của riêng User A, nhưng User B tạo mới vẫn được gợi ý bình thường.

* **Cơ chế Reset:** Admin dòng họ có một giao diện Audit để xem danh sách các "Từ chối gợi ý trùng lặp" và có quyền bấm "Reset" (xóa bản ghi khỏi bảng `duplicate_rejections`) nếu phát hiện EU từ chối nhầm.

## MFO-AS-40. Ví dụ Tính điểm Thực tế (Áp dụng Overdrive Trục C)

**Case 1: Trùng nhiều ID quan hệ nhưng thiếu năm sinh (Nguy cơ Đỏ - Vượt trần C)**

* Khai báo mới: "Nguyễn Văn A" (Không rõ năm sinh), Vợ "B", Cha "C".

* Đã có trên DB: "Văn A" (Không rõ năm sinh). Đã map chung ID Vợ và ID Cha.

* Tính điểm:
  * Trục A: Tên A3 (10đ).
  * Trục B: Trống (0đ, không phạt).
  * Trục C: Trùng ID Cha C2 (25đ) + Trùng ID Vợ C1 (25đ) = 50đ $ightarrow$ Bị cap ở **45đ**.
  * Tổng điểm: 10 + 0 + 45 = **55đ** (Chưa đỏ, nhưng với tín hiệu mạnh, Admin chỉ cần bổ sung 1 năm sinh ước chừng là nhảy vọt).

* *Nếu có thêm năm sinh ước chừng (Khoảng 1950 vs 1951) B4 (10đ):* Tổng 55 + 10 = **65đ (Vàng)**.
* *Nếu thêm cùng một địa điểm an táng D1 (15đ):* Tổng 65 + 15 = **80đ (Báo động Đỏ)**.

**Case 2: Cùng tên, trùng năm sinh, trùng tên 3 con (Cảnh báo Vàng mạnh)**

* Khai báo mới: "Lê Thị Lan" (1980), con: Nam, Hải, Bình.

* DB: "Lê Thị Lan" (1980), con: Nam, Hải, Bình.

* Tính điểm: Tên A2 (15đ) + Ngày B3 (15đ) + Trùng tên 3 con C4 (5đ x 3 = 15đ) = **45đ**.

* *Nếu Admin map được ID Chồng:* 45đ + Trùng ID Chồng C1 (25đ) = **70đ (Cảnh báo Vàng rất cao, sát ngưỡng Đỏ)**.

## MFO-AS-50. Giới hạn hiện tại (Known Limitations for Phase 2)

1. **Dữ liệu chữ Hán Nôm:** Nếu dữ liệu Hán Nôm chưa được chuẩn hóa, công cụ so khớp chuỗi sẽ hoạt động kém hiệu quả.

2. **Khuyết tên, thiếu quan hệ:** Các bản ghi kiểu "Khuyết danh mẫu thân" mà lại KHÔNG được map ID với chồng/con sẽ bị lọc bỏ ngay ở lớp Pre-filtering để tiết kiệm tài nguyên.

**Chữ ký:** \[Tech Lead / Data Architect\]

**Ngày soạn thảo:** 2026-11-25