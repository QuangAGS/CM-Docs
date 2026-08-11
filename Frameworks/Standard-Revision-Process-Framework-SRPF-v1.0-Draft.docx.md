**STANDARD REVISION PROCESS FRAMEWORK**

(SRPF) — Version 1.0.0-Draft

| PATH | Doctrines docs/Frameworks/Standard-Revision-Process-Framework-SRPF-v1.0.md |
| :---- | :---- |
| **DATETIME** | 2026-08-11T10:50:00+07:00 |
| **VERSION** | 1.0.0-Draft |
| **STATUS** | Draft – chờ phê duyệt |
| **DESCRIPTION** | Khung tiêu chuẩn cho các Business Process có hỗ trợ vòng revision. Đủ tổng quát để áp dụng cho Onboarding và các tiến trình ngoài Onboarding. |
| **SSOT References** | OP-Boundary-Definition-SSOT-2026-08-09 · HandOver-Register-Process-Closure-2026-08-10 · schema.prisma · CED · Security · Business Ledger · Communication Ledger · Elder Support |
| **Q1/Q2** | Tuân thủ nghiêm ngặt |

# **1\. Mục đích & Phạm vi**

## **1.1 Mục đích**

Cung cấp một khung chuẩn để định nghĩa, vận hành và theo dõi các Business Process có (hoặc không có) vòng revision, đảm bảo nhất quán về Correlation, Business Ledger, Communication, phân quyền và Elder Support.

## **1.2 Phạm vi v1.0**

* Tổng quát, không giới hạn chỉ Onboarding.

* Có thể áp dụng cho Register, Tenant Activate, Member Promote, Family Draft, và các tiến trình tương lai.

## **1.3 Không thuộc phạm vi**

* Logic nghiệp vụ cụ thể của từng process (do Process Definition cung cấp).

* Tạo mới DB models (trừ khi sau này thực sự cần).

# **2\. Định nghĩa thuật ngữ & Acronym (Glossary)**

Phần này giúp người đọc hiểu đúng và dùng đúng context các thuật ngữ trong tài liệu.

| Thuật ngữ / Acronym | Định nghĩa | Ghi chú sử dụng |
| :---- | :---- | :---- |
| **SRPF** | Standard Revision Process Framework | Tên chính thức của khung này |
| **Process Instance** | Một lần thực thi cụ thể của một loại tiến trình nghiệp vụ | Ví dụ: một hồ sơ Register cụ thể, một lần Promote cụ thể |
| **Correlation / C / Correlation\_id** | Định danh duy nhất gắn với một Action nghiệp vụ quan trọng | 1 Action quan trọng \= 1 Correlation |
| **Action** | Hành động được phép thực hiện trong một Process Instance | Submit, Approve, ReturnForRevision… |
| **State / Trạng thái** | Trạng thái hiện tại của Process Instance trong State Machine | DRAFT, SUBMITTED, NEEDS\_REVISION… |
| **Revision Cycle** | Chu kỳ Submit → Return for Revision → Submit lại | Đặc trưng của các process hỗ trợ revision |
| **Context Guard** | Cơ chế kiểm tra điều kiện ngữ cảnh \+ quyền trước khi cho phép thực hiện Action | Có thể dựa trên role (SYSTEM\_ADMIN, CLAN\_ADMIN, MEMBER…), trạng thái tenant, object… |
| **Side-effect** | Thay đổi dữ liệu nghiệp vụ được thực hiện sau khi Action thành công | Ví dụ: đổi members.status, đổi tenant.status |
| **Terminal State** | Trạng thái kết thúc của Process Instance (không còn chuyển tiếp nghiệp vụ thông thường) | APPROVED, REJECTED, CANCELLED, EXPIRED |
| **Business Ledger / BPL** | Sổ cái nghiệp vụ ghi nhận các sự kiện quan trọng của process | Model chính: business\_process\_logs |
| **Communication Ledger** | Cơ chế ghi nhận và điều phối thông báo gắn với Correlation | Hiện ưu tiên dùng Notification Orchestrator |
| **CED** | Centralized Error Doctrine | Mọi lỗi phải đi qua CED |
| **Elder Support** | Doctrine hỗ trợ người cao tuổi (UI \+ Voice) | Bắt buộc với mọi UI thuộc SRPF |
| **Entry Condition** | Điều kiện bắt buộc phải thỏa mãn trước khi Process Instance được phép bắt đầu hoặc nhận Action đầu tiên |  |
| **Process Definition** | Phần khai báo cụ thể của một tiến trình khi đăng ký vào SRPF | Bao gồm states, actions, guards, side-effects… |
| **OPD** | Onboarding Process Doctrine / Diagram | Tài liệu / sơ đồ tham chiếu liên quan đến onboarding |
| **Q1** | Nguyên tắc Bảo toàn (không phá vỡ chức năng đã có) |  |
| **Q2** | Nguyên tắc định dạng tài liệu & code chuẩn |  |

# **3\. Định nghĩa cốt lõi**

* Process Instance: Một lần thực thi cụ thể của một process type.

* Correlation (C): Định danh duy nhất cho một Action nghiệp vụ quan trọng.

* Action: Hành động được phép trong process (Submit, Approve, ReturnForRevision…).

* Revision Cycle: Vòng lặp Submit → Return → Submit lại.

* Context Guard: Cơ chế kiểm tra quyền \+ điều kiện ngữ cảnh trước khi cho phép Action.

* Side-effect: Thay đổi trạng thái dữ liệu nghiệp vụ sau khi Action thành công.

# **4\. Invariants (bắt buộc)**

1. Một Action nghiệp vụ quan trọng \= một Correlation\_id duy nhất.

2. Mọi Correlation phải được ghi vào Business Ledger.

3. Communication (nếu có) phải đi qua Orchestrator và gắn với cùng Correlation.

4. Mọi Process Instance phải có Entry Condition được kiểm tra trước Action đầu tiên.

5. Mọi Process phải khai báo rõ Terminal States.

6. Quyền thực hiện Action phải được kiểm tra bởi Context Guard (có thể là SYSTEM\_ADMIN, CLAN\_ADMIN, MEMBER…).

7. Side-effect chỉ được thực hiện sau khi Action được chấp nhận (trong transaction).

8. Nếu process hỗ trợ revision thì phải cho phép quay lại trạng thái có thể Submit lại.

9. UI của mọi Process thuộc SRPF phải tuân thủ Elder Support (Voice \+ audioHelpButton / voiceHelpButton).

10. Mọi lỗi phải đi qua Centralized Error Doctrine (CED).

# **5\. State Machine chuẩn (Generic)**

Bộ trạng thái ổn định, đủ dùng cho đa số tiến trình có/không có revision. Thuật ngữ generic, không gắn với business\_process\_type.

| State | Loại | Ý nghĩa |
| :---- | :---- | :---- |
| **DRAFT** | Intermediate | Đang soạn thảo, chưa gửi |
| **SUBMITTED** | Intermediate | Đã gửi, chờ xử lý |
| **UNDER\_REVIEW** | Intermediate | Đang thẩm định |
| **NEEDS\_REVISION** | Intermediate | Bị trả về để bổ sung / sửa |
| **APPROVED** | Terminal (Success) | Phê duyệt thành công |
| **REJECTED** | Terminal (Failure) | Từ chối cuối cùng |
| **CANCELLED** | Terminal | Hủy bởi người dùng hoặc hệ thống |
| **EXPIRED** | Terminal | Hết hạn xử lý |

## **5.1 Quy tắc chuyển trạng thái cơ bản**

DRAFT → SUBMITTED (Submit)

SUBMITTED → UNDER\_REVIEW (Start Review)

UNDER\_REVIEW → NEEDS\_REVISION (Return for Revision)

UNDER\_REVIEW → APPROVED (Approve)

UNDER\_REVIEW → REJECTED (Reject)

NEEDS\_REVISION → SUBMITTED (Submit lại)

\* → CANCELLED | EXPIRED (tùy điều kiện)

*Process không hỗ trợ revision có thể bỏ qua NEEDS\_REVISION. Process có thể bắt đầu từ SUBMITTED hoặc UNDER\_REVIEW nếu không cần giai đoạn Draft.*

# **6\. Action chuẩn**

| Action | Mô tả | Thường dẫn đến state |
| :---- | :---- | :---- |
| **CREATE / START** | Khởi tạo Process Instance | DRAFT / SUBMITTED |
| **SAVE\_DRAFT** | Lưu nháp | DRAFT |
| **SUBMIT** | Gửi chính thức | SUBMITTED |
| **START\_REVIEW** | Bắt đầu thẩm định | UNDER\_REVIEW |
| **RETURN\_FOR\_REVISION** | Trả về yêu cầu sửa | NEEDS\_REVISION |
| **APPROVE** | Phê duyệt cuối cùng | APPROVED |
| **REJECT** | Từ chối cuối cùng | REJECTED |
| **CANCEL** | Hủy tiến trình | CANCELLED |
| **WITHDRAW** | Người nộp rút hồ sơ | CANCELLED |

**Mỗi Action quan trọng (SUBMIT, RETURN\_FOR\_REVISION, APPROVE, REJECT…) bắt buộc sinh Correlation mới.**

# **7\. Process Definition Contract**

Mỗi process cụ thể khi đăng ký vào SRPF phải khai báo:

* process\_type (tương ứng hoặc map sang business\_process\_type)

* supported\_states

* supported\_actions \+ transitions

* entry\_condition

* context\_guard (ai được làm action nào)

* profile\_validation\_rules (nếu có)

* side\_effects khi đạt terminal state

* revision\_supported (true/false)

# **8\. Minimum Required Models (Dependencies)**

Framework chỉ được coi là đủ điều kiện vận hành khi hệ thống có tối thiểu các thành phần sau. SRPF không bắt buộc tạo model mới trong v1.0 — chỉ yêu cầu hệ thống đáp ứng được các trách nhiệm.

| Thành phần | Vai trò | Mức độ |
| :---- | :---- | :---- |
| **business\_process\_logs** | Business Ledger gắn Correlation | Bắt buộc |
| **Cơ chế Correlation (correlation\_id)** | Đảm bảo 1 Action \= 1 C | Bắt buộc |
| **Model lưu trạng thái Process Instance** | Lưu State Machine (ví dụ onboarding\_cases hoặc tương đương) | Bắt buộc |
| **Actor / Role context** | Phục vụ Context Guard | Bắt buộc |
| **Notification Orchestrator** | Communication Ledger gắn C | Khuyến nghị mạnh |

# **9\. Integration với các Doctrine**

## **9.1 Security**

* Kiểm tra quyền qua Context Guard.

* Ghi nhận actor \+ correlation trong mọi thao tác.

* Không expose thông tin nhạy cảm trong response lỗi.

## **9.2 Centralized Error Doctrine (CED)**

* Mọi lỗi đi qua createError / createBusinessError.

* CorrelationId bắt buộc.

* Dual-contract nếu cần tương thích FE.

## **9.3 Business Ledger**

* Ghi theo từng Action \+ Correlation.

* Tuân thủ Snapshot Doctrine (target\_name đóng băng tại thời điểm sự kiện).

## **9.4 Communication Ledger**

* Ưu tiên dùng Notification Orchestrator đã UAT của Register Process.

* Truyền correlationId vào orchestrator.

* Orchestrator chịu trách nhiệm persist-first \+ routing \+ delivery placeholder.

## **9.5 Elder Support**

* Chữ lớn, tương phản cao, nút bấm lớn (mobile-first).

* Voice Support: mọi thông báo (chỉ dẫn, cảnh báo, lỗi) phải có khả năng được đọc to.

* Online Help dạng voice: người dùng kích hoạt để hệ thống đọc hướng dẫn bất cứ lúc nào.

* Mỗi Page/Form/Report luôn có audioHelpButton (hướng dẫn tổng quan).

* Các nhóm thông tin có voiceHelpButton riêng.

* Tham khảo trực tiếp pattern trên các Page/Form của Register Process (ElderAssistButton, elder-doctrine feature).

# **10\. Correlation & Observability**

* Sinh Correlation tại thời điểm thực hiện Action quan trọng.

* Gắn với BPL và Communication.

* Có thể đưa vào job/cron để theo dõi dài hạn nếu cần.

* Mô hình: mỗi Action quan trọng \= một C mới (không dùng 1 C cho cả process dài).

# **11\. Extensibility & Versioning**

* Có thể thêm State / Action mới trong phiên bản sau mà không phá vỡ tương thích.

* Process cũ không bắt buộc phải nâng cấp ngay (Q1).

* Versioning của Framework theo semantic (v1.0, v1.1…).

# **12\. Ví dụ ánh xạ (minh họa)**

* Register Process → đã gần với SRPF (nhiều C, có revision).

* Tenant Activate → process gần atomic, revision\_supported \= false.

* Member Promote (OP-A) → sẽ được định nghĩa lại theo SRPF (có revision).

# **13\. Out of Scope & Future**

* Chưa tạo bảng process\_instances tổng quát.

* Chưa chuẩn hóa toàn bộ business\_process\_type hiện có.

* Future: Formal Process Registry, visual state machine, metrics.

*— End of Standard Revision Process Framework (SRPF) v1.0.0-Draft —*

Tài liệu này là Draft. Chỉ trở thành SSOT sau khi được phê duyệt chính thức.