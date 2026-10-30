# TFD Core Framework — Bản Phê Chuẩn Chính Thức
## Family Tree Doctrine (TFD) Core + Alignment Report

**Dự án:** myclan.com.vn  
**Mã tài liệu:** TFD-CORE-APPROVAL-1.0.0  
**Ngày phê chuẩn:** 2026-10-30  
**Trạng thái:** **PHÊ CHUẨN** — Khung TFD Core có hiệu lực để triển khai  
**Phạm vi:** TFD-001, TFD-101, TFD-201, TFD-301 + MYCLAN-FTD-TFD-ALIGNMENT-REPORT-2.0.0-FINAL  

---

## 1. Quyết định phê chuẩn

Hội đồng Kiến trúc / Chủ dự án **phê chuẩn khung TFD Core** bao gồm bốn tài liệu sau làm **SSOT nội dung nghiệp vụ và mô hình logic** cho hệ thống Cây Phả Hệ của myclan.com.vn:

| Mã | Tên tài liệu | Vai trò trong khung | Phiên bản gốc |
|----|--------------|---------------------|---------------|
| **TFD-001** | Tổng quan và nguyên tắc quy chuẩn | Nguyên tắc nền tảng, phạm vi, ngôn ngữ PHẢI/NÊN/CÓ THỂ | 0.1 (20/10/2026) |
| **TFD-101** | Mô hình dữ liệu | Kiến trúc logic Identity / Relationship / Event / Source-Evidence / Lineage | 0.1 (20/10/2026) |
| **TFD-201** | Quy tắc gia phả Việt Nam và chi phái | Quy tắc nghiệp vụ đặc thù Việt Nam (đời, chi/phái, tên, thứ tự) | 0.1 (20/10/2026) |
| **TFD-301** | Quy trình quản lý nguồn, chứng cứ và dị bản | Quy trình chứng cứ, assertion, mâu thuẫn, provenance | 0.1 (20/10/2026) |

**Đồng thời phê chuẩn** tài liệu kỹ thuật liên kết:

- **MYCLAN-FTD-TFD-ALIGNMENT-REPORT-2.0.0-FINAL** (21/10/2026) — Hợp đồng ngữ nghĩa giữa TFD Core và FT-DOCTRINE-SPEC / Graph Engine.

**Nguyên tắc tích hợp đã chốt:**
- TFD Core = Quy chuẩn nội dung nghiệp vụ, khoa học chứng cứ, quy tắc tộc ước Việt Nam.
- FT-DOCTRINE-SPEC = Đặc tả kỹ thuật Graph Engine, concurrency, projection, RBAC.
- Hai lớp **không thay thế** nhau. Alignment Report là cầu nối bắt buộc.

---

## 2. Nguyên tắc cốt lõi được freeze (từ TFD-001)

Các nguyên tắc sau **có hiệu lực bắt buộc** khi triển khai:

1. **P-01 Định danh ổn định** — `person_id` không đổi khi sửa tên, ngày, vị trí cây.
2. **P-02 Không suy diễn khi thiếu chứng cứ** — Không tự kết luận quan hệ huyết thống từ họ tên, địa điểm, trùng ngày.
3. **P-03 Nguyên bản được bảo toàn** — Tên Hán Nôm, cách ghi cổ, bản phiên âm/dịch tách biệt.
4. **P-04 Nguồn gắn với mệnh đề** — Assertion quan trọng phải có Citation hoặc ghi rõ “chưa có nguồn”.
5. **P-05 Mô hình quan hệ có kiểu** — Phân biệt sinh học / nhận nuôi / pháp lý / xã hội / tư cách dòng họ.
6. **P-06 Không ép dữ liệu bất định thành giá trị chính xác** — Hỗ trợ ngày thiếu, khoảng, xấp xỉ, tranh chấp.
7. **P-07 Độc lập dữ liệu và hiển thị** — Sơ đồ cây là projection, không làm thay đổi dữ liệu gốc.
8. **P-08 Quy tắc dòng họ có phạm vi** — Đời thứ, trưởng/thứ, chi phái gắn với bộ quy ước + nguồn cụ thể.
9. **P-09 Truy nguyên và lịch sử thay đổi** — Mọi thay đổi quan trọng có before/after + agent + thời điểm.
10. **P-14 Không xóa bất đồng** — Lưu các Assertion cạnh tranh; SelectionPolicy chỉ chọn giá trị hiển thị.

---

## 3. Mô hình logic được phê chuẩn (từ TFD-101 + Alignment)

### 3.1 Các nhóm thực thể chính

- **Identity:** Person, Name, PersonIdentifier
- **Relationship:** Parentage (quan hệ cha/mẹ–con), Union (bối cảnh kết đôi), Relationship mở rộng
- **Event & Place:** Event, EventParticipant, Place, PlaceName
- **Source & Evidence:** Source, Citation, Assertion/Claim, EvidenceAssessment, Conclusion
- **Genealogy-specific:** Lineage, LineageMembership, GenerationAssignment
- **Governance:** ChangeLog, AccessPolicy

### 3.2 Mapping đã chốt (Alignment Report)

| Khái niệm TFD | Khái niệm Engine | Model target | Ghi chú |
|---------------|------------------|--------------|---------|
| Cá nhân | Person | `members` | UUID ổn định, độc lập vai trò |
| Quan hệ cha/mẹ–con | Parentage | `parentages` | Có `relationship_type`, `review_status`, `is_selected_for_lineage` |
| Bối cảnh kết đôi | Union | `marriages` | Optional trên Parentage |
| Khẳng định / Claim | Assertion | `review_status` | PROPOSED / ACCEPTED / DISPUTED / REJECTED / SUPERSEDED |
| Kết luận | SelectionPolicy | Cấu hình policy | Chỉ ACCEPTED + selected được vẽ Cây chính |
| Chi/phái văn hóa | Lineage | `lineage_memberships` | Độc lập với Branch RBAC |
| Phạm vi biên tập | Branch (RBAC) | `branches` | Không đồng nhất với chi phái tộc ước |

**Cây chính (Primary Tree):** Chỉ lấy Parentage có  
`review_status = ACCEPTED` **AND** `is_selected_for_lineage = true`.  
Nếu có xung đột chưa giải quyết → trạng thái `UNRESOLVED_CONFLICT` (không tự chọn bản ghi mới nhất).

---

## 4. Quy tắc Việt Nam được freeze (từ TFD-201)

- Đời thứ là thuộc tính theo quy ước + anchor, **không** bằng khoảng cách cạnh đồ thị sinh học.
- Chi/phái và tư cách thành viên là thực thể riêng (`LineageMembership`), không thay bằng quan hệ cha–con.
- Không tự động gán trưởng/thứ từ tuổi, giới tính hoặc thứ tự nhập liệu.
- Một người có thể có nhiều tên (khai sinh, húy, tự, hiệu, thụy, Hán Nôm) — mỗi tên là bản ghi riêng có nguồn.
- Con nuôi / con riêng / con đỡ đầu phải có loại quan hệ rõ; không ép vào hôn nhân cha mẹ.
- Quy tắc tính đời, chi phái phải khai báo phạm vi áp dụng.

---

## 5. Quy trình chứng cứ được freeze (từ TFD-301)

Hệ thống **PHẢI** phân biệt tối thiểu các lớp:

1. Source  
2. Citation (vị trí cụ thể)  
3. Transcription / Translation  
4. Assertion  
5. EvidenceAssessment  
6. Conclusion / SelectionPolicy  
7. Giá trị hiển thị (Display)

**Bắt buộc:**
- Bảo toàn mâu thuẫn.
- Không biến diễn giải thành nguyên văn.
- Không đồng nhất “không thấy” với “không tồn tại”.
- Mọi sửa đổi kết luận đã công bố phải truy nguyên.

---

## 6. Ràng buộc kỹ thuật bắt buộc (từ Alignment)

- Mọi mutation cấu trúc cây (thêm/sửa/xóa Parentage, re-parent, merge) **PHẢI** chạy Cycle Detection **fail-closed**.
- Dùng `pg_advisory_xact_lock` theo `tenant_id` khi ghi cấu trúc.
- Không được commit khi validation incomplete / timeout.
- Parentage là bảng độc lập (không còn dùng `father_id` / `mother_id` adjacency list làm nguồn sự thật).

---

## 7. Phạm vi hiệu lực và giới hạn

**Có hiệu lực:**
- Mô hình logic và nguyên tắc nghiệp vụ của TFD Core.
- Mapping ngữ nghĩa với Graph Engine theo Alignment Report.
- Quy tắc xây dựng Primary Tree và SelectionPolicy.

**Chưa freeze (vẫn là hỗ trợ / draft):**
- TFD-102, TFD-103, TFD-401, TFD-501, TFD-601 (dùng tham chiếu, không phải yêu cầu bắt buộc tuyệt đối ở giai đoạn này).
- Chi tiết Prisma schema vật lý, API endpoint, UI cụ thể.
- Engine lịch âm dương đầy đủ và ngưỡng pháp lý.

---

## 8. Điều kiện áp dụng

1. Mọi thiết kế schema, API, và logic Engine **PHẢI** tuân thủ khung này.
2. Khi có mâu thuẫn giữa tài liệu TFD gốc và Alignment Report → **Alignment Report ưu tiên** cho triển khai kỹ thuật.
3. Thay đổi khung này phải tạo phiên bản mới và ghi vào Decision Register.

---

**Phê chuẩn bởi:** Chủ dự án / Hội đồng Kiến trúc myclan.com.vn  
**Ngày có hiệu lực:** 2026-10-30  
**Tài liệu gốc tham chiếu:**  
- TFD-001, TFD-101, TFD-201, TFD-301 (Standard FTD)  
- MYCLAN-FTD-TFD-ALIGNMENT-REPORT-2.0.0-FINAL (FTDI)

---

*Đây là bản phê chuẩn khung. Tài liệu thực chiến chi tiết (FTDI Practical Spec) sẽ được xây dựng tiếp theo trên nền tảng này.*
