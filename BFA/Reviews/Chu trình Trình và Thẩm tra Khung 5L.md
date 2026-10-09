# ĐẶC TẢ KIẾN TRÚC: CHU TRÌNH TRÌNH ⟷ THẨM TRA KHUNG 5L
**Mã phân hệ:** MFO Phase 2 (Chuẩn BFA 1.3.1 / Handover Snapshot 2026-10-07)  
**Tài liệu tham chiếu:** *BFA-Branch-Family-Doctrine-v1.3.1*, *MFO Phase 1 Handover*, *Itemized Review Protocol*

---

## 1. TỔNG QUAN VÀ NGUYÊN TẮC CỐT TỬ

Chu trình Trình $\longleftrightarrow$ Thẩm tra Khung 5L là cơ chế phối hợp hai chiều (Collaborative Review Loop) giữa **Người trình (Founder/MWL)** và **Quản trị viên (Clan Admin / System Admin)** trước khi lô phả hệ chính thức bước vào giai đoạn thi công (Xưởng).

```
┌────────────────────────────────────────────────────────────────────────┐
│                        NGƯỜI TRÌNH (FOUNDER / MWL)                     │
│  [Soạn thảo Canvas 5L] ──► [Trình Khung 5L] ──► [Nhận phản hồi/Sửa]   │
└────────────────────────────────────┬───────────────────────────────────┘
                                     │ (init_SCS + Payload Lớp Đôi)
                                     ▼
┌────────────────────────────────────────────────────────────────────────┐
│                        QUẢN TRỊ VIÊN (ADMIN PORTAL)                    │
│  [Soi Checklist review_SCS] ──► [Kiểm tra đối chiếu Canvas Read-Only]  │
│                                    │                                   │
│           ┌────────────────────────┴────────────────────────┐          │
│           ▼ (Có >= 1 REJECT)                                ▼ (100% OK)│
│  [TRẢ VỀ SỬA: NEEDS_REVISION]                  [PHÊ DUYỆT: PLAN_OK]    │
│           │                                                 │          │
└───────────┼─────────────────────────────────────────────────┼──────────┘
            │ (Lưu vào review_rounds)                         │ (Mở xưởng thi công)
            ▼                                                 ▼
    Founder sửa trên Canvas                           Bước vào Giai đoạn Xưởng
```

### 3 Nguyên tắc bất biến:
1. **Nguyên tắc "Tất cả hoặc không" (Atomic / All-or-Nothing Approval):**
   * Một Khung 5L chỉ được phê duyệt khi $100\%$ các đề xuất biến đổi thành phần đều được Admin chấp thuận (`ACCEPT`).
   * Chỉ cần $1$ đề xuất bị từ chối (`REJECT`), toàn bộ Khung bị trả về trạng thái `NEEDS_REVISION`. Hệ thống cấm duyệt từng phần (Partial Approval) để bảo vệ tính toàn vẹn tham chiếu của đồ thị phả hệ (Graph Referential Integrity).
2. **Nguyên tắc Đối chiếu Độc lập (Decoupled Summarized Content Submission):**
   * Người trình nộp kèm bản tóm tắt nguyên thủy: **`init_SCS`** (Initial Summarized Content Submission).
   * Admin thao tác trên bản kiểm tra tương tác: **`review_SCS`** (Itemized Review Protocol), ghi nhận quyết định và bút phê cụ thể cho từng mục.
3. **Nguyên tắc Bất biến Kiểm toán (Audit Immutability & Round Tracking):**
   * Mỗi chu kỳ Trình $\to$ Thẩm tra được đánh số thứ tự vòng `attempt_no` (đồng bộ với BPL).
   * Mọi bút phê, quyết định và snapshot của các vòng trước được lưu trữ bất biến trong mảng `review_rounds` để phục vụ đối soát, chống chỉnh sửa tùy tiện và giải quyết tranh chấp gia tộc.

---

## 2. CẤU TRÚC DỮ LIỆU ĐẶC TẢ

### 2.1. Bản Tóm Tắt Khung Ban Đầu (`init_scs`)
Được tạo tự động ngay khi Founder bấm **"Trình Khung 5L"** (thông qua engine `diffDraftAgainstInit`):

```json
[
  {
    "item_id": "diff_d1_01",
    "depth": 1,
    "target_node_id": "node_origin_spouse",
    "summary_text": "Gán cụm hôn phối: Nguyễn Văn A & Lê Thị B",
    "action_type": "ASSIGN_UNION"
  },
  {
    "item_id": "diff_d3_01",
    "depth": 3,
    "target_node_id": "draft-child-1728291000",
    "summary_text": "Xin tạo con nháp: Nguyễn Văn D",
    "action_type": "DRAFT_CHILD"
  },
  {
    "item_id": "diff_d4_01",
    "depth": 4,
    "target_node_id": "anon-empty-4-1728292000",
    "summary_text": "Khai khuyết danh (KD) tại Đời 4",
    "action_type": "SET_ANONYMOUS"
  }
]
```

### 2.2. Bản Thẩm Tra Chi Tiết Của Admin (`review_scs`)
Được Admin biên tập trực tiếp trên Admin Portal trong quá trình soi hồ sơ:

```json
[
  {
    "item_id": "diff_d1_01",
    "decision": "ACCEPT",
    "admin_note": ""
  },
  {
    "item_id": "diff_d3_01",
    "decision": "REJECT",
    "admin_note": "Cần bổ sung năm sinh và văn bản xác nhận của chi họ"
  },
  {
    "item_id": "diff_d4_01",
    "decision": "ACCEPT",
    "admin_note": "Chấp thuận tạm thời khuyết danh đời 4"
  }
]
```

### 2.3. Lịch Sử Các Vòng Thẩm Tra (`review_rounds`)
Nằm trong `proposals.payload`, lưu giữ toàn bộ tiến trình lịch sử qua các lần trả về sửa đổi:

```json
{
  "ticket_id": "f47ac10b-58cc-4372-a567-0e02b2c3d479",
  "current_attempt": 2,
  "granted_generation": null,
  
  "init_scs": [ /* init_scs của vòng 2 hiện tại */ ],
  "review_scs": null,

  "review_rounds": [
    {
      "attempt_no": 1,
      "submitted_at": "2026-10-07T08:00:00.000Z",
      "requester_user_id": "usr_founder_01",
      "init_scs": [
        {
          "item_id": "diff_d3_01",
          "depth": 3,
          "target_node_id": "draft-child-1728291000",
          "summary_text": "Xin tạo con nháp: Nguyễn Văn D",
          "action_type": "DRAFT_CHILD"
        }
      ],
      "reviewed_at": "2026-10-07T09:15:00.000Z",
      "reviewer_user_id": "usr_admin_09",
      "review_scs": [
        {
          "item_id": "diff_d3_01",
          "decision": "REJECT",
          "admin_note": "Cần bổ sung năm sinh và văn bản xác nhận của chi họ"
        }
      ],
      "global_admin_note": "Khung cơ bản ổn, làm rõ người con thứ ở Đời 3 rồi nộp lại.",
      "outcome": "NEEDS_REVISION"
    }
  ]
}
```

---

## 3. MÁY TRẠNG THÁI & MA TRẬN CHUYỂN DỊCH (STATE MACHINE)

| Trạng thái nguồn | Hành động | Trạng thái đích | Tác nhân | Điều kiện ràng buộc & Dữ liệu ghi nhận |
| :--- | :--- | :--- | :--- | :--- |
| `DRAFT` | **Trình Khung Lần đầu** | `PENDING` | Founder | • Khóa dòng $k$ là `ASSIGN`<br>• Sinh `init_scs`<br>• Single Active Pipeline check |
| `NEEDS_REVISION` | **Trình lại (Re-submit)** | `PENDING` | Founder | • Tăng `current_attempt`<br>• Sinh `init_scs` mới<br>• Snapshot đồ thị cập nhật |
| `PENDING` | **Trả về sửa** | `NEEDS_REVISION` | Admin | • Tồn tại $\ge 1$ mục `REJECT` trong `review_scs`<br>• Bắt buộc có Bút phê tại mục bị từ chối hoặc Bút phê chung<br>• Lưu vòng vào `review_rounds` |
| `PENDING` | **Phê duyệt Khung** | `UNDER_REVIEW` | Admin | • $100\%$ mục mang trạng thái `ACCEPT`<br>• Bắt buộc nhập số nguyên `granted_generation`<br>• Đóng dấu cờ `plan_ok = true` |
| `PENDING` / `NEEDS_REVISION` | **Bác bỏ vĩnh viễn** | `REJECTED` | Admin | • Vi phạm nghiêm trọng (khai khống, không cứu vãn được)<br>• Bắt buộc có `reject_reason`<br>• Đóng vĩnh viễn lô |
| `PENDING` / `NEEDS_REVISION` | **Rút hồ sơ** | `WITHDRAWN` | Founder | • Founder chủ động hủy bỏ tờ trình khi chưa vào xưởng |

---

## 4. QUY TRÌNH THỰC THI CHI TIẾT THEO VÒNG ĐỜI

```
                  CHỦ TOÀN BỘ CHU TRÌNH TRÌNH - THẨM TRA
  
  [FOUNDER CANVAS]                           [ADMIN REVIEW PORTAL]
        │                                              │
        ├── 1. Trình Khung 5L                          │
        │   (Tạo init_scs, đóng băng DRAFT)            │
        │   ──► status: PENDING ─────────────────────► │
        │                                              ├── 2. Nhận hồ sơ hàng đợi
        │                                              ├── 3. Duyệt từng mục (Itemized Review)
        │                                              │      • Xem xét init_scs
        │                                              │      • Focus Canvas Read-Only
        │                                              │      • Ra quyết định review_scs
        │                                              │
        │                                              ├── 4A. CÓ MỤC TỪ CHỐI (>= 1 REJECT)
        │                                              │   • Bút phê dòng vi phạm
        │                                              │   • Ghi vào review_rounds
        │   ◄── status: NEEDS_REVISION ────────────────┴── • Bấm "Trả về yêu cầu sửa"
        │
        ├── 5. Nhận thông báo & Mở ?draft=<id>
        │   • Canvas hiển thị viền đỏ mục bị từ chối
        │   • Xem tooltip Bút phê của Admin
        │   • Chỉnh sửa đồ thị Canvas
        │
        ├── 6. Bấm "Trình lại Khung 5L"
        │   • current_attempt: 1 ──► 2
        │   • Sinh init_scs mới
        │   ──► status: PENDING ─────────────────────► ├── 7. Nhận hồ sơ Lần 2
        │                                              │   • Mở tab "Đối chiếu vòng trước"
        │                                              │   • Soi các mục đã sửa
        │                                              │
        │                                              └── 4B. 100% MỤC ACCEPT
        │                                                  • Nhập granted_generation
        │   ◄── status: UNDER_REVIEW (plan_ok = true) ─────┴── • Bấm "Phê Duyệt Khung 5L"
        ▼                                              ▼
   [MỞ XƯỞNG THI CÔNG]                            [LƯU HỒ SƠ PHÊ DUYỆT]
```

### Bước 1: Người trình nộp Khung (Submit Event)
1. Kiểm tra Guardrail:
   * Ô dòng $k$ gán đúng Founder (`ASSIGN`).
   * Đơn luồng: Không có hồ sơ nào khác thuộc tập `IN-FLIGHT`.
2. Trích xuất Payload Lớp Đôi:
   * Business Layer: `lines`, `k`, `origin_member_id`, `canvas_delta`.
   * UI Render Layer: `graph_snapshot` (viewport, nodes, edges).
3. Động cơ `diffDraftAgainstInit` tự động sinh `init_scs`.
4. Gọi `createPlan(submitPayload)`:
   * Chuyển trạng thái: `DRAFT` $\to$ `PENDING`.
   * Ghi BPL: `action: 'MFO_PLAN_SUBMITTED'`, `attempt_no: 1`.
   * Ghi Audit Log: `action: 'CAP_NHAT'`.

### Bước 2: Quản trị viên thẩm định trên Admin Portal
1. Admin mở hồ sơ tại `/op/mfo/review/:ticket_id`.
2. Giao diện chia 2 phân vùng tương tác:
   * **Bên trái (40% - Itemized Checklist):**
     * Render toàn bộ các dòng của `init_scs`.
     * Mỗi dòng có toggle: `[✓ Duyệt]` | `[✕ Từ chối]`.
     * Mỗi dòng có ô nhập `admin_note` riêng.
     * Cuối trang: Ô nhập `global_admin_note` và ô nhập `granted_generation`.
   * **Bên phải (60% - Canvas Inspection):**
     * Khôi phục toàn bộ không gian Canvas từ `graph_snapshot` ở chế độ **Read-Only**.
     * **Cơ chế Focus tương tác:** Khi Admin bấm vào bất kỳ dòng nào ở Checklist bên trái, Canvas bên phải tự động `fitBounds` / `focusView` mượt mà tới đúng Node/Cạnh tương ứng.
3. Guardrail nút bấm Admin:
   * Khi chưa tick đủ $100\%$ các mục: Khóa toàn bộ các nút thao tác.
   * Nếu có $\ge 1$ mục `REJECT`:
     * Nút **"Phê Duyệt Khung"** bị KHÓA (`disabled`).
     * Nút **"Trả về yêu cầu sửa"** SÁNG (`enabled`). Bắt buộc có Bút phê tại dòng bị từ chối hoặc Bút phê chung.
   * Nếu $100\%$ mục `ACCEPT`:
     * Nút **"Trả về yêu cầu sửa"** ẩn/mờ.
     * Nút **"Phê Duyệt Khung"** SÁNG (`enabled`), yêu cầu bắt buộc nhập số nguyên hợp lệ vào ô `granted_generation`.

### Bước 3: Xử lý khi Khung bị trả về (`NEEDS_REVISION`)
1. Admin bấm **"Trả về yêu cầu sửa"**:
   * Hệ thống đóng gói `init_scs` và `review_scs` hiện tại vào mảng `review_rounds`.
   * Trạng thái vé chuyển sang: `status = 'NEEDS_REVISION'`.
   * Ghi BPL: `action: 'MFO_PLAN_RETURNED'`.
   * Ghi Audit Log: `action: 'CAP_NHAT'`.
2. Phản hồi phía Founder (`OpMfoPlanPage.jsx`):
   * Founder nhận cảnh báo tại `MyMfoPlans.jsx`, mở lại liên kết `?draft=<id>`.
   * **Trải nghiệm sửa theo bút phê (Feedback-Driven UX):**
     * Node bị từ chối được viền đỏ và nhấp nháy nhẹ.
     * Hover hoặc click vào node mở tooltip hiển thị Bút phê cụ thể của Admin: *"Cần bổ sung năm sinh và chứng thư..."*.
     * Founder thực hiện điều chỉnh trực tiếp trên Canvas.

### Bước 4: Trình lại hồ sơ (Re-submission)
1. Khi Founder sửa xong và bấm **"Trình Khung 5L"** lần nữa:
   * `current_attempt` tăng từ $1 \to 2$.
   * Sinh bản `init_scs` mới phản ánh trạng thái đồ thị mới nhất.
   * Trạng thái vé chuyển ngược lại: `NEEDS_REVISION` $\to$ `PENDING`.
   * Ghi BPL: `action: 'MFO_PLAN_SUBMITTED'`, `attempt_no: 2`.
2. Khi Admin mở lại hồ sơ ở Vòng 2:
   * Hệ thống hiển thị Checklist của Vòng 2.
   * Bổ sung nút **"Xem lịch sử bút phê Vòng 1"** (Đối chiếu chuyển hồi). Admin có thể xem lại chính xác lần trước mình đã yêu cầu những gì để kiểm tra xem Founder đã khắc phục triệt để hay chưa.

### Bước 5: Phê duyệt chính thức (`approvePlan`)
1. Khi tất cả các mục đều được đánh dấu `ACCEPT` và Admin nhập `granted_generation` (ví dụ: `12`):
2. Admin bấm **"Phê Duyệt Khung 5L"**:
   * `status` chuyển thành `UNDER_REVIEW` (theo Doctrine).
   * Cờ `payload.plan_ok = true`.
   * Ghim `payload.granted_generation = 12`.
   * Ghi BPL: `action: 'MFO_PLAN_APPROVE'`, `attempt_no: current_attempt`.
   * Ghi Audit Log: `action: 'CAP_NHAT'`.
3. Hồ sơ chính thức rời khỏi giai đoạn Khung, mở khóa Cửa Xưởng (Workshop) để Founder tiến hành thi công phả hệ.

---

## 5. BỘ QUY CHUẨN AUDIT VÀ NHẬT KÝ BẮT BUỘC

### 5.1. Nhật ký tiến trình nghiệp vụ (`business_process_logs` - BPL)
Mô hình Append-Only, đảm bảo tính truy vết toàn vẹn:

```sql
INSERT INTO business_process_logs (
  process_type,
  action,
  actor,
  ticket_id,
  origin_member_id,
  from_status,
  to_status,
  attempt_no,
  payload_snapshot,
  created_at
) VALUES (
  'MFO_REVIEW',
  'MFO_PLAN_RETURNED', -- 'MFO_PLAN_SUBMITTED' | 'MFO_PLAN_APPROVE' | 'MFO_PLAN_REJECT'
  :admin_user_id,
  :ticket_id,
  :origin_member_id,
  'PENDING',
  'NEEDS_REVISION',
  :current_attempt,
  :review_scs_json,
  NOW()
);
```

### 5.2. Nhật ký kiểm toán CSDL (`audit_logs`)
Tuân thủ nghiêm ngặt chuẩn Enum tiếng Việt không dấu:
* Mọi thao tác chuyển trạng thái trên bảng `proposals` đều ghi nhận `action: 'CAP_NHAT'`.
* Tuyệt đối không dùng `UPDATE`, `EDIT` hay `APPROVE`.

---

## 6. DANH MỤC CÁC TỆP NGUỒN LIÊN QUAN TRỰC TIẾP

1. **Frontend Soạn thảo & Sửa đổi:**
   * `frontend/src/pages/OpMfoPlanPage.jsx` (Gắn kết hàm `handleSubmitPlan`, tái dựng phản hồi bút phê theo Node).
2. **Frontend Quản trị Thẩm định:**
   * `frontend/src/pages/OpMfoReviewPage.jsx` (Giao diện 2 phân vùng: Checklist `review_scs` và Canvas Inspection).
   * `frontend/src/features/mfo/components/MfoReviewChecklist.jsx` (Component bảng kiểm duyệt tương tác).
3. **Backend Service & Routing:**
   * `src/modules/mfo/mfo.service.js` (Triển khai các hàm `submitPlan`, `returnPlanForRevision`, `approvePlan`, `rejectPlan`).
   * `src/modules/mfo/mfo.ledger.js` (Bộ ghi BPL và phát sự kiện Communication Ledger).
   * `src/modules/mfo/mfo.routes.js` (Các endpoint `/api/mfo/plans/:id/submit`, `/approve`, `/return`, `/reject`).