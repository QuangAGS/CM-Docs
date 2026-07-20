# **EGAL Technical Architecture Handbook V3**

## **Volume 02**

# **EGAL Layering Doctrine**

**PART I — Architectural Philosophy**

---

**Document ID**

EGAL-ARCH-V3-VOL02

**Version**

EGAL-25.2.x

**Status**

Approved Architecture Doctrine

**Classification**

Core Architecture Doctrine

**Depends On**

* Three Ledger Doctrine  
* Prisma Doctrine  
* Transaction Doctrine  
* Snapshot Doctrine  
* Correlation Doctrine  
* Notification Doctrine  
* Onboarding Doctrine

---

# **1\. Introduction**

EGAL là một hệ thống quản lý gia phả, tổ chức dòng họ và các quy trình nghiệp vụ có tính chất dài hạn. Trong suốt vòng đời phát triển, hệ thống liên tục bổ sung các Business Process (BP), mở rộng các module và tăng số lượng lập trình viên tham gia.

Nếu không có một kiến trúc phân tầng rõ ràng, các vấn đề sau sẽ xuất hiện:

* Business Service truy cập trực tiếp cơ sở dữ liệu.  
* Logic nghiệp vụ bị trộn lẫn với Infrastructure.  
* Transaction được khởi tạo ở nhiều nơi khác nhau.  
* Metadata bị định nghĩa không thống nhất.  
* Ledger bị ghi trực tiếp, bỏ qua các quy tắc chuẩn hóa.  
* Kiến trúc dần bị "xói mòn" (Architectural Erosion).

EGAL Layering Doctrine được xây dựng nhằm ngăn chặn các hiện tượng trên và thiết lập một mô hình kiến trúc thống nhất cho toàn bộ Backend.

---

# **2\. Purpose**

Layering Doctrine xác định rõ:

* Mỗi tầng của hệ thống có trách nhiệm gì.  
* Mỗi tầng không được phép làm gì.  
* Luồng phụ thuộc giữa các tầng.  
* Ranh giới giữa Business Logic và Infrastructure.  
* Cách tích hợp Three Ledger Doctrine vào kiến trúc tổng thể.

Doctrine này không mô tả chi tiết từng Business Process.

Doctrine này xác định **kiến trúc** mà mọi Business Process phải tuân thủ.

---

# **3\. Architectural Philosophy**

## **3.1 Separation of Concerns**

Nguyên tắc đầu tiên của EGAL là:

**Mỗi tầng chỉ chịu trách nhiệm cho đúng một loại vấn đề.**

Ví dụ:

Business Layer

* xử lý nghiệp vụ

Ledger Layer

* chuẩn hóa việc ghi lịch sử

Infrastructure Layer

* cung cấp năng lực hạ tầng

Database

* lưu trữ dữ liệu

Không có tầng nào được thực hiện trách nhiệm của tầng khác.

---

## **3.2 Business First**

Business Process là trung tâm của hệ thống.

Infrastructure tồn tại để phục vụ Business.

Infrastructure không được phép quyết định nghiệp vụ.

Ví dụ:

Sai

Infrastructure tự quyết định:

* phê duyệt  
* từ chối  
* merge branch

Đúng

Business Service quyết định.

Infrastructure chỉ thực thi.

---

## **3.3 Stable Infrastructure**

Một Business Process mới **không được phép** yêu cầu thay đổi Infrastructure nếu Infrastructure hiện tại đã đủ năng lực.

Ví dụ:

Một BP mới:

```
Donation Approval
```

không được thêm:

```
prisma.donationApproval()
```

vào Infrastructure.

Thay vào đó Business Service sử dụng các capability đã có:

* withTransaction()  
* businessProcess.create()  
* audit.create()  
* notification.create()

Điều này giúp Infrastructure ổn định trong thời gian dài.

---

## **3.4 Explicit Responsibilities**

Mọi thành phần đều phải có trách nhiệm rõ ràng.

Ví dụ:

Business Logger

chịu trách nhiệm

* validate  
* sanitize  
* build log

Notification Builder

chịu trách nhiệm

* build notification payload

Prisma Infrastructure

chịu trách nhiệm

* transaction  
* persistence  
* execution context

Không thành phần nào được đảm nhận vai trò của thành phần khác.

---

## **3.5 Traceability by Design**

Mọi Business Process phải có khả năng truy vết toàn bộ vòng đời.

Do đó:

* Business Process Ledger  
* Audit Ledger  
* Communication Ledger

được liên kết bằng:

```
correlation_id
```

Mục tiêu:

Một Business Process bất kỳ có thể được truy vết từ đầu đến cuối.

---

## **3.6 History Must Never Change**

Một nguyên tắc cốt lõi của EGAL là:

**Lịch sử không được phép thay đổi.**

Business Log sử dụng Snapshot Doctrine.

Notification lưu trạng thái tại thời điểm phát sinh.

Audit lưu thay đổi tại thời điểm thực hiện.

Không sử dụng JOIN thời gian thực để tái tạo lịch sử.

---

# **4\. Core Design Principles**

EGAL Layering Doctrine dựa trên các nguyên tắc sau.

## **Principle 1**

Business Logic phải độc lập với Persistence.

---

## **Principle 2**

Infrastructure không chứa Business Rule.

---

## **Principle 3**

Ledger phải được chuẩn hóa.

---

## **Principle 4**

Metadata phải được kiểm soát bằng Schema Contract.

---

## **Principle 5**

Transaction phải có một điểm bắt đầu duy nhất.

---

## **Principle 6**

Correlation phải xuyên suốt toàn bộ Business Process.

---

## **Principle 7**

Mọi Business Process đều phải có khả năng Audit.

---

## **Principle 8**

Communication là một Ledger độc lập.

---

# **5\. Relationship with Existing Doctrines**

Layering Doctrine không thay thế các doctrine hiện có.

Layering Doctrine là "khung kiến trúc" để các doctrine khác hoạt động cùng nhau.

Ví dụ:

Three Ledger Doctrine

quy định

Ba Ledger tồn tại.

Layering Doctrine

quy định

Ledger nằm ở tầng nào.

Prisma Doctrine

quy định

Cách truy cập Prisma.

Layering Doctrine

quy định

Ai được phép sử dụng Prisma.

Snapshot Doctrine

quy định

Cách lưu dữ liệu lịch sử.

Layering Doctrine

quy định

Snapshot được áp dụng ở tầng nào.

---

# **6\. Scope**

Doctrine này áp dụng cho toàn bộ Backend của EGAL.

Bao gồm:

* User Management  
* Member Management  
* Branch Management  
* Onboarding  
* Approval Workflow  
* Notification  
* Audit  
* Business Process Logging  
* Các Business Process được bổ sung trong tương lai.

---

# **7\. Non-Goals**

Doctrine này **không** quy định:

* Thiết kế Database Schema.  
* Thiết kế API.  
* Thiết kế UI.  
* Thiết kế Frontend.  
* Thiết kế Business Rule cụ thể.

Những nội dung trên thuộc các doctrine khác.

---

# **8\. Expected Benefits**

Việc áp dụng Layering Doctrine mang lại các lợi ích sau:

* Giảm sự phụ thuộc giữa Business và Infrastructure.  
* Hạn chế Architectural Erosion.  
* Chuẩn hóa cách phát triển Business Process mới.  
* Giảm Technical Debt.  
* Tăng khả năng Review Source Code.  
* Đơn giản hóa việc Onboarding lập trình viên mới.  
* Tăng khả năng bảo trì dài hạn.  
* Tạo nền tảng ổn định cho các phiên bản EGAL tiếp theo.

---

# **9\. Conformance Statement**

Mọi module mới được bổ sung vào Backend EGAL SHALL tuân thủ Layering Doctrine.

Các module hiện có SHOULD được refactor dần để đạt Compliance.

Không được bổ sung tính năng mới bằng cách phá vỡ ranh giới giữa các tầng đã được định nghĩa trong doctrine này.

---

**End of PART I**

# **PART II — Layer Model**

---

# **1\. Purpose**

**Layer Model xác định cấu trúc phân tầng chuẩn của toàn bộ Backend EGAL.**

**Mục tiêu của Layer Model không phải là chia source code thành nhiều thư mục, mà là xác định trách nhiệm (Responsibility) và ranh giới phụ thuộc (Dependency Boundary) giữa các thành phần của hệ thống.**

**Mọi module mới của EGAL SHALL được phát triển theo mô hình này.**

---

# **2\. Architectural Layer Stack**

**Kiến trúc chuẩn của Backend EGAL được định nghĩa như sau:**

```
                +--------------------------------+
                |        Business Layer          |
                +--------------------------------+
                           │
                           ▼
                +--------------------------------+
                |         Ledger Layer           |
                +--------------------------------+
                           │
                           ▼
                +--------------------------------+
                |   Prisma Infrastructure Layer  |
                +--------------------------------+
                           │
                           ▼
                +--------------------------------+
                |      PostgreSQL Database       |
                +--------------------------------+
```

**Mỗi tầng chỉ được phép giao tiếp với tầng ngay bên dưới.**

**Không được bỏ qua một tầng trung gian.**

---

# **3\. Business Layer**

## **3.1 Mission**

**Business Layer là nơi hiện thực hóa toàn bộ nghiệp vụ của hệ thống.**

**Ví dụ:**

* **User Approval**  
* **User Rejection**  
* **Onboarding**  
* **Branch Merge**  
* **Member Activation**  
* **Password Reset**  
* **Donation**  
* **Grave Management**  
* **Future Business Processes**

**Business Layer là nơi duy nhất được phép quyết định:**

* **Quy trình nghiệp vụ.**  
* **Điều kiện nghiệp vụ.**  
* **Luồng xử lý.**  
* **Chính sách nghiệp vụ.**

---

## **3.2 Responsibilities**

**Business Layer SHALL:**

* **Điều phối Business Workflow.**  
* **Kiểm tra Business Rule.**  
* **Gọi Ledger Layer khi cần ghi nhận lịch sử.**  
* **Gọi Infrastructure Layer thông qua các API chuẩn.**

**Business Layer SHALL NOT:**

* **Truy cập Prisma Delegate trực tiếp.**  
* **Ghi Business Process Log trực tiếp.**  
* **Ghi Audit trực tiếp.**  
* **Ghi Notification trực tiếp.**  
* **Tự tạo Transaction.**  
* **Tự tạo Execution Context.**

---

## **3.3 Examples**

**Ví dụ:**

```
UserApprovalService

OnboardingService

BranchMergeService

MemberService

DonationService
```

**Đây đều là Business Service.**

---

# **4\. Ledger Layer**

## **4.1 Mission**

**Ledger Layer chịu trách nhiệm chuẩn hóa toàn bộ dữ liệu được ghi vào các Ledger.**

**Ledger Layer là "cổng kiểm soát" trước khi dữ liệu được lưu xuống Database.**

**Ledger Layer không quyết định nghiệp vụ.**

**Ledger Layer chỉ chuẩn hóa dữ liệu.**

---

## **4.2 Responsibilities**

**Ledger Layer SHALL:**

* **Validate dữ liệu.**  
* **Sanitize Metadata.**  
* **Chuẩn hóa Snapshot.**  
* **Chuẩn hóa Correlation.**  
* **Chuẩn hóa Notification Payload.**  
* **Chuẩn hóa Audit Payload.**

**Ledger Layer SHALL NOT:**

* **Quyết định Business Rule.**  
* **Quyết định Workflow.**  
* **Điều phối Business Process.**

---

## **4.3 Components**

**Ví dụ:**

```
Business Logger

Audit Logger

Notification Builder

Notification Service
```

**Đây là các thành phần thuộc Ledger Layer.**

---

# **5\. Prisma Infrastructure Layer**

## **5.1 Mission**

**Prisma Infrastructure Layer cung cấp các năng lực hạ tầng (Infrastructure Capabilities) để Business Layer và Ledger Layer sử dụng.**

**Đây không phải Business Layer.**

**Đây không phải Repository Layer truyền thống.**

**Đây là Infrastructure Layer.**

---

## **5.2 Responsibilities**

**Infrastructure SHALL:**

* **Quản lý Transaction.**  
* **Quản lý Execution Context.**  
* **Quản lý Tenant Scope.**  
* **Cung cấp các Infrastructure Primitive.**  
* **Thực hiện Persistence.**

**Infrastructure SHALL NOT:**

* **Chứa Business Rule.**  
* **Chứa Workflow.**  
* **Chứa Validation nghiệp vụ.**  
* **Chứa Logic Approval.**  
* **Chứa Logic Onboarding.**

---

## **5.3 Stable Infrastructure API**

**Ví dụ:**

```
withTransaction()

createExecutionContext()

tenant.scope()

businessProcess.create()

audit.create()

notification.create()

notification.createRecipient()

notification.createDelivery()
```

**Đây là các Infrastructure Capability.**

**Business Layer chỉ được sử dụng các Capability này.**

**Business Layer không được gọi Prisma Delegate trực tiếp.**

---

# **6\. Database Layer**

**Database chỉ chịu trách nhiệm lưu trữ dữ liệu.**

**Database không chứa Business Rule.**

**Database không quyết định Workflow.**

**Database không biết Business Process.**

**Các bảng:**

```
users

members

branches

onboarding_cases

business_process_logs

audit_logs

notifications

notification_recipients

notification_deliveries
```

**đều thuộc Database Layer.**

---

# **7\. Layer Interaction**

**Luồng chuẩn của một Business Process:**

```
Business Service
        │
        ▼
Ledger Layer
        │
        ▼
Prisma Infrastructure
        │
        ▼
PostgreSQL
```

**Ví dụ:**

```
Approve User
      │
      ▼
Business Logger
      │
      ▼
Prisma.businessProcess.create()
      │
      ▼
business_process_logs
```

**Notification cũng đi theo nguyên tắc tương tự:**

```
Business Service
      │
      ▼
Notification Builder
      │
      ▼
Notification Service
      │
      ▼
Prisma.notification.create()
      │
      ▼
notifications
```

---

# **8\. Dependency Rules**

**Quan hệ phụ thuộc được định nghĩa như sau:**

```
Business Layer
      │
      ▼
Ledger Layer
      │
      ▼
Prisma Infrastructure
      │
      ▼
Database
```

**Không được phép:**

```
Business Layer
      │
      ▼
Database
```

**Không được phép:**

```
Business Layer
      │
      ▼
Prisma Delegate
```

**Không được phép:**

```
Ledger Layer
      │
      ▼
Business Service
```

**Dependency luôn đi theo một chiều từ trên xuống dưới.**

---

# **9\. Layer Isolation**

**Mỗi Layer có thể được thay thế mà không làm thay đổi trách nhiệm của Layer khác.**

**Ví dụ:**

**Nếu Prisma được thay bằng một ORM khác trong tương lai:**

```
Prisma
↓
Drizzle ORM
```

**Business Layer không cần thay đổi.**

**Ledger Layer không cần thay đổi.**

**Chỉ Infrastructure Layer được điều chỉnh.**

**Đây là mục tiêu của Layer Isolation.**

---

# **10\. Layer Evolution**

**Business Layer sẽ thay đổi thường xuyên.**

**Ledger Layer thay đổi ít hơn.**

**Infrastructure Layer thay đổi rất hiếm.**

**Database Schema thay đổi theo Migration Doctrine.**

**Do đó:**

* **Business Layer có tốc độ phát triển cao nhất.**  
* **Ledger Layer có tốc độ phát triển trung bình.**  
* **Infrastructure Layer phải giữ ổn định lâu dài.**

---

# **11\. Layer Ownership**

**Để tránh chồng chéo trách nhiệm, mỗi Layer có một phạm vi sở hữu riêng.**

| Layer | Owns |
| ----- | ----- |
| **Business Layer** | **Business Rule, Workflow** |
| **Ledger Layer** | **Business History, Audit, Communication** |
| **Infrastructure Layer** | **Transaction, Context, Tenant, Persistence Primitive** |
| **Database** | **Persistent Storage** |

**Không Layer nào được mở rộng phạm vi sở hữu sang Layer khác.**

---

# **12\. Conformance Statement**

**Mọi Business Process mới SHALL được triển khai theo Layer Model này.**

**Không được triển khai Business Logic bằng cách bỏ qua Ledger Layer hoặc Prisma Infrastructure Layer.**

**Mọi exception MUST được xem xét và phê duyệt ở mức Architecture Doctrine.**

---

**End of PART II**

# **PART III — Responsibility Matrix**

---

# **1\. Purpose**

**Layer Model (PART II) định nghĩa cấu trúc phân tầng của Backend EGAL.**

**PART III định nghĩa:**

**Trách nhiệm (Responsibilities), Quyền hạn (Authorities), Nghĩa vụ (Obligations) và Điều cấm (Prohibitions) của từng Layer.**

**Mục tiêu là bảo đảm:**

* **Không có Business Logic nằm trong Infrastructure.**  
* **Không có Infrastructure Logic nằm trong Business.**  
* **Không có Ledger Logic bị phân tán.**  
* **Không có thành phần nào chịu trách nhiệm thay cho thành phần khác.**

**Responsibility Matrix là tiêu chuẩn chính thức dùng trong Code Review, Architecture Review và Compliance Review.**

---

# **2\. Responsibility Matrix**

| Layer | Primary Responsibility | MUST | MUST NOT |
| ----- | ----- | ----- | ----- |
| **Business Layer** | **Business Workflow** | **Điều phối nghiệp vụ** | **Ghi DB trực tiếp** |
| **Ledger Layer** | **Chuẩn hóa Ledger** | **Validate, Sanitize, Snapshot** | **Quyết định Business Rule** |
| **Prisma Infrastructure** | **Infrastructure Capability** | **Transaction, Context, Persistence Primitive** | **Chứa Workflow** |
| **Database** | **Persistent Storage** | **Lưu trữ dữ liệu** | **Chứa Application Logic** |

**Mỗi Layer chỉ có một trách nhiệm chính (Single Primary Responsibility).**

---

# **3\. Business Layer**

## **3.1 Responsibilities**

**Business Layer SHALL chịu trách nhiệm:**

* **Điều phối Business Workflow.**  
* **Áp dụng Business Rule.**  
* **Quyết định hướng xử lý.**  
* **Gọi Ledger Layer.**  
* **Kết hợp nhiều Aggregate.**  
* **Xử lý lỗi nghiệp vụ.**

**Ví dụ:**

```
UserApprovalService

OnboardingService

BranchMergeService

DonationService

MemberActivationService
```

---

## **3.2 Business Layer MUST NOT**

**Business Layer SHALL NOT:**

* **Gọi Prisma Delegate.**  
* **Ghi Notification trực tiếp.**  
* **Ghi Business Process Log trực tiếp.**  
* **Ghi Audit trực tiếp.**  
* **Tự build Metadata.**  
* **Tự tạo Transaction.**  
* **Tự tạo Execution Context.**  
* **Tự chuẩn hóa Snapshot.**

**Business Layer chỉ mô tả:**

**"Điều gì cần xảy ra."**

**Business Layer không mô tả:**

**"Dữ liệu được ghi như thế nào."**

---

## **3.3 Ownership**

**Business Layer sở hữu:**

* **Business Rule**  
* **Workflow**  
* **Aggregate Coordination**  
* **Domain Decision**

**Business Layer không sở hữu:**

* **Persistence**  
* **Metadata Contract**  
* **Notification Payload**  
* **Audit Format**

---

# **4\. Ledger Layer**

## **4.1 Responsibilities**

**Ledger Layer SHALL chịu trách nhiệm:**

* **Validate dữ liệu.**  
* **Sanitize Metadata.**  
* **Chuẩn hóa Payload.**  
* **Chuẩn hóa Snapshot.**  
* **Chuẩn hóa Audit.**  
* **Chuẩn hóa Notification.**  
* **Chuẩn hóa Correlation.**

**Ledger Layer đảm bảo dữ liệu trước khi chạm Database.**

---

## **4.2 Ledger Layer MUST NOT**

**Ledger Layer SHALL NOT:**

* **Quyết định nghiệp vụ.**  
* **Quyết định Approval.**  
* **Quyết định Reject.**  
* **Quyết định Merge.**  
* **Quyết định Workflow.**  
* **Điều phối Aggregate.**

**Ledger Layer chỉ chuẩn hóa dữ liệu.**

---

## **4.3 Ownership**

**Ledger Layer sở hữu:**

* **Business Process Ledger**  
* **Audit Ledger**  
* **Communication Ledger**  
* **Schema Contract**  
* **Metadata Validation**  
* **Snapshot Standardization**

---

# **5\. Prisma Infrastructure Layer**

## **5.1 Responsibilities**

**Infrastructure Layer SHALL:**

* **Quản lý Transaction.**  
* **Quản lý Execution Context.**  
* **Quản lý Tenant Scope.**  
* **Quản lý Persistence Primitive.**  
* **Cung cấp Infrastructure API.**  
* **Thực hiện Persistence.**

**Infrastructure Layer là điểm truy cập duy nhất tới ORM.**

---

## **5.2 Infrastructure MUST NOT**

**Infrastructure SHALL NOT:**

* **Biết Approval là gì.**  
* **Biết Onboarding là gì.**  
* **Biết Donation là gì.**  
* **Biết Business Workflow.**  
* **Biết Domain Policy.**

**Infrastructure chỉ biết:**

* **Transaction**  
* **Persistence**  
* **Context**  
* **Tenant**  
* **Correlation**

---

## **5.3 Ownership**

**Infrastructure sở hữu:**

* **withTransaction()**  
* **createExecutionContext()**  
* **tenant.scope()**  
* **businessProcess.create()**  
* **audit.create()**  
* **notification.create()**  
* **notification.createRecipient()**  
* **notification.createDelivery()**

**Đây được gọi là Infrastructure Capabilities.**

---

# **6\. Database Layer**

## **Responsibilities**

**Database SHALL:**

* **Lưu trữ dữ liệu.**  
* **Thực thi Constraint.**  
* **Thực thi Index.**  
* **Thực thi Foreign Key.**  
* **Thực thi Trigger (nếu có).**

**Database không chịu trách nhiệm:**

* **Workflow.**  
* **Business Rule.**  
* **Approval.**  
* **Notification Logic.**  
* **Validation nghiệp vụ.**

---

# **7\. Cross-Layer Responsibilities**

**Một Business Process hoàn chỉnh được chia trách nhiệm như sau:**

| Step | Responsible Layer |
| ----- | ----- |
| **Kiểm tra điều kiện nghiệp vụ** | **Business Layer** |
| **Chuẩn hóa Business Log** | **Ledger Layer** |
| **Chuẩn hóa Notification** | **Ledger Layer** |
| **Chuẩn hóa Audit** | **Ledger Layer** |
| **Transaction** | **Infrastructure** |
| **Persistence** | **Infrastructure** |
| **Storage** | **Database** |

**Không có bước nào được giao cho nhiều Layer cùng chịu trách nhiệm.**

---

# **8\. Responsibility Ownership Principle**

**EGAL áp dụng nguyên tắc:**

**Một trách nhiệm chỉ có một chủ sở hữu (Single Ownership).**

**Ví dụ:**

**Validation nghiệp vụ**

**→ Business Layer**

**Validation Metadata**

**→ Ledger Layer**

**Transaction**

**→ Infrastructure Layer**

**Persistence**

**→ Infrastructure Layer**

**Storage**

**→ Database**

**Không được trùng lặp Ownership.**

---

# **9\. Responsibility Transfer**

**Layer trên chỉ được phép ủy quyền (Delegate) cho Layer dưới.**

**Ví dụ:**

```
Business Service
        │
        ▼
Business Logger
        │
        ▼
Prisma Infrastructure
        │
        ▼
Database
```

**Business Layer không được bỏ qua Ledger Layer.**

**Ledger Layer không được bỏ qua Infrastructure Layer.**

---

# **10\. Responsibility Violations**

**Các ví dụ sau đây được coi là vi phạm kiến trúc.**

---

## **Violation A**

```
Business Service
↓
Prisma.user.create()
```

**Sai.**

**Business Layer không được gọi Prisma Delegate.**

---

## **Violation B**

```
Business Service
↓
notifications.create()
```

**Sai.**

**Business Layer phải đi qua Notification Builder và Notification Service.**

---

## **Violation C**

```
Infrastructure
↓
Approval Logic
```

**Sai.**

**Infrastructure không được chứa Business Rule.**

---

## **Violation D**

```
Ledger
↓
Merge Branch
```

**Sai.**

**Ledger không được quyết định Workflow.**

---

## **Violation E**

```
Business Service
↓
business_process_logs.create()
```

**Sai.**

**Business Process Log phải đi qua Business Logger.**

---

# **11\. Responsibility Escalation Rule**

**Nếu một chức năng bắt đầu thực hiện trách nhiệm của Layer khác thì:**

* **SHALL được Architecture Review.**  
* **SHALL được refactor.**  
* **SHALL không được mở rộng thêm.**

**Mục tiêu là ngăn Architectural Erosion.**

---

# **12\. Compliance Checklist**

**Một module đạt Responsibility Compliance khi:**

**✓ Không truy cập Prisma Delegate trực tiếp.**

**✓ Không ghi Ledger trực tiếp.**

**✓ Không chứa Business Rule trong Infrastructure.**

**✓ Không chứa Workflow trong Ledger.**

**✓ Không chứa Persistence trong Business Layer.**

**✓ Tuân thủ Single Ownership Principle.**

---

# **13\. Conformance Statement**

**Responsibility Matrix là chuẩn phân định trách nhiệm chính thức của Backend EGAL.**

**Mọi module mới SHALL tuân thủ ma trận này.**

**Mọi Architecture Review SHALL sử dụng Responsibility Matrix như tiêu chí đánh giá đầu tiên trước khi xem xét chất lượng source code.**

---

**End of PART III**

# 

# **PART IV — Dependency Rules**

---

# **1\. Purpose**

**PART II định nghĩa Layer Model.**

**PART III định nghĩa Responsibility Matrix.**

**PART IV định nghĩa:**

**Dependency Rules**

**Nói cách khác:**

**Layer nào được phép phụ thuộc Layer nào.**

**Đây là doctrine nhằm bảo đảm:**

* **Không xảy ra Circular Dependency.**  
* **Không xuất hiện Business Logic trong Infrastructure.**  
* **Không xuất hiện Infrastructure Logic trong Business.**  
* **Không phát sinh Architectural Erosion khi hệ thống mở rộng.**

---

# **2\. Fundamental Principle**

**EGAL sử dụng nguyên tắc:**

**Dependency luôn đi theo một chiều từ trên xuống dưới.**

**Kiến trúc chuẩn:**

```
Business Layer
        │
        ▼
Ledger Layer
        │
        ▼
Prisma Infrastructure Layer
        │
        ▼
Database
```

**Không được phép đảo chiều.**

---

# **3\. Layer Dependency Graph**

**Quan hệ phụ thuộc chính thức của Backend EGAL:**

```
                +------------------------+
                |   Business Layer       |
                +------------------------+
                          │
                          ▼
                +------------------------+
                |    Ledger Layer        |
                +------------------------+
                          │
                          ▼
                +------------------------+
                | Prisma Infrastructure  |
                +------------------------+
                          │
                          ▼
                +------------------------+
                | PostgreSQL Database    |
                +------------------------+
```

**Dependency SHALL luôn đi xuống.**

---

# **4\. Business Layer Dependencies**

**Business Layer được phép phụ thuộc:**

**✓ Ledger Layer**

**✓ Domain Model**

**✓ DTO**

**✓ Validator**

**✓ Configuration**

**Business Layer không được phụ thuộc:**

**✗ Prisma Delegate**

**✗ Database Driver**

**✗ SQL**

**✗ PostgreSQL**

**✗ ORM Internal**

**Ví dụ đúng:**

```
UserApprovalService
        │
        ▼
Business Logger
```

**Ví dụ sai:**

```
UserApprovalService
        │
        ▼
prisma.users.update()
```

---

# **5\. Ledger Layer Dependencies**

**Ledger Layer được phép phụ thuộc:**

**✓ Prisma Infrastructure**

**✓ Schema Contract**

**✓ Utility**

**✓ Metadata Contract**

**Ledger Layer không được phụ thuộc:**

**✗ Business Service**

**✗ Workflow**

**✗ Aggregate Logic**

**✗ UI**

**Ví dụ:**

```
Business Logger
        │
        ▼
Prisma.businessProcess.create()
```

**Đúng.**

---

# **6\. Infrastructure Dependencies**

**Infrastructure được phép phụ thuộc:**

**✓ Prisma Client**

**✓ PostgreSQL**

**✓ Utility**

**✓ Execution Context**

**✓ Tenant Scope**

**Infrastructure không được phụ thuộc:**

**✗ Business Service**

**✗ Notification Builder**

**✗ Business Logger**

**✗ Approval Logic**

**Infrastructure không được biết:**

* **Approval**  
* **Reject**  
* **Merge**  
* **Donation**  
* **Onboarding**

**Infrastructure chỉ biết:**

* **Persistence**  
* **Transaction**  
* **Context**  
* **Tenant**  
* **Correlation**

---

# **7\. Database Dependencies**

**Database không phụ thuộc bất kỳ Layer nào.**

**Database là Layer thấp nhất.**

**Các Constraint:**

* **Primary Key**  
* **Foreign Key**  
* **Index**  
* **Trigger**  
* **Check Constraint**

**thuộc Database.**

**Business Rule không thuộc Database.**

---

# **8\. One-Way Dependency Rule**

**EGAL áp dụng nguyên tắc:**

**Dependency SHALL luôn một chiều.**

**Ví dụ:**

```
Business
    │
    ▼
Ledger
```

**Được.**

**Ngược lại:**

```
Ledger
    │
    ▼
Business
```

**Không được.**

---

# **9\. No Circular Dependency**

**Circular Dependency bị cấm tuyệt đối.**

**Ví dụ:**

```
Business
      │
      ▼
Ledger
      │
      ▼
Infrastructure
      │
      └──────────────┐
                     │
                     ▼
                 Business
```

**Sai.**

**Dependency Cycle SHALL NOT tồn tại.**

---

# **10\. Dependency Inversion**

**Infrastructure không điều khiển Business.**

**Business điều khiển Infrastructure.**

**Ví dụ:**

**Đúng:**

```
Business

↓

Infrastructure
```

**Sai:**

```
Infrastructure

↓

Business
```

**Infrastructure không được callback vào Business Logic.**

---

# **11\. Service Dependency Rules**

**Business Service được phép gọi:**

**✓ Business Logger**

**✓ Notification Service**

**✓ Audit Service**

**✓ Repository (nếu có)**

**Business Service không được gọi:**

**✗ Prisma Delegate**

**✗ SQL**

**✗ Database Connection**

---

# **12\. Repository Dependency Rules**

**Nếu hệ thống sử dụng Repository Pattern:**

**Repository SHALL:**

* **phụ thuộc Infrastructure**

**Repository SHALL NOT:**

* **phụ thuộc Business Service**

**Repository SHALL NOT:**

* **chứa Business Rule**

**Repository là tầng chuyển tiếp giữa Business và Infrastructure.**

---

# **13\. Schema Dependency Rules**

**BusinessLogSchemas**

**NotificationMetadataSchemas**

**được phép phụ thuộc:**

**✓ Utility**

**✓ Validation**

**Không được phụ thuộc:**

**✗ Business Service**

**✗ Database**

**✗ Prisma Delegate**

**Schema Contract phải hoàn toàn thuần dữ liệu (Pure Data Contract).**

---

# **14\. Execution Context Dependency**

**Execution Context được tạo tại:**

```
withTransaction()
```

**Sau khi được tạo:**

```
Business Layer
        │
        ▼
Ledger Layer
        │
        ▼
Infrastructure
```

**đều sử dụng cùng một Context.**

**Không Layer nào được tự tạo Context thứ hai.**

---

# **15\. Correlation Dependency**

**Một Business Process SHALL chỉ có:**

**Một**

```
correlation_id
```

**Correlation được truyền xuyên suốt:**

```
Business Service

↓

Business Logger

↓

Audit

↓

Notification

↓

Database
```

**Không được sinh Correlation mới giữa chừng.**

---

# **16\. Dependency Anti-Patterns**

## **Anti-pattern A**

```
Business

↓

Prisma Delegate
```

**Sai.**

---

## **Anti-pattern B**

```
Business

↓

SQL
```

**Sai.**

---

## **Anti-pattern C**

```
Infrastructure

↓

Business Rule
```

**Sai.**

---

## **Anti-pattern D**

```
Notification Builder

↓

Business Service
```

**Sai.**

---

## **Anti-pattern E**

```
Business Logger

↓

Approval Service
```

**Sai.**

**Ledger Layer không được gọi ngược Business.**

---

# **17\. Architectural Boundary**

**Boundary chính thức:**

```
Business
────────────────────────────
Ledger
────────────────────────────
Infrastructure
────────────────────────────
Database
```

**Không được viết code vượt Boundary.**

**Nếu cần vượt Boundary:**

**SHALL được Architecture Review.**

---

# **18\. Future Evolution**

**Khi Business Process mới xuất hiện:**

**Ví dụ:**

```
Donation

Grave Management

DNA Verification

AI Genealogy
```

**Business Layer được mở rộng.**

**Ledger Layer gần như không đổi.**

**Infrastructure gần như không đổi.**

**Đây là mục tiêu của Layering Doctrine.**

---

# **19\. Compliance Checklist**

**Một module đạt Dependency Compliance khi:**

**✓ Không có Circular Dependency.**

**✓ Business không gọi Prisma Delegate.**

**✓ Ledger không gọi Business.**

**✓ Infrastructure không biết Business Rule.**

**✓ Database không chứa Workflow.**

**✓ Dependency chỉ đi theo một chiều.**

---

# **20\. Conformance Statement**

**Dependency Rules là chuẩn chính thức để đánh giá mọi quan hệ phụ thuộc trong Backend EGAL.**

**Mọi module mới SHALL tuân thủ các quy tắc của PART IV.**

**Mọi Architecture Review SHALL kiểm tra Dependency Rules trước khi đánh giá chi tiết implementation.**

---

**End of PART IV**

# **PART V — Three Ledger Integration**

---

# **1\. Purpose**

**Three Ledger Doctrine đã được định nghĩa như một doctrine độc lập của EGAL.**

**PART V không thiết kế lại Three Ledger Doctrine.**

**Mục tiêu của PART này là xác định:**

**Ba Ledger được tích hợp như thế nào trong kiến trúc phân tầng (Layering Architecture).**

**Đây là cầu nối giữa:**

* **Layering Doctrine**  
* **Three Ledger Doctrine**  
* **Correlation Doctrine**  
* **Snapshot Doctrine**  
* **Notification Doctrine**

---

# **2\. Philosophy**

**EGAL không coi việc ghi Log là một hoạt động phụ.**

**EGAL coi việc ghi lịch sử là một phần của Business Process.**

**Mỗi Business Process đều sinh ra:**

* **Business History**  
* **Audit History**  
* **Communication History**

**Ba loại lịch sử này có mục đích hoàn toàn khác nhau.**

**Do đó chúng được lưu ở ba Ledger độc lập.**

---

# **3\. Three Ledger Model**

**Kiến trúc chuẩn:**

```
                    Business Process
                           │
        ┌──────────────────┼──────────────────┐
        ▼                  ▼                  ▼
 Business Process      Audit Ledger     Communication
      Ledger                                Ledger
        │                  │                  │
        ▼                  ▼                  ▼
business_process_logs   audit_logs      notifications
                                         │
                                         ▼
                             notification_recipients
                                         │
                                         ▼
                             notification_deliveries
```

**Không có Ledger nào thay thế Ledger khác.**

---

# **4\. Business Process Ledger**

## **4.1 Mission**

**Business Process Ledger ghi nhận:**

**Điều gì đã xảy ra trong Business.**

**Ví dụ:**

```
USER_APPROVAL

USER_REJECTION

PASSWORD_RESET

ONBOARDING_SUBMITTED

ONBOARDING_APPROVED

ONBOARDING_MERGED

BRANCH_CREATED

MEMBER_TRANSFERRED
```

**Business Process Ledger không ghi:**

* **SQL**  
* **Row Update**  
* **Notification Delivery**

---

## **4.2 Characteristics**

**Business Process Ledger SHALL:**

* **bất biến (Immutable)**  
* **có Snapshot**  
* **có Correlation**  
* **có Timestamp**  
* **có Metadata chuẩn hóa**

**Business Process Ledger SHALL NOT:**

* **cập nhật lịch sử**  
* **JOIN realtime để tái tạo dữ liệu**

---

# **5\. Audit Ledger**

## **5.1 Mission**

**Audit Ledger ghi nhận:**

**Ai đã thay đổi dữ liệu gì.**

**Audit Ledger trả lời:**

* **Who**  
* **What**  
* **When**

**Ví dụ:**

```
Admin A

changed

status

from

PENDING

to

APPROVED
```

**Audit Ledger không mô tả Business Workflow.**

---

## **5.2 Characteristics**

**Audit Ledger SHALL:**

* **ghi Before/After (khi phù hợp)**  
* **ghi User**  
* **ghi Timestamp**  
* **ghi Correlation**

**Audit Ledger SHALL NOT:**

* **quyết định nghiệp vụ**  
* **mô tả Notification**

---

# **6\. Communication Ledger**

## **6.1 Mission**

**Communication Ledger ghi nhận:**

**Thông tin nào đã được truyền tới ai.**

**Communication Ledger sử dụng:**

```
notifications

notification_recipients

notification_deliveries
```

**Không tạo:**

```
communication_events
```

**Đây là doctrine đã được phê duyệt.**

---

## **6.2 Responsibilities**

**Communication Ledger ghi:**

* **Notification**  
* **Recipient**  
* **Delivery**  
* **Delivery Result**  
* **Retry**  
* **Read Status**

**Communication Ledger không ghi Business Rule.**

---

# **7\. Independence Principle**

**Ba Ledger độc lập.**

**Không Ledger nào phụ thuộc Ledger khác.**

**Ví dụ:**

```
Business Process Ledger
```

**vẫn tồn tại nếu Notification thất bại.**

**Ngược lại:**

**Notification thành công**

**không có nghĩa Business Process thành công.**

**Điều này bảo đảm tính độc lập của từng loại lịch sử.**

---

# **8\. Correlation Integration**

**Ba Ledger được liên kết bằng:**

```
correlation_id
```

**Kiến trúc chuẩn:**

```
Business Service
        │
        ▼
Business Logger
        │
        ▼
business_process_logs
        │
        │ correlation_id
        │
        ▼
audit_logs
        │
        │ correlation_id
        │
        ▼
notifications
        │
        ▼
notification_recipients
        │
        ▼
notification_deliveries
```

**Không được sinh Correlation mới trong cùng một Business Process.**

---

# **9\. Snapshot Integration**

**Snapshot Doctrine chỉ áp dụng cho:**

```
business_process_logs
```

**Thông tin Snapshot được lưu trong:**

```
metadata.context

metadata.payload
```

**Snapshot dùng để tái hiện lịch sử tại thời điểm Business Process xảy ra.**

**Audit Ledger không thay thế Snapshot.**

**Communication Ledger cũng không thay thế Snapshot.**

---

# **10\. Layer Integration**

**Three Ledger nằm hoàn toàn trong Ledger Layer.**

**Kiến trúc:**

```
Business Layer
        │
        ▼
────────────────────────────
Ledger Layer
────────────────────────────

Business Logger

Audit Logger

Notification Builder

Notification Service

────────────────────────────
        │
        ▼
Prisma Infrastructure
```

**Business Layer không ghi trực tiếp vào Ledger.**

---

# **11\. Standard Flow**

**Một Business Process chuẩn:**

```
Business Service
        │
        ▼
Business Rule
        │
        ▼
Business Logger
        │
        ▼
Audit Logger
        │
        ▼
Notification Builder
        │
        ▼
Notification Service
        │
        ▼
Prisma Infrastructure
        │
        ▼
Database
```

**Đây là luồng chuẩn của EGAL.**

---

# **12\. Transaction Integration**

**Business Process SHALL sử dụng:**

```
withTransaction()
```

**Toàn bộ:**

* **Business Process Log**  
* **Audit**  
* **Notification**

**được tạo trong cùng một Execution Context.**

**Việc Notification Delivery thực tế (gửi email, push, SMS...) có thể diễn ra bất đồng bộ sau khi transaction hoàn tất, nhưng Communication Ledger vẫn được khởi tạo từ cùng một `correlation_id`.**

---

# **13\. Schema Integration**

**Ba Ledger sử dụng các Data Contract khác nhau.**

**Business Process Ledger**

**↓**

```
BusinessLogSchemas
```

**Communication Ledger**

**↓**

```
NotificationMetadataSchemas
```

**Audit Ledger**

**↓**

**Audit Schema riêng.**

**Không được sử dụng Metadata tự do.**

---

# **14\. Infrastructure Integration**

**Ledger Layer không truy cập Database trực tiếp.**

**Ledger Layer sử dụng Infrastructure Capability:**

```
businessProcess.create()

audit.create()

notification.create()

notification.createRecipient()

notification.createDelivery()
```

**Infrastructure chịu trách nhiệm Persistence.**

**Ledger chịu trách nhiệm Standardization.**

---

# **15\. Failure Isolation**

**Một Ledger gặp lỗi không làm thay đổi ý nghĩa của Ledger khác.**

**Ví dụ:**

**Notification Delivery thất bại.**

**Business Process Ledger**

**↓**

**vẫn tồn tại.**

**Audit Ledger**

**↓**

**vẫn tồn tại.**

**Communication Ledger**

**↓**

**ghi trạng thái thất bại để phục vụ retry và theo dõi.**

**Điều này giúp hệ thống có khả năng phục hồi và truy vết đầy đủ.**

---

# **16\. Anti-Patterns**

**Các trường hợp sau bị coi là vi phạm kiến trúc.**

---

## **Anti-pattern A**

```
Business Service

↓

business_process_logs.create()
```

**Sai.**

**Phải đi qua Business Logger.**

---

## **Anti-pattern B**

```
Business Service

↓

notifications.create()
```

**Sai.**

**Phải đi qua Notification Builder và Notification Service.**

---

## **Anti-pattern C**

```
Audit Log

↓

Business Workflow
```

**Sai.**

**Audit không mô tả Workflow.**

---

## **Anti-pattern D**

```
Notification

↓

Business State
```

**Sai.**

**Notification không quyết định trạng thái nghiệp vụ.**

---

## **Anti-pattern E**

**Một Ledger được sử dụng để thay thế Ledger khác.**

**Sai.**

**Ba Ledger có mục đích khác nhau và không thể thay thế lẫn nhau.**

---

# **17\. Compliance Checklist**

**Một Business Process đạt Three Ledger Compliance khi:**

**✓ Có Business Process Ledger.**

**✓ Có Audit Ledger (nếu phát sinh thay đổi dữ liệu cần kiểm toán).**

**✓ Có Communication Ledger khi phát sinh thông tin cần gửi.**

**✓ Chia sẻ cùng `correlation_id`.**

**✓ Business Process Log có Snapshot.**

**✓ Metadata được chuẩn hóa bằng Schema Contract.**

**✓ Không ghi trực tiếp vào các bảng Ledger.**

---

# **18\. Conformance Statement**

**Three Ledger Integration là chuẩn tích hợp chính thức của Backend EGAL.**

**Mọi Business Process mới SHALL tuân thủ mô hình tích hợp này.**

**Không được bỏ qua Ledger Layer hoặc ghi trực tiếp vào các bảng của Ledger nếu không có một Architecture Decision Record (ADR) được phê duyệt.**

---

**End of PART V**

# 

# **PART VI — Prisma Infrastructure Layer**

---

# **1\. Purpose**

**Three Ledger Doctrine đã định nghĩa mô hình Ledger.**

**Prisma Doctrine đã định nghĩa cách sử dụng Prisma.**

**PART VI không thay thế Prisma Doctrine.**

**PART VI xác định:**

**Vai trò của Prisma Infrastructure Layer trong kiến trúc Layering của EGAL.**

**Đây là tầng chịu trách nhiệm chuyển đổi yêu cầu từ Business và Ledger thành các thao tác Persistence một cách nhất quán, an toàn và độc lập với Business Process.**

---

# **2\. Design Philosophy**

**EGAL không coi Prisma là ORM thuần túy.**

**Trong EGAL, Prisma là:**

**Infrastructure Runtime**

**không phải**

**Business API**

**Điều này có nghĩa:**

**Business không làm việc với Prisma Delegate.**

**Business làm việc với:**

* **Infrastructure Capability**  
* **Execution Context**  
* **Transaction**  
* **Tenant Scope**

**Prisma chỉ là công nghệ được sử dụng để hiện thực các capability đó.**

---

# **3\. Mission**

**Prisma Infrastructure Layer có bốn nhiệm vụ chính:**

1. **Quản lý vòng đời Transaction.**  
2. **Quản lý Execution Context.**  
3. **Thực hiện Persistence.**  
4. **Cung cấp Infrastructure Capability ổn định cho toàn hệ thống.**

**Infrastructure không quyết định nghiệp vụ.**

**Infrastructure chỉ thực thi các yêu cầu đã được Business Layer và Ledger Layer chuẩn hóa.**

---

# **4\. Architectural Position**

```
Business Layer
        │
        ▼
Ledger Layer
        │
        ▼
──────────────────────────────
Prisma Infrastructure Layer
──────────────────────────────
        │
        ▼
Prisma Client
        │
        ▼
PostgreSQL
```

**Infrastructure là tầng duy nhất được phép tương tác trực tiếp với Prisma Client.**

---

# **5\. Infrastructure Components**

**Một Prisma Infrastructure chuẩn của EGAL bao gồm:**

## **Runtime**

* **`withTransaction()`**  
* **`createExecutionContext()`**

## **Context**

* **Tenant Context**  
* **User Context**  
* **Correlation Context**  
* **Request Context**

## **Infrastructure Capability**

* **`businessProcess.create()`**  
* **`audit.create()`**  
* **`notification.create()`**  
* **`notification.createRecipient()`**  
* **`notification.createDelivery()`**

## **Persistence**

* **Prisma Delegate**  
* **Transaction Client**

---

# **6\. Stable Infrastructure API**

**Infrastructure Layer cung cấp một tập API ổn định.**

**Ví dụ:**

```javascript
await withTransaction(contextInput, async (tx, context) => {

    await prisma.businessProcess.create(tx, context, ...);

    await prisma.audit.create(tx, context, ...);

    await prisma.notification.create(tx, context, ...);

});
```

**Business Layer không biết:**

* **Transaction được tạo như thế nào.**  
* **Prisma Delegate nào được sử dụng.**  
* **Tenant được inject như thế nào.**

---

# **7\. Execution Context**

**Execution Context là nền tảng của toàn bộ Infrastructure.**

**Context được tạo một lần:**

```javascript
const context = createExecutionContext(contextInput);
```

**sau đó được truyền xuyên suốt:**

```
Business

↓

Ledger

↓

Infrastructure

↓

Database
```

**Execution Context SHALL chứa tối thiểu:**

* **tenant\_id**  
* **user\_id**  
* **correlation\_id**  
* **request\_id**  
* **actor**  
* **timestamp**

**Không được tạo Context mới trong cùng một Business Process.**

---

# **8\. Transaction Doctrine Integration**

**Infrastructure Layer là nơi duy nhất được phép tạo Transaction.**

**Chuẩn chính thức:**

```javascript
await withTransaction(contextInput, async (tx, context) => {

    // Business Process

});
```

**Business Layer SHALL NOT gọi:**

```javascript
prisma.$transaction(...)
```

**trực tiếp.**

**Ledger Layer cũng SHALL NOT tạo Transaction.**

---

# **9\. Persistence Primitive**

**Infrastructure cung cấp các Persistence Primitive.**

**Ví dụ:**

```
businessProcess.create()

audit.create()

notification.create()

notification.createRecipient()

notification.createDelivery()
```

**Đây là các Primitive.**

**Không phải Business API.**

---

# **10\. Tenant Scope**

**Infrastructure chịu trách nhiệm áp dụng Tenant Scope.**

**Business Layer không phải nhớ:**

```
tenant_id

deleted_at IS NULL

organization_id
```

**Infrastructure tự động áp dụng các quy tắc chung này khi thực hiện Persistence hoặc cung cấp helper/query builder phù hợp.**

**Điều này bảo đảm tính nhất quán trên toàn hệ thống.**

---

# **11\. Correlation Propagation**

**Infrastructure chịu trách nhiệm bảo toàn:**

```
correlation_id
```

**trong suốt Transaction.**

**Ví dụ:**

```
Business Logger

↓

Audit

↓

Notification
```

**đều nhận cùng:**

```
correlation_id
```

**Infrastructure không được sinh Correlation mới.**

---

# **12\. Error Handling**

**Infrastructure xử lý:**

* **Transaction Rollback**  
* **Connection Error**  
* **Deadlock Retry (nếu được cấu hình)**  
* **Database Exception Mapping**

**Business Layer xử lý:**

* **Business Exception**  
* **Validation Exception**  
* **Authorization Exception**

**Không được trộn lẫn hai loại Exception.**

---

# **13\. What Infrastructure Knows**

**Infrastructure biết:**

* **Transaction**  
* **Context**  
* **Tenant**  
* **Correlation**  
* **Persistence**  
* **Database Connection**

**Infrastructure không biết:**

* **Approval**  
* **Merge**  
* **Onboarding**  
* **Donation**  
* **Workflow**  
* **Business Rule**

**Đây là ranh giới quan trọng nhất của Layering Doctrine.**

---

# **14\. Infrastructure Evolution**

**Infrastructure chỉ được mở rộng khi xuất hiện:**

## **Capability mới**

**Ví dụ:**

* **Distributed Lock**  
* **Outbox Pattern**  
* **Soft Delete Framework**  
* **Retry Policy**  
* **Optimistic Concurrency**  
* **Event Store**  
* **Read Replica Routing**

**Đây đều là Infrastructure Capability.**

**Infrastructure không được mở rộng chỉ vì có Business Process mới.**

**Ví dụ:**

**Sai:**

```
Donation Approval

↓

prisma.donationApproval()
```

**Đúng:**

**Donation Service sử dụng các Infrastructure Capability hiện có.**

---

# **15\. Anti-Patterns**

## **Anti-pattern A**

```javascript
new PrismaClient()
```

**trong Business Service.**

**Sai.**

---

## **Anti-pattern B**

```javascript
prisma.users.create(...)
```

**trong Business Layer.**

**Sai.**

---

## **Anti-pattern C**

```javascript
prisma.$transaction(...)
```

**trong Service.**

**Sai.**

**Phải dùng:**

```javascript
withTransaction()
```

---

## **Anti-pattern D**

**Infrastructure chứa:**

```
if (approval)
```

**Sai.**

**Infrastructure không biết Approval.**

---

## **Anti-pattern E**

**Infrastructure quyết định:**

```
Branch Merge
```

**Sai.**

**Merge là Business Logic.**

---

# **16\. Infrastructure Compliance Checklist**

**Một Infrastructure đạt chuẩn khi:**

**✓ Chỉ có một Prisma Singleton.**

**✓ Không tạo PrismaClient ở nhiều nơi.**

**✓ Mọi Transaction đi qua `withTransaction()`.**

**✓ Có Execution Context thống nhất.**

**✓ Có Tenant Scope.**

**✓ Có Correlation Propagation.**

**✓ Chỉ cung cấp Infrastructure Capability.**

**✓ Không chứa Business Rule.**

---

# **17\. Relationship with Prisma Doctrine**

**Prisma Doctrine trả lời:**

**Sử dụng Prisma như thế nào.**

**Layering Doctrine trả lời:**

**Prisma nằm ở đâu trong kiến trúc.**

**Hai doctrine bổ sung cho nhau.**

**Không thay thế nhau.**

---

# **18\. Conformance Statement**

**Prisma Infrastructure Layer là điểm truy cập duy nhất từ Backend EGAL tới Prisma Client và cơ sở dữ liệu.**

**Mọi module mới SHALL sử dụng các Infrastructure Capability được định nghĩa tại tầng này.**

**Không được truy cập trực tiếp Prisma Delegate từ Business Layer hoặc Ledger Layer.**

**Mọi thay đổi mở rộng Prisma Infrastructure SHALL chứng minh rằng đó là Infrastructure Capability mới, không phải là một Business Process mới.**

---

**End of PART VI**

# 

# 

# **PART VII — Schema Contract Doctrine**

---

# **1\. Purpose**

**Three Ledger Doctrine đã định nghĩa ba Ledger độc lập.**

**Prisma Doctrine đã chuẩn hóa Persistence.**

**Layering Doctrine đã định nghĩa Layer Model.**

**PART VII định nghĩa:**

**Schema Contract Doctrine**

**Schema Contract là nền tảng bảo đảm dữ liệu được ghi vào hệ thống luôn có ý nghĩa nhất quán, có thể kiểm chứng, và có khả năng mở rộng trong nhiều năm mà không làm suy giảm chất lượng dữ liệu.**

---

# **2\. Philosophy**

**EGAL không coi `metadata` là một vùng dữ liệu tự do (Free-form JSON).**

**Trong EGAL:**

**Metadata là một hợp đồng dữ liệu (Data Contract).**

**Điều này có nghĩa:**

* **Mỗi Business Process có cấu trúc Metadata riêng.**  
* **Mỗi Notification có cấu trúc Metadata riêng.**  
* **Các cấu trúc này phải được kiểm tra và chuẩn hóa trước khi ghi xuống Database.**

**Metadata không phải là nơi lưu trữ dữ liệu tùy ý của lập trình viên.**

---

# **3\. What is a Schema Contract?**

**Schema Contract là tập hợp các quy tắc xác định:**

* **Thuộc tính nào được phép xuất hiện.**  
* **Thuộc tính nào bắt buộc.**  
* **Giá trị nào hợp lệ.**  
* **Giá trị nào phải bị loại bỏ.**  
* **Cách chuẩn hóa dữ liệu trước khi lưu.**

**Schema Contract không chỉ thực hiện validation.**

**Schema Contract còn thực hiện:**

* **Sanitization**  
* **Normalization**  
* **Compatibility Control**

---

# **4\. Architectural Position**

```
Business Layer
        │
        ▼
Ledger Layer
──────────────────────────────
BusinessLogSchemas
NotificationMetadataSchemas
AuditSchemas
──────────────────────────────
        │
        ▼
Prisma Infrastructure
        │
        ▼
Database
```

**Schema Contract thuộc Ledger Layer.**

**Không thuộc Business Layer.**

**Không thuộc Infrastructure Layer.**

---

# **5\. Why Schema Contract Exists**

**Nếu Metadata được ghi trực tiếp:**

```json
{
  "abc":123,
  "xyz":"hello",
  "tmp":"debug"
}
```

**sau vài năm:**

* **Không ai biết ý nghĩa của từng field.**  
* **Nhiều Business Process sử dụng cùng tên field nhưng khác ý nghĩa.**  
* **Metadata không còn khả năng phân tích.**

**Schema Contract được tạo ra để ngăn hiện tượng này.**

---

# **6\. Business Log Schema**

**Business Process Log SHALL sử dụng:**

```
BusinessLogSchemas
```

**Ví dụ:**

```javascript
BusinessLogSchemas.USER_APPROVAL

BusinessLogSchemas.ONBOARDING_SUBMITTED

BusinessLogSchemas.BRANCH_MERGED
```

**Mỗi Schema mô tả đầy đủ:**

* **context**  
* **payload**  
* **actor**  
* **target**  
* **allowed metadata**

---

# **7\. Notification Metadata Schema**

**Communication Ledger SHALL sử dụng:**

```
NotificationMetadataSchemas
```

**Ví dụ:**

```javascript
NotificationMetadataSchemas.USER_APPROVAL

NotificationMetadataSchemas.PASSWORD_RESET

NotificationMetadataSchemas.ONBOARDING_APPROVED
```

**Notification Metadata SHALL được sanitize trước khi Persistence.**

**Không được ghi Notification Metadata trực tiếp.**

---

# **8\. Audit Schema**

**Audit Ledger cũng phải có Data Contract.**

**Ví dụ:**

```javascript
AuditSchemas.USER_STATUS

AuditSchemas.BRANCH_STATUS

AuditSchemas.MEMBER_TRANSFER
```

**Audit Schema chuẩn hóa:**

* **before**  
* **after**  
* **changed\_fields**  
* **actor**  
* **timestamp**

**Audit Schema không mô tả Business Workflow.**

---

# **9\. Schema Lifecycle**

**Mỗi Schema trải qua vòng đời sau:**

```
Business Request
        │
        ▼
Build Metadata
        │
        ▼
Schema Validation
        │
        ▼
Schema Sanitization
        │
        ▼
Normalized Metadata
        │
        ▼
Persistence
```

**Không được bỏ qua bước Validation hoặc Sanitization.**

---

# **10\. Sanitization Rules**

**Schema SHALL loại bỏ:**

* **Unknown Property**  
* **Undefined Value**  
* **Invalid Enum**  
* **Internal Debug Field**  
* **Runtime Object**  
* **Function Reference**

**Ví dụ:**

**Sai:**

```json
{
    "member_id":123,
    "_debug":"abc",
    "tmp":true
}
```

**Sau Sanitization:**

```json
{
    "member_id":123
}
```

---

# **11\. Snapshot Contract**

**Business Process Log SHALL chứa:**

```
metadata.context

metadata.payload
```

**Trong đó:**

**Context**

**↓**

**Snapshot Entity**

**Payload**

**↓**

**Snapshot Business Data**

**Snapshot phải đủ để tái hiện lịch sử.**

**Không phụ thuộc dữ liệu hiện tại trong Database.**

---

# **12\. Schema Evolution**

**Schema có thể mở rộng.**

**Schema không được phá vỡ khả năng đọc dữ liệu cũ.**

**Nguyên tắc:**

**✓ Additive Change**

**✓ Backward Compatible**

**Không được:**

* **đổi ý nghĩa field**  
* **tái sử dụng field cho mục đích khác**  
* **xóa field đang được sử dụng nếu chưa có migration strategy**

---

# **13\. Versioning**

**Schema Contract nên hỗ trợ Versioning khi cần.**

**Ví dụ:**

```
USER_APPROVAL v1

↓

USER_APPROVAL v2
```

**Versioning chỉ áp dụng khi thay đổi cấu trúc dữ liệu.**

**Không áp dụng cho thay đổi Business Rule.**

---

# **14\. Ownership**

**Business Layer**

**↓**

**xây dựng dữ liệu nghiệp vụ.**

**Ledger Layer**

**↓**

**chuẩn hóa dữ liệu.**

**Infrastructure**

**↓**

**ghi dữ liệu.**

**Database**

**↓**

**lưu dữ liệu.**

**Schema Contract thuộc sở hữu của Ledger Layer.**

---

# **15\. Dependency Rules**

**Schema Contract được phép phụ thuộc:**

* **Utility**  
* **Validator**  
* **Enum**  
* **Constant**

**Schema Contract không được phụ thuộc:**

* **Business Service**  
* **Prisma**  
* **Repository**  
* **Database**  
* **HTTP Request**  
* **Express Context**

**Schema Contract phải là Pure Contract.**

---

# **16\. Anti-Patterns**

## **Anti-pattern A**

**Business Service tự build Metadata.**

**Sai.**

**Business Service chỉ cung cấp dữ liệu.**

**Ledger Layer chuẩn hóa.**

---

## **Anti-pattern B**

```javascript
metadata = request.body
```

**Sai.**

**Request không phải Schema.**

---

## **Anti-pattern C**

**Notification Metadata ghi trực tiếp.**

**Sai.**

**Phải đi qua:**

```
NotificationMetadataSchemas
```

---

## **Anti-pattern D**

**Business Log không qua Schema.**

**Sai.**

---

## **Anti-pattern E**

**Schema chứa Business Rule.**

**Ví dụ:**

```javascript
if (user.role=="ADMIN")
```

**Sai.**

**Schema không quyết định nghiệp vụ.**

---

# **17\. Compliance Checklist**

**Một Schema Contract đạt chuẩn khi:**

**✓ Có Validation.**

**✓ Có Sanitization.**

**✓ Có Normalization.**

**✓ Không phụ thuộc Business Layer.**

**✓ Không phụ thuộc Infrastructure.**

**✓ Không phụ thuộc Database.**

**✓ Có khả năng mở rộng.**

**✓ Có khả năng tương thích ngược khi cần.**

---

# **18\. Relationship with Other Doctrines**

**Three Ledger Doctrine**

**↓**

**quy định Ledger.**

**Schema Contract Doctrine**

**↓**

**quy định dữ liệu trong Ledger.**

**Prisma Doctrine**

**↓**

**quy định Persistence.**

**Layering Doctrine**

**↓**

**quy định Schema nằm ở Ledger Layer.**

**Các doctrine này bổ sung cho nhau.**

---

# **19\. Future Evolution**

**Trong tương lai có thể bổ sung:**

* **Schema Registry**  
* **JSON Schema Export**  
* **Runtime Schema Introspection**  
* **Metadata Documentation Generator**  
* **Automatic Contract Testing**

**Những mở rộng này không làm thay đổi triết lý của Schema Contract Doctrine.**

---

# **20\. Conformance Statement**

**Mọi dữ liệu được ghi vào Business Process Ledger, Audit Ledger và Communication Ledger SHALL tuân thủ một Schema Contract chính thức.**

**Không được sử dụng Metadata tự do trong các Ledger của EGAL.**

**Mọi Business Process mới SHALL bổ sung hoặc tái sử dụng Schema Contract phù hợp trước khi triển khai implementation.**

---

**End of PART VII**

# 

# 

# **PART VIII — Architectural Anti-Patterns**

---

# **1\. Purpose**

**Các PART trước đã định nghĩa:**

* **Layer Model**  
* **Responsibility Matrix**  
* **Dependency Rules**  
* **Three Ledger Integration**  
* **Prisma Infrastructure**  
* **Schema Contract**

**PART VIII định nghĩa phần còn lại:**

**Những điều tuyệt đối không được làm (Architectural Anti-Patterns).**

**Mục tiêu của PART này là:**

* **Ngăn chặn Architectural Erosion.**  
* **Chuẩn hóa Code Review.**  
* **Phát hiện sớm sai lệch kiến trúc.**  
* **Giảm Technical Debt.**  
* **Duy trì khả năng mở rộng lâu dài của Backend EGAL.**

---

# **2\. Philosophy**

**Một hệ thống lớn hiếm khi thất bại vì một quyết định sai.**

**Nó thường thất bại vì hàng nghìn ngoại lệ nhỏ được chấp nhận theo thời gian.**

**Ví dụ:**

**"Chỉ một chỗ này thôi..."**

**↓**

**"Chỉ thêm một PrismaClient..."**

**↓**

**"Chỉ insert trực tiếp notification..."**

**↓**

**"Chỉ transaction riêng ở service này..."**

**↓**

**Sau vài năm:**

**Không còn kiến trúc.**

**Layering Doctrine được xây dựng để ngăn điều này.**

---

# **3\. Anti-Pattern Classification**

**EGAL phân loại Anti-Pattern thành:**

| Category | Description |
| ----- | ----- |
| **Layer Violation** | **Vi phạm Layer Model** |
| **Dependency Violation** | **Vi phạm Dependency Rules** |
| **Responsibility Leakage** | **Một Layer làm việc của Layer khác** |
| **Infrastructure Leakage** | **Business biết Infrastructure** |
| **Ledger Bypass** | **Ghi Ledger trực tiếp** |
| **Schema Violation** | **Không dùng Schema Contract** |
| **Transaction Violation** | **Transaction sai Doctrine** |
| **Correlation Violation** | **Correlation không xuyên suốt** |
| **Snapshot Violation** | **Snapshot không đầy đủ** |

---

# **4\. Layer Violation**

## **Sai**

```
Business Service
        │
        ▼
Prisma Delegate
```

**Ví dụ:**

```javascript
await prisma.users.update(...)
```

**trong:**

```
UserApprovalService
```

**Đây là vi phạm Layering Doctrine.**

---

## **Đúng**

```
Business Service
        │
        ▼
Ledger Layer
        │
        ▼
Prisma Infrastructure
```

---

# **5\. Ledger Bypass**

**Sai:**

```javascript
await prisma.business_process_logs.create(...)
```

**Sai:**

```javascript
await prisma.audit_logs.create(...)
```

**Sai:**

```javascript
await prisma.notifications.create(...)
```

**Business Layer không được ghi trực tiếp Ledger.**

**Phải đi qua:**

* **Business Logger**  
* **Audit Logger**  
* **Notification Builder**  
* **Notification Service**

---

# **6\. Multiple PrismaClient**

**Sai:**

```javascript
const prisma = new PrismaClient();
```

**trong nhiều Service.**

**Hệ thống chỉ được phép có:**

```javascript
src/lib/prisma.js
```

**là nơi quản lý Prisma Singleton.**

**Đây là yêu cầu bắt buộc của Prisma Doctrine.**

---

# **7\. Transaction Leakage**

**Sai:**

```javascript
await prisma.$transaction(...)
```

**trong Business Service.**

**Sai:**

```javascript
await tx.$transaction(...)
```

**lồng nhiều Transaction không có chủ đích.**

**Chuẩn:**

```javascript
await withTransaction(contextInput, async (tx, context) => {

});
```

**Transaction chỉ được khởi tạo tại Infrastructure Layer.**

---

# **8\. Infrastructure Leakage**

**Business Layer không được biết:**

* **Prisma Delegate**  
* **SQL**  
* **Connection**  
* **Retry**  
* **Deadlock**

**Ví dụ sai:**

```javascript
if (databaseError.code === ...)
```

**Business Layer không xử lý Database Error.**

**Infrastructure mới xử lý.**

---

# **9\. Business Logic in Infrastructure**

**Sai:**

```javascript
if (user.status === "APPROVED") {

}
```

**trong:**

```
prisma.js
```

**Infrastructure không được chứa:**

* **Approval**  
* **Reject**  
* **Merge**  
* **Onboarding**  
* **Donation**

**Infrastructure chỉ biết:**

* **Persistence**  
* **Transaction**  
* **Context**

---

# **10\. Business Logic in Ledger**

**Sai:**

```javascript
if (branch.type=="PRIMARY") {

merge()

}
```

**trong:**

```
Business Logger
```

**Ledger không được quyết định nghiệp vụ.**

**Ledger chỉ chuẩn hóa dữ liệu.**

---

# **11\. Free-form Metadata**

**Sai:**

```javascript
metadata = request.body;
```

**Sai:**

```javascript
metadata = {

...anything

}
```

**Chuẩn:**

```javascript
metadata =
BusinessLogSchemas.USER_APPROVAL(...)
```

**Hoặc:**

```javascript
NotificationMetadataSchemas....
```

**Metadata phải có Data Contract.**

---

# **12\. Correlation Fragmentation**

**Sai:**

```
Business Log

correlation A
```

**↓**

```
Audit

correlation B
```

**↓**

```
Notification

correlation C
```

**Một Business Process chỉ có một:**

```
correlation_id
```

---

# **13\. Snapshot Violation**

**Sai:**

**Business Log chỉ lưu:**

```
member_id
```

**Sau đó JOIN Database để dựng lịch sử.**

**Nếu dữ liệu thay đổi:**

**Lịch sử sai.**

**Chuẩn:**

**Business Log lưu Snapshot.**

**Không phụ thuộc dữ liệu hiện tại.**

---

# **14\. Cross-Layer Callback**

**Sai:**

```
Infrastructure

↓

Business
```

**Ví dụ:**

**Infrastructure callback Business Rule.**

**Dependency bị đảo chiều.**

**Đây là Circular Responsibility.**

---

# **15\. God Service**

**Một Service:**

* **Approval**  
* **Notification**  
* **Audit**  
* **Branch**  
* **Database**  
* **Validation**  
* **Email**

**đều nằm trong cùng một file.**

**Đây là God Service.**

**Giải pháp:**

**Tách:**

* **Business**  
* **Ledger**  
* **Infrastructure**

---

# **16\. God Infrastructure**

**Sai:**

```
prisma.js
```

**chứa:**

* **Approval**  
* **Donation**  
* **Merge**  
* **Import**  
* **AI**  
* **Genealogy**

**Infrastructure chỉ chứa:**

**Infrastructure Capability.**

**Không chứa Business Process.**

---

# **17\. Hidden Side Effects**

**Một hàm:**

```javascript
approveUser()
```

**âm thầm:**

* **gửi Email**  
* **ghi Audit**  
* **ghi Notification**  
* **ghi Business Log**

**nhưng không thể hiện rõ qua API hoặc orchestration.**

**Business Workflow phải minh bạch.**

**Side Effect phải có chủ đích.**

---

# **18\. Direct Table Ownership**

**Business Layer không được coi bảng Database là API.**

**Sai:**

```javascript
await prisma.notifications.create(...)
```

**Đúng:**

```
Notification Builder

↓

Notification Service

↓

Infrastructure
```

**Table không phải Public API.**

**Infrastructure Capability mới là API.**

---

# **19\. Layer Bleeding**

**Layer Bleeding xảy ra khi:**

* **Business hiểu Database.**  
* **Infrastructure hiểu Business.**  
* **Ledger hiểu Workflow.**

**Đây là dấu hiệu kiến trúc đang xuống cấp.**

**Mọi Layer Bleeding SHALL được refactor.**

---

# **20\. Architecture Review Triggers**

**Các thay đổi sau bắt buộc phải được Architecture Review:**

* **Thêm Infrastructure Capability mới.**  
* **Thay đổi Transaction Model.**  
* **Thêm Ledger mới.**  
* **Thay đổi Correlation Model.**  
* **Thay đổi Schema Contract.**  
* **Thay đổi Layer Dependency.**  
* **Thay đổi Execution Context.**  
* **Thêm cơ chế Persistence mới.**

**Không cần Architecture Review khi:**

* **Thêm Business Process mới (nếu chỉ sử dụng các capability hiện có).**  
* **Bổ sung Business Rule trong Business Layer.**  
* **Mở rộng Schema theo hướng tương thích ngược.**

---

# **21\. Code Review Checklist**

**Reviewer SHALL kiểm tra:**

**✓ Có bypass Ledger Layer không?**

**✓ Có gọi Prisma Delegate trực tiếp không?**

**✓ Có `new PrismaClient()` không?**

**✓ Có `prisma.$transaction()` ngoài `withTransaction()` không?**

**✓ Có Metadata tự do không?**

**✓ Có Correlation xuyên suốt không?**

**✓ Có Snapshot đúng chuẩn không?**

**✓ Có Layer Bleeding không?**

**✓ Có Business Rule trong Infrastructure không?**

**✓ Có Infrastructure biết Workflow không?**

---

# **22\. Architectural Smells**

**Các dấu hiệu sau cần được xem là "mùi kiến trúc" (Architectural Smells):**

* **Service dài bất thường (\>500–700 dòng) và kiêm nhiều trách nhiệm.**  
* **Nhiều module cùng lặp lại logic tạo Notification hoặc Business Log.**  
* **Cùng một loại Metadata nhưng có nhiều cấu trúc khác nhau.**  
* **Transaction được tạo ở nhiều vị trí.**  
* **Logic tenant hoặc soft delete bị lặp lại nhiều lần.**  
* **Reviewer phải đọc nhiều file mới hiểu được một Business Process đơn giản.**

**Những dấu hiệu này không phải lúc nào cũng là lỗi, nhưng SHOULD được đánh giá trước khi tiếp tục mở rộng.**

---

# **23\. Conformance Statement**

**Các Anti-Pattern được mô tả trong PART VIII được coi là các vi phạm kiến trúc chính thức của EGAL.**

**Mọi Code Review và Architecture Review SHALL sử dụng danh sách này như một tiêu chuẩn đánh giá.**

**Nếu cần chấp nhận một ngoại lệ, ngoại lệ đó MUST được ghi nhận bằng một Architecture Decision Record (ADR) và nêu rõ:**

* **Lý do.**  
* **Phạm vi áp dụng.**  
* **Thời hạn xem xét lại (nếu có).**  
* **Kế hoạch loại bỏ ngoại lệ trong tương lai.**

---

**End of PART VIII**

# 

# **PART IX — Implementation Guidelines**

---

# **1\. Purpose**

**Các phần trước của Layering Doctrine đã định nghĩa:**

* **Layer Model**  
* **Responsibility Matrix**  
* **Dependency Rules**  
* **Three Ledger Integration**  
* **Prisma Infrastructure Layer**  
* **Schema Contract Doctrine**  
* **Architectural Anti-Patterns**

**PART IX trả lời câu hỏi cuối cùng:**

**Lập trình viên phải triển khai Business Process mới như thế nào để tuân thủ toàn bộ các doctrine của EGAL.**

**Đây là tài liệu hướng dẫn implementation chính thức cho Phase 6B và các giai đoạn phát triển tiếp theo.**

---

# **2\. Business Process Lifecycle**

**Mọi Business Process mới SHALL tuân theo vòng đời sau:**

```
Business Request
        │
        ▼
Business Validation
        │
        ▼
withTransaction()
        │
        ▼
Business Logic
        │
        ▼
Business Logger
        │
        ▼
Audit Logger
        │
        ▼
Notification Builder
        │
        ▼
Notification Service
        │
        ▼
Infrastructure Persistence
        │
        ▼
Commit
```

**Đây là luồng chuẩn của EGAL.**

---

# **3\. Standard Directory Organization**

**Một Business Process mới nên được tổ chức theo cấu trúc sau:**

```
modules/

    onboarding/

        services/

        policies/

        validators/

        dto/

        routes/
```

**Ledger Layer:**

```
services/

    business-logger.service.js

    audit.service.js

modules/

    notifications/

        builder/

        services/

        policy/
```

**Infrastructure:**

```
lib/

    prisma.js

    execution-context.js

    transaction.js
```

---

# **4\. Standard Implementation Sequence**

**Khi phát triển Business Process mới:**

## **Bước 1**

**Xác định Business Rule.**

**Ví dụ:**

```
Approve Member
```

**↓**

**Business Layer.**

---

## **Bước 2**

**Nếu cần ghi lịch sử:**

**↓**

**Business Logger.**

---

## **Bước 3**

**Nếu thay đổi dữ liệu:**

**↓**

**Audit Logger.**

---

## **Bước 4**

**Nếu cần gửi thông báo:**

**↓**

**Notification Builder.**

**↓**

**Notification Service.**

---

## **Bước 5**

**Toàn bộ thực hiện trong:**

```javascript
await withTransaction(...)
```

---

# **5\. Standard Transaction Pattern**

**Chuẩn chính thức:**

```javascript
await withTransaction(contextInput, async (tx, context) => {

    // Business Logic

});
```

**Không tạo Transaction ở nơi khác.**

---

# **6\. Standard Execution Context**

**Context được tạo đúng một lần.**

**Context SHALL bao gồm:**

* **tenant\_id**  
* **user\_id**  
* **correlation\_id**  
* **request\_id**  
* **actor**  
* **timestamp**

**Business Process không được tạo Context thứ hai.**

---

# **7\. Standard Business Logger Pattern**

**Business Layer không ghi Log trực tiếp.**

**Chuẩn:**

```
Business Service

↓

Business Logger

↓

BusinessLogSchemas

↓

Infrastructure

↓

Database
```

**Business Logger chịu trách nhiệm:**

* **Validate**  
* **Sanitize**  
* **Snapshot**  
* **Correlation**

---

# **8\. Standard Audit Pattern**

**Audit được tạo sau khi thay đổi dữ liệu.**

**Chuẩn:**

```
Business Service

↓

Audit Logger

↓

Audit Schema

↓

Infrastructure
```

**Audit không quyết định Business Rule.**

---

# **9\. Standard Notification Pattern**

**Notification luôn đi theo chuỗi:**

```
Business Service

↓

Notification Builder

↓

NotificationMetadataSchemas

↓

Notification Service

↓

Infrastructure
```

**Business Layer không insert Notification trực tiếp.**

---

# **10\. Standard Persistence Pattern**

**Business Layer chỉ sử dụng:**

* **Infrastructure Capability**  
* **Ledger Service**

**Không sử dụng:**

```javascript
prisma.users.create(...)
```

**hoặc:**

```javascript
prisma.notifications.create(...)
```

**trực tiếp.**

---

# **11\. Error Handling Pattern**

**Business Exception**

**↓**

**Business Layer.**

**Database Exception**

**↓**

**Infrastructure.**

**Validation Exception**

**↓**

**Business Layer.**

**Transaction Rollback**

**↓**

**Infrastructure.**

**Không trộn lẫn các loại lỗi.**

---

# **12\. Correlation Pattern**

**Một Business Process**

**↓**

**Một**

```
correlation_id
```

**↓**

**được truyền xuyên suốt:**

* **Business Logger**  
* **Audit**  
* **Notification**  
* **Persistence**

**Không được tạo Correlation mới.**

---

# **13\. Metadata Pattern**

**Không sử dụng Metadata tự do.**

**Business Process Log**

**↓**

**BusinessLogSchemas.**

**Notification**

**↓**

**NotificationMetadataSchemas.**

**Audit**

**↓**

**AuditSchemas.**

---

# **14\. Snapshot Pattern**

**Business Process Log phải chứa Snapshot.**

**Ít nhất bao gồm:**

```
metadata.context

metadata.payload
```

**Snapshot phản ánh trạng thái tại thời điểm Business Process xảy ra.**

**Không dựa vào dữ liệu hiện tại trong Database.**

---

# **15\. Code Review Checklist**

**Trước khi merge một Business Process mới, Reviewer SHOULD xác nhận:**

**✓ Không có `new PrismaClient()`.**

**✓ Không gọi Prisma Delegate trực tiếp.**

**✓ Có `withTransaction()`.**

**✓ Có Execution Context.**

**✓ Có Correlation xuyên suốt.**

**✓ Có Business Logger (nếu phát sinh Business Event).**

**✓ Có Audit Logger (nếu thay đổi dữ liệu cần kiểm toán).**

**✓ Có Notification Builder (nếu phát sinh Communication).**

**✓ Có Schema Contract phù hợp.**

**✓ Không vi phạm Layering Doctrine.**

---

# **16\. Future Evolution**

**Khi xuất hiện Business Process mới như:**

* **Donation**  
* **Grave Management**  
* **DNA Verification**  
* **AI Genealogy**  
* **Volunteer Management**

**Quy trình implementation không thay đổi.**

**Chỉ bổ sung:**

* **Business Service**  
* **Business Rule**  
* **Schema Contract**

**Infrastructure và Layering Doctrine vẫn giữ nguyên.**

---

# **17\. Phase 6B Compliance**

**Một module được coi là hoàn thành Phase 6B khi:**

**✓ Tuân thủ Layering Doctrine.**

**✓ Tuân thủ Prisma Doctrine.**

**✓ Tuân thủ Three Ledger Doctrine.**

**✓ Tuân thủ Schema Contract Doctrine.**

**✓ Không có Architectural Anti-Pattern.**

**✓ Không truy cập Prisma Delegate trực tiếp từ Business Layer.**

**✓ Toàn bộ Business Process chạy qua `withTransaction()`.**

---

# **18\. Conformance Statement**

**Implementation Guidelines là tiêu chuẩn triển khai chính thức của Backend EGAL.**

**Mọi Business Process mới SHALL tuân thủ các bước triển khai được mô tả trong PART IX.**

**Các hướng dẫn này được sử dụng làm chuẩn cho:**

* **Development.**  
* **Code Review.**  
* **Architecture Review.**  
* **Technical Audit.**  
* **Phase 6B Completion Review.**

---

**End of PART IX**

# **PART X — Architecture Governance**

---

# **1\. Purpose**

**Các phần trước đã định nghĩa đầy đủ:**

* **Layer Model**  
* **Responsibility Matrix**  
* **Dependency Rules**  
* **Three Ledger Integration**  
* **Prisma Infrastructure Layer**  
* **Schema Contract Doctrine**  
* **Architectural Anti-Patterns**  
* **Implementation Guidelines**

**PART X định nghĩa lớp cuối cùng của Layering Doctrine:**

**Architecture Governance**

**Đây là doctrine quy định cách kiến trúc được duy trì, kiểm soát và phát triển trong suốt vòng đời của hệ thống EGAL.**

**Kiến trúc tốt không chỉ được thiết kế tốt.**

**Kiến trúc tốt phải được govern tốt.**

---

# **2\. Governance Philosophy**

**EGAL áp dụng nguyên tắc:**

**Architecture là tài sản dài hạn (Long-lived Asset).**

**Business Process có thể thay đổi.**

**Source Code có thể refactor.**

**Framework có thể thay thế.**

**Nhưng Architecture phải duy trì tính ổn định.**

**Do đó mọi thay đổi kiến trúc phải được kiểm soát.**

---

# **3\. Governance Objectives**

**Architecture Governance có năm mục tiêu chính:**

1. **Bảo vệ Layer Boundary.**  
2. **Bảo vệ Infrastructure Stability.**  
3. **Bảo vệ Data Contract.**  
4. **Kiểm soát Architectural Evolution.**  
5. **Ngăn chặn Architectural Erosion.**

---

# **4\. Governance Levels**

**EGAL phân chia Governance thành bốn cấp:**

| Level | Scope |
| ----- | ----- |
| **Development** | **Implementation hàng ngày** |
| **Code Review** | **Kiểm tra tuân thủ Doctrine** |
| **Architecture Review** | **Thay đổi kiến trúc** |
| **Technical Audit** | **Đánh giá toàn hệ thống** |

**Mỗi cấp có trách nhiệm khác nhau.**

---

# **5\. Development Governance**

**Trong quá trình phát triển:**

**Developer SHALL:**

* **Tuân thủ Layering Doctrine.**  
* **Tuân thủ Prisma Doctrine.**  
* **Tuân thủ Three Ledger Doctrine.**  
* **Tuân thủ Schema Contract.**

**Developer SHALL NOT:**

* **Tự ý mở rộng Infrastructure.**  
* **Bypass Ledger Layer.**  
* **Thêm Dependency ngược chiều.**  
* **Ghi trực tiếp vào Ledger.**

---

# **6\. Code Review Governance**

**Code Review không chỉ đánh giá chất lượng code.**

**Code Review SHALL đánh giá:**

* **Layer Boundary.**  
* **Dependency Direction.**  
* **Transaction Pattern.**  
* **Correlation.**  
* **Snapshot.**  
* **Metadata Contract.**  
* **Prisma Doctrine Compliance.**

**Code Review là tuyến phòng thủ đầu tiên của kiến trúc.**

---

# **7\. Architecture Review**

**Architecture Review bắt buộc khi có thay đổi liên quan đến:**

* **Layer Model.**  
* **Dependency Rule.**  
* **Execution Context.**  
* **Transaction Model.**  
* **Infrastructure Capability.**  
* **Schema Contract cơ bản.**  
* **Correlation Model.**  
* **Ledger Model.**

**Các thay đổi Business Rule thông thường không yêu cầu Architecture Review.**

---

# **8\. Architecture Decision Record (ADR)**

**Mọi thay đổi kiến trúc quan trọng SHALL được ghi nhận bằng ADR.**

**Một ADR tối thiểu bao gồm:**

* **Decision.**  
* **Context.**  
* **Alternatives.**  
* **Consequences.**  
* **Status.**  
* **Date.**

**ADR tạo lịch sử tiến hóa của kiến trúc.**

---

# **9\. Exception Management**

**Trong một số trường hợp đặc biệt có thể cần ngoại lệ.**

**Ví dụ:**

* **Migration tạm thời.**  
* **Legacy Compatibility.**  
* **Third-party Integration.**

**Mọi ngoại lệ SHALL:**

* **Có phạm vi rõ ràng.**  
* **Có thời hạn.**  
* **Có ADR.**  
* **Có kế hoạch loại bỏ.**

**Không được tạo ngoại lệ vĩnh viễn nếu không có lý do đặc biệt.**

---

# **10\. Layer Stability Principle**

**Mức độ ổn định của các Layer:**

```
Business Layer
██████████████
(thay đổi nhiều)

Ledger Layer
███████
(thay đổi vừa)

Infrastructure
███
(thay đổi ít)

Database Core
██
(rất ổn định)
```

**Infrastructure càng ổn định thì Business càng dễ mở rộng.**

---

# **11\. Capability Evolution Rule**

**Infrastructure chỉ được mở rộng khi xuất hiện:**

**Infrastructure Capability mới.**

**Ví dụ:**

* **Distributed Transaction Support**  
* **Optimistic Locking**  
* **Outbox Pattern**  
* **Event Store**  
* **Retry Framework**  
* **Multi-region Routing**

**Không mở rộng Infrastructure vì:**

* **Approval mới.**  
* **Donation mới.**  
* **Onboarding mới.**  
* **Branch Workflow mới.**

**Đó là Business Process.**

---

# **12\. Layer Ownership Governance**

**Ownership của từng Layer phải luôn được duy trì.**

| Layer | Owns |
| ----- | ----- |
| **Business** | **Workflow, Business Rule** |
| **Ledger** | **History, Metadata Contract** |
| **Infrastructure** | **Persistence Capability** |
| **Database** | **Storage** |

**Không được chuyển Ownership giữa các Layer nếu chưa có Architecture Review.**

---

# **13\. Architectural Metrics**

**Trong Technical Audit, nên theo dõi các chỉ số sau:**

### **Layer Compliance**

* **Tỷ lệ module tuân thủ Layering Doctrine.**

### **Transaction Compliance**

* **Tỷ lệ Business Process sử dụng `withTransaction()`.**

### **Ledger Compliance**

* **Tỷ lệ Business Event đi qua Business Logger.**

### **Correlation Compliance**

* **Tỷ lệ Business Process có `correlation_id` xuyên suốt.**

### **Schema Compliance**

* **Tỷ lệ Metadata đi qua Schema Contract.**

**Những chỉ số này phản ánh "sức khỏe kiến trúc" của hệ thống.**

---

# **14\. Continuous Refactoring**

**Refactoring được khuyến khích khi:**

* **Giảm Layer Bleeding.**  
* **Loại bỏ Duplicate Logic.**  
* **Chuẩn hóa Schema.**  
* **Tăng khả năng tái sử dụng.**  
* **Cải thiện khả năng kiểm thử.**

**Không refactor chỉ để thay đổi cấu trúc thư mục hoặc đổi tên thành phần mà không mang lại lợi ích kiến trúc rõ ràng.**

---

# **15\. Legacy Integration**

**Khi tích hợp mã nguồn cũ:**

1. **Đánh giá mức độ vi phạm Doctrine.**  
2. **Ưu tiên loại bỏ `new PrismaClient()`.**  
3. **Chuẩn hóa Transaction.**  
4. **Chuẩn hóa Ledger.**  
5. **Chuẩn hóa Metadata.**  
6. **Chuẩn hóa Correlation.**

**Không bắt buộc viết lại toàn bộ hệ thống ngay lập tức.**

**Áp dụng chiến lược Incremental Modernization.**

---

# **16\. Governance During Phase 6B**

**Trong Phase 6B, Architecture Governance tập trung vào bốn nhiệm vụ:**

* **Review toàn bộ Backend.**  
* **Loại bỏ vi phạm Prisma Doctrine.**  
* **Chuẩn hóa Three Ledger.**  
* **Chuẩn hóa Layer Boundary.**

**Đây là tiêu chí hoàn thành Phase 6B.**

---

# **17\. Governance During Future Phases**

**Các Phase sau (ví dụ Phase 7, Phase 8...) vẫn sử dụng cùng Governance Model.**

**Điều thay đổi là:**

* **Business Process tăng.**  
* **Module tăng.**  
* **Capability có thể tăng.**

**Layering Doctrine vẫn giữ nguyên.**

---

# **18\. Architecture Compliance Checklist**

**Một module đạt Architecture Governance Compliance khi:**

**✓ Tuân thủ Layer Model.**

**✓ Tuân thủ Responsibility Matrix.**

**✓ Tuân thủ Dependency Rules.**

**✓ Tuân thủ Prisma Doctrine.**

**✓ Tuân thủ Three Ledger Doctrine.**

**✓ Tuân thủ Schema Contract.**

**✓ Không có Architectural Anti-Pattern.**

**✓ Không có Layer Bleeding.**

**✓ Không cần ngoại lệ chưa được phê duyệt.**

---

# **19\. Governance Principles**

**EGAL Architecture Governance dựa trên các nguyên tắc sau:**

1. **Stability over Convenience — Ưu tiên sự ổn định hơn giải pháp tiện lợi trước mắt.**  
2. **Explicit over Implicit — Quyết định kiến trúc phải rõ ràng và được ghi nhận.**  
3. **Single Ownership — Mỗi trách nhiệm chỉ có một chủ sở hữu.**  
4. **Incremental Evolution — Tiến hóa từng bước, tránh thay đổi đột ngột.**  
5. **Backward Compatibility — Hạn chế phá vỡ khả năng tương thích khi mở rộng.**

---

# **20\. Final Conformance Statement**

**Layering Doctrine là một trong những Architecture Doctrine nền tảng của EGAL.**

**Mọi thành phần của Backend EGAL SHALL:**

* **Tuân thủ Layer Model.**  
* **Tuân thủ Responsibility Matrix.**  
* **Tuân thủ Dependency Rules.**  
* **Sử dụng Prisma Infrastructure Layer.**  
* **Ghi nhận dữ liệu thông qua Three Ledger.**  
* **Chuẩn hóa dữ liệu bằng Schema Contract.**  
* **Được phát triển và duy trì dưới Architecture Governance.**

**Layering Doctrine cùng với:**

* **Prisma Doctrine**  
* **Three Ledger Doctrine**  
* **Snapshot Doctrine**  
* **Correlation Doctrine**  
* **Notification Doctrine**  
* **Metadata Doctrine**

**tạo thành kiến trúc nền tảng (Foundational Architecture) của EGAL-25.x và là cơ sở cho toàn bộ các giai đoạn phát triển tiếp theo.**

---

**End of PART X**

**End of Volume 02 — EGAL Layering Doctrine**

# **APPENDIX C — Layering Review Checklist**

---

# **C.1 Purpose**

**Appendix C cung cấp Layering Review Checklist chính thức của EGAL.**

**Checklist này được sử dụng cho:**

* **Pull Request Review**  
* **Code Review**  
* **Architecture Review**  
* **Technical Audit**  
* **Release Review**  
* **Phase Completion Review**

**Đây là checklist chuẩn để đánh giá một module hoặc một Business Process có tuân thủ EGAL Layering Doctrine hay không.**

---

# **C.2 Review Levels**

**Việc đánh giá được chia thành năm cấp độ:**

| Level | Scope | Required |
| ----- | ----- | ----- |
| **L1** | **Source Code** | **✓** |
| **L2** | **Layer Boundary** | **✓** |
| **L3** | **Ledger Integration** | **✓** |
| **L4** | **Infrastructure Compliance** | **✓** |
| **L5** | **Architecture Compliance** | **✓** |

**Module chỉ được coi là Fully Compliant khi đạt cả năm cấp độ.**

---

# **C.3 Level 1 — Source Code Review**

## **Project Structure**

**□ Module nằm đúng Layer.**

**□ Không đặt Business Logic trong Infrastructure.**

**□ Không đặt Infrastructure trong Business Module.**

**□ Không xuất hiện Utility không rõ trách nhiệm.**

---

## **Naming**

**□ Tên Service phản ánh đúng trách nhiệm.**

**□ Không có tên gây hiểu nhầm.**

**□ Không có Service đa nghĩa.**

---

## **Single Responsibility**

**□ Một Service chỉ thực hiện một Responsibility chính.**

**□ Không xuất hiện God Service.**

---

# **C.4 Level 2 — Layer Boundary Review**

## **Business Layer**

**Business Layer:**

**□ Không gọi Prisma Delegate.**

**□ Không biết Database.**

**□ Không biết SQL.**

**□ Không tự tạo Transaction.**

**□ Không tự tạo Execution Context.**

---

## **Ledger Layer**

**Ledger:**

**□ Không quyết định Workflow.**

**□ Không quyết định Approval.**

**□ Không quyết định Merge.**

**□ Chỉ chuẩn hóa dữ liệu.**

---

## **Infrastructure**

**Infrastructure:**

**□ Không biết Business Rule.**

**□ Không biết Workflow.**

**□ Chỉ cung cấp Capability.**

---

# **C.5 Dependency Review**

**Dependency chỉ đi:**

```
Business

↓

Ledger

↓

Infrastructure

↓

Database
```

**Reviewer xác nhận:**

**□ Không có Dependency ngược.**

**□ Không có Circular Dependency.**

**□ Không có Layer Bleeding.**

---

# **C.6 Transaction Review**

**Transaction phải sử dụng:**

```javascript
withTransaction(contextInput, callback)
```

**Reviewer xác nhận:**

**□ Không dùng `prisma.$transaction()` trong Business Service.**

**□ Không có Nested Transaction không cần thiết.**

**□ Một Business Process chỉ có một Transaction Root.**

**□ Callback nhận `(tx, context)`.**

---

# **C.7 Prisma Doctrine Review**

**Reviewer kiểm tra:**

**□ Chỉ có một Prisma Singleton.**

**□ Không có `new PrismaClient()`.**

**□ Không tạo PrismaClient trong Repository.**

**□ Không tạo PrismaClient trong Service.**

**□ Infrastructure là nơi duy nhất truy cập Prisma Client.**

---

# **C.8 Execution Context Review**

**Reviewer xác nhận:**

**□ Context được tạo đúng một lần.**

**□ Context được truyền xuyên suốt.**

**□ Không tạo Context mới giữa Transaction.**

**□ Có:**

* **tenant\_id**  
* **user\_id**  
* **correlation\_id**  
* **request\_id**

---

# **C.9 Business Process Ledger Review**

**Reviewer kiểm tra:**

**□ Business Event được ghi qua Business Logger.**

**□ Có Schema Contract.**

**□ Có Snapshot.**

**□ Có Correlation.**

**□ Không insert trực tiếp vào:**

```
business_process_logs
```

---

# **C.10 Audit Review**

**Reviewer xác nhận:**

**□ Audit đi qua Audit Logger.**

**□ Có Before/After (nếu phù hợp).**

**□ Có Actor.**

**□ Có Correlation.**

**□ Không insert trực tiếp vào:**

```
audit_logs
```

---

# **C.11 Communication Ledger Review**

**Reviewer xác nhận:**

**□ Notification đi qua Notification Builder.**

**□ Notification đi qua Notification Service.**

**□ Có Metadata Schema.**

**□ Có Correlation.**

**□ Không insert trực tiếp:**

```
notifications
```

---

# **C.12 Schema Contract Review**

**Reviewer kiểm tra:**

**□ Có Validation.**

**□ Có Sanitization.**

**□ Không có Metadata tự do.**

**□ Không có Unknown Property.**

**□ Không phụ thuộc Business Layer.**

---

# **C.13 Snapshot Review**

**Business Process Log SHALL chứa:**

**□ metadata.context**

**□ metadata.payload**

**Snapshot phải đủ để tái hiện lịch sử.**

**Reviewer xác nhận:**

**□ Không cần JOIN realtime để hiểu Business Event.**

---

# **C.14 Correlation Review**

**Một Business Process SHALL chỉ có:**

```
correlation_id
```

**Reviewer kiểm tra:**

**□ Business Process Log dùng cùng Correlation.**

**□ Audit dùng cùng Correlation.**

**□ Notification dùng cùng Correlation.**

**□ Không sinh Correlation mới giữa chừng.**

---

# **C.15 Anti-Pattern Review**

**Reviewer xác nhận không tồn tại:**

**□ Business gọi Prisma Delegate.**

**□ Business ghi Ledger trực tiếp.**

**□ Ledger chứa Workflow.**

**□ Infrastructure chứa Business Rule.**

**□ Metadata tự do.**

**□ Layer Bleeding.**

**□ Circular Dependency.**

**□ God Service.**

**□ God Infrastructure.**

---

# **C.16 Infrastructure Capability Review**

**Reviewer xác nhận Infrastructure chỉ mở rộng khi xuất hiện:**

**□ Infrastructure Capability mới.**

**Không mở rộng vì:**

**□ Business Process mới.**

**□ Approval mới.**

**□ Donation mới.**

**□ Branch Workflow mới.**

---

# **C.17 Performance Review**

**Reviewer đánh giá:**

**□ Không có Transaction quá dài.**

**□ Không query dư thừa trong Transaction.**

**□ Không giữ Transaction khi thực hiện I/O ngoài Database.**

**□ Notification Delivery bất đồng bộ khi phù hợp.**

**□ Snapshot có kích thước hợp lý.**

---

# **C.18 Security Review**

**Reviewer xác nhận:**

**□ Tenant Scope được áp dụng.**

**□ Không rò rỉ dữ liệu giữa Tenant.**

**□ Context không bị giả mạo.**

**□ Metadata không chứa dữ liệu nhạy cảm ngoài chủ đích.**

**□ Audit không làm mất khả năng truy vết.**

---

# **C.19 Maintainability Review**

**Reviewer xác nhận:**

**□ Module dễ đọc.**

**□ Layer rõ ràng.**

**□ Không duplicate logic.**

**□ Không duplicate Schema.**

**□ Không duplicate Transaction Pattern.**

**□ Infrastructure Capability được tái sử dụng.**

---

# **C.20 Final Compliance Matrix**

| Area | Status |
| ----- | ----- |
| **Layer Model** | **□ Pass / □ Fail** |
| **Responsibility Matrix** | **□ Pass / □ Fail** |
| **Dependency Rules** | **□ Pass / □ Fail** |
| **Prisma Doctrine** | **□ Pass / □ Fail** |
| **Transaction Doctrine** | **□ Pass / □ Fail** |
| **Execution Context** | **□ Pass / □ Fail** |
| **Business Process Ledger** | **□ Pass / □ Fail** |
| **Audit Ledger** | **□ Pass / □ Fail** |
| **Communication Ledger** | **□ Pass / □ Fail** |
| **Schema Contract** | **□ Pass / □ Fail** |
| **Snapshot Doctrine** | **□ Pass / □ Fail** |
| **Correlation Doctrine** | **□ Pass / □ Fail** |
| **Anti-Pattern Review** | **□ Pass / □ Fail** |
| **Security Review** | **□ Pass / □ Fail** |
| **Performance Review** | **□ Pass / □ Fail** |
| **Maintainability Review** | **□ Pass / □ Fail** |

**Module chỉ được đánh giá Architecture Compliant khi toàn bộ các mục đều đạt Pass hoặc các ngoại lệ đã được ghi nhận bằng Architecture Decision Record (ADR).**

---

# **C.21 Recommended Review Order**

**Để tăng hiệu quả review, EGAL khuyến nghị thứ tự sau:**

1. **Layer Boundary**  
2. **Dependency Rules**  
3. **Prisma Doctrine**  
4. **Transaction Pattern**  
5. **Execution Context**  
6. **Three Ledger Integration**  
7. **Schema Contract**  
8. **Snapshot & Correlation**  
9. **Anti-Pattern Detection**  
10. **Performance & Security**  
11. **Maintainability**  
12. **Final Compliance Matrix**

**Thứ tự này giúp phát hiện các sai lệch kiến trúc từ gốc trước khi đi vào chi tiết implementation.**

---

# **C.22 Conformance Statement**

**Layering Review Checklist là tiêu chuẩn kiểm tra chính thức của EGAL Layering Doctrine.**

**Mọi Pull Request, Code Review, Technical Audit và Architecture Review SHOULD sử dụng Checklist này như tài liệu tham chiếu mặc định.**

**Checklist này cùng với các Doctrine của EGAL tạo thành Architecture Compliance Framework cho EGAL-25.x.**

---

**End of APPENDIX C**

**End of Volume 02 — EGAL Layering Doctrine**

