# **ĐẶC TẢ KIẾN TRÚC: CHU TRÌNH TRÌNH ⟷ THẨM TRA KHUNG 5L**

**Mã phân hệ:** MFO Phase 2 (Chuẩn BFA 1.3.1 / Handover Snapshot 2026-10-07)

**Tài liệu tham chiếu:** *BFA-Branch-Family-Doctrine-v1.3.1*, *MFO Phase 1 Handover*, *Itemized Review Protocol*

## **1\. TỔNG QUAN VÀ NGUYÊN TẮC CỐT TỬ**

Chu trình Trình ![][image1] Thẩm tra Khung 5L là cơ chế phối hợp hai chiều (Collaborative Review Loop) giữa **Người trình (Founder/MWL)** và **Quản trị viên (Clan Admin / System Admin)** trước khi lô phả hệ chính thức bước vào giai đoạn thi công (Xưởng).

┌────────────────────────────────────────────────────────────────────────┐  
│                        NGƯỜI TRÌNH (FOUNDER / MWL)                     │  
│  \[Soạn thảo Canvas 5L\] ──► \[Trình Khung 5L\] ──► \[Nhận phản hồi/Sửa\]   │  
└────────────────────────────────────┬───────────────────────────────────┘  
                                     │ (init\_SCS \+ Payload Lớp Đôi)  
                                     ▼  
┌────────────────────────────────────────────────────────────────────────┐  
│                        QUẢN TRỊ VIÊN (ADMIN PORTAL)                    │  
│  \[Soi Checklist review\_SCS\] ──► \[Kiểm tra đối chiếu Canvas Read-Only\]  │  
│                                    │                                   │  
│           ┌────────────────────────┴────────────────────────┐          │  
│           ▼ (Có \>= 1 REJECT)                                ▼ (100% OK)│  
│  \[TRẢ VỀ SỬA: NEEDS\_REVISION\]                  \[PHÊ DUYỆT: PLAN\_OK\]    │  
│           │                                                 │          │  
└───────────┼─────────────────────────────────────────────────┼──────────┘  
            │ (Lưu vào review\_rounds)                         │ (Mở xưởng thi công)  
            ▼                                                 ▼  
    Founder sửa trên Canvas                           Bước vào Giai đoạn Xưởng

### **3 Nguyên tắc bất biến:**

1. **Nguyên tắc "Tất cả hoặc không" (Atomic / All-or-Nothing Approval):**  
   * Một Khung 5L chỉ được phê duyệt khi ![][image2] các đề xuất biến đổi thành phần đều được Admin chấp thuận (ACCEPT).  
   * Chỉ cần ![][image3] đề xuất bị từ chối (REJECT), toàn bộ Khung bị trả về trạng thái NEEDS\_REVISION. Hệ thống cấm duyệt từng phần (Partial Approval) để bảo vệ tính toàn vẹn tham chiếu của đồ thị phả hệ (Graph Referential Integrity).  
2. **Nguyên tắc Đối chiếu Độc lập (Decoupled Summarized Content Submission):**  
   * Người trình nộp kèm bản tóm tắt nguyên thủy: **init\_SCS** (Initial Summarized Content Submission).  
   * Admin thao tác trên bản kiểm tra tương tác: **review\_SCS** (Itemized Review Protocol), ghi nhận quyết định và bút phê cụ thể cho từng mục.  
3. **Nguyên tắc Bất biến Kiểm toán (Audit Immutability & Round Tracking):**  
   * Mỗi chu kỳ Trình ![][image4] Thẩm tra được đánh số thứ tự vòng attempt\_no (đồng bộ với BPL).  
   * Mọi bút phê, quyết định và snapshot của các vòng trước được lưu trữ bất biến trong mảng review\_rounds để phục vụ đối soát, chống chỉnh sửa tùy tiện và giải quyết tranh chấp gia tộc.

## **2\. CẤU TRÚC DỮ LIỆU ĐẶC TẢ**

### **2.1. Bản Tóm Tắt Khung Ban Đầu (init\_scs)**

Được tạo tự động ngay khi Founder bấm **"Trình Khung 5L"** (thông qua engine diffDraftAgainstInit):

\[  
  {  
    "item\_id": "diff\_d1\_01",  
    "depth": 1,  
    "target\_node\_id": "node\_origin\_spouse",  
    "summary\_text": "Gán cụm hôn phối: Nguyễn Văn A & Lê Thị B",  
    "action\_type": "ASSIGN\_UNION"  
  },  
  {  
    "item\_id": "diff\_d3\_01",  
    "depth": 3,  
    "target\_node\_id": "draft-child-1728291000",  
    "summary\_text": "Xin tạo con nháp: Nguyễn Văn D",  
    "action\_type": "DRAFT\_CHILD"  
  },  
  {  
    "item\_id": "diff\_d4\_01",  
    "depth": 4,  
    "target\_node\_id": "anon-empty-4-1728292000",  
    "summary\_text": "Khai khuyết danh (KD) tại Đời 4",  
    "action\_type": "SET\_ANONYMOUS"  
  }  
\]

### **2.2. Bản Thẩm Tra Chi Tiết Của Admin (review\_scs)**

Được Admin biên tập trực tiếp trên Admin Portal trong quá trình soi hồ sơ:

\[  
  {  
    "item\_id": "diff\_d1\_01",  
    "decision": "ACCEPT",  
    "admin\_note": ""  
  },  
  {  
    "item\_id": "diff\_d3\_01",  
    "decision": "REJECT",  
    "admin\_note": "Cần bổ sung năm sinh và văn bản xác nhận của chi họ"  
  },  
  {  
    "item\_id": "diff\_d4\_01",  
    "decision": "ACCEPT",  
    "admin\_note": "Chấp thuận tạm thời khuyết danh đời 4"  
  }  
\]

### **2.3. Lịch Sử Các Vòng Thẩm Tra (review\_rounds)**

Nằm trong proposals.payload, lưu giữ toàn bộ tiến trình lịch sử qua các lần trả về sửa đổi:

{  
  "ticket\_id": "f47ac10b-58cc-4372-a567-0e02b2c3d479",  
  "current\_attempt": 2,  
  "granted\_generation": null,  
    
  "init\_scs": \[ /\* init\_scs của vòng 2 hiện tại \*/ \],  
  "review\_scs": null,

  "review\_rounds": \[  
    {  
      "attempt\_no": 1,  
      "submitted\_at": "2026-10-07T08:00:00.000Z",  
      "requester\_user\_id": "usr\_founder\_01",  
      "init\_scs": \[  
        {  
          "item\_id": "diff\_d3\_01",  
          "depth": 3,  
          "target\_node\_id": "draft-child-1728291000",  
          "summary\_text": "Xin tạo con nháp: Nguyễn Văn D",  
          "action\_type": "DRAFT\_CHILD"  
        }  
      \],  
      "reviewed\_at": "2026-10-07T09:15:00.000Z",  
      "reviewer\_user\_id": "usr\_admin\_09",  
      "review\_scs": \[  
        {  
          "item\_id": "diff\_d3\_01",  
          "decision": "REJECT",  
          "admin\_note": "Cần bổ sung năm sinh và văn bản xác nhận của chi họ"  
        }  
      \],  
      "global\_admin\_note": "Khung cơ bản ổn, làm rõ người con thứ ở Đời 3 rồi nộp lại.",  
      "outcome": "NEEDS\_REVISION"  
    }  
  \]  
}

## **3\. MÁY TRẠNG THÁI & MA TRẬN CHUYỂN DỊCH (STATE MACHINE)**

| Trạng thái nguồn | Hành động | Trạng thái đích | Tác nhân | Điều kiện ràng buộc & Dữ liệu ghi nhận |
| :---- | :---- | :---- | :---- | :---- |
| DRAFT | **Trình Khung Lần đầu** | PENDING | Founder | • Khóa dòng ![][image5] là ASSIGN • Sinh init\_scs • Single Active Pipeline check |
| NEEDS\_REVISION | **Trình lại (Re-submit)** | PENDING | Founder | • Tăng current\_attempt • Sinh init\_scs mới • Snapshot đồ thị cập nhật |
| PENDING | **Trả về sửa** | NEEDS\_REVISION | Admin | • Tồn tại ![][image6] mục REJECT trong review\_scs • Bắt buộc có Bút phê tại mục bị từ chối hoặc Bút phê chung • Lưu vòng vào review\_rounds |
| PENDING | **Phê duyệt Khung** | UNDER\_REVIEW | Admin | • ![][image2] mục mang trạng thái ACCEPT • Bắt buộc nhập số nguyên granted\_generation • Đóng dấu cờ plan\_ok \= true |
| PENDING / NEEDS\_REVISION | **Bác bỏ vĩnh viễn** | REJECTED | Admin | • Vi phạm nghiêm trọng (khai khống, không cứu vãn được) • Bắt buộc có reject\_reason • Đóng vĩnh viễn lô |
| PENDING / NEEDS\_REVISION | **Rút hồ sơ** | WITHDRAWN | Founder | • Founder chủ động hủy bỏ tờ trình khi chưa vào xưởng |

## **4\. QUY TRÌNH THỰC THI CHI TIẾT THEO VÒNG ĐỜI**

                  CHỦ TOÀN BỘ CHU TRÌNH TRÌNH \- THẨM TRA  
    
  \[FOUNDER CANVAS\]                           \[ADMIN REVIEW PORTAL\]  
        │                                              │  
        ├── 1\. Trình Khung 5L                          │  
        │   (Tạo init\_scs, đóng băng DRAFT)            │  
        │   ──► status: PENDING ─────────────────────► │  
        │                                              ├── 2\. Nhận hồ sơ hàng đợi  
        │                                              ├── 3\. Duyệt từng mục (Itemized Review)  
        │                                              │      • Xem xét init\_scs  
        │                                              │      • Focus Canvas Read-Only  
        │                                              │      • Ra quyết định review\_scs  
        │                                              │  
        │                                              ├── 4A. CÓ MỤC TỪ CHỐI (\>= 1 REJECT)  
        │                                              │   • Bút phê dòng vi phạm  
        │                                              │   • Ghi vào review\_rounds  
        │   ◄── status: NEEDS\_REVISION ────────────────┴── • Bấm "Trả về yêu cầu sửa"  
        │  
        ├── 5\. Nhận thông báo & Mở ?draft=\<id\>  
        │   • Canvas hiển thị viền đỏ mục bị từ chối  
        │   • Xem tooltip Bút phê của Admin  
        │   • Chỉnh sửa đồ thị Canvas  
        │  
        ├── 6\. Bấm "Trình lại Khung 5L"  
        │   • current\_attempt: 1 ──► 2  
        │   • Sinh init\_scs mới  
        │   ──► status: PENDING ─────────────────────► ├── 7\. Nhận hồ sơ Lần 2  
        │                                              │   • Mở tab "Đối chiếu vòng trước"  
        │                                              │   • Soi các mục đã sửa  
        │                                              │  
        │                                              └── 4B. 100% MỤC ACCEPT  
        │                                                  • Nhập granted\_generation  
        │   ◄── status: UNDER\_REVIEW (plan\_ok \= true) ─────┴── • Bấm "Phê Duyệt Khung 5L"  
        ▼                                              ▼  
   \[MỞ XƯỞNG THI CÔNG\]                            \[LƯU HỒ SƠ PHÊ DUYỆT\]

### **Bước 1: Người trình nộp Khung (Submit Event)**

1. Kiểm tra Guardrail:  
   * Ô dòng ![][image5] gán đúng Founder (ASSIGN).  
   * Đơn luồng: Không có hồ sơ nào khác thuộc tập IN-FLIGHT.  
2. Trích xuất Payload Lớp Đôi:  
   * Business Layer: lines, k, origin\_member\_id, canvas\_delta.  
   * UI Render Layer: graph\_snapshot (viewport, nodes, edges).  
3. Động cơ diffDraftAgainstInit tự động sinh init\_scs.  
4. Gọi createPlan(submitPayload):  
   * Chuyển trạng thái: DRAFT ![][image4] PENDING.  
   * Ghi BPL: action: 'MFO\_PLAN\_SUBMITTED', attempt\_no: 1\.  
   * Ghi Audit Log: action: 'CAP\_NHAT'.

### **Bước 2: Quản trị viên thẩm định trên Admin Portal**

1. Admin mở hồ sơ tại /op/mfo/review/:ticket\_id.  
2. Giao diện chia 2 phân vùng tương tác:  
   * **Bên trái (40% \- Itemized Checklist):**  
     * Render toàn bộ các dòng của init\_scs.  
     * Mỗi dòng có toggle: \[✓ Duyệt\] | \[✕ Từ chối\].  
     * Mỗi dòng có ô nhập admin\_note riêng.  
     * Cuối trang: Ô nhập global\_admin\_note và ô nhập granted\_generation.  
   * **Bên phải (60% \- Canvas Inspection):**  
     * Khôi phục toàn bộ không gian Canvas từ graph\_snapshot ở chế độ **Read-Only**.  
     * **Cơ chế Focus tương tác:** Khi Admin bấm vào bất kỳ dòng nào ở Checklist bên trái, Canvas bên phải tự động fitBounds / focusView mượt mà tới đúng Node/Cạnh tương ứng.  
3. Guardrail nút bấm Admin:  
   * Khi chưa tick đủ ![][image2] các mục: Khóa toàn bộ các nút thao tác.  
   * Nếu có ![][image6] mục REJECT:  
     * Nút **"Phê Duyệt Khung"** bị KHÓA (disabled).  
     * Nút **"Trả về yêu cầu sửa"** SÁNG (enabled). Bắt buộc có Bút phê tại dòng bị từ chối hoặc Bút phê chung.  
   * Nếu ![][image2] mục ACCEPT:  
     * Nút **"Trả về yêu cầu sửa"** ẩn/mờ.  
     * Nút **"Phê Duyệt Khung"** SÁNG (enabled), yêu cầu bắt buộc nhập số nguyên hợp lệ vào ô granted\_generation.

### **Bước 3: Xử lý khi Khung bị trả về (NEEDS\_REVISION)**

1. Admin bấm **"Trả về yêu cầu sửa"**:  
   * Hệ thống đóng gói init\_scs và review\_scs hiện tại vào mảng review\_rounds.  
   * Trạng thái vé chuyển sang: status \= 'NEEDS\_REVISION'.  
   * Ghi BPL: action: 'MFO\_PLAN\_RETURNED'.  
   * Ghi Audit Log: action: 'CAP\_NHAT'.  
2. Phản hồi phía Founder (OpMfoPlanPage.jsx):  
   * Founder nhận cảnh báo tại MyMfoPlans.jsx, mở lại liên kết ?draft=\<id\>.  
   * **Trải nghiệm sửa theo bút phê (Feedback-Driven UX):**  
     * Node bị từ chối được viền đỏ và nhấp nháy nhẹ.  
     * Hover hoặc click vào node mở tooltip hiển thị Bút phê cụ thể của Admin: *"Cần bổ sung năm sinh và chứng thư..."*.  
     * Founder thực hiện điều chỉnh trực tiếp trên Canvas.

### **Bước 4: Trình lại hồ sơ (Re-submission)**

1. Khi Founder sửa xong và bấm **"Trình Khung 5L"** lần nữa:  
   * current\_attempt tăng từ ![][image7].  
   * Sinh bản init\_scs mới phản ánh trạng thái đồ thị mới nhất.  
   * Trạng thái vé chuyển ngược lại: NEEDS\_REVISION ![][image4] PENDING.  
   * Ghi BPL: action: 'MFO\_PLAN\_SUBMITTED', attempt\_no: 2\.  
2. Khi Admin mở lại hồ sơ ở Vòng 2:  
   * Hệ thống hiển thị Checklist của Vòng 2\.  
   * Bổ sung nút **"Xem lịch sử bút phê Vòng 1"** (Đối chiếu chuyển hồi). Admin có thể xem lại chính xác lần trước mình đã yêu cầu những gì để kiểm tra xem Founder đã khắc phục triệt để hay chưa.

### **Bước 5: Phê duyệt chính thức (approvePlan)**

1. Khi tất cả các mục đều được đánh dấu ACCEPT và Admin nhập granted\_generation (ví dụ: 12):  
2. Admin bấm **"Phê Duyệt Khung 5L"**:  
   * status chuyển thành UNDER\_REVIEW (theo Doctrine).  
   * Cờ payload.plan\_ok \= true.  
   * Ghim payload.granted\_generation \= 12\.  
   * Ghi BPL: action: 'MFO\_PLAN\_APPROVE', attempt\_no: current\_attempt.  
   * Ghi Audit Log: action: 'CAP\_NHAT'.  
3. Hồ sơ chính thức rời khỏi giai đoạn Khung, mở khóa Cửa Xưởng (Workshop) để Founder tiến hành thi công phả hệ.

## **5\. BỘ QUY CHUẨN AUDIT VÀ NHẬT KÝ BẮT BUỘC**

### **5.1. Nhật ký tiến trình nghiệp vụ (business\_process\_logs \- BPL)**

Mô hình Append-Only, đảm bảo tính truy vết toàn vẹn:

INSERT INTO business\_process\_logs (  
  process\_type,  
  action,  
  actor,  
  ticket\_id,  
  origin\_member\_id,  
  from\_status,  
  to\_status,  
  attempt\_no,  
  payload\_snapshot,  
  created\_at  
) VALUES (  
  'MFO\_REVIEW',  
  'MFO\_PLAN\_RETURNED', \-- 'MFO\_PLAN\_SUBMITTED' | 'MFO\_PLAN\_APPROVE' | 'MFO\_PLAN\_REJECT'  
  :admin\_user\_id,  
  :ticket\_id,  
  :origin\_member\_id,  
  'PENDING',  
  'NEEDS\_REVISION',  
  :current\_attempt,  
  :review\_scs\_json,  
  NOW()  
);

### **5.2. Nhật ký kiểm toán CSDL (audit\_logs)**

Tuân thủ nghiêm ngặt chuẩn Enum tiếng Việt không dấu:

* Mọi thao tác chuyển trạng thái trên bảng proposals đều ghi nhận action: 'CAP\_NHAT'.  
* Tuyệt đối không dùng UPDATE, EDIT hay APPROVE.

##   **6\. DANH MỤC CÁC TỆP NGUỒN LIÊN QUAN TRỰC TIẾP**

1. **Frontend Soạn thảo & Sửa đổi:**  
   * frontend/src/pages/OpMfoPlanPage.jsx (Gắn kết hàm handleSubmitPlan, tái dựng phản hồi bút phê theo Node).  
2. **Frontend Quản trị Thẩm định:**  
   * frontend/src/pages/OpMfoReviewPage.jsx (Giao diện 2 phân vùng: Checklist review\_scs và Canvas Inspection).  
   * frontend/src/features/mfo/components/MfoReviewChecklist.jsx (Component bảng kiểm duyệt tương tác).  
3. **Backend Service & Routing:**  
   * src/modules/mfo/mfo.service.js (Triển khai các hàm submitPlan, returnPlanForRevision, approvePlan, rejectPlan).  
   * src/modules/mfo/mfo.ledger.js (Bộ ghi BPL và phát sự kiện Communication Ledger).  
   * src/modules/mfo/mfo.routes.js (Các endpoint /api/mfo/plans/:id/submit, /approve, /return, /reject).

### **TỔNG QUAN KẾ HOẠCH PATCH (PHASE 2\)**

```
┌────────────────────────────────────────────────────────────────────────┐
│ LÁT 1: ĐỒNG NHẤT BỘ SERIALIZER & NÚT TRÌNH KHUNG (FE NGƯỜI TRÌNH)      │
│ • File: frontend/src/pages/OpMfoPlanPage.jsx                           │
│ • Việc làm: Gộp hàm trích xuất payload; sinh init_scs từ diff engine;  │
│             gửi trọn vẹn Payload Lớp Đôi khi bấm "Trình Khung 5L".    │
└───────────────────────────────────┬────────────────────────────────────┘
                                    │
                                    ▼
┌────────────────────────────────────────────────────────────────────────┐
│ LÁT 2: TIẾP NHẬN BẢN TRÌNH & BẢO VỆ ĐƠN LUỒNG (BE SERVICE & LEDGER)    │
│ • File: src/modules/mfo/mfo.service.js, mfo.ledger.js                 │
│ • Việc làm: Nhận ticket_id, thăng cấp DRAFT -> PENDING, lưu init_scs;  │
│             ghi BPL (MFO_PLAN_SUBMITTED) & Audit Log ('CAP_NHAT').     │
└───────────────────────────────────┬────────────────────────────────────┘
                                    │
                                    ▼
┌────────────────────────────────────────────────────────────────────────┐
│ LÁT 3: ENGINE THẨM TRA & API QUẢN TRỊ VIÊN (BE ADMIN REVIEW ENDPOINTS) │
│ • File: src/modules/mfo/mfo.admin.service.js, mfo.routes.js            │
│ • Việc làm: API approvePlan (chốt granted_gen) và returnForRevision    │
│             (lưu review_scs, đẩy vòng cũ vào review_rounds, BPL).      │
└───────────────────────────────────┬────────────────────────────────────┘
                                    │
                                    ▼
┌────────────────────────────────────────────────────────────────────────┐
│ LÁT 4: GIAO DIỆN THẨM ĐỊNH HAI CỘT ADMIN (FE ADMIN REVIEW PORTAL)      │
│ • File: frontend/src/pages/OpMfoReviewPage.jsx                         │
│ • Việc làm: Cột trái Checklist + Bút phê từng mục; Cột phải Canvas     │
│             Read-Only tự pan/zoom; Guardrail nút Phê duyệt / Trả về.   │
└────────────────────────────────────────────────────────────────────────┘
```

### **CHI TIẾT TỪNG LÁT CẮT KỸ THUẬT**

#### **🔹 LÁT 1: Đồng nhất Serializer & Nút "Trình Khung 5L" (Frontend)**

* **File mục tiêu:** frontend/src/pages/OpMfoPlanPage.jsx  
* **Nhiệm vụ cụ thể:**  
  1. Trích xuất logic đóng gói chung thành hàm extractCurrentPayload() (dùng chung cho cả "Lưu nháp" và "Trình khung").  
  2. Bổ sung việc sinh init\_scs tự động (tích hợp diffDraftAgainstInit).  
  3. Viết lại hàm submit() thành handleSubmitPlan(): gửi trọn vẹn Payload Lớp Đôi (lines, canvas\_delta, graph\_snapshot, init\_scs).  
  4. Giữ nguyên các Guardrail chống click đúp (busy) và điều hướng dọn dẹp cache.

#### **🔹 LÁT 2: Tiếp nhận Bản Trình & Ghi Sổ Kiểm toán (Backend Service)**

* **File mục tiêu:** src/modules/mfo/mfo.service.js (và mfo.ledger.js)  
* **Nhiệm vụ cụ thể:**  
  1. Xử lý hàm createPlan: Nếu request mang ticket\_id của bản nháp hiện có, thực hiện chuyển dịch trạng thái DRAFT $\rightarrow$ PENDING.  
  2. Lưu trữ an toàn các trường init\_scs, canvas\_delta, graph\_snapshot vào payload.  
  3. Kiểm tra ràng buộc Single Active Pipeline (chặn nếu user có hồ sơ in-flight khác).  
  4. Ghi BPL: action: 'MFO\_PLAN\_SUBMITTED' kèm correlation\_id và SQL đếm attempt\_no.  
  5. Ghi Audit Log: action \= 'CAP\_NHAT' theo chuẩn tiếng Việt không dấu.

#### **🔹 LÁT 3: Bộ Cửa API Thẩm định Admin & Quản lý Vòng (Backend Endpoints)**

* **File mục tiêu:** src/modules/mfo/mfo.admin.service.js, mfo.routes.js  
* **Nhiệm vụ cụ thể:**  
  1. **Endpoint POST /api/mfo/plans/:id/approve**:  
     * Kiểm tra điều kiện: \$100\\%\$ mục trong review\_scs là ACCEPT \+ bắt buộc có granted\_generation.  
     * Chuyển status sang UNDER\_REVIEW, bật plan\_ok \= true.  
  2. **Endpoint POST /api/mfo/plans/:id/return**:  
     * Kiểm tra điều kiện: Có ít nhất một mục REJECT \+ có bút phê.  
     * Chuyển status sang NEEDS\_REVISION.  
     * Đóng gói init\_scs và review\_scs hiện tại đẩy vào mảng review\_rounds (bảo toàn lịch sử các vòng thẩm định).

#### **🔹 LÁT 4: Màn hình Thẩm định Chi tiết Admin (Admin Review Portal)**

* **File mục tiêu:** frontend/src/pages/OpMfoReviewPage.jsx  
* **Nhiệm vụ cụ thể:**  
  1. Xây dựng bố cục 2 cột (40% Bảng Checklist review\_scs / 60% Canvas Re-hydration Read-Only).  
  2. Mỗi mục thay đổi có toggle \[Chấp thuận / Từ chối\] và ô nhập bút phê riêng.  
  3. Sự kiện click vào dòng checklist sẽ trigger fitBounds hoặc panTo của React Flow tới đúng Node/Edge liên quan.  
  4. Bộ khóa nút bấm: Chỉ khi đã xem xét \$100\\%\$ các mục và không có mục nào bị REJECT thì nút "Phê Duyệt Khung" mới sáng.

[image1]: <data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAADAAAAAfCAYAAACh+E5kAAABPElEQVR4Xu2VvUrEQBSFw4qChY0iCgn5I2wgbVoRfADB1tInWLDwGSwstLS2t7Hfwm6rbSwUsRJsBFtR/PuCWuxh1cSFicj94DJwbu6dM5PJxPMMwzAM45/SUcEVeZ7PqdaYKIq2GaZUdwFzP/q+v6B6bYIgyGjyqrormPuE6KtemziOD2gwVN0VzL/56w1MkmSJ4mOvpePzSZqmXRZyqPq3VEWYvyqKYkZzbYCXJxaxr/pXdCi4peBUE22Blw083TPGmhuB/C4PPlTnjrggzv9Q3ETvvq7V9wjVKnnohdjTXFtkWbaInzOsbZVlOa35sVCwFobhjuqu4Sqfx8eAcVZzP1K9MopXVHcJHo74mQWq14KrdJUGz6q74uObvFS9ERM3mADmvuME9FRvBLuwrJorML+ummEYhmGM4w3goF/PXQPOFgAAAABJRU5ErkJggg==>

[image2]: <data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAADwAAAAfCAYAAAC7xK7qAAADyElEQVR4Xu2XW4hNURjH5xYe3MKEuZ09FyZT5PpAvMyDy4OYSCkexJOQW6IoMURJLkXME8qlKB5MCTVEMSikeNBQKIZyzSWX8fuctfT5Zu99TmOUqf2vr7PW//9fa31r7b32WSsnJ0GCBAn+EVKp1DBiU3l5+QirhQHvImK05bsESPwwcayqqqp3EATbKLeVlJQMtz6HPPQ9RBPlXCtmBRpPs1wYKioq+uDdLE+CGGx1i+Li4hJ8O8rKytYUFhb2tLqgtLR0kkywsrKy1FH51G8TX4gGFqCH91IeBHdL/ES55zMhj4ZzaXCQ32bXuM2aNGRQ52vynEtK2rVbZV7LlPPv9RzlV2HjwH22PE+3H4s0T8r8zkFfSQ7LiZmUnxHntT8WNTU13Vwy74irrtwuEQ0GOoTnbVFR0QDP8bSHwn0loWXam5N+Qi3EFU3SxwIZB/8YzUeNj3+j5QSSB2OXWT5rRA3oIa+j6Lx6Y60GX+cmsVRxjVH9MYndoun9GTU+3u26zv4uxPdCcx1C1IAeaA9FZz/2txpJjXTtGz1H+XtUf/JaiiaL6Dnqj62/urq6F9xizVE/SbzWXIeQxYQjdVkEq9u6Bvwsp7/xHJOfLxz7fqDnWJjLvizg7SrCd1pzHUZcgoI43T2JP3Rb1yDp6WE6E9wF10CxQL4JVqd+Vi/IXyEsAY04nX3V3eq2rsHEpkTp8o2QfYtWq3nq7+BPaA7k8x0YYrjsEJWAR5yuvvhZTZinNDlOD0Eu3uf6+yEfSLin0gcLcVebs0KmBOL0znzCYcC3hDYzDCcfvev81hI3ZX9rPSMyJRCnd9YeDkMqfUZ4qjnaH4c7pTnqb+VIqrlYZEogTpeDiNVtXYOEZzs949+L+OSN8PUgfdr7RtSH+KZqLhZxCQrQnoiuzrpaG+/aX1NcZH8kts4luM1qCgV4btizt98O/K7QPFwrC7lVc7GIS1AQuNMRnU4M0eRMLu1Xe47yHddfgbL+Av4DooWd2jzQNxA/QvjRbqxVhv9ArNdcLFwnkmCe1RxymewlPC9JuK8nqcsN4RNxRJvl/zKVvihc0LxanIWa13Bf/fuBuiFpwN9F36k51+cEzbVDkL5zHmMi51wDiRb4M0H6ojBK+3kilc7z+4PhFqFNroza67Rfe5W+1noulb7lRL5JAvR6xhpneQ/63U+fzZqjzYOckBtbZ0BuQXVukY4Sw6xBw5+HiYvEvlSG+zP6PTuZMOBrJd4H6a32ESrferoESP6RXDktbyEnLLxb3Ou9yeoJEiRIkCDBf4qf02dtsBlQNNAAAAAASUVORK5CYII=>

[image3]: <data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAA0AAAAfCAYAAAA89UfsAAAAjklEQVR4XmNgGAXUB4zy8vI5ioqKbugScKCgoMABVBQtJyc3H0jfAOL/UNyLrhYOgJKSUEVvgHgvUZrQwagmKEDS1IcuhxPANAHjrR9dDieAaQJG+gR0OZwASdNEdDmcAMlPk9HlcAIkTVPQ5XACJE1z0OVQAFDBVGBorQDSh5E0gfy1CogXoqsfBcMUAADjdUUvLuvWRwAAAABJRU5ErkJggg==>

[image4]: <data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAABoAAAAeCAYAAAAy2w7YAAAAn0lEQVR4XmNgGAWjYBSMApoAeXn5HnQxmgCgRS8VFBQ40MWpDuTk5KaDLEMXpzoQFxfnBlp0R0tLiw1djiYAaNkzIL6NLg4HQK+nAhVMogLeDMT/gXg3MM4s0O2hGgA6eAPQkp9ASwTQ5agJWOQhQWeJLkE1APRJHtCC3+jiVAdAS+7J0yPTAi1ZjC5GdSAjI6MCjPxwdPFRMApGAfUBAKdOKTEHhjdRAAAAAElFTkSuQmCC>

[image5]: <data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAA4AAAAgCAYAAAAi7kmXAAABRElEQVR4XmNgGAXEATk5uXZ5efnZCgoKh4D0VXR5nACo+D8yRpfHC4C2aUA1XkOXwwuAGjNBGoHOno4uhw8wAjW9htooiS6JE8jIyOhCNd1El8MLgBrWQTVGoYnPAuITysrKYsjicACUfAPSCLRZGirECPRrPVBsN9DvE4D0HBQNMAC1DRwNWlpabED2XnV1dV4gPQUkDtR8CV0PGMA0Am3kBNLbgQo5oOJ7oXKt6HqQAwZk8kKgEDO6GqwAqCEHphGI/wHxBVFRUR50degAHn9A2yRAAkB2NtSQo+iK4QAYclpQRdeRhEGGgcT+IKkLQ5IHm74UalsETAwUMFCxWyC+rKysFJAdgNDFANb4ENmZSOIgG/eA2EDb2hjQAwyqACMbAcWOQeV+AnEVujzINGugbebo4kDABBIHRpUQusQoGOEAAFmLYX20u1l/AAAAAElFTkSuQmCC>

[image6]: <data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAACgAAAAfCAYAAACVgY94AAABZklEQVR4Xu2VO0sEMRhF10pBsJ1mnIczYCH+A0tF8FELW4iwjRZi6S9QsRR81CqWFoK42Cm6gpUKtnaWgjZiYaFnIAH5UNhkEqscuMyQm9y5TDK7jUYgEAhYk+f5cJZlm3L8V9I07aCLJElmpecKssfRMjrnWZ/oq5Kc9ydMvlKLWmVZ9kq/LuTeqPx7dGxcUBPH8SgLj9ArWpO+C4qiGLQuqGHxDvpAu2zLkPTr4KSghu0eoOCqCmxL3wanBTV8cYsEPqEOhWekb4KXgj8heFo94FR63eC1IKFN9IDueKuT0u8GLwUp04eWqlC2+FL6JjgtSJkNgt4ot8/9iPRtcFKw+mlBe4S8U25L+nWoVZBFZ2obV6Io6pe+C6wKMnkKXaNHys1L3yXGBSl0i8bkuC/4Oy2NCkKPHHAN53iBQgdcT7i+6IKojQ5RU64JOIPXPscZXLfQhMzygjoXzxballmBQOAf+QYkoI8x9T/gtQAAAABJRU5ErkJggg==>

[image7]: <data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAEIAAAAfCAYAAABTRBvBAAACDElEQVR4Xu2Xu0sDQRDGE0VRRLQyYC6XF3IQsJCAloIWKogWVjaCdiIINoIgWgliY2VjIYhFEBS008LKF+g/YJVSCIKinQrRbzEHm4/cubkkXAL7g2GXb252duYe2QQCGo1Go9FUTDQanWCtUUgmkz2xWGzaNM1d1LFkGEY7X+NEEwJnEbSP8QHjjzC+qAEIovgz7H0P4yhqGcf8QKonyAFFpFKp1sLFH7DbRm0ECl/BvvOs2/XAdtjnil+NsCyrk7VykApekHU0aMz2Yb4m+1zxqxHI+QUbYV0VqRFXsh6JRHol343sc8WvRuC93kTeHOuqIH4S8SeJRKJL1uPxuGXXhCfiXPa54lcj8HXvq0VeNGjOrgnzDfY74lcjBKFQqAO578UHnH1ewXr5QhNW2eeKn40QIPcrNn3BukeCnuvxHFgl8Ir0I/8z3uch9pUL1lgUtWA8Zt+/VNIIxGVgT1WwbPRvH++cQxXEvok1WFemsAHvC1RIOp1uKZwQ13Enu9mvQjgcNhD/jfh59injcyOakTuHn0CTHaog/rrUkwTtEXbKuiN+NgJPwjLu4jDrZSAa+YJ10uyA/gnbYt0RqRFN7KslyDkjNsu6KuKMYO/dyXC4GuS4InAXtnFhBotdSoFZcRKDHWI+wDHVBjnuYEesq8JFlzI+ddYl+E8whaa3sa7RaDQajUZTz/wCgvDEMlaLkxcAAAAASUVORK5CYII=>