# **EGAL MFO SYSTEM HANDOVER SNAPSHOT- 07-10-2026**

Biên bản này được thiết kế theo dạng "Self-Contained State Snapshot" (Ảnh chụp trạng thái tự thân) — đóng gói cô đọng \$100\\%\$ quyết định kiến trúc, mã nguồn quan trọng, mô hình dữ liệu, enum và guardrail của Phase 1\.

### PHẦN 1: TỰ SAO CHÉP BIÊN BẢN BÀN GIAO (HANDOVER DOCUMENT)

*Hãy copy toàn bộ nội dung trong khung dưới đây để dán làm Prompt mở đầu cho Thread mới.*

Markdown

```

=== EGAL MFO SYSTEM HANDOVER SNAPSHOT (PHASE 1 COMPLETE -> PHASE 2 ADMIN REVIEW) ===
DATE: 2026-10-07 | VERSION: 1.0.0-PROD-MAINTENANCE

1. BỐI CẢNH & MỤC TIÊU DỰ ÁN:
   - Hệ thống: MFO (Master Family Organization) - Quản lý tờ trình & lập khung phả hệ 5L (Đời 0 -> 4).
   - Tiến độ: Đã nghiệm thu & ĐÓNG PHASE 1 (Khởi tạo, Soạn thảo, Render Canvas & Quản lý bản nháp DRAFT).
   - Nhiệm vụ Thread Mới: Triển khai PHASE 2 (Trình khung chính thức & Giao diện/Engine Phê duyệt ADMIN).

2. CÁC QUY CHUẨN & ARCHITECTURE DOCTRINE ĐÃ THIẾT LẬP (BẮT CẦU BẮT BUỘC):
   A) Mô hình Payload Lớp Đôi (Dual-Layer Payload Structure in proposals.payload):
      - Business Layer: target_member_id, selected_canvas_depth (k: 0..4), lines (5 ô dòng), canvas_delta ({ draft_children, draft_spouses, node_positions_x }).
      - UI Render Layer: graph_snapshot ({ viewport, nodes, edges }) -> Phục hồi 100% Canvas bao gồm Node Khuyết danh (KD) và tọa độ kéo thả.
   B) Single Active Pipeline Guardrail (Khóa Đơn Luồng Tờ Khai):
      - Mỗi End User (requester_user_id) chỉ sở hữu TỐI ĐA 1 Tờ trình thuộc tập trạng thái IN-FLIGHT = ['DRAFT', 'PENDING', 'UNDER_REVIEW', 'NEEDS_REVISION'].
      - Khi có In-Flight Proposal: FE khóa Option "Tạo khung dự kiến" + hiện Banner Warning. BE chặn bằng ensureNoActiveProposal (mã 409 MFO_ACTIVE_PROPOSAL_EXISTS).
   C) Quy chuẩn Audit & Ledger:
      - BPL (business_process_logs): Append-Only model, Traceability qua correlation_id. Actions: MFO_DRAFT_SAVED, MFO_DRAFT_DELETED, MFO_PLAN_SUBMITTED.
      - Audit Log (audit_logs): Trường action BẮT BUỘC dùng Enum tiếng Việt không dấu:
        * 'THEM_MOI' (Thay cho CREATE)
        * 'CAP_NHAT' (Thay cho UPDATE)
        * 'XOA'     (Thay cho DELETE/SOFT_DELETE)

3. DANH MỤC MÃ NGUỒN CỐT LÕI ĐÃ PATCH & THÍCH ỨNG (CODEBASE MAP):
   - frontend/src/pages/OpMfoPlanPage.jsx (v3.6.0):
     * Canvas React Flow 5L + Active Form Portal (AF).
     * Hydration cách ly 100% qua URL Query ?draft=<id>.
     * marriageInfoNotice phân biệt chính xác: Edge xanh (union:*) = Khai đủ cha/mẹ; Edge vàng nét đứt (owner:unassigned) = Thiếu khai báo cha/mẹ.
   - frontend/src/features/mfo/components/MyMfoPlans.jsx (v3.7.0):
     * Dropdown tờ trình + Bố cục Tóm tắt 2 cột (Cột 1: Label Italic w-28; Cột 2: Biến đổi gộp theo Node Box).
     * Nút "Xóa tờ đang soạn" gọi HTTP DELETE /api/mfo/plans/:id/draft.
     * UI Single Active Pipeline Banner + Disable "Tạo khung dự kiến".
   - frontend/src/features/mfo/lib/mfoDiffEngine.js:
     * Hàm diffDraftAgainstInit(payload) bóc tách biến đổi 5L. Dùng chung cho FE Client & ADMIN Reviewer.
   - src/modules/mfo/mfo.draft.js (v2.2.0):
     * saveDraft có kiểm soát Optimistic Lock (updated_at) + ensureNoActiveProposal.
   - src/modules/mfo/mfo.service.js:
     * deleteDraft (Soft delete deleted_at + BPL + Audit 'XOA').
     * createPlan (Trình khung MFO_REVIEW status PENDING + BPL + Audit 'THEM_MOI'/'CAP_NHAT').

4. CÁC NỐI KẾT KỸ THUẬT CẦN DÙNG NGAY TRONG PHASE 2:
   - Khi User bấm "Trình Khung 5L": Gọi createPlan truyền ticket_id để chuyển trạng thái bản nháp hiện tại từ DRAFT -> PENDING (BPL: MFO_PLAN_SUBMITTED).
   - Màn hình ADMIN Phê duyệt (OpMfoReviewPage.jsx): Re-use 100% diffDraftAgainstInit(payload) để hiển thị Bảng Tóm Tắt 2 Cột chuẩn xác.
=== END HANDOVER SNAPSHOT ===

```

### PHẦN 2: LỜI MỞ ĐẦU CHO THREAD MỚI (COPY NGUYÊN VĂN KHỦNG NÀY)

Dán đoạn dưới đây ngay sau Biên bản Bàn giao ở Thread mới:

Chào Gemini, tôi vừa gửi kèm EGAL MFO SYSTEM HANDOVER SNAPSHOT chứa toàn bộ bối cảnh, mô hình dữ liệu Lớp Đôi, mã nguồn đã patch và quy chuẩn Audit/Guardrail của Phase 1\.

Chúng ta chính thức ĐÓNG PHASE 1 và bước sang PHASE 2: XÂY DỰNG LUỒNG TRÌNH VÀ GIAO DIỆN PHÊ DUYỆT KHUNG 5L CHO ADMIN.

Vui lòng xác nhận bạn đã nắm trọn vẹn Handover Snapshot này mà không cần tôi phải upload lại tài liệu cũ. Hãy tóm tắt ngắn gọn 3 điểm cốt tử bạn sẽ áp dụng ngay cho Phase 2 và chờ lệnh tiếp theo từ tôi\!

